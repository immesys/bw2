package plaintext

import (
	"bufio"
	"errors"
	"fmt"
	"strconv"
	"strings"

	"github.com/immesys/bw2/objects"
)

type Header struct {
	Content []byte
	Key     string
	Length  string
	ILength int
}
type ROEntry struct {
	RO     objects.RoutingObject
	RONum  string
	Length string
}
type POEntry struct {
	PO     objects.PayloadObject
	IntNum string
	DotNum string
	Length string
}
type Frame struct {
	SeqNo   int
	Headers []Header
	Cmd     string
	ROs     []ROEntry
	POs     []POEntry
	Length  int
}

func CreateFrame(cmd string, seqno int) *Frame {
	return &Frame{Cmd: cmd,
		SeqNo:   seqno,
		Headers: make([]Header, 0),
		POs:     make([]POEntry, 0),
		ROs:     make([]ROEntry, 0),
		Length:  4, //"end\n"
	}
}
func (f *Frame) AddHeader(k string, v []byte) {
	h := Header{Key: k, Content: v, Length: string(len(v))}
	f.Headers = append(f.Headers, h)
	//6 = 3 for "kv " 1 for space, 1 for newline before content and 1 for newline after
	f.Length += len(k) + len(h.Length) + 6
}

func (f *Frame) AddRoutingObject(ro objects.RoutingObject) {
	re := ROEntry{
		RO:     ro,
		RONum:  string(ro.GetRONum()),
		Length: string(len(ro.GetContent())),
	}
	f.ROs = append(f.ROs, re)
	//3 for "ro ", 2 for newlines before and after 1 for space
	f.Length += 3 + len(re.RONum) + 1 + len(re.Length) + 1 + len(ro.GetContent()) + 1
}
func (f *Frame) AddPayloadObject(po objects.PayloadObject) {
	pe := POEntry{
		PO:     po,
		IntNum: string(po.GetPONum()),
		DotNum: objects.PONumDotForm(po.GetPONum()),
		Length: string(len(po.GetContent())),
	}
	f.POs = append(f.POs, pe)
	//3 for "po ",                  colon                space                newline                   newline
	f.Length += 3 + len(pe.IntNum) + 1 + len(pe.DotNum) + 1 + len(pe.Length) + 1 + len(po.GetContent()) + 1
}

func (f *Frame) WriteToStream(s bufio.Writer) {
	s.WriteString(fmt.Sprintf("%4s %010d %010d\n", f.Cmd, f.Length, f.SeqNo))
	for _, v := range f.Headers {
		s.WriteString(fmt.Sprintf("kv %s %s\n", v.Key, v.Length))
		s.Write(v.Content)
		s.WriteRune('\n')
	}
	for _, re := range f.ROs {
		s.WriteString(fmt.Sprintf("ro %s %s\n",
			re.RONum, re.Length))
		s.Write(re.RO.GetContent())
		s.WriteRune('\n')
	}
	for _, pe := range f.POs {
		s.WriteString(fmt.Sprintf("po %s:%s %s\n",
			pe.IntNum, pe.DotNum, pe.Length))
		s.Write(pe.PO.GetContent())
		s.WriteRune('\n')
	}
	s.WriteString("end\n")
	s.Flush()
}

func ReadExactly(s bufio.Reader, to []byte) error {
	n := 0
	for n < len(to) {
		rd, err := s.Read(to[n:])
		if err != nil {
			return err
		}
		n += rd
	}
	return nil
}
func LoadFrameFromStream(s bufio.Reader) (f *Frame, e error) {
	defer func() {
		if r := recover(); r != nil {
			f = nil
			fmt.Println(r)
			e = errors.New("Malformed frame")
			return
		}
	}()
	hdr := make([]byte, 27)
	if e := ReadExactly(s, hdr); e != nil {
		return nil, e
	}
	//Remember header is
	//    4          15         26
	//CMMD 10DIGITLEN 10DIGITSEQ\n
	f = &Frame{}
	f.Cmd = string(hdr[0:4])
	cx, err := strconv.ParseUint(string(hdr[5:15]), 10, 32)
	if err != nil {
		return nil, err
	}
	f.Length = int(cx)
	cx, err = strconv.ParseUint(string(hdr[16:26]), 10, 32)
	if err != nil {
		return nil, err
	}
	f.SeqNo = int(cx)
	for {
		l, err := s.ReadBytes('\n')
		if err != nil {
			return nil, err
		}
		tok := strings.Split(string(l), " ")
		if len(tok) != 3 {
			return nil, errors.New("Bad line")
		}
		switch tok[0] {
		case "kv":
			h := Header{}
			h.Key = tok[1]
			cx, err := strconv.ParseUint(tok[2], 10, 32)
			if err != nil {
				return nil, err
			}
			h.ILength = int(cx)
			body := make([]byte, h.ILength)
			if e := ReadExactly(s, body); e != nil {
				return nil, e
			}
			//Strip newline
			if _, e := s.ReadByte(); e != nil {
				return nil, e
			}
			h.Content = body
		case "ro":
			cx, err := strconv.ParseUint(tok[1], 10, 32)
			if err != nil {
				return nil, err
			}
			ronum := int(cx)
			cx, err = strconv.ParseUint(tok[2], 10, 32)
			if err != nil {
				return nil, err
			}
			length := int(cx)
			body := make([]byte, length)
			if e := ReadExactly(s, body); e != nil {
				return nil, e
			}
			//Strip newline
			if _, e := s.ReadByte(); e != nil {
				return nil, e
			}
			ro, err := objects.LoadRoutingObject(ronum, body)
			if err != nil {
				return nil, e
			}
			f.ROs = append(f.ROs, ROEntry{ro, string(ronum), string(length)})
		case "po":
			ponums := strings.Split(tok[1], ":")
			var ponum int
			if len(ponums[1]) != 0 {
				cx, err := strconv.ParseUint(ponums[1], 10, 32)
				if err != nil {
					return nil, err
				}
				ponum = int(cx)
			} else {
				cx, err := objects.PONumFromDotForm(ponums[0])
				if err != nil {
					return nil, err
				}
				ponum = cx
			}
			cx, err = strconv.ParseUint(tok[2], 10, 32)
			if err != nil {
				return nil, err
			}
			length := int(cx)
			body := make([]byte, length)
			if e := ReadExactly(s, body); e != nil {
				return nil, e
			}
			//Strip newline
			if _, e := s.ReadByte(); e != nil {
				return nil, e
			}
			po, err := objects.LoadPayloadObject(ponum, body)
			if err != nil {
				return nil, err
			}
			poe := POEntry{
				PO:     po,
				IntNum: string(ponum),
				DotNum: objects.PONumDotForm(ponum),
				Length: string(length),
			}
			f.POs = append(f.POs, poe)
		}
	}
}

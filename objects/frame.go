// This file is part of BOSSWAVE.
//
// BOSSWAVE is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// BOSSWAVE is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with BOSSWAVE.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright © 2015 Michael Andersen <m.andersen@cs.berkeley.edu>

package objects

import (
	"bufio"
	"errors"
	"fmt"
	"strconv"
	"strings"

	"github.com/immesys/bw2/util/bwe"
)

const (
	CmdHello        = "helo"
	CmdPublish      = "publ"
	CmdSubscribe    = "subs"
	CmdPersist      = "pers"
	CmdList         = "list"
	CmdQuery        = "quer"
	CmdTapSubscribe = "tsub"
	CmdTapQuery     = "tque"

	CmdMakeDot      = "makd"
	CmdMakeEntity   = "make"
	CmdMakeChain    = "makc"
	CmdBuildChain   = "bldc"
	CmdAddPrefDot   = "adpd"
	CmdAddPrefChain = "adpc"
	CmdDelPrefDot   = "dlpd"
	CmdDelPrefChain = "dlpc"
	CmdSetEntity    = "sete"

	//New for 2.1.x
	CmdPutDot                = "putd"
	CmdPutEntity             = "pute"
	CmdPutChain              = "putc"
	CmdEntityBalances        = "ebal"
	CmdAddressBalance        = "abal"
	CmdBCInteractionParams   = "bcip"
	CmdTransfer              = "xfer"
	CmdMakeShortAlias        = "mksa"
	CmdMakeLongAlias         = "mkla"
	CmdResolveAlias          = "resa"
	CmdNewDROffer            = "ndro"
	CmdAcceptDROffer         = "adro"
	CmdResolveRegistryObject = "rsro"
	CmdUpdateSRVRecord       = "usrv"
	CmdListDROffers          = "ldro"
	CmdMakeView              = "mkvw"
	CmdSubscribeView         = "vsub"
	CmdPublishView           = "vpub"
	CmdListView              = "vlst"
	CmdUnsubscribe           = "usub"
	CmdRevokeDROffer         = "rdro"
	CmdRevokeDRAccept        = "rdra"
	CmdRevokeRO              = "revk"
	CmdPutRevocation         = "prvk"
	CmdFindDots              = "fdot"

	CmdResponse = "resp"
	CmdResult   = "rslt"
)

type Header struct {
	Content []byte
	Key     string
	Length  string
	ILength int
}
type ROEntry struct {
	RO     RoutingObject
	RONum  string
	Length string
}
type POEntry struct {
	PO     PayloadObject
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
func (f *Frame) AddHeaderB(k string, v []byte) {
	h := Header{Key: k, Content: v, Length: strconv.Itoa(len(v))}
	f.Headers = append(f.Headers, h)
	//6 = 3 for "kv " 1 for space, 1 for newline before content and 1 for newline after
	f.Length += len(k) + len(h.Length) + 6 + len(v)
}
func (f *Frame) AddHeader(k string, v string) {
	f.AddHeaderB(k, []byte(v))
}
func (f *Frame) GetAllPOs() []PayloadObject {
	rv := make([]PayloadObject, len(f.POs))
	for i, v := range f.POs {
		rv[i] = v.PO
	}
	return rv
}
func (f *Frame) GetAllROs() []RoutingObject {
	rv := make([]RoutingObject, len(f.ROs))
	for i, v := range f.ROs {
		rv[i] = v.RO
	}
	return rv
}
func (f *Frame) GetFirstHeaderB(k string) ([]byte, bool) {
	for _, h := range f.Headers {
		if h.Key == k {
			return h.Content, true
		}
	}
	return nil, false
}
func (f *Frame) GetFirstHeader(k string) (string, bool) {
	r, ok := f.GetFirstHeaderB(k)
	return string(r), ok
}
func (f *Frame) ParseFirstHeaderAsBool(k string, def bool) (bool, bool, *string) {
	v, ok := f.GetFirstHeader(k)
	if !ok {
		return def, false, nil
	}
	cx, e := strconv.ParseBool(v)
	if e != nil {
		msg := fmt.Sprintf("could not parse %s kv as boolean", k)
		return def, false, &msg
	}
	return cx, true, nil
}
func (f *Frame) ParseFirstHeaderAsInt(k string, def int) (int, bool, *string) {
	v, ok := f.GetFirstHeader(k)
	if !ok {
		return def, false, nil
	}
	cx, e := strconv.ParseInt(v, 10, 64)
	if e != nil {
		msg := fmt.Sprintf("could not parse %s kv as boolean", k)
		return def, false, &msg
	}
	return int(cx), true, nil
}
func (f *Frame) GetAllHeaders(k string) []string {
	var rv []string
	for _, h := range f.Headers {
		if h.Key == k {
			rv = append(rv, string(h.Content))
		}
	}
	return rv
}
func (f *Frame) GetAllHeadersB(k string) [][]byte {
	var rv [][]byte
	for _, h := range f.Headers {
		if h.Key == k {
			rv = append(rv, h.Content)
		}
	}
	return rv
}
func (f *Frame) AddRoutingObject(ro RoutingObject) {
	re := ROEntry{
		RO:     ro,
		RONum:  strconv.Itoa(ro.GetRONum()),
		Length: strconv.Itoa(len(ro.GetContent())),
	}
	f.ROs = append(f.ROs, re)
	//3 for "ro ", 2 for newlines before and after 1 for space
	f.Length += 3 + len(re.RONum) + 1 + len(re.Length) + 1 + len(ro.GetContent()) + 1
}
func (f *Frame) AddPayloadObject(po PayloadObject) {
	pe := POEntry{
		PO:     po,
		IntNum: strconv.Itoa(po.GetPONum()),
		DotNum: PONumDotForm(po.GetPONum()),
		Length: strconv.Itoa(len(po.GetContent())),
	}
	f.POs = append(f.POs, pe)
	//3 for "po ",                  colon                space                newline                   newline
	f.Length += 3 + len(pe.IntNum) + 1 + len(pe.DotNum) + 1 + len(pe.Length) + 1 + len(po.GetContent()) + 1
}

func (f *Frame) WriteToStream(s *bufio.Writer) {
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
			pe.DotNum, pe.IntNum, pe.Length))
		s.Write(pe.PO.GetContent())
		s.WriteRune('\n')
	}
	s.WriteString("end\n")
	s.Flush()
}

func ReadExactly(s *bufio.Reader, to []byte) error {
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
func LoadFrameFromStream(s *bufio.Reader) (f *Frame, e error) {
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
		if string(l) == "end\n" {
			return f, nil
		}
		tok := strings.Split(string(l), " ")
		if len(tok) != 3 {
			return nil, errors.New("Bad line")
		}
		//Strip newline
		tok[2] = tok[2][:len(tok[2])-1]
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
			f.Headers = append(f.Headers, h)
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
			ro, err := LoadRoutingObject(ronum, body)
			if err != nil {
				return nil, e
			}
			f.ROs = append(f.ROs, ROEntry{ro, strconv.Itoa(ronum), strconv.Itoa(length)})
		case "po":
			ponums := strings.Split(tok[1], ":")
			var dponum int
			var iponum int
			var ponum int
			haveD := false
			haveI := false
			if len(ponums[1]) != 0 {
				cx, err := strconv.ParseUint(ponums[1], 10, 32)
				if err != nil {
					return nil, err
				}
				iponum = int(cx)
				ponum = iponum
				haveI = true
			}
			if len(ponums[0]) != 0 {
				cx, err := PONumFromDotForm(ponums[0])
				if err != nil {
					return nil, err
				}
				dponum = cx
				ponum = dponum
				haveD = true
			}
			if haveI && haveD && iponum != dponum {
				return nil, bwe.M(bwe.MalformedOOBCommand, "PONums do not match")
			}
			if !haveI && !haveD {
				return nil, bwe.M(bwe.MalformedOOBCommand, "Missing PO number")
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
			po, err := LoadPayloadObject(ponum, body)
			if err != nil {
				return nil, err
			}
			poe := POEntry{
				PO:     po,
				IntNum: strconv.Itoa(ponum),
				DotNum: PONumDotForm(ponum),
				Length: strconv.Itoa(length),
			}
			f.POs = append(f.POs, poe)
		case "end":
			return f, nil
		}
	}
}

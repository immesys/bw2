package api

import (
	"bytes"
	"crypto/tls"
	"crypto/x509"
	"encoding/binary"
	"errors"
	"io"
	"net"
	"sync"
	"sync/atomic"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/internal/crypto"
)

type PeerClient struct {
	conn    net.Conn
	txmtx   sync.Mutex
	replyCB map[uint64]func(*nativeFrame)
	seqno   uint64
}

func magicallyDetermineIPAddress(vk []byte) (string, error) {
	rawEnc := crypto.FmtKey(vk)
	rawEnc = "_" + rawEnc[:43] //Strip the last equals, we know its there and its invalid
	_, addrs, err := net.LookupSRV("", "", rawEnc+".bw2.io")
	if err != nil {
		return "", err
	}
	if len(addrs) < 1 {
		return "", errors.New("Unable to resolve VK to router")
	}
	return addrs[0].Target, nil
}
func ConnectToPeer(vk []byte) (*PeerClient, error) {
	target, err := magicallyDetermineIPAddress(vk)
	if err != nil {
		return nil, err
	}
	roots := x509.NewCertPool()
	conn, err := tls.Dial("tcp", target, &tls.Config{
		InsecureSkipVerify: true,
		RootCAs:            roots,
	})
	if err != nil {
		return nil, err
	}
	cs := conn.ConnectionState()
	if len(cs.PeerCertificates) != 1 {
		log.Criticalf("peer connection weird response")
		return nil, errors.New("Wrong certificates")
	}
	proof := make([]byte, 96)
	_, err = io.ReadFull(conn, proof)
	if err != nil {
		return nil, errors.New("failed to read proof: " + err.Error())
	}
	proofOK := crypto.VerifyBlob(proof[:32], proof[32:], cs.PeerCertificates[0].Signature)
	if !proofOK {
		return nil, errors.New("peer verification failed")
	}
	if !bytes.Equal(proof[:32], vk) {
		return nil, errors.New("peer has a different VK")
	}

	rv := PeerClient{
		conn:    conn,
		replyCB: make(map[uint64]func(*nativeFrame)),
	}
	return &rv, nil
}

func (pc *PeerClient) getSeqno() uint64 {
	return atomic.AddUint64(&pc.seqno, 1)
}
func (pc *PeerClient) removeCB(seqno uint64) {
	pc.txmtx.Lock()
	delete(pc.replyCB, seqno)
	pc.txmtx.Unlock()
}
func (pc *PeerClient) transact(f *nativeFrame, onRX func(f *nativeFrame)) {
	tmphdr := make([]byte, 17)
	binary.LittleEndian.PutUint64(tmphdr, uint64(len(f.body)))
	binary.LittleEndian.PutUint64(tmphdr[8:], f.seqno)
	tmphdr[16] = byte(f.cmd)
	pc.txmtx.Lock()
	pc.replyCB[f.seqno] = onRX
	defer pc.txmtx.Unlock()
	_, err := pc.conn.Write(tmphdr)
	if err != nil {
		log.Info("peer write error: ", err.Error())
		pc.conn.Close()
		return
	}
	_, err = pc.conn.Write(f.body)
	if err != nil {
		log.Info("peer write error: ", err.Error())
		pc.conn.Close()
	}
}
func (pc *PeerClient) PublishPersist(m *core.Message, actionCB func(code int, msg string)) {
	nf := nativeFrame{
		cmd:   nCmdMessage,
		body:  m.Encoded,
		seqno: pc.getSeqno(),
	}
	pc.transact(&nf, func(f *nativeFrame) {
		defer pc.removeCB(nf.seqno)
		if len(f.body) < 2 {
			actionCB(core.BWStatusPeerError, "short response frame")
			return
		}
		code := int(binary.LittleEndian.Uint16(f.body))
		msg := string(f.body[2:])
		actionCB(code, msg)
		return
	})
}

func (pc *PeerClient) Subscribe(m *core.Message,
	actionCB func(status int, isNew bool, id core.UniqueMessageID, msg string),
	messageCB func(m *core.Message)) {
	nf := nativeFrame{
		cmd:   nCmdMessage,
		body:  m.Encoded,
		seqno: pc.getSeqno(),
	}
	pc.transact(&nf, func(f *nativeFrame) {
		switch f.cmd {
		case nCmdRStatus:
			if len(f.body) < 2 {
				actionCB(core.BWStatusPeerError, false, core.UniqueMessageID{}, "short response frame")
				return
			}
			code := int(binary.LittleEndian.Uint16(f.body))
			if code != core.BWStatusOkay {
				actionCB(code, false, core.UniqueMessageID{}, string(f.body[2:]))
			} else {
				mid := binary.LittleEndian.Uint64(f.body[2:])
				sig := binary.LittleEndian.Uint64(f.body[10:])
				umid := core.UniqueMessageID{Mid: mid, Sig: sig}
				isnew := m.UMid == umid
				actionCB(core.BWStatusOkay, isnew, umid, "")
			}
			return
		case nCmdResult:
			nm, err := core.LoadMessage(f.body)
			if err != nil {
				log.Info("dropping incoming subscription result (malformed message)")
				return
			}
			s := nm.Verify()
			if s.Code != core.BWStatusOkay {
				log.Infof("dropping incoming subscription result on uri=%s (failed local validation)", m.Topic)
				return
			}
			messageCB(nm)
			return
		case nCmdEnd:
			//This will be signalled when we unsubscribe
			pc.removeCB(nf.seqno)
		}
	})
}

func (pc *PeerClient) List(m *core.Message,
	actionCB func(code int, msg string),
	resultCB func(uri string, ok bool)) {
	nf := nativeFrame{
		cmd:   nCmdMessage,
		body:  m.Encoded,
		seqno: pc.getSeqno(),
	}
	pc.transact(&nf, func(f *nativeFrame) {
		switch f.cmd {
		case nCmdRStatus:
			if len(f.body) < 2 {
				actionCB(core.BWStatusPeerError, "short response frame")
				return
			}
			code := int(binary.LittleEndian.Uint16(f.body))
			actionCB(code, string(f.body[2:]))
			return
		case nCmdResult:
			resultCB(string(f.body), true)
			return
		case nCmdEnd:
			//This will be signalled when we unsubscribe
			resultCB("", false)
			pc.removeCB(nf.seqno)
		}
	})
}

func (pc *PeerClient) Query(m *core.Message,
	actionCB func(code int, msg string),
	resultCB func(m *core.Message)) {
	nf := nativeFrame{
		cmd:   nCmdMessage,
		body:  m.Encoded,
		seqno: pc.getSeqno(),
	}
	pc.transact(&nf, func(f *nativeFrame) {
		switch f.cmd {
		case nCmdRStatus:
			if len(f.body) < 2 {
				actionCB(core.BWStatusPeerError, "short response frame")
				return
			}
			code := int(binary.LittleEndian.Uint16(f.body))
			actionCB(code, string(f.body[2:]))
		case nCmdResult:
			nm, err := core.LoadMessage(f.body)
			if err != nil {
				log.Info("dropping incoming query result (malformed message)")
				return
			}
			s := nm.Verify()
			if s.Code != core.BWStatusOkay {
				log.Infof("dropping incoming query result on uri=%s (failed local validation)", m.Topic)
				return
			}
			resultCB(nm)
		case nCmdEnd:
			resultCB(nil)
			//This will be signalled when we unsubscribe
			pc.removeCB(nf.seqno)
		}
	})
}

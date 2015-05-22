package core

import (
	"encoding/base64"
	"encoding/binary"
	"fmt"
	"time"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/objects"
)

const (
	TypePublish   = 0x01
	TypePersist   = 0x02
	TypeSubscribe = 0x03
	TypeTap       = 0x04
	TypeQuery     = 0x05
	TypeTapQuery  = 0x06
	TypeLS        = 0x07
)

type sigState int8

const (
	sigUnchecked = iota
	sigValid
	sigInvalid
)

// Message is the primary Bosswave message type that is passed all the way through
type Message struct {

	//Packed
	Encoded []byte

	//Primary data
	Type           uint8
	MessageID      uint16
	Valid          bool
	Consumers      int
	MVK            []byte
	TopicSuffix    string
	Signature      []byte
	RoutingObjects []objects.RoutingObject
	PayloadObjects []objects.PayloadObject
	SigCoverEnd    int
	OriginVK       *[]byte

	//Derived data
	Topic      string
	RXTime     time.Time
	ExpireTime time.Time
	sigStatus  sigState
}

func Load(b []byte, originVK *[]byte) (m *Message, err error) {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("Bad message: ", r)
			m.Valid = false
			err = r.(error)
		}
	}()
	m = &Message{Encoded: b}

	//Common header
	idx := 0
	m.Type = b[idx]
	m.MessageID = binary.LittleEndian.Uint16(b[idx+1:])
	idx += 2
	m.MVK = b[idx : idx+32]
	idx += 32
	suffixlen := binary.LittleEndian.Uint16(b[idx:])
	m.TopicSuffix = string(b[idx+2 : idx+2+int(suffixlen)])
	idx += int(suffixlen) + 2
	m.Topic = base64.URLEncoding.EncodeToString(m.MVK) + "/" + m.TopicSuffix

	//Read type specific block
	switch m.Type {
	case TypePublish, TypePersist:
		//One additional byte denoting consumer limit
		m.Consumers = int(b[idx])
		idx++
	}

	//Read routing objects
	for b[idx] != 0 {
		RONum := int(b[idx])
		ln := int(binary.LittleEndian.Uint16(b[idx+1:]))
		idx += 3
		ro, err := objects.LoadRoutingObject(RONum, b[idx:idx+ln])
		if err != nil {
			log.Errorf("Got bad routing object: 0x%02x, error: %s", RONum, err)
			idx += ln
			continue
		}
		m.RoutingObjects = append(m.RoutingObjects, ro)
		idx += ln
	}
	idx++ //Skip final zero

	//Read payload objects
	for {
		PONum := int(binary.LittleEndian.Uint32(b[idx:]))
		idx += 4
		if PONum == 0 {
			break
		}
		ln := int(binary.LittleEndian.Uint32(b[idx:]))
		idx += 4
		po, err := objects.LoadPayloadObject(PONum, b[idx:idx+ln])
		if err != nil {
			log.Errorf("Got bad payload object: %s, error: %s", objects.PONumDotForm(PONum), err)
		}
		m.PayloadObjects = append(m.PayloadObjects, po)
		idx += ln
	}

	//This is where the signature stops
	m.SigCoverEnd = idx
	m.Signature = b[idx : idx+64]

	//To verify the signature we need the OriginVK. If it is passed in
	//then we can verify the signature, otherwise we need to extract the
	//vk from the last DOT in the first access DChain
	if originVK != nil {
		m.OriginVK = originVK
	}
	return m, nil
}

func (m *Message) Verify() bool {
	if m.sigStatus == sigUnchecked {
		if crypto.VerifyBlob(*m.OriginVK, m.Signature, m.Encoded[:m.SigCoverEnd]) {
			m.sigStatus = sigValid
			m.Valid = true
		} else {
			m.sigStatus = sigInvalid
		}
	}
	return m.sigStatus == sigValid
}

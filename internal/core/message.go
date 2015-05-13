package core

import "time"

const (
	TypePublish   = 0x01
	TypeSubscribe = 0x02
	TypeTap       = 0x03
	TypeQuery     = 0x04
	TypeTapQuery  = 0x06
	TypeLS        = 0x06
)

// Message is the primary Bosswave message type that is passed all the way through
type Message struct {
	//Populated manually by TX or by Load for RX
	Type        uint8
	MessageID   uint16
	Invalid     bool
	MVK         []byte
	Topic       string
	TopicSuffix string
	Signature   []byte

	Encoded   []byte
	Persist   uint8
	Consumers int
	//Populated by Init()
	RXTime     time.Time
	ExpireTime time.Time
}

/*
func (m *Message) Load(b []byte) (err error) {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("Bad message: ", r)
			m.Invalid = true
			err = r.(error)
		}
	}()
	//Type code
	idx := 0
	func rd_common_header() {
		m.Type = b[idx]
		m.MessageID = binary.LittleEndian.Uint16(b[idx+1:])
		idx += 2
		m.MVK = b[idx : idx+32]
		idx += 32
		suffixlen := binary.LittleEndian.Uint16(b[idx:])
		m.TopicSuffix = string(b[idx+2 : idx+2+int(suffixlen)])
		idx += int(suffixlen) + 2
		m.Topic = base64.URLEncoding.EncodeString(string(m.MVK)) + "/" + m.TopicSuffix
	}
	func rd_routing_objects() {

	}
	//Load type specific block
	switch m.Type {
	case TypePublish:
		rd_common_header()
		m.Consumers = int(b[idx])
		m.Persist = b[idx+1]
		idx += 2
		rd_routing_objects()
		rd_payload_objects()
		m.Signature = b[idx:idx+32]
		rd_tag_objects()



	case TypeSubscribe:

	case TypeTap:
	case TypeQuery:
	case TypeTapQuery:
	case TypeLS:
	}
}
*/

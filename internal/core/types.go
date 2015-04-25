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

var Forever = time.Date(2050, time.January, 1, 1, 1, 1, 1, time.UTC)

// Message is the primary Bosswave message type that is passed all the way through
type Message struct {
	Type        uint8
	MVK         []byte
	TopicSuffix string
	Signature   []byte
	Payload     []byte
	Persist     uint8
	Consumers   int
	RXTime      time.Time
	ExpireTime  time.Time
}

type Dot struct {
	FromVK    []byte
	ToVK      []byte
	Signature []byte
	Params    map[string][]byte
}
type SubReq struct {
	//	Type     uint8
	DChain   []Dot
	MVK      []byte
	Topic    string
	Tap      bool
	Client   *Client
	Dispatch func(m *Message)
}

func (m *Message) Init() {
	m.RXTime = time.Now()
	switch {
	case m.Persist == 0x01:
		m.ExpireTime = Forever
	case m.Persist&0xc0 == 0x40:
		m.ExpireTime = time.Now().Add(time.Duration(m.Persist&0x3F) * time.Second)
	case m.Persist&0xc0 == 0x80:
		m.ExpireTime = time.Now().Add(time.Duration(m.Persist&0x3F) * time.Minute)
	case m.Persist&0xc0 == 0xc0:
		m.ExpireTime = time.Now().Add(time.Duration(m.Persist&0x3F) * time.Hour)
	}
}

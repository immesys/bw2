package core

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
	Type        uint8
	TopicSuffix string
	Signature   []byte
	Payload     []byte
}

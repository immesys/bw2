package bw2

import (
	"fmt"

	"github.com/immesys/bw2/internal/core"
)

// This is the main function interface for BW2. All Out Of Band providers will
// use this interface, and it is the main interface for creating GO based BW2
// applications

// BW is the primary handle for bosswave consumers
type BW struct {
	Config *core.BWConfig
	tm     *core.Terminus
}

// OpenBWContext will create a new Bosswave context and initialise the
// daemons specified in the configuration file
func OpenBWContext(config *core.BWConfig) *BW {
	if config == nil {
		config = core.LoadConfig("")
	}
	rv := &BW{Config: config, tm: core.CreateTerminus()}
	return rv
}

type BosswaveClient struct {
	bw *BW
	cl *core.Client
}

func OnChanged() {
	fmt.Println("Got changed")
}

func (bw *BW) CreateClient() *BosswaveClient {
	return &BosswaveClient{bw: bw, cl: bw.tm.CreateClient(OnChanged)}
}

func (c *BosswaveClient) Publish(topic string, message string) error {
	//Typically we would now send this to a security check
	msg := &core.Message{}
	msg.TopicSuffix = topic
	c.cl.Publish(msg)
	return nil
}

//
// func (bw *BW) MakeTopic(t string) *core.Topic {
// 	rv := &core.Topic{V: t}
// 	return rv
// }
//
// func (bw *BW) MakeMessage(t string) *core.Message {
// 	return &core.Message{}
// }
//
// type HandlerWrapper struct {
// 	target func(s string)
// }
//
// func (h HandlerWrapper) Handle(t *core.Topic, m *core.Message) {
// 	h.target("gotit")
// }
// func (bw *BW) MakeHandler(f func(string)) core.SubscriptionHandler {
// 	h := HandlerWrapper{target: f}
// 	return h
// }
func (c *BosswaveClient) Subscribe(topic string) {
	c.cl.Subscribe(topic)
}

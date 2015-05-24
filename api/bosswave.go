package api

import (
	"math/rand"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/objects"
)

//The version of BW2 this is
var BW2Version = "2.0.0 - 'Anarchy'"

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
	log.Infof("Opening context")
	if config == nil {
		config = core.LoadConfig("")
	}
	rv := &BW{Config: config, tm: core.CreateTerminus()}
	return rv
}

// BosswaveClient represents an individual client. It contains the
// handle to the terminus client that contains the message queue
type BosswaveClient struct {
	bw *BW
	cl *core.Client

	//MessageFactory stuff
	mid uint64
	us  *objects.Entity
}

// MatchTopic will check if t matches the pattern.
// TODO this is not nearly as optimal as it can be, copy
// logic from RestrictBy. In the meantime it may be faster
// to call RestrictBy.
func MatchTopic(t []string, pattern []string) bool {
	if len(t) == 0 && len(pattern) == 0 {
		return true
	}
	if len(t) == 0 || len(pattern) == 0 {
		return false
	}
	if t[0] == pattern[0] || pattern[0] == "+" {
		return MatchTopic(t[1:], pattern[1:])
	}
	if pattern[0] == "*" {
		for i := 0; i < len(t); i++ {
			if MatchTopic(t[i:], pattern[1:]) {
				return true
			}
		}
	}
	return false
}

/*
func (c *BosswaveClient) dispatch() {
	if c.irq == nil {
		//Do dispatch to the subreq's Dispatch field
		ms := c.cl.GetFront()
		for ms != nil {
			c.disch <- ms
			ms = c.cl.GetFront()
		}
	} else {
		//Delegate to client
		c.irq()
	}
}
*/

// CreateClient will create a new BosswaveClient. If the queueChanged function
// is nil, the dispatch handlers in each subscription will be invoked when
// a message appears for them. If a queueChanged function is specified, this
// behaviour is supressed, and the caller needs to work out how to dispatch
// messages when the queue has changed.
func (bw *BW) CreateClient(us *objects.Entity) *BosswaveClient {
	rv := &BosswaveClient{bw: bw, us: us, mid: uint64(rand.Int63() << 16)}
	if len(us.GetSK()) == 0 {
		return nil
	}
	rv.cl = bw.tm.CreateClient()
	return rv
}

/*
func (c *BosswaveClient) DispatchMessage(m *core.Message) *core.StatusMessage {
	//Not clear we would do this for messages arriving from OOB
	s := m.Verify()
	if !s.Ok() {
		fmt.Printf("Failed verification: %d\n", s.Code)
		return s
	}
	//Probably check for remote vs local delivery. Assume local for now
	switch m.Type {
	case core.TypePublish:
		c.cl.Publish(m)
	default:
		//Subscribes need their own channel or something.
		panic("ARGH WTF EVEN FUCK!")
	}
	return s
}
*/

/*
// Publish the given message using the permissions contained in the message
func (c *BosswaveClient) Publish(m *core.Message) *core.StatusMessage {

	//In real life we would now check if this message was destined for local
	//delivery or remote delivery. If remote, we would create the client for that
	//for now lets assume its local. Furthermore, lets pretend it needs its
	//security checked (maybe we decide to do that in future anyway)
	s := m.Verify()
	if s.Code != core.BWStatusOkay {
		return s
	}
	c.cl.Publish(m)
	return nil
}
*/
// Subscribe with the given subscription request
/*
func (c *BosswaveClient) Subscribe(m *core.Message) bool {
	n := c.cl.Subscribe(m)
	fmt.Printf("Subid: %v\n", n)
	return true
}
*/

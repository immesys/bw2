package core

import (
	"container/list"
	"sync"
	"sync/atomic"
)

// If a message enters the terminus, it has already had its signature verified,
// and it is destined for our MVK, otherwise a different part of the program
// would have handled it. Similarly, any subscribe requests entering the
// terminus have been verified, same for tap, ls etc.

type SubscriptionHandler interface {
	Handle(m *Message)
}

type Client struct {
	//MVK etc
	cid          uint32
	queueChanged func()
	mlist        *list.List
	tm           *Terminus
}
type Topic struct {
	V string
}

type Terminus struct {
	// Crude workaround
	q_lock sync.RWMutex
	//topic onto cid onto subid
	subs map[string]map[uint32]uint32
	//subid onto string, uid is got from context
	rsubs      map[uint32]string
	c_maplock  sync.RWMutex
	cmap       map[uint32]*Client
	cid_head   uint32
	subid_head uint32
}

func CreateTerminus() *Terminus {
	rv := &Terminus{}
	rv.subs = make(map[string]map[uint32]uint32)
	rv.rsubs = make(map[uint32]string)
	rv.cmap = make(map[uint32]*Client)
	return rv
}

func (tm *Terminus) CreateClient(queueChanged func()) *Client {
	cid := atomic.AddUint32(&tm.cid_head, 1)
	c := Client{cid: cid, queueChanged: queueChanged, mlist: list.New(), tm: tm}
	tm.q_lock.Lock()
	tm.cmap[cid] = &c
	tm.q_lock.Unlock()
	return &c
}

func (cl *Client) Publish(m *Message) {
	cl.tm.q_lock.RLock()
	clientlist, ok := cl.tm.subs[m.TopicSuffix]
	cl.tm.q_lock.RUnlock()
	changed_clients := make(map[uint32]*Client)
	if ok {
		for c := range clientlist {
			cl.tm.c_maplock.RLock()
			cle, ok := cl.tm.cmap[c]
			if !ok {
				panic("client id not resolved")
			}
			cl.tm.c_maplock.RUnlock()
			cle.mlist.PushBack(m)
			changed_clients[c] = cle
		}
		for _, v := range changed_clients {
			v.queueChanged()
		}
	}
}

//Subscribe should bind the given handler with the given topic
//returns the identifier used for Unsubscribe
func (cl *Client) Subscribe(topic string) uint32 {
	subid := atomic.AddUint32(&cl.tm.subid_head, 1)
	cl.tm.q_lock.Lock()
	topicmap, ok := cl.tm.subs[topic]
	if !ok {
		topicmap = make(map[uint32]uint32)
		cl.tm.subs[topic] = topicmap
		topicmap[cl.cid] = subid
		cl.tm.rsubs[subid] = topic
		cl.tm.q_lock.Unlock()
		return subid
	}
	existing_subid, ok := topicmap[cl.cid]
	if ok {
		cl.tm.q_lock.Unlock()
		return existing_subid
	} else {
		topicmap[cl.cid] = subid
		cl.tm.rsubs[subid] = topic
		cl.tm.q_lock.Unlock()
		return subid
	}

}

//Unsubscribe does what it says. For now the topic system is crude
//so this doesn't seem necessary to have the subid instead of topic
//but it will make sense when we are doing wildcards later.
func (cl *Client) Unsubscribe(subid uint32) {
	cl.tm.q_lock.Lock()
	topic, ok := cl.tm.rsubs[subid]
	if !ok {
		cl.tm.q_lock.Unlock()
		return
	}
	delete(cl.tm.rsubs, subid)
	topicmap := cl.tm.subs[topic]
	delete(topicmap, cl.cid)
	cl.tm.q_lock.Unlock()
}

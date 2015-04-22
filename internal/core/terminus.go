package core

import (
	"container/list"
	"strings"
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

type subscription struct {
	subid uint32
	tap   bool
}
type Terminus struct {
	// Crude workaround
	q_lock sync.RWMutex
	//topic onto cid onto subid
	subs map[string]map[uint32]subscription
	//subid onto string, uid is got from context
	rsubs      map[uint32]string
	c_maplock  sync.RWMutex
	cmap       map[uint32]*Client
	cid_head   uint32
	subid_head uint32
	//map topic onto message
	persistLock sync.RWMutex
	persist     map[string]*Message
}

func CreateTerminus() *Terminus {
	rv := &Terminus{}
	rv.subs = make(map[string]map[uint32]subscription)
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
	count := 0 //how many we delivered it to
	if ok {
		//We are relying on the fact that golang randomises iteration order here
		//if this ever changes, we need to manually randomise it ourself

		for c, sub := range clientlist {
			if !sub.tap && m.Consumers != 0 && count == m.Consumers {
				continue //We hit limit
			}
			cl.tm.c_maplock.RLock()
			cle, ok := cl.tm.cmap[c]
			if !ok {
				panic("client id not resolved")
			}
			cl.tm.c_maplock.RUnlock()
			cle.mlist.PushBack(m)
			changed_clients[c] = cle
			count++
		}
		for _, v := range changed_clients {
			v.queueChanged()
		}
	}
	if m.Consumers != 0 && count < m.Consumers {
		m.Consumers -= count //Set consumers to how many deliveries we have left
	}
	if m.Persist != 0 && !(m.Consumers != 0 && count == m.Consumers) {
		cl.tm.persistLock.Lock()
		cl.tm.persist[m.TopicSuffix] = m
		cl.tm.persistLock.Unlock()
	}
}

//Subscribe should bind the given handler with the given topic
//returns the identifier used for Unsubscribe
func (cl *Client) Subscribe(topic string, tap bool) uint32 {
	subid := atomic.AddUint32(&cl.tm.subid_head, 1)
	cl.tm.q_lock.Lock()
	topicmap, ok := cl.tm.subs[topic]
	if !ok {
		topicmap = make(map[uint32]subscription)
		cl.tm.subs[topic] = topicmap
		topicmap[cl.cid] = subscription{subid: subid, tap: tap}
		cl.tm.rsubs[subid] = topic
		cl.tm.q_lock.Unlock()
		return subid
	}
	existing_sub, ok := topicmap[cl.cid]
	if ok {
		cl.tm.q_lock.Unlock()
		return existing_sub.subid
	}
	topicmap[cl.cid] = subscription{subid: subid, tap: tap}
	cl.tm.rsubs[subid] = topic
	cl.tm.q_lock.Unlock()
	return subid

}

func (cl *Client) Query(topic string, tap bool) *Message {
	cl.tm.persistLock.RLock()
	m, ok := cl.tm.persist[topic]
	cl.tm.persistLock.RUnlock()
	if ok {
		//Should we be monitoring delivery count
		if !tap && m.Consumers > 0 {
			m.Consumers--
			//Last delivery, delete it
			if m.Consumers == 0 {
				cl.tm.persistLock.Lock()
				delete(cl.tm.persist, topic)
				cl.tm.persistLock.Unlock()
			}
		}
		return m
	}
	return nil
}

//List will return a list of known immediate children for a given URI. A known
//child can only exist if the children streams have persisted messages
func (cl *Client) List(topic string) []string {
	rv := make([]string, 0, 30)
	cl.tm.persistLock.RLock()
	tlen := len(topic)
	for key := range cl.tm.persist {
		if strings.HasPrefix(key, topic) {
			rv = append(rv, key[tlen:])
		}
	}
	cl.tm.persistLock.RUnlock()
	return rv
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

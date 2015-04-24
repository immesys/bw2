package core

import (
	"container/list"
	"math/rand"
	"strings"
	"sync"
	"sync/atomic"
)

// If a message enters the terminus, it has already had its signature verified,
// and it is destined for our MVK, otherwise a different part of the program
// would have handled it. Similarly, any subscribe requests entering the
// terminus have been verified, same for tap, ls etc.
// This might not be possible for subscribes with wildcards, but the exiting
// messages will be verified by outer layers

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

type snode struct {
	lock     sync.RWMutex
	children map[string]*snode
	//map cid to subscription (NOT SUBID)
	subs map[uint32]subscription
}

func NewSnode() *snode {
	return &snode{children: make(map[string]*snode), subs: make(map[uint32]subscription, 0)}
}

type subscription struct {
	subid  uint32
	client *Client
	tap    bool
}
type Terminus struct {
	// Crude workaround
	q_lock sync.RWMutex
	//topic onto cid onto subid
	//subs map[string]map[uint32]subscription
	//subid onto string, uid is got from context
	rsubs map[uint32]string

	c_maplock  sync.RWMutex
	cmap       map[uint32]*Client
	cid_head   uint32
	subid_head uint32
	//map topic onto message
	persistLock sync.RWMutex
	persist     map[string]*Message

	stree *snode
	//map subid to a tree node
	rstree map[uint32]*snode
}

func (s *snode) rmatchSubs(parts []string, visitor func(s subscription)) {
	if len(parts) == 0 {
		s.lock.RLock()
		for _, sub := range s.subs {
			visitor(sub)
		}
		s.lock.RUnlock()
		return
	}
	s.lock.RLock()
	v1, ok1 := s.children[parts[0]]
	v2, ok2 := s.children["+"]
    v3, ok3 := s.children["*"]
	s.lock.RUnlock()
	if ok1 {
		v1.rmatchSubs(parts[1:], visitor)
	}
	if ok2 {
		v2.rmatchSubs(parts[1:], visitor)
	}
    if ok3 {
        for i:=0; i<len(parts); i++ {
            v3.rmatchSubs(parts[i:], visitor)
        }
    }
}
func (s *snode) addSub(parts []string, sub subscription) (uint32, *snode) {
	if len(parts) == 0 {
		s.lock.Lock()
		existing, ok := s.subs[sub.client.cid]
		if ok {
			s.lock.Unlock()
			return existing.subid, s
		} else {
			s.subs[sub.client.cid] = sub
			s.lock.Unlock()
			return sub.subid, s
		}
	}
	s.lock.RLock()
	child, ok := s.children[parts[0]]
	s.lock.RUnlock()
	if !ok {
		nc := NewSnode()
		subid, node := nc.addSub(parts[1:], sub)
		s.lock.Lock()
		s.children[parts[0]] = nc
		s.lock.Unlock()
		return subid, node
	} else {
		return child.addSub(parts[1:], sub)
	}
}

func (tm *Terminus) AddSub(topic string, s subscription) uint32 {
	parts := strings.Split(topic, "/")
	subid, node := tm.stree.addSub(parts, s)
	if subid != s.subid {
		tm.q_lock.Lock()
		tm.rstree[subid] = node
		tm.q_lock.Unlock()
	}
	return subid
}
func (tm *Terminus) RMatchSubs(topic string, visitor func(s subscription)) {
	parts := strings.Split(topic, "/")
	tm.stree.rmatchSubs(parts, visitor)
}

func CreateTerminus() *Terminus {
	rv := &Terminus{}
	rv.rsubs = make(map[uint32]string)
	rv.cmap = make(map[uint32]*Client)
	rv.stree = NewSnode()
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
	var clientlist []subscription
	cl.tm.RMatchSubs(m.TopicSuffix, func(s subscription) {
		clientlist = append(clientlist, s)
	})
	if m.Consumers != 0 {
		for i := range clientlist {
			j := rand.Intn(i + 1)
			clientlist[i], clientlist[j] = clientlist[j], clientlist[i]
		}
	}
	changed_clients := make(map[int]*Client)
	count := 0 //how many we delivered it to
	for c, sub := range clientlist {
		if !sub.tap && m.Consumers != 0 && count == m.Consumers {
			continue //We hit limit
		}

		sub.client.mlist.PushBack(m)
		changed_clients[c] = sub.client
		count++
	}
	for _, v := range changed_clients {
		v.queueChanged()
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
	newsub := subscription{subid: subid, tap: tap, client: cl}

	//Add to the sub tree
	subid = cl.tm.AddSub(topic, newsub)
	//the subid might not be the one we specified, if it was already in the tree
	if subid == newsub.subid { //was new
		cl.tm.q_lock.Lock()
		cl.tm.rsubs[subid] = topic
		cl.tm.q_lock.Unlock()
	}
	return subid
	// topicmap, ok := cl.tm.subs[topic]
	// if !ok {
	// 	topicmap = make(map[uint32]subscription)
	// 	cl.tm.subs[topic] = topicmap
	// 	topicmap[cl.cid] = subscription{subid: subid, tap: tap}
	//
	//
	// 	return subid
	// }
	// existing_sub, ok := topicmap[cl.cid]
	// if ok {
	// 	cl.tm.q_lock.Unlock()
	// 	return existing_sub.subid
	// }
	// topicmap[cl.cid] =
	// cl.tm.rsubs[subid] = topic
	// cl.tm.q_lock.Unlock()
	// return subid

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
	_, ok1 := cl.tm.rsubs[subid]
	node := cl.tm.rstree[subid]
	if !ok1 {
		cl.tm.q_lock.Unlock()
		return
	}
	delete(cl.tm.rsubs, subid)
	delete(node.subs, cl.cid)
	//TODO we don't clean up the tree!
	cl.tm.q_lock.Unlock()
}

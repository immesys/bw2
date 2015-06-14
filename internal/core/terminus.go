// This file is part of BOSSWAVE.
//
// BOSSWAVE is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// BOSSWAVE is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with BOSSWAVE.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright © 2015 Michael Andersen <m.andersen@cs.berkeley.edu>

package core

// If a message enters the terminus, it has already had its signature verified,
// and it is destined for an MVK that we are responsible for,
// otherwise a different part of the program
// would have handled it.

// For subscribe requests, a valid D Similarly, any subscribe requests entering the
// terminus have been verified, same for tap, ls etc.
// This might not be possible for subscribes with wildcards, but the exiting
// messages will be verified by outer layers

import (
	"fmt"
	"math/rand"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"github.com/immesys/bw2/internal/store"
)

/*
type SubscriptionHandler interface {
	Handle(m *Message)
}
*/

//A handle to a queue that gets messages dispatched to it
type Client struct {
	//MVK etc
	cid  clientid
	subs []UniqueMessageID
	tm   *Terminus
}

type clientid uint32

type snode struct {
	lock     sync.RWMutex
	children map[string]*snode
	//map cid to subscription (NOT SUBID)
	subs map[clientid]subscription
}

func NewSnode() *snode {
	return &snode{children: make(map[string]*snode), subs: make(map[clientid]subscription, 0)}
}

type subscription struct {
	subid   UniqueMessageID
	handler func(m *Message, s UniqueMessageID)
	client  *Client
	tap     bool
}

type Terminus struct {
	// Crude workaround
	//q_lock sync.RWMutex

	//This maps a client ID onto a client pointer
	//TODO can we just use the pointer throughout?
	c_maplock sync.RWMutex
	cmap      map[clientid]*Client
	cid_head  uint32

	//The subscription tree
	stree *snode

	//map a subscription ID onto the snode that contains it
	rstree_lock sync.RWMutex
	rstree      map[UniqueMessageID]*snode
}

//For a node in the tree, match the given subscription string and call visitor
//for every subscription found
func (s *snode) rmatchSubs(parts []string, visitor func(s subscription)) {
	fmt.Println("rms ", parts)
	if len(parts) == 0 {
		fmt.Println("checking zero case")
		s.lock.RLock()
		for _, sub := range s.subs {
			fmt.Println("dispatching to sub")
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
	fmt.Println("matches", ok1, ok2, ok3)
	if ok1 {
		v1.rmatchSubs(parts[1:], visitor)
	}
	if ok2 {
		v2.rmatchSubs(parts[1:], visitor)
	}
	if ok3 {
		for i := 0; i <= len(parts); i++ {
			v3.rmatchSubs(parts[i:], visitor)
		}
	}
}

//Add the given subscription parts starting from the given snode
//returns a unique message ID of the subscription in the tree. If this does
//not match the ID of the subscription given, then it is because there was
//an existing subscription from the same client with the same pattern.
func (s *snode) addSub(parts []string, sub subscription) (UniqueMessageID, *snode) {
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

//AddSub adds a subscription to terminus. It returns the unique message ID
//of the actual subscription in the tree. If it is not the same as the one
//in the given subscription, then the add was a noop. Note that means that
//the new callback in the added subscription WILL NOT BE CALLED upon new
//messages. i.e subscriptions must be unique within a client
func (tm *Terminus) AddSub(topic string, s subscription) UniqueMessageID {
	parts := strings.Split(topic, "/")
	fmt.Println("Add subscription: ", parts)
	subid, node := tm.stree.addSub(parts, s)
	if subid == s.subid { //This was a new subscription
		tm.rstree_lock.Lock()
		tm.rstree[subid] = node
		tm.rstree_lock.Unlock()
	}
	return subid
}
func (tm *Terminus) RMatchSubs(topic string, visitor func(s subscription)) {
	parts := strings.Split(topic, "/")
	tm.stree.rmatchSubs(parts, visitor)
}

func CreateTerminus() *Terminus {
	rv := &Terminus{}
	rv.cmap = make(map[clientid]*Client)
	rv.stree = NewSnode()
	rv.rstree = make(map[UniqueMessageID]*snode)
	go func() {
		for {
			time.Sleep(5 * time.Second)
			fmt.Println("terminus map:")
			for k := range rv.cmap {
				fmt.Printf("[%v]\n", k)
			}
			fmt.Println("rsmap:")
			for k := range rv.rstree {
				fmt.Printf("[%v]\n", k)
			}
		}
	}()
	return rv
}

func (tm *Terminus) CreateClient() *Client {
	cid := clientid(atomic.AddUint32(&tm.cid_head, 1))
	c := Client{cid: cid, tm: tm}
	tm.c_maplock.Lock()
	tm.cmap[cid] = &c
	tm.c_maplock.Unlock()
	return &c
}

func (cl *Client) Publish(m *Message) {
	var clientlist []subscription
	cl.tm.RMatchSubs(m.Topic, func(s subscription) {
		fmt.Printf("sub match\n")
		clientlist = append(clientlist, s)
	})
	//Note that the semantics of consumers here is a little odd, its subscriptions,
	//but in a topology with N oob clients per router, we may have one subscription
	//for >1 oob clients
	//If we are doing a subset delivery, randomize the client list
	if m.Consumers != 0 {
		for i := range clientlist {
			j := rand.Intn(i + 1)
			clientlist[i], clientlist[j] = clientlist[j], clientlist[i]
		}
	}
	count := 0 //how many we delivered it to
	for _, sub := range clientlist {
		if !sub.tap && m.Consumers != 0 && count >= m.Consumers {
			continue //We hit limit
		}
		go sub.handler(m, sub.subid)
		count++
	}
}

//Subscribe should bind the given handler with the given topic
//returns the identifier used for Unsubscribe
//func (cl *Client) Subscribe(topic string, tap bool, meta interface{}) (uint32, bool) {
func (cl *Client) Subscribe(m *Message, cb func(m *Message, id UniqueMessageID)) UniqueMessageID {
	newsub := subscription{subid: m.UMid,
		tap:     m.Type == TypeTap,
		client:  cl,
		handler: cb}

	//Add to the sub tree
	subid := cl.tm.AddSub(m.Topic, newsub)
	//Record it for destroy
	if subid == m.UMid { //this sub was new
		cl.subs = append(cl.subs, subid)
	}
	//the subid might not be the one we specified, if it was already in the tree
	return subid
}

func (cl *Client) Persist(m *Message) {
	store.PutMessage(m.Topic, m.Encoded)
	cl.Publish(m)
}

func (cl *Client) Query(m *Message, cb func(m *Message)) {
	rc := make(chan store.SM, 3)
	go store.GetMatchingMessage(m.Topic, rc)
	for {
		select {
		case sm, ok := <-rc:
			if ok {
				m, err := LoadMessage(sm.Body)
				if err != nil {
					panic("Not expecting error from unpersist: " + err.Error())
				}
				cb(m)
			} else {
				cb(nil)
				return
			}
		}
	}
}

func (cl *Client) List(m *Message, cb func(s string, ok bool)) {
	rc := make(chan string, 3)
	go store.ListChildren(m.Topic, rc)
	for {
		select {
		case uri, ok := <-rc:
			if ok {
				cb(uri, true)
			} else {
				cb("", false)
				return
			}
		}
	}
}

func (cl *Client) Destroy() {
	//delete all subscriptions
	cl.tm.rstree_lock.Lock()
	for _, subid := range cl.subs {
		node, ok := cl.tm.rstree[subid]
		if ok {
			delete(node.subs, cl.cid)
		}
		delete(cl.tm.rstree, subid)
	}
	cl.tm.rstree_lock.Unlock()
	//Delete client
	cl.tm.c_maplock.Lock()
	delete(cl.tm.cmap, cl.cid)
	cl.tm.c_maplock.Unlock()
}

//Unsubscribe does what it says. For now the topic system is crude
//so this doesn't seem necessary to have the subid instead of topic
//but it will make sense when we are doing wildcards later.
func (cl *Client) Unsubscribe(subid UniqueMessageID) {
	cl.tm.rstree_lock.Lock()
	node, ok := cl.tm.rstree[subid]
	if !ok {
		cl.tm.rstree_lock.Unlock()
		return
	}
	delete(node.subs, cl.cid)
	delete(cl.tm.rstree, subid)
	//TODO we don't clean up the tree!
	cl.tm.rstree_lock.Unlock()
}

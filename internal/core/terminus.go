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

// Similarly, any subscribe requests entering the
// terminus have been verified, same for tap, ls etc.

import (
	"fmt"
	"math/rand"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"golang.org/x/net/context"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/internal/store"
	"github.com/immesys/bw2/util/bwe"
)

//A handle to a queue that gets messages dispatched to it
type Client struct {
	cid  clientid
	subs []UniqueMessageID
	tm   *Terminus
	name string
	ctx  context.Context
}

type clientid uint32

type subTreeNode struct {
	lock     sync.RWMutex
	children map[string]*subTreeNode
	//map cid to subscription (NOT SUBID)
	subz []*subscription
	//	subs map[clientid]subscription
}

func (stn *subTreeNode) subForId(subid UniqueMessageID) *subscription {
	for _, sub := range stn.subz {
		if sub.subid == subid {
			return sub
		}
	}
	return nil
}

func NewSnode() *subTreeNode {
	return &subTreeNode{children: make(map[string]*subTreeNode)}
}

//This identifies an individual client subscription
type subscription struct {
	subid     UniqueMessageID
	handler   func(m *Message)
	client    *Client
	tap       bool
	uri       string
	created   time.Time
	mqueue    chan *Message
	ctx       context.Context
	ctxcancel func()
}

type Terminus struct {
	// Crude workaround
	//q_lock sync.RWMutex

	//This maps a client ID onto a client pointer
	c_maplock sync.RWMutex
	cmap      map[clientid]*Client
	cid_head  uint32

	//The subscription tree
	stree *subTreeNode

	//map a subscription ID onto the snode that contains it
	rstree_lock sync.RWMutex
	rstree      map[UniqueMessageID]*subTreeNode
}

//For a node in the tree, match the given subscription string and call visitor
//for every subscription found
func (s *subTreeNode) rmatchSubs(parts []string, visitor func(s *subscription)) {
	//fmt.Println("rms ", parts)
	if len(parts) == 0 {
		//fmt.Println("checking zero case")
		s.lock.RLock()
		for _, sub := range s.subz {
			//fmt.Println("dispatching to sub")
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
	//fmt.Println("matches", ok1, ok2, ok3)
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
//returns a unique message ID of the subscription in the tree.
func (s *subTreeNode) addSub(parts []string, sub *subscription) (UniqueMessageID, *subTreeNode) {
	if len(parts) == 0 {
		s.lock.Lock()
		s.subz = append(s.subz, sub)
		s.lock.Unlock()
		return sub.subid, s
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
//of the actual subscription in the tree.
func (tm *Terminus) AddSub(topic string, s *subscription) UniqueMessageID {
	parts := strings.Split(topic, "/")
	fmt.Println("Add subscription: ", parts)
	subid, node := tm.stree.addSub(parts, s)
	tm.rstree_lock.Lock()
	tm.rstree[subid] = node
	tm.rstree_lock.Unlock()
	return subid
}
func (tm *Terminus) RMatchSubs(topic string, visitor func(s *subscription)) {
	parts := strings.Split(topic, "/")
	tm.stree.rmatchSubs(parts, visitor)
}

func rounddur(d, r time.Duration) time.Duration {
	if r <= 0 {
		return d
	}
	neg := d < 0
	if neg {
		d = -d
	}
	if m := d % r; m+m < r {
		d = d - m
	} else {
		d = d + r - m
	}
	if neg {
		return -d
	}
	return d
}

func CreateTerminus() *Terminus {
	rv := &Terminus{}
	rv.cmap = make(map[clientid]*Client)
	rv.stree = NewSnode()
	rv.rstree = make(map[UniqueMessageID]*subTreeNode)
	go func() {
		for {
			time.Sleep(5 * time.Second)
			rv.rstree_lock.RLock()
			rv.c_maplock.RLock()
			if len(rv.cmap) > 0 {
				log.Infof("Active clients:")
				for k, v := range rv.cmap {
					log.Infof("[%d->%s]", k, v.name)
				}
			} else {
				log.Infof("No active clients")
			}
			if len(rv.rstree) > 0 {
				log.Infof("Active subscriptions:")
				log.Infof("  AGE   CLIENT                     URI")
				for mid, stn := range rv.rstree {
					sub := stn.subForId(mid)
					age := time.Now().Sub(sub.created)
					log.Infof("  %-5s %-26s %s", rounddur(age, time.Second), sub.client.name, sub.uri)
				}
			} else {
				log.Infof("No active subscriptions")
			}
			rv.c_maplock.RUnlock()
			rv.rstree_lock.RUnlock()
		}
	}()
	return rv
}

func (tm *Terminus) CreateClient(ctx context.Context, name string) *Client {
	cid := clientid(atomic.AddUint32(&tm.cid_head, 1))
	c := Client{cid: cid, tm: tm, name: name, ctx: ctx}
	go func() {
		<-ctx.Done()
		c.tm.rstree_lock.Lock()
		for _, subid := range c.subs {
			node, ok := c.tm.rstree[subid]
			if ok {
				np := node.subz[:0]
				for _, s := range node.subz {
					if s.client.cid != c.cid {
						np = append(np, s)
					}
				}
				node.subz = np
			}
			delete(c.tm.rstree, subid)
		}
		c.tm.rstree_lock.Unlock()
		//Delete client
		c.tm.c_maplock.Lock()
		delete(c.tm.cmap, c.cid)
		c.tm.c_maplock.Unlock()
	}()
	tm.c_maplock.Lock()
	tm.cmap[cid] = &c
	tm.c_maplock.Unlock()
	return &c
}

func (cl *Client) Publish(m *Message) {
	var clientlist []*subscription
	cl.tm.RMatchSubs(m.Topic, func(s *subscription) {
		//fmt.Printf("sub match\n")
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
		select {
		case sub.mqueue <- m:
		default:
			fmt.Printf("UNSUBSCRIBING %v::%s QUEUE FULL\n", sub.client.name, sub.uri)
			sub.ctxcancel()
		}
		count++
	}
}

//Subscribe should bind the given handler with the given topic
//returns the identifier used for Unsubscribe
//func (cl *Client) Subscribe(topic string, tap bool, meta interface{}) (uint32, bool) {
func (cl *Client) Subscribe(ctx context.Context, m *Message, cb func(m *Message)) UniqueMessageID {
	cctx, cancel := context.WithCancel(ctx)
	newsub := subscription{subid: m.UMid,
		tap:       m.Type == TypeTap,
		client:    cl,
		handler:   cb,
		mqueue:    make(chan *Message, 4096),
		created:   time.Now(),
		uri:       m.Topic,
		ctx:       cctx,
		ctxcancel: cancel}

	go func() {
		for {
			select {
			case mm := <-newsub.mqueue:
				newsub.handler(mm)
			case <-newsub.ctx.Done():
				newsub.client.Unsubscribe(newsub.subid)
				newsub.handler(nil)
			}
		}
	}()
	//Add to the sub tree
	subid := cl.tm.AddSub(m.Topic, &newsub)
	//Record it for destroy
	cl.subs = append(cl.subs, subid)

	return subid
}

func (cl *Client) Persist(m *Message) {
	store.PutMessage(m.Topic, m.Encoded)
	cl.Publish(m)
}

func (cl *Client) Query(m *Message, cb func(m *Message)) {
	rc := make(chan store.SM, 3)
	go store.GetMatchingMessage(m.Topic, rc)
	for sm := range rc {
		//We could check validity of the message, but whoever
		//we send this to will do that. We just check expiry because
		//it is cheap
		m, err := LoadMessage(sm.Body)
		if err != nil {
			panic("Not expecting error from unpersist: " + err.Error())
		}
		if !m.ExpireTime.Before(time.Now()) {
			cb(m)
		}
	}
	cb(nil)
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

//func (cl *Client) Destroy() {
//delete all subscriptions
// cl.tm.rstree_lock.Lock()
// for _, subid := range cl.subs {
// 	node, ok := cl.tm.rstree[subid]
// 	if ok {
// 		np := node.subz[:0]
// 		for _, s := range node.subz {
// 			if s.client.cid != cl.cid {
// 				np = append(np, s)
// 			}
// 		}
// 		node.subz = np
// 	}
// 	delete(cl.tm.rstree, subid)
// }
// cl.tm.rstree_lock.Unlock()
// //Delete client
// cl.tm.c_maplock.Lock()
// delete(cl.tm.cmap, cl.cid)
// cl.tm.c_maplock.Unlock()
//}

//Unsubscribe does what it says. For now the topic system is crude
//so this doesn't seem necessary to have the subid instead of topic
//but it will make sense when we are doing wildcards later.
func (cl *Client) Unsubscribe(subid UniqueMessageID) error {
	cl.tm.rstree_lock.Lock()
	node, ok := cl.tm.rstree[subid]
	if !ok {
		cl.tm.rstree_lock.Unlock()
		return bwe.M(bwe.UnsubscribeError, "Subscription does not exist (terminus)")
	}
	toTerm := []*subscription{}
	//delete(node.subs, cl.cid)
	np := node.subz[:0]
	for _, s := range node.subz {
		if s.subid != subid {
			np = append(np, s)
		} else {
			toTerm = append(toTerm, s)
		}
	}
	node.subz = np
	delete(cl.tm.rstree, subid)
	//TODO we don't clean up the tree!
	// meaning there are intermediate nodes with no leaves
	// that is probably ok
	cl.tm.rstree_lock.Unlock()
	for _, tt := range toTerm {
		tt.ctxcancel()
	}
	return nil
}

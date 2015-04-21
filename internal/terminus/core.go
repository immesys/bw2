package core

import (
	"sync"
)

// If a message enters the terminus, it has already had its signature verified,
// and it is destined for our MVK, otherwise a different part of the program
// would have handled it. Similarly, any subscribe requests entering the
// terminus have been verified, same for tap, ls etc.

type SubscriptionHandler interface {
	Handle(t *Topic, m *Message)
}

type Topic struct {
	v string
}

// Crude workaround
var q_lock sync.RWMutex
var subs map[string]map[SubscriptionHandler]bool

func (t *Terminus) Publish(topic *Topic, m *Message) {
	q_lock.RLock()
	topicmap, ok := subs[topic.v]
	if ok {
		for k, v := range topicmap {
			v.Handle(topic, m)
		}
	}
	q_lock.RUnlock()
}

//Subscribe should bind the given handler with the given topic
func (t *Terminus) Subscribe(topic *Topic, handler SubscriptionHandler) {
	q_lock.Lock()
	subs[topic.v][handler] = true
	q_lock.Unlock()
}

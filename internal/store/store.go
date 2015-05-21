package store

//This module stores and retrieves DOTs, Entities and DChains. For now its
//a passthru to the database.
//Note that these parameters must be clean at this stage of the program. The
//topics must be well formed, and the messages must be syntactically valid
//otherwise we will panic when extracting them from the DB

import (
	"strings"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/internal/rocks"
	"github.com/immesys/bw2/objects"
)

//These constants are used to differentiate blocks of keys in the DB.
//We leave a space between them so that we can do range queries
const (
	markDOT     = 1
	markEDOT    = 2
	markDChain  = 3
	markEDChain = 4
	markEntity  = 5
	markEEntity = 6
)

//StoreDOT puts a DOT into the DB
func PutDOT(v *objects.DOT) {
	value := make([]byte, len(v.GetContent())+1)
	value[0] = byte(v.GetRONum())
	copy(value[1:], v.GetContent())
	rocks.PutObject(rocks.CFDot, v.GetHash(), value)
}

//RetreiveDOT gets a DOT from the DB
func GetDOT(hash []byte) (*objects.DOT, bool) {
	value, err := rocks.GetObject(rocks.CFDot, hash)
	if err == rocks.ErrObjNotFound {
		return nil, false
	}
	rdot, err := objects.NewDOT(int(value[0]), value[1:])
	if err != nil {
		log.Criticalf("Deserializing dot from DB: %v", err)
		panic("Deserialising dot from dB")
	}
	dot := rdot.(*objects.DOT)
	return dot, true
}

//StoreDChain puts a DChain into the DB. This must be an elaborated
//DChain, otherwise it panics (no point in storing a standard dchain)
func PutDChain(v *objects.DChain) {
	if !v.IsElaborated() {
		panic("dchain needs to be elaborated")
	}
	value := make([]byte, len(v.GetContent())+1)
	value[0] = byte(v.GetRONum())
	copy(value[1:], v.GetContent())
	rocks.PutObject(rocks.CFDChain, v.GetChainHash(), value)
}

func GetDChain(hash []byte) (*objects.DChain, bool) {
	value, err := rocks.GetObject(rocks.CFDChain, hash)
	if err == rocks.ErrObjNotFound {
		return nil, false
	}
	rdchain, err := objects.NewDChain(int(value[0]), value[1:])
	if err != nil {
		log.Criticalf("Deserialising dchain from db: %v", err)
		panic("Deserialising dchain from dB")
	}
	dchain := rdchain.(*objects.DChain)
	return dchain, true
}

func PutEntity(v *objects.Entity) {
	rocks.PutObject(rocks.CFEntity, v.GetVK(), v.GetContent())
}

func GetEntity(vk []byte) (*objects.Entity, bool) {
	value, err := rocks.GetObject(rocks.CFEntity, vk)
	if err == rocks.ErrObjNotFound {
		return nil, false
	}
	rentity, err := objects.NewDChain(int(value[0]), value[1:])
	if err != nil {
		log.Criticalf("Deserialising entity from DB: %v", err)
		panic("Deserialising entity from dB")
	}
	entity := rentity.(*objects.Entity)
	return entity, true
}

//PutMessage inserts a message into the database. Note that the topic must be
//well formed and complete (no wildcards etc)
func PutMessage(topic string, payload []byte) {
	ts := strings.Split(topic, "/")
	tb := []byte(topic)
	mrg := make([]string, len(ts)*2)
	for i, v := range ts {
		mrg[i*2] = v
		mrg[(len(ts)-i)*2-1] = v
	}
	smrg := []byte(strings.Join(mrg, "/"))

	rocks.PutObject(rocks.CFMsg, smrg, payload)
	rocks.PutObject(rocks.CFMsg, tb, payload)

	//Put parents
	for i := len(ts) - 1; i > 0; i-- {
		pstr := []byte(strings.Join(ts[0:i], "/"))
		if !rocks.Exists(rocks.CFMsg, pstr) {
			rocks.PutObject(rocks.CFMsg, pstr, []byte{0})
		} else {
			//We assume that if a path exists, all its parents exist
			break
		}
	}
	for i := len(mrg) - 1; i > 0; i-- {
		pstr := []byte(strings.Join(mrg[0:i], "/"))
		if !rocks.Exists(rocks.CFMsgI, pstr) {
			rocks.PutObject(rocks.CFMsgI, pstr, []byte{0})
		} else {
			//We assume that if a path exists, all its parents exist
			break
		}
	}
}

func GetExactMessage(topic string) ([]byte, error) {
	value, err := rocks.GetObject(rocks.CFMsg, vk)
	if err == rocks.ErrObjNotFound {
		return nil, false
	}
	return buildMessage()
	rentity, err := objects.NewDChain(int(value[0]), value[1:])
	if err != nil {
		log.Criticalf("Deserialising entity from DB: %v", err)
		panic("Deserialising entity from dB")
	}
	entity := rentity.(*objects.Entity)
	return entity, true
}

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

package api

import (
	"bytes"
	"encoding/base64"
	"encoding/binary"
	"fmt"
	"os"
	"strings"
	"sync/atomic"
	"time"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util"
	"github.com/immesys/bw2/util/bwe"
)

const (
	NoElaboration      = 0
	PartialElaboration = 1
	FullElaboration    = 2
)

func InitLog(logfile string) {
	cfg := `
	<seelog>
    <outputs>
        <splitter formatid="common">
            <console/>
            <file path="` + logfile + `"/>
        </splitter>
    </outputs>
		<formats>
				<format id="common" format="[%LEV] %Time %Date %File:%Line %Msg%n"/>
		</formats>
	</seelog>`

	nlogger, err := log.LoggerFromConfigAsString(cfg)
	if err == nil {
		log.ReplaceLogger(nlogger)
	} else {
		fmt.Printf("Bad log config: %v\n", err)
		os.Exit(1)
	}
}

type PublishParams struct {
	MVK                []byte
	URISuffix          string
	PrimaryAccessChain *objects.DChain
	RoutingObjects     []objects.RoutingObject
	PayloadObjects     []objects.PayloadObject
	Expiry             *time.Time
	ExpiryDelta        *time.Duration
	ElaboratePAC       int
	DoVerify           bool
	Persist            bool
}
type PublishCallback func(err error)

func (c *BosswaveClient) checkAddOriginVK(m *core.Message) {

	//Although the PAC may not be elaborated, we might be able to
	//elaborate it some more here for our decision support
	pac := m.PrimaryAccessChain
	if pac != nil {
		if !pac.IsElaborated() {
			dc := core.ElaborateDChain(m.PrimaryAccessChain, c.BW())
			if dc != nil {
				pac = dc
			}
		}
		core.ResolveDotsInDChain(pac, nil, c.BW())
	}
	if pac == nil || !pac.IsElaborated() ||
		pac.GetReceiverVK() == nil ||
		objects.IsEveryoneVK(pac.GetReceiverVK()) {
		ovk := objects.CreateOriginVK(c.GetUs().GetVK())
		m.RoutingObjects = append(m.RoutingObjects, ovk)
		vk := c.GetUs().GetVK()
		m.OriginVK = &vk
	}
}
func (c *BosswaveClient) Publish(params *PublishParams,
	cb PublishCallback) {
	t := core.TypePublish
	if params.Persist {
		t = core.TypePersist
	}
	m, err := c.newMessage(t, params.MVK, params.URISuffix)
	if err != nil {
		cb(err)
		return
	}
	m.PrimaryAccessChain = params.PrimaryAccessChain
	m.RoutingObjects = params.RoutingObjects
	m.PayloadObjects = params.PayloadObjects
	if err := c.doPAC(m, params.ElaboratePAC); err != nil {
		cb(err)
		return
	}

	//Check if we need to add an origin VK header
	c.checkAddOriginVK(m)

	//Add expiry
	if params.ExpiryDelta != nil {
		m.RoutingObjects = append(m.RoutingObjects, objects.CreateNewExpiryFromNow(*params.ExpiryDelta))
	} else if params.Expiry != nil {
		m.RoutingObjects = append(m.RoutingObjects, objects.CreateNewExpiry(*params.Expiry))
	}

	c.finishMessage(m)

	if params.DoVerify {
		//log.Info("verifying")
		s := m.Verify(c.BW())
		if s.Code != bwe.Okay {
			log.Info("verification failed")
			cb(bwe.M(s.Code, "message verification failed"))
			return
		}
	}
	//Probably wanna do shit like determine if this is for remote delivery or local

	err = c.VerifyAffinity(m)
	if err == nil { //Local delivery
		if params.Persist {
			c.cl.Persist(m)
		} else {
			c.cl.Publish(m)
		}
		cb(nil)
	} else { //Remote delivery
		peer, err := c.GetPeer(m.MVK)
		if err != nil {
			log.Info("Could not deliver to peer: ", err)
			cb(bwe.WrapC(bwe.PeerError, err))
			return
		}
		peer.PublishPersist(m, cb)
	}
}

func (c *BosswaveClient) VerifyAffinity(m *core.Message) error {
	drvk, err := c.BW().LookupDesignatedRouter(m.MVK)
	if err != nil {
		return bwe.WrapM(bwe.AffinityMismatch, "error verifying affinity", err)
	}
	if bytes.Equal(c.BW().Entity.GetVK(), drvk) {
		return nil
	} else {
		return bwe.M(bwe.AffinityMismatch, "we are not the DR for this namespace")
	}
}

type SubscribeParams struct {
	MVK                []byte
	URISuffix          string
	PrimaryAccessChain *objects.DChain
	RoutingObjects     []objects.RoutingObject
	Expiry             *time.Time
	ExpiryDelta        *time.Duration
	ElaboratePAC       int
	DoVerify           bool
}
type SubscribeInitialCallback func(err error, isNew bool, id core.UniqueMessageID)
type SubscribeMessageCallback func(m *core.Message)

func (c *BosswaveClient) Subscribe(params *SubscribeParams,
	actionCB SubscribeInitialCallback,
	messageCB SubscribeMessageCallback) {

	m, err := c.newMessage(core.TypeSubscribe, params.MVK, params.URISuffix)
	if err != nil {
		actionCB(err, false, core.UniqueMessageID{})
		return
	}
	m.PrimaryAccessChain = params.PrimaryAccessChain
	m.RoutingObjects = params.RoutingObjects
	if err := c.doPAC(m, params.ElaboratePAC); err != nil {
		actionCB(err, false, core.UniqueMessageID{})
		return
	}
	//Add expiry
	if params.ExpiryDelta != nil {
		m.RoutingObjects = append(m.RoutingObjects, objects.CreateNewExpiryFromNow(*params.ExpiryDelta))
	} else if params.Expiry != nil {
		m.RoutingObjects = append(m.RoutingObjects, objects.CreateNewExpiry(*params.Expiry))
	}
	//Check if we need to add an origin VK header
	c.checkAddOriginVK(m)
	c.finishMessage(m)
	if params.DoVerify {
		s := m.Verify(c.BW())
		if s.Code != bwe.Okay {
			actionCB(bwe.C(s.Code), false, core.UniqueMessageID{})
			return
		}
	}

	err = c.VerifyAffinity(m)
	if err == nil { //Local delivery
		subid := c.cl.Subscribe(m, func(m *core.Message, subid core.UniqueMessageID) {
			messageCB(m)
		})
		isNew := subid == m.UMid
		actionCB(nil, isNew, subid)
	} else { //Remote delivery
		peer, err := c.GetPeer(m.MVK)
		if err != nil {
			log.Info("Could not deliver to peer: ", err)
			actionCB(bwe.WrapM(bwe.PeerError, "could not peer", err), false, core.UniqueMessageID{})
			return
		}
		peer.Subscribe(m, actionCB, messageCB)
	}
}

type BuildChainParams struct {
	To          []byte
	URI         string
	Status      *chan string
	Permissions string
}

func (c *BosswaveClient) BuildChain(p *BuildChainParams) (chan *objects.DChain, error) {
	log.Info("BC TO: ", crypto.FmtKey(p.To))
	log.Info("Permissions: ", p.Permissions)
	log.Info("URI: ", p.URI)
	var status chan string
	if p.Status == nil {
		log.Info("default status")
		status = make(chan string, 10)
		go func() {
			for m := range status {
				log.Info("chain build status: ", m)
			}
		}()
	} else {
		status = *p.Status
	}
	parts := strings.SplitN(p.URI, "/", 2)
	if len(parts) != 2 {
		return nil, bwe.M(bwe.BadURI, "Bad URI")
	}
	rnsvk, err := c.BW().ResolveKey(parts[0])
	if err != nil {
		return nil, err
	}
	log.Info("making CB")
	cb := NewChainBuilder(c, crypto.FmtKey(rnsvk)+"/"+parts[1], p.Permissions, p.To, status)
	if cb == nil {
		return nil, bwe.M(bwe.BadChainBuildParams, "Could not construct CB: bad params")
	}
	log.Info("making RV chan")
	rv := make(chan *objects.DChain)
	go func() {
		//We are going to change the chain builder to emit results on a channel later
		//so lets emit each result on a different message preemptively
		chains, e := cb.Build()
		fmt.Println("chain build in async complete")
		if e != nil {
			log.Criticalf("CB fail: %v", e.Error())
			close(rv)
			return
		}
		for _, ch := range chains {
			rv <- ch
		}
		close(rv)
	}()
	return rv, nil
}

type SetEntityParams struct {
	Keyfile []byte
}

func (c *BosswaveClient) SetEntity(p *SetEntityParams) (*objects.Entity, error) {
	if len(p.Keyfile) < 33 {
		return nil, bwe.M(bwe.BadOperation, "keyfile too short")
	}
	e, err := objects.NewEntity(objects.ROEntity, p.Keyfile[32:])
	if err != nil {
		return nil, bwe.WrapM(bwe.BadOperation, "could not create entity: ", err)
	}
	entity := e.(*objects.Entity)
	entity.SetSK(p.Keyfile[:32])

	return entity, c.SetEntityObj(entity)
}

func (c *BosswaveClient) SetEntityObj(e *objects.Entity) error {
	keysOk := crypto.CheckKeypair(e.GetSK(), e.GetVK())
	sigOk := e.SigValid()
	if !keysOk {
		return bwe.M(bwe.InvalidEntity, "Entity keypair mismatch")
	}
	if !sigOk {
		return bwe.M(bwe.InvalidSig, "Entity signature invalid")
	}
	c.ourvk = e
	c.bcc = c.bchain.GetClient(e)
	return nil
}

type ListParams struct {
	MVK                []byte
	URISuffix          string
	PrimaryAccessChain *objects.DChain
	RoutingObjects     []objects.RoutingObject
	Expiry             *time.Time
	ExpiryDelta        *time.Duration
	ElaboratePAC       int
	DoVerify           bool
}
type ListInitialCallback func(err error)
type ListResultCallback func(s string, ok bool)

func (c *BosswaveClient) List(params *ListParams,
	actionCB ListInitialCallback,
	resultCB ListResultCallback) {
	m, err := c.newMessage(core.TypeLS, params.MVK, params.URISuffix)
	if err != nil {
		actionCB(err)
		return
	}
	m.PrimaryAccessChain = params.PrimaryAccessChain
	m.RoutingObjects = params.RoutingObjects
	if err := c.doPAC(m, params.ElaboratePAC); err != nil {
		actionCB(err)
		return
	}
	//Add expiry
	if params.ExpiryDelta != nil {
		m.RoutingObjects = append(m.RoutingObjects, objects.CreateNewExpiryFromNow(*params.ExpiryDelta))
	} else if params.Expiry != nil {
		m.RoutingObjects = append(m.RoutingObjects, objects.CreateNewExpiry(*params.Expiry))
	}

	//Check if we need to add an origin VK header
	c.checkAddOriginVK(m)

	c.finishMessage(m)

	if params.DoVerify {
		s := m.Verify(c.BW())
		if s.Code != bwe.Okay {
			actionCB(bwe.M(s.Code, "Message failed local verification"))
			return
		}
	}
	err = c.VerifyAffinity(m)
	if err == nil { //Local delivery
		actionCB(nil)
		c.cl.List(m, resultCB)
	} else { //Remote delivery
		peer, err := c.GetPeer(m.MVK)
		if err != nil {
			log.Info("Could not deliver to peer: ", err)
			actionCB(bwe.WrapM(bwe.PeerError, "could not peer", err))
			return
		}
		peer.List(m, actionCB, resultCB)
	}
}

type QueryParams struct {
	MVK                []byte
	URISuffix          string
	PrimaryAccessChain *objects.DChain
	RoutingObjects     []objects.RoutingObject
	Expiry             *time.Time
	ExpiryDelta        *time.Duration
	ElaboratePAC       int
	DoVerify           bool
}
type QueryInitialCallback func(err error)
type QueryResultCallback func(m *core.Message)

func (c *BosswaveClient) Query(params *QueryParams,
	actionCB QueryInitialCallback,
	resultCB QueryResultCallback) {
	m, err := c.newMessage(core.TypeQuery, params.MVK, params.URISuffix)
	if err != nil {
		actionCB(err)
		return
	}
	m.PrimaryAccessChain = params.PrimaryAccessChain
	m.RoutingObjects = params.RoutingObjects
	if err := c.doPAC(m, params.ElaboratePAC); err != nil {
		actionCB(err)
		return
	}
	//Add expiry
	if params.ExpiryDelta != nil {
		m.RoutingObjects = append(m.RoutingObjects, objects.CreateNewExpiryFromNow(*params.ExpiryDelta))
	} else if params.Expiry != nil {
		m.RoutingObjects = append(m.RoutingObjects, objects.CreateNewExpiry(*params.Expiry))
	}
	//Check if we need to add an origin VK header
	c.checkAddOriginVK(m)

	c.finishMessage(m)

	if params.DoVerify {
		s := m.Verify(c.BW())
		if s.Code != bwe.Okay {
			actionCB(bwe.M(s.Code, "message failed local verification"))
			return
		}
	}

	err = c.VerifyAffinity(m)
	if err == nil { //Local delivery
		actionCB(nil)
		c.cl.Query(m, func(m *core.Message) {
			if m == nil {
				resultCB(nil)
				return
			}
			sm := m.Verify(c.BW())
			if sm.Code == bwe.Okay {
				resultCB(m)
			} else {
				log.Info("dropping local query result (failed verify)")
			}
		})
	} else { //Remote delivery
		peer, err := c.GetPeer(m.MVK)
		if err != nil {
			log.Info("Could not deliver to peer: ", err)
			actionCB(bwe.WrapM(bwe.PeerError, "could not peer", err))
			return
		}
		peer.Query(m, actionCB, resultCB)
	}
}

type CreateDOTParams struct {
	IsPermission     bool
	To               []byte
	TTL              uint8
	Expiry           *time.Time
	ExpiryDelta      *time.Duration
	Contact          string
	Comment          string
	Revokers         [][]byte
	OmitCreationDate bool

	//For Access
	URISuffix         string
	MVK               []byte
	AccessPermissions string

	//For Permissions
	Permissions map[string]string
}

func (c *BosswaveClient) CreateDOT(p *CreateDOTParams) (*objects.DOT, error) {
	if len(p.To) != 32 {
		return nil, bwe.M(bwe.InvalidSlice, "To VK is bad")
	}
	d := objects.CreateDOT(!p.IsPermission, c.GetUs().GetVK(), p.To)
	d.SetTTL(int(p.TTL))
	d.SetContact(p.Contact)
	d.SetComment(p.Comment)
	if p.ExpiryDelta != nil {
		d.SetExpiry(time.Now().Add(*p.ExpiryDelta))
	} else if p.Expiry != nil {
		d.SetExpiry(*p.Expiry)
	}
	if !p.OmitCreationDate {
		d.SetCreationToNow()
	}
	for _, r := range p.Revokers {
		if len(r) != 32 {
			return nil, bwe.M(bwe.InvalidSlice, "Delegated revoker is bad")
		}
		d.AddRevoker(r)
	}
	if p.IsPermission {
		for k, v := range p.Permissions {
			d.SetPermission(k, v)
		}
	} else {
		d.SetAccessURI(p.MVK, p.URISuffix)
		if !d.SetPermString(p.AccessPermissions) {
			return nil, bwe.M(bwe.BadPermissions, "Permission string is invalid")
		}
	}
	d.Encode(c.GetUs().GetSK())
	return d, nil
}

type CreateDotChainParams struct {
	DOTs         []*objects.DOT
	IsPermission bool
	UnElaborate  bool
}

func (c *BosswaveClient) CreateDOTChain(p *CreateDotChainParams) (*objects.DChain, error) {
	rv, err := objects.CreateDChain(!p.IsPermission, p.DOTs...)
	if err != nil {
		return nil, bwe.WrapM(bwe.BadOperation, "failed to build chain", err)
	}
	if rv == nil {
		panic("This should not happen, please report")
	}
	if p.UnElaborate {
		rv.UnElaborate()
	}
	return rv, nil
}

type CreateEntityParams struct {
	Expiry           *time.Time
	ExpiryDelta      *time.Duration
	Contact          string
	Comment          string
	Revokers         [][]byte
	OmitCreationDate bool
}

func CreateEntity(p *CreateEntityParams) (*objects.Entity, error) {
	e := objects.CreateNewEntity(p.Contact, p.Comment, p.Revokers)
	if p.ExpiryDelta != nil {
		e.SetExpiry(time.Now().Add(*p.ExpiryDelta))
	} else if p.Expiry != nil {
		e.SetExpiry(*p.Expiry)
	}
	if !p.OmitCreationDate {
		e.SetCreationToNow()
	}
	e.Encode()
	return e, nil
}

func (c *BosswaveClient) doPAC(m *core.Message, elaboratePAC int) error {
	//Elaborate PAC
	if elaboratePAC > NoElaboration {
		//fmt.Println("doing elab")
		if m.PrimaryAccessChain == nil {
			return bwe.M(bwe.Unresolvable, "No PAC with elaboration")
		}
		if !m.PrimaryAccessChain.IsElaborated() {
			dc := core.ElaborateDChain(m.PrimaryAccessChain, c.BW())
			if dc == nil {
				return bwe.M(bwe.Unresolvable, "Could not resolve PAC")
			}
			m.RoutingObjects = append(m.RoutingObjects, dc)
		}
		if elaboratePAC > PartialElaboration {
			ok := core.ResolveDotsInDChain(m.PrimaryAccessChain, m.RoutingObjects, c.BW())
			if !ok {
				return bwe.M(bwe.Unresolvable, "dot in PAC unresolvable")
			}
			for i := 0; i < m.PrimaryAccessChain.NumHashes(); i++ {
				d := m.PrimaryAccessChain.GetDOT(i)
				if d != nil {
					m.RoutingObjects = append(m.RoutingObjects, d)
				}
			}
		}
	} else if m.PrimaryAccessChain != nil {
		m.PrimaryAccessChain.UnElaborate()
	}

	if m.PrimaryAccessChain != nil {
		m.RoutingObjects = append(m.RoutingObjects, m.PrimaryAccessChain)
	}
	//TODO remove duplicates in the routing objects, but preserve order.
	return nil
}

func (c *BosswaveClient) getMid() uint64 {
	mid := atomic.AddUint64(&c.mid, 1)
	return mid
}

func (c *BosswaveClient) newMessage(mtype int, mvk []byte, urisuffix string) (*core.Message, error) {
	if c.GetUs() == nil {
		return nil, bwe.M(bwe.NoEntity, "entity not set")
	}
	ovk := c.GetUs().GetVK()
	m := core.Message{Type: uint8(mtype),
		TopicSuffix:    urisuffix,
		MVK:            mvk,
		RoutingObjects: []objects.RoutingObject{},
		PayloadObjects: []objects.PayloadObject{},
		OriginVK:       &ovk,
		MessageID:      c.getMid()}
	valid, star, plus, _, _ := util.AnalyzeSuffix(urisuffix)
	if !valid {
		return nil, bwe.M(bwe.BadURI, "invalid URI")
	} else if len(mvk) != 32 {
		return nil, bwe.M(bwe.BadURI, "bad MVK")
	} else if (star || plus) && (mtype == core.TypePublish || mtype == core.TypePersist) {
		return nil, bwe.M(bwe.BadOperation, "bad OP with wildcard")
	}
	return &m, nil
}

func (c *BosswaveClient) finishMessage(m *core.Message) {
	m.Encode(c.GetUs().GetSK(), c.GetUs().GetVK())
	m.Topic = base64.URLEncoding.EncodeToString(m.MVK) + "/" + m.TopicSuffix
	m.UMid.Mid = m.MessageID
	m.UMid.Sig = binary.LittleEndian.Uint64(m.Signature)
}

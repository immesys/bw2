package api

import (
	"bytes"
	"encoding/base64"
	"encoding/binary"
	"errors"
	"fmt"
	"os"
	"sync/atomic"
	"time"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/internal/util"
	"github.com/immesys/bw2/objects"
)

const (
	NoElaboration      = 0
	PartialElaboration = 1
	FullElaboration    = 2
)

func init() {
	cfg := `
	<seelog>
    <outputs>
        <splitter formatid="common">
            <console/>
            <file path="bw.log"/>
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
type PublishCallback func(status int, msg string)

func (c *BosswaveClient) checkAddOriginVK(m *core.Message) {

	if m.PrimaryAccessChain == nil ||
		m.PrimaryAccessChain.GetReceiverVK() == nil ||
		objects.IsEveryoneVK(m.PrimaryAccessChain.GetReceiverVK()) {
		fmt.Println("Adding an origin VK header")
		ovk := objects.CreateOriginVK(c.us.GetVK())
		m.RoutingObjects = append(m.RoutingObjects, ovk)
		vk := c.us.GetVK()
		m.OriginVK = &vk
	}
}
func (c *BosswaveClient) Publish(params *PublishParams,
	cb PublishCallback) {
	t := core.TypePublish
	if params.Persist {
		t = core.TypePersist
	}
	m, code, msg := c.newMessage(t, params.MVK, params.URISuffix)
	if m == nil {
		cb(code, msg)
		return
	}
	m.PrimaryAccessChain = params.PrimaryAccessChain
	m.RoutingObjects = params.RoutingObjects
	m.PayloadObjects = params.PayloadObjects
	if s, msg := c.doPAC(m, params.ElaboratePAC); s != core.BWStatusOkay {
		cb(s, msg)
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
		log.Info("verifying")
		s := m.Verify()
		if s.Code != core.BWStatusOkay {
			log.Info("verification failed")
			cb(s.Code, "message verification failed")
			return
		} else {
			log.Info("Message verified ok")
		}
	}
	//Probably wanna do shit like determine if this is for remote delivery or local

	err := c.VerifyAffinity(m)
	if err == nil { //Local delivery
		if params.Persist {
			c.cl.Persist(m)
		} else {
			c.cl.Publish(m)
		}
		cb(core.BWStatusOkay, "")
	} else { //Remote delivery
		peer, err := c.GetPeer(m.MVK)
		if err != nil {
			log.Info("Could not deliver to peer: ", err)
			cb(core.BWStatusPeerError, "could not peer")
			return
		}
		peer.PublishPersist(m, cb)
	}

}

func (c *BosswaveClient) VerifyAffinity(m *core.Message) error {
	mvk := m.MVK
	for _, ourMVK := range c.bw.MVKs {
		if bytes.Equal(mvk, ourMVK) {
			return nil
		}
	}
	return errors.New("we are not the designated router for this MVK")
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
type SubscribeInitialCallback func(status int, isNew bool, id core.UniqueMessageID, msg string)
type SubscribeMessageCallback func(m *core.Message)

func (c *BosswaveClient) Subscribe(params *SubscribeParams,
	actionCB SubscribeInitialCallback,
	messageCB SubscribeMessageCallback) {

	m, code, msg := c.newMessage(core.TypeSubscribe, params.MVK, params.URISuffix)
	if m == nil {
		actionCB(code, false, core.UniqueMessageID{}, msg)
		return
	}
	m.PrimaryAccessChain = params.PrimaryAccessChain
	m.RoutingObjects = params.RoutingObjects
	if s, msg := c.doPAC(m, params.ElaboratePAC); s != core.BWStatusOkay {
		actionCB(s, false, core.UniqueMessageID{}, msg)
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
		s := m.Verify()
		if s.Code != core.BWStatusOkay {
			actionCB(s.Code, false, core.UniqueMessageID{}, "see code")
			return
		}
	}

	err := c.VerifyAffinity(m)
	if err == nil { //Local delivery
		subid := c.cl.Subscribe(m, func(m *core.Message, subid core.UniqueMessageID) {
			messageCB(m)
		})
		isNew := subid == m.UMid
		actionCB(core.BWStatusOkay, isNew, subid, "")
	} else { //Remote delivery
		peer, err := c.GetPeer(m.MVK)
		if err != nil {
			log.Info("Could not deliver to peer: ", err)
			actionCB(core.BWStatusPeerError, false, core.UniqueMessageID{}, "could not peer")
			return
		}
		peer.Subscribe(m, actionCB, messageCB)
	}
}

type SetEntityParams struct {
	Keyfile []byte
}

func (c *BosswaveClient) SetEntity(p *SetEntityParams) int {
	if len(p.Keyfile) < 33 {
		return core.BWStatusBadOperation
	}
	e, err := objects.NewEntity(objects.ROEntity, p.Keyfile[32:])
	if err != nil {
		return core.BWStatusBadOperation
	}
	entity := e.(*objects.Entity)
	entity.SetSK(p.Keyfile[:32])
	keysOk := crypto.CheckKeypair(entity.GetSK(), entity.GetVK())
	sigOk := entity.SigValid()
	if !keysOk || !sigOk {
		return core.BWStatusInvalidSig
	}
	c.us = entity
	core.DistributeRO(c.BW().Entity, entity, c.cl)
	return core.BWStatusOkay
}

func (c *BosswaveClient) SetEntityObj(e *objects.Entity) int {
	keysOk := crypto.CheckKeypair(e.GetSK(), e.GetVK())
	sigOk := e.SigValid()
	if !keysOk || !sigOk {
		return core.BWStatusInvalidSig
	}
	c.us = e
	core.DistributeRO(c.BW().Entity, e, c.cl)
	return core.BWStatusOkay
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
type ListInitialCallback func(status int, msg string)
type ListResultCallback func(s string, ok bool)

func (c *BosswaveClient) List(params *ListParams,
	actionCB ListInitialCallback,
	resultCB ListResultCallback) {
	m, code, msg := c.newMessage(core.TypeLS, params.MVK, params.URISuffix)
	if m == nil {
		actionCB(code, msg)
		return
	}
	m.PrimaryAccessChain = params.PrimaryAccessChain
	m.RoutingObjects = params.RoutingObjects
	if s, msg := c.doPAC(m, params.ElaboratePAC); s != core.BWStatusOkay {
		actionCB(s, msg)
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
		s := m.Verify()
		if s.Code != core.BWStatusOkay {
			actionCB(s.Code, "see code")
			return
		}
	}
	err := c.VerifyAffinity(m)
	if err == nil { //Local delivery
		actionCB(core.BWStatusOkay, "")
		c.cl.List(m, resultCB)
	} else { //Remote delivery
		peer, err := c.GetPeer(m.MVK)
		if err != nil {
			log.Info("Could not deliver to peer: ", err)
			actionCB(core.BWStatusPeerError, "could not peer")
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
type QueryInitialCallback func(status int, msg string)
type QueryResultCallback func(m *core.Message)

func (c *BosswaveClient) Query(params *QueryParams,
	actionCB QueryInitialCallback,
	resultCB QueryResultCallback) {
	m, code, msg := c.newMessage(core.TypeQuery, params.MVK, params.URISuffix)
	if m == nil {
		actionCB(code, msg)
		return
	}
	m.PrimaryAccessChain = params.PrimaryAccessChain
	m.RoutingObjects = params.RoutingObjects
	if s, msg := c.doPAC(m, params.ElaboratePAC); s != core.BWStatusOkay {
		actionCB(s, msg)
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
		s := m.Verify()
		if s.Code != core.BWStatusOkay {
			actionCB(s.Code, "see code")
			return
		}
	}

	err := c.VerifyAffinity(m)
	if err == nil { //Local delivery
		actionCB(core.BWStatusOkay, "")
		c.cl.Query(m, resultCB)
	} else { //Remote delivery
		peer, err := c.GetPeer(m.MVK)
		if err != nil {
			log.Info("Could not deliver to peer: ", err)
			actionCB(core.BWStatusPeerError, "could not peer")
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

func (c *BosswaveClient) CreateDOT(p *CreateDOTParams) *objects.DOT {
	if len(p.To) != 32 {
		log.Info("To VK bad")
		return nil
	}
	d := objects.CreateDOT(!p.IsPermission, c.us.GetVK(), p.To)
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
			log.Info("Delegated revoker bad")
			return nil
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
			log.Info("Failed to set access permissions")
			return nil
		}
	}
	d.Encode(c.us.GetSK())
	core.DistributeRO(c.BW().Entity, d, c.cl)
	return d
}

type CreateDotChainParams struct {
	DOTs         []*objects.DOT
	IsPermission bool
	UnElaborate  bool
}

func (c *BosswaveClient) CreateDOTChain(p *CreateDotChainParams) *objects.DChain {
	rv, err := objects.CreateDChain(!p.IsPermission, p.DOTs...)
	if err != nil || rv == nil {
		return nil
	}
	core.DistributeRO(c.BW().Entity, rv, c.cl)
	if p.UnElaborate {
		rv.UnElaborate()
	}
	return rv
}

type CreateEntityParams struct {
	Expiry           *time.Time
	ExpiryDelta      *time.Duration
	Contact          string
	Comment          string
	Revokers         [][]byte
	OmitCreationDate bool
}

func (c *BosswaveClient) CreateEntity(p *CreateEntityParams) *objects.Entity {
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
	core.DistributeRO(c.BW().Entity, e, c.cl)
	return e
}

func (c *BosswaveClient) doPAC(m *core.Message, elaboratePAC int) (int, string) {

	//If there is no explicit PAC, use the first access chain in the ROs
	if m.PrimaryAccessChain == nil {
		for _, ro := range m.RoutingObjects {
			if ro.GetRONum() == objects.ROAccessDChain ||
				ro.GetRONum() == objects.ROAccessDChainHash {
				m.PrimaryAccessChain = ro.(*objects.DChain)
				break
			}
		}
	}
	//Elaborate PAC
	if elaboratePAC > NoElaboration {
		if m.PrimaryAccessChain == nil {
			return core.BWStatusUnresolvable, "No PAC with elaboration"
		}
		if !m.PrimaryAccessChain.IsElaborated() {
			dc := core.ElaborateDChain(m.PrimaryAccessChain)
			if dc == nil {
				return core.BWStatusUnresolvable, "Could not resolve PAC"
			}
			m.RoutingObjects = append(m.RoutingObjects, dc)
		}
		if elaboratePAC > PartialElaboration {
			ok := core.ResolveDotsInDChain(m.PrimaryAccessChain, m.RoutingObjects)
			if !ok {
				return core.BWStatusUnresolvable, "dot in PAC unresolvable"
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
	return core.BWStatusOkay, ""
}

func (c *BosswaveClient) getMid() uint64 {
	mid := atomic.AddUint64(&c.mid, 1)
	return mid
}

func (c *BosswaveClient) newMessage(mtype int, mvk []byte, urisuffix string) (*core.Message, int, string) {
	m := core.Message{Type: uint8(mtype),
		TopicSuffix:    urisuffix,
		MVK:            mvk,
		RoutingObjects: []objects.RoutingObject{},
		PayloadObjects: []objects.PayloadObject{},
		MessageID:      c.getMid()}
	valid, star, plus, _, _ := util.AnalyzeSuffix(urisuffix)
	if !valid {
		return nil, core.BWStatusBadURI, "invalid URI"
	} else if len(mvk) != 32 {
		return nil, core.BWStatusBadURI, "bad MVK"
	} else if (star || plus) && (mtype == core.TypePublish || mtype == core.TypePersist) {
		return nil, core.BWStatusBadOperation, "bad OP with wildcard"
	}
	return &m, core.BWStatusOkay, ""
}

func (c *BosswaveClient) finishMessage(m *core.Message) {
	m.Encode(c.us.GetSK(), c.us.GetVK())
	m.Topic = base64.URLEncoding.EncodeToString(m.MVK) + "/" + m.TopicSuffix
	m.UMid.Mid = m.MessageID
	m.UMid.Sig = binary.LittleEndian.Uint64(m.Signature)
	for _, ro := range m.RoutingObjects {
		core.DistributeRO(c.BW().Entity, ro, c.cl)
	}
}

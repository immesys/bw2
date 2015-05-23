package core

import (
	"bytes"
	"encoding/base64"
	"encoding/binary"
	"errors"
	"fmt"
	"sync/atomic"
	"time"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/internal/store"
	"github.com/immesys/bw2/internal/util"
	"github.com/immesys/bw2/objects"
)

const (
	TypePublish   = 0x01
	TypePersist   = 0x02
	TypeSubscribe = 0x03
	TypeTap       = 0x04
	TypeQuery     = 0x05
	TypeTapQuery  = 0x06
	TypeLS        = 0x07
)

type VerifyState struct {
	Code   uint8
	Reason []byte
}

// Message is the primary Bosswave message type that is passed all the way through
type Message struct {

	//Packed
	Encoded []byte

	//Primary data
	Type           uint8
	MessageID      uint64
	Consumers      int
	MVK            []byte
	TopicSuffix    string
	Signature      []byte
	RoutingObjects []objects.RoutingObject
	PayloadObjects []objects.PayloadObject

	//Derived data, not needed for TX message
	SigCoverEnd        int
	OriginVK           *[]byte
	Valid              bool
	Topic              string
	RXTime             time.Time
	ExpireTime         time.Time
	PrimaryAccessChain *objects.DChain
	status             StatusMessage
	MergedTopic        *string
	UMid               UniqueMessageID
}

//Encode generates the encoded array with signature.
//it assumes that everything is properly set up by the message factory
//that created this message object.
func (m *Message) Encode(sk []byte, vk []byte) {
	//Try cut down on alloc by assuming < 4k
	b := make([]byte, 9, 4096)
	tmp := make([]byte, 8)
	b[0] = byte(m.Type)
	binary.LittleEndian.PutUint64(b[1:], m.MessageID)
	b = append(b, m.MVK...)
	binary.LittleEndian.PutUint16(tmp, uint16(len(m.TopicSuffix)))
	b = append(b, tmp[:2]...)
	b = append(b, []byte(m.TopicSuffix)...)
	switch m.Type {
	case TypePublish, TypePersist:
		b = append(b, byte(m.Consumers))
	}
	for _, ro := range m.RoutingObjects {
		b = append(b, byte(ro.GetRONum()))
		content := ro.GetContent()
		binary.LittleEndian.PutUint16(tmp, uint16(len(content)))
		b = append(b, tmp[:2]...)
		b = append(b, ro.GetContent()...)
	}
	b = append(b, 0)
	for _, po := range m.PayloadObjects {
		binary.LittleEndian.PutUint32(tmp, uint32(po.GetPONum()))
		b = append(b, tmp[:4]...)
		content := po.GetContent()
		binary.LittleEndian.PutUint32(tmp, uint32(len(content)))
		b = append(b, tmp[:4]...)
		b = append(b, content...)
	}
	b = append(b, 0, 0, 0, 0)
	sig := make([]byte, 64)
	crypto.SignBlob(sk, vk, sig, b)
	b = append(b, sig...)
	m.Encoded = b
}

func LoadMessage(b []byte) (m *Message, err error) {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("Bad message: ", r)
			m.Valid = false
			err = r.(error)
		}
	}()
	m = &Message{Encoded: b}

	//Common header
	idx := 0
	m.Type = b[idx]
	m.MessageID = binary.LittleEndian.Uint64(b[idx+1:])
	idx += 8
	m.MVK = b[idx : idx+32]
	idx += 32
	suffixlen := binary.LittleEndian.Uint16(b[idx:])
	m.TopicSuffix = string(b[idx+2 : idx+2+int(suffixlen)])
	idx += int(suffixlen) + 2
	m.Topic = base64.URLEncoding.EncodeToString(m.MVK) + "/" + m.TopicSuffix

	//Read type specific block
	switch m.Type {
	case TypePublish, TypePersist:
		//One additional byte denoting consumer limit
		m.Consumers = int(b[idx])
		idx++
	}

	//We (for Anarchy) persist all RO's we ever see (LOLWUT??!?)
	//Do it marginally in parallel
	rochan := make(chan objects.RoutingObject, 20)
	go func() {
		for ro := range rochan {
			switch ro.GetRONum() {
			case objects.ROAccessDChain, objects.ROPermissionDChain:
				dc := ro.(*objects.DChain)
				store.PutDChain(dc)
			case objects.ROAccessDOT, objects.ROPermissionDOT:
				dot := ro.(*objects.DOT)
				store.PutDOT(dot)

			case objects.ROEntity:
				e := ro.(*objects.Entity)
				store.PutEntity(e)
			}
		}
	}()

	foundprimary := false
	foundorigin := false
	foundexpiry := false
	//Read routing objects
	for b[idx] != 0 {
		RONum := int(b[idx])
		ln := int(binary.LittleEndian.Uint16(b[idx+1:]))
		idx += 3
		ro, err := objects.LoadRoutingObject(RONum, b[idx:idx+ln])
		if err != nil {
			log.Errorf("Got bad routing object: 0x%02x, error: %s", RONum, err)
			idx += ln
			continue
		}
		m.RoutingObjects = append(m.RoutingObjects, ro)
		if !foundprimary && (ro.GetRONum() == objects.ROAccessDChain ||
			ro.GetRONum() == objects.ROAccessDChainHash) {
			foundprimary = true
			m.PrimaryAccessChain = ro.(*objects.DChain)
		}
		if !foundorigin && (ro.GetRONum() == objects.ROOriginVK) {
			ovk := ro.(*objects.OriginVK).GetVK()
			m.OriginVK = &ovk
			foundorigin = true
		}
		if !foundexpiry && (ro.GetRONum() == objects.ROExpiry) {
			exp := ro.(*objects.Expiry)
			m.ExpireTime = exp.GetExpiry()
			foundexpiry = true
		}
		rochan <- ro
		idx += ln
	}
	if !foundexpiry {
		//No expiry
		m.ExpireTime = time.Date(2999, time.January, 1, 0, 0, 0, 0, time.UTC)
	}
	idx++ //Skip final zero
	close(rochan)
	if m.PrimaryAccessChain == nil {
		return nil, errors.New("Missing primary access dchain")
	}
	//Read payload objects
	for {
		PONum := int(binary.LittleEndian.Uint32(b[idx:]))
		idx += 4
		if PONum == 0 {
			break
		}
		ln := int(binary.LittleEndian.Uint32(b[idx:]))
		idx += 4
		po, err := objects.LoadPayloadObject(PONum, b[idx:idx+ln])
		if err != nil {
			log.Errorf("Got bad payload object: %s, error: %s", objects.PONumDotForm(PONum), err)
		}
		m.PayloadObjects = append(m.PayloadObjects, po)
		idx += ln
	}
	//No tag objects in Anarchy

	//This is where the signature stops
	m.SigCoverEnd = idx
	m.Signature = b[idx : idx+64]

	m.UMid.Mid = m.MessageID
	m.UMid.Sig = binary.LittleEndian.Uint64(m.Signature)
	return m, nil
}

func ElaborateDChain(dc *objects.DChain) *objects.DChain {
	if !dc.IsElaborated() {
		//We need to elaborate it ourselves
		nchain, ok := store.GetDChain(dc.GetChainHash())
		if !ok { //Not in our DB
			return nil
		}
		return nchain
	}
	return dc
}

func ResolveDotsInDChain(dc *objects.DChain, cache []objects.RoutingObject) bool {
	if !dc.IsElaborated() {
		panic("Can only augment elaborated chain")
	}
	//Augment the primary dchain by the ro's we got given
	for _, ro := range cache {
		if ro.GetRONum() == objects.ROAccessDOT {
			dc.AugmentBy(ro.(*objects.DOT))
		}
	}
	//Next, resolve any dots that did not exist in the chain
	for i := 0; i < dc.NumHashes(); i++ {
		if dc.GetDOT(i) == nil {
			dot, ok := store.GetDOT(dc.GetDotHash(i))
			if !ok {
				return false
			}
			dc.SetDOT(i, dot)
		}
	}
	return true
}

//AnalyzeAccessDotChain does what it says.
func AnalyzeAccessDOTChain(mtype int, targetURI string, dc *objects.DChain) (code int,
	mvk []byte, mergeduri *string, star, plus bool,
	ps *objects.AccessDOTPermissionSet, originVK []byte) {

	//Next check the chain is connected end to end, check the TTL and construct
	//the merged topic
	mvk = nil
	mergeduri = nil
	ps = nil
	star = false
	plus = false
	originVK = nil

	firstdot := dc.GetDOT(0)
	head := firstdot.GetGiverVK()
	tail := firstdot.GetReceiverVK()
	ttl := firstdot.GetTTL()
	uri, uriok := util.RestrictBy(targetURI, firstdot.GetAccessURISuffix())
	if !uriok {
		code = BWStatusBadURI
		return
	}
	mvk = firstdot.GetAccessURIMVK()
	ps = firstdot.GetPermissionSet()
	if !bytes.Equal(head, mvk) {
		code = BWStatusBadPermissions
		return
	}
	for i := 1; i < dc.NumHashes(); i++ {
		d := dc.GetDOT(i)
		if ttl == 0 {
			code = BWStatusTTLExpired
			return
		}
		ttl--
		ps.ReduceBy(d.GetPermissionSet())
		if d.GetTTL() < ttl {
			ttl = d.GetTTL()
		}
		if !bytes.Equal(tail, d.GetGiverVK()) ||
			!bytes.Equal(mvk, d.GetAccessURIMVK()) {
			code = BWStatusInvalidDOT
			return
		}
		var okay bool
		uri, okay = util.RestrictBy(uri, d.GetAccessURISuffix())
		if !okay {
			code = BWStatusBadPermissions
			return
		}
		tail = d.GetReceiverVK()
	}
	originVK = tail
	mergeduri = &uri
	tValid, star, plus, _, _ := util.AnalyzeSuffix(uri)

	if !tValid {
		log.Criticalf("Didn't expect bad uri after merge: %s", uri)
		code = BWStatusBadURI
		return
	}

	//Now check if the permissions are valid
	switch mtype {
	//Note we really need to work out how persist permissions are going to work
	//(and resource groups too)
	case TypePublish, TypePersist:
		if !ps.CanPublish {
			code = BWStatusBadPermissions
			return
		}
	case TypeQuery, TypeSubscribe:
		if !ps.CanConsume || (plus && !ps.CanConsumePlus) || (star && !ps.CanConsumeStar) {
			code = BWStatusBadPermissions
			return
		}
	case TypeTapQuery, TypeTap:
		if !ps.CanTap || (plus && !ps.CanTapPlus) || (star && !ps.CanTapStar) {
			code = BWStatusBadPermissions
			return
		}
	case TypeLS:
		if !ps.CanList {
			code = BWStatusBadPermissions
			return
		}
	default:
		code = BWStatusBadOperation
		return
	}

	code = BWStatusOkay
	return
}

//A piece of critical documentation:
//There are a few "exceptions" to the obvious rules.
// a) A DOT granting a VK of all zeroes applies to anyone
// b) Any message concerning a topic of mvk/*/$/* is allowed as read only
//    without a DChain. This is used so that clients can discover "free"
//    DOTs or means of acquiring DOTs.
// c) A router exposes its DOTs and entities as
//		  00..00/$/dot/to/<vk>/<hashes>
//      00..00/$/dot/from/<vk>/<hash>
//			00..00/$/dot/from/to/<vk>/<hash>
//		  00..00/$/dot/<hash>
//      00..00/$/entity/<hash>
//    these can be queried or subscribed to.
func (m *Message) Verify() *StatusMessage {
	//Return cached code if you can
	if m.status.Code != BWStatusUnchecked {
		return &m.status
	}
	//This is used as the EVERYONE vk (all zeroes) or the router MVK (all zeroes)
	allzeroes := make([]byte, 32) //ALL vk (zeroes)
	pac := m.PrimaryAccessChain
	//First thing: check the uri for validity
	//the presence of a dollar complicates everything because it
	//allows you to execute queries or subscribes even if the
	//permission process fails
	urivalid, star, plus, uridollar, _ := util.AnalyzeSuffix(m.TopicSuffix)
	//Can't publish to wildcards
	if (star || plus) && (m.Type == TypePublish || m.Type == TypePersist) {
		m.status.Code = BWStatusBadOperation
		return &m.status
	}
	if !urivalid {
		m.status.Code = BWStatusBadURI
		return &m.status
	}

	//These will be populated by the permissions search process
	//only use them if you don't jump to badperm

	//Can't get permissions if there is no access chain
	if pac == nil {
		m.status.Code = BWStatusBadPermissions
		goto badperm
	} else {
		pac = ElaborateDChain(pac)
		if pac == nil {
			m.status.Code = BWStatusUnresolvable
			goto badperm
		}

		ok := ResolveDotsInDChain(pac, m.RoutingObjects)
		if !ok {
			m.status.Code = BWStatusUnresolvable
			goto badperm
		}

		//Check the signature of all the dots. This also checks that their topics are
		//well formed
		if !pac.CheckAllSigs() {
			m.status.Code = BWStatusInvalidDOT
			goto badperm
		}

		//Next check the chain is connected end to end, check the TTL and construct
		//the merged topic
		azCode, azMVK, azURI, _, _, _, azOVK := AnalyzeAccessDOTChain(int(m.Type), m.TopicSuffix, pac)
		if azCode != BWStatusOkay {
			m.status.Code = azCode
			goto badperm
		}
		m.MergedTopic = azURI

		//Check if this is an ALL grant and we don't have an origin VK
		if bytes.Equal(azOVK, allzeroes) {
			if m.OriginVK == nil {
				m.status.Code = BWStatusNoOrigin
				goto badperm
			}
		} else {
			if m.OriginVK == nil {
				m.OriginVK = &azOVK
			}
		}
		//Also check chain MVK matches message
		if !bytes.Equal(m.MVK, azMVK) {
			m.status.Code = BWStatusMVKMismatch
			goto badperm
		}
	}

	//We could be here with failed permissions
	//we still must continue because we might have dollar
	//status
badperm:

	//No dollar, and we hit an error, bail
	if !uridollar && m.status.Code != BWStatusOkay {
		return &m.status
	}

	//Now check if the signature is correct
	if !crypto.VerifyBlob(*m.OriginVK, m.Signature, m.Encoded[:m.SigCoverEnd]) {
		m.status.Code = BWStatusInvalidSig
		//Not even a dollar can save you
		return &m.status
	}

	dollarpath := uridollar && m.status.Code != BWStatusOkay

	//Now check type vs dollar
	switch m.Type {
	case TypePublish, TypePersist:
		if dollarpath {
			m.status.Code = BWStatusBadPermissions
			return &m.status
		}
	case TypeQuery, TypeSubscribe:
		//in this case use the (more powerful) original uri if it is a dollar
		if uridollar {
			m.MergedTopic = &m.TopicSuffix
		}
	case TypeTapQuery, TypeTap:
		if dollarpath {
			m.status.Code = BWStatusBadPermissions
			return &m.status
		}
	case TypeLS:
		//Here too, use the (more powerful) original uri if it is a dollar
		if uridollar {
			m.MergedTopic = &m.TopicSuffix
		}
	default:
		m.status.Code = BWStatusBadOperation
		return &m.status
	}

	m.status.Code = BWStatusOkay
	return &m.status
}

// Message is the primary Bosswave message type that is passed all the way through
type MessageFactory struct {
	m   *Message
	mid uint64
	us  *objects.Entity
}
type ConstructionMessage struct {
	f   *MessageFactory
	m   *Message
	s   *StatusMessage
	bad bool
}

func NewMessageFactory() *MessageFactory {
	epoch := time.Date(2015, time.January, 1, 0, 0, 0, 0, time.UTC)
	//milliseconds since the epoch
	delta := time.Now().Sub(epoch).Nanoseconds() / 1000000
	return &MessageFactory{mid: uint64(delta << 16)}
}
func (f *MessageFactory) GetMid() uint64 {
	mid := atomic.AddUint64(&f.mid, 1)
	return mid
}

//SetEntity sets who we are. It also verifies that the keypair is correct.
//returns false if the entity is invalid
func (f *MessageFactory) SetEntity(e *objects.Entity) bool {
	if !crypto.CheckKeypair(e.GetSK(), e.GetVK()) {
		return false
	}
	f.us = e
	return true
}

func (f *MessageFactory) NewMessage(mtype int, mvk []byte, urisuffix string) *ConstructionMessage {
	m := Message{Type: uint8(mtype),
		TopicSuffix:    urisuffix,
		MVK:            mvk,
		RoutingObjects: []objects.RoutingObject{},
		PayloadObjects: []objects.PayloadObject{},
		MessageID:      f.GetMid()}
	rv := ConstructionMessage{f: f, m: &m}
	valid, star, plus, _, _ := util.AnalyzeSuffix(urisuffix)
	if !valid {
		rv.bail(BWStatusBadURI)
	} else if len(mvk) != 32 {
		rv.bail(BWStatusBadURI)
	} else if (star || plus) && (mtype == TypePublish || mtype == TypePersist) {
		rv.bail(BWStatusBadOperation)
	}
	return &rv
}
func (cm *ConstructionMessage) bail(code int) {
	cm.bad = true
	cm.s.Code = code
}
func (cm *ConstructionMessage) AddRoutingObject(ro objects.RoutingObject) {
	if cm.bad {
		return
	}
	cm.m.RoutingObjects = append(cm.m.RoutingObjects, ro)
}
func (cm *ConstructionMessage) AddPayloadObject(po objects.PayloadObject) {
	if cm.bad {
		return
	}
	cm.m.PayloadObjects = append(cm.m.PayloadObjects, po)
}
func (cm *ConstructionMessage) Ok() (bool, int) {
	return !cm.bad, cm.s.Code
}
func (cm *ConstructionMessage) SetConsumers(v int) {
	if cm.bad {
		return
	}
	//We don't really mind if its the wrong type
	cm.m.Consumers = v
}

//AddDChain will add the given DChain to the message. if elaborate is set, it
//will be included as an elaborated DChain. If includeDOTs is set, the DOTs it
//references will be included (if this router has them)
func (cm *ConstructionMessage) AddDChain(dc *objects.DChain, elaborate bool, includeDOTs bool) {
	if elaborate && !dc.IsElaborated() {
		dc = ElaborateDChain(dc)
		if dc == nil {
			cm.bail(BWStatusUnresolvable)
		}
	}
	if includeDOTs && dc.IsElaborated() {
		for i := 0; i < dc.NumHashes(); i++ {
			d := dc.GetDOT(i)
			if d != nil {
				cm.m.RoutingObjects = append(cm.m.RoutingObjects, d)
			}
		}
	}
	if !elaborate {
		dc.UnElaborate()
	}
	cm.m.RoutingObjects = append(cm.m.RoutingObjects, dc)
}

func (cm *ConstructionMessage) Finish() *Message {
	if cm.bad {
		return nil
	}
	cm.m.Encode(cm.f.us.GetSK(), cm.f.us.GetVK())
	return cm.m
}

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

import (
	"bytes"
	"encoding/base64"
	"encoding/binary"
	"fmt"
	"runtime"
	"time"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util"
	"github.com/immesys/bw2/util/bwe"
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

// This is used for verifying messages
type Resolver interface {
	ResolveDOT(dothash []byte) (*objects.DOT, int, error)
	ResolveEntity(vk []byte) (*objects.Entity, int, error)
	ResolveAccessDChain(chainhash []byte) (*objects.DChain, int, error)
}

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
	m.Signature = sig
	//fmt.Printf("\nSigning message blob len %d\n", len(b))
	//fmt.Println("SK: ", crypto.FmtKey(sk))
	//fmt.Println("VK: ", crypto.FmtKey(vk))
	crypto.SignBlob(sk, vk, sig, b)
	//fmt.Println("Signature: ", crypto.FmtSig(m.Signature))
	m.SigCoverEnd = len(b)
	b = append(b, sig...)
	m.Encoded = b
}

func LoadMessage(b []byte) (m *Message, err error) {
	defer func() {
		if r := recover(); r != nil {
			fbuf := make([]byte, 8000)
			nm := runtime.Stack(fbuf, false)
			fmt.Println("Bad message: ", r)
			fmt.Println(string(fbuf[:nm]))
			m.Valid = false
			err = r.(error)
		}
	}()
	m = &Message{Encoded: b}
	//Common header
	idx := 0
	m.Type = b[idx]
	m.MessageID = binary.LittleEndian.Uint64(b[idx+1:])
	idx += 9
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
		//rochan <- ro
		idx += ln
	}
	if !foundexpiry {
		//No expiry
		m.ExpireTime = time.Date(2999, time.January, 1, 0, 0, 0, 0, time.UTC)
	}
	idx++ //Skip final zero

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

func ElaborateDChain(dc *objects.DChain, res Resolver) *objects.DChain {
	if !dc.IsElaborated() {
		//We need to elaborate it ourselves
		fmt.Println("!!!! chain is not elaborated !!!!")
		nchain, _, err := res.ResolveAccessDChain(dc.GetChainHash())
		if err != nil { //Not in our DB
			return nil
		}
		return nchain
	} else {
		fmt.Println("!!!! PAC chain was elaborated is not elaborated !!!!")
	}
	return dc
}

func ResolveDotsInDChain(dc *objects.DChain, cache []objects.RoutingObject, res Resolver) bool {
	if !dc.IsElaborated() {
		return false
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
			dot, _, err := res.ResolveDOT(dc.GetDotHash(i))
			if err != nil {
				return false
			}
			dc.SetDOT(i, dot)
		}
	}
	return true
}

//AnalyzeAccessDotChain does what it says.
func AnalyzeAccessDOTChain(mtype int, targetURI string, dc *objects.DChain) (err error,
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
		err = bwe.M(bwe.BadURI, "Bad URI "+uri)
		return
	}
	mvk = firstdot.GetAccessURIMVK()
	ps = firstdot.GetPermissionSet()
	if !bytes.Equal(head, mvk) {
		err = bwe.M(bwe.ChainOriginNotMVK, fmt.Sprintf("BadPermissions (mvk) %v != %v", crypto.FmtKey(head), crypto.FmtKey(mvk)))
		return
	}
	for i := 1; i < dc.NumHashes(); i++ {
		d := dc.GetDOT(i)
		if ttl == 0 {
			err = bwe.C(bwe.TTLExpired)
			return
		}
		ttl--
		ps.ReduceBy(d.GetPermissionSet())
		if d.GetTTL() < ttl {
			ttl = d.GetTTL()
		}
		if !bytes.Equal(tail, d.GetGiverVK()) ||
			!bytes.Equal(mvk, d.GetAccessURIMVK()) {
			err = bwe.C(bwe.BadLink)
			return
		}
		var okay bool
		uri, okay = util.RestrictBy(uri, d.GetAccessURISuffix())
		if !okay {
			err = bwe.M(bwe.OverconstrainedURI, "overconstrained URI while merging")
			return
		}
		tail = d.GetReceiverVK()
	}
	originVK = tail
	mergeduri = &uri
	tValid, star, plus, _, _ := util.AnalyzeSuffix(uri)

	if !tValid {
		err = bwe.M(bwe.OverconstrainedURI, "overconstrained URI after merging")
		return
	}

	//Now check if the permissions are valid
	switch mtype {
	//Note we really need to work out how persist permissions are going to work
	//(and resource groups too)
	case TypePublish, TypePersist:
		if !ps.CanPublish {
			err = bwe.M(bwe.BadPermissions, "require P")
			return
		}
	case TypeQuery, TypeSubscribe:
		if !ps.CanConsume || (plus && !ps.CanConsumePlus) || (star && !ps.CanConsumeStar) {
			err = bwe.M(bwe.BadPermissions, "require C")
			return
		}
	case TypeTapQuery, TypeTap:
		if !ps.CanTap || (plus && !ps.CanTapPlus) || (star && !ps.CanTapStar) {
			err = bwe.M(bwe.BadPermissions, "require T")
			return
		}
	case TypeLS:
		if !ps.CanList {
			err = bwe.M(bwe.BadPermissions, "require L")
			return
		}
	default:
		err = bwe.M(bwe.BadOperation, "invalid message type code")
		return
	}

	err = nil
	return
}

//TODO remove the damn status message thing and just use an int
//A piece of critical documentation:
//There are a few "exceptions" to the obvious rules.
// a) A DOT granting a VK of all 0xFF applies to anyone
// b) Any message concerning a topic of mvk/*/$/* is allowed as read only
//    without a DChain. This is used so that clients can discover "free"
//    DOTs or means of acquiring DOTs.
//    these can be queried or subscribed to.
func (m *Message) Verify(res Resolver) *StatusMessage {
	//Return cached code if you can
	if m.status.Code != bwe.Unchecked {
		return &m.status
	}
	//This is used as the EVERYONE vk (all 0xFF) or the router MVK (all 0xFF)
	allgrant := make([]byte, 32)
	for i := range allgrant {
		allgrant[i] = 0xFF
	}
	pac := m.PrimaryAccessChain
	//First thing: check the uri for validity
	//the presence of a dollar complicates everything because it
	//allows you to execute queries or subscribes even if the
	//permission process fails
	urivalid, star, plus, uridollar, _ := util.AnalyzeSuffix(m.TopicSuffix)
	//Can't publish to wildcards
	if (star || plus) && (m.Type == TypePublish || m.Type == TypePersist || m.Type == TypeLS) {
		m.status.Code = bwe.BadOperation
		log.Infof("V: BadOperation (bad wild)")
		return &m.status
	}
	if !urivalid {
		m.status.Code = bwe.BadURI
		return &m.status
	}

	fromMVK := false
	//If message is from MVK it can do whatever it wants
	if m.OriginVK != nil && bytes.Equal(*m.OriginVK, m.MVK) {
		fromMVK = true
		m.status.Code = bwe.Okay
		goto endperm
	}

	//These will be populated by the permissions search process
	//only use them if you don't jump to endperm

	//Can't get permissions if there is no access chain
	if pac == nil {
		log.Infof("V: BadPermissions (no PAC)")
		m.status.Code = bwe.BadPermissions
		goto endperm
	} else {
		pac = ElaborateDChain(pac, res)
		if pac == nil {
			m.status.Code = bwe.Unresolvable
			log.Infof("V: Unresolvable (elaborating chain)")
			goto endperm
		}

		ok := ResolveDotsInDChain(pac, m.RoutingObjects, res)
		if !ok {
			m.status.Code = bwe.Unresolvable
			log.Infof("V: Unresolvable (dots in chain)")
			goto endperm
		}

		//Check the signature of all the dots. This also checks that their topics are
		//well formed
		if !pac.CheckAllSigs() {
			m.status.Code = bwe.InvalidSig
			log.Infof("V: InvalidDOT (dot signature)")
			goto endperm
		}

		//Next check the chain is connected end to end, check the TTL and construct
		//the merged topic
		azErr, azMVK, azURI, _, _, _, azOVK := AnalyzeAccessDOTChain(int(m.Type), m.TopicSuffix, pac)
		//fmt.Println("AZDC says OVK is ", crypto.FmtKey(azOVK))
		if azErr == nil {
			m.status.Code = bwe.Okay
		} else {
			m.status.Code = azErr.(*bwe.BWStatus).Code
			goto endperm
		}
		m.MergedTopic = azURI

		//Check if this is an ALL grant and we don't have an origin VK
		if bytes.Equal(azOVK, allgrant) {
			if m.OriginVK == nil {
				m.status.Code = bwe.NoOrigin
				log.Infof("V: NoOrigin (allgrant, no OVK ro)")
				goto endperm
			}
		} else {
			if m.OriginVK == nil {
				m.OriginVK = &azOVK
			}
		}
		//Also check chain MVK matches message
		if !bytes.Equal(m.MVK, azMVK) {
			m.status.Code = bwe.MVKMismatch
			log.Infof("V: MVKMismatch %v != %v", crypto.FmtKey(m.MVK), crypto.FmtKey(azMVK))
			goto endperm
		}
	}

	//We could be here with failed permissions
	//we still must continue because we might have dollar
	//status
endperm:

	//No dollar, and we hit an error, bail
	if !uridollar && m.status.Code != bwe.Okay {
		return &m.status
	}

	if m.OriginVK == nil {
		log.Criticalf("V: no origin VK on message")
		m.status.Code = bwe.NoOrigin
		return &m.status
	}

	//Now check if the signature is correct
	//fmt.Printf("\nenclen %v, sce %v, siglen %v\n", len(m.Encoded), m.SigCoverEnd, len(m.Signature))
	//fmt.Println("Signature: ", crypto.FmtSig(m.Signature))
	//fmt.Println("VK: ", crypto.FmtKey(*m.OriginVK))
	if !crypto.VerifyBlob(*m.OriginVK, m.Signature, m.Encoded[:m.SigCoverEnd]) {
		m.status.Code = bwe.InvalidSig
		log.Infof("V: InvalidSig (whole sig)")
		//Not even a dollar can save you
		return &m.status
	}

	if fromMVK {
		m.status.Code = bwe.Okay
		return &m.status
	}

	dollarpath := uridollar && m.status.Code != bwe.Okay

	//Now check type vs dollar
	switch m.Type {
	case TypePublish, TypePersist:
		if dollarpath {
			m.status.Code = bwe.BadPermissions
			log.Infof("V: BadPermissions (dollarpath pub)")
			return &m.status
		}
	case TypeQuery, TypeSubscribe:
		//in this case use the (more powerful) original uri if it is a dollar
		if uridollar {
			m.MergedTopic = &m.TopicSuffix
		}
	case TypeTapQuery, TypeTap:
		if dollarpath {
			m.status.Code = bwe.BadPermissions
			log.Infof("V: BadPermissions (dollarpath tap)")
			return &m.status
		}
	case TypeLS:
		//Here too, use the (more powerful) original uri if it is a dollar
		if uridollar {
			m.MergedTopic = &m.TopicSuffix
		}
	default:
		m.status.Code = bwe.BadOperation
		log.Infof("V: BadOperation (type)")
		return &m.status
	}

	//log.Infof("V: OK")
	m.status.Code = bwe.Okay
	return &m.status
}

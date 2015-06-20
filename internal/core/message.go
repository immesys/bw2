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
		log.Infof("AZ: BadURI %v", uri)
		return
	}
	mvk = firstdot.GetAccessURIMVK()
	ps = firstdot.GetPermissionSet()
	if !bytes.Equal(head, mvk) {
		code = BWStatusBadPermissions
		log.Infof("AZ: BadPermissions (mvk) %v != %v", crypto.FmtKey(head), crypto.FmtKey(mvk))
		return
	}
	for i := 1; i < dc.NumHashes(); i++ {
		d := dc.GetDOT(i)
		if ttl == 0 {
			log.Infof("AZ: TTLExpired")
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
			log.Infof("AZ: InvalidDot (chain link mismatch)")
			code = BWStatusInvalidDOT
			return
		}
		var okay bool
		uri, okay = util.RestrictBy(uri, d.GetAccessURISuffix())
		if !okay {
			log.Infof("AZ: BadPermissions (merging URI)")
			code = BWStatusBadPermissions
			return
		}
		tail = d.GetReceiverVK()
	}
	originVK = tail
	mergeduri = &uri
	tValid, star, plus, _, _ := util.AnalyzeSuffix(uri)

	if !tValid {
		log.Infof("AZ: BadURI (merged URI)")
		code = BWStatusBadURI
		return
	}

	//Now check if the permissions are valid
	switch mtype {
	//Note we really need to work out how persist permissions are going to work
	//(and resource groups too)
	case TypePublish, TypePersist:
		if !ps.CanPublish {
			log.Infof("AZ: BadPermissions (ps.pub)")
			code = BWStatusBadPermissions
			return
		}
	case TypeQuery, TypeSubscribe:
		if !ps.CanConsume || (plus && !ps.CanConsumePlus) || (star && !ps.CanConsumeStar) {
			log.Infof("AZ: BadPermissions (ps.consume...)")
			code = BWStatusBadPermissions
			return
		}
	case TypeTapQuery, TypeTap:
		if !ps.CanTap || (plus && !ps.CanTapPlus) || (star && !ps.CanTapStar) {
			log.Infof("AZ: BadPermissions (ps.tap...)")
			code = BWStatusBadPermissions
			return
		}
	case TypeLS:
		if !ps.CanList {
			log.Infof("AZ: BadPermissions (ps.list)")
			code = BWStatusBadPermissions
			return
		}
	default:
		log.Infof("AZ: BadOperation (typecode)")
		code = BWStatusBadOperation
		return
	}

	code = BWStatusOkay
	return
}

//TODO remove the damn status message thing and just use an int
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
	if (star || plus) && (m.Type == TypePublish || m.Type == TypePersist || m.Type == TypeLS) {
		m.status.Code = BWStatusBadOperation
		log.Infof("V: BadOperation (bad wild)")
		return &m.status
	}
	if !urivalid {
		m.status.Code = BWStatusBadURI
		return &m.status
	}

	fromMVK := false
	//If message is from MVK it can do whatever it wants
	if m.OriginVK != nil && bytes.Equal(*m.OriginVK, m.MVK) {
		fromMVK = true
		m.status.Code = BWStatusOkay
		goto endperm
	}

	//These will be populated by the permissions search process
	//only use them if you don't jump to endperm

	//Can't get permissions if there is no access chain
	if pac == nil {
		log.Infof("V: BadPermissions (no PAC)")
		m.status.Code = BWStatusBadPermissions
		goto endperm
	} else {
		pac = ElaborateDChain(pac)
		if pac == nil {
			m.status.Code = BWStatusUnresolvable
			log.Infof("V: Unresolvable (elaborating chain)")
			goto endperm
		}

		ok := ResolveDotsInDChain(pac, m.RoutingObjects)
		if !ok {
			m.status.Code = BWStatusUnresolvable
			log.Infof("V: Unresolvable (dots in chain)")
			goto endperm
		}

		//Check the signature of all the dots. This also checks that their topics are
		//well formed
		if !pac.CheckAllSigs() {
			m.status.Code = BWStatusInvalidDOT
			log.Infof("V: InvalidDOT (dot signature)")
			goto endperm
		}

		//Next check the chain is connected end to end, check the TTL and construct
		//the merged topic
		azCode, azMVK, azURI, _, _, _, azOVK := AnalyzeAccessDOTChain(int(m.Type), m.TopicSuffix, pac)
		//fmt.Println("AZDC says OVK is ", crypto.FmtKey(azOVK))
		m.status.Code = azCode
		if azCode != BWStatusOkay {
			goto endperm
		}
		m.MergedTopic = azURI

		//Check if this is an ALL grant and we don't have an origin VK
		if bytes.Equal(azOVK, allzeroes) {
			if m.OriginVK == nil {
				m.status.Code = BWStatusNoOrigin
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
			m.status.Code = BWStatusMVKMismatch
			log.Infof("V: MVKMismatch %v != %v", crypto.FmtKey(m.MVK), crypto.FmtKey(azMVK))
			goto endperm
		}
	}

	//We could be here with failed permissions
	//we still must continue because we might have dollar
	//status
endperm:

	//No dollar, and we hit an error, bail
	if !uridollar && m.status.Code != BWStatusOkay {
		return &m.status
	}

	if m.OriginVK == nil {
		log.Criticalf("V: no origin VK on message")
		m.status.Code = BWStatusNoOrigin
		return &m.status
	}

	//Now check if the signature is correct
	//fmt.Printf("\nenclen %v, sce %v, siglen %v\n", len(m.Encoded), m.SigCoverEnd, len(m.Signature))
	//fmt.Println("Signature: ", crypto.FmtSig(m.Signature))
	//fmt.Println("VK: ", crypto.FmtKey(*m.OriginVK))
	if !crypto.VerifyBlob(*m.OriginVK, m.Signature, m.Encoded[:m.SigCoverEnd]) {
		m.status.Code = BWStatusInvalidSig
		log.Infof("V: InvalidSig (whole sig)")
		//Not even a dollar can save you
		return &m.status
	}

	if fromMVK {
		m.status.Code = BWStatusOkay
		return &m.status
	}

	dollarpath := uridollar && m.status.Code != BWStatusOkay

	//Now check type vs dollar
	switch m.Type {
	case TypePublish, TypePersist:
		if dollarpath {
			m.status.Code = BWStatusBadPermissions
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
			m.status.Code = BWStatusBadPermissions
			log.Infof("V: BadPermissions (dollarpath tap)")
			return &m.status
		}
	case TypeLS:
		//Here too, use the (more powerful) original uri if it is a dollar
		if uridollar {
			m.MergedTopic = &m.TopicSuffix
		}
	default:
		m.status.Code = BWStatusBadOperation
		log.Infof("V: BadOperation (type)")
		return &m.status
	}

	//log.Infof("V: OK")
	m.status.Code = BWStatusOkay
	return &m.status
}

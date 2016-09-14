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

package objects

import (
	"bytes"
	//	"crypto/ecdsa"
	"crypto/sha256"
	"encoding/base64"
	"encoding/binary"
	"errors"
	"fmt"
	"io"
	//	"math/big"
	"runtime/debug"
	"strconv"
	"time"

	//	"golang.org/x/crypto/sha3"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/util"
	"github.com/immesys/bw2/util/bwe"
	//	"github.com/immesys/bw2bc/common"
	//	ethcrypto "github.com/immesys/bw2bc/crypto"
)

//RoutingObject is the interface that is common among all objects that
//appear in the routing object block
type RoutingObject interface {
	GetRONum() int
	GetContent() []byte
	WriteToStream(w io.Writer, fullObjNum bool) error
	IsPayloadObject() bool
}

type sigState int8

const (
	sigUnchecked = iota
	sigValid
	sigInvalid
)

//RoutingObjectConstruct allows you to map a ROnum into a constructor that takes a
//binary representation and returns a Routing Object
var RoutingObjectConstructor = map[int]func(ronum int, content []byte) (RoutingObject, error){
	ROAccessDChain:         NewDChain,
	ROAccessDChainHash:     NewDChain,
	ROPermissionDChain:     NewDChain,
	ROPermissionDChainHash: NewDChain,
	ROAccessDOT:            NewDOT,
	ROPermissionDOT:        NewDOT,
	ROEntity:               NewEntity,
	ROEntityWKey:           NewEntity,
	ROOriginVK:             NewOriginVK,
	ROExpiry:               NewExpiry,
	RORevocation:           NewRevocation,
}

//LoadRoutingObject takes the ronum and the content and returns the object
func LoadRoutingObject(ronum int, content []byte) (RoutingObject, error) {
	constructor, ok := RoutingObjectConstructor[ronum]
	if !ok {
		return nil, NewObjectError(ronum, "Unknown RONum")
	}
	return constructor(ronum, content)
}

func (ro *DOT) IsPayloadObject() bool {
	return false
}
func (ro *DChain) IsPayloadObject() bool {
	return false
}
func (ro *Entity) IsPayloadObject() bool {
	return false
}

/*
func (ro *Entity) GetAccountHex(index int) (string, error) {
	if ro.sk == nil || len(ro.sk) != 32 {
		return "", bwe.M(bwe.BadOperation, "No signing key for account extrapolation")
	}
	seed := make([]byte, 64)
	copy(seed[0:32], ro.GetSK())
	copy(seed[32:64], common.BigToBytes(big.NewInt(int64(index)), 256))
	rand := sha3.Sum512(seed)
	reader := bytes.NewReader(rand[:])
	privateKeyECDSA, err := ecdsa.GenerateKey(ethcrypto.S256(), reader)
	if err != nil {
		panic(err)
	}
	addr := ethcrypto.PubkeyToAddress(privateKeyECDSA.PublicKey)
	return addr.Hex(), nil
}
*/
// DChain is a list of DOT hashes
type DChain struct {
	dothashes  []byte
	chainhash  []byte
	dots       []*DOT
	isAccess   bool
	ronum      int
	elaborated bool
}

//NewDChain deserialises a DChain from a byte array
func NewDChain(ronum int, content []byte) (rv RoutingObject, err error) {
	defer func() {
		if r := recover(); r != nil {
			err = NewObjectError(ronum, "Bad DChain")
			rv = nil
		}
	}()
	ro := DChain{ronum: ronum}
	switch ronum {
	case ROAccessDChain, ROPermissionDChain:
		if len(content)%32 != 0 || len(content) == 0 {
			log.Warnf("case 1 cl was %v", len(content))
			return nil, NewObjectError(ronum, "Wrong content length")
		}
		ro.dothashes = content
		sum := sha256.Sum256(content)
		ro.chainhash = sum[:]
		ro.isAccess = ronum == 0x02
		ro.elaborated = true
		ro.dots = make([]*DOT, len(content)/32)
		return &ro, nil
	case ROAccessDChainHash, ROPermissionDChainHash:
		if len(content) != 32 {
			log.Warnf("case 2 cl was %v", len(content))
			return nil, NewObjectError(ronum, "Wrong content length: ")
		}
		ro.chainhash = content
		ro.isAccess = ronum == 0x01
		return &ro, nil
	default:
		panic("Should not have reached here")
	}
}

func (ro *DChain) WriteToStream(s io.Writer, fullObjNum bool) error {
	var ln int
	if ro.elaborated {
		ln = len(ro.dothashes)
	} else {
		ln = len(ro.chainhash)
	}
	if fullObjNum {
		//Little endian
		_, err := s.Write([]byte{byte(ro.GetRONum()), 0, 0, 0,
			byte(ln),
			byte(ln >> 8),
			byte(ln >> 16),
			byte(ln >> 24),
		})
		if err != nil {
			return err
		}
	} else {
		_, err := s.Write([]byte{byte(ro.GetRONum()),
			byte(ln),
			byte(ln >> 8),
		})
		if err != nil {
			return err
		}
	}
	if ro.elaborated {
		_, err := s.Write(ro.dothashes)
		if err != nil {
			return err
		}
	} else {
		_, err := s.Write(ro.chainhash)
		if err != nil {
			return err
		}
	}
	return nil
}

func (ro *DChain) GetAccessURISuffix() (string, error) {
	d := ro.dots[0]
	u := d.GetAccessURISuffix()
	for _, d := range ro.dots[1:] {
		nu, ok := util.RestrictBy(u, d.GetAccessURISuffix())
		if !ok {
			return "", errors.New("Chain doesn't grant anything")
		}
		u = nu
	}
	return u, nil
}
func (ro *DChain) GetAccessURIPermString() string {
	adps := ro.dots[0].GetPermissionSet()
	for _, d := range ro.dots[1:] {
		adps.ReduceBy(d.GetPermissionSet())
	}
	return adps.GetPermString()
}
func (ro *DChain) IsAccess() bool {
	return ro.GetRONum() == ROAccessDChain ||
		ro.GetRONum() == ROAccessDChainHash
}

//NumHashes returns the length of the chain
func (ro *DChain) NumHashes() int {
	if ro.elaborated {
		return len(ro.dots)
	}
	panic("DChain not elaborated")
}

// CheckAccessGrants is supposed to verify absolutely everything it can.
// As a quirk, it is written to use external state so it can be used
// for BC and statedb work. It fails if absoulutely ANYTHING is out of
// order.
// it checks
//  - all DOT sigs,
//  - Revocations on srcvk, dstvk, dothash
//  - all dots are access
//  - dots are tail-to-tail
//  - dot expiry against curTimeNs
//  - TTL
//  - all dots grant on MVK (if mvk is zero, fill from first DOT)
//  - final chain gives superset of ADPS and Suffix(if present)
//  - all entity sigs
//  - entity expiry against curTimeNs
//  - given URI suffix is well formed(if present)
//  - the origin of the dchain is the mvk - this might be contentious
// it is my hope that if this method gives the okay, there is nothing
// (save for unknown revocations) that could be wrong
// if curTimeNs is nil, the current system time will be used
// if any of the state functions cannot find, it should return nil
// if status is BWStatusOkay, everything is A-OK,
// if it is BWStatusOkayAsResolved it MIGHT be ok
// it is up to the caller to determine if they need to know that the entities
// are unexpired. Otherwise any entity that fails to resolve is not an error
// but may have been expired and we don't know.
// DOTs must be resolvable so we know they are not expired.
func (ro *DChain) CheckAccessGrants(curTime *time.Time,
	ADPS *AccessDOTPermissionSet, mvk []byte, suffix string,
	getDOT func([]byte) *DOT, getEntity func([]byte) *Entity,
	getRevocations func([]byte) []*Revocation) int {

	//fmt.Println("ATAG 1")
	if curTime == nil {
		t := time.Now()
		curTime = &t
	}
	//fmt.Println("ATAG 2")
	zero := true
	for _, b := range mvk {
		if b != 0 {
			zero = false
		}
	}
	if zero {
		mvkdot := getDOT(ro.GetDotHash(0))
		if mvkdot == nil {
			return bwe.Unresolvable
		}
		mvk = mvkdot.GetGiverVK()
	}
	//fmt.Println("ATAG 3")
	// First augment the chain, checking all DOTs are individually ok
	for i := 0; i < ro.NumHashes(); i++ {
		//fmt.Println("ATAG 4", i)
		dt := getDOT(ro.GetDotHash(i))
		if dt == nil {
			return bwe.Unresolvable
		}
		//fmt.Println("ATAG 5", i)
		// Check DOT signature
		if !dt.SigValid() {
			return bwe.InvalidDOT
		}
		//fmt.Println("ATAG 6", i)
		// Check is access
		if !dt.IsAccess() {
			return bwe.NotAccessRO
		}
		//fmt.Println("ATAG 7", i)
		// Check is unexpired
		if dt.GetExpiry() != nil && dt.GetExpiry().Before(*curTime) {
			return bwe.ExpiredDOT
		}
		//fmt.Println("ATAG 8", i)
		// Check grants on MVK
		if !bytes.Equal(dt.GetAccessURIMVK(), mvk) {
			return bwe.MVKMismatch
		}
		//fmt.Println("ATAG 9", i)
		//fmt.Println("ATAG 9.2", i, dt.GetHash())
		// Check for DOT revocation
		for _, r := range getRevocations(dt.GetHash()) {
			//fmt.Println("ATAG 10", i)
			if r.IsValidFor(dt) {
				return bwe.RevokedDOT
			}
		}
		ro.AugmentBy(dt)
	}
	//fmt.Println("ATAG 10.5")
	ovk := ro.GetDOT(0).GetGiverVK()
	//fmt.Println("ATAG 11")
	// Check OVK is MVK
	if !bytes.Equal(ovk, mvk) {
		return bwe.ChainOriginNotMVK
	}
	tail := ro.GetDOT(0).GetReceiverVK()
	//fmt.Println("ATAG 12")
	entitiesToCheck := [][]byte{ro.GetDOT(0).GetGiverVK(), ro.GetDOT(0).GetReceiverVK()}
	//fmt.Println("ATAG 13")
	// Then check all DOTs are end-to-end and rest of entities are ok
	for i := 1; i < ro.NumHashes(); i++ {
		//fmt.Println("ATAG 14", i, crypto.FmtKey(ro.GetDOT(i).GetGiverVK()), crypto.FmtKey(ro.GetDOT(i).GetReceiverVK()))
		if !bytes.Equal(tail, ro.GetDOT(i).GetGiverVK()) {
			//fmt.Println("ATAG 15")
			return bwe.BadLink
		}
		//fmt.Println("ATAG 15", i
		entitiesToCheck = append(entitiesToCheck, ro.GetDOT(i).GetReceiverVK())
		tail = ro.GetDOT(i).GetReceiverVK()
	}

	// Check entities
	unresolvedEntities := false
	//fmt.Println("ATAG 16")
	for _, vk := range entitiesToCheck {
		//fmt.Println("ATAG 17", i)
		e := getEntity(vk)
		if e == nil {
			unresolvedEntities = true
			continue
		}
		//fmt.Println("ATAG 18", i)
		if !e.SigValid() {
			return bwe.InvalidEntity
		}
		//fmt.Println("ATAG 18", i)
		if e.GetExpiry() != nil {
			if e.GetExpiry().Before(*curTime) {
				return bwe.ExpiredEntity
			}
		}
		for _, r := range getRevocations(e.GetVK()) {
			if r.IsValidFor(e) {
				return bwe.RevokedEntity
			}
		}
	}
	//fmt.Println("ATAG 25")
	// Check TTL
	ttl := 255
	for i := 0; i < ro.NumHashes(); i++ {
		if ttl == 0 {
			return bwe.TTLExpired
		}
		ttl--
		if ro.GetDOT(i).GetTTL() < ttl {
			ttl = ro.GetDOT(i).GetTTL()
		}
	}
	//fmt.Println("ATAG 26")
	// Calc ADPS
	for i := 0; i < ro.NumHashes(); i++ {
		ADPS.ReduceBy(ro.GetDOT(i).GetPermissionSet())
	}

	nosuffix := suffix == ""
	if nosuffix {
		//fmt.Println("ATAG 27")
		suffix = "*"
	}
	//fmt.Println("ATAG 28")
	//fmt.Println("nosuffix %v suffix %v\n", nosuffix, suffix)
	// Chcek suffix well formed
	// Note that the stars/plusses etc in the URI are NOT
	// relevant to the ADPS because this is about granting.
	// granting foo/* has nothing to do with P*C*
	valid, _, _, _ := util.AnalyzeSuffix(suffix)
	if !valid {
		//fmt.Println("Analysis disliked")
		return bwe.BadURI
	}
	uri := suffix
	//fmt.Println("ATAG 30")
	// Calc URI
	for i := 0; i < ro.NumHashes(); i++ {
		nuri, ok := util.RestrictBy(uri, ro.GetDOT(i).GetAccessURISuffix())
		if !ok {
			//fmt.Println("ATAG 31")
			return bwe.OverconstrainedURI
		}
		uri = nuri
	}
	//fmt.Println("ATAG 32")
	// The suffix will not have gotten MORE permissive, so any change is bad
	if !nosuffix && suffix != uri {
		return bwe.BadPermissions
	}
	//fmt.Println("ATAG 33")
	if unresolvedEntities {
		return bwe.OkayAsResolved
	}
	return bwe.Okay
}

//AugmentBy fills the given dot into the right position in the chain
//assuming it is referred to at all
func (ro *DChain) AugmentBy(d *DOT) {
	for i := 0; i < ro.NumHashes(); i++ {
		if bytes.Equal(ro.GetDotHash(i), d.GetHash()) {
			ro.dots[i] = d
		}
	}
}

func (ro *DChain) GetTTL() int {
	ttl := 256
	for _, d := range ro.dots {
		ttl -= 1
		if d.GetTTL() < ttl {
			ttl = d.GetTTL()
		}
	}
	return ttl
}

func (ro *DChain) GetMVK() []byte {
	return ro.dots[0].GetAccessURIMVK()
}

//SetDOT sets the specific DOT
func (ro *DChain) SetDOT(num int, d *DOT) {
	ro.dots[num] = d
}

//GetDOT returns the DOT at the given index if it has been
//stored in the chain, otherwise nil
func (ro *DChain) GetDOT(num int) *DOT {
	return ro.dots[num]
}

//GetDotHash returns the dot hash at the specific index
func (ro *DChain) GetDotHash(num int) []byte {
	return ro.dothashes[num*32 : (num+1)*32]
}

//GetChainHash returns the hash of the chain
func (ro *DChain) GetChainHash() []byte {
	return ro.chainhash
}

//IsElaborated returns true if the dot hashes are populated
func (ro *DChain) IsElaborated() bool {
	return ro.elaborated
}

//GetRONum returns the RONum for this object
func (ro *DChain) GetRONum() int {
	if ro.elaborated {
		if ro.isAccess {
			return ROAccessDChain
		}
		return ROPermissionDChain
	}
	if ro.isAccess {
		return ROAccessDChainHash
	}
	return ROPermissionDChainHash
}

func (ro *DChain) GetGiverVK() []byte {
	if !ro.IsElaborated() || ro.GetDOT(0) == nil {
		return nil
	}
	return ro.GetDOT(0).GetGiverVK()
}

func (ro *DChain) GetReceiverVK() []byte {
	ln := ro.NumHashes()
	if !ro.IsElaborated() || ro.GetDOT(ln-1) == nil {
		return nil
	}
	return ro.GetDOT(ln - 1).GetReceiverVK()
}

func (ro *DChain) UnElaborate() {
	ro.elaborated = false
	ro.ronum = ro.GetRONum()
}

//GetContent returns the serialised content for this object
func (ro *DChain) GetContent() []byte {
	switch ro.ronum {
	case ROAccessDChain, ROPermissionDChain:
		return ro.dothashes
	case ROAccessDChainHash, ROPermissionDChainHash:
		return ro.chainhash
	default:
		panic("Invalid RONUM")
	}
}

func (ro *DChain) CheckAllSigs() bool {
	for i := 0; i < ro.NumHashes(); i++ {
		if ro.GetDOT(i) == nil || !ro.GetDOT(i).SigValid() {
			return false
		}
	}
	return true
}

//CreateDChain creates a dot chain from the given DOTs. The DOTs must have
//the hash field populated
func CreateDChain(access bool, dots ...*DOT) (*DChain, error) {
	rv := &DChain{
		dothashes:  make([]byte, len(dots)*32),
		chainhash:  make([]byte, 32),
		dots:       dots,
		isAccess:   access,
		elaborated: true,
	}
	for i, v := range dots {
		copy(rv.dothashes[i*32:(i+1)*32], v.hash)
		if v.isAccess != access {
			return nil, NewObjectError(-1, "DOT/DChain access mismatch")
		}
	}
	hash := sha256.Sum256(rv.dothashes)
	rv.chainhash = hash[:]
	if access {
		rv.ronum = ROAccessDChain
	} else {
		rv.ronum = ROPermissionDChain
	}
	return rv, nil
}

//ConvertToDChainHash creates a hash RO from a dchain RO that may or may not
//be fully elaborated. Note that there are shared resources in the result
func (ro *DChain) ConvertToDChainHash() (*DChain, error) {
	if len(ro.chainhash) != 32 {
		return nil, NewObjectError(-1, "Cannot convert: no chainhash")
	}
	rv := &DChain{
		chainhash: ro.chainhash,
		isAccess:  ro.isAccess,
	}
	if ro.isAccess {
		rv.ronum = ROAccessDChainHash
	} else {
		rv.ronum = ROPermissionDChainHash
	}
	return rv, nil
}

//PublishLimits is an option found in an AccessDOT that governs
//the resources that may be used by messages authorised via the DOT
type PublishLimits struct {
	TxLimit    int64
	StoreLimit int64
	Retain     int
}

func (p *PublishLimits) toBytes() []byte {
	rv := make([]byte, 17)
	binary.LittleEndian.PutUint64(rv, uint64(p.TxLimit))
	binary.LittleEndian.PutUint64(rv, uint64(p.StoreLimit))
	rv[16] = byte(p.Retain)
	return rv
}

//DOT is a declaration of trust. This is a shared object that implements
//both an access dot and a permission dot
type DOT struct {
	content    []byte
	hash       []byte
	giverVK    []byte //VK
	receiverVK []byte
	expires    *time.Time
	created    *time.Time
	revokers   [][]byte
	contact    string
	comment    string
	signature  []byte
	isAccess   bool
	ttl        int
	sigok      sigState

	//Only for ACCESS dot
	mVK            []byte
	uriSuffix      string
	uri            string
	pubLim         *PublishLimits
	canPublish     bool
	canConsume     bool
	canConsumePlus bool
	canConsumeStar bool
	canTap         bool
	canTapPlus     bool
	canTapStar     bool
	canList        bool

	//Only for Permission dot
	kv map[string]string

	//This is for users to cache, none of the code here
	//populates these nor are they guaranteed to be correct
	GiverEntity    *Entity
	ReceiverEntity *Entity
}

type AccessDOTPermissionSet struct {
	CanPublish     bool
	CanConsume     bool
	CanConsumePlus bool
	CanConsumeStar bool
	CanTap         bool
	CanTapPlus     bool
	CanTapStar     bool
	CanList        bool
}

// This is not the encoding used on the wire, but it is used on the BC
func (ps *AccessDOTPermissionSet) Encode() []byte {
	rv := make([]byte, 8)
	if ps.CanPublish {
		rv[0] = 1
	}
	if ps.CanConsume {
		rv[1] = 1
	}
	if ps.CanConsumePlus {
		rv[2] = 1
	}
	if ps.CanConsumeStar {
		rv[3] = 1
	}
	if ps.CanTap {
		rv[4] = 1
	}
	if ps.CanTapPlus {
		rv[5] = 1
	}
	if ps.CanTapStar {
		rv[6] = 1
	}
	if ps.CanList {
		rv[7] = 1
	}
	return rv
}
func DecodeADPS(raw []byte) *AccessDOTPermissionSet {
	rv := AccessDOTPermissionSet{
		CanPublish:     raw[0] == 1,
		CanConsume:     raw[1] == 1,
		CanConsumePlus: raw[2] == 1,
		CanConsumeStar: raw[3] == 1,
		CanTap:         raw[4] == 1,
		CanTapPlus:     raw[5] == 1,
		CanTapStar:     raw[6] == 1,
		CanList:        raw[7] == 1,
	}
	return &rv
}
func (ps *AccessDOTPermissionSet) ReduceBy(rhs *AccessDOTPermissionSet) {
	ps.CanPublish = ps.CanPublish && rhs.CanPublish
	ps.CanConsume = ps.CanConsume && rhs.CanConsume
	ps.CanConsumePlus = ps.CanConsumePlus && rhs.CanConsumePlus && rhs.CanConsume
	ps.CanConsumeStar = ps.CanConsumeStar && rhs.CanConsumeStar && rhs.CanConsumePlus && rhs.CanConsume
	ps.CanTap = ps.CanTap && rhs.CanTap
	ps.CanTapPlus = ps.CanTapPlus && rhs.CanTapPlus && rhs.CanTap
	ps.CanTapStar = ps.CanTapStar && rhs.CanTapStar && rhs.CanTapPlus && rhs.CanTap
	ps.CanList = ps.CanList && rhs.CanList
}

func (ps *AccessDOTPermissionSet) IsSubsetOf(rhs *AccessDOTPermissionSet) bool {
	return !(ps.CanPublish && !rhs.CanPublish ||
		ps.CanConsume && !rhs.CanConsume ||
		ps.CanConsumePlus && !rhs.CanConsumePlus ||
		ps.CanConsumeStar && !rhs.CanConsumeStar ||
		ps.CanTap && !rhs.CanTap ||
		ps.CanTapPlus && !rhs.CanTapPlus ||
		ps.CanTapStar && !rhs.CanTapStar ||
		ps.CanList && !rhs.CanList)
}

func GetADPSFromPermString(v string) *AccessDOTPermissionSet {
	ro := &AccessDOTPermissionSet{}
	for len(v) > 0 {
		switch v[0] {
		case 'C', 'c':
			ro.CanConsume = true
			if len(v) > 1 && v[1] == '*' {
				ro.CanConsumeStar = true
				ro.CanConsumePlus = true
				v = v[2:]
				continue
			}
			if len(v) > 1 && v[1] == '+' {
				ro.CanConsumePlus = true
				v = v[2:]
				continue
			}
			v = v[1:]
			continue
		case 'P', 'p':
			ro.CanPublish = true
			v = v[1:]
			continue
		case 'T', 't':
			ro.CanTap = true
			if len(v) > 1 && v[1] == '*' {
				ro.CanTapStar = true
				ro.CanTapPlus = true
				v = v[2:]
				continue
			}
			if len(v) > 1 && v[1] == '+' {
				ro.CanTapPlus = true
				v = v[2:]
				continue
			}
			v = v[1:]
			continue
		case 'L', 'l':
			ro.CanList = true
			v = v[1:]
			continue
		default:
			log.Infof("Hit default permstring case: %v", v[0])
			return nil
		}
	}
	return ro
}
func (ps *AccessDOTPermissionSet) GetPermString() string {
	rv := ""
	if ps.CanConsumeStar {
		rv += "C*"
	} else if ps.CanConsumePlus {
		rv += "C+"
	} else if ps.CanConsume {
		rv += "C"
	}
	if ps.CanTapStar {
		rv += "T*"
	} else if ps.CanTapPlus {
		rv += "T+"
	} else if ps.CanTap {
		rv += "T"
	}
	if ps.CanPublish {
		rv += "P"
	}
	if ps.CanList {
		rv += "L"
	}
	return rv
}

//NewDOT constructs a DOT from its packed form
func NewDOT(ronum int, content []byte) (rv RoutingObject, err error) {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println(r)
			debug.PrintStack()
			err = NewObjectError(ronum, "Bad DoT")
			rv = nil
		}
	}()

	idx := 0
	ro := DOT{
		giverVK:    content[0:32],
		receiverVK: content[32:64],
		ttl:        int(content[64]),
		revokers:   make([][]byte, 0),
		kv:         make(map[string]string),
		content:    content,
	}

	//Sentinel: added so that a malicious attacker cannot replay an access
	//dot as a permission dot and vice versa
	if (content[65] != 0x01 && ronum == ROAccessDOT) ||
		(content[65] != 0x02 && ronum == ROPermissionDOT) {
		return nil, NewObjectError(ronum, "Bad DoT")
	}

	idx = 66
	for {
		switch content[idx] {
		case 0x01: //Publish limits
			if content[idx+1] != 17 {
				return nil, NewObjectError(ronum, "Invalid publim in DoT")
			}
			idx += 2
			ro.pubLim = &PublishLimits{
				TxLimit:    int64(binary.LittleEndian.Uint64(content[idx:])),
				StoreLimit: int64(binary.LittleEndian.Uint64(content[idx+8:])),
				Retain:     int(content[idx+16]),
			}
			idx += 17
		case 0x02: //Creation date
			if content[idx+1] != 8 {
				return nil, NewObjectError(ronum, "Invalid creation date in DoT")
			}
			idx += 2
			t := time.Unix(0, int64(binary.LittleEndian.Uint64(content[idx:])))
			ro.created = &t
			idx += 8
		case 0x03: //Expiry date
			if content[idx+1] != 8 {
				return nil, NewObjectError(ronum, "Invalid expiry date in DoT")
			}
			idx += 2
			t := time.Unix(0, int64(binary.LittleEndian.Uint64(content[idx:])))
			ro.expires = &t
			idx += 8
		case 0x04: //Delegated revoker
			if content[idx+1] != 32 {
				return nil, NewObjectError(ronum, "Invalid delegated revoker in DoT")
			}
			idx += 2
			ro.revokers = append(ro.revokers, content[idx:idx+32])
			idx += 32
		case 0x05: //contact
			ln := int(content[idx+1])
			ro.contact = string(content[idx+2 : idx+2+ln])
			idx += 2 + ln
		case 0x06: //Comment
			ln := int(content[idx+1])
			ro.comment = string(content[idx+2 : idx+2+ln])
			idx += 2 + ln
		case 0x00: //End
			idx++
			goto done
		default: //Skip unknown header
			fmt.Println("Unknown DoT header type: ", content[idx])
			idx += int(content[idx+1]) + 1

		}
	}
done:
	if ronum == ROAccessDOT {
		ro.isAccess = true
		perm := binary.LittleEndian.Uint16(content[idx:])
		idx += 2
		if perm&0x0001 != 0 {
			ro.canConsume = true
		}
		if perm&0x0002 != 0 {
			ro.canConsumePlus = true
			ro.canConsume = true
		}
		if perm&0x0004 != 0 {
			ro.canConsumeStar = true
			ro.canConsumePlus = true
			ro.canConsume = true
		}
		if perm&0x0008 != 0 {
			ro.canTap = true
		}
		if perm&0x0010 != 0 {
			ro.canTapPlus = true
			ro.canTap = true
		}
		if perm&0x0020 != 0 {
			ro.canTapStar = true
			ro.canTapPlus = true
			ro.canTap = true
		}
		if perm&0x0040 != 0 {
			ro.canPublish = true
		}
		if perm&0x0080 != 0 {
			ro.canList = true
		}

		ro.mVK = content[idx : idx+32]
		idx += 32
		ln := int(binary.LittleEndian.Uint16(content[idx:]))
		idx += 2
		ro.uriSuffix = string(content[idx : idx+ln])
		ro.uri = base64.URLEncoding.EncodeToString(ro.mVK) + "/" + ro.uriSuffix
		idx += ln
	} else if ronum == ROPermissionDOT {
		//Parse Key value
		for {
			keylen := int(content[idx])
			if keylen == 0 {
				idx++
				break
			}
			key := string(content[idx+1 : idx+1+keylen])
			idx += 1 + keylen
			valLen := int(binary.LittleEndian.Uint16(content[idx:]))
			val := string(content[idx+2 : idx+2+valLen])
			idx += 2 + valLen
			ro.kv[key] = val
		}
	} else {
		return nil, NewObjectError(ronum, "Unknown RONum")
	}
	hash := sha256.Sum256(content[0:idx])
	ro.hash = hash[:]
	ro.signature = content[idx : idx+64]
	return &ro, nil
}

func (ro *DOT) WriteToStream(s io.Writer, fullObjNum bool) error {
	if len(ro.content) == 0 {
		return NewObjectError(ro.GetRONum(), "Cannot write to stream: no content")
	}
	ln := len(ro.content)
	if fullObjNum {
		//Little endian
		_, err := s.Write([]byte{byte(ro.GetRONum()), 0, 0, 0,
			byte(ln),
			byte(ln >> 8),
			byte(ln >> 16),
			byte(ln >> 24),
		})
		if err != nil {
			return err
		}
	} else {
		_, err := s.Write([]byte{byte(ro.GetRONum()),
			byte(ln),
			byte(ln >> 8),
		})
		if err != nil {
			return err
		}
	}
	_, err := s.Write(ro.content)
	return err
}

func (ro *DOT) IsExpired() bool {
	if ro.expires != nil {
		return ro.expires.Before(time.Now())
	}
	return false
}
func (ro *DOT) SetComment(v string) {
	ro.comment = v
}

func (ro *DOT) GetComment() string {
	return ro.comment
}

func (ro *DOT) GetContact() string {
	return ro.contact
}

func (ro *DOT) GetRevokers() [][]byte {
	return ro.revokers
}

func (ro *DOT) GetExpiry() *time.Time {
	return ro.expires
}

func (ro *DOT) GetCreated() *time.Time {
	return ro.created
}

func (ro *DOT) SetContact(v string) {
	ro.contact = v
}

//GetHash returns the dot hash or panics if it has not been set
//by encoding/reading from stream etc.
func (ro *DOT) GetHash() []byte {
	if len(ro.hash) == 0 {
		panic("Badness")
	}
	return ro.hash
}

func (ro *DOT) GetPermissionSet() *AccessDOTPermissionSet {
	if !ro.isAccess {
		panic("Should be an access DOT")
	}
	return &AccessDOTPermissionSet{
		CanPublish:     ro.canPublish,
		CanConsume:     ro.canConsume,
		CanConsumePlus: ro.canConsumePlus,
		CanConsumeStar: ro.canConsumeStar,
		CanTap:         ro.canTap,
		CanTapPlus:     ro.canTapPlus,
		CanTapStar:     ro.canTapStar,
		CanList:        ro.canList,
	}
}

func (ro *DOT) AddRevoker(rvk []byte) {
	ro.revokers = append(ro.revokers, rvk)
}

//SigValid returns if the DOT's signature is valid. This only checks
//the signature on the first call, so the content must not change
//after encoding for this to be valid. As a plus it also verifies that
//the topic is sane
func (ro *DOT) SigValid() bool {
	if ro.sigok == sigValid {
		return true
	} else if ro.sigok == sigInvalid {
		return false
	}
	uriSane, _, _, _ := util.AnalyzeSuffix(ro.uriSuffix)
	if !uriSane {
		ro.sigok = sigInvalid
		return false
	}
	if len(ro.signature) != 64 || len(ro.content) == 0 {
		panic("DOT in invalid state")
	}
	ok := VerifyBlob(ro.giverVK, ro.signature, ro.content[:len(ro.content)-64])
	if ok {
		ro.sigok = sigValid
		return true
	}
	ro.sigok = sigInvalid
	return false
}

//OverrideSetSigValid sets this dots signature as valid without checking it
//this is used if the DOT is known good (say from the store)
func (ro *DOT) OverrideSetSignatureValid() {
	ro.sigok = sigValid
}

//SetCanConsume sets the consume privileges on an access dot
func (ro *DOT) SetCanConsume(normal bool, plus bool, star bool) {
	if !ro.isAccess {
		panic("Not an access DOT")
	}
	plus = plus || star
	normal = normal || plus
	ro.canConsume = normal
	ro.canConsumePlus = plus
	ro.canConsumeStar = star
}

//SetCreation sets the creation timestamp on the DOT
func (ro *DOT) SetCreation(time time.Time) {
	ro.created = &time
}

//SetCreationToNow sets the creation timestamp to the current time
func (ro *DOT) SetCreationToNow() {
	t := time.Now().UnixNano()
	to := time.Unix(0, t)
	ro.created = &to
}

//Check is vk is all zeroes
func IsEveryoneVK(vk []byte) bool {
	return bytes.Equal(vk, util.EverybodySlice)
}

//SetExpiry sets the expiry time to the given time
func (ro *DOT) SetExpiry(time time.Time) {
	ro.expires = &time
}

//SetExpireFromNow is a convenience function that sets the creation time
//to now, and sets the expiry to the given delta from the creation time
func (ro *DOT) SetExpireFromNow(delta time.Duration) {
	ro.SetCreationToNow()
	e := ro.created.Add(delta)
	ro.expires = &e
}

//SetCanTap sets the tap capability on an access dot
func (ro *DOT) SetCanTap(normal bool, plus bool, star bool) {
	if !ro.isAccess {
		panic("Not an access DOT")
	}
	plus = plus || star
	normal = normal || plus
	ro.canTap = normal
	ro.canTapPlus = plus
	ro.canTapStar = star
}

//SetCanPublish sets the publish capability on an access DOT
func (ro *DOT) SetCanPublish(value bool) {
	if !ro.isAccess {
		panic("Not an access DOT")
	}
	ro.canPublish = value
}

//SetCanList sets the list capability on an access DOT
func (ro *DOT) SetCanList(value bool) {
	if !ro.isAccess {
		panic("Not an access DOT")
	}
	ro.canList = value
}

//CreateDOT is used to create a DOT from scratch. The DOT is incomplete until
//Encode() is called later.
func CreateDOT(isAccess bool, giverVK []byte, receiverVK []byte) *DOT {
	rv := DOT{isAccess: isAccess, giverVK: giverVK, receiverVK: receiverVK, kv: make(map[string]string), revokers: make([][]byte, 0)}
	return &rv
}

//GetRONum returns the ronum of the dot
func (ro *DOT) GetRONum() int {
	if ro.isAccess {
		return ROAccessDOT
	}
	return ROPermissionDOT
}

func (ro *DOT) IsAccess() bool {
	return ro.isAccess
}

//GetContent returns the binary representation of the DOT if Encode has been called
func (ro *DOT) GetContent() []byte {
	if len(ro.content) == 0 {
		panic("Bad content")
	}
	return ro.content
}

//SetAccessURI sets the URI of an Access DOT
func (ro *DOT) SetAccessURI(mvk []byte, suffix string) {
	if !ro.isAccess {
		panic("Should be an access DOT")
	}
	ro.mVK = mvk
	ro.uriSuffix = suffix
	ro.uri = base64.URLEncoding.EncodeToString(ro.mVK) + "/" + ro.uriSuffix
}

//GetAccessURISuffix returns the suffix if this is an access DOT
func (ro *DOT) GetAccessURISuffix() string {
	if !ro.isAccess {
		panic("Should be an access DOT")
	}
	return ro.uriSuffix
}

//GetAccessURIMVK gets the mvk if this is an access DOT
func (ro *DOT) GetAccessURIMVK() []byte {
	if !ro.isAccess {
		panic("Should be an access DOT")
	}
	return ro.mVK
}

//SetPermission sets the given key in a Permission DOT's table
func (ro *DOT) SetPermission(key string, value string) {
	if ro.isAccess {
		panic("Should be a permission DOT")
	}
	if len(key) > 255 || len(value) > 65535 {
		panic("Permission is too big")
	}
	ro.kv[key] = value
}

//GetTTL gets the TTL of a DOT
func (ro *DOT) GetTTL() int {
	return ro.ttl
}

//SetTTL sets the TTL of a dot
func (ro *DOT) SetTTL(v int) {
	if v < 0 || v > 255 {
		panic("Bad TTL")
	}
	ro.ttl = v
}

//GetPermString gets the human readable permission string for an access dot
func (ro *DOT) GetPermString() string {
	if !ro.isAccess {
		panic("Should be an access DOT")
	}
	rv := ""
	if ro.canConsumeStar {
		rv += "C*"
	} else if ro.canConsumePlus {
		rv += "C+"
	} else if ro.canConsume {
		rv += "C"
	}
	if ro.canTapStar {
		rv += "T*"
	} else if ro.canTapPlus {
		rv += "T+"
	} else if ro.canTap {
		rv += "T"
	}
	if ro.canPublish {
		rv += "P"
	}
	if ro.canList {
		rv += "L"
	}
	return rv
}

//SetPermString sets the permissions of this (access) dot.
//it returns true on success, false if the string is bad or this was
//not an access dot
func (ro *DOT) SetPermString(v string) bool {
	if !ro.isAccess {
		return false
	}
	ro.canConsume = false
	ro.canConsumePlus = false
	ro.canConsumeStar = false
	ro.canList = false
	ro.canPublish = false
	ro.canTap = false
	ro.canTapPlus = false
	ro.canTapStar = false
	for len(v) > 0 {
		switch v[0] {
		case 'C', 'c':
			ro.canConsume = true
			if len(v) > 1 && v[1] == '*' {
				ro.canConsumeStar = true
				ro.canConsumePlus = true
				v = v[2:]
				continue
			}
			if len(v) > 1 && v[1] == '+' {
				ro.canConsumePlus = true
				v = v[2:]
				continue
			}
			v = v[1:]
			continue
		case 'P', 'p':
			ro.canPublish = true
			v = v[1:]
			continue
		case 'T', 't':
			ro.canTap = true
			if len(v) > 1 && v[1] == '*' {
				ro.canTapStar = true
				ro.canTapPlus = true
				v = v[2:]
				continue
			}
			if len(v) > 1 && v[1] == '+' {
				ro.canTapPlus = true
				v = v[2:]
				continue
			}
			v = v[1:]
			continue
		case 'L', 'l':
			ro.canList = true
			v = v[1:]
			continue
		default:
			log.Infof("Hit default permstring case: %v", v[0])
			return false
		}
	}
	return true
}

//String returns a string representation of the DOT
func (ro *DOT) String() string {
	rv := "[DOT]\n"
	if ro.isAccess {
		rv += "ACCESS " + ro.GetPermString() + "\n"
	} else {
		rv += "PERMISSION\n"
	}
	rv += "Hash: " + FmtHash(ro.hash) + "\n"
	rv += "From VK: " + FmtKey(ro.giverVK) + "\n"
	rv += "To VK  : " + FmtKey(ro.receiverVK) + "\n"
	if ro.created != nil {
		rv += "Created: " + ro.created.String() + "\n"
	}
	if ro.expires != nil {
		rv += "Expires: " + ro.expires.String()
	}
	if ro.pubLim != nil {
		rv += "PubLim: store(" + string(ro.pubLim.StoreLimit) + ") tx(" + string(ro.pubLim.TxLimit) + ") p(" + string(ro.pubLim.Retain) + ")\n"
	}
	return rv
}

//Encode will work out the content of the DOT based on the fields
//that have been set, and sign it with the given sk (must match the vk)
func (ro *DOT) Encode(sk []byte) {
	buf := make([]byte, 66, 256)
	copy(buf, ro.giverVK)
	copy(buf[32:], ro.receiverVK)
	buf[64] = byte(ro.ttl)
	if ro.isAccess {
		buf[65] = 0x01
	} else {
		buf[65] = 0x02
	}
	//max = 65
	if ro.pubLim != nil {
		buf = append(buf, 0x01, 17)
		buf = append(buf, ro.pubLim.toBytes()...)
	}
	if ro.created != nil {
		buf = append(buf, 0x02, 8)
		tmp := make([]byte, 8)
		binary.LittleEndian.PutUint64(tmp, uint64(ro.created.UnixNano()))
		buf = append(buf, tmp...)
	}
	if ro.expires != nil {
		buf = append(buf, 0x03, 8)
		tmp := make([]byte, 8)
		binary.LittleEndian.PutUint64(tmp, uint64(ro.expires.UnixNano()))
		buf = append(buf, tmp...)
	}
	for _, dr := range ro.revokers {
		buf = append(buf, 0x04, 32)
		buf = append(buf, dr...)
	}
	if ro.contact != "" {
		if len(ro.contact) > 255 {
			ro.contact = ro.contact[:255]
		}
		buf = append(buf, 0x05, byte(len(ro.contact)))
		buf = append(buf, []byte(ro.contact)...)
	}
	if ro.comment != "" {
		if len(ro.comment) > 255 {
			ro.comment = ro.comment[:255]
		}
		buf = append(buf, 0x06, byte(len(ro.comment)))
		buf = append(buf, []byte(ro.comment)...)
	}
	buf = append(buf, 0x00)
	if ro.isAccess {
		perm := 0
		if ro.canConsume {
			perm |= 0x01
		}
		if ro.canConsumePlus {
			perm |= 0x03
		}
		if ro.canConsumeStar {
			perm |= 0x07
		}
		if ro.canTap {
			perm |= 0x08
		}
		if ro.canTapPlus {
			perm |= 0x18
		}
		if ro.canTapStar {
			perm |= 0x38
		}
		if ro.canPublish {
			perm |= 0x40
		}
		if ro.canList {
			perm |= 0x80
		}
		buf = append(buf, byte(perm), 0x00)
		buf = append(buf, ro.mVK...)
		tmp := make([]byte, 2)
		binary.LittleEndian.PutUint16(tmp, uint16(len(ro.uriSuffix)))
		buf = append(buf, tmp...)
		buf = append(buf, []byte(ro.uriSuffix)...)
	} else {
		tmp := make([]byte, 2)
		for key, value := range ro.kv {
			buf = append(buf, byte(len(key)))
			buf = append(buf, []byte(key)...)
			binary.LittleEndian.PutUint16(tmp, uint16(len(value)))
			buf = append(buf, tmp...)
			buf = append(buf, []byte(value)...)
		}
		buf = append(buf, 0)
	}
	hash := sha256.Sum256(buf)
	ro.hash = hash[:]
	sig := make([]byte, 64)
	SignBlob(sk, ro.giverVK, sig, buf)
	buf = append(buf, sig...)
	ro.content = buf
	ro.signature = sig
}

//GetGiverVK returns the verifying key of the entity that created this DOT
func (ro *DOT) GetGiverVK() []byte {
	return ro.giverVK
}

//GetReceiverVK gets the verifying key of the entity that is the recipient of
//trust in this DOT
func (ro *DOT) GetReceiverVK() []byte {
	return ro.receiverVK
}

type Entity struct {
	content   []byte
	signature []byte
	vk        []byte
	sk        []byte
	expires   *time.Time
	created   *time.Time
	revokers  [][]byte
	contact   string
	comment   string
	sigok     sigState
}

func CreateLightEntity(vk, sk []byte) *Entity {
	if len(vk) != 32 || len(sk) != 32 {
		panic("Bad keypairs")
	}
	return &Entity{vk: vk, sk: sk}
}
func CreateNewEntity(contact, comment string, revokers [][]byte) *Entity {
	if revokers == nil {
		revokers = make([][]byte, 0)
	}
	for _, v := range revokers {
		if len(v) != 32 {
			panic("I told you we need to check this...")
		}
	}
	rv := &Entity{contact: contact, comment: comment, revokers: revokers}
	rv.sk, rv.vk = GenerateKeypair()
	return rv
}
func (ro *Entity) IsExpired() bool {
	if ro.expires != nil {
		return ro.expires.Before(time.Now())
	}
	return false
}
func (ro *Entity) AddRevoker(rvk []byte) {
	if len(rvk) != 32 {
		panic("What kind of VK is this?")
	}
	ro.revokers = append(ro.revokers, rvk)
}

func (ro *Entity) SetCreationToNow() {
	t := time.Now()
	ro.created = &t
}
func (ro *Entity) GetContact() string {
	return ro.contact
}

func (ro *Entity) GetComment() string {
	return ro.comment
}

//GetSigningBlob returns the full entity, including the private key
func (ro *Entity) GetSigningBlob() []byte {
	if len(ro.content) == 0 {
		ro.Encode()
	}
	if len(ro.GetSK()) == 0 || len(ro.content) == 0 {
		return nil
	}
	rv := make([]byte, len(ro.content)+32)
	copy(rv, ro.GetSK())
	copy(rv[32:], ro.content)
	return rv
}

func (ro *Entity) SetSK(sk []byte) {
	ro.sk = sk
}

func (ro *Entity) GetSK() []byte {
	return ro.sk
}

func (ro *Entity) SetVK(vk []byte) {
	ro.vk = vk
}

func (ro *Entity) GetVK() []byte {
	return ro.vk
}

func (ro *Entity) StringKey() string {
	return FmtKey(ro.vk)
}

func (ro *Entity) SetExpiry(t time.Time) {
	ro.expires = &t
}
func (ro *Entity) GetExpiry() *time.Time {
	return ro.expires
}
func (ro *Entity) GetCreated() *time.Time {
	return ro.created
}
func (ro *Entity) GetRevokers() [][]byte {
	return ro.revokers
}

//SigValid returns if the Entity's signature is valid. This only checks
//the signature on the first call, so the content must not change
//after encoding for this to be valid
func (ro *Entity) SigValid() bool {
	if ro.sigok == sigValid {
		return true
	} else if ro.sigok == sigInvalid {
		return false
	}
	if len(ro.signature) != 64 || len(ro.content) == 0 {
		panic("Entity in invalid state")
	}
	ok := VerifyBlob(ro.vk, ro.signature, ro.content[:len(ro.content)-64])
	if ok {
		ro.sigok = sigValid
		return true
	}
	ro.sigok = sigInvalid
	return false
}

func (ro *Entity) Encode() {
	if len(ro.sk) != 32 {
		panic("Requires SK to Encode")
	}
	buf := make([]byte, 32)
	copy(buf, ro.vk)
	if ro.created != nil {
		buf = append(buf, 0x02, 8)
		tmp := make([]byte, 8)
		binary.LittleEndian.PutUint64(tmp, uint64(ro.created.UnixNano()))
		buf = append(buf, tmp...)
	}
	if ro.expires != nil {
		buf = append(buf, 0x03, 8)
		tmp := make([]byte, 8)
		binary.LittleEndian.PutUint64(tmp, uint64(ro.expires.UnixNano()))
		buf = append(buf, tmp...)
	}
	for _, k := range ro.revokers {
		buf = append(buf, 0x04, 32)
		buf = append(buf, k...)
	}
	if ro.contact != "" {
		if len(ro.contact) > 255 {
			panic("Bad contact")
		}
		buf = append(buf, 0x05, byte(len(ro.contact)))
		buf = append(buf, []byte(ro.contact)...)
	}
	if ro.comment != "" {
		if len(ro.comment) > 255 {
			panic("Bad comment")
		}
		buf = append(buf, 0x06, byte(len(ro.comment)))
		buf = append(buf, []byte(ro.comment)...)
	}
	buf = append(buf, 0)
	sig := make([]byte, 64)
	SignBlob(ro.sk, ro.vk, sig, buf)
	buf = append(buf, sig...)
	ro.content = buf
	ro.signature = sig
}

func NewEntity(ronum int, content []byte) (rv RoutingObject, err error) {
	defer func() {
		if r := recover(); r != nil {
			err = NewObjectError(ronum, "Bad Entity")
			rv = nil
		}
	}()
	var sk []byte
	if ronum == ROEntityWKey {
		sk = content[:32]
		content = content[32:]
		ronum = ROEntity
	}
	if ronum != ROEntity {
		panic("Bad RONUM: " + strconv.Itoa(ronum))
	}
	e := &Entity{
		content:  content,
		vk:       content[:32],
		revokers: make([][]byte, 0),
	}
	idx := 32
	for {
		switch content[idx] {
		case 0x02: //Creation date
			if content[idx+1] != 8 {
				return nil, NewObjectError(ROEntity, "Invalid creation date in Entity")
			}
			idx += 2
			t := time.Unix(0, int64(binary.LittleEndian.Uint64(content[idx:])))
			e.created = &t
			idx += 8
		case 0x03: //Expiry date
			if content[idx+1] != 8 {
				return nil, NewObjectError(ROEntity, "Invalid expiry date in Entity")
			}
			idx += 2
			t := time.Unix(0, int64(binary.LittleEndian.Uint64(content[idx:])))
			e.expires = &t
			idx += 8
		case 0x04: //Delegated revoker
			if content[idx+1] != 32 {
				return nil, NewObjectError(ROEntity, "Invalid delegated revoker in Entity")
			}
			idx += 2
			e.revokers = append(e.revokers, content[idx:idx+32])
			idx += 32
		case 0x05: //contact
			ln := int(content[idx+1])
			e.contact = string(content[idx+2 : idx+2+ln])
			idx += 2 + ln
		case 0x06: //Comment
			ln := int(content[idx+1])
			e.comment = string(content[idx+2 : idx+2+ln])
			idx += 2 + ln
		case 0x00: //End
			idx++
			goto done
		default: //Skip unknown header
			fmt.Println("Unknown Entity option type: ", content[idx])
			idx += int(content[idx+1]) + 1
		}
	}
done:
	e.signature = content[idx : idx+64]
	if sk != nil {
		e.SetSK(sk)
	}
	return e, nil
}

func (ro *Entity) WriteToStream(s io.Writer, fullObjNum bool) error {
	if len(ro.content) == 0 {
		return NewObjectError(ro.GetRONum(), "Cannot write to stream: no content")
	}
	ln := len(ro.content)
	if fullObjNum {
		//Little endian
		_, err := s.Write([]byte{byte(ro.GetRONum()), 0, 0, 0,
			byte(ln),
			byte(ln >> 8),
			byte(ln >> 16),
			byte(ln >> 24),
		})
		if err != nil {
			return err
		}
	} else {
		_, err := s.Write([]byte{byte(ro.GetRONum()),
			byte(ln),
			byte(ln >> 8),
		})
		if err != nil {
			return err
		}
	}
	_, err := s.Write(ro.content)
	return err
}

func (ro *Entity) GetRONum() int {
	return ROEntity
}

func (ro *Entity) GetContent() []byte {
	if len(ro.content) == 0 {
		ro.Encode()
	}
	return ro.content
}

func (ro *Entity) FullString() string {
	rv := "Entity: "
	if len(ro.sk) != 0 {
		rv += "+SK"
	}
	rv += "\n VK: " + FmtKey(ro.vk)
	if ro.contact != "" {
		rv += "\n Contact: " + ro.contact
	}
	if ro.comment != "" {
		rv += "\n Comment: " + ro.comment
	}
	if ro.created != nil {
		rv += "\n Created: " + ro.created.String()
	}
	if ro.expires != nil {
		rv += "\n Expires: " + ro.expires.String()
	}
	for _, v := range ro.revokers {
		rv += "\n Revoker: " + FmtKey(v)
	}
	return rv
}

func (ro *Entity) OverrideSetSignatureValid() {
	ro.sigok = sigValid
}

type Expiry struct {
	time    time.Time
	content []byte
}

func CreateNewExpiryFromNow(expiry time.Duration) *Expiry {
	edate := time.Now().Add(expiry)
	rv := Expiry{time: edate, content: make([]byte, 8)}
	binary.LittleEndian.PutUint64(rv.content, uint64(edate.UnixNano()))
	return &rv
}
func CreateNewExpiry(expiry time.Time) *Expiry {
	rv := Expiry{time: expiry, content: make([]byte, 8)}
	binary.LittleEndian.PutUint64(rv.content, uint64(expiry.UnixNano()))
	return &rv
}
func NewExpiry(ronum int, content []byte) (rv RoutingObject, err error) {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println(r)
			debug.PrintStack()
			err = NewObjectError(ronum, "Bad Expiry")
			rv = nil
		}
	}()
	if ronum != ROExpiry {
		panic("Bad ronum")
	}
	if len(content) != 8 {
		return nil, NewObjectError(ronum, "Content is the wrong size")
	}
	t := time.Unix(0, int64(binary.LittleEndian.Uint64(content[:8])))
	rv = &Expiry{time: t, content: content}
	return rv, nil
}
func (ro *Expiry) GetRONum() int {
	return ROExpiry
}
func (ro *Expiry) GetContent() []byte {
	return ro.content
}
func (ro *Expiry) IsPayloadObject() bool {
	return false
}
func (ro *Expiry) WriteToStream(s io.Writer, fullObjNum bool) error {
	if len(ro.content) == 0 {
		return NewObjectError(ro.GetRONum(), "Cannot write to stream: no content")
	}
	ln := len(ro.content)
	if fullObjNum {
		//Little endian
		_, err := s.Write([]byte{byte(ro.GetRONum()), 0, 0, 0,
			byte(ln),
			byte(ln >> 8),
			byte(ln >> 16),
			byte(ln >> 24),
		})
		if err != nil {
			return err
		}
	} else {
		_, err := s.Write([]byte{byte(ro.GetRONum()),
			byte(ln),
			byte(ln >> 8),
		})
		if err != nil {
			return err
		}
	}
	_, err := s.Write(ro.content)
	return err
}
func (ro *Expiry) GetExpiry() time.Time {
	return ro.time
}

type OriginVK struct {
	vk []byte
}

func CreateOriginVK(vk []byte) *OriginVK {
	return &OriginVK{vk: vk}
}
func NewOriginVK(ronum int, content []byte) (RoutingObject, error) {
	if ronum != ROOriginVK {
		panic("Bad ronum")
	}
	if len(content) != 32 {
		return nil, NewObjectError(ronum, "Content is the wrong size")
	}
	rv := OriginVK{vk: content}
	return &rv, nil
}
func (ro *OriginVK) GetRONum() int {
	return ROOriginVK
}

func (ro *OriginVK) GetContent() []byte {
	return ro.vk
}

func (ro *OriginVK) IsPayloadObject() bool {
	return false
}

func (ro *OriginVK) GetVK() []byte {
	return ro.vk
}

func (ro *OriginVK) WriteToStream(s io.Writer, fullObjNum bool) error {
	ln := 32
	if fullObjNum {
		//Little endian
		_, err := s.Write([]byte{byte(ro.GetRONum()), 0, 0, 0,
			byte(ln),
			byte(ln >> 8),
			byte(ln >> 16),
			byte(ln >> 24),
		})
		if err != nil {
			return err
		}
	} else {
		_, err := s.Write([]byte{byte(ro.GetRONum()),
			byte(ln),
			byte(ln >> 8),
		})
		if err != nil {
			return err
		}
	}
	_, err := s.Write(ro.vk)
	return err
}

type Revocation struct {
	content   []byte
	vk        []byte
	target    []byte
	signature []byte
	hash      []byte
	sigok     sigState
	created   *time.Time
	comment   string
}

func CreateRevocation(authVK []byte, target []byte, comment string) *Revocation {
	n := time.Now()
	rv := &Revocation{
		vk:      authVK,
		target:  target,
		created: &n,
		comment: comment,
	}
	return rv
}

func (ro *Revocation) GetHash() []byte {
	if len(ro.hash) != 32 {
		panic("Bad Revocation Hash")
	}
	return ro.hash
}
func (ro *Revocation) GetVK() []byte {
	return ro.vk
}
func (ro *Revocation) GetTarget() []byte {
	return ro.target
}
func (ro *Revocation) GetRONum() int {
	return RORevocation
}
func (ro *Revocation) GetCreated() *time.Time {
	return ro.created
}
func (ro *Revocation) GetComment() string {
	return ro.comment
}

//This does not recurse. E.g. for a dot this would return
//false even if valid for src/dstvk...
//this is because you have to check the entities seperately anyway
//to fully factor in the entities DRVKs
func (ro *Revocation) IsValidFor(obj RoutingObject) bool {
	if !ro.SigValid() {
		return false
	}
	switch obj := obj.(type) {
	case *DOT:
		if !bytes.Equal(ro.GetTarget(), obj.GetHash()) {
			return false
		}
		//It is valid, as long as the src is valid
		if bytes.Equal(ro.GetVK(), obj.GetGiverVK()) {
			return true
		}
		//It might also be valid if it is a DRVKR
		for _, drvk := range obj.GetRevokers() {
			if bytes.Equal(ro.GetVK(), drvk) {
				return true
			}
		}
		//Someone trying to revoke something with no AUTHORITAH
		return false
	case *Entity:
		if !bytes.Equal(ro.GetTarget(), obj.GetVK()) {
			return false
		}
		//It is valid, as long as the src is valid
		if bytes.Equal(ro.GetVK(), obj.GetVK()) {
			return true
		}
		//It might also be valid if it is a DRVKR
		for _, drvk := range obj.GetRevokers() {
			if bytes.Equal(ro.GetVK(), drvk) {
				return true
			}
		}
		//Someone trying to revoke something with no AUTHORITAH
		return false
	default:
		return false
	}
}
func (ro *Revocation) GetContent() []byte {
	return ro.content
}

func (ro *Revocation) IsPayloadObject() bool {
	return false
}
func NewRevocation(ronum int, content []byte) (rv RoutingObject, err error) {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println(r)
			debug.PrintStack()
			err = NewObjectError(ronum, "Bad Revocation")
			rv = nil
		}
	}()
	if ronum != RORevocation {
		panic("Bad RONUM: " + strconv.Itoa(ronum))
	}
	hasharr := sha256.Sum256(content)
	rk := &Revocation{
		content: content,
		vk:      content[:32],
		target:  content[32:64],
		hash:    hasharr[:],
	}
	idx := 64
	for {
		switch content[idx] {
		case 0x02: //Creation date
			if content[idx+1] != 8 {
				return nil, NewObjectError(RORevocation, "Invalid creation date in Revocation")
			}
			idx += 2
			t := time.Unix(0, int64(binary.LittleEndian.Uint64(content[idx:])))
			rk.created = &t
			idx += 8
		case 0x06: //Comment
			ln := int(content[idx+1])
			rk.comment = string(content[idx+2 : idx+2+ln])
			idx += 2 + ln
		case 0x00: //End
			idx++
			goto done
		default: //Skip unknown header
			fmt.Println("Unknown Revocation option type: ", content[idx])
			idx += int(content[idx+1]) + 1
		}
	}
done:
	rk.signature = content[idx : idx+64]
	return rk, nil
}

func (ro *Revocation) WriteToStream(s io.Writer, fullObjNum bool) error {
	if len(ro.content) == 0 {
		return NewObjectError(ro.GetRONum(), "Cannot write to stream: no content")
	}
	ln := len(ro.content)
	if fullObjNum {
		//Little endian
		_, err := s.Write([]byte{byte(ro.GetRONum()), 0, 0, 0,
			byte(ln),
			byte(ln >> 8),
			byte(ln >> 16),
			byte(ln >> 24),
		})
		if err != nil {
			return err
		}
	} else {
		_, err := s.Write([]byte{byte(ro.GetRONum()),
			byte(ln),
			byte(ln >> 8),
		})
		if err != nil {
			return err
		}
	}
	_, err := s.Write(ro.content)
	return err
}
func (ro *Revocation) Encode(sk []byte) {
	buf := make([]byte, 64, 256)
	copy(buf, ro.vk)
	copy(buf[32:], ro.target)
	if ro.created != nil {
		buf = append(buf, 0x02, 8)
		tmp := make([]byte, 8)
		binary.LittleEndian.PutUint64(tmp, uint64(ro.created.UnixNano()))
		buf = append(buf, tmp...)
	}
	if ro.comment != "" {
		if len(ro.comment) > 255 {
			ro.comment = ro.comment[:255]
		}
		buf = append(buf, 0x06, byte(len(ro.comment)))
		buf = append(buf, []byte(ro.comment)...)
	}
	buf = append(buf, 0x00)
	hash := sha256.Sum256(buf)
	ro.hash = hash[:]

	sig := make([]byte, 64)
	SignBlob(sk, ro.vk, sig, buf)
	buf = append(buf, sig...)
	ro.content = buf
	ro.signature = sig
}

func (ro *Revocation) SigValid() bool {
	if ro.sigok == sigValid {
		return true
	} else if ro.sigok == sigInvalid {
		return false
	}
	if len(ro.signature) != 64 || len(ro.content) == 0 {
		panic("Revocation in invalid state")
	}
	ok := VerifyBlob(ro.vk, ro.signature, ro.content[:len(ro.content)-64])
	if ok {
		ro.sigok = sigValid
		return true
	}
	ro.sigok = sigInvalid
	return false
}

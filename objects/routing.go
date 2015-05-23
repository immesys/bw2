package objects

import (
	"bytes"
	"crypto/sha256"
	"encoding/base64"
	"encoding/binary"
	"fmt"
	"io"
	"runtime/debug"
	"time"

	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/internal/util"
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
	ROOriginVK:             NewOriginVK,
	ROExpiry:               NewExpiry,
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
			return nil, NewObjectError(ronum, "Wrong content length")
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

//NumHashes returns the length of the chain
func (ro *DChain) NumHashes() int {
	if ro.elaborated {
		return len(ro.dots)
	}
	panic("DChain not elaborated")
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
	return ro.ronum
}

func (ro *DChain) UnElaborate() {
	ro.elaborated = false
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
			t := time.Unix(0, int64(binary.LittleEndian.Uint64(content[idx:])*1000000))
			ro.created = &t
			idx += 8
		case 0x03: //Expiry date
			if content[idx+1] != 8 {
				return nil, NewObjectError(ronum, "Invalid expiry date in DoT")
			}
			idx += 2
			t := time.Unix(0, int64(binary.LittleEndian.Uint64(content[idx:])*1000000))
			ro.expires = &t
			idx += 8
		case 0x04: //Delegated revoker
			if content[idx+1] != 8 {
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
	uriSane, _, _, _, _ := util.AnalyzeSuffix(ro.uriSuffix)
	if !uriSane {
		ro.sigok = sigInvalid
		return false
	}
	if len(ro.signature) != 64 || len(ro.content) == 0 {
		panic("DOT in invalid state")
	}
	ok := crypto.VerifyBlob(ro.giverVK, ro.signature, ro.content[:len(ro.content)-64])
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
	t /= 1000000
	t *= 1000000
	to := time.Unix(0, t)
	ro.created = &to
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

//String returns a string representation of the DOT
func (ro *DOT) String() string {
	rv := "[DOT]\n"
	if ro.isAccess {
		rv += "ACCESS " + ro.GetPermString() + "\n"
	} else {
		rv += "PERMISSION\n"
	}
	rv += "Hash: " + crypto.FmtHash(ro.hash) + "\n"
	rv += "From VK: " + crypto.FmtKey(ro.giverVK) + "\n"
	rv += "To VK  : " + crypto.FmtKey(ro.receiverVK) + "\n"
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
		binary.LittleEndian.PutUint64(tmp, uint64(ro.created.UnixNano()/1000000))
		buf = append(buf, tmp...)
	}
	if ro.expires != nil {
		buf = append(buf, 0x03, 8)
		tmp := make([]byte, 8)
		binary.LittleEndian.PutUint64(tmp, uint64(ro.expires.UnixNano()/1000000))
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
	crypto.SignBlob(sk, ro.giverVK, sig, buf)
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

func CreateNewEntity(contact, comment string, revokers [][]byte, expiry time.Duration) *Entity {
	c := RoundTime(time.Now())
	e := RoundTime(time.Now().Add(expiry))
	rv := &Entity{contact: contact, comment: comment, created: &c, expires: &e, revokers: revokers}
	rv.sk, rv.vk = crypto.GenerateKeypair()
	return rv
}

func (ro *Entity) AddRevoker(rvk []byte) {
	if len(rvk) != 32 {
		panic("What kind of VK is this?")
	}
	ro.revokers = append(ro.revokers, rvk)
}

func (ro *Entity) GetContact() string {
	return ro.contact
}

func (ro *Entity) GetComment() string {
	return ro.comment
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
	return crypto.FmtKey(ro.vk)
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
	ok := crypto.VerifyBlob(ro.vk, ro.signature, ro.content[:len(ro.content)-64])
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
		binary.LittleEndian.PutUint64(tmp, uint64(ro.created.UnixNano()/1000000))
		buf = append(buf, tmp...)
	}
	if ro.expires != nil {
		buf = append(buf, 0x03, 8)
		tmp := make([]byte, 8)
		binary.LittleEndian.PutUint64(tmp, uint64(ro.expires.UnixNano()/1000000))
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
	crypto.SignBlob(ro.sk, ro.vk, sig, buf)
	buf = append(buf, sig...)
	ro.content = buf
	ro.signature = sig
}

func NewEntity(ronum int, content []byte) (RoutingObject, error) {
	if ronum != ROEntity {
		panic("Bad RONUM")
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
			t := time.Unix(0, int64(binary.LittleEndian.Uint64(content[idx:])*1000000))
			e.created = &t
			idx += 8
		case 0x03: //Expiry date
			if content[idx+1] != 8 {
				return nil, NewObjectError(ROEntity, "Invalid expiry date in Entity")
			}
			idx += 2
			t := time.Unix(0, int64(binary.LittleEndian.Uint64(content[idx:])*1000000))
			e.expires = &t
			idx += 8
		case 0x04: //Delegated revoker
			if content[idx+1] != 8 {
				return nil, NewObjectError(ROEntity, "Invalid delegated revoker in DoT")
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
	return ro.content
}

func (ro *Entity) FullString() string {
	rv := "Entity: "
	if len(ro.sk) != 0 {
		rv += "+SK"
	}
	rv += "\n VK: " + crypto.FmtKey(ro.vk)
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
		rv += "\n Revoker: " + crypto.FmtKey(v)
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
	binary.LittleEndian.PutUint64(rv.content, uint64(edate.UnixNano()/1000000))
	return &rv
}
func CreateNewExpiry(expiry time.Time) *Expiry {
	rv := Expiry{time: expiry, content: make([]byte, 8)}
	binary.LittleEndian.PutUint64(rv.content, uint64(expiry.UnixNano()/1000000))
	return &rv
}
func NewExpiry(ronum int, content []byte) (RoutingObject, error) {
	if ronum != ROExpiry {
		panic("Bad ronum")
	}
	if len(content) != 8 {
		return nil, NewObjectError(ronum, "Content is the wrong size")
	}
	t := time.Unix(0, int64(binary.LittleEndian.Uint64(content[:8])*1000000))
	rv := Expiry{time: t, content: content}
	return &rv, nil
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

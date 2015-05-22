package objects

import (
	"encoding/binary"
	"errors"
	"fmt"
	"io"
	"time"
)

// We allocate buffers for objects. Lets not get too exciteable
// about how big an object we are willing to accept
const SaneObjectSize = 16 * 1024 * 1024

// ObjectError is thrown by object parsing function
type ObjectError struct {
	ObjectID int
	Message  string
}

type BossWaveObject interface {
	IsPayloadObject() bool
}

// NewObjectError constructs an ObjectError
func NewObjectError(oid int, msg string) error {
	return ObjectError{ObjectID: oid, Message: msg}
}

func (oe ObjectError) Error() string {
	return oe.Message
}

//RoundTime removes the micro/nano part of the time, to
//match up with how it is serialised
func RoundTime(t time.Time) time.Time {
	nanos := t.UnixNano()
	nanos /= 1000000
	nanos *= 1000000
	return time.Unix(0, nanos)
}

//PayloadObject is the interface that is common among all objects that
//appear in the payload block
type PayloadObject interface {
	GetPONum() int
	GetContent() []byte
}

func PONumDotForm(ponum int) string {
	return fmt.Sprintf("%d.%d.%d.%d", ponum>>24, (ponum>>16)&0xFF, (ponum>>8)&0xFF, ponum&0xFF)
}

// LoadBosswaveObject loads an object from a reader.
// all objects will need to have the full length header
func LoadBosswaveObject(s io.Reader) (BossWaveObject, error) {
	hdr := make([]byte, 8)
	totn := 0
	for totn < 8 {
		n, e := s.Read(hdr[totn:8])
		totn += n
		if e != nil {
			return nil, e
		}
	}
	onum := int(binary.LittleEndian.Uint32(hdr[0:4]))
	ln := int(binary.LittleEndian.Uint32(hdr[4:8]))
	if ln > SaneObjectSize {
		return nil, errors.New("Object is of insane size")
	}
	buf := make([]byte, ln)
	totn = 0
	for totn < ln {
		n, e := s.Read(buf[totn:])
		totn += n
		if e != nil {
			return nil, e
		}
	}
	if onum&0xFFFFFF00 == 0 {
		//Routing object
		constructor, ok := RoutingObjectConstructor[onum]
		if !ok {
			return nil, NewObjectError(onum, "No such routing object constructor")
		}
		obj, err := constructor(onum, buf)
		return obj, err
	}
	return nil, NewObjectError(onum, "No constructor for this object type yet")
}

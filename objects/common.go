package objects

import (
	"time"
)

// ObjectError is thrown by object parsing function
type ObjectError struct {
	ObjectID int
	Message  string
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

package objects

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

package rocks

// #cgo CXXFLAGS: -I./include/ -std=gnu++11
// #cgo LDFLAGS: -L/home/michael/go/src/github.com/immesys/bw2/lib -lrocksdb -lz -lbz2
// #include "iface.h"
import "C"
import (
	"errors"
	"unsafe"
)

func init() {
	C.init()
}

const (
	CFDot    = 1
	CFDChain = 2
	CFMsg    = 3
	CFMsgI   = 4
	CFEntity = 5
)

//ErrObjNotFound is returned from GetObject if the object cannot be found
var ErrObjNotFound = errors.New("Object Not Found")

func PutObject(cf int, key []byte, val []byte) {
	C.put_object(C.int(cf), (*C.char)(unsafe.Pointer(&key[0])),
		(C.size_t)(len(key)),
		(*C.char)(unsafe.Pointer(&val[0])),
		(C.size_t)(len(val)))
}

func GetObject(cf int, key []byte) ([]byte, error) {
	var ln C.size_t
	val := C.get_object(C.int(cf), (*C.char)(unsafe.Pointer(&key[0])),
		(C.size_t)(len(key)),
		&ln)
	if val == nil {
		return nil, ErrObjNotFound
	}
	rv := make([]byte, int(ln))
	C.memcpy(unsafe.Pointer(&rv[0]), unsafe.Pointer(val), ln)
	C.free(unsafe.Pointer(val))
	return rv, nil
}

func DeleteObject(cf int, key []byte) {
	C.delete_object(C.int(cf), (*C.char)(unsafe.Pointer(&key[0])),
		(C.size_t)(len(key)))
}

func Exists(cf int, key []byte) bool {
	if C.exists(C.int(cf),
		(*C.char)(unsafe.Pointer(&key[0])), (C.size_t)(len(key))) != 0 {
		return true
	}
	return false
}

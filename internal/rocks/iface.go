package rocks

// #cgo CXXFLAGS: -I./include/ -std=gnu++11
// #cgo LDFLAGS: -L/home/michael/go/src/github.com/immesys/bw2/lib -lrocksdb -lz -lbz2
// #include "iface.h"
import "C"
import (
	"errors"
	"unsafe"
)

//InitDatabase creates or opens the local bosswave database
func InitDatabase() {
	C.init()
}

//ErrObjNotFound is returned from GetObject if the object cannot be found
var ErrObjNotFound = errors.New("Object Not Found")

//PutObject puts the given object into the local database
func PutObject(key []byte, val []byte) {
	C.put_object((*C.char)(unsafe.Pointer(&key[0])),
		(C.size_t)(len(key)),
		(*C.char)(unsafe.Pointer(&val[0])),
		(C.size_t)(len(val)))
}

//GetObject puts the given object into the local database
func GetObject(key []byte) ([]byte, error) {
	var ln C.size_t
	val := C.get_object((*C.char)(unsafe.Pointer(&key[0])),
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

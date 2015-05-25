package rocks

// #cgo CXXFLAGS: -I./include/ -std=gnu++11
// #cgo LDFLAGS: -L/home/michael/go/src/github.com/immesys/bw2/lib -lrocksdb -lz -lbz2
// #include "iface.h"
import "C"
import (
	"bytes"
	"errors"
	"runtime"
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

type Iterator struct {
	state  unsafe.Pointer
	prefix []byte
	curv   *C.char
	curvl  C.size_t
	curk   []byte
	valid  bool
}

func CreateIterator(cf int, prefix []byte) *Iterator {
	rv := Iterator{prefix: prefix}
	var k *C.char
	var kl C.size_t
	var v *C.char
	var vl C.size_t
	C.iterator_create(C.int(cf), (*C.char)(unsafe.Pointer(&prefix[0])),
		(C.size_t)(len(prefix)),
		&rv.state, &k, &kl, &v, &vl)
	runtime.SetFinalizer(&rv, func(it *Iterator) {
		//I have no idea how long rocks will take to do this. I suspect
		//it involves deleting a snapshot. Lets not block the finalizer
		//goroutine
		go func() {
			C.iterator_delete(it.state)
		}()
	})

	rv.curv = v
	rv.curvl = vl
	//There is no result at all
	if kl == 0 {
		rv.valid = false
		return &rv
	}
	//We need to copy out the key to check if its valid
	//in terms of prefix
	key := make([]byte, kl)
	C.memcpy(unsafe.Pointer(&key[0]), unsafe.Pointer(k), kl)
	if len(key) < len(prefix) || !bytes.Equal(key[:len(prefix)], prefix) {
		rv.valid = false
		return &rv
	}
	rv.curk = key
	rv.valid = true
	return &rv
}

func (i *Iterator) Next() {
	var k *C.char
	var kl C.size_t
	var v *C.char
	var vl C.size_t
	C.iterator_next(i.state, &k, &kl, &v, &vl)
	if kl == 0 {
		i.valid = false
		return
	}
	i.curv = v
	i.curvl = vl
	key := make([]byte, kl)
	C.memcpy(unsafe.Pointer(&key[0]), unsafe.Pointer(k), kl)
	if len(key) < len(i.prefix) || !bytes.Equal(key[:len(i.prefix)], i.prefix) {
		i.valid = false
		return
	}
	i.curk = key
	i.valid = true
}
func (i *Iterator) OK() bool {
	return i.valid
}
func (i *Iterator) Key() []byte {
	return i.curk
}
func (i *Iterator) Value() (value []byte) {
	value = make([]byte, i.curvl)
	C.memcpy(unsafe.Pointer(&value[0]), unsafe.Pointer(i.curv), i.curvl)
	return
}

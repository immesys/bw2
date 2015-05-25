package rocks

import (
	"crypto/rand"
	"fmt"
	"reflect"
	"testing"
)

func TestAll(t *testing.T) {
	k1 := make([]byte, 64)
	rand.Read(k1)
	k2 := make([]byte, 64)
	rand.Read(k2)
	v1 := make([]byte, 64)
	rand.Read(v1)
	v2 := make([]byte, 64)
	rand.Read(v2)
	PutObject(CFDot, k1, v1)
	PutObject(CFDot, k2, v2)
	r1, _ := GetObject(CFDot, k1)
	r2, _ := GetObject(CFDot, k2)
	if !reflect.DeepEqual(v1, r1) || !reflect.DeepEqual(v2, r2) {
		t.Fail()
		fmt.Println("Not equal")
	}

	k2[0] ^= 0x01
	r3, err := GetObject(CFDot, k2)
	if err != ErrObjNotFound || r3 != nil {
		t.Fail()
		fmt.Println("Object found")
	}
}

func TestIterator(t *testing.T) {
	k1 := []byte("a/b/c")
	k2 := []byte("a/b/d")
	k3 := []byte("a/b/e")
	ki := []byte("a/b")
	v := []byte("foobar")
	PutObject(CFDot, k1, v)
	PutObject(CFDot, k2, v)
	PutObject(CFDot, k3, v)
	i := CreateIterator(CFDot, ki)
	for i.OK() {
		k := i.Key()
		v := i.Value()
		fmt.Println("KV: ", string(k), string(v))
		i.Next()
	}
}
func BenchmarkPutObject(b *testing.B) {
	keys := make([][]byte, b.N)
	vals := make([][]byte, b.N)

	for i := 0; i < b.N; i++ {
		keys[i] = make([]byte, 64)
		vals[i] = make([]byte, 256)
		rand.Read(keys[i])
		rand.Read(vals[i])
	}

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		PutObject(CFDot, keys[i], vals[i])
	}
}

func BenchmarkGetObject(b *testing.B) {
	keys := make([][]byte, b.N)
	vals := make([][]byte, b.N)

	for i := 0; i < b.N; i++ {
		keys[i] = make([]byte, 64)
		vals[i] = make([]byte, 256)
		rand.Read(keys[i])
		rand.Read(vals[i])
	}

	for i := 0; i < b.N; i++ {
		PutObject(CFDot, keys[i], vals[i])
	}

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		_, _ = GetObject(CFDot, keys[i])
	}
}

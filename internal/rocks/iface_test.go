package rocks

import (
	"crypto/rand"
	"fmt"
	"reflect"
	"testing"
)

func TestAll(t *testing.T) {
	InitDatabase()
	k1 := make([]byte, 64)
	rand.Read(k1)
	k2 := make([]byte, 64)
	rand.Read(k2)
	v1 := make([]byte, 64)
	rand.Read(v1)
	v2 := make([]byte, 64)
	rand.Read(v2)
	PutObject(k1, v1)
	PutObject(k2, v2)
	r1, _ := GetObject(k1)
	r2, _ := GetObject(k2)
	if !reflect.DeepEqual(v1, r1) || !reflect.DeepEqual(v2, r2) {
		t.Fail()
		fmt.Println("Not equal")
	}

	k2[0] ^= 0x01
	r3, err := GetObject(k2)
	if err != ErrObjNotFound || r3 != nil {
		t.Fail()
		fmt.Println("Object found")
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
		PutObject(keys[i], vals[i])
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
		PutObject(keys[i], vals[i])
	}

	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		_, _ = GetObject(keys[i])
	}
}

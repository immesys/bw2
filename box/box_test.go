package box

import (
	"bytes"
	"crypto/rand"
	"fmt"
	"testing"

	"vuvuzela.io/crypto/ibe"

	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
)

func TestBoxEncrypt(t *testing.T) {
	ent := objects.CreateNewEntity("", "", nil)
	omsg := []byte("helloworld234234234234")
	bx := NewBox(ent, omsg)

	pub, priv := ibe.Setup(rand.Reader)
	_ = priv
	id := []byte("someidfgdfgdfgdfgdentity")
	bx.AddIBEKeyhole(pub, id)

	contents, err := bx.Encrypt()
	if err != nil {
		t.Fatalf("unexpected error %v\n", err)
	}
	//fmt.Printf("contents %x\n", contents)

	bxid := ExtractIdentity(pub, priv, id)
	msg, err := DecryptBoxWithIBEK(contents, bxid)
	if err != nil {
		t.Fatalf("unexpected error %v\n", err)
	}
	if !bytes.Equal(msg, omsg) {
		t.Fatalf("Message did not match")
	}
}

func BenchmarkEncryptBox_1_IBE(b *testing.B) {
	ent := objects.CreateNewEntity("", "", nil)
	omsg := []byte("helloworld234234234234")
	bx := NewBox(ent, omsg)

	pub, priv := ibe.Setup(rand.Reader)
	_ = priv
	id := []byte("someidfgdfgdfgdfgdentity")
	bx.AddIBEKeyhole(pub, id)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		contents, err := bx.Encrypt()
		if err != nil {
			b.Fatalf("unexpected error %v\n", err)
		}
		_ = contents
	}
}
func BenchmarkEncryptBox_1_Ed25519(b *testing.B) {
	ent := objects.CreateNewEntity("", "", nil)
	ent2 := objects.CreateNewEntity("", "", nil)
	omsg := []byte("helloworld234234234234")
	bx := NewBox(ent, omsg)

	bx.AddEd25519Keyhole(ent2.GetVK())

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		contents, err := bx.Encrypt()
		if err != nil {
			b.Fatalf("unexpected error %v\n", err)
		}
		_ = contents
	}
}
func BenchmarkDecryptBox_1_Ed25519(b *testing.B) {
	ent := objects.CreateNewEntity("", "", nil)
	ent2 := objects.CreateNewEntity("", "", nil)
	omsg := []byte("helloworld234234234234")
	bx := NewBox(ent, omsg)

	bx.AddEd25519Keyhole(ent2.GetVK())
	contents, err := bx.Encrypt()
	if err != nil {
		b.Fatalf("unexpected error %v\n", err)
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		contents, err := DecryptBoxWithEd25519(contents, ent2)
		if err != nil {
			b.Fatalf("unexpected error %v\n", err)
		}
		_ = contents
	}
}
func BenchmarkDecryptBox_10_Ed25519(b *testing.B) {
	ent := objects.CreateNewEntity("", "", nil)
	ent2 := objects.CreateNewEntity("", "", nil)
	omsg := []byte("helloworld234234234234")
	bx := NewBox(ent, omsg)
	for i := 0; i < 9; i++ {
		enti := objects.CreateNewEntity("", "", nil)
		bx.AddEd25519Keyhole(enti.GetVK())
	}
	bx.AddEd25519Keyhole(ent2.GetVK())
	contents, err := bx.Encrypt()
	if err != nil {
		b.Fatalf("unexpected error %v\n", err)
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		contents, err := DecryptBoxWithEd25519(contents, ent2)
		if err != nil {
			b.Fatalf("unexpected error %v\n", err)
		}
		_ = contents
	}
}
func BenchmarkDecryptBox_1_IBE(b *testing.B) {
	ent := objects.CreateNewEntity("", "", nil)
	omsg := []byte("helloworld234234234234")
	bx := NewBox(ent, omsg)

	pub, priv := ibe.Setup(rand.Reader)
	_ = priv
	id := []byte("someidfgdfgdfgdfgdentity")
	bx.AddIBEKeyhole(pub, id)
	contents, err := bx.Encrypt()
	if err != nil {
		b.Fatalf("unexpected error %v\n", err)
	}
	bid := ExtractIdentity(pub, priv, id)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		contents, err := DecryptBoxWithIBEK(contents, bid)
		if err != nil {
			b.Fatalf("unexpected error %v\n", err)
		}
		_ = contents
	}
}

//
// // Time to sign 256 512KB messages. (just signature generation)
// func BenchmarkEd25519Sign512(b *testing.B) {
//
// 	//Things to sign
// 	const NN = 256
// 	targets := make([][]byte, NN)
// 	vks := make([][]byte, NN)
// 	sks := make([][]byte, NN)
// 	sigs := make([][]byte, NN)
// 	for i := 0; i < NN; i++ {
// 		//512 KB message
// 		targets[i] = make([]byte, 512*1024)
// 		rand.Read(targets[i])
// 		sks[i], vks[i] = crypto.GenerateKeypair()
// 		sigs[i] = make([]byte, 64)
// 	}
// 	b.ResetTimer()
//
// 	for k := 0; k < b.N; k++ {
// 		for i := 0; i < NN; i++ {
// 			crypto.SignBlob(sks[i], vks[i], sigs[i], targets[i])
// 		}
// 	}
// }
//
// // Time to sign 256 512KB messages. (just signature generation)
// func BenchmarkEd25519Sign2(b *testing.B) {
//
// 	//Things to sign
// 	const NN = 256
// 	targets := make([][]byte, NN)
// 	vks := make([][]byte, NN)
// 	sks := make([][]byte, NN)
// 	sigs := make([][]byte, NN)
// 	for i := 0; i < NN; i++ {
// 		//2 KB message
// 		targets[i] = make([]byte, 2*1024)
// 		rand.Read(targets[i])
// 		sks[i], vks[i] = crypto.GenerateKeypair()
// 		sigs[i] = make([]byte, 64)
// 	}
// 	b.ResetTimer()
//
// 	for k := 0; k < b.N; k++ {
// 		for i := 0; i < NN; i++ {
// 			crypto.SignBlob(sks[i], vks[i], sigs[i], targets[i])
// 		}
// 	}
// }
//
// // Time to verify 256 512KB messages. (just signature verification)
// func BenchmarkEd25519Verify512(b *testing.B) {
// 	//Things to sign
// 	const NN = 256
// 	targets := make([][]byte, NN)
// 	vks := make([][]byte, NN)
// 	sks := make([][]byte, NN)
// 	sigs := make([][]byte, NN)
// 	for i := 0; i < NN; i++ {
// 		//512 KB message
// 		targets[i] = make([]byte, 512*1024)
// 		rand.Read(targets[i])
// 		sks[i], vks[i] = crypto.GenerateKeypair()
// 		sigs[i] = make([]byte, 64)
// 	}
// 	for i := 0; i < NN; i++ {
// 		crypto.SignBlob(sks[i], vks[i], sigs[i], targets[i])
// 	}
// 	b.ResetTimer()
// 	for k := 0; k < b.N; k++ {
// 		for i := 0; i < NN; i++ {
// 			ok := crypto.VerifyBlob(vks[i], sigs[i], targets[i])
// 			if !ok {
// 				panic("UH")
// 			}
// 		}
// 	}
// }
//
// func BenchmarkEd25519Verify2(b *testing.B) {
// 	//Things to sign
// 	const NN = 256
// 	targets := make([][]byte, NN)
// 	vks := make([][]byte, NN)
// 	sks := make([][]byte, NN)
// 	sigs := make([][]byte, NN)
// 	for i := 0; i < NN; i++ {
// 		//2 KB message
// 		targets[i] = make([]byte, 2*1024)
// 		rand.Read(targets[i])
// 		sks[i], vks[i] = crypto.GenerateKeypair()
// 		sigs[i] = make([]byte, 64)
// 	}
// 	for i := 0; i < NN; i++ {
// 		crypto.SignBlob(sks[i], vks[i], sigs[i], targets[i])
// 	}
// 	b.ResetTimer()
// 	for k := 0; k < b.N; k++ {
// 		for i := 0; i < NN; i++ {
// 			ok := crypto.VerifyBlob(vks[i], sigs[i], targets[i])
// 			if !ok {
// 				panic("UH")
// 			}
// 		}
// 	}
// }

// Time to sign 256 512KB messages. (just signature generation)
func BenchmarkEd25519Sign512KB(b *testing.B) {

	//Things to sign
	const NN = 256
	targets := make([][]byte, NN)
	vks := make([][]byte, NN)
	sks := make([][]byte, NN)
	sigs := make([][]byte, NN)
	for i := 0; i < NN; i++ {
		//512 KB message
		targets[i] = make([]byte, 512*1024)
		rand.Read(targets[i])
		sks[i], vks[i] = crypto.GenerateKeypair()
		sigs[i] = make([]byte, 64)
	}
	b.ResetTimer()

	for k := 0; k < b.N; k++ {
		//	for i := 0; i < NN; i++ {
		crypto.SignBlob(sks[0], vks[0], sigs[0], targets[0])
		//	}
	}
}

// Time to sign 256 512KB messages. (just signature generation)
func BenchmarkEd25519Sign2KB(b *testing.B) {

	//Things to sign
	const NN = 256
	targets := make([][]byte, NN)
	vks := make([][]byte, NN)
	sks := make([][]byte, NN)
	sigs := make([][]byte, NN)
	for i := 0; i < NN; i++ {
		//2 KB message
		targets[i] = make([]byte, 2*1024)
		rand.Read(targets[i])
		sks[i], vks[i] = crypto.GenerateKeypair()
		sigs[i] = make([]byte, 64)
	}
	b.ResetTimer()

	for k := 0; k < b.N; k++ {
		//	for i := 0; i < NN; i++ {
		crypto.SignBlob(sks[0], vks[0], sigs[0], targets[0])
		//	}
	}
}

// Time to sign 256 512KB messages. (just signature generation)
func BenchmarkEd25519Sign256B(b *testing.B) {

	//Things to sign
	const NN = 256
	targets := make([][]byte, NN)
	vks := make([][]byte, NN)
	sks := make([][]byte, NN)
	sigs := make([][]byte, NN)
	for i := 0; i < NN; i++ {
		//2 KB message
		targets[i] = make([]byte, 256)
		rand.Read(targets[i])
		sks[i], vks[i] = crypto.GenerateKeypair()
		sigs[i] = make([]byte, 64)
	}
	b.ResetTimer()

	for k := 0; k < b.N; k++ {
		//	for i := 0; i < NN; i++ {
		crypto.SignBlob(sks[0], vks[0], sigs[0], targets[0])
		//	}
	}
}

// Time to verify 256 512KB messages. (just signature verification)
func BenchmarkEd25519Verify512KB(b *testing.B) {
	//Things to sign
	const NN = 256
	targets := make([][]byte, NN)
	vks := make([][]byte, NN)
	sks := make([][]byte, NN)
	sigs := make([][]byte, NN)
	for i := 0; i < NN; i++ {
		//512 KB message
		targets[i] = make([]byte, 512*1024)
		rand.Read(targets[i])
		sks[i], vks[i] = crypto.GenerateKeypair()
		sigs[i] = make([]byte, 64)
	}
	for i := 0; i < NN; i++ {
		crypto.SignBlob(sks[i], vks[i], sigs[i], targets[i])
	}
	b.ResetTimer()
	for k := 0; k < b.N; k++ {
		//	for i := 0; i < NN; i++ {
		ok := crypto.VerifyBlob(vks[0], sigs[0], targets[0])
		if !ok {
			panic("UH")
		}
		//		}
	}
}

func BenchmarkEd25519Verify2KB(b *testing.B) {
	//Things to sign
	const NN = 256
	targets := make([][]byte, NN)
	vks := make([][]byte, NN)
	sks := make([][]byte, NN)
	sigs := make([][]byte, NN)
	for i := 0; i < NN; i++ {
		//2 KB message
		targets[i] = make([]byte, 2*1024)
		rand.Read(targets[i])
		sks[i], vks[i] = crypto.GenerateKeypair()
		sigs[i] = make([]byte, 64)
	}
	for i := 0; i < NN; i++ {
		crypto.SignBlob(sks[i], vks[i], sigs[i], targets[i])
	}
	b.ResetTimer()
	for k := 0; k < b.N; k++ {
		//	for i := 0; i < NN; i++ {
		ok := crypto.VerifyBlob(vks[0], sigs[0], targets[0])
		if !ok {
			panic("UH")
		}
		//	}
	}
}

func BenchmarkEd25519Verify256B(b *testing.B) {
	//Things to sign
	const NN = 256
	targets := make([][]byte, NN)
	vks := make([][]byte, NN)
	sks := make([][]byte, NN)
	sigs := make([][]byte, NN)
	for i := 0; i < NN; i++ {
		//2 KB message
		targets[i] = make([]byte, 256)
		rand.Read(targets[i])
		sks[i], vks[i] = crypto.GenerateKeypair()
		sigs[i] = make([]byte, 64)
	}
	for i := 0; i < NN; i++ {
		crypto.SignBlob(sks[i], vks[i], sigs[i], targets[i])
	}
	b.ResetTimer()
	for k := 0; k < b.N; k++ {
		//	for i := 0; i < NN; i++ {
		ok := crypto.VerifyBlob(vks[0], sigs[0], targets[0])
		if !ok {
			panic("UH")
		}
		//	}
	}
}
func BenchmarkEd25519SecretGen(b *testing.B) {
	//Things to sign
	const NN = 256
	vks1 := make([][]byte, NN)
	sks1 := make([][]byte, NN)
	vks2 := make([][]byte, NN)
	sks2 := make([][]byte, NN)
	for i := 0; i < NN; i++ {
		sks1[i], vks1[i] = crypto.GenerateKeypair()
		sks2[i], vks2[i] = crypto.GenerateKeypair()
	}
	b.ResetTimer()
	for k := 0; k < b.N; k++ {
		//	for i := 0; i < NN; i++ {
		secret1 := crypto.Ed25519CalcSecret(sks1[0], vks2[0])
		_ = secret1
		//	secret2 := crypto.Ed25519CalcSecret(sks2[i], vks1[i])
		//	if !bytes.Equal(secret1, secret2) {
		//		b.Fatalf("whoops")
		//	}
		//	}
	}
}
func BenchmarkDecryptBox_AESK(b *testing.B) {
	ent := objects.CreateNewEntity("", "", nil)
	ent2 := objects.CreateNewEntity("", "", nil)
	omsg := []byte("helloworld234234234234")
	bx := NewBox(ent, omsg)

	bx.AddEd25519Keyhole(ent2.GetVK())
	contents, err := bx.Encrypt()
	if err != nil {
		b.Fatalf("unexpected error %v\n", err)
	}
	aesk := bx.AESK
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		rc, err := DecryptBoxWithAESK(contents, aesk)
		if err != nil {
			b.Fatalf("unexpected error %v\n", err)
		}
		_ = rc
	}
}
func BenchmarkDecryptBox_10_IBE(b *testing.B) {
	ent := objects.CreateNewEntity("", "", nil)
	omsg := []byte("helloworld234234234234")
	bx := NewBox(ent, omsg)

	pub, priv := ibe.Setup(rand.Reader)
	_ = priv
	id := []byte("someidfgdfgdfgdfgdentity")

	for i := 0; i < 9; i++ {
		bx.AddIBEKeyhole(pub, []byte(fmt.Sprintf("random%d", i)))
	}
	bx.AddIBEKeyhole(pub, id)
	contents, err := bx.Encrypt()
	if err != nil {
		b.Fatalf("unexpected error %v\n", err)
	}
	bid := ExtractIdentity(pub, priv, id)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		contents, err := DecryptBoxWithIBEK(contents, bid)
		if err != nil {
			b.Fatalf("unexpected error %v\n", err)
		}
		_ = contents
	}
}
func BenchmarkIBEKeyhole0(b *testing.B) {
	ent := objects.CreateNewEntity("", "", nil)

	bx := NewBox(ent, []byte("helloworld234234234234"))

	pub, priv := ibe.Setup(rand.Reader)
	_ = priv
	b.ResetTimer()
	id := []byte("hello world id")
	for i := 0; i < b.N; i++ {
		bx.makeIBEKeyhole(pub, id)
	}
}
func BenchmarkIBEKeyhole1(b *testing.B) {
	ent := objects.CreateNewEntity("", "", nil)

	bx := NewBox(ent, []byte("helloworld234234234234"))

	pub, priv := ibe.Setup(rand.Reader)
	_ = priv
	b.ResetTimer()
	id := []byte("hello world id")
	for i := 0; i < b.N; i++ {
		bx.makeIBEKeyholeOrig(pub, id)
	}
}
func BenchmarkOpenIBEKeyholeGenIdentity(b *testing.B) {
	ent := objects.CreateNewEntity("", "", nil)

	bx := NewBox(ent, []byte("helloworld234234234234"))

	pub, priv := ibe.Setup(rand.Reader)
	_ = priv
	b.ResetTimer()
	id := []byte("hello world id")
	kh := bx.makeIBEKeyhole(pub, id)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		identpriv := ibe.Extract(priv, id)
		openIBEKeyhole(identpriv, kh)
	}
}

func BenchmarkOpenIBEKeyholeCachedIdentity(b *testing.B) {
	ent := objects.CreateNewEntity("", "", nil)

	bx := NewBox(ent, []byte("helloworld234234234234"))

	pub, priv := ibe.Setup(rand.Reader)
	_ = priv
	b.ResetTimer()
	id := []byte("hello world id")
	kh := bx.makeIBEKeyhole(pub, id)
	identpriv := ibe.Extract(priv, id)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		openIBEKeyhole(identpriv, kh)
	}
}

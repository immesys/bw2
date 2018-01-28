package dotv3

import (
	"crypto/rand"
	"fmt"
	"testing"

	"vuvuzela.io/crypto/ibe"

	"github.com/immesys/bw2/objects"
)

const BWPUB = "ws:Publish"
const BWSUB = "ws:Subscribe"

func BenchmarkEncryptDOT(b *testing.B) {
	ns := objects.CreateNewEntity("", "", nil)
	src := objects.CreateNewEntity("", "", nil)
	dst := objects.CreateNewEntity("", "", nil)
	dstibepub, dstibepriv := ibe.Setup(rand.Reader)
	_ = dstibepriv
	d := DOTV3{
		Content: &DOTV3Content{
			SRCVK:       src.GetVK(),
			DSTVK:       dst.GetVK(),
			URI:         []byte("foo/bar"),
			Permissions: []string{BWPUB},
			TTL:         5,
		},
		Label: &DOTV3Label{
			Namespace: ns.GetVK(),
			Partition: []byte{},
		},
	}
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, err := d.Encode(src, [][]byte{ns.GetVK()}, []*ibe.MasterPublicKey{dstibepub})
		if err != nil {
			panic(err)
		}
	}
}

func BenchmarkDecryptDOTwIBE(b *testing.B) {
	ns := objects.CreateNewEntity("", "", nil)
	src := objects.CreateNewEntity("", "", nil)
	dst := objects.CreateNewEntity("", "", nil)
	dstibepub, dstibepriv := ibe.Setup(rand.Reader)
	_ = dstibepriv
	d := DOTV3{
		Content: &DOTV3Content{
			SRCVK:       src.GetVK(),
			DSTVK:       dst.GetVK(),
			URI:         []byte("foo/bar"),
			Permissions: []string{BWPUB},
			TTL:         5,
		},
		Label: &DOTV3Label{
			Namespace: ns.GetVK(),
			Partition: []byte{},
		},
	}
	dcontext := &DecryptionContext{
		Pub:  dstibepub,
		Priv: dstibepriv,
	}
	_, err := d.Encode(src, [][]byte{ns.GetVK()}, []*ibe.MasterPublicKey{dstibepub})
	if err != nil {
		panic(err)
	}
	blob := d.Marshal()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		rd, err := LoadDOT(blob)
		if err != nil {
			panic(err)
		}
		err = rd.Reveal(dcontext)
		if err != nil {
			panic(err)
		}
		err = rd.Validate()
		if err != nil {
			panic(err)
		}
	}
}

func BenchmarkDecryptDOTwNSVK(b *testing.B) {
	ns := objects.CreateNewEntity("", "", nil)
	src := objects.CreateNewEntity("", "", nil)
	dst := objects.CreateNewEntity("", "", nil)
	dstibepub, dstibepriv := ibe.Setup(rand.Reader)
	_ = dstibepriv
	d := DOTV3{
		Content: &DOTV3Content{
			SRCVK:       src.GetVK(),
			DSTVK:       dst.GetVK(),
			URI:         []byte("foo/bar"),
			Permissions: []string{BWPUB},
			TTL:         5,
		},
		Label: &DOTV3Label{
			Namespace: ns.GetVK(),
			Partition: []byte{},
		},
	}
	dcontext := &DecryptionContext{
		Entity: ns,
	}
	_, err := d.Encode(src, [][]byte{ns.GetVK()}, []*ibe.MasterPublicKey{dstibepub})
	if err != nil {
		panic(err)
	}
	blob := d.Marshal()
	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		rd, err := LoadDOT(blob)
		if err != nil {
			panic(err)
		}
		err = rd.Reveal(dcontext)
		if err != nil {
			panic(err)
		}
		err = rd.Validate()
		if err != nil {
			panic(err)
		}
	}
}

func BenchmarkDecryptDOTwAESK(b *testing.B) {
	ns := objects.CreateNewEntity("", "", nil)
	src := objects.CreateNewEntity("", "", nil)
	dst := objects.CreateNewEntity("", "", nil)
	dstibepub, dstibepriv := ibe.Setup(rand.Reader)
	_ = dstibepriv
	d := DOTV3{
		Content: &DOTV3Content{
			SRCVK:       src.GetVK(),
			DSTVK:       dst.GetVK(),
			URI:         []byte("foo/bar"),
			Permissions: []string{BWPUB},
			TTL:         5,
		},
		Label: &DOTV3Label{
			Namespace: ns.GetVK(),
			Partition: []byte{},
		},
	}
	aesk, err := d.Encode(src, [][]byte{ns.GetVK()}, []*ibe.MasterPublicKey{dstibepub})
	if err != nil {
		panic(err)
	}
	dcontext := &DecryptionContext{
		AESK: aesk,
	}
	blob := d.Marshal()
	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		rd, err := LoadDOT(blob)
		if err != nil {
			panic(err)
		}
		err = rd.Reveal(dcontext)
		if err != nil {
			panic(err)
		}
		err = rd.Validate()
		if err != nil {
			panic(err)
		}
	}
}

type Entity struct {
	E *objects.Entity
	P *ibe.MasterPublicKey
	p *ibe.MasterPrivateKey
}

func mke() *Entity {
	e := objects.CreateNewEntity("", "", nil)
	dstibepub, dstibepriv := ibe.Setup(rand.Reader)
	return &Entity{
		E: e,
		P: dstibepub,
		p: dstibepriv,
	}
}
func pubdot(eng *Engine, src *Entity, dst *Entity, ns *Entity, path string) {
	d := DOTV3{
		Content: &DOTV3Content{
			SRCVK:       src.E.GetVK(),
			DSTVK:       dst.E.GetVK(),
			URI:         []byte(path),
			Permissions: []string{BWPUB},
			TTL:         5,
		},
		Label: &DOTV3Label{
			Namespace: ns.E.GetVK(),
			Partition: []byte{},
		},
	}
	aesk, err := d.Encode(src.E, [][]byte{ns.E.GetVK()}, []*ibe.MasterPublicKey{dst.P})
	if err != nil {
		panic(err)
	}
	d.Label.AESK = aesk
	eng.InsertDOT(&d)
    totalDots++
}

func xrecurse(e *Engine, rem []int, from *Entity, ns *Entity) *Entity {
	if len(rem) == 0 {
		//fmt.Printf("child entity: %v\n", crypto.FmtKey(from.E.GetVK()))
		return from
	}
	var rv *Entity
	for i := 0; i < rem[0]; i++ {
		child := mke()
		pubdot(e, from, child, ns, fmt.Sprintf("foo/bar%d", i))
		subrv := xrecurse(e, rem[1:], child, ns)
		if rv == nil {
			//x fmt.Printf("child is %d\n", i)
			rv = subrv
		}
	}
	return rv
}
func recurse(e *Engine, level int, from *Entity, ns *Entity) *Entity {
	if level == 0 {
		//fmt.Printf("child entity: %v\n", crypto.FmtKey(from.E.GetVK()))
		return from
	}
	var rv *Entity
	for i := 0; i < 5; i++ {
		child := mke()
		pubdot(e, from, child, ns, fmt.Sprintf("foo/bar%d", i))
		rv = recurse(e, level-1, child, ns)
	}
	return rv
}
func recurseall(e *Engine, level int, from *Entity, ns *Entity) *Entity {
	if level == 0 {
		//fmt.Printf("child entity: %v\n", crypto.FmtKey(from.E.GetVK()))
		return from
	}
	var rv *Entity
	for i := 0; i < 5; i++ {
		child := mke()
		pubdot(e, from, child, ns, "foo/bar")
		rv = recurseall(e, level-1, child, ns)
	}
	return rv
}

func Benchmark5eChainBuild(b *testing.B) {
	eng := NewEngine()
	ns := mke()
	child := recurse(eng, 5, ns, ns)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		cb := NewChainBuilder(eng, ns.E.GetVK(), "foo/bar4", BWPUB, child.E.GetVK())
		rv, err := cb.Build()
		if err != nil {
			panic(err)
		}
		if len(rv) == 0 {
			panic("no chains")
		}
	}
	eng.Close()
}
func Benchmark5eChainBuildAll(b *testing.B) {
	eng := NewEngine()
	ns := mke()
	child := recurseall(eng, 5, ns, ns)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		cb := NewChainBuilder(eng, ns.E.GetVK(), "foo/bar", BWPUB, child.E.GetVK())
		rv, err := cb.Build()
		if err != nil {
			panic(err)
		}
		if len(rv) == 0 {
			panic("no chains")
		}
	}
	eng.Close()
}
var totalDots int
func BenchmarkUtility(b *testing.B) {
	eng := NewEngine()
	ns := mke()
    totalDots=0
	fmt.Printf("Starting insert of nodes\n")
	child := xrecurse(eng, []int{36, 100, 100}, ns, ns)
	fmt.Printf("Insert of nodes complete (%d)\n",totalDots)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		cb := NewChainBuilder(eng, ns.E.GetVK(), "foo/bar0", BWPUB, child.E.GetVK())
		rv, err := cb.Build()
		if err != nil {
			panic(err)
		}
		if len(rv) == 0 {
			panic("no chains")
		}
	}
	eng.Close()
}

//
// func TestThingy(t *testing.T) {
// 	BuildCorpus()
// }

//
// func TestBoxEncrypt(t *testing.T) {
// 	ent := objects.CreateNewEntity("", "", nil)
// 	omsg := []byte("helloworld234234234234")
// 	bx := NewBox(ent, omsg)
//
// 	pub, priv := ibe.Setup(rand.Reader)
// 	_ = priv
// 	id := []byte("someidfgdfgdfgdfgdentity")
// 	bx.AddIBEKeyhole(pub, id)
//
// 	contents, err := bx.Encrypt()
// 	if err != nil {
// 		t.Fatalf("unexpected error %v\n", err)
// 	}
// 	//fmt.Printf("contents %x\n", contents)
//
// 	bxid := ExtractIdentity(pub, priv, id)
// 	msg, err := DecryptBoxWithIBEK(contents, bxid)
// 	if err != nil {
// 		t.Fatalf("unexpected error %v\n", err)
// 	}
// 	if !bytes.Equal(msg, omsg) {
// 		t.Fatalf("Message did not match")
// 	}
// }
//
// func BenchmarkEncryptBox_1_IBE(b *testing.B) {
// 	ent := objects.CreateNewEntity("", "", nil)
// 	omsg := []byte("helloworld234234234234")
// 	bx := NewBox(ent, omsg)
//
// 	pub, priv := ibe.Setup(rand.Reader)
// 	_ = priv
// 	id := []byte("someidfgdfgdfgdfgdentity")
// 	bx.AddIBEKeyhole(pub, id)
//
// 	b.ResetTimer()
// 	for i := 0; i < b.N; i++ {
// 		contents, err := bx.Encrypt()
// 		if err != nil {
// 			b.Fatalf("unexpected error %v\n", err)
// 		}
// 		_ = contents
// 	}
// }
// func BenchmarkEncryptBox_1_Ed25519(b *testing.B) {
// 	ent := objects.CreateNewEntity("", "", nil)
// 	ent2 := objects.CreateNewEntity("", "", nil)
// 	omsg := []byte("helloworld234234234234")
// 	bx := NewBox(ent, omsg)
//
// 	bx.AddEd25519Keyhole(ent2.GetVK())
//
// 	b.ResetTimer()
// 	for i := 0; i < b.N; i++ {
// 		contents, err := bx.Encrypt()
// 		if err != nil {
// 			b.Fatalf("unexpected error %v\n", err)
// 		}
// 		_ = contents
// 	}
// }
// func BenchmarkDecryptBox_1_Ed25519(b *testing.B) {
// 	ent := objects.CreateNewEntity("", "", nil)
// 	ent2 := objects.CreateNewEntity("", "", nil)
// 	omsg := []byte("helloworld234234234234")
// 	bx := NewBox(ent, omsg)
//
// 	bx.AddEd25519Keyhole(ent2.GetVK())
// 	contents, err := bx.Encrypt()
// 	if err != nil {
// 		b.Fatalf("unexpected error %v\n", err)
// 	}
//
// 	b.ResetTimer()
// 	for i := 0; i < b.N; i++ {
// 		contents, err := DecryptBoxWithEd25519(contents, ent2)
// 		if err != nil {
// 			b.Fatalf("unexpected error %v\n", err)
// 		}
// 		_ = contents
// 	}
// }
// func BenchmarkDecryptBox_10_Ed25519(b *testing.B) {
// 	ent := objects.CreateNewEntity("", "", nil)
// 	ent2 := objects.CreateNewEntity("", "", nil)
// 	omsg := []byte("helloworld234234234234")
// 	bx := NewBox(ent, omsg)
// 	for i := 0; i < 9; i++ {
// 		enti := objects.CreateNewEntity("", "", nil)
// 		bx.AddEd25519Keyhole(enti.GetVK())
// 	}
// 	bx.AddEd25519Keyhole(ent2.GetVK())
// 	contents, err := bx.Encrypt()
// 	if err != nil {
// 		b.Fatalf("unexpected error %v\n", err)
// 	}
//
// 	b.ResetTimer()
// 	for i := 0; i < b.N; i++ {
// 		contents, err := DecryptBoxWithEd25519(contents, ent2)
// 		if err != nil {
// 			b.Fatalf("unexpected error %v\n", err)
// 		}
// 		_ = contents
// 	}
// }
// func BenchmarkDecryptBox_1_IBE(b *testing.B) {
// 	ent := objects.CreateNewEntity("", "", nil)
// 	omsg := []byte("helloworld234234234234")
// 	bx := NewBox(ent, omsg)
//
// 	pub, priv := ibe.Setup(rand.Reader)
// 	_ = priv
// 	id := []byte("someidfgdfgdfgdfgdentity")
// 	bx.AddIBEKeyhole(pub, id)
// 	contents, err := bx.Encrypt()
// 	if err != nil {
// 		b.Fatalf("unexpected error %v\n", err)
// 	}
// 	bid := ExtractIdentity(pub, priv, id)
// 	b.ResetTimer()
// 	for i := 0; i < b.N; i++ {
// 		contents, err := DecryptBoxWithIBEK(contents, bid)
// 		if err != nil {
// 			b.Fatalf("unexpected error %v\n", err)
// 		}
// 		_ = contents
// 	}
// }

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

/*
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
*/

package objects

import (
	"crypto/rand"
	"fmt"
	"reflect"
	"testing"
	"time"

	"github.com/immesys/bw2/crypto"
)

// type DOT struct {
// 	Content    []byte
// 	Hash       []byte
// 	GiverVK    []byte //VK
// 	ReceiverVK []byte
// 	Expires    *time.Time
// 	Created    *time.Time
// 	Revokers   [][]byte
// 	Contact    string
// 	Comment    string
// 	Signature  []byte
// 	IsAccess   bool
//
// 	//Only for ACCESS dot
// 	MVK            []byte
// 	UriSuffix      string
// 	Uri            string
// 	PubLim         *PublishLimits
// 	CanPublish     bool
// 	CanConsume     bool
// 	CanConsumePlus bool
// 	CanConsumeStar bool
// 	CanTap         bool
// 	CanTapPlus     bool
// 	CanTapStar     bool
// 	CanList        bool
//
// 	//Only for Permission dot
// 	KV map[string]string
// }

func TestSig(t *testing.T) {
	sk, vk := crypto.GenerateKeypair()
	//fmt.Println("SK:", crypto.FmtKey(sk))
	//fmt.Println("VK:", crypto.FmtKey(vk))
	blob := make([]byte, 128)
	rand.Read(blob)
	sig := make([]byte, 64)
	crypto.SignBlob(sk, vk, sig, blob)
	//fmt.Println("Sig:", crypto.FmtSig(sig))

	//Now lets try verify the sig
	if !crypto.VerifyBlob(vk, sig, blob) {
		t.FailNow()
	}
	//fmt.Println("Sig checks out")
	sig[0] ^= 0x01
	if crypto.VerifyBlob(vk, sig, blob) {
		t.FailNow()
	}
	//fmt.Println("Bad Sig fails ok")
}

func TestVectorSig(t *testing.T) {
	sk, vk := crypto.GenerateKeypair()
	//fmt.Println("SK:", crypto.FmtKey(sk))
	//fmt.Println("VK:", crypto.FmtKey(vk))
	blob := make([]byte, 128)
	rand.Read(blob)
	sig := make([]byte, 64)
	vsig := make([]byte, 64)
	crypto.SignBlob(sk, vk, sig, blob)
	crypto.SignVector(sk, vk, vsig, blob[0:16], blob[16:32], blob[32:64], blob[64:128])
	for i, expected := range sig {
		if vsig[i] != expected {
			fmt.Printf("Byte %d differed", i)
			t.FailNow()
		}
	}
	//fmt.Println("Sig:", crypto.FmtSig(vsig))
}

func BenchmarkSignBlob(b *testing.B) {
	sk, vk := crypto.GenerateKeypair()
	//fmt.Println("SK:", crypto.FmtKey(sk))
	//fmt.Println("VK:", crypto.FmtKey(vk))
	blob := make([]byte, 128)
	rand.Read(blob)
	sig := make([]byte, 64)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		crypto.SignBlob(sk, vk, sig, blob)
	}
}
func BenchmarkSignVector(b *testing.B) {
	sk, vk := crypto.GenerateKeypair()
	//fmt.Println("SK:", crypto.FmtKey(sk))
	//fmt.Println("VK:", crypto.FmtKey(vk))
	blob := make([]byte, 128)
	rand.Read(blob)
	vsig := make([]byte, 64)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		crypto.SignVector(sk, vk, vsig, blob[0:16], blob[16:32], blob[32:64], blob[64:128])
	}
}
func BenchmarkVerifyBlob(b *testing.B) {
	sk, vk := crypto.GenerateKeypair()
	//fmt.Println("SK:", crypto.FmtKey(sk))
	//fmt.Println("VK:", crypto.FmtKey(vk))
	blob := make([]byte, 128)
	rand.Read(blob)
	sig := make([]byte, 64)
	crypto.SignBlob(sk, vk, sig, blob)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		crypto.VerifyBlob(vk, sig, blob)
	}
}

//
func TestMakeAccessDOT(t *testing.T) {
	fromSK, fromVK := crypto.GenerateKeypair()
	_, toVK := crypto.GenerateKeypair()
	d := CreateDOT(true, fromVK, toVK)
	d.SetAccessURI(fromVK, "foo/bar")
	d.SetCanPublish(true)
	d.SetCanConsume(true, true, true)
	d.SetExpireFromNow(1 * time.Minute)
	d.Encode(fromSK)

	content := d.content
	newdTmp, err := NewDOT(ROAccessDOT, content)
	newd := newdTmp.(*DOT)
	if err != nil {
		fmt.Printf("Error: %+v", err)
		t.Fail()
	}

	if !reflect.DeepEqual(d, newd) {
		fmt.Printf("Not Equal!!")
		fmt.Printf("\nold: %+v\n", d)
		fmt.Printf("\nnew: %+v\n", newd)
		t.Fail()
	}
}

func TestMakePermissionDOT(t *testing.T) {
	fromSK, fromVK := crypto.GenerateKeypair()
	_, toVK := crypto.GenerateKeypair()
	d := CreateDOT(false, fromVK, toVK)
	d.SetExpireFromNow(1 * time.Minute)
	d.SetPermission("foo", "bar")
	d.SetPermission("baz", "boop")
	d.Encode(fromSK)

	content := d.content
	newdTmp, err := NewDOT(ROPermissionDOT, content)
	if err != nil {
		fmt.Printf("Error: %+v\n", err)
		t.Fail()
	}
	newd := newdTmp.(*DOT)

	if !reflect.DeepEqual(d, newd) {
		fmt.Println("Not Equal!!")
		fmt.Printf("\nold: %+v\n", d)
		fmt.Printf("\nnew: %+v\n", newd)
		t.Fail()
	}

	if !d.SigValid() {
		fmt.Println("Signature invalid")
		t.Fail()
	}
	if !newd.SigValid() {
		fmt.Println("Signature invalid")
		t.Fail()
	}
}

func TestMakeEntity(t *testing.T) {
	e := CreateNewEntity("contact", "comment", [][]byte{}, 1*time.Minute)
	e.Encode()
	cnt := e.GetContent()

	netmp, err := NewEntity(ROEntity, cnt)
	if err != nil {
		fmt.Println("Creation error: ", err)
	}
	ne := netmp.(*Entity)
	ne.SetSK(e.sk)
	if !reflect.DeepEqual(e, ne) {
		fmt.Println("Not Equal!!")
		fmt.Printf("\nold: %+v\n", e)
		fmt.Printf("\nnew: %+v\n", ne)
		t.Fail()
	}
}

// func TestMakeDOT(t *testing.T) {
//   d := DOT{}
// 	bw := OpenBWContext(nil)
// 	// f := func(s string) {
// 	// 	fmt.Printf("Got: %v", s)
// 	// }
// 	client1 := bw.CreateClient(func() {
// 		fmt.Println("C1 Queue changed")
// 	})
// 	client1.Subscribe(MakeSub("/a/*/b", nil))
// 	client2 := bw.CreateClient(nil)
// 	client2.Subscribe(MakeSub("/a/b/b/b", func(m *core.Message) {
// 		fmt.Println("Got message: ", string(m.Payload))
// 	}))
// 	client1.Publish(MakeMsg("/a/b/b/b", "foo"))
// 	//client.Publish("/a/b/c", "foo")
// }

package papertests

import (
	"bytes"
	"crypto/rand"
	"fmt"
	"testing"

	"golang.org/x/crypto/curve25519"

	"github.com/immesys/bw2/crypto"
)

// Time to sign 256 512KB messages. (just signature generation)
func BenchmarkEd25519Sign512(b *testing.B) {

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
		for i := 0; i < NN; i++ {
			crypto.SignBlob(sks[i], vks[i], sigs[i], targets[i])
		}
	}
}

// Time to sign 256 512KB messages. (just signature generation)
func BenchmarkEd25519Sign2(b *testing.B) {

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
		for i := 0; i < NN; i++ {
			crypto.SignBlob(sks[i], vks[i], sigs[i], targets[i])
		}
	}
}

// Time to verify 256 512KB messages. (just signature verification)
func BenchmarkEd25519Verify512(b *testing.B) {
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
		for i := 0; i < NN; i++ {
			ok := crypto.VerifyBlob(vks[i], sigs[i], targets[i])
			if !ok {
				panic("UH")
			}
		}
	}
}

func BenchmarkEd25519Verify2(b *testing.B) {
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
		for i := 0; i < NN; i++ {
			ok := crypto.VerifyBlob(vks[i], sigs[i], targets[i])
			if !ok {
				panic("UH")
			}
		}
	}
}

//
// func TestSanity(t *testing.T) {
// 	sk1, vk1 := crypto.GenerateKeypair()
// 	//sk2, vk2 := crypto.GenerateKeypair()
//
// 	paramsk1 := [32]byte{}
// 	copy(paramsk1[:], sk1)
// 	tstvk1 := [32]byte{}
// 	check := crypto.SKExt(sk1)
// 	fmt.Printf("chk %064x\nand %064x\n", check[0:32], check[32:64])
//
// 	pk2 := crypto.ConvertEd25519VKtoCurve25519PK(vk1)
// 	fmt.Printf("pk2 %064x\n", pk2)
// 	smmb := crypto.SMMB(sk1)
// 	fmt.Printf("smb %064x\n", smmb)
// 	curve25519.ScalarBaseMult(&tstvk1, &paramsk1)
// 	fmt.Printf("rVK %064x\n", vk1)
// 	fmt.Printf("gbm %064x\n", tstvk1[:])
//
// 	gbA := crypto.SMMB(check[0:32])
// 	fmt.Printf("gbA %064x\n", gbA)
// 	gbB := crypto.SMMB(check[32:64])
// 	fmt.Printf("gbB %064x\n", gbB)
// 	fmt.Printf("sk  %064x\n", sk1)
// 	if !bytes.Equal(tstvk1[:], vk1) {
// 		t.Fatalf("ScalarBaseMult not so bueno. \nGot %064x\nexp %064x\n", tstvk1[:], vk1)
// 	}
//
// }

func TestSanity2(t *testing.T) {
	edsk1, edvk1 := crypto.GenerateKeypair()
	curvesk1 := crypto.ConvertEd25519SKtoCurve25519SK(edsk1)
	curvepk1 := crypto.ConvertEd25519VKtoCurve25519PK(edvk1)

	//Test that the public key on the curve that we derived from the ed public key
	//is the same as the public key on curve derived from the private curve key
	paramprivk1 := [32]byte{}
	copy(paramprivk1[:], curvesk1)
	pubkey1 := [32]byte{}
	curve25519.ScalarBaseMult(&pubkey1, &paramprivk1)
	if !bytes.Equal(pubkey1[:], curvepk1[:]) {
		t.Fatalf("ed.priv->curve.priv->curve.pub != ed.pub->curve.pub")
	}

	//Make another keypair
	edsk2, edvk2 := crypto.GenerateKeypair()
	curvesk2 := crypto.ConvertEd25519SKtoCurve25519SK(edsk2)
	curvepk2 := crypto.ConvertEd25519VKtoCurve25519PK(edvk2)

	pk1 := [32]byte{}
	copy(pk1[:], curvepk1)
	pk2 := [32]byte{}
	copy(pk2[:], curvepk2)
	sk1 := [32]byte{}
	copy(sk1[:], curvesk1)
	sk2 := [32]byte{}
	copy(sk2[:], curvesk2)

	//Make a shared secret
	secret1 := [32]byte{}
	secret2 := [32]byte{}

	curve25519.ScalarMult(&secret1, &sk2, &pk1)
	curve25519.ScalarMult(&secret2, &sk1, &pk2)

	fmt.Printf("sk1: %064x\nsk2: %064x\n", secret1, secret2)
}

func TestSanity3(t *testing.T) {
	edsk1, edvk1 := crypto.GenerateKeypair()
	edsk2, edvk2 := crypto.GenerateKeypair()

	secret1 := crypto.Ed25519CalcSecret(edsk1, edvk2)
	secret2 := crypto.Ed25519CalcSecret(edsk2, edvk1)
	fmt.Printf("sk1: %064x\nsk2: %064x\n", secret1, secret2)
}

func BenchmarkSecretGen(b *testing.B) {
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

/**
 * The private DOTs will basically be
 * A normal DoT encrypted under AESK k
 * An envelope with the DestVK/SourceVK
 * AESK encrypted under destVK's namespace IBE key
 *  for each auditor
 *  AESK under auditor's namespace IBE key
func BenchmarkIBEExtract(b *testing.B) {
	_, masterPriv := Setup(rand.Reader)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		Extract(masterPriv, []byte("foo@bar.com"))
	}
}

func BenchmarkDecrypt(b *testing.B) {
	masterPub, masterPriv := Setup(rand.Reader)

	msg := make([]byte, 32)
	rand.Read(msg)

	ctxt := Encrypt(rand.Reader, masterPub, []byte("alice@example.com"), msg)
	idAlice := Extract(masterPriv, []byte("alice@example.com"))

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, ok := Decrypt(idAlice, ctxt)
		if !ok {
			b.Fatalf("error decrypting")
		}
	}
}
*/

package coldstore

import (
	"bytes"
	"crypto/ecdsa"
	"encoding/base64"
	"fmt"
	"math/big"

	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2bc/common"
	ethcrypto "github.com/immesys/bw2bc/crypto"
	"golang.org/x/crypto/blowfish"
	"golang.org/x/crypto/sha3"
)

var magicCipherData = []byte{
	0x4f, 0x72, 0x70, 0x68,
	0x65, 0x61, 0x6e, 0x42,
	0x65, 0x68, 0x6f, 0x6c,
	0x64, 0x65, 0x72, 0x53,
	0x63, 0x72, 0x79, 0x44,
	0x6f, 0x75, 0x62, 0x74,
}

var fixedSalt = []byte{
	0xa1, 0xf5, 0x50, 0x2f,
	0x19, 0x72, 0xfe, 0x8f,
	0x91, 0x7c, 0x2a, 0x5f,
	0x28, 0x7a, 0x7b, 0xe1,
}

const maxCryptedHashSize = 23

const alphabet = "./ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

var bcEncoding = base64.NewEncoding(alphabet)

func bcrypt(password []byte, cost int, salt []byte) ([]byte, error) {
	cipherData := make([]byte, len(magicCipherData))
	copy(cipherData, magicCipherData)

	c, err := expensiveBlowfishSetup(password, uint32(cost), salt)
	if err != nil {
		return nil, err
	}

	for i := 0; i < 24; i += 8 {
		for j := 0; j < 64; j++ {
			c.Encrypt(cipherData[i:i+8], cipherData[i:i+8])
		}
	}

	// Bug compatibility with C bcrypt implementations. We only encode 23 of
	// the 24 bytes encrypted.
	hsh := base64Encode(cipherData[:maxCryptedHashSize])
	return hsh, nil
}

func base64Encode(src []byte) []byte {
	n := bcEncoding.EncodedLen(len(src))
	dst := make([]byte, n)
	bcEncoding.Encode(dst, src)
	for dst[n-1] == '=' {
		n--
	}
	return dst[:n]
}

func expensiveBlowfishSetup(key []byte, cost uint32, csalt []byte) (*blowfish.Cipher, error) {

	// Bug compatibility with C bcrypt implementations. They use the trailing
	// NULL in the key string during expansion.
	ckey := append(key, 0)

	c, err := blowfish.NewSaltedCipher(ckey, csalt)
	if err != nil {
		return nil, err
	}

	var i, rounds uint64
	rounds = 1 << cost
	for i = 0; i < rounds; i++ {
		blowfish.ExpandKey(ckey, c)
		blowfish.ExpandKey(csalt, c)
	}

	return c, nil
}

func space4hex(b []byte) string {
	rv := ""
	for len(b) > 0 {
		rv += fmt.Sprintf("%04x ", b[:2])
		b = b[2:]
	}
	return rv
}

func printAddr(ent *objects.Entity, index int) {
	seed := make([]byte, 64)
	copy(seed[0:32], ent.GetSK())
	copy(seed[32:64], common.BigToBytes(big.NewInt(int64(index)), 256))
	rand := sha3.Sum512(seed)
	reader := bytes.NewReader(rand[:])
	privateKeyECDSA, err := ecdsa.GenerateKey(ethcrypto.S256(), reader)
	if err != nil {
		panic(err)
	}
	addr := ethcrypto.PubkeyToAddress(privateKeyECDSA.PublicKey)
	fmt.Printf("Address: %s\n", addr.Hex())
}

func DecodeColdStore(token []byte) *objects.Entity {
	for i := 0; i < 1000; i++ {
		fmt.Printf("Extrapolating cold-store entropy: %.1f %%\r", float64(i)/10)
		nvo, err := bcrypt(token, 7, fixedSalt)
		if err != nil {
			panic(err)
		}
		token = nvo
	}
	sk := make([]byte, 32)
	copy(sk, token)
	vk := crypto.VKforSK(sk)
	ent := objects.CreateLightEntity(vk, sk)
	if !crypto.CheckKeypair(sk, vk) {
		panic("bad keypair")
	}
	fmt.Printf("Entity decoded VK=%s\n", crypto.FmtKey(vk))
	printAddr(ent, 0)
	return ent
}

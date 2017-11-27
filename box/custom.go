package box

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/binary"
	"errors"

	"golang.org/x/crypto/sha3"

	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"

	"vuvuzela.io/crypto/ibe"
)

type BW2Box struct {
	Contents        []byte
	ed25519Keyholes [][]byte
	ibeKeyholes     []ibekeyhole
	AESK            []byte
	owner           *objects.Entity
	isbuilder       bool
}

type ibekeyhole struct {
	targetpk *ibe.MasterPublicKey
	identity []byte
}

func NewBox(owner *objects.Entity, contents []byte) *BW2Box {
	rv := &BW2Box{Contents: contents, isbuilder: true, owner: owner}
	rv.AESK = make([]byte, 32)
	rand.Read(rv.AESK)
	//fmt.Printf("AESK is %x\n", rv.AESK)
	return rv
}

func (bx *BW2Box) AddEd25519Keyhole(VK []byte) {
	if !bx.isbuilder {
		panic("Add keyhole on opened box")
	}
	bx.ed25519Keyholes = append(bx.ed25519Keyholes, VK)
}

func (bx *BW2Box) AddIBEKeyhole(targetpk *ibe.MasterPublicKey, identity []byte) {
	if !bx.isbuilder {
		panic("Add keyhole on opened box")
	}
	bx.ibeKeyholes = append(bx.ibeKeyholes, ibekeyhole{targetpk, identity})
}

type unpackedbox struct {
	ed25519keyholes [][]byte
	ibeKeyholes     [][]byte
	signature       []byte
	aes_ciphertext  []byte
	msglen          int
	vk              []byte
}

const ibekeyholesize = 112
const ed25519keyholesize = 48

func unpackbox(ciphertext []byte) (*unpackedbox, error) {
	rv := unpackedbox{}
	if len(ciphertext) < 16+32+64 {
		return nil, errors.New("this is not a box")
	}
	objtype := binary.LittleEndian.Uint16(ciphertext)
	if objtype != 0x85 {
		return nil, errors.New("this is not a box")
	}
	version := binary.LittleEndian.Uint16(ciphertext[2:])
	if version != 0x01 {
		return nil, errors.New("this version of box is too new for this client")
	}
	msgsize := binary.LittleEndian.Uint32(ciphertext[4:])
	num_ibe := binary.LittleEndian.Uint32(ciphertext[8:])
	num_ed := binary.LittleEndian.Uint32(ciphertext[12:])
	rv.msglen = int(msgsize)
	padd := 16 - (msgsize % aes.BlockSize)
	if padd == 16 {
		padd = 0
	}
	expectedsize := 16 + 32 + 64 + ed25519keyholesize*num_ed + ibekeyholesize*num_ibe + msgsize + padd
	if len(ciphertext) != int(expectedsize) {
		return nil, errors.New("box is not the expected size")
	}
	rv.vk = ciphertext[16:48]
	rv.signature = ciphertext[48 : 48+64]
	off := 48 + 64
	for i := 0; i < int(num_ibe); i++ {
		rv.ibeKeyholes = append(rv.ibeKeyholes, ciphertext[off:off+ibekeyholesize])
		off += ibekeyholesize
	}
	for i := 0; i < int(num_ed); i++ {
		rv.ed25519keyholes = append(rv.ed25519keyholes, ciphertext[off:off+ed25519keyholesize])
		off += ed25519keyholesize
	}
	rv.aes_ciphertext = ciphertext[off:]
	return &rv, nil
}

// func DecryptBoxWithEntity(ciphertext []byte, e *objects.Entity) (*BW2Box, error) {
//
// }
type BoxIdentity struct {
	pk *ibe.IdentityPrivateKey
	fp [16]byte
}

func ExtractIdentity(pub *ibe.MasterPublicKey, priv *ibe.MasterPrivateKey, id []byte) *BoxIdentity {
	hsh := sha3.New256()
	bin, err := pub.MarshalBinary()
	if err != nil {
		panic(err)
	}
	hsh.Write(bin)
	hsh.Write(id)
	sumarr := [32]byte{}
	sum := hsh.Sum(sumarr[:0])

	rv := &BoxIdentity{}
	copy(rv.fp[:], sum[:16])
	rv.pk = ibe.Extract(priv, id)
	return rv
}
func decryptBoxWithAESK(bx *unpackedbox, aesk []byte) ([]byte, error) {
	block, err := aes.NewCipher(aesk)
	if err != nil {
		panic(err)
	}
	iv := make([]byte, aes.BlockSize)
	cfb := cipher.NewCFBDecrypter(block, iv)
	rv := make([]byte, len(bx.aes_ciphertext))
	cfb.XORKeyStream(rv, bx.aes_ciphertext)
	rv = rv[:bx.msglen]
	blob := make([]byte, len(rv)+32)
	copy(blob[:32], aesk)
	copy(blob[32:], rv)
	if !crypto.VerifyBlob(bx.vk, bx.signature, blob) {
		return nil, errors.New("Signature is invalid")
	}
	return rv, nil
}
func DecryptBoxWithAESK(ciphertext []byte, aesk []byte) ([]byte, error) {
	bx, err := unpackbox(ciphertext)
	if err != nil {
		return nil, err
	}
	block, err := aes.NewCipher(aesk)
	if err != nil {
		panic(err)
	}
	iv := make([]byte, aes.BlockSize)
	cfb := cipher.NewCFBDecrypter(block, iv)
	rv := make([]byte, len(bx.aes_ciphertext))
	cfb.XORKeyStream(rv, bx.aes_ciphertext)
	rv = rv[:bx.msglen]
	blob := make([]byte, len(rv)+32)
	copy(blob[:32], aesk)
	copy(blob[32:], rv)
	if !crypto.VerifyBlob(bx.vk, bx.signature, blob) {
		return nil, errors.New("Signature is invalid")
	}
	return rv, nil
}
func DecryptBoxWithIBEK(ciphertext []byte, id *BoxIdentity) ([]byte, error) {
	bx, err := unpackbox(ciphertext)
	if err != nil {
		return nil, err
	}
	for _, ibek := range bx.ibeKeyholes {
		//	fmt.Printf("trying %d - %x -> %x\n", idx, ibek[:16], id.fp[:])
		if bytes.Equal(ibek[:16], id.fp[:]) {
			//This is the right key
			aesk := openIBEKeyhole(id.pk, ibek)
			return decryptBoxWithAESK(bx, aesk)
		}
	}
	return nil, errors.New("No keyhole fits")
}
func DecryptBoxWithEd25519(ciphertext []byte, ent *objects.Entity) ([]byte, error) {
	bx, err := unpackbox(ciphertext)
	if err != nil {
		return nil, err
	}
	for _, eddk := range bx.ed25519keyholes {
		if bytes.Equal(eddk[:16], ent.GetVK()[:16]) {
			aesk := openEd25519Keyhole(ent.GetSK(), bx.aes_ciphertext[:16], bx.vk, eddk)
			return decryptBoxWithAESK(bx, aesk)
		}
	}
	return nil, errors.New("No keyhole fits")
}

// func encrypt(key, text []byte) ([]byte, error) {
// 	block, err := aes.NewCipher(key)
// 	if err != nil {
// 		return nil, err
// 	}
// 	ciphertext := make([]byte, len(text))
// 	iv := make([]byte, aes.BlockSize)
// 	cfb := cipher.NewCFBEncrypter(block, iv)
// 	cfb.XORKeyStream(ciphertext, text)
// 	return ciphertext, nil
// }
//
// func decrypt(key, text []byte) ([]byte, error) {
// 	block, err := aes.NewCipher(key)
// 	if err != nil {
// 		return nil, err
// 	}
// 	if len(text) < aes.BlockSize {
// 		return nil, errors.New("ciphertext too short")
// 	}
// 	iv := make([]byte, aes.BlockSize)
// 	cfb := cipher.NewCFBDecrypter(block, iv)
// 	cfb.XORKeyStream(text, text)
// 	return text, nil
// }

func (bx *BW2Box) makeIBEKeyhole(pub *ibe.MasterPublicKey, id []byte) []byte {
	//An IBE keyhole is:
	// [16: hash of master public + id] [ 64: RP bytes ] [ 32: ciphertext ]
	rpb, secret := ibe.GetEncryptSecret(rand.Reader, pub, id)
	//fmt.Printf("rpb is\n%d:%x secret is \n%x\n", len(rpb), rpb, secret)
	hsh := sha3.New256()
	bin, err := pub.MarshalBinary()
	if err != nil {
		panic(err)
	}
	hsh.Write(bin)
	hsh.Write(id)
	rv := make([]byte, 16+64+32)
	sumarr := [32]byte{}
	sum := hsh.Sum(sumarr[:0])
	copy(rv[0:16], sum[0:16])
	copy(rv[16:80], rpb)

	//Encrypt (zero IV)
	block, err := aes.NewCipher(secret)
	if err != nil {
		panic(err)
	}
	iv := make([]byte, aes.BlockSize)
	cfb := cipher.NewCFBEncrypter(block, iv)
	cfb.XORKeyStream(rv[80:], bx.AESK)
	return rv
}
func (bx *BW2Box) makeEd25519Keyhole(vk []byte, nonce []byte) []byte {
	rawsecret := crypto.Ed25519CalcSecret(bx.owner.GetSK(), vk)
	hsh := sha3.New256()
	hsh.Write(rawsecret)
	hsh.Write(nonce)
	digest := [32]byte{}
	secret := hsh.Sum(digest[:0])
	block, err := aes.NewCipher(secret)
	if err != nil {
		panic(err)
	}
	rv := make([]byte, 48)
	copy(rv[0:16], vk[0:16])
	iv := make([]byte, aes.BlockSize)
	cfb := cipher.NewCFBEncrypter(block, iv)
	cfb.XORKeyStream(rv[16:48], bx.AESK)
	return rv
}

func openEd25519Keyhole(sk []byte, nonce []byte, srcvk []byte, keyhole []byte) []byte {
	ciphertext := keyhole[16:48]
	rawsecret := crypto.Ed25519CalcSecret(sk, srcvk)
	hsh := sha3.New256()
	hsh.Write(rawsecret)
	hsh.Write(nonce)
	digest := [32]byte{}
	secret := hsh.Sum(digest[:0])
	block, err := aes.NewCipher(secret)
	if err != nil {
		panic(err)
	}
	rv := make([]byte, 32)
	iv := make([]byte, aes.BlockSize)
	cfb := cipher.NewCFBDecrypter(block, iv)
	cfb.XORKeyStream(rv, ciphertext)
	return rv
}

func openIBEKeyhole(priv *ibe.IdentityPrivateKey, keyhole []byte) []byte {
	rpb := keyhole[16:80]
	//fmt.Printf("rpb param is\n%x\n", rpb)
	secret := ibe.GetDecryptSecret(priv, rpb)
	if len(secret) != 32 {
		panic("I dont get it")
	}
	block, err := aes.NewCipher(secret)
	if err != nil {
		panic(err)
	}
	ciphertext := keyhole[80:112]
	rv := make([]byte, 32)
	iv := make([]byte, aes.BlockSize)
	cfb := cipher.NewCFBDecrypter(block, iv)
	cfb.XORKeyStream(rv, ciphertext)
	return rv
}

func (bx *BW2Box) makeIBEKeyholeOrig(pub *ibe.MasterPublicKey, id []byte) []byte {
	if len(bx.AESK) != 32 {
		panic("hmm")
	}
	keyhole_ciphertext := ibe.Encrypt(rand.Reader, pub, id, bx.AESK)
	bin, _ := keyhole_ciphertext.MarshalBinary()
	return bin
}

func (bx *BW2Box) Encrypt() ([]byte, error) {
	if !bx.isbuilder {
		panic("Encrypt on opened box")
	}
	//We assume that the message content has a MAC or hash such
	//that you can tell if trying a keyhole is successful or not
	//you can attach metadata to the box if you want people to know
	//what the keyholes are
	var num_keyholes uint32
	num_keyholes += uint32(len(bx.ibeKeyholes))
	num_keyholes += uint32(len(bx.ed25519Keyholes))

	msglen := len(bx.Contents)
	if msglen < 16 {
		return nil, errors.New("You cannot put messages shorter than 16 bytes into a box")
	}
	padd := aes.BlockSize - (msglen % aes.BlockSize)
	if padd == aes.BlockSize {
		padd = 0
	}
	//16 for preamble
	//32 for VK
	//64 for signature
	//msglen + padd for content
	nonmessagedata := 16 + 32 + 64 + ed25519keyholesize*len(bx.ed25519Keyholes) + ibekeyholesize*len(bx.ibeKeyholes)
	out := make([]byte, nonmessagedata+msglen+padd)
	binary.LittleEndian.PutUint16(out[0:], 0x85) //box type object
	binary.LittleEndian.PutUint16(out[2:], 0x01) //version 1 of box
	binary.LittleEndian.PutUint32(out[4:], uint32(len(bx.Contents)))
	binary.LittleEndian.PutUint32(out[8:], uint32(len(bx.ibeKeyholes)))
	binary.LittleEndian.PutUint32(out[12:], uint32(len(bx.ed25519Keyholes)))
	copy(out[16:48], bx.owner.GetVK())
	mblock, err := aes.NewCipher(bx.AESK)
	if err != nil {
		return nil, err
	}
	plaintext := make([]byte, msglen+padd)
	copy(plaintext, bx.Contents)
	iv := make([]byte, aes.BlockSize) //zero
	cfb := cipher.NewCFBEncrypter(mblock, iv)
	ciphertext := out[nonmessagedata:]
	cfb.XORKeyStream(ciphertext, plaintext)
	//We are using the AESK as a type of nonce here to prevent the signature from
	//meaning too much on the message contents (so an oracle attack cannot use
	//box signing to make DoTs for example)
	vec := []byte{}
	vec = append(vec, bx.AESK...)
	vec = append(vec, bx.Contents...)
	crypto.SignBlob(bx.owner.GetSK(), bx.owner.GetVK(), out[48:48+64], vec) //,, bx.AESK, bx.Contents)
	off := 48 + 64
	for i := 0; i < len(bx.ibeKeyholes); i++ {
		keyhole_ciphertext := bx.makeIBEKeyhole(bx.ibeKeyholes[i].targetpk, bx.ibeKeyholes[i].identity)
		copy(out[off:], keyhole_ciphertext)
		if len(keyhole_ciphertext) != ibekeyholesize {
			panic("wong")
		}
		off += ibekeyholesize
	}

	for i := 0; i < len(bx.ed25519Keyholes); i++ {
		keyhole_ciphertext := bx.makeEd25519Keyhole(bx.ed25519Keyholes[i], ciphertext[:16])
		copy(out[off:], keyhole_ciphertext)
	}
	return out, nil
}

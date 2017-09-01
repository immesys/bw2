package dotv3

import (
	"fmt"

	"github.com/immesys/bw2/box"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
	"vuvuzela.io/crypto/ibe"
)

//Available information to assist decryption
type DecryptionContext struct {
	Pub    *ibe.MasterPublicKey
	Priv   *ibe.MasterPrivateKey
	Entity *objects.Entity
	AESK   []byte
}

func LoadDOT(blob []byte) (*DOTV3, error) {
	lbl := &DOTV3Label{}
	rem, err := lbl.UnmarshalMsg(blob)
	if err != nil {
		return nil, err
	}
	sig := rem[:64]
	ec := rem[64:]
	lbl.Signature = sig
	return &DOTV3{
		Label:            lbl,
		EncodedLabel:     blob[:len(blob)-len(rem)],
		EncryptedContent: ec,
	}, nil
}

func (dt *DOTV3) Reveal(ctx *DecryptionContext) error {
	if len(ctx.AESK) != 0 {
		blob, err := box.DecryptBoxWithAESK(dt.EncryptedContent, ctx.AESK)
		if err == nil {
			dt.PlaintextContent = blob
			content := &DOTV3Content{}
			rem, err := content.UnmarshalMsg(blob)
			if err != nil {
				panic(err)
			}
			if len(rem) != 0 {
				panic("remaining bytes")
			}
			dt.Content = content
			return nil
		}
	}
	if ctx.Entity != nil {
		blob, err := box.DecryptBoxWithEd25519(dt.EncryptedContent, ctx.Entity)
		if err == nil {
			dt.PlaintextContent = blob
			content := &DOTV3Content{}
			rem, err := content.UnmarshalMsg(blob)
			if err != nil {
				panic(err)
			}
			if len(rem) != 0 {
				panic("remaining bytes")
			}
			dt.Content = content
			return nil
		}
	}
	if ctx.Pub != nil && ctx.Priv != nil {
		id := append([]byte{}, dt.Label.Namespace...)
		id = append(id, dt.Label.Partition...)
		bid := box.ExtractIdentity(ctx.Pub, ctx.Priv, id)
		blob, err := box.DecryptBoxWithIBEK(dt.EncryptedContent, bid)
		if err == nil {
			dt.PlaintextContent = blob
			content := &DOTV3Content{}
			rem, err := content.UnmarshalMsg(blob)
			if err != nil {
				panic(err)
			}
			if len(rem) != 0 {
				panic("remaining bytes")
			}
			dt.Content = content
			return nil
		}
	}
	return fmt.Errorf("insufficient stuffs in context")
}

func (dt *DOTV3) Encode(src *objects.Entity, ed25519Recipients [][]byte, ibeRecipients []*ibe.MasterPublicKey) ([]byte, error) {
	plaintextcontents, err := dt.Content.MarshalMsg(nil)
	if err != nil {
		panic(err)
	}
	dt.PlaintextContent = plaintextcontents
	bx := box.NewBox(src, plaintextcontents)
	for _, vk := range ed25519Recipients {
		bx.AddEd25519Keyhole(vk)
	}
	for _, ibek := range ibeRecipients {
		id := append([]byte{}, dt.Label.Namespace...)
		id = append(id, dt.Label.Partition...)
		bx.AddIBEKeyhole(ibek, id)
	}
	dt.EncryptedContent, err = bx.Encrypt()
	if err != nil {
		panic(err)
	}
	sig := make([]byte, 64)
	dt.Label.Signature = nil
	dt.EncodedLabel, err = dt.Label.MarshalMsg(nil)
	if err != nil {
		panic(err)
	}
	vec := make([]byte, 0, len(dt.EncodedLabel)+len(dt.PlaintextContent))
	vec = append(vec, dt.EncodedLabel...)
	vec = append(vec, dt.PlaintextContent...)
	crypto.SignBlob(src.GetSK(), src.GetVK(), sig, vec)
	if err != nil {
		panic(err)
	}
	dt.Label.Signature = sig
	return bx.AESK, nil
}

func (dt *DOTV3) Marshal() []byte {
	if len(dt.EncodedLabel) == 0 || len(dt.EncryptedContent) == 0 {
		panic("need to encode first")
	}
	rv := make([]byte, 0, len(dt.EncodedLabel)+len(dt.EncryptedContent)+64)
	rv = append(rv, dt.EncodedLabel...)
	rv = append(rv, dt.Label.Signature...)
	rv = append(rv, dt.EncryptedContent...)
	return rv
}

func (dt *DOTV3) Validate() error {
	over := []byte{}
	over = append(over, dt.EncodedLabel...)
	over = append(over, dt.PlaintextContent...)

	if !crypto.VerifyBlob(dt.Content.SRCVK, dt.Label.Signature, over) {
		return fmt.Errorf("invalid signature")
	}
	return nil
}

/*
	content    []byte
	hash       []byte
	giverVK    []byte //VK
	receiverVK []byte
	expires    *time.Time
	created    *time.Time
	revokers   [][]byte
	contact    string
	comment    string
	signature  []byte
	isAccess   bool
	ttl        int
	sigok      sigState

	//Only for ACCESS dot
	mVK            []byte
	uriSuffix      string
	uri            string
	pubLim         *PublishLimits
	canPublish     bool
	canConsume     bool
	canConsumePlus bool
	canConsumeStar bool
	canTap         bool
	canTapPlus     bool
	canTapStar     bool
	canList        bool

	//Only for Permission dot
	kv map[string]string

	//This is for users to cache, none of the code here
	//populates these nor are they guaranteed to be correct
	GiverEntity    *Entity
	ReceiverEntity *Entity
}*/

// func Encode

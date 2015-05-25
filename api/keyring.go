package api

import (
	"errors"
	"os"

	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/objects"
)

// KeyRing stores a bunch of entities with SKs. These entities are
// used for signing stuff. They are "us"
type KeyRing struct {
	//Map FmtKey of VK onto Keypair
	KnownSK map[string]*objects.Entity
}

// NewKeyRing creates a new keyring
func NewKeyRing() KeyRing {
	return KeyRing{make(map[string]*objects.Entity)}
}

// AddEntity adds an entity to the keyring, as long as it has a signing key
func (k *KeyRing) AddEntity(e *objects.Entity) error {
	if len(e.GetSK()) == 0 {
		return errors.New("Entity has no SK")
	}
	k.KnownSK[e.StringKey()] = e
	return nil
}

// LoadSKFromFile loads an entity+signing key from a file
// and stores it in the keyring
func (k *KeyRing) LoadSKFromFile(filename string) error {
	kp, err := LoadSKFromFile(filename)
	if err != nil {
		return err
	}
	k.KnownSK[kp.StringKey()] = kp
	return nil
}

// LoadSKFromFile loads an entity+signing key from a file
// and returns it
func LoadSKFromFile(filename string) (*objects.Entity, error) {
	f, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	sk := make([]byte, 32)

	totn := 0
	for totn < 32 {
		n, e := f.Read(sk[totn:32])
		totn += n
		if e != nil {
			return nil, e
		}
	}

	//Now load the Entity:
	bwo, err := objects.LoadBosswaveObject(f)
	f.Close()
	if err != nil {
		return nil, err
	}
	entity, ok := bwo.(*objects.Entity)
	if !ok {
		return nil, errors.New("Malformed secret key file")
	}
	entity.SetSK(sk)
	keysOk := crypto.CheckKeypair(entity.GetSK(), entity.GetVK())
	sigOk := entity.SigValid()
	if !keysOk || !sigOk {
		return nil, errors.New("Invalid keys/signatures in secret key file")
	}
	return entity, nil
}

/*
// CreateNewSigningKeyFile is a wrapper around objects.CreateNewEntity that also writes out
// the keyfile
func CreateNewSigningKeyFile(destfile, contact, comment string, revokers [][]byte,
	expiry time.Duration) (*objects.Entity, error) {
	e := objects.CreateNewEntity(contact, comment, revokers, expiry)
	e.Encode()
	f, err := os.OpenFile(destfile, os.O_CREATE|os.O_WRONLY, 0600)
	if err != nil {
		return nil, err
	}
	_, err = f.Write(e.GetSK())
	if err != nil {
		return nil, err
	}
	err = e.WriteToStream(f, true)
	if err != nil {
		return nil, err
	}
	err = f.Close()
	if err != nil {
		return nil, err
	}
	return e, nil
}
*/

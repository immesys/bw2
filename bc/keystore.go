package bc

import (
	"bytes"
	"crypto/ecdsa"
	"fmt"
	"io"
	"math/big"
	"sync"

	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2bc/common"
	ethcrypto "github.com/immesys/bw2bc/crypto"
	"github.com/pborman/uuid"
	"golang.org/x/crypto/sha3"
)

const MaxEntityAccounts = 16

const namespace = "66d4d61e-957e-4a4a-9959-c0eeb46cbf68"

type entityKeyStore struct {
	ekeys map[Bytes32][]*ethcrypto.Key
	akeys map[common.Address]*ethcrypto.Key
	alist []common.Address
	ents  []*objects.Entity
	mu    sync.Mutex
}

func NewEntityKeyStore() *entityKeyStore {
	rv := &entityKeyStore{
		ekeys: make(map[Bytes32][]*ethcrypto.Key),
		akeys: make(map[common.Address]*ethcrypto.Key),
	}
	return rv
}

// This first consults the cache
func (eks *entityKeyStore) GetEntityAddressByIdx(e *objects.Entity, idx int) common.Address {
	eks.mu.Lock()
	defer eks.mu.Unlock()
	if idx > MaxEntityAccounts {
		panic("Bad IDX")
	}
	vk := SliceToBytes32(e.GetVK())
	k, ok := eks.ekeys[vk]
	if ok {
		return k[idx].Address
	}
	//I don't think we have a use case for fallthru
	panic("Do we need fallthru here?")
}
func (eks *entityKeyStore) AddEntity(ent *objects.Entity) {
	eks.mu.Lock()
	defer eks.mu.Unlock()
	for _, e := range eks.ents {
		if bytes.Equal(e.GetVK(), ent.GetVK()) {
			return
		}
	}
	eks.ents = append(eks.ents, ent)
	mainkeys := make([]*ethcrypto.Key, MaxEntityAccounts)

	for i := 0; i < MaxEntityAccounts; i++ {
		mainkeys[i], _ = createKeyByIndex(ent, i)
		eks.alist = append(eks.alist, mainkeys[i].Address)
		eks.akeys[mainkeys[i].Address] = mainkeys[i]
	}
	vk := SliceToBytes32(ent.GetVK())
	eks.ekeys[vk] = mainkeys
}

func (eks *entityKeyStore) GetEntityKeyAddresses(ent *objects.Entity) ([]common.Address, error) {
	eks.mu.Lock()
	defer eks.mu.Unlock()
	vk := SliceToBytes32(ent.GetVK())
	k, ok := eks.ekeys[vk]
	rv := make([]common.Address, MaxEntityAccounts)
	if ok {
		for i := 0; i < MaxEntityAccounts; i++ {
			rv[i] = k[i].Address
		}
		return rv, nil
	}
	return nil, fmt.Errorf("Could not find addresses")
}
func (eks *entityKeyStore) GetKeyAddresses() ([]common.Address, error) {
	return nil, fmt.Errorf("We don't support this")
	//We could, but I am dubious we want to
	/*
		rv := make([]common.Address, len(eks.alist))
		eks.mu.Lock()
		defer eks.mu.Unlock()
		copy(rv, eks.alist)
		return rv
	*/
}

func createKeyByIndex(ent *objects.Entity, index int) (*ethcrypto.Key, error) {
	seed := make([]byte, 64)
	copy(seed[0:32], ent.GetSK())
	copy(seed[32:64], common.BigToBytes(big.NewInt(int64(index)), 256))
	rand := sha3.Sum512(seed)
	reader := bytes.NewReader(rand[:])
	privateKeyECDSA, err := ecdsa.GenerateKey(ethcrypto.S256(), reader)
	if err != nil {
		return nil, err
	}
	//namespace is public key
	ns := uuid.Parse(namespace)
	id := uuid.NewSHA1(ns, seed)
	key := &ethcrypto.Key{
		Id:         id,
		Address:    ethcrypto.PubkeyToAddress(privateKeyECDSA.PublicKey),
		PrivateKey: privateKeyECDSA,
	}
	return key, nil
}

func (eks *entityKeyStore) GenerateNewKey(r io.Reader, s string) (*ethcrypto.Key, error) {
	return nil, fmt.Errorf("Unsupported operation")
}

func (eks *entityKeyStore) GetKey(addr common.Address, auth string) (*ethcrypto.Key, error) {
	eks.mu.Lock()
	defer eks.mu.Unlock()
	k, ok := eks.akeys[addr]
	if ok {
		return k, nil
	}
	return nil, fmt.Errorf("Addr not found: %x", addr)
}

func (eks *entityKeyStore) StoreKey(k *ethcrypto.Key, auth string) error {
	panic(k)
	//return fmt.Errorf("Unsupported operation")
}
func (eks *entityKeyStore) DeleteKey(k common.Address, auth string) error {
	panic(k)
	//return fmt.Errorf("Unsupported operation")
}
func (eks *entityKeyStore) Cleanup(k common.Address) error {
	panic(k)
	//return fmt.Errorf("Unsupported operation")
}

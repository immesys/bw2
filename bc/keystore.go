package bc

import (
	"bytes"
	"crypto/ecdsa"
	"fmt"
	"math/big"
	"sync"

	"github.com/immesys/bw2/objects"
	ethereum "github.com/immesys/bw2bc"
	"github.com/immesys/bw2bc/accounts"
	"github.com/immesys/bw2bc/accounts/keystore"
	"github.com/immesys/bw2bc/common"
	"github.com/immesys/bw2bc/common/math"
	"github.com/immesys/bw2bc/core/types"
	ethcrypto "github.com/immesys/bw2bc/crypto"
	"github.com/immesys/bw2bc/crypto/secp256k1"
	"github.com/immesys/bw2bc/event"
	"golang.org/x/crypto/sha3"
)

const MaxEntityAccounts = 16

const namespace = "66d4d61e-957e-4a4a-9959-c0eeb46cbf68"

type entityKeyStore struct {
	ekeys map[Bytes32][]*keystore.Key
	akeys map[common.Address]*keystore.Key
	alist []common.Address
	ents  []*objects.Entity
	mu    sync.Mutex
}

func NewEntityKeyStore() *entityKeyStore {
	rv := &entityKeyStore{
		ekeys: make(map[Bytes32][]*keystore.Key),
		akeys: make(map[common.Address]*keystore.Key),
	}
	return rv
}

func (eks *entityKeyStore) URL() accounts.URL {
	panic("probably not required")
}
func (eks *entityKeyStore) Status() string {
	return "okay"
}
func (eks *entityKeyStore) Open(passphrase string) error {
	return nil
}
func (eks *entityKeyStore) Close() error {
	return nil
}
func (eks *entityKeyStore) Accounts() []accounts.Account {
	return []accounts.Account{}
}
func (eks *entityKeyStore) Contains(account accounts.Account) bool {
	return true //probably
}
func (eks *entityKeyStore) Derive(path accounts.DerivationPath, pin bool) (accounts.Account, error) {
	panic("probably not required")
}
func (eks *entityKeyStore) SelfDerive(base accounts.DerivationPath, chain ethereum.ChainStateReader) {
	panic("probably not required")
}

// SignHash calculates a ECDSA signature for the given hash. The produced
// signature is in the [R || S || V] format where V is 0 or 1.
func (eks *entityKeyStore) SignHash(a accounts.Account, hash []byte) ([]byte, error) {
	eks.mu.Lock()
	defer eks.mu.Unlock()
	k, ok := eks.akeys[a.Address]
	if !ok {
		return nil, fmt.Errorf("Addr not found: %x", a.Address)
	}

	// Sign the hash using plain ECDSA operations
	return ethcrypto.Sign(hash, k.PrivateKey)
}

// SignTx signs the given transaction with the requested account.
func (eks *entityKeyStore) SignTx(a accounts.Account, tx *types.Transaction, chainID *big.Int) (*types.Transaction, error) {
	eks.mu.Lock()
	defer eks.mu.Unlock()
	k, ok := eks.akeys[a.Address]
	if !ok {
		return nil, fmt.Errorf("Addr not found: %x", a.Address)
	}

	// Depending on the presence of the chain ID, sign with EIP155 or homestead
	if chainID != nil {
		return types.SignTx(tx, types.NewEIP155Signer(chainID), k.PrivateKey)
	}
	return types.SignTx(tx, types.HomesteadSigner{}, k.PrivateKey)
}

// SignHashWithPassphrase signs hash if the private key matching the given address
// can be decrypted with the given passphrase. The produced signature is in the
// [R || S || V] format where V is 0 or 1.
func (eks *entityKeyStore) SignHashWithPassphrase(a accounts.Account, passphrase string, hash []byte) (signature []byte, err error) {
	return eks.SignHash(a, hash)
}

// SignTxWithPassphrase signs the transaction if the private key matching the
// given address can be decrypted with the given passphrase.
func (eks *entityKeyStore) SignTxWithPassphrase(a accounts.Account, passphrase string, tx *types.Transaction, chainID *big.Int) (*types.Transaction, error) {
	return eks.SignTx(a, tx, chainID)
}

func (eks *entityKeyStore) BWSignTx(accidx int, ent *objects.Entity, tx *types.Transaction, chainID *big.Int) (*types.Transaction, error) {
	eks.mu.Lock()
	defer eks.mu.Unlock()

	vk := SliceToBytes32(ent.GetVK())
	kz, ok := eks.ekeys[vk]

	if !ok {
		return nil, fmt.Errorf("Addr idx not found: %x", accidx)
	}
	k := kz[accidx]
	if chainID != nil {
		return types.SignTx(tx, types.NewEIP155Signer(chainID), k.PrivateKey)
	}
	return types.SignTx(tx, types.HomesteadSigner{}, k.PrivateKey)
}

func (eks *entityKeyStore) Wallets() []accounts.Wallet {
	return []accounts.Wallet{eks}
}

func (eks *entityKeyStore) Subscribe(sink chan<- accounts.WalletEvent) event.Subscription {
	return nil
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
	mainkeys := make([]*keystore.Key, MaxEntityAccounts)

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

func createKeyByIndex(ent *objects.Entity, index int) (*keystore.Key, error) {
	seed := make([]byte, 64)
	copy(seed[0:32], ent.GetSK())
	copy(seed[32:64], math.PaddedBigBytes(big.NewInt(int64(index)), 32))
	rand := sha3.Sum512(seed)
	reader := bytes.NewReader(rand[:])
	privateKeyECDSA, err := ecdsa.GenerateKey(secp256k1.S256(), reader)
	if err != nil {
		return nil, err
	}
	//namespace is public key
	// ns := uuid.Parse(namespace)
	// id := uuid.NewSHA1(ns, seed)
	key := &keystore.Key{
		Address:    ethcrypto.PubkeyToAddress(privateKeyECDSA.PublicKey),
		PrivateKey: privateKeyECDSA,
	}
	return key, nil
}

// func (eks *entityKeyStore) GetKey(addr common.Address, filename string, auth string) (*keystore.Key, error) {
// 	eks.mu.Lock()
// 	defer eks.mu.Unlock()
// 	k, ok := eks.akeys[addr]
// 	if ok {
// 		return k, nil
// 	}
// 	return nil, fmt.Errorf("Addr not found: %x", addr)
// }

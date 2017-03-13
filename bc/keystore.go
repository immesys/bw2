package bc

import (
	"bytes"
	"crypto/ecdsa"
	"fmt"
	"io"
	"math/big"
	"sync"

	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2bc/accounts"
	"github.com/immesys/bw2bc/common"
	"github.com/immesys/bw2bc/core/types"
	ethcrypto "github.com/immesys/bw2bc/crypto"
	"github.com/immesys/bw2bc/crypto/secp256k1"
	"github.com/immesys/bw2bc/event"
	"github.com/pborman/uuid"
	"golang.org/x/crypto/sha3"
)

const MaxEntityAccounts = 16

const namespace = "66d4d61e-957e-4a4a-9959-c0eeb46cbf68"

type entityKeyStore struct {
	ekeys map[Bytes32][]*accounts.Key
	akeys map[common.Address]*accounts.Key
	alist []common.Address
	ents  []*objects.Entity
	mu    sync.Mutex
}

func NewEntityKeyStore() *entityKeyStore {
	rv := &entityKeyStore{
		ekeys: make(map[Bytes32][]*accounts.Key),
		akeys: make(map[common.Address]*accounts.Key),
	}
	return rv
}

// Account represents an Ethereum account located at a specific location defined
// by the optional URL field.
type Account struct {
	Address common.Address `json:"address"` // Ethereum account address derived from the key
	URL     URL            `json:"url"`     // Optional resource locator within a backend
}

// Wallet represents a software or hardware wallet that might contain one or more
// accounts (derived from the same seed).
type Wallet interface {
	// URL retrieves the canonical path under which this wallet is reachable. It is
	// user by upper layers to define a sorting order over all wallets from multiple
	// backends.
	URL() URL

	// Status returns a textual status to aid the user in the current state of the
	// wallet.
	Status() string

	// Open initializes access to a wallet instance. It is not meant to unlock or
	// decrypt account keys, rather simply to establish a connection to hardware
	// wallets and/or to access derivation seeds.
	//
	// The passphrase parameter may or may not be used by the implementation of a
	// particular wallet instance. The reason there is no passwordless open method
	// is to strive towards a uniform wallet handling, oblivious to the different
	// backend providers.
	//
	// Please note, if you open a wallet, you must close it to release any allocated
	// resources (especially important when working with hardware wallets).
	Open(passphrase string) error

	// Close releases any resources held by an open wallet instance.
	Close() error

	// Accounts retrieves the list of signing accounts the wallet is currently aware
	// of. For hierarchical deterministic wallets, the list will not be exhaustive,
	// rather only contain the accounts explicitly pinned during account derivation.
	Accounts() []Account

	// Contains returns whether an account is part of this particular wallet or not.
	Contains(account Account) bool

	// Derive attempts to explicitly derive a hierarchical deterministic account at
	// the specified derivation path. If requested, the derived account will be added
	// to the wallet's tracked account list.
	Derive(path DerivationPath, pin bool) (Account, error)

	// SelfDerive sets a base account derivation path from which the wallet attempts
	// to discover non zero accounts and automatically add them to list of tracked
	// accounts.
	//
	// Note, self derivaton will increment the last component of the specified path
	// opposed to decending into a child path to allow discovering accounts starting
	// from non zero components.
	//
	// You can disable automatic account discovery by calling SelfDerive with a nil
	// chain state reader.
	SelfDerive(base DerivationPath, chain ethereum.ChainStateReader)

	// SignHash requests the wallet to sign the given hash.
	//
	// It looks up the account specified either solely via its address contained within,
	// or optionally with the aid of any location metadata from the embedded URL field.
	//
	// If the wallet requires additional authentication to sign the request (e.g.
	// a password to decrypt the account, or a PIN code o verify the transaction),
	// an AuthNeededError instance will be returned, containing infos for the user
	// about which fields or actions are needed. The user may retry by providing
	// the needed details via SignHashWithPassphrase, or by other means (e.g. unlock
	// the account in a keystore).
	SignHash(account Account, hash []byte) ([]byte, error)

	// SignTx requests the wallet to sign the given transaction.
	//
	// It looks up the account specified either solely via its address contained within,
	// or optionally with the aid of any location metadata from the embedded URL field.
	//
	// If the wallet requires additional authentication to sign the request (e.g.
	// a password to decrypt the account, or a PIN code o verify the transaction),
	// an AuthNeededError instance will be returned, containing infos for the user
	// about which fields or actions are needed. The user may retry by providing
	// the needed details via SignTxWithPassphrase, or by other means (e.g. unlock
	// the account in a keystore).
	SignTx(account Account, tx *types.Transaction, chainID *big.Int) (*types.Transaction, error)

	// SignHashWithPassphrase requests the wallet to sign the given hash with the
	// given passphrase as extra authentication information.
	//
	// It looks up the account specified either solely via its address contained within,
	// or optionally with the aid of any location metadata from the embedded URL field.
	SignHashWithPassphrase(account Account, passphrase string, hash []byte) ([]byte, error)

	// SignTxWithPassphrase requests the wallet to sign the given transaction, with the
	// given passphrase as extra authentication information.
	//
	// It looks up the account specified either solely via its address contained within,
	// or optionally with the aid of any location metadata from the embedded URL field.
	SignTxWithPassphrase(account Account, passphrase string, tx *types.Transaction, chainID *big.Int) (*types.Transaction, error)
}

func (eks *entityKeyStore) Wallets() []accounts.Wallet {
	return []accounts.Wallet{eks}
}

func (eks *entityKeyStore) Subscribe(sink chan-< WalletEvent) event.Subscription {
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
	mainkeys := make([]*accounts.Key, MaxEntityAccounts)

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

func createKeyByIndex(ent *objects.Entity, index int) (*accounts.Key, error) {
	seed := make([]byte, 64)
	copy(seed[0:32], ent.GetSK())
	copy(seed[32:64], common.BigToBytes(big.NewInt(int64(index)), 256))
	rand := sha3.Sum512(seed)
	reader := bytes.NewReader(rand[:])
	privateKeyECDSA, err := ecdsa.GenerateKey(secp256k1.S256(), reader)
	if err != nil {
		return nil, err
	}
	//namespace is public key
	ns := uuid.Parse(namespace)
	id := uuid.NewSHA1(ns, seed)
	key := &accounts.Key{
		Id:         id,
		Address:    ethcrypto.PubkeyToAddress(privateKeyECDSA.PublicKey),
		PrivateKey: privateKeyECDSA,
	}
	return key, nil
}

func (eks *entityKeyStore) GenerateNewKey(r io.Reader, s string) (*accounts.Key, error) {
	return nil, fmt.Errorf("Unsupported operation")
}

func (eks *entityKeyStore) GetKey(addr common.Address, filename string, auth string) (*accounts.Key, error) {
	eks.mu.Lock()
	defer eks.mu.Unlock()
	k, ok := eks.akeys[addr]
	if ok {
		return k, nil
	}
	return nil, fmt.Errorf("Addr not found: %x", addr)
}

func (eks *entityKeyStore) StoreKey(filename string, k *accounts.Key, auth string) error {
	panic(k)
	//return fmt.Errorf("Unsupported operation")
}

func (eks *entityKeyStore) JoinPath(filename string) string {
	panic("joinpath called")
}

package bc

import (
	"context"
	"math/big"

	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2bc/common"
	"github.com/immesys/bw2bc/core/types"
)

type BlockChainClient interface {

	//Set the entity
	SetEntity(*objects.Entity)

	SetDefaultConfirmations(c uint64)
	SetDefaultTimeout(c uint64)

	GetDefaultConfirmations() uint64
	GetDefaultTimeout() uint64

	//Get the address of the given account
	GetAddress(idx int) (addr Address, err error)

	//Get all our addresses
	GetAddresses() ([]Address, error)

	//CallOnChain executed the given UFI on the chain
	CallOnChain(ctx context.Context, account int, ufi UFI, value, gas, gasPrice string, params ...interface{}) (txhash common.Hash, err error)

	//Transact does a transaction from the default account to the given
	//address (in hex) with the given value (in wei). If gas and gasPrice
	//are omitted, defaults will be used. Code contains the transaction data
	//in hex
	Transact(ctx context.Context, fromacc int, to, value, gas, gasPrice string, code []byte) (txhash common.Hash, err error)

	//Like transact but also ensure the transaction is confirmed
	TransactAndCheck(ctx context.Context, fromacc int, to, value, gas, gasPrice string, code []byte, confirmed func(error))

	//Get balance returns the balance of one of our accounts in
	//decimal and human readable
	GetBalance(ctx context.Context, idx int) (decimal string, human string, err error)

	//Create a routing offer from DR to NS
	CreateRoutingOffer(ctx context.Context, acc int, dr *objects.Entity, nsvk []byte, confirmed func(err error))

	//Accept a designated router offer. This will overwrite previous acceptances
	AcceptRoutingOffer(ctx context.Context, acc int, ns *objects.Entity, drvk []byte, confirmed func(err error))

	//Undo a routing binding from the NS side
	RetractRoutingAcceptance(ctx context.Context, acc int, ns *objects.Entity, drvk []byte, confirmed func(err error))

	//Undo a routing binding from the DR side
	RetractRoutingOffer(ctx context.Context, acc int, dr *objects.Entity, nsvk []byte, confirmed func(err error))

	//Create the service record (host:port) for the given designated router
	CreateSRVRecord(ctx context.Context, acc int, dr *objects.Entity, record string, confirmed func(err error))

	//Publish the given entity
	PublishEntity(ctx context.Context, acc int, ent *objects.Entity, confirmed func(err error))

	//Publish the given DOT. The entities must be published already
	PublishDOT(ctx context.Context, acc int, dot *objects.DOT, confirmed func(err error))

	//Publish the given DChain. The dots and entities must be published already
	PublishAccessDChain(ctx context.Context, acc int, chain *objects.DChain, confirmed func(err error))

	//Publish the given revocation. The target must be published already
	PublishRevocation(ctx context.Context, acc int, rvk *objects.Revocation, confirmed func(err error))

	// Builtins
	//Create a short alias on the chain. After a few confirmations (or timeout)
	//confirmed is called. To avoid incorrect timeouts during sync, try to
	//only call this if ChainFresh() is true
	CreateShortAlias(ctx context.Context, acc int, val Bytes32, confirmed func(alias uint64, err error))

	//Sets a full alias on the chain. Note that you cannot collide with
	//short aliases, so don't have too many leading zeroes.
	SetAlias(ctx context.Context, acc int, key Bytes32, val Bytes32, confirmed func(err error))
}

type BlockChainProvider interface {

	//Get the ENode string
	ENode() string

	//Get a client bound to the given entity. This will create independent
	//clients even if the entity is the same
	GetClient(*objects.Entity) BlockChainClient

	//HeadBlockAge gets the age of the latest block in seconds. Negative means
	//the system time must be shady
	HeadBlockAge() int64

	//Get the balance of an address (in hex) in decimal and human readable
	GetAddrBalance(ctx context.Context, addr string) (decimal string, human string, err error)

	//Get a specific block
	GetBlock(height uint64) *Block

	//Get a header
	GetHeader(height uint64) *types.Header

	//Each time the head of the chain changes, write the new header to
	//the channel. Cancel the context to unsubscribe
	NewHeads(ctx context.Context) chan *types.Header

	//Returns a channel that true will be written to after CurrentBlock has
	//increased by at least n. false will be written if the context expires
	AfterBlocks(ctx context.Context, n uint64) chan bool

	//Get the synchronisation progress. Note that highest is not a very
	//reliable number (and may be less than current) due to how the
	//downloader works. It is better to check chain liveness using
	//HeadBlockAge().
	SyncProgress() (peercount int, start, current, highest uint64)

	//Gets the block number of the current block (that we have)
	CurrentBlock() uint64

	//CallOffChain executes the given UFI on the local machine
	//without using any money or creating global state
	CallOffChain(ctx context.Context, ufi UFI, params ...interface{}) (ret []interface{}, err error)

	//CallOffSpecificChain executes the given UFI on the local machine
	//without using any money or creating global state
	CallOffSpecificChain(ctx context.Context, block int64, ufi UFI, params ...interface{}) (ret []interface{}, err error)

	GasPrice(ctx context.Context) (*big.Int, error)

	// Call on every log appearing after block number 'after'. If before is -1 it will
	// get the current block number. If addr is not empty, only logs from that
	// contract address will be matched. The array of topics must be at most 4 long,
	// each element is an array of options.
	FindLogsBetweenHeavy(ctx context.Context, after int64, before int64, addr common.Address, topics [][]common.Hash) ([]Log, error)

	//This calls on the given blocks, but does not subscribe to new blocks
	//CallOnBlocksBetween(from uint64, to uint64, cb func(*Block))

	//Find all designated router VKs that have offered to route the given namespace
	FindRoutingOffers(ctx context.Context, nsvk []byte) (drs [][]byte, err error)

	//Find all current router affinities for the DRVK
	FindRoutingAffinities(ctx context.Context, drvk []byte) (nsvks [][]byte, err error)

	//Get the designated router for a namespace
	GetDesignatedRouterFor(ctx context.Context, nsvk []byte) ([]byte, error)

	//Get the SRV record for a designated router
	GetSRVRecordFor(ctx context.Context, drvk []byte) (string, error)

	//Resolve a DOT from the registry. Also checks for revocations (of the DOT)
	//and expiry. Will also check for entity revocations and expiry
	ResolveDOT(ctx context.Context, dothash []byte) (*objects.DOT, int, error)

	//Resolve an Entity from the registry. Also checks for revocations
	//and expiry.
	ResolveEntity(ctx context.Context, vk []byte) (*objects.Entity, int, error)

	//Resolve a chain from the registry, Also checks for revocations
	//and expiry from all the DOTs and Entities. Will error if any
	//dots or entities do not resolve.
	ResolveAccessDChain(ctx context.Context, chainhash []byte) (*objects.DChain, int, error)

	//Get all the dot hashes granted from a specific VK
	ResolveDOTsFromVK(ctx context.Context, vk Bytes32) ([]Bytes32, error)

	//Resolve a short alias returning its contents. Note that
	ResolveShortAlias(ctx context.Context, alias uint64) (res Bytes32, iszero bool, err error)

	//Resolve an alias. Note that the key will be right-padded to be
	//32 bytes
	ResolveAlias(ctx context.Context, key Bytes32) (res Bytes32, iszero bool, err error)

	//Check what the first alias made for the given value is
	UnresolveAlias(ctx context.Context, value Bytes32) (key Bytes32, iszero bool, err error)
}

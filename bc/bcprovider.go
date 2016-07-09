package bc

import (
	"time"

	"github.com/immesys/bw2/objects"
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
	CallOnChain(account int, ufi UFI, value, gas, gasPrice string, params ...interface{}) (txhash string, err error)

	//Transact does a transaction from the default account to the given
	//address (in hex) with the given value (in wei). If gas and gasPrice
	//are omitted, defaults will be used. Code contains the transaction data
	//in hex
	Transact(fromacc int, to, value, gas, gasPrice, code string) (txhash string, err error)

	//Like transact but also ensure the transaction is confirmed
	TransactAndCheck(fromacc int, to, value, gas, gasPrice, code string, confirmed func(error))

	//Get balance returns the balance of one of our accounts in
	//decimal and human readable
	GetBalance(idx int) (decimal string, human string, err error)

	//Create a routing offer from DR to NS
	CreateRoutingOffer(acc int, dr *objects.Entity, nsvk []byte, confirmed func(err error))

	//Accept a designated router offer. This will overwrite previous acceptances
	AcceptRoutingOffer(acc int, ns *objects.Entity, drvk []byte, confirmed func(err error))

	//Undo a routing binding from the NS side
	RetractRoutingAcceptance(acc int, ns *objects.Entity, drvk []byte, confirmed func(err error))

	//Undo a routing binding from the DR side
	RetractRoutingOffer(acc int, dr *objects.Entity, nsvk []byte, confirmed func(err error))

	//Create the service record (host:port) for the given designated router
	CreateSRVRecord(acc int, dr *objects.Entity, record string, confirmed func(err error))

	//Publish the given entity
	PublishEntity(acc int, ent *objects.Entity, confirmed func(err error))

	//Publish the given DOT. The entities must be published already
	PublishDOT(acc int, dot *objects.DOT, confirmed func(err error))

	//Publish the given DChain. The dots and entities must be published already
	PublishAccessDChain(acc int, chain *objects.DChain, confirmed func(err error))

	//Publish the given revocation. The target must be published already
	PublishRevocation(acc int, rvk *objects.Revocation, confirmed func(err error))

	// Builtins
	//Create a short alias on the chain. After a few confirmations (or timeout)
	//confirmed is called. To avoid incorrect timeouts during sync, try to
	//only call this if ChainFresh() is true
	CreateShortAlias(acc int, val Bytes32, confirmed func(alias uint64, err error))

	//Sets a full alias on the chain. Note that you cannot collide with
	//short aliases, so don't have too many leading zeroes.
	SetAlias(acc int, key Bytes32, val Bytes32, confirmed func(err error))
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
	GetAddrBalance(addr string) (decimal string, human string)

	//Get a specific block
	GetBlock(height uint64) *Block

	//Call the given callback on every block after 'since'. If -1 it will
	//get the current block number. If the callback returns true, it will
	//unregister, otherwise it will keep being called
	CallOnNewBlocks(cb func(*Block) (stop bool))

	//Returns a channel that true will be written to after CurrentBlock has
	//increased by at least n
	AfterBlocks(n uint64) chan bool

	//Returns a channel that true will be written to if 't' expires or
	//false will be written to if CurrentBlock increases by at least
	//'blocks'
	AfterBlocksOrTime(blocks uint64, t time.Duration) (timeout chan bool)

	//Get the synchronisation progress. Note that highest is not a very
	//reliable number (and may be less than current) due to how the
	//downloader works. It is better to check chain liveness using
	//HeadBlockAge().
	SyncProgress() (peercount int, start, current, highest uint64)

	//Gets the block number of the current block (that we have)
	CurrentBlock() uint64

	//CallOffChain executes the given UFI on the local machine
	//without using any money or creating global state
	CallOffChain(ufi UFI, params ...interface{}) (ret []interface{}, err error)

	//CallOffSpecificChain executes the given UFI on the local machine
	//without using any money or creating global state
	CallOffSpecificChain(block int64, ufi UFI, params ...interface{}) (ret []interface{}, err error)

	//Call on every log appearing after block number 'after'. If before is -1 it will
	//get the current block number. If hexaddr is not empty, only logs from that
	//contract address will be matched. If topics is not empty, every set of
	//topics inside it (up to 4 per set) will be used to match against the logs.
	//Zero arrays are wildcards. If strict is false, ANY topic matching is sufficient
	//(ethereum default) if strict is true, then all nonzero topics must match in
	//their respective positions.
	FindLogsBetween(after int64, before int64, hexaddr string, topics [][]Bytes32, strict bool) []Log

	//This calls on the given blocks, but does not subscribe to new blocks
	CallOnBlocksBetween(from uint64, to uint64, cb func(*Block))

	//Find all designated router VKs that have offered to route the given namespace
	FindRoutingOffers(nsvk []byte) (drs [][]byte)

	//Find all current router affinities for the DRVK
	FindRoutingAffinities(drvk []byte) (nsvks [][]byte)

	//Get the designated router for a namespace
	GetDesignatedRouterFor(nsvk []byte) ([]byte, error)

	//Get the SRV record for a designated router
	GetSRVRecordFor(drvk []byte) (string, error)

	//Resolve a DOT from the registry. Also checks for revocations (of the DOT)
	//and expiry. Will also check for entity revocations and expiry
	ResolveDOT(dothash []byte) (*objects.DOT, int, error)

	//Resolve an Entity from the registry. Also checks for revocations
	//and expiry.
	ResolveEntity(vk []byte) (*objects.Entity, int, error)

	//Resolve a chain from the registry, Also checks for revocations
	//and expiry from all the DOTs and Entities. Will error if any
	//dots or entities do not resolve.
	ResolveAccessDChain(chainhash []byte) (*objects.DChain, int, error)

	//Get all the dot hashes granted from a specific VK
	ResolveDOTsFromVK(vk Bytes32) ([]Bytes32, error)

	//Resolve a short alias returning its contents. Note that
	ResolveShortAlias(alias uint64) (res Bytes32, iszero bool, err error)

	//Resolve an alias. Note that the key will be right-padded to be
	//32 bytes
	ResolveAlias(key Bytes32) (res Bytes32, iszero bool, err error)

	//Check what the first alias made for the given value is
	UnresolveAlias(value Bytes32) (key Bytes32, iszero bool, err error)
}

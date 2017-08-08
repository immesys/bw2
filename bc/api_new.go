package bc

import (
	"bytes"
	"context"
	"fmt"
	"math/big"
	"time"

	"github.com/immesys/bw2/util/bwe"
	ethereum "github.com/immesys/bw2bc"
	"github.com/immesys/bw2bc/common"
	"github.com/immesys/bw2bc/core"
	"github.com/immesys/bw2bc/core/types"
	"github.com/immesys/bw2bc/params"
	"github.com/immesys/bw2bc/rlp"
)

const (
	BWDefaultLargeGas  = "3000000"
	BWDefaultSmallGas  = "100000"
	FreshnessThreshold = 30 //seconds
)

var BWDefaultGasBig = big.NewInt(3000000)

// TODO add more
type Block struct {
	Number     uint64
	Hash       Bytes32
	Time       int64
	Difficulty uint64
	Parent     Bytes32
	Logs       []Log
}

type BlockHeader struct {
	Number     uint64
	Hash       Bytes32
	Time       int64
	Difficulty uint64
	Parent     Bytes32
}

type Log interface {
	ContractAddress() Address
	Topics() []Bytes32
	Data() []byte
	BlockNumber() uint64
	TxHash() Bytes32
	BlockHash() Bytes32
	MatchesTopicsStrict(topics []Bytes32) bool
	MatchesAnyTopicsStrict(topics [][]Bytes32) bool
	String() string
}
type logWrapper struct {
	vmlog *types.Log
}

func (bc *blockChain) HeadBlockAge() int64 {
	var hdr *types.Header
	if bc.isLight {
		hdr = bc.lethi.BlockChain().CurrentHeader()
	} else {
		hdr = bc.fethi.BlockChain().CurrentHeader()
	}
	return time.Now().Unix() - hdr.Time.Int64()
}

func (bc *blockChain) GasPrice(ctx context.Context) (*big.Int, error) {
	if bc.isLight {
		return bc.lethi.ApiBackend.SuggestPrice(ctx)
	} else {
		return bc.fethi.ApiBackend.SuggestPrice(ctx)
	}
}

func (bc *blockChain) GetAddrBalance(ctx context.Context, addr string) (decimal string, human string, err error) {
	var rv *big.Int
	if bc.isLight {
		panic("we need to update this")
		/*
			sdb := bc.lethi.BlockChain().State()
			rv, err = sdb.GetBalance(ctx, common.HexToAddress(addr))
			if err != nil {
				return "", "", err
			}*/
	} else {
		sdb, err := bc.fethi.BlockChain().State()
		if err != nil {
			return "", "", err
		}
		rv = sdb.GetBalance(common.HexToAddress(addr))
	}
	decimal = rv.Text(10)
	//HeH
	human = decimal
	return decimal, human, nil
}

func (lw *logWrapper) String() string {
	rv := fmt.Sprintf("LOG \n contract 0x%040x\n", lw.vmlog.Address)
	for i, t := range lw.Topics() {
		rv += fmt.Sprintf(" topic[%d]= 0x%040x\n", i, t[:])
	}
	rv += fmt.Sprintf(" block #%d\n", lw.BlockNumber())
	rv += fmt.Sprintf(" data= %x\n", lw.Data())
	return rv
}

func (lw *logWrapper) ContractAddress() Address {
	return Address(lw.vmlog.Address)
}
func (lw *logWrapper) Topics() []Bytes32 {
	rv := make([]Bytes32, len(lw.vmlog.Topics))
	for i, v := range lw.vmlog.Topics {
		rv[i] = Bytes32(v)
	}
	return rv
}
func (lw *logWrapper) Data() []byte {
	return lw.vmlog.Data
}
func (lw *logWrapper) BlockNumber() uint64 {
	return lw.vmlog.BlockNumber
}
func (lw *logWrapper) TxHash() Bytes32 {
	return Bytes32(lw.vmlog.TxHash)
}
func (lw *logWrapper) BlockHash() Bytes32 {
	return Bytes32(lw.vmlog.BlockHash)
}

//For every nonzero topic present in topics ensure that the log's topic at the same index matches.
func (l *logWrapper) MatchesTopicsStrict(topics []Bytes32) bool {
	for i, t := range topics {
		if (i >= len(l.Topics()) && t != Bytes32{}) {
			return false
		}
		if (l.Topics()[i] != t && t != Bytes32{}) {
			return false
		}
	}
	return true
}
func (l *logWrapper) MatchesAnyTopicsStrict(topics [][]Bytes32) bool {
	for _, t := range topics {
		if l.MatchesTopicsStrict(t) {
			return true
		}
	}
	return false
}
func blockFromCore(b *types.Block, l []*types.Log) *Block {
	lw := make([]Log, len(l))
	for i, lg := range l {
		lw[i] = &logWrapper{lg}
	}
	return &Block{
		Number:     b.NumberU64(),
		Hash:       Bytes32(b.Hash()),
		Time:       b.Time().Int64(),
		Parent:     Bytes32(b.ParentHash()),
		Difficulty: uint64(b.Difficulty().Int64()),
		Logs:       lw,
	}
}

func (bc *blockChain) GetHeader(height uint64) *types.Header {
	if bc.isLight {
		return bc.lethi.BlockChain().GetHeaderByNumber(height)
	}
	return bc.fethi.BlockChain().GetHeaderByNumber(height)
}
func (bc *blockChain) GetBlock(height uint64) *Block {
	panic("if we could avoid this, yeah that'd be great")
	// coreblock := bc.eth.BlockChain().GetBlockByNumber(height)
	// if coreblock == nil {
	// 	return nil
	// }
	// var lgs []*types.Log
	// receipts := core.GetBlockReceipts(bc.eth.ChainDb(), coreblock.Hash(), height)
	// for _, r := range receipts {
	// 	if len(r.Logs) > 0 {
	// 		lgs = append(lgs, r.Logs...)
	// 	}
	// }
	// b := blockFromCore(coreblock, lgs)
	// return b
}

//Subscribes to new blocks, and calls the callback on each one. If the function
//returns true, the subscription is cancelled and no more calls will occur
//if it returns false, it will continue to be called
// Removed in jansky
// func (bc *blockChain) CallOnNewBlocksInt(cb func(*types.Block, vm.Logs) (stop bool)) {
// 	f := filters.New(bc.eth.ChainDb())
// 	id := -1
// 	//There might be invocations of the callback queued before we unsub. To
// 	//ensure downstream does not get unexpected invocations of the callback
// 	//after they return true, add a check here
// 	haveUnsubbed := false
// 	f.BlockCallback = func(b *types.Block, logs vm.Logs) {
// 		if haveUnsubbed {
// 			return
// 		}
// 		unsub := cb(b, logs)
// 		if unsub {
// 			haveUnsubbed = true
// 			if id < 0 {
// 				panic(id)
// 			}
// 			go bc.fm.Remove(id)
// 		}
// 	}
// 	f.SetBeginBlock(-1)
// 	var err error
// 	id, err = bc.fm.Add(f, filters.ChainFilter)
// 	if err != nil {
// 		panic(err)
// 	}
// }

func (bc *blockChain) CurrentHeader() *types.Header {
	if bc.isLight {
		return bc.lethi.BlockChain().CurrentHeader()
	}
	return bc.fethi.BlockChain().CurrentHeader()
}
func (bc *blockChain) CurrentBlock() uint64 {
	return bc.CurrentHeader().Number.Uint64()
}

func (bc *blockChain) NewHeads(ctx context.Context) chan *types.Header {
	rvc := make(chan *types.Header, 100)
	sub := bc.api_es.SubscribeNewHeads(rvc)
	go func() {
		<-ctx.Done()
		sub.Unsubscribe()
	}()
	return rvc
}

// func (bc *blockChain) CallOnNewBlocks(cb func(*Block) (stop bool)) {
// 	bc.CallOnNewBlocksInt(func(coreb *types.Block, corelogs vm.Logs) bool {
// 		return cb(blockFromCore(coreb, corelogs))
// 	})
// }

func (bc *blockChain) AfterBlocks(ctx context.Context, n uint64) chan bool {
	rv := make(chan bool, 1)
	start := bc.CurrentBlock()
	octx, cancel := context.WithCancel(ctx)
	hdrc := bc.NewHeads(octx)
	go func() {
		for {
			select {
			case header := <-hdrc:
				if header.Number.Uint64() >= start+n {
					rv <- true
					cancel()
					return
				}
			case <-ctx.Done():
				rv <- false
				cancel()
				return
			}
		}
	}()
	return rv
}

func (bc *blockChain) SyncProgress() (peercount int, start, current, highest uint64) {
	peers, e := bc.api_pubadmin.Peers()
	if e != nil {
		panic(e)
	}
	peercount = len(peers)

	var sp ethereum.SyncProgress
	if bc.isLight {
		sp = bc.lethi.Downloader().Progress()
	} else {
		sp = bc.fethi.Downloader().Progress()
	}
	fmt.Printf("also we have %v / %v state info\n", sp.PulledStates, sp.KnownStates)
	return peercount, sp.StartingBlock, sp.CurrentBlock, sp.HighestBlock
}

const LatestBlock = -1
const PendingBlock = -2

func (bc *blockChain) CallOffChain(ctx context.Context, ufi UFI, params ...interface{}) (ret []interface{}, err error) {
	return bc.CallOffSpecificChain(ctx, LatestBlock, ufi, params...)
}

//CallOffChain is used for calling constant functions to get return values
//It executes locally and does not cost any money
func (bc *blockChain) CallOffSpecificChain(ctx context.Context, block int64, ufi UFI, params ...interface{}) (ret []interface{}, err error) {
	addr, calldata, err := EncodeABICall(ufi, params...)
	if err != nil {
		return nil, bwe.WrapM(bwe.InvalidUFI, "Invalid off-chain UFI call args", err)
	}

	cm := ethereum.CallMsg{
		To:   &addr,
		Gas:  BWDefaultGasBig,
		Data: calldata,
	}

	res, err := bc.api_contract.CallContract(ctx, cm, big.NewInt(block))

	if err != nil {
		return nil, bwe.WrapC(bwe.UFIInvocationError, err)
	}
	rv, err := DecodeABIReturn(ufi, res)
	if err != nil {
		return nil, bwe.WrapM(bwe.InvalidUFI, "Invalid off-chain UFI return args", err)
	}
	return rv, nil
}

//Topics is not what you think. Its
// [
//  [topic0, topic0alt, topic0alt2],
//  [topic1, ... ...]
// ...
// ]
// not as previously thought, a list of [4]. But rather a [4] of lists
func (bc *blockChain) FindLogsBetweenHeavy(ctx context.Context, since int64, until int64, addr common.Address, topics [][]common.Hash) ([]Log, error) {
	if until < 0 {
		until = int64(bc.CurrentBlock())
	}

	var addrBytes Bytes32
	copy(addrBytes[:], addr[:])
	f := bc.newFilter()
	f.SetBeginBlock(since)
	f.SetEndBlock(until)
	f.SetAddresses([]common.Address{addr})
	f.SetTopics(topics)
	lgs, err := f.Find(ctx)
	if err != nil {
		return nil, err
	}
	rv := make([]Log, len(lgs))
	for i, l := range lgs {
		rv[i] = &logWrapper{l}
	}
	return rv, nil
}

//
// //If strict is false, ANY topic matching is sufficient (ethereum default) if strict is true,
// //then all nonzero topics must match in their respective positions.
// func (bc *blockChain) FindLogsBetween(since int64, until int64, hexaddr string, topics [][]Bytes32, strict bool) []Log {
// 	if until < 0 {
// 		until = bc.eth.BlockChain().CurrentHeader().Number.Int64()
// 	}
// 	var addrBytes Bytes32
// 	copy(addrBytes[:], common.HexToAddress(hexaddr))
//
// 	//must convert contract addr3ess
// 	rv := []Log{}
// 	for n := since; n <= until; n++ {
// 		hdr := bc.eth.BlockChain().GetHeaderByNumber(uint64(n))
// 		if hdr == nil {
// 			return rv
// 		}
// 		worthy := false
// 		if hdr.Bloom.TestBytes(addrBytes) {
// 			for _, slc := range topics {
// 				worthy = testBloom(hdr.Bloom, topics, strict)
// 				if worthy {
// 					break
// 				}
// 			}
// 		}
// 		//Bloom thinks block is interesting
// 		if worthy {
//
// 		}
// 	}
//
// 	f := filters.New(bc.eth.ChainDb())
// 	if hexaddr != "" {
// 		f.SetAddresses([]common.Address{common.HexToAddress(hexaddr)})
// 	}
// 	ts := make([][]common.Hash, len(topics))
// 	for i1, slc := range topics {
// 		el := make([]common.Hash, len(slc))
// 		for i2, sub := range slc {
// 			el[i2] = common.Hash(sub)
// 		}
// 		ts[i1] = el
// 	}
// 	f.SetTopics(ts)
// 	f.SetBeginBlock(since)
// 	f.SetEndBlock(until)
// 	rawlog := f.Find()
// 	rv := []Log{}
// 	for _, v := range rawlog {
// 		vv := &logWrapper{v}
// 		if !strict || vv.MatchesAnyTopicsStrict(topics) {
// 			rv = append(rv, vv)
// 		}
// 	}
// 	return rv
// }

// func (bc *blockChain) CallOnBlocksBetween(from uint64, to uint64, cb func(b *Block)) {
// 	max := bc.CurrentBlock()
// 	if to > max {
// 		to = max
// 	}
// 	for ; from < to; from++ {
// 		b := bc.GetBlock(from)
// 		if b == nil {
// 			break
// 		}
// 		cb(b)
// 	}
// 	cb(nil)
// 	return
// }

func (bcc *bcClient) SetDefaultConfirmations(c uint64) {
	bcc.DefaultConfirmations = c
}
func (bcc *bcClient) SetDefaultTimeout(c uint64) {
	bcc.DefaultTimeout = c
}
func (bcc *bcClient) GetDefaultConfirmations() uint64 {
	return bcc.DefaultConfirmations
}
func (bcc *bcClient) GetDefaultTimeout() uint64 {
	return bcc.DefaultTimeout
}
func (bcc *bcClient) GetAddress(idx int) (addr Address, err error) {
	if idx >= MaxEntityAccounts {
		return Address{}, bwe.M(bwe.InvalidAccountNumber, fmt.Sprintf("bad account: %d", idx))
	}
	return Address(bcc.bc.ks.GetEntityAddressByIdx(bcc.ent, idx)), nil
}

func (bcc *bcClient) GetAddresses() ([]Address, error) {
	a, e := bcc.bc.ks.GetEntityKeyAddresses(bcc.ent)
	if e != nil {
		return []Address{}, bwe.WrapM(bwe.BlockChainGenericError, "Could not get addresses for entity", e)
	}
	rv := make([]Address, len(a))
	for i, v := range a {
		rv[i] = Address(v)
	}
	return rv, nil
}

//CallOnChain executes a real distributed invocation of the identified function.
//It can cost some money. If gas is omitted, it defaults to three million
func (bcc *bcClient) CallOnChain(ctx context.Context, acc int, ufi UFI, value, gas, gasPrice string, params ...interface{}) (txhash common.Hash, err error) {
	addr, calldata, err := EncodeABICall(ufi, params...)
	if err != nil {
		return common.Hash{}, bwe.WrapM(bwe.InvalidUFI, "Invalid on-chain UFI call args", err)
	}
	return bcc.Transact(ctx, acc, addr.Hex(), value, gas, gasPrice, calldata)
}

func (bcc *bcClient) signAndSendTransaction(ctx context.Context, accidx int, tx *types.Transaction) (common.Hash, error) {
	var chainID *big.Int
	var cfg *params.ChainConfig
	if bcc.bc.isLight {
		cfg = bcc.bc.lethi.ApiBackend.ChainConfig()
	} else {
		cfg = bcc.bc.fethi.ApiBackend.ChainConfig()
	}
	if cfg.IsEIP155(bcc.bc.CurrentHeader().Number) {
		chainID = cfg.ChainId
	}
	signed, err := bcc.bc.ks.BWSignTx(accidx, bcc.ent, tx, chainID)
	if err != nil {
		return common.Hash{}, err
	}
	if bcc.bc.isLight {
		err = bcc.bc.lethi.ApiBackend.SendTx(ctx, signed)
	} else {
		err = bcc.bc.fethi.ApiBackend.SendTx(ctx, signed)
	}
	if err != nil {
		return common.Hash{}, err
	}
	return signed.Hash(), nil
}

func (bcc *bcClient) Transact(ctx context.Context, accidx int, to, value, gas, gasPrice string, code []byte) (txhash common.Hash, err error) {
	acc, err := bcc.GetAddress(accidx)
	if err != nil {
		return common.Hash{}, err
	}
	if gas == "" {
		if len(code) == 0 {
			gas = BWDefaultSmallGas
		} else {
			gas = "0"
		}
	}
	gasb := big.NewInt(0)
	_, ok := gasb.SetString(gas, 0)
	if !ok {
		return common.Hash{}, bwe.M(bwe.InvalidUFI, "Invalid on-chain UFI call gas")
	}
	var gasp *big.Int = nil
	if gasPrice != "" {
		gasp = big.NewInt(0)
		_, ok = gasp.SetString(gasPrice, 0)
		if !ok {
			return common.Hash{}, bwe.M(bwe.InvalidUFI, "Invalid on-chain UFI call gasPrice")
		}
	} else {
		gasp, err = bcc.bc.api_contract.SuggestGasPrice(ctx)
		if err != nil {
			return common.Hash{}, bwe.WrapM(bwe.BlockChainGenericError, "Could not get optimal gas price", err)
		}
	}
	if value == "" {
		value = "0"
	}
	valb := big.NewInt(0)
	_, ok = valb.SetString(value, 0)
	if !ok {
		return common.Hash{}, bwe.M(bwe.InvalidUFI, "Invalid on-chain UFI call value")
	}
	toa := common.HexToAddress(to)
	var nonce uint64

	if gasb.Int64() == 0 {
		egas, err := bcc.bc.api_contract.EstimateGas(ctx, ethereum.CallMsg{
			From:     common.Address(acc),
			To:       &toa,
			Gas:      nil,
			GasPrice: gasp,
			Value:    valb,
			Data:     code,
		})
		if err != nil {
			return common.Hash{}, bwe.WrapM(bwe.InvalidUFI, "Invalid gas estimation", err)
		}
		gasb = egas
	}

	if bcc.bc.isLight {
		nonce, err = bcc.bc.lethi.TxPool().GetNonce(ctx, common.Address(acc))
		if err != nil {
			return common.Hash{}, bwe.WrapM(bwe.BlockChainGenericError, "Could not get txpool nonce", err)
		}
	} else {
		nonce = bcc.bc.fethi.TxPool().State().GetNonce(common.Address(acc))
	}
	tx := types.NewTransaction(nonce, toa, valb, gasb, gasp, code)

	txhash, terr := bcc.signAndSendTransaction(ctx, accidx, tx)
	if terr != nil {
		return common.Hash{}, bwe.WrapM(bwe.BlockChainGenericError, "Could not transact", terr)
	}
	return txhash, nil
}

func (bcc *bcClient) TransactAndCheck(ctx context.Context, accidx int, to, value, gas, gasPrice string, code []byte, confirmed func(error)) {
	txhash, err := bcc.Transact(ctx, accidx, to, value, gas, gasPrice, code)
	if err != nil {
		confirmed(err)
		return
	}
	bcc.bc.GetTransactionDetailsInt(ctx, txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bnum uint64, err error) {
			confirmed(err)
		})
}

func (bc *blockChain) getTransaction(txHash common.Hash) (tx *types.Transaction, pending bool, blocknum int64, err error) {
	var txData []byte
	if bc.isLight {
		panic("not supported on light yet")
		txData, err = bc.lethi.ApiBackend.ChainDb().Get(txHash.Bytes())
	} else {
		txData, err = bc.fethi.ChainDb().Get(txHash.Bytes())
	}
	fmt.Printf("get transaction rv len=%d err=%v\n", len(txData), err)
	isPending := false
	tx = new(types.Transaction)

	if err == nil && len(txData) > 0 {
		if err := rlp.DecodeBytes(txData, tx); err != nil {
			return nil, isPending, -1, err
		}
	} else {
		// pending transaction?
		if bc.isLight {
			tx = bc.lethi.ApiBackend.GetPoolTransaction(txHash)
		} else {
			tx = bc.fethi.ApiBackend.GetPoolTransaction(txHash)
		}
		isPending = true
	}

	if !isPending {
		var txBlock struct {
			BlockHash  common.Hash
			BlockIndex uint64
			Index      uint64
		}
		var blockData []byte
		//TODO LIGHTIFY
		blockData, err := bc.fethi.ChainDb().Get(append(txHash.Bytes(), 0x0001))
		if err != nil {
			return nil, false, 0, err
		}

		reader := bytes.NewReader(blockData)
		if err = rlp.Decode(reader, &txBlock); err != nil {
			return nil, false, 0, err
		}

		return tx, false, int64(txBlock.BlockIndex), nil
	}

	return tx, true, -1, nil
}

// func (bc *blockChain) intGetTransactionByHash(ctx context.Context, hash common.Hash) (*types.Transaction, error) {
// 	var tx *types.Transaction
// 	var isPending bool
// 	var err error
//
// 	if tx, isPending, err = bc.getTransaction(hash); err != nil {
// 		log.Debug("Failed to retrieve transaction", "hash", hash, "err", err)
// 		return nil, nil
// 	} else if tx == nil {
// 		return nil, nil
// 	}
// 	if isPending {
// 		return newRPCPendingTransaction(tx), nil
// 	}
//
// 	blockHash, _, _, err := getTransactionBlockData(s.b.ChainDb(), hash)
// 	if err != nil {
// 		log.Debug("Failed to retrieve transaction block", "hash", hash, "err", err)
// 		return nil, nil
// 	}
//
// 	if block, _ := s.b.GetBlock(ctx, blockHash); block != nil {
// 		return newRPCTransaction(block, hash)
// 	}
// 	return nil, nil
// }

func (bc *blockChain) GetTransactionReceipt(txhash common.Hash) *types.Receipt {
	if bc.isLight {
		panic("is not supported on light")
	}
	return core.GetReceipt(bc.fethi.ChainDb(), txhash)
}

func (bc *blockChain) GetTransactionDetailsInt(ctx context.Context, txhash common.Hash, timeoutblocks uint64, confirmations uint64,
	onseen func(blocknum uint64, err error),
	onconfirmed func(blocknum uint64, err error)) {

	startblock := bc.CurrentBlock()

	waitConfirmations := func(found uint64) {
		for {
			if ctx.Err() != nil {
				if onconfirmed != nil {
					onconfirmed(0, bwe.M(bwe.TransactionConfirmationTimeout, "Timeout waiting for confirmations"))
				}
				return
			}
			//If we are past the number of confirmations required
			curblock := bc.CurrentBlock()
			fmt.Println("Waiting for confirmations on", txhash, "seen at", found, "curblock", curblock)
			if curblock >= found+confirmations {
				tx, pending, blocknum, err := bc.getTransaction(txhash)
				if err != nil {
					onconfirmed(0, bwe.WrapM(bwe.TransactionConfirmationTimeout, "Got TX error", err))
				}
				if !(pending || tx == nil) {
					if blocknum > 0 && uint64(blocknum) < curblock-confirmations {
						onconfirmed(uint64(blocknum), nil)
						return
					}
				}
			}
			//Or we have timed out
			if curblock >= startblock+timeoutblocks {
				if onconfirmed != nil {
					onconfirmed(0, bwe.M(bwe.TransactionConfirmationTimeout, "Timeout waiting for confirmations"))
				}
				return
			}
			<-bc.AfterBlocks(ctx, 1)
		}
	}

	go func() {
		for {
			curblock := bc.CurrentBlock()
			tx, pending, blocknum, err := bc.getTransaction(txhash)
			if err != nil {
				panic("hmm2?" + err.Error())
			}
			if err == nil && !pending && tx != nil && blocknum > 0 {
				if onseen != nil {
					onseen(uint64(blocknum), nil)
				}
				waitConfirmations(uint64(blocknum))
				return
			}
			if curblock >= startblock+timeoutblocks {
				if onseen != nil {
					onseen(0, bwe.M(bwe.TransactionTimeout, "Timeout waiting for tx to appear"))
				}
				if onconfirmed != nil {
					onconfirmed(0, bwe.M(bwe.TransactionTimeout, "Timeout waiting for tx to appear"))
				}
				return
			}
			sctx, cancel := context.WithTimeout(ctx, 5*time.Second)
			<-bc.AfterBlocks(sctx, 1)
			cancel()
		}
	}()
}

func (bcc *bcClient) GetBalance(ctx context.Context, idx int) (decimal string, human string, err error) {
	acc, err := bcc.GetAddress(idx)
	if err != nil {
		return "", "", err
	}
	dec, hum, err := bcc.bc.GetAddrBalance(ctx, acc.Hex())
	return dec, hum, err
}

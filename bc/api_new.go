package bc

import (
	"fmt"
	"math/big"
	"time"

	"github.com/immesys/bw2/util/bwe"
	"github.com/immesys/bw2bc/common"
	"github.com/immesys/bw2bc/core"
	"github.com/immesys/bw2bc/core/types"
	"github.com/immesys/bw2bc/core/vm"
	"github.com/immesys/bw2bc/eth"
	"github.com/immesys/bw2bc/eth/filters"
	"github.com/immesys/bw2bc/rpc"
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
	vmlog *vm.Log
}

func (bc *blockChain) HeadBlockAge() int64 {
	head, err := bc.api_pubchain.GetBlockByNumber(-1, false)
	if err != nil {
		panic(err)
	}
	btime := head["timestamp"].(*rpc.HexNumber).Int64()
	now := time.Now().Unix()
	return now - btime
}

func (bc *blockChain) GasPrice() *big.Int {
	return bc.api_pubeth.GasPrice()
}

func (bc *blockChain) GetAddrBalance(addr string) (decimal string, human string) {
	rv, err := bc.api_pubchain.GetBalance(common.HexToAddress(addr), -1)
	if err != nil {
		panic(err)
	}
	decimal = rv.Text(10)
	human = common.CurrencyToString(rv)
	return
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
func blockFromCore(b *types.Block, l vm.Logs) *Block {
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

func (bc *blockChain) GetBlock(height uint64) *Block {
	coreblock := bc.eth.BlockChain().GetBlockByNumber(height)
	if coreblock == nil {
		return nil
	}
	var lgs []*vm.Log
	receipts := core.GetBlockReceipts(bc.eth.ChainDb(), coreblock.Hash())
	for _, r := range receipts {
		if len(r.Logs) > 0 {
			lgs = append(lgs, r.Logs...)
		}
	}
	b := blockFromCore(coreblock, lgs)
	return b
}

//Subscribes to new blocks, and calls the callback on each one. If the function
//returns true, the subscription is cancelled and no more calls will occur
//if it returns false, it will continue to be called
func (bc *blockChain) CallOnNewBlocksInt(cb func(*types.Block, vm.Logs) (stop bool)) {
	f := filters.New(bc.eth.ChainDb())
	id := -1
	//There might be invocations of the callback queued before we unsub. To
	//ensure downstream does not get unexpected invocations of the callback
	//after they return true, add a check here
	haveUnsubbed := false
	f.BlockCallback = func(b *types.Block, logs vm.Logs) {
		if haveUnsubbed {
			return
		}
		unsub := cb(b, logs)
		if unsub {
			haveUnsubbed = true
			if id < 0 {
				panic(id)
			}
			go bc.fm.Remove(id)
		}
	}
	f.SetBeginBlock(-1)
	var err error
	id, err = bc.fm.Add(f, filters.ChainFilter)
	if err != nil {
		panic(err)
	}
}

func (bc *blockChain) CurrentBlock() uint64 {
	return bc.eth.BlockChain().CurrentBlock().NumberU64()
}

func (bc *blockChain) CallOnNewBlocks(cb func(*Block) (stop bool)) {
	bc.CallOnNewBlocksInt(func(coreb *types.Block, corelogs vm.Logs) bool {
		return cb(blockFromCore(coreb, corelogs))
	})
}

func (bc *blockChain) AfterBlocks(n uint64) chan bool {
	rv := make(chan bool, 1)
	start := bc.CurrentBlock()
	bc.CallOnNewBlocksInt(func(b *types.Block, l vm.Logs) bool {
		if bc.CurrentBlock() >= start+n {
			rv <- true
			return true
		}
		return false
	})
	return rv
}

//Returns True on channel if timeout, false if block
func (bc *blockChain) AfterBlocksOrTime(blocks uint64, t time.Duration) chan bool {
	rv := make(chan bool, 1)
	go func() {
		select {
		case <-time.After(t):
			rv <- true
		case <-bc.AfterBlocks(blocks):
			rv <- false
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
	start, current, highest, _, _ = bc.eth.Downloader().Progress()
	return
}

const LatestBlock = -1
const PendingBlock = -2

func (bc *blockChain) CallOffChain(ufi UFI, params ...interface{}) (ret []interface{}, err error) {
	return bc.CallOffSpecificChain(LatestBlock, ufi, params...)
}

//CallOffChain is used for calling constant functions to get return values
//It executes locally and does not cost any money
func (bc *blockChain) CallOffSpecificChain(block int64, ufi UFI, params ...interface{}) (ret []interface{}, err error) {
	addr, calldata, err := EncodeABICall(ufi, params...)
	if err != nil {
		return nil, bwe.WrapM(bwe.InvalidUFI, "Invalid off-chain UFI call args", err)
	}
	type CallArgs struct {
		From     common.Address  `json:"from"`
		To       *common.Address `json:"to"`
		Gas      *rpc.HexNumber  `json:"gas"`
		GasPrice *rpc.HexNumber  `json:"gasPrice"`
		Value    rpc.HexNumber   `json:"value"`
		Data     string          `json:"data"`
	}
	ca := eth.CallArgs{To: &addr,
		Gas:  rpc.NewHexNumber(BWDefaultGasBig),
		Data: common.ToHex(calldata),
	}
	// Call executes the given transaction on the state for the given block number.
	// It doesn't make and changes in the state/blockchain and is useful to execute and retrieve values.
	// func (s *PublicBlockChainAPI) Call(args CallArgs, blockNr rpc.BlockNumber) (string, error) {
	// 	result, _, err := s.doCall(args, blockNr)
	// 	return result, err
	// }
	res, err := bc.api_pubchain.Call(ca, rpc.BlockNumber(block))
	if err != nil {
		return nil, bwe.WrapC(bwe.UFIInvocationError, err)
	}
	rv, err := DecodeABIReturn(ufi, common.FromHex(res))
	if err != nil {
		return nil, bwe.WrapM(bwe.InvalidUFI, "Invalid off-chain UFI return args", err)
	}
	return rv, nil
}

//If strict is false, ANY topic matching is sufficient (ethereum default) if strict is true,
//then all nonzero topics must match in their respective positions.
func (bc *blockChain) FindLogsBetween(since int64, until int64, hexaddr string, topics [][]Bytes32, strict bool) []Log {
	f := filters.New(bc.eth.ChainDb())
	if hexaddr != "" {
		f.SetAddresses([]common.Address{common.HexToAddress(hexaddr)})
	}
	ts := make([][]common.Hash, len(topics))
	for i1, slc := range topics {
		el := make([]common.Hash, len(slc))
		for i2, sub := range slc {
			el[i2] = common.Hash(sub)
		}
		ts[i1] = el
	}
	f.SetTopics(ts)
	f.SetBeginBlock(since)
	f.SetEndBlock(until)
	rawlog := f.Find()
	rv := []Log{}
	for _, v := range rawlog {
		vv := &logWrapper{v}
		if !strict || vv.MatchesAnyTopicsStrict(topics) {
			rv = append(rv, vv)
		}
	}
	return rv
}

func (bc *blockChain) CallOnBlocksBetween(from uint64, to uint64, cb func(b *Block)) {
	max := bc.CurrentBlock()
	if to > max {
		to = max
	}
	for ; from < to; from++ {
		b := bc.GetBlock(from)
		if b == nil {
			break
		}
		cb(b)
	}
	cb(nil)
	return
}

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
func (bcc *bcClient) CallOnChain(acc int, ufi UFI, value, gas, gasPrice string, params ...interface{}) (txhash string, err error) {
	addr, calldata, err := EncodeABICall(ufi, params...)
	if err != nil {
		return "", bwe.WrapM(bwe.InvalidUFI, "Invalid on-chain UFI call args", err)
	}
	return bcc.Transact(acc, addr.Hex(), value, gas, gasPrice, common.ToHex(calldata))
}

func (bcc *bcClient) Transact(accidx int, to, value, gas, gasPrice, code string) (txhash string, err error) {
	acc, err := bcc.GetAddress(accidx)
	if err != nil {
		return "", err
	}
	if gas == "" {
		if len(code) == 0 {
			gas = BWDefaultSmallGas
		} else {
			gas = BWDefaultLargeGas
		}
	}
	gasb := big.NewInt(0)
	_, ok := gasb.SetString(gas, 0)
	if !ok {
		return "", bwe.M(bwe.InvalidUFI, "Invalid on-chain UFI call gas")
	}
	var gasp *big.Int = nil
	if gasPrice != "" {
		gasp = big.NewInt(0)
		_, ok = gasp.SetString(gasPrice, 0)
		if !ok {
			return "", bwe.M(bwe.InvalidUFI, "Invalid on-chain UFI call gasPrice")
		}
	}
	if value == "" {
		value = "0"
	}
	valb := big.NewInt(0)
	_, ok = valb.SetString(value, 0)
	if !ok {
		return "", bwe.M(bwe.InvalidUFI, "Invalid on-chain UFI call value")
	}
	var terr error
	commaddr := common.HexToAddress(to)
	txhashc, terr := bcc.bc.api_privacct.SignAndSendTransaction(eth.SendTxArgs{
		From:     common.Address(acc),
		To:       &commaddr,
		Gas:      rpc.NewHexNumber(gasb),
		GasPrice: nil,
		Value:    rpc.NewHexNumber(valb),
		Data:     code,
		Nonce:    nil,
	}, "")
	txhash = txhashc.Hex()
	if terr != nil {
		err = bwe.WrapM(bwe.BlockChainGenericError, "Could not transact", terr)
		return
	}
	err = nil
	return
}

func (bcc *bcClient) TransactAndCheck(accidx int, to, value, gas, gasPrice, code string, confirmed func(error)) {
	txhash, err := bcc.Transact(accidx, to, value, gas, gasPrice, code)
	if err != nil {
		confirmed(err)
		return
	}
	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bnum uint64, rptt *eth.RPCTransaction, err error) {
			confirmed(err)
		})
}

func (bc *blockChain) GetTransactionReceipt(txhash string) *types.Receipt {
	return core.GetReceipt(bc.eth.ChainDb(), common.HexToHash(txhash))
}
func (bc *blockChain) GetTransactionDetailsInt(txhash string, timeout uint64, confirmations uint64,
	onseen func(blocknum uint64, rpct *eth.RPCTransaction, err error),
	onconfirmed func(blocknum uint64, rpct *eth.RPCTransaction, err error)) {

	startblock := bc.CurrentBlock()
	starttime := time.Now().UnixNano() / 1000000000
	timeouttime := starttime + int64(timeout*20)

	waitConfirmations := func(found uint64) {
		for {
			//If we are past the number of confirmations required
			curblock := bc.CurrentBlock()
			fmt.Println("Waiting for confirmations on", txhash, "seen at", found, "curblock", curblock)
			curtime := time.Now().UnixNano() / 1000000000
			if curblock >= found+confirmations {
				//See if it is still there
				rpct, err := bc.api_pubtx.GetTransactionByHash(common.HexToHash(txhash))
				if err != nil {
					panic("hmm?" + err.Error())
				}
				if err == nil && rpct != nil && rpct.BlockNumber != nil && rpct.BlockNumber.Uint64() < curblock-confirmations {
					if onconfirmed != nil {
						onconfirmed(rpct.BlockNumber.Uint64(), rpct, nil)
					}
					return
				}
			}
			//Or we have timed out
			if curblock >= startblock+timeout || curtime > timeouttime {
				if onconfirmed != nil {
					onconfirmed(0, nil, bwe.M(bwe.TransactionConfirmationTimeout, "Timeout waiting for confirmations"))
				}
				return
			}
			<-bc.AfterBlocksOrTime(1, 5*time.Second)
		}
	}

	go func() {
		for {
			curblock := bc.CurrentBlock()
			//log.Infof("Waiting for appearance of", txhash, "oblock is", startblock, "curblock is", curblock)
			curtime := time.Now().UnixNano() / 1000000000
			rpct, err := bc.api_pubtx.GetTransactionByHash(common.HexToHash(txhash))
			if err != nil {
				panic("hmm2?" + err.Error())
			}
			if err == nil && rpct != nil && rpct.BlockNumber != nil {
				if onseen != nil {
					onseen(rpct.BlockNumber.Uint64(), rpct, nil)
				}
				waitConfirmations(rpct.BlockNumber.Uint64())
				return
			}
			if curblock >= startblock+timeout || curtime > timeouttime {
				if onseen != nil {
					onseen(0, nil, bwe.M(bwe.TransactionTimeout, "Timeout waiting for tx to appear"))
				}
				if onconfirmed != nil {
					onconfirmed(0, nil, bwe.M(bwe.TransactionTimeout, "Timeout waiting for tx to appear"))
				}
				return
			}
			<-bc.AfterBlocksOrTime(1, 5*time.Second)
		}
	}()
}

func (bcc *bcClient) GetBalance(idx int) (decimal string, human string, err error) {
	acc, err := bcc.GetAddress(idx)
	if err != nil {
		return "", "", err
	}
	dec, hum := bcc.bc.GetAddrBalance(acc.Hex())
	return dec, hum, err
}

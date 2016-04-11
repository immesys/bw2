package bc

import (
	"os"
	"os/signal"
	"path/filepath"
	"time"

	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util"
	"github.com/immesys/bw2bc/accounts"
	"github.com/immesys/bw2bc/cmd/utils"
	"github.com/immesys/bw2bc/common"
	"github.com/immesys/bw2bc/core"
	"github.com/immesys/bw2bc/eth"
	"github.com/immesys/bw2bc/eth/filters"
	"github.com/immesys/bw2bc/logger/glog"
	"github.com/immesys/bw2bc/p2p/nat"
	"github.com/immesys/bw2bc/xeth"
)

const (
	DefGasPrice          = "1000000000" // 1 GWei
	GpoMinGasPrice       = DefGasPrice
	GpoMaxGasPrice       = "500000000000"
	DefaultConfirmations = 2
	DefaultTimeout       = 20
)

type blockChain struct {
	ks    *entityKeyStore
	x     *xeth.XEth
	am    *accounts.Manager
	fm    *filters.FilterSystem
	eth   *eth.Ethereum
	shdwn chan bool
}

type bcClient struct {
	bc                   *blockChain
	ent                  *objects.Entity
	acc                  int
	DefaultConfirmations uint64
	DefaultTimeout       uint64
}

func NewBlockChain(datadir string) (BlockChainProvider, chan bool) {

	os.MkdirAll(datadir, os.ModeDir|0777)
	glog.SetV(2)
	glog.CopyStandardLogTo("INFO")
	glog.SetLogDir(datadir)

	rv := &blockChain{
		ks:    NewEntityKeyStore(),
		shdwn: make(chan bool, 1),
	}
	natThing, _ := nat.Parse("")
	front := &frontend{bc: rv}
	rv.am = accounts.NewManager(rv.ks)
	// Assemble the entire eth configuration
	cfg := &eth.Config{
		Name:                    common.MakeName("BW2", util.BW2Version),
		DataDir:                 datadir,
		GenesisFile:             "",
		FastSync:                false,
		BlockChainVersion:       core.BlockChainVersion,
		DatabaseCache:           0,
		SkipBcVersionCheck:      false,
		NetworkId:               eth.NetworkId,
		LogFile:                 "logfile",
		Verbosity:               2,
		Etherbase:               common.Address{},
		MinerThreads:            0,
		AccountManager:          rv.am,
		VmDebug:                 false,
		MaxPeers:                25,
		MaxPendingPeers:         0,
		Port:                    "30303",
		Olympic:                 false,
		NAT:                     natThing,
		NatSpec:                 false,
		DocRoot:                 filepath.Join(datadir, "docroot"),
		Discovery:               true,
		NodeKey:                 nil,
		Shh:                     false,
		Dial:                    true,
		BootNodes:               "",
		GasPrice:                common.String2Big(DefGasPrice),
		GpoMinGasPrice:          common.String2Big(GpoMinGasPrice),
		GpoMaxGasPrice:          common.String2Big(GpoMaxGasPrice),
		GpoFullBlockRatio:       80,
		GpobaseStepDown:         10,
		GpobaseStepUp:           100,
		GpobaseCorrectionFactor: 110,
		SolcPath:                "",
		AutoDAG:                 false,
	}
	var err error
	rv.eth, err = eth.New(cfg)
	if err != nil {
		utils.Fatalf("%v", err)
	}
	utils.StartEthereum(rv.eth)
	rv.fm = filters.NewFilterSystem(rv.eth.EventMux())
	rv.x = xeth.New(rv.eth, front)

	sig := make(chan os.Signal, 1)
	signal.Notify(sig, os.Interrupt)
	go func() {
		<-sig
		rv.x.Stop()
		glog.Flush()
		rv.shdwn <- true
	}()
	go rv.DebugTXPoolLoop()
	return rv, rv.shdwn
}

func (bc *blockChain) DebugTXPoolLoop() {
	for {
		time.Sleep(2 * time.Second)

		for i, v := range bc.eth.TxPool().GetTransactions() {
			if i == 0 {
				glog.V(2).Infof("\n")
			}
			glog.V(2).Infof("TX %d", i)
			glog.V(2).Info(v.String())
		}
	}
}
func (bc *blockChain) ENode() string {
	return bc.Backend().Network().Self().String()
}
func (bc *blockChain) GetClient(ent *objects.Entity) BlockChainClient {
	rv := &bcClient{
		bc:                   bc,
		ent:                  ent,
		DefaultConfirmations: DefaultConfirmations,
		DefaultTimeout:       DefaultTimeout,
	}
	bc.ks.AddEntity(ent)
	return rv
}

func (bcc *bcClient) SetEntity(ent *objects.Entity) {
	bcc.ent = ent
	bcc.acc = 0
	//This might be a new entity
	bcc.bc.ks.AddEntity(ent)
}
func (bc *blockChain) Shutdown() {
	bc.x.Stop()
}

// Frontend stuff
type frontend struct {
	bc *blockChain
}

func (f *frontend) AskPassword() (string, bool) {
	return "", true
}
func (f *frontend) UnlockAccount(address []byte) bool {
	e := f.bc.am.Unlock(common.BytesToAddress(address), "")
	if e != nil {
		panic(e)
	}
	return true
}
func (f *frontend) ConfirmTransaction(tx string) bool {
	return true
}

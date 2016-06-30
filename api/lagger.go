package api

import (
	"fmt"
	"sync"
	"time"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/bc"
)

type Lagger struct {
	doneNumber    int64
	expectParent  bc.Bytes32
	subscribers   []func(b *bc.Block)
	onReset       []func()
	smu           sync.Mutex
	bchain        bc.BlockChainProvider
	caughtup      bool
	lastPrintTime time.Time
}

const LagConfirmations = 3

func NewLagger(bchain bc.BlockChainProvider) *Lagger {
	rv := &Lagger{
		bchain:     bchain,
		doneNumber: -1,
	}
	return rv
}

//Returns true if initial replay is complete
func (lag *Lagger) CaughtUp() bool {
	return lag.caughtup
}
func (lag *Lagger) Subscribe(onConfirmedBlock func(b *bc.Block), onReset func()) {
	lag.smu.Lock()
	defer lag.smu.Unlock()
	lag.onReset = append(lag.onReset, onReset)
	lag.subscribers = append(lag.subscribers, onConfirmedBlock)
}

//Must be called with smu locked
func (lag *Lagger) onConfirmedBlock(b *bc.Block) {
	if b.Number != 0 && b.Parent != lag.expectParent {
		fmt.Printf("block=%d parent=%x expected=%x done=%d\n", b.Number, b.Parent, lag.expectParent, lag.doneNumber)
		//If you hit this, just increase LagConfirmations
		panic(fmt.Errorf("Deep chain reorganization. Not supported in this version!!"))
	}
	for _, s := range lag.subscribers {
		s(b)
	}
	lag.expectParent = b.Hash
	lag.doneNumber = int64(b.Number)
}
func (lag *Lagger) onBlock(b *bc.Block) {
	lag.smu.Lock()
	defer lag.smu.Unlock()
	for {
		if lag.bchain.GetBlock(uint64(lag.doneNumber+1+LagConfirmations)) != nil {
			laggedBlock := lag.bchain.GetBlock(uint64(lag.doneNumber + 1))
			lag.onConfirmedBlock(laggedBlock)
		} else {
			break
		}
	}
}
func (lag *Lagger) printrblock(block uint64, doneNumber int64) {
	if time.Now().Sub(lag.lastPrintTime) > 7*time.Second {
		log.Infof("received block %d (lagged=%d)", block, doneNumber)
		lag.lastPrintTime = time.Now()
	}
}
func (lag *Lagger) BeginLoop() {
	lag.bchain.CallOnNewBlocks(func(b *bc.Block) bool {
		lag.printrblock(b.Number, lag.doneNumber)
		if !lag.caughtup {
			st := lag.doneNumber
			if st < 0 {
				st = 0
			}
			lag.bchain.CallOnBlocksBetween(uint64(st), b.Number, func(oldb *bc.Block) {
				if oldb != nil {
					lag.onBlock(oldb)
				}
			})
			lag.caughtup = true
		}
		lag.onBlock(b)
		return false
	})
}

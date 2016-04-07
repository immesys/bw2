package api

import (
	"fmt"
	"sync"

	"github.com/immesys/bw2/bc"
)

type Lagger struct {
	doneNumber   int64
	expectParent bc.Bytes32
	subscribers  []func(b *bc.Block)
	onReset      []func()
	smu          sync.Mutex
	bchain       bc.BlockChainProvider
	caughtup     bool
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
	lag.expectParent = b.Hash
	lag.doneNumber = int64(b.Number)
	for _, s := range lag.subscribers {
		s(b)
	}
}
func (lag *Lagger) onBlock(b *bc.Block) {
	lag.smu.Lock()
	defer lag.smu.Unlock()
	if int64(b.Number)-LagConfirmations > lag.doneNumber {
		laggedBlock := lag.bchain.GetBlock(uint64(lag.doneNumber + 1))
		lag.onConfirmedBlock(laggedBlock)
	}
}
func (lag *Lagger) BeginLoop() {
	lag.bchain.CallOnNewBlocks(func(b *bc.Block) bool {
		if !lag.caughtup {
			lag.bchain.CallOnBlocksBetween(0, b.Number, func(oldb *bc.Block) {
				if oldb != nil {
					lag.onBlock(oldb)
				}
			})
			lag.caughtup = true
		}
		fmt.Printf("received block %d\n", b.Number)
		fmt.Printf("doneNumber: %d\n", lag.doneNumber)
		lag.onBlock(b)
		return false
	})
}

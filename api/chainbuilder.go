package api

import (
	"container/list"
	"errors"
	"strings"
	"sync"

	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/internal/util"
	"github.com/immesys/bw2/objects"
)

type ChainBuilder struct {
	cl     *BosswaveClient
	status chan string
	uri    string
	perms  string
	peers  [][]byte
}

type scenario struct {
	chain []*objects.DOT
}

func (s *scenario) Clone() *scenario {
	cc := make([]*objects.DOT, len(s.chain))
	copy(cc, s.chain)
	return &scenario{chain: cc}
}

func (s *scenario) AddAndClone(d *objects.DOT) *scenario {
	cc := make([]*objects.DOT, len(s.chain)+1)
	copy(cc, s.chain)
	cc[len(s.chain)] = d
	return &scenario{chain: cc}
}

/*
func (s *scenario) GetTerminalVK() string {
	return crypto.FmtKey(s.chain[len(s.chain)-1].GetReceiverVK())
}*/

func NewChainBuilder(cl *BosswaveClient, uri, perms string, status chan string) *ChainBuilder {
	return &ChainBuilder{cl: cl, uri: uri, perms: perms, peers: make([][]byte, 0), status: status}
}

func (b *ChainBuilder) AddPeerMVK(mvk []byte) {
	b.peers = append(b.peers, mvk)
}

//genTier takes an entity and finds every DOT that grants on
//the MVK with the required permissions
func (b *ChainBuilder) genTier(used map[string]bool, from []byte) {

}
func (b *ChainBuilder) dotUseful(d *objects.DOT) bool {
	return true
}
func (b *ChainBuilder) getOptions(from []byte) []*objects.DOT {
	rv := make([]*objects.DOT, 0)
	rc := make(chan *objects.DOT, 10)
	wg := sync.WaitGroup{}
	go func() {
		for _, peerMVK := range b.peers {
			wg.Add(1)
			go b.cl.Query(&QueryParams{
				MVK:       peerMVK,
				URISuffix: "$/fromto/" + crypto.FmtKey(from)[:43] + "/+",
			},
				func(status int, msg string) {
					if status != core.BWStatusOkay {
						b.status <- "opt query error: " + msg
						wg.Done()
					}
				},
				func(m *core.Message) {
					if m == nil {
						wg.Done()
						return
					}
					for _, ro := range m.RoutingObjects {
						dot, ok := ro.(*objects.DOT)
						if ok && b.dotUseful(dot) {
							rc <- dot
						}
					}
				})
		}
		wg.Wait()
		close(rc)
	}()
	for res := range rc {
		rv = append(rv, res)
	}
	return rv
}
func (b *ChainBuilder) Build() (*objects.DChain, error) {
	parts := strings.SplitN(b.uri, "/", 2)
	if len(parts) != 2 {
		return nil, errors.New("Invalid URI")
	}
	valid, hasStar, hasPlus, hasDollar, hasBang := util.AnalyzeSuffix(parts[1])
	if !valid {
		return nil, errors.New("Invalid URI")
	}
	mvk, err := crypto.UnFmtKey(parts[0])
	if err != nil {
		return nil, err
	}
  //The VK's we have visited (and the TTL). Do not add scenarios that have seen this VK
  //unless the TTL is higher because it's a 
  seen := map[string]bool
	validscenarios := list.New()
	evals := list.New()
	initial := b.getOptions(mvk)
	for _, dt := range initial {
		s := scenario{chain: []*objects.DOT{dt}}
		evals.PushBack(&s)
	}
	for evals.Front() != nil {
		s := evals.Front()
    evals.Remove(s)
	}

}

package api

import (
	"bytes"
	"container/list"
	"errors"
	"fmt"
	"strings"
	"sync"

	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/internal/util"
	"github.com/immesys/bw2/objects"
)

type ChainBuilder struct {
	cl        *BosswaveClient
	status    chan string
	uri       string
	perms     string
	target    []byte
	peers     [][]byte
	urimvk    []byte
	urisuffix string
	desperms  *objects.AccessDOTPermissionSet
}

type scenario struct {
	chain  []*objects.DOT
	suffix string
}

func (s *scenario) TTL() int {
	ttl := 256
	for _, d := range s.chain {
		ttl = ttl - 1
		if d.GetTTL() < ttl {
			ttl = d.GetTTL()
		}
	}
	return ttl
}
func (s *scenario) Clone() *scenario {
	cc := make([]*objects.DOT, len(s.chain))
	copy(cc, s.chain)
	return &scenario{chain: cc}
}
func (s *scenario) String() string {
	rv := "["
	for _, d := range s.chain {
		rv += crypto.FmtKey(d.GetHash()) + ","
	}
	return rv + "]"
}
func NewScenario(d *objects.DOT) *scenario {
	return &scenario{chain: []*objects.DOT{d}, suffix: d.GetAccessURISuffix()}
}
func (s *scenario) AddAndClone(d *objects.DOT) (*scenario, bool) {
	cc := make([]*objects.DOT, len(s.chain)+1)
	copy(cc, s.chain)
	cc[len(s.chain)] = d
	nuri, okay := util.RestrictBy(s.suffix, d.GetAccessURISuffix())
	if !okay {
		return nil, false
	}
	return &scenario{chain: cc, suffix: nuri}, true
}

func (s *scenario) GetTerminalVK() []byte {
	return s.chain[len(s.chain)-1].GetReceiverVK()
}

func (s *scenario) ToChain() *objects.DChain {
	rv, err := objects.CreateDChain(true, s.chain...)
	if err != nil {
		panic(err)
	}
	return rv
}
func NewChainBuilder(cl *BosswaveClient, uri, perms string, target []byte, status chan string) *ChainBuilder {
	rv := ChainBuilder{cl: cl,
		uri:      uri,
		target:   target,
		perms:    perms,
		peers:    make([][]byte, 0),
		status:   status,
		desperms: objects.GetADPSFromPermString(perms)}
	uriparts := strings.SplitN(uri, "/", 2)
	urimvk, err := crypto.UnFmtKey(uriparts[0])
	if err != nil {
		panic("need to fix this")
	}
	rv.urisuffix = uriparts[1]
	rv.urimvk = urimvk
	return &rv
}

func (b *ChainBuilder) AddPeerMVK(mvk []byte) {
	b.peers = append(b.peers, mvk)
}

func (b *ChainBuilder) dotUseful(d *objects.DOT) bool {
	adps := d.GetPermissionSet()
	if !b.desperms.IsSubsetOf(adps) {
		fmt.Println("rejecting DOT: perms")
		return false
	}
	if !bytes.Equal(d.GetAccessURIMVK(), b.urimvk) {
		fmt.Println("rejecting DOT: mvk")
		return false
	}
	nu, ok := util.RestrictBy(b.urisuffix, d.GetAccessURISuffix())
	if !ok || nu != b.urisuffix {
		return false
	}
	return true
}
func (b *ChainBuilder) getOptions(from []byte) []*objects.DOT {
	rv := make([]*objects.DOT, 0)
	rc := make(chan *objects.DOT, 10)
	wg := sync.WaitGroup{}
	go func() {
		for _, peerMVK := range b.peers {
			drVK, err := b.cl.BW().GetDRVK(crypto.FmtKey(peerMVK))
			if err != nil {
				b.status <- "could not get DRVK for peer " + crypto.FmtKey(peerMVK)
				continue
			}
			wg.Add(1)
			//The peer might be an MVK, but its the DR itself that we need to query
			go b.cl.Query(&QueryParams{
				MVK:       drVK,
				URISuffix: "$/dot/fromto/" + crypto.FmtKey(from)[:43] + "/+",
			},
				func(status int, msg string) {
					if status != core.BWStatusOkay {
						b.status <- "opt query error: " + msg
						wg.Done()
					}
				},
				func(m *core.Message) {
					if m == nil {
						b.status <- "finished options query"
						wg.Done()
						return
					}
					b.status <- "got options query rv"
					for _, ro := range m.RoutingObjects {
						dot, ok := ro.(*objects.DOT)
						if ok {
							core.DistributeRO(b.cl.BW().Entity, dot, b.cl.CL())
							if b.dotUseful(dot) {
								rc <- dot
							}
						}
					}
				})
		}
		wg.Wait()
		close(rc)
	}()
	seen := make(map[string]bool)
	for res := range rc {
		k := crypto.FmtHash(res.GetHash())
		_, ok := seen[k]
		if !ok {
			rv = append(rv, res)
			seen[k] = true
		}
	}
	b.status <- fmt.Sprintf("options len %d", len(rv))
	return rv
}
func (b *ChainBuilder) Build() ([]*objects.DChain, error) {
	parts := strings.SplitN(b.uri, "/", 2)
	if len(parts) != 2 {
		return nil, errors.New("Invalid URI")
	}
	valid, _, _, _, _ := util.AnalyzeSuffix(parts[1])
	if !valid {
		return nil, errors.New("Invalid URI")
	}
	mvk, err := b.cl.BW().ResolveName(parts[0])
	if err != nil {
		return nil, err
	}
	validscenarios := list.New()
	evals := list.New()
	b.status <- "populating initial options"
	b.status <- "looking for DOTs from " + crypto.FmtKey(mvk)
	initial := b.getOptions(mvk)
	for _, dt := range initial {
		s := NewScenario(dt)
		if bytes.Equal(s.GetTerminalVK(), b.target) {
			b.status <- "found valid scenario"
			validscenarios.PushBack(s)
		} else {
			b.status <- "adding scenario: " + s.String()
			evals.PushBack(s)
		}
	}
	for evals.Front() != nil {
		le := evals.Front()
		s := le.Value.(*scenario)
		endsat := s.GetTerminalVK()
		opts := b.getOptions(endsat)
		for _, dt := range opts {
			newscenario, okay := s.AddAndClone(dt)
			if !okay {
				continue
			}
			if bytes.Equal(newscenario.GetTerminalVK(), b.target) {
				b.status <- "found valid scenario"
				validscenarios.PushBack(newscenario)
			} else {
				evals.PushBack(newscenario)
			}
		}
		evals.Remove(le)
	}
	fmt.Println("uh")
	seen := make(map[string]bool)
	rv := make([]*objects.DChain, 0, validscenarios.Len())
	e := validscenarios.Front()
	for e != nil {
		chn := e.Value.(*scenario).ToChain()
		k := crypto.FmtHash(chn.GetChainHash())
		_, ok := seen[k]
		if !ok {
			rv = append(rv, chn)
		}
		e = e.Next()
	}
	close(b.status)
	fmt.Println("chain build complete")
	return rv, nil
}

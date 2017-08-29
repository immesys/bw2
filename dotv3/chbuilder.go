package dotv3

import (
	"bytes"
	"container/list"
	"fmt"

	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util"
)

type CBCache interface {
	Lookup(ck CacheKey) []*objects.DChain
}
type CacheKey struct {
	uri    string
	perms  string
	target [32]byte
	nsvk   [32]byte
}
type ChainBuilder struct {
	// cl     *BosswaveClient
	// status chan string
	eng    *Engine
	uri    string
	perms  string
	target []byte
	//	fulluri   []byte
	nsvk      []byte
	urisuffix string
}

type scenario struct {
	chain  []*DOTV3
	suffix string
}

func (s *scenario) TTL() int {
	ttl := 256
	for _, d := range s.chain {
		ttl = ttl - 1
		if int(d.Content.TTL) < ttl {
			ttl = int(d.Content.TTL)
		}
	}
	return ttl
}
func (s *scenario) Clone() *scenario {
	cc := make([]*DOTV3, len(s.chain))
	copy(cc, s.chain)
	return &scenario{chain: cc}
}
func (s *scenario) String() string {
	rv := "["
	/*	for _, d := range s.chain {
		rv += crypto.FmtKey(d.GetHash()) + ","
	}*/
	return rv + "]"
}
func NewScenario(d *DOTV3) *scenario {
	return &scenario{chain: []*DOTV3{d}, suffix: string(d.Content.URI)}
}
func (s *scenario) AddAndClone(d *DOTV3) (*scenario, bool) {
	cc := make([]*DOTV3, len(s.chain)+1)
	copy(cc, s.chain)
	cc[len(s.chain)] = d
	nuri, okay := util.RestrictBy(s.suffix, string(d.Content.URI))
	if !okay {
		return nil, false
	}
	rv := &scenario{chain: cc, suffix: nuri}
	if rv.TTL() < 0 {
		return nil, false
	}
	return rv, true
}

func (s *scenario) GetTerminalVK() []byte {
	return s.chain[len(s.chain)-1].Content.DSTVK
}

// func (s *scenario) ToChain() *objects.DChain {
// 	rv, err := objects.CreateDChain(true, s.chain...)
// 	if err != nil {
// 		panic(err)
// 	}
// 	return rv
// }
func NewChainBuilder(e *Engine, ns []byte, uri, perms string, target []byte) *ChainBuilder {
	rv := ChainBuilder{eng: e,
		uri:    uri,
		target: target,
		perms:  perms,
	}
	rv.urisuffix = uri
	rv.nsvk = ns
	return &rv
}

func (b *ChainBuilder) dotUseful(d *DOTV3) bool {
	if !bytes.Equal(d.Label.Namespace, b.nsvk) {
		fmt.Printf("dot not useful: wrong namespace")
		return false
	}
	// adps := d.GetPermissionSet()
	// if !bytes.Equal(d.GetAccessURIMVK(), b.nsvk) {
	// 	b.status <- fmt.Sprintf("rejecting DOT(%s) - incorrect namespace", crypto.FmtHash(d.GetHash()))
	// 	return false
	// }
	hasPerm := false
	for _, p := range d.Content.Permissions {
		if p == b.perms {
			hasPerm = true
		}
	}
	if !hasPerm {
		fmt.Printf("dot not useful, wrong permissions")
		return false
	}
	nu, ok := util.RestrictBy(b.urisuffix, string(d.Content.URI))
	if !ok || nu != b.urisuffix {
		fmt.Printf("dot not useful, URI is too restrictive")
		return false
	}
	return true
}

func (b *ChainBuilder) getOptions(from []byte) []*DOTV3 {
	dz, err := b.eng.LookupDOTs(b.nsvk, from)
	if err != nil {
		panic(err)
	}
	rv := []*DOTV3{}
	for _, d := range dz {
		if b.dotUseful(d) {
			fmt.Printf("possible edge DOT")
			rv = append(rv, d)
		}
	}
	return rv
	//
	// dlz, err := b.cl.BW().ResolveGrantedDOTs(from)
	// rv := []*objects.DOT{}
	// if err != nil {
	// 	//can happen if chain is still synchronizing
	// 	return rv
	// }
	//
	// for _, dl := range dlz {
	// 	if dl.S != StateValid {
	// 		if dl.D == nil {
	// 			b.status <- fmt.Sprintf("rejecting DOT - Status is %d", dl.S)
	// 		} else {
	// 			b.status <- fmt.Sprintf("rejecting DOT(%s) - Status is %d", crypto.FmtHash(dl.D.GetHash()), dl.S)
	// 		}
	// 		continue
	// 	}
	// 	if b.dotUseful(dl.D) {
	// 		b.status <- "possible edge DOT: " + crypto.FmtHash(dl.D.GetHash())
	// 		rv = append(rv, dl.D)
	// 	}
	// }
	// return rv
}

func (b *ChainBuilder) Build() ([]*objects.DChain, error) {
	// ck := CacheKey{
	// 	uri:   b.uri,
	// 	perms: b.perms,
	// }
	// copy(ck.target[:], b.target)
	// copy(ck.nsvk[:], b.nsvk)
	// cached, states := b.cl.bw.resolveBuiltChain(ck)
	// if cached != nil {
	// 	log.Infof("chain build cache hit")
	// 	rv := make([]*objects.DChain, 0, len(cached))
	// 	for idx, chn := range cached {
	// 		if states[idx] != StateValid {
	// 			b.status <- fmt.Sprintf("dropping chain %s : %s", crypto.FmtHash(chn.GetChainHash()), b.cl.BW().StateToString(states[idx]))
	// 		} else {
	// 			rv = append(rv, chn)
	// 		}
	// 	}
	// 	return rv, nil
	// } else {
	// 	log.Infof("chain build cache miss")
	// }
	// parts := strings.SplitN(b.uri, "/", 2)
	// if len(parts) != 2 {
	// 	return nil, errors.New("Invalid URI")
	// }
	// valid, _, _, _ := util.AnalyzeSuffix(parts[1])
	// if !valid {
	// 	return nil, errors.New("Invalid URI")
	// }
	// mvk, err := b.cl.BW().ResolveKey(parts[0])
	// if err != nil {
	// 	return nil, err
	// }
	validscenarios := list.New()
	evals := list.New()
	initial := b.getOptions(b.nsvk)
	for _, dt := range initial {
		s := NewScenario(dt)
		if bytes.Equal(s.GetTerminalVK(), b.target) || bytes.Equal(s.GetTerminalVK(), util.EverybodySlice) {
			fmt.Printf("found valid scenario")
			validscenarios.PushBack(s)
		} else {
			fmt.Printf("adding scenario: " + s.String())
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
			if bytes.Equal(newscenario.GetTerminalVK(), b.target) || bytes.Equal(newscenario.GetTerminalVK(), util.EverybodySlice) {
				fmt.Printf("graph walk found a valid scenario!")
				validscenarios.PushBack(newscenario)
			} else {
				evals.PushBack(newscenario)
			}
		}
		evals.Remove(le)
	}
	//seen := make(map[string]bool)
	rv := make([]*objects.DChain, 0, validscenarios.Len())
	e := validscenarios.Front()
	for e != nil {
		fmt.Printf("found chain %p", e.Value)
		// chn := e.Value.(*scenario).ToChain()
		// k := crypto.FmtHash(chn.GetChainHash())
		// _, ok := seen[k]
		// if !ok {
		// 	rv = append(rv, chn)
		// }
		e = e.Next()
	}
	return rv, nil
}

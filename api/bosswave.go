// This file is part of BOSSWAVE.
//
// BOSSWAVE is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// BOSSWAVE is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with BOSSWAVE.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright © 2015 Michael Andersen <m.andersen@cs.berkeley.edu>

package api

import (
	"fmt"
	"io/ioutil"
	"math/rand"
	"os"
	"path"
	"strings"
	"sync"

	"github.com/immesys/bw2/bc"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/internal/store"
	"github.com/immesys/bw2/objects"
)

// This is the main function interface for BW2. All Out Of Band providers will
// use this interface, and it is the main interface for creating GO based BW2
// applications

type VKPair struct {
	DRVK []byte
	MVK  []byte
}

// BW is the primary handle for bosswave consumers
type BW struct {
	Config *core.BWConfig
	tm     *core.Terminus
	//VK        []byte
	//SK        []byte
	Entity *objects.Entity
	//XTAG TODO we need to populate this
	RoutingNSVKs [][]byte

	bchain bc.BlockChainProvider

	//This is all for resolution caching
	cachemu sync.Mutex

	lag       *Lagger
	cachesize int
	//from vk -> to vk -> []dothash
	dotcache map[bc.Bytes32]map[bc.Bytes32][]bc.Bytes32
}

func (bw *BW) BC() bc.BlockChainProvider {
	return bw.bchain
}

// In seconds
const defaultMaxAge = 120

// OpenBWContext will create a new Bosswave context and initialise the
// daemons specified in the configuration file
func OpenBWContext(config *core.BWConfig) (*BW, chan bool) {
	if config == nil {
		config = core.LoadConfig("")
	}
	rv := &BW{Config: config,
		tm:       core.CreateTerminus(),
		dotcache: make(map[bc.Bytes32]map[bc.Bytes32][]bc.Bytes32),
	}
	entcontents, err := ioutil.ReadFile(config.Router.Entity)
	if err != nil {
		fmt.Println("Could not load router entity:", err)
		os.Exit(1)
	}
	enti, err := objects.NewEntity(int(entcontents[0]), entcontents[1:])
	if err != nil {
		fmt.Println("Could not load router entity:", err)
		os.Exit(1)
	}
	ent, ok := enti.(*objects.Entity)
	if !ok {
		fmt.Println("Could not load router entity: bad file")
		os.Exit(1)
	}
	store.Initialize(config.Router.DB)

	rv.Entity = ent
	//In future we can add our own on-shutdown logic here. For now
	//only the BC has shutdown tasks
	var bcShutdown chan bool
	rv.bchain, bcShutdown = bc.NewBlockChain(path.Join(config.Router.DB, "bw2bc"))
	rv.lag = NewLagger(rv.bchain)
	rv.startResolutionLoop()

	return rv, bcShutdown
}

func (cl *BosswaveClient) BW() *BW {
	return cl.bw
}

// BosswaveClient represents an individual client. It contains the
// handle to the terminus client that contains the message queue
type BosswaveClient struct {
	//MessageFactory stuff
	mid   uint64
	ourvk *objects.Entity

	bw *BW
	cl *core.Client

	peerlock sync.Mutex
	peers    map[string]*PeerClient

	bchain bc.BlockChainProvider
	bcc    bc.BlockChainClient

	maxage uint64

	viewseq int
	views   map[int]*View
	viewmu  sync.Mutex
}

func (cl *BosswaveClient) registerView(v *View) int {
	cl.viewmu.Lock()
	cl.viewseq++
	seq := cl.viewseq
	cl.views[seq] = v
	cl.viewmu.Unlock()
	return seq
}

func (cl *BosswaveClient) GetMaxChainAge() uint64 {
	return cl.maxage
}
func (cl *BosswaveClient) SetMaxChainAge(age uint64) {
	cl.maxage = age
}
func (cl *BosswaveClient) ChainStale() bool {
	return (cl.bchain.HeadBlockAge() > int64(cl.GetMaxChainAge()) || !cl.bw.lag.CaughtUp())
}
func (cl *BosswaveClient) GetUs() *objects.Entity {
	return cl.ourvk
}

func (cl *BosswaveClient) BC() bc.BlockChainProvider {
	return cl.bchain
}
func (cl *BosswaveClient) BCC() bc.BlockChainClient {
	return cl.bcc
}

// CreateClient will create a new BosswaveClient. If the queueChanged function
// is nil, the dispatch handlers in each subscription will be invoked when
// a message appears for them. If a queueChanged function is specified, this
// behaviour is supressed, and the caller needs to work out how to dispatch
// messages when the queue has changed.
func (bw *BW) CreateClient(name string) *BosswaveClient {
	rv := &BosswaveClient{bw: bw,
		mid:    uint64(rand.Int63() << 16),
		peers:  make(map[string]*PeerClient),
		bchain: bw.bchain,
		maxage: defaultMaxAge,
		views:  make(map[int]*View),
	}
	rv.cl = bw.tm.CreateClient(name)
	return rv
}

func (cl *BosswaveClient) Destroy() {
	cl.cl.Destroy()
	for _, p := range cl.peers {
		p.Destroy()
	}
}

//Resolve URI will convert the namespace into an nsvk if it is symbolic
func (bw *BW) ResolveURI(uri string) (string, error) {
	parts := strings.SplitN(uri, "/", 2)
	nsvk, err := bw.ResolveKey(parts[0])
	if err != nil {
		return "", err
	}
	return crypto.FmtKey(nsvk) + "/" + parts[1], nil
}

func (c *BosswaveClient) CL() *core.Client {
	return c.cl
}

//Connect to a peer by IP address without knowing VK
/*
func (c *BosswaveClient) GetPeerByTrustedTarget(target string) (*PeerClient, error) {
	peer, err := ConnectToPeer(nil, target, true)
	if err != nil {
		return nil, err
	}
	return peer, nil
}
*/

//InjectPeer puts the given peer into the caches so that it will be resolved
//it returns the name of the peer that can be used later
/*
func (c *BosswaveClient) InjectPeer(p *PeerClient) string {
	bw := c.BW()
	bw.cachelock.Lock()
	defer bw.cachelock.Unlock()
	vks := crypto.FmtKey(p.GetRemoteVK())
	bw.Namecache[vks] = p.GetRemoteVK()
	bw.DRVKcache[vks] = p.GetRemoteVK()
	bw.Targetcache[vks] = p.GetTarget()
	return vks
}
*/
//GetPeer gets the peer for the given NSVK, NOT THE PEER VK
func (c *BosswaveClient) GetPeer(nsvk []byte) (*PeerClient, error) {
	drvk, err := c.bw.LookupDesignatedRouter(nsvk)
	if err != nil {
		return nil, err
	}
	key := crypto.FmtKey(drvk)
	c.peerlock.Lock()
	defer c.peerlock.Unlock()
	peer, ok := c.peers[key]
	if !ok {
		tgt, err := c.bw.LookupDesignatedRouterSRV(drvk)
		if err != nil {
			return nil, err
		}
		peer, err = c.ConnectToPeer(drvk, tgt, false)
		if err != nil {
			return nil, err
		}
		c.peers[key] = peer
	}
	return peer, nil
}

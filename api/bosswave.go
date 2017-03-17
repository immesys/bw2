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

	"golang.org/x/net/context"

	"github.com/immesys/bw2/bc"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/internal/store"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2bc/common"
)

// This is the main function interface for BW2. All Out Of Band providers will
// use this interface, and it is the main interface for creating GO based BW2
// applications

// BW is the primary handle for bosswave consumers
type BW struct {
	Config *core.BWConfig
	tm     *core.Terminus
	Entity *objects.Entity
	bchain bc.BlockChainProvider
	rdata  *ResolutionData
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
		tm: core.CreateTerminus(),
		//dotcache:   make(map[bc.Bytes32]map[bc.Bytes32][]bc.Bytes32),
		rdata: newResolutionData(),
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
	ben := common.HexToAddress(config.Mining.Benificiary)
	if (ben == common.Address{}) {
		panic("Invalid mining benificiary")
	}
	store.Initialize(config.Router.DB)
	rv.Entity = ent
	//In future we can add our own on-shutdown logic here. For now
	//only the BC has shutdown tasks
	var bcShutdown chan bool
	rv.bchain, bcShutdown = bc.NewBlockChain(bc.NBCParams{
		Datadir:           path.Join(config.Router.DB, "bw2bc"),
		MaxLightPeers:     config.Altruism.MaxLightPeers,
		MaxLightResources: config.Altruism.MaxLightResourcePercentage,
		IsLight:           config.P2P.IAmLight,
		MaxPeers:          config.P2P.MaxPeers,
		NetRestrict:       config.P2P.PermittedNetworks,
		CoinBase:          ben,
		MinerThreads:      config.Mining.Threads,
	})
	rv.startResolutionServices()
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

	ctx       context.Context
	ctxCancel context.CancelFunc

	maxage uint64

	viewseq int
	views   map[int]*View
	viewmu  sync.Mutex

	subs   map[core.UniqueMessageID]*Subscription
	subsmu sync.Mutex
}

type Subscription struct {
	Msg  *core.Message
	UMid core.UniqueMessageID
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
	return (cl.bchain.HeadBlockAge() > int64(cl.GetMaxChainAge()))
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
func (bw *BW) CreateClient(pctx context.Context, name string) *BosswaveClient {
	rv := &BosswaveClient{bw: bw,
		mid:    uint64(rand.Int63() << 16),
		peers:  make(map[string]*PeerClient),
		bchain: bw.bchain,
		maxage: defaultMaxAge,
		views:  make(map[int]*View),
		subs:   make(map[core.UniqueMessageID]*Subscription),
	}
	rv.ctx, rv.ctxCancel = context.WithCancel(pctx)
	rv.cl = bw.tm.CreateClient(rv.ctx, name)
	return rv
}

// func (cl *BosswaveClient) Destroy() {
//
// 	cl.cl.Destroy()
// 	for _, p := range cl.peers {
// 		p.Destroy()
// 	}
// }

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
		peer, err = c.ConnectToPeer(drvk, tgt)
		if err != nil {
			return nil, err
		}
		c.peers[key] = peer
	}
	return peer, nil
}

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
	"bytes"
	"encoding/base64"
	"errors"
	"fmt"
	"math/rand"
	"net"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/internal/rocks"
	"github.com/immesys/bw2/internal/store"
	"github.com/immesys/bw2/objects"
)

//The version of BW2 this is
var BW2Version = "2.0.1 - 'Broadside'"

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
	Entity    *objects.Entity
	MVKs      [][]byte
	cachelock sync.Mutex
	//This maps a DRVK onto a target
	Targetcache map[string]string
	//This maps an MVK onto a DRVK
	DRVKcache map[string][]byte
	//This maps a name onto an MVK
	Namecache map[string][]byte
}

// OpenBWContext will create a new Bosswave context and initialise the
// daemons specified in the configuration file
func OpenBWContext(config *core.BWConfig) *BW {
	if config == nil {
		config = core.LoadConfig("")
	}
	rv := &BW{Config: config,
		tm:          core.CreateTerminus(),
		DRVKcache:   config.GetDRVKcache(),
		Namecache:   config.GetNamecache(),
		Targetcache: config.GetTargetcache(),
	}
	rSK, err := crypto.UnFmtKey(config.Router.SK)
	if err != nil {
		fmt.Println("Could not load router's signing key from config")
		os.Exit(1)
	}
	rVK, err := crypto.UnFmtKey(config.Router.VK)
	if err != nil {
		fmt.Println("Could not load router's verifying key from config")
		os.Exit(1)
	}
	rv.Entity = objects.CreateLightEntity(rVK, rSK)
	rv.MVKs = make([][]byte, len(config.Affinity.MVK)+1)
	for i, smvk := range config.Affinity.MVK {
		mvk, err := crypto.UnFmtKey(smvk)
		if err != nil {
			fmt.Println("Could not parse affinity mvk '" + smvk + "'")
			os.Exit(1)
		}
		rv.MVKs[i] = mvk
	}
	rv.MVKs[len(config.Affinity.MVK)] = rv.Entity.GetVK()
	rv.DRVKcache[config.Router.VK] = rVK

	rocks.Initialize(config.Router.DB)
	return rv
}

func SplitURI(uri string) (mvk []byte, urisuffix string, ok bool) {
	rv, err := base64.URLEncoding.DecodeString(uri[:44])
	if err != nil {
		return nil, "", false
	}
	return rv, uri[45:], true
}

func (cl *BosswaveClient) BW() *BW {
	return cl.bw
}

// BosswaveClient represents an individual client. It contains the
// handle to the terminus client that contains the message queue
type BosswaveClient struct {
	bw *BW
	cl *core.Client

	//MessageFactory stuff
	mid uint64
	us  *objects.Entity

	peerlock sync.Mutex
	peers    map[string]*PeerClient
}

// MatchTopic will check if t matches the pattern.
// TODO this is not nearly as optimal as it can be, copy
// logic from RestrictBy. In the meantime it may be faster
// to call RestrictBy.
func MatchTopic(t []string, pattern []string) bool {
	if len(t) == 0 && len(pattern) == 0 {
		return true
	}
	if len(t) == 0 || len(pattern) == 0 {
		return false
	}
	if t[0] == pattern[0] || pattern[0] == "+" {
		return MatchTopic(t[1:], pattern[1:])
	}
	if pattern[0] == "*" {
		for i := 0; i < len(t); i++ {
			if MatchTopic(t[i:], pattern[1:]) {
				return true
			}
		}
	}
	return false
}

func (cl *BosswaveClient) GetUs() *objects.Entity {
	return cl.us
}

// CreateClient will create a new BosswaveClient. If the queueChanged function
// is nil, the dispatch handlers in each subscription will be invoked when
// a message appears for them. If a queueChanged function is specified, this
// behaviour is supressed, and the caller needs to work out how to dispatch
// messages when the queue has changed.
func (bw *BW) CreateClient() *BosswaveClient {
	rv := &BosswaveClient{bw: bw,
		mid:   uint64(rand.Int63() << 16),
		peers: make(map[string]*PeerClient),
	}
	rv.cl = bw.tm.CreateClient()
	return rv
}

func (cl *BosswaveClient) Destroy() {
	cl.cl.Destroy()
	for _, p := range cl.peers {
		p.Destroy()
	}
}

func (bw *BW) ResolveURI(uri string) (string, error) {
	parts := strings.SplitN(uri, "/", 2)
	mvk, err := bw.ResolveName(parts[0])
	if err != nil {
		return "", err
	}
	return crypto.FmtKey(mvk) + "/" + parts[1], nil
}

func (bw *BW) GetTarget(drvk string) (string, error) {
	bw.cachelock.Lock()
	defer bw.cachelock.Unlock()
	target, ok := bw.Targetcache[drvk]
	if ok {
		return target, nil
	}
	rawEnc := "_" + drvk[:43] //Strip the last equals, we know its there and its invalid
	_, addrs, err := net.LookupSRV("", "", rawEnc+".bw2.io")
	if err != nil {
		return "", err
	}
	if len(addrs) < 1 {
		return "", errors.New("Unable to resolve VK to router")
	}
	tgt := addrs[0].Target[:len(addrs[0].Target)-1] + ":" + strconv.Itoa(int(addrs[0].Port))
	bw.Targetcache[drvk] = tgt
	return tgt, nil
}
func (bw *BW) GetDRVK(mvk string) ([]byte, error) {
	bw.cachelock.Lock()
	defer bw.cachelock.Unlock()
	drvk, ok := bw.DRVKcache[mvk]
	if ok {
		return drvk, nil
	}
	rv, err := net.LookupTXT("_dr." + mvk[:43] + ".bw2.io")
	if err != nil {
		return nil, err
	}
	if len(rv) < 1 {
		return nil, errors.New("could not resolve _dr for '" + mvk[:43] + "'")
	}
	sdrvk := rv[0]
	drvk, err = crypto.UnFmtKey(sdrvk)
	if err != nil {
		return nil, errors.New("TXT record malformed")
	}
	bw.DRVKcache[mvk] = drvk
	return drvk, nil
}

func (c *BosswaveClient) CL() *core.Client {
	return c.cl
}

//ResolveName resolves a DNS name into an MVK
//TODO add caching for this shit
func (bw *BW) ResolveName(name string) ([]byte, error) {
	bw.cachelock.Lock()
	defer bw.cachelock.Unlock()
	mvk, ok := bw.Namecache[name]
	if ok {
		return mvk, nil
	}
	if !strings.Contains(name, ".") && len(name) == 44 {
		var err error
		mvk, err = crypto.UnFmtKey(name)
		if err != nil {
			return nil, errors.New("Could not parse MVK")
		}
		bw.Namecache[name] = mvk
		return mvk, nil
	} else {
		//name is probably a DNS record
		rv, err := net.LookupTXT("_mvk." + name)
		if err != nil {
			return nil, err
		}
		if len(rv) < 1 {
			return nil, errors.New("could not resolve _mvk for '" + name + "'")
		}
		smvk := rv[0]
		mvk, err = crypto.UnFmtKey(smvk)
		if err != nil {
			return nil, errors.New("TXT record malformed")
		}
		bw.Namecache[name] = mvk
		return mvk, nil
	}
}

//Resolve will ask a couple names for whatever this object is, and try find it
//for an entity "hash" is actually the VK
func (c *BosswaveClient) Resolve(hash string, ask []string) objects.RoutingObject {
	thash := hash[:43] //strip off the last equals
	bhash, err := crypto.UnFmtKey(hash)
	if err != nil {
		return nil
	}

	//First try short circuit resolution by querying the local DB
	dot, ok := store.GetDOT(bhash)
	if ok {
		return dot
	}
	ent, ok := store.GetEntity(bhash)
	if ok {
		return ent
	}
	dc, ok := store.GetDChain(bhash)
	if ok {
		return dc
	}

	var peers []*PeerClient
	for _, a := range ask {
		mvk, err := c.BW().ResolveName(a)
		if err != nil {
			log.Warnf("unable to resolve peer name '%s'", a)
			continue
		}
		peer, err := c.GetPeer(mvk)
		if err != nil {
			log.Warnf("unable to connect to peer mvk '%s'", crypto.FmtKey(mvk))
			continue
		}
		peers = append(peers, peer)
	}

	//Try as a DOT
	rv := make(chan objects.RoutingObject, 1)
	wg := sync.WaitGroup{}
	for _, p := range peers {
		wg.Add(1)
		go func(p *PeerClient) {
			//This is the routerVK so is the DRVK automatically
			drVK := p.GetRemoteVK()
			uris := []string{"$/dot/hash/" + thash, "$/entity/vk/" + thash, "$/chain/hash/" + thash}
			for _, uri := range uris {
				wg.Add(1)
				c.Query(&QueryParams{
					MVK:       drVK,
					URISuffix: uri,
				},
					func(status int, msg string) {
						if status != core.BWStatusOkay {
							log.Warnf("bad peer resolve query: %s", msg)
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
							if ok {
								store.PutDOT(dot)
							}
							if ok && bytes.Equal(bhash, dot.GetHash()) {
								rv <- dot
							}
							ent, ok := ro.(*objects.Entity)
							if ok {
								store.PutEntity(ent)
							}
							if ok && bytes.Equal(bhash, ent.GetVK()) {
								rv <- ent
							}
							dc, ok := ro.(*objects.DChain)
							if ok {
								store.PutDChain(dc)
							}
							if ok && bytes.Equal(bhash, dc.GetChainHash()) {
								rv <- dc
							}
						}
					})
			}
			wg.Done()
		}(p)
	}

	go func() {
		wg.Wait()
		close(rv)
	}()
	select {
	case retval, ok := <-rv:
		if ok {
			go func() {
				for _ = range rv {
				}
			}()
			return retval
		}
		return nil
	case _ = <-time.After(5 * time.Second):
		go func() {
			for _ = range rv {
			}
		}()
		return nil
	}
}

//GetPeer gets the peer for the given MVK, NOT THE PEER VK
func (c *BosswaveClient) GetPeerByTrustedTarget(target string) (*PeerClient, error) {
	peer, err := ConnectToPeer(nil, target, true)
	if err != nil {
		return nil, err
	}
	return peer, nil
}

//InjectPeer puts the given peer into the caches so that it will be resolved
//it returns the name of the peer that can be used later
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

//GetPeer gets the peer for the given MVK, NOT THE PEER VK
func (c *BosswaveClient) GetPeer(mvk []byte) (*PeerClient, error) {
	vk, err := c.bw.GetDRVK(crypto.FmtKey(mvk))
	if err != nil {
		return nil, err
	}
	key := crypto.FmtKey(vk)
	c.peerlock.Lock()
	defer c.peerlock.Unlock()
	peer, ok := c.peers[key]
	if !ok {
		tgt, err := c.bw.GetTarget(key)
		if err != nil {
			return nil, err
		}
		peer, err := ConnectToPeer(vk, tgt, false)
		if err != nil {
			return nil, err
		}
		c.peers[key] = peer
		return peer, nil
	}
	return peer, nil

}

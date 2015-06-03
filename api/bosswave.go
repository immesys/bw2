package api

import (
	"encoding/base64"
	"errors"
	"fmt"
	"math/rand"
	"net"
	"os"
	"strconv"
	"strings"
	"sync"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/internal/rocks"
	"github.com/immesys/bw2/objects"
)

//The version of BW2 this is
var BW2Version = "2.0.0 - 'Anarchy'"

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
	log.Infof("Opening context")
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

/*
func (c *BosswaveClient) dispatch() {
	if c.irq == nil {
		//Do dispatch to the subreq's Dispatch field
		ms := c.cl.GetFront()
		for ms != nil {
			c.disch <- ms
			ms = c.cl.GetFront()
		}
	} else {
		//Delegate to client
		c.irq()
	}
}
*/

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
		peer, err := ConnectToPeer(vk, tgt)
		if err != nil {
			return nil, err
		}
		c.peers[key] = peer
		return peer, nil
	}
	return peer, nil

}

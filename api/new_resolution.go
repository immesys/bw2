package api

import (
	"fmt"
	"runtime"
	"sync"
	"time"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/bc"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2bc/common"
)

// todo
// why is cli not adding revokers to objects
// add log processing for cache inv
// test
//  - create ent
//  - create dot with ent
//  - revoke ent
//  - try create dot with ent
//  - check validity of first dot
//  - try above with delegated revoker
//
//  - create dot
//  - revoke dot
//  - try use dot to send message
//  - create dot and revoke destination
//  - try above with delegated revoker

//Cached operations:
// #1 get entity state by VK
//  inv: revocation on VK
//       fixed expiry time
// #2 get DOT state by hash
//  inv: revocation by hash
//       revocation of entities
//       fixed time of entity expiry
//       fixed time of DOT expiry
// #3 get DOTs by granter VK
//  inv: new DOT from VK
//  note: we don't invalidate on DOT state change
// #4 cache and lookup chain
//  inv: new DOTs on nsvk
//       changes to any of the DOTs
//
// GOTCHAs
//  - expiry may not reflect on chain (must be done in fromBC methods)
//  - revocation/expiry of subobjects may not reflect on chain (do in fromBC methods)
//  - DOT grants + entity creations are lagged by 5 confirmations (done in bcprovider)
//	- We need an expiry inv goroutine
//  - We need an on-registry-transaction inv goroutine

const holdoffConstant = 6

var hasit string

type ResolutionData struct {
	mu sync.RWMutex

	chaincache map[bc.Bytes32]map[CacheKey][]*objects.DChain

	// vk -> entity
	entityCache map[bc.Bytes32]*registryEntityResult
	// dothash -> dot
	dotHashCache map[bc.Bytes32]*registryDOTResult
	// dot from vk -> hash used for inv
	dotFromInvCache map[bc.Bytes32][]bc.Bytes32
	// This is similar to above, but has a stronger guarantee.
	// if a VK has an entry here, all of the DOTs that VK has
	// granted will be here. The above is just an opportunistic
	// cache
	dotFromCompleteCache map[bc.Bytes32][]bc.Bytes32
	// dot to vk -> hash used for inv
	dotToInvCache map[bc.Bytes32][]bc.Bytes32
	// dothash -> chainhash (for inv)
	dotChainCache map[bc.Bytes32][]bc.Bytes32
	// suppress caching built chains on these nsvks until this block number
	// has passed
	holdoff map[bc.Bytes32]uint64

	chainchangemu sync.Mutex
	lastblock     uint64

	expinvchan   chan struct{}
	nextInterval time.Duration
}

func newResolutionData() *ResolutionData {
	return &ResolutionData{
		chaincache:           make(map[bc.Bytes32]map[CacheKey][]*objects.DChain),
		entityCache:          make(map[bc.Bytes32]*registryEntityResult),
		dotHashCache:         make(map[bc.Bytes32]*registryDOTResult),
		dotFromInvCache:      make(map[bc.Bytes32][]bc.Bytes32),
		dotFromCompleteCache: make(map[bc.Bytes32][]bc.Bytes32),
		dotToInvCache:        make(map[bc.Bytes32][]bc.Bytes32),
		dotChainCache:        make(map[bc.Bytes32][]bc.Bytes32),
		expinvchan:           make(chan struct{}),
		holdoff:              make(map[bc.Bytes32]uint64),
		nextInterval:         5 * time.Second,
	}
}

func (bw *BW) startResolutionServices() {
	bw.rdata.lastblock = bw.BC().CurrentBlock()
	bw.BC().CallOnNewBlocks(func(b *bc.Block) bool {
		//Try avoid making the goroutine for a nop
		bw.rdata.chainchangemu.Lock()
		lblock := bw.rdata.lastblock
		bw.rdata.chainchangemu.Unlock()
		currentBlock := bw.BC().CurrentBlock()
		if lblock == currentBlock {
			return false
		}
		go bw.checkChainChange()
		return false
	})
	go func() {
		for {
			select {
			case <-bw.rdata.expinvchan:
			case <-time.After(bw.rdata.nextInterval):
			}
			bw.rdata.nextInterval = bw.checkExpiryInv()
		}
	}()
	go func() {
		for {
			time.Sleep(200 * time.Millisecond)
			go func() {
				ok := make(chan bool, 1)
				go func() {
					time.Sleep(1 * time.Second)
					select {
					case <-ok:
					default:
						log.Errorf("WARNING RESOLUTION DEADLOCK?: %s\n", hasit)
					}
				}()
				bw.rdata.mu.Lock()
				ok <- true
				bw.rdata.mu.Unlock()
			}()
		}
	}()

}

const (
	StateUnknown = iota
	StateValid
	StateExpired
	StateRevoked
	StateError
)

func (bw *BW) getlock() {
	// MyCaller returns the caller of the function that called it :)
	// we get the callers as uintptrs - but we just need 1
	fpcs := make([]uintptr, 1)
	// skip 3 levels to get to the caller of whoever called Caller()
	n := runtime.Callers(2, fpcs)
	if n == 0 {
		panic("a")
	}

	// get the info of the actual function that's in the pointer
	fun := runtime.FuncForPC(fpcs[0] - 1)
	if fun == nil {
		panic("b")
	}

	// return its name
	af, al := fun.FileLine(fpcs[0])

	caller := fmt.Sprintf("%s:%v,%v", fun.Name(), af, al)
	bw.rdata.mu.Lock()
	hasit = caller
}
func (bw *BW) rellock() {
	hasit = "rel"
	bw.rdata.mu.Unlock()
}
func (bw *BW) checkExpiryInv() time.Duration {
	//Cycle through entities
	bw.getlock()
	defer bw.rellock()
	minexpiry := time.Now().Add(1 * time.Hour)
	for _, er := range bw.rdata.entityCache {
		if er.ro.IsExpired() {
			go bw.FlushEntity(er.ro.GetVK())
		} else {
			ex := er.ro.GetExpiry()
			if ex != nil && ex.Before(minexpiry) {
				minexpiry = *ex
			}
		}
	}
	for _, dr := range bw.rdata.dotHashCache {
		if dr.ro.IsExpired() {
			go bw.FlushDOT(dr.ro.GetHash())
		} else {
			ex := dr.ro.GetExpiry()
			if ex != nil && ex.Before(minexpiry) {
				minexpiry = *ex
			}
		}
	}
	return minexpiry.Sub(time.Now())
}
func (bw *BW) forceExpiryInv() {
	bw.rdata.expinvchan <- struct{}{}
}
func (bw *BW) StateToString(state int) string {
	switch state {
	case StateUnknown:
		return "Unknown"
	case StateValid:
		return "Valid"
	case StateExpired:
		return "Expired"
	case StateRevoked:
		return "Revoked"
	default:
		return "Error"
	}
}

// captures the dot, and it's state
type DOTLink struct {
	D *objects.DOT
	S int
}
type registryEntityResult struct {
	ro *objects.Entity
	s  int
}
type registryDOTResult struct {
	ro *objects.DOT
	s  int
}

// There has been some kind of change (possibly)
func (bw *BW) checkChainChange() {
	bw.rdata.chainchangemu.Lock()
	defer bw.rdata.chainchangemu.Unlock()
	currentBlock := bw.BC().CurrentBlock()
	fmt.Printf("checking chain change for #%d\n", currentBlock)
	if bw.rdata.lastblock == currentBlock {
		fmt.Printf(" -- skip\n")
		return
	}

	logs := bw.BC().FindLogsBetween(int64(bw.rdata.lastblock), int64(currentBlock), bc.UFI_Registry_Address,
		[][]bc.Bytes32{}, false)
	bw.rdata.lastblock = currentBlock
	for _, log := range logs {
		switch log.Topics()[0] {
		case bc.HexToBytes32(bc.EventSig_Registry_NewDOT):
			ln := common.BytesToBig(log.Data()[32:64]).Int64()
			datahex := log.Data()[64 : 64+ln]
			ro, err := objects.NewDOT(objects.ROAccessDOT, datahex)
			if err != nil {
				panic("Could not decode log dot")
			}
			fmt.Printf("flushing nsvk=%s fromvk=%s\n", crypto.FmtKey(ro.(*objects.DOT).GetAccessURIMVK()), crypto.FmtKey(ro.(*objects.DOT).GetGiverVK()))
			bw.FlushGrantedFromCache(ro.(*objects.DOT).GetGiverVK())
			bw.FlushChainNSVK(ro.(*objects.DOT).GetAccessURIMVK())
			fallthrough
		case bc.HexToBytes32(bc.EventSig_Registry_NewDOTRevocation):
			fmt.Printf("flushing dot")
			bw.FlushDOT(log.Topics()[1][:])
		case bc.HexToBytes32(bc.EventSig_Registry_NewEntityRevocation), bc.HexToBytes32(bc.EventSig_Registry_NewEntity):
			fmt.Printf("flushing entity")
			bw.FlushEntity(log.Topics()[1][:])
		default:

		}
	}
}

// Resolve an Entity and it's state. An error will only be returned
// if there is some kind of chain or contract error, not for revocation
// or expiry etc.
func (bw *BW) ResolveEntity(vk []byte) (ro *objects.Entity, s int, err error) {
	ok, ro, s := bw.resolveEntityFromCache(vk)
	if ok {
		err = nil
		return
	}
	ro, s, err = bw.resolveEntityFromBC(vk)
	if err == nil && ro != nil && s != StateUnknown {
		bw.cacheEntity(ro, s)
	}
	return
}

func (bw *BW) ResolveDOT(hash []byte) (ro *objects.DOT, s int, err error) {
	ok, ro, s := bw.resolveDOTFromCache(hash)
	if ok {
		err = nil
		return
	}
	ro, s, err = bw.resolveDOTFromBC(hash)
	if err == nil && ro != nil && s != StateUnknown {
		bw.cacheDOT(ro, s)
	}
	return
}

func (bw *BW) ResolveGrantedDOTs(fromVK []byte) (links []DOTLink, err error) {
	ok, hashes := bw.resolveGrantedDOTsFromCache(fromVK)
	if !ok {
		hashes, err = bw.resolveGrantedDOTsFromBC(fromVK)
		if err == nil {
			bw.cacheGrantedDOTs(fromVK, hashes)
		} else {
			return nil, err
		}
	}
	links, err = bw.dothashToLink(hashes)
	return
}

func (bw *BW) ResolveAccessDChain(hash []byte) (ro *objects.DChain, s int, err error) {
	ro, s, err = bw.resolveAccessDChainFromBC(hash)
	return
}

//Discard cached entity and call FlushDOT on all dots that use the entity
func (bw *BW) FlushEntity(vk []byte) {
	bw.getlock()
	defer bw.rellock()
	kvk := bc.SliceToBytes32(vk)
	delete(bw.rdata.entityCache, kvk)
	dTo := bw.rdata.dotToInvCache[kvk]
	for _, dhash := range dTo {
		bw.flushDOT(dhash)
	}
	delete(bw.rdata.dotToInvCache, kvk)
	dFrom := bw.rdata.dotFromInvCache[kvk]
	for _, dhash := range dFrom {
		bw.flushDOT(dhash)
	}
	delete(bw.rdata.dotFromInvCache, kvk)
	// We don't need to flush dots in complete cache
	// because the above two are complete (cover all cached dots)
}

//Discard cached DOT
func (bw *BW) FlushDOT(hash []byte) {
	khash := bc.SliceToBytes32(hash)
	bw.getlock()
	bw.flushDOT(khash)
	bw.rellock()
}

//Lock must be held
func (bw *BW) flushDOT(hash bc.Bytes32) {
	delete(bw.rdata.dotHashCache, hash)
	//We don't need to flush toVK or fromVK because those are not stale
	//and they are hard to look up :p
	//We don't flush the chains because their validity is checked every time
	//they are accessed
}

// If a DOT appears from a VK (e.g), we need to flush the complete granted from cache
func (bw *BW) FlushGrantedFromCache(vk []byte) {
	kvk := bc.SliceToBytes32(vk)
	bw.getlock()
	delete(bw.rdata.dotFromCompleteCache, kvk)
	bw.rellock()
}

// If a DOT appears on an NSVK, discard cached chains on that nsvk
func (bw *BW) FlushChainNSVK(nsvk []byte) {
	bw.getlock()
	knsvk := bc.SliceToBytes32(nsvk)
	delete(bw.rdata.chaincache, knsvk)
	bw.rdata.holdoff[knsvk] = bw.BC().CurrentBlock() + holdoffConstant
	bw.rellock()
}

func (bw *BW) resolveEntityFromCache(vk []byte) (bool, *objects.Entity, int) {
	bw.getlock()
	defer bw.rellock()
	kvk := bc.SliceToBytes32(vk)
	entry, ok := bw.rdata.entityCache[kvk]
	if ok {
		return true, entry.ro, entry.s
	}
	return false, nil, StateUnknown
}
func (bw *BW) resolveEntityFromBC(vk []byte) (ro *objects.Entity, s int, err error) {
	var si int
	ro, si, err = bw.BC().ResolveEntity(vk)
	s = int(si)
	if s == StateValid && ro.IsExpired() {
		s = StateExpired
	}
	return
}
func (bw *BW) cacheEntity(ro *objects.Entity, s int) {
	bw.getlock()
	defer bw.rellock()
	kvk := bc.SliceToBytes32(ro.GetVK())
	bw.rdata.entityCache[kvk] = &registryEntityResult{ro: ro, s: s}
}
func (bw *BW) resolveDOTFromCache(hash []byte) (bool, *objects.DOT, int) {
	bw.getlock()
	defer bw.rellock()
	khash := bc.SliceToBytes32(hash)
	entry, ok := bw.rdata.dotHashCache[khash]
	if ok {
		//We can trust the state stored in the DOT cache because any change
		//in the entity state would have flushed the DOT from the cache
		return true, entry.ro, entry.s
	}
	return false, nil, StateUnknown
}
func (bw *BW) resolveDOTFromBC(hash []byte) (*objects.DOT, int, error) {
	var si int
	ro, si, err := bw.BC().ResolveDOT(hash)
	if err != nil {
		return nil, StateError, err
	}
	if si == StateValid {
		//Ensure you combine in the entity state too, the contract may not.
		_, fromS, fromErr := bw.ResolveEntity(ro.GetGiverVK())
		if fromErr != nil {
			return nil, StateError, err
		}
		if fromS != StateValid {
			return ro, fromS, nil
		}
		_, toS, toErr := bw.ResolveEntity(ro.GetReceiverVK())
		if toErr != nil {
			return nil, StateError, err
		}
		if toS != StateValid {
			return ro, toS, nil
		}
		if ro.IsExpired() {
			return ro, StateExpired, nil
		}
	}
	return ro, int(si), nil
}
func (bw *BW) cacheDOT(ro *objects.DOT, s int) {
	bw.getlock()
	defer bw.rellock()
	khash := bc.SliceToBytes32(ro.GetHash())
	bw.rdata.dotHashCache[khash] = &registryDOTResult{ro: ro, s: s}
	kFromVK := bc.SliceToBytes32(ro.GetGiverVK())
	kToVK := bc.SliceToBytes32(ro.GetReceiverVK())
	existing := false
	// If the has does not exist in one of the caches, it doesn't
	// exist in both (and vice versa)
	for _, hash := range bw.rdata.dotFromInvCache[kFromVK] {
		if hash == khash {
			existing = true
			break
		}
	}
	if !existing {
		bw.rdata.dotFromInvCache[kFromVK] = append(bw.rdata.dotFromInvCache[kFromVK], khash)
		bw.rdata.dotToInvCache[kToVK] = append(bw.rdata.dotToInvCache[kToVK], khash)
	}
}
func (bw *BW) resolveAccessDChainFromBC(hash []byte) (*objects.DChain, int, error) {
	var si int
	ro, si, err := bw.BC().ResolveAccessDChain(hash)
	if err != nil {
		return nil, StateError, err
	}
	if si == StateValid {
		//Ensure you combine in the dot state too, the contract may not.
		for dhidx := 0; dhidx < ro.NumHashes(); dhidx++ {
			dhash := ro.GetDotHash(dhidx)
			_, dotstate, err := bw.ResolveDOT(dhash)
			if err != nil {
				return nil, StateError, err
			}
			if dotstate != StateValid {
				return ro, dotstate, nil
			}
		}
	}
	return ro, int(si), nil
}
func (bw *BW) resolveBuiltChain(k CacheKey) ([]*objects.DChain, []int) {
	bw.getlock()
	nsmap, ok := bw.rdata.chaincache[k.nsvk]
	if !ok {
		bw.rellock()
		return nil, nil
	}
	chains, ok2 := nsmap[k]
	bw.rellock()
	if !ok2 {
		return nil, nil
	}
	states := make([]int, len(chains))
	for idx, chain := range chains {
		for dotidx := 0; dotidx < chain.NumHashes(); dotidx++ {
			_, ds, err := bw.ResolveDOT(chain.GetDotHash(dotidx))
			if err != nil {
				panic(err)
			}
			if ds != StateValid {
				states[idx] = ds
				goto nextchain
			}
		}
		//We don't check the validity of the dchain itself, other places will
		//hopefully have done that before caching it
		states[idx] = StateValid
	nextchain:
	}
	return chains, states
}
func (bw *BW) cacheBuiltChains(k CacheKey, ro []*objects.DChain) {
	bw.getlock()
	defer bw.rellock()
	//To workaround the mismatch between a new dot appearing (and invalidating
	//the cache) and when it becomes valid, simply refuse to cache chains
	//present in the holdoff map
	bn, ok := bw.rdata.holdoff[k.nsvk]
	if ok {
		if bw.BC().CurrentBlock() > bn {
			log.Info("removing holdoff")
			delete(bw.rdata.holdoff, k.nsvk)
		} else {
			log.Info("observing holdoff")
			return
		}
	}
	nsmap, ok := bw.rdata.chaincache[k.nsvk]
	if !ok {
		nsmap = make(map[CacheKey][]*objects.DChain)
	}
	nsmap[k] = ro
	bw.rdata.chaincache[k.nsvk] = nsmap
}
func (bw *BW) resolveGrantedDOTsFromCache(vk []byte) (bool, []bc.Bytes32) {
	bw.getlock()
	defer bw.rellock()
	kvk := bc.SliceToBytes32(vk)
	hashlist, ok := bw.rdata.dotFromCompleteCache[kvk]
	return ok, hashlist
}
func (bw *BW) resolveGrantedDOTsFromBC(vk []byte) ([]bc.Bytes32, error) {
	kvk := bc.SliceToBytes32(vk)
	dhashes, err := bw.BC().ResolveDOTsFromVK(kvk)
	return dhashes, err
}
func (bw *BW) cacheGrantedDOTs(vk []byte, dots []bc.Bytes32) {
	bw.getlock()
	defer bw.rellock()
	kvk := bc.SliceToBytes32(vk)
	bw.rdata.dotFromCompleteCache[kvk] = dots
}
func (bw *BW) dothashToLink(dhashes []bc.Bytes32) ([]DOTLink, error) {
	rv := make([]DOTLink, len(dhashes))
	for idx, dh := range dhashes {
		dot, state, err := bw.ResolveDOT(dh[:])
		if err != nil {
			return nil, err
		}
		rv[idx] = DOTLink{D: dot, S: state}
	}
	return rv, nil
}

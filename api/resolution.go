// +build ignore

package api

import (
	"bytes"
	"encoding/gob"
	"encoding/hex"
	"fmt"
	"os"
	"path"
	"strings"
	"time"
	"unicode/utf8"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/bc"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util/bwe"
)

//All of this shit requires caching. A naive cache will suck because we will miss
//changes. So we need to subscribe to bc changes to keep things in sync.

//Invalid old function
/*
func (bw *BW) GetTarget(drvk string) (string, error) {
	return bw.LookupSRVRecord(drvk)
}
*/

func (bw *BW) startResolutionLoop() {
	fname := path.Join(bw.Config.Router.DB, "rocache")
	rocache, err := os.Open(fname)
	var versionmagic uint64
	if err == nil {
		dec := gob.NewDecoder(rocache)
		err = dec.Decode(&versionmagic)
		if err != nil {
			log.Criticalf("Could not load rocache, please delete %s and restart", fname)
			os.Exit(1)
		}
		if versionmagic != 0xFFFFBEEFBABE0001 {
			rocache.Close()
			log.Infof("Rocache is the wrong version, ignoring")
			goto skip
		}
		err = dec.Decode(&bw.lag.doneNumber)
		if err != nil {
			log.Criticalf("Could not load rocache, please delete %s and restart", fname)
			os.Exit(1)
		}
		err = dec.Decode(&bw.lag.expectParent)
		if err != nil {
			log.Criticalf("Could not load rocache, please delete %s and restart", fname)
			os.Exit(1)
		}
		err = dec.Decode(&bw.dotFromCache)
		if err != nil {
			log.Criticalf("Could not load rocache, please delete %s and restart", fname)
			os.Exit(1)
		}
		err = dec.Decode(&bw.dotToCache)
		if err != nil {
			log.Criticalf("Could not load rocache, please delete %s and restart", fname)
			os.Exit(1)
		}
		err = dec.Decode(&bw.entityCache)
		if err != nil {
			log.Criticalf("Could not load rocache, please delete %s and restart", fname)
			os.Exit(1)
		}
		err = dec.Decode(&bw.dotHashCache)
		if err != nil {
			log.Criticalf("Could not load rocache, please delete %s and restart", fname)
			os.Exit(1)
		}
		rocache.Close()
		log.Infof("Loaded rocache number %d", bw.lag.doneNumber)
	} else {
		log.Warnf("Did not load rocache")
	}
skip:

	bw.lag.Subscribe(func(b *bc.Block) {
		//Check the logs for DOTs
		for _, l := range b.Logs {
			log.Tracef("Found log from %x \n %s", l.ContractAddress(), l.String())
			if l.ContractAddress() == bc.HexToAddress(bc.UFI_Registry_Address) {
				switch {
				case l.MatchesTopicsStrict([]bc.Bytes32{
					bc.HexToBytes32(bc.EventSig_Registry_NewDOT)}):
					log.Tracef("Found a DOT: \n%s", l)
					dh := l.Topics()[1]
					// dot, s, err := bw.ResolveDOT(dh[:])
					// if err != nil {
					// 	panic(err)
					// }
					bw.FlushDOT(dh[:])

				case l.MatchesTopicsStrict([]bc.Bytes32{
					bc.HexToBytes32(bc.EventSig_Registry_NewDOTRevocation)}):
					log.Tracef("Found a DOT revocation: \n%s", l)
					dh := l.Topics()[1]
					bw.FlushDOT(dh[:])
					//
					// bw.cachemu.Lock()
					// dh := l.Topics()[1]
					// entry, ok := bw.dotHashCache[dh]
					// _, s, e := bw.ResolveDOT(dh[:])
					// if ok {
					// 	entry.valid = false
					// 	entry.s = s
					// 	entry.err = e
					// }
					// bw.cachemu.Unlock()
				case l.MatchesTopicsStrict([]bc.Bytes32{
					bc.HexToBytes32(bc.EventSig_Registry_NewEntityRevocation)}):
					vk := l.Topics()[1]
					bw.FlushEntity(vk[:])
					//
					// fE, ok := bw.dotFromCache[vk]
					// if ok {
					// 	fmt.Println("invalidated DOT fcache entry")
					// 	for _, hash := range fE {
					// 		entry, ok2 := bw.dotHashCache[hash]
					// 		if ok2 {
					// 			must invalidate chains as well
					// 			_, s, e := bw.ResolveDOT(hash[:])
					// 			entry.valid = false
					// 			entry.s = s
					// 			entry.err = e
					// 		}
					// 	}
					// }
					// tE, ok := bw.dotToCache[vk]
					// if ok {
					// 	fmt.Println("invalidated DOT tcache entry")
					// 	for _, hash := range tE {
					// 		entry, ok2 := bw.dotHashCache[hash]
					// 		if ok2 {
					// 			_, s, e := bw.ResolveDOT(hash[:])
					// 			entry.valid = false
					// 			entry.s = s
					// 			entry.err = e
					// 		}
					// 	}
					// }
					// ent, ok := bw.entityCache[vk]
					// if ok {
					// 	_, s, e := bw.ResolveEntity(vk[:])
					// 	ent.valid = false
					// 	ent.s = s
					// 	ent.err = e
					// }
					// bw.cachemu.Unlock()
				}
			}
		}
	})
	bw.lag.BeginLoop()
	// go func() {
	// 	for {
	//
	// 		bw.cachemu.Lock()
	// 		fmt.Println("Cache size:", bw.cachesize)
	// 		bw.cachemu.Unlock()
	// 		time.Sleep(5 * time.Second)
	// 	}
	// }()
	go func() {
		for {
			time.Sleep(30 * time.Second)

			rocache, err := os.Create(path.Join(bw.Config.Router.DB, "rocache.next"))
			if err != nil {
				panic(err)
			}

			enc := gob.NewEncoder(rocache)
			bw.lag.smu.Lock()
			bw.cachemu.Lock()
			err = enc.Encode(bw.lag.doneNumber)
			if err != nil {
				panic(err)
			}
			err = enc.Encode(bw.lag.expectParent)
			if err != nil {
				panic(err)
			}
			err = enc.Encode(bw.dotFromCache)
			if err != nil {
				panic(err)
			}
			err = enc.Encode(bw.dotToCache)
			if err != nil {
				panic(err)
			}
			err = enc.Encode(bw.entityCache)
			if err != nil {
				panic(err)
			}
			err = enc.Encode(bw.dotHashCache)
			if err != nil {
				panic(err)
			}
			bw.cachemu.Unlock()
			bw.lag.smu.Unlock()

			err = rocache.Close()
			if err != nil {
				panic(err)
			}
			os.Rename(path.Join(bw.Config.Router.DB, "rocache.next"), path.Join(bw.Config.Router.DB, "rocache"))
			log.Infof("Saved rocache")
		}
	}()
}

func (bw *BW) GetDOTsFrom(giver []byte) ([]*DOTLink, error) {
	from := bc.SliceToBytes32(giver)
	bw.cachemu.Lock()
	defer bw.cachemu.Unlock()
	hashslice, ok := bw.dotFromCache[from]
	if !ok {
		return nil, nil
	}
	rv := []*DOTLink{}
	for _, dh := range hashslice {
		de := bw.dotHashCache[dh]
		if de.s == StateError {
			panic("I don't think this should happen")
		}
		dl := DOTLink{de.ro, de.s}
		rv = append(rv, &dl)
	}
	return rv, nil
}

// func (bw *BW) GetDOTsBetween(giver []byte, receiver []byte) ([]*DOTLink, error) {
// 	from := bc.SliceToBytes32(giver)
// 	to := bc.SliceToBytes32(receiver)
// 	bw.cachemu.Lock()
// 	defer bw.cachemu.Unlock()
// 	fmap, ok := bw.dotcache[from]
// 	if !ok {
// 		return nil, nil
// 	}
// 	tslc, ok := fmap[to]
// 	if !ok {
// 		return nil, nil
// 	}
// 	rv := make([]*DOTLink, len(tslc))
// 	for i, hsh := range tslc {
// 		d, s, e := bw.ResolveDOT(hsh[:])
// 		if s == StateError {
// 			return nil, e
// 		}
// 		dl := DOTLink{d, s}
// 		rv[i] = &dl
// 	}
// 	return rv, nil
// }
func (bw *BW) UnresolveAlias(val []byte) (string, bool, error) {
	if len(val) > 32 {
		return "", false, nil
	}
	key, iszero, err := bw.BC().UnresolveAlias(bc.SliceToBytes32(val))
	if err != nil || iszero {
		return "", false, err
	}
	return NullTerminatedByteSliceToString(key[:]), true, nil
}

//Get the host:port SRV record for a drvk. XTAG add this to the bc caching
//mechanism
func (bw *BW) LookupDesignatedRouterSRV(drvk []byte) (string, error) {
	return bw.bchain.GetSRVRecordFor(drvk)
}

//XTAG add this to the bc caching mechanism
func (bw *BW) LookupDesignatedRouter(nsvk []byte) ([]byte, error) {
	return bw.bchain.GetDesignatedRouterFor(nsvk)
}
func (bw *BW) LookupDesignatedRouterS(nsvk string) ([]byte, error) {
	nsvkbin, err := crypto.UnFmtKey(nsvk)
	if err != nil {
		return nil, err
	}
	return bw.LookupDesignatedRouter(nsvkbin)
}

func (bw *BW) ResolveLongAlias(in string) ([]byte, error) {
	k := bc.Bytes32{}
	copy(k[:], []byte(in))
	res, iszero, err := bw.bchain.ResolveAlias(k)
	if err != nil {
		return nil, err
	}
	if iszero {
		return nil, bwe.M(bwe.UnresolvedAlias, "Could not resolve long alias")
	}
	return res[:], nil
}
func (bw *BW) ResolveShortAlias(hexstr string) ([]byte, error) {
	if len(hexstr)%2 == 1 {
		hexstr = "0" + hexstr
	}
	bin, err := hex.DecodeString(hexstr)
	if err != nil {
		return nil, bwe.M(bwe.UnresolvedAlias, "Bad hex for short alias")
	}
	k := bc.Bytes32{}
	copy(k[32-len(bin):], bin)
	res, iszero, err := bw.bchain.ResolveAlias(k)
	if err != nil {
		return nil, err
	}
	if iszero {
		return nil, bwe.M(bwe.UnresolvedAlias, "Could not resolve short alias")
	}
	return res[:], nil
}
func NullTerminatedByteSliceToString(bs []byte) string {
	var buffer bytes.Buffer
	for _, runeVal := range string(bs) {
		if runeVal == 0 {
			break
		}
		buffer.WriteRune(runeVal)
	}
	return buffer.String()
}
func (bw *BW) ExpandAliases(in string) (string, error) {
	var buffer bytes.Buffer
	for i, w := 0, 0; i < len(in); i += w {
		runeValue, width := utf8.DecodeRuneInString(in[i:])
		w = width
		if runeValue == '@' {
			if in[i+1] == '@' {
				buffer.WriteString("@")
				i += w //skip ahead of next @
				continue
			}
			endshortidx := strings.IndexRune(in[i:], '>')
			endlongidx := strings.IndexRune(in[i:], '<')
			if endshortidx == -1 && endlongidx == -1 {
				return "", bwe.M(bwe.UnresolvedAlias, "Unterminated alias")
			}
			if endshortidx == -1 || (endlongidx < endshortidx && endlongidx != -1) {
				longval, err := bw.ResolveLongAlias(in[i+1 : endlongidx])
				if err != nil {
					return "", err
				}
				longstrval := NullTerminatedByteSliceToString(longval)
				buffer.WriteString(longstrval)
				i = endlongidx
			}
			if endlongidx == -1 || (endshortidx < endlongidx && endshortidx != -1) {
				shortval, err := bw.ResolveShortAlias(in[i+1 : endshortidx])
				if err != nil {
					return "", err
				}
				shortstrval := NullTerminatedByteSliceToString(shortval)
				buffer.WriteString(shortstrval)
				i = endshortidx
			}
		}
	}
	return buffer.String(), nil
}

//A little like expand aliases except we first check if it is
//a valid encoded key and only if that fails do we  assume it
//is a long alias. The result is a binary VK
func (bw *BW) ResolveKey(name string) ([]byte, error) {
	nsvk, err := crypto.UnFmtKey(name)
	if err == nil {
		return nsvk, nil
	}
	if len([]byte(name)) > 32 {
		return nil, bwe.M(bwe.UnresolvedAlias, "Key is not a VK/Hash but longer than an alias"+name)
	}
	k := bc.Bytes32{}
	copy(k[:], []byte(name))
	res, iszero, err := bw.bchain.ResolveAlias(k)
	if err != nil {
		return nil, err
	}
	if iszero {
		return nil, bwe.M(bwe.UnresolvedAlias, "Key not found")
	}
	return res[:], nil
}

func (bw *BW) ResolveRO(aliasorhash string) (ros objects.RoutingObject, state int, err error) {
	bhash, err := crypto.UnFmtKey(aliasorhash)
	if err != nil {
		//Try and resolve it as an alias
		if len([]byte(aliasorhash)) > 32 {
			return nil, StateError, bwe.M(bwe.UnresolvedAlias, "Key is not a VK/Hash but longer than an alias"+aliasorhash)
		}
		bhash, err = bw.ResolveLongAlias(aliasorhash)
		if err != nil {
			return nil, StateError, err
		}
	}
	//These errors might not prevent resolving the RO's. They might be
	//revocations or expiries and whatnot
	dot, state, err := bw.ResolveDOT(bhash)
	if dot != nil {
		return dot, state, err
	}
	ent, state, err := bw.ResolveEntity(bhash)
	if ent != nil {
		return ent, state, err
	}
	dc, state, err := bw.ResolveAccessDChain(bhash)
	if dc != nil {
		return dc, state, err
	}
	return nil, StateUnknown, nil
}

const (
	StateUnknown = iota
	StateValid
	StateExpired
	StateRevoked
	StateError
)

// Although this is in resolution, we actually evaluate expiry based on the
// real wall time. Err is actually a useful value that can be used higher up
// plus we validate the entities in the DOT too
func (bw *BW) GetDOTState(d *objects.DOT) (err error) {
	if d.GetExpiry() != nil {
		if d.GetExpiry().Before(time.Now()) {
			return bwe.M(bwe.ExpiredDOT, "DOT "+crypto.FmtHash(d.GetHash())+" is expired by our clock")
		}
	}
	_, state, err := bw.ResolveDOT(d.GetHash())
	switch state {
	case StateRevoked:
		return bwe.M(bwe.RevokedDOT, "DOT "+crypto.FmtHash(d.GetHash())+" is revoked")
	case StateExpired:
		return bwe.M(bwe.ExpiredDOT, "DOT "+crypto.FmtHash(d.GetHash())+" is expired in the registry")
	case StateValid:
		fE, _, _ := bw.ResolveEntity(d.GetGiverVK())
		if fE == nil {
			return bwe.M(bwe.RegistryEntityResolutionFailed, "Unexpected missing entity")
		}
		eF := bw.GetEntityState(fE)
		if eF != nil {
			return eF
		}
		tE, _, _ := bw.ResolveEntity(d.GetReceiverVK())
		if tE == nil {
			return bwe.M(bwe.RegistryEntityResolutionFailed, "Unexpected missing entity")
		}
		eT := bw.GetEntityState(tE)
		if eT != nil {
			return eT
		}
		return nil
	default:
		return bwe.WrapC(bwe.RegistryDOTResolutionFailed, err)
	}
}

// Although this is in resolution, we actually evaluate expiry based on the
// real wall time. Err is actually a useful value that can be used higher up
func (bw *BW) GetEntityState(e *objects.Entity) (err error) {
	if e.GetExpiry() != nil {
		if e.GetExpiry().Before(time.Now()) {
			return bwe.M(bwe.ExpiredEntity, "Entity "+crypto.FmtKey(e.GetVK())+" is expired by our clock")
		}
	}
	_, state, err := bw.ResolveEntity(e.GetVK())
	switch state {
	case StateRevoked:
		return bwe.M(bwe.RevokedEntity, "Entity "+crypto.FmtKey(e.GetVK())+" is revoked")
	case StateExpired:
		return bwe.M(bwe.ExpiredEntity, "Entity "+crypto.FmtKey(e.GetVK())+" is expired in the registry")
	case StateValid:
		return nil
	default:
		return bwe.WrapC(bwe.RegistryEntityResolutionFailed, err)
	}
}

//These should use the cache when we make it
func (bw *BW) ResolveDOT(dothash []byte) (*objects.DOT, int, error) {
	//First check cache
	bw.cachemu.RLock()
	res, hit := bw.dotHashCache[bc.SliceToBytes32(dothash)]
	bw.cachemu.RUnlock()
	if hit && res.valid {
		return res.ro, res.s, res.err
	}
	d, s, er := bw.bchain.ResolveDOT(dothash)
	if s != StateError {
		memo := &registryDOTResult{ro: d, s: s, err: er, valid: true}
		bw.cachemu.Lock()
		k := bc.SliceToBytes32(dothash)
		bw.dotHashCache[k] = memo
		if d != nil {
			bw.dotFromCache[bc.SliceToBytes32(d.GetGiverVK())] = k
			bw.dotToCache[bc.SliceToBytes32(d.GetReceiverVK())] = k
		}
		bw.cachemu.Unlock()
	}
	return d, s, er
}
func (bw *BW) ResolveEntity(vk []byte) (*objects.Entity, int, error) {
	//First check cache
	bw.cachemu.RLock()
	res, hit := bw.entityCache[bc.SliceToBytes32(vk)]
	bw.cachemu.RUnlock()
	if hit && res.valid {
		return res.ro, res.s, res.err
	}
	e, s, er := bw.bchain.ResolveEntity(vk)
	if s != StateError {
		memo := &registryEntityResult{ro: e, s: s, err: er, valid: true}
		bw.cachemu.Lock()
		bw.entityCache[bc.SliceToBytes32(vk)] = memo
		bw.cachemu.Unlock()
	}
	return e, s, er
}

var radccount int

func (bw *BW) ResolveAccessDChain(chainhash []byte) (*objects.DChain, int, error) {
	fmt.Printf("RADC called %d times\n", radccount)
	radccount += 1

	return bw.bchain.ResolveAccessDChain(chainhash)
}

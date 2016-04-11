package api

import (
	"bytes"
	"encoding/gob"
	"encoding/hex"
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
	rocache, err := os.Open(path.Join(bw.Config.Router.DB, "rocache"))
	if err == nil {
		dec := gob.NewDecoder(rocache)
		err = dec.Decode(&bw.lag.doneNumber)
		if err != nil {
			panic(err)
		}
		err = dec.Decode(&bw.lag.expectParent)
		if err != nil {
			panic(err)
		}
		err = dec.Decode(&bw.cachesize)
		if err != nil {
			panic(err)
		}
		err = dec.Decode(&bw.dotcache)
		if err != nil {
			panic(err)
		}
		rocache.Close()

		log.Infof("Loaded ROCache number %d", bw.lag.doneNumber)
	} else {
		log.Warnf("Did not load ROCache: %v", err)
	}

	bw.lag.Subscribe(func(b *bc.Block) {
		//Check the logs for DOTs
		for _, l := range b.Logs {
			log.Tracef("Found log from %x \n %s", l.ContractAddress(), l.String())
			topicz := []bc.Bytes32{bc.HexToBytes32(bc.EventSig_Registry_NewDOT)}
			if l.ContractAddress() == bc.HexToAddress(bc.UFI_Registry_Address) &&
				l.MatchesTopicsStrict(topicz) {
				log.Tracef("Found a DOT: \n%s", l)
				dh := l.Topics()[1]
				dot, _, err := bw.ResolveDOT(dh[:])
				if err != nil {
					panic(err)
				}
				bw.CacheDOT(dot)
			}
		}
	}, func() {
		bw.cachemu.Lock()
		bw.dotcache = make(map[bc.Bytes32]map[bc.Bytes32][]bc.Bytes32)
		bw.cachemu.Unlock()
	})
	bw.lag.BeginLoop()
	go func() {
		for {

			bw.cachemu.Lock()
			log.Infof("ROCache size: %d", bw.cachesize)
			bw.cachemu.Unlock()
			time.Sleep(5 * time.Second)
		}
	}()
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
			err = enc.Encode(bw.cachesize)
			if err != nil {
				panic(err)
			}
			err = enc.Encode(bw.dotcache)
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
			log.Infof("Save ROCache")
		}
	}()
}

func (bw *BW) CacheDOT(d *objects.DOT) {
	bw.cachemu.Lock()
	defer bw.cachemu.Unlock()
	from := bc.SliceToBytes32(d.GetGiverVK())
	to := bc.SliceToBytes32(d.GetReceiverVK())
	hsh := bc.SliceToBytes32(d.GetHash())
	fmap, ok := bw.dotcache[from]
	if !ok {
		fmap = make(map[bc.Bytes32][]bc.Bytes32)
		bw.dotcache[from] = fmap
	}
	tslc, ok := fmap[to]
	if !ok {
		tslc = make([]bc.Bytes32, 0, 1)
	}
	for _, v := range tslc {
		if v == hsh {
			return //Already there
		}
	}
	bw.cachesize++
	tslc = append(tslc, hsh)
	fmap[to] = tslc
}

type DOTLink struct {
	D *objects.DOT
	S int
}

func (bw *BW) GetDOTsFrom(giver []byte) ([]*DOTLink, error) {
	from := bc.SliceToBytes32(giver)
	bw.cachemu.Lock()
	defer bw.cachemu.Unlock()
	fmap, ok := bw.dotcache[from]
	if !ok {
		return nil, nil
	}
	rv := []*DOTLink{}
	for to := range fmap {
		tslc := fmap[to]
		for _, hsh := range tslc {
			d, s, e := bw.ResolveDOT(hsh[:])
			if s == StateError {
				return nil, e
			}
			dl := DOTLink{d, s}
			rv = append(rv, &dl)
		}
	}
	return rv, nil
}

func (bw *BW) GetDOTsBetween(giver []byte, receiver []byte) ([]*DOTLink, error) {
	from := bc.SliceToBytes32(giver)
	to := bc.SliceToBytes32(receiver)
	bw.cachemu.Lock()
	defer bw.cachemu.Unlock()
	fmap, ok := bw.dotcache[from]
	if !ok {
		return nil, nil
	}
	tslc, ok := fmap[to]
	if !ok {
		return nil, nil
	}
	rv := make([]*DOTLink, len(tslc))
	for i, hsh := range tslc {
		d, s, e := bw.ResolveDOT(hsh[:])
		if s == StateError {
			return nil, e
		}
		dl := DOTLink{d, s}
		rv[i] = &dl
	}
	return rv, nil
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

//These should use the cache when we make it
func (bw *BW) ResolveDOT(dothash []byte) (*objects.DOT, int, error) {
	return bw.bchain.ResolveDOT(dothash)
}
func (bw *BW) ResolveEntity(vk []byte) (*objects.Entity, int, error) {
	return bw.bchain.ResolveEntity(vk)
}
func (bw *BW) ResolveAccessDChain(chainhash []byte) (*objects.DChain, int, error) {
	return bw.bchain.ResolveAccessDChain(chainhash)
}

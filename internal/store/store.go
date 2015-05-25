package store

//This module stores and retrieves DOTs, Entities and DChains. For now its
//a passthru to the database.
//Note that these parameters must be clean at this stage of the program. The
//topics must be well formed, and the messages must be syntactically valid
//otherwise we will panic when extracting them from the DB

import (
	"fmt"
	"strings"
	"sync"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/internal/rocks"
	"github.com/immesys/bw2/objects"
)

//These constants are used to differentiate blocks of keys in the DB.
//We leave a space between them so that we can do range queries
const (
	markDOT     = 1
	markEDOT    = 2
	markDChain  = 3
	markEDChain = 4
	markEntity  = 5
	markEEntity = 6
)

//StoreDOT puts a DOT into the DB
func PutDOT(v *objects.DOT) {
	//We assume all DOTs in the DB are valid, so we should make sure it has
	//been checked. This is practically a noop if it has already been checked
	if !v.SigValid() {
		return
	}
	value := make([]byte, len(v.GetContent())+1)
	value[0] = byte(v.GetRONum())
	copy(value[1:], v.GetContent())
	rocks.PutObject(rocks.CFDot, v.GetHash(), value)
}

//RetreiveDOT gets a DOT from the DB
func GetDOT(hash []byte) (*objects.DOT, bool) {
	value, err := rocks.GetObject(rocks.CFDot, hash)
	if err == rocks.ErrObjNotFound {
		return nil, false
	}
	rdot, err := objects.NewDOT(int(value[0]), value[1:])
	if err != nil {
		log.Criticalf("Deserializing dot from DB: %v", err)
		panic("Deserialising dot from dB")
	}
	dot := rdot.(*objects.DOT)
	dot.OverrideSetSignatureValid()
	return dot, true
}

//StoreDChain puts a DChain into the DB. This must be an elaborated
//DChain, otherwise it panics (no point in storing a standard dchain)
func PutDChain(v *objects.DChain) {
	if !v.IsElaborated() {
		panic("dchain needs to be elaborated")
	}
	value := make([]byte, len(v.GetContent())+1)
	value[0] = byte(v.GetRONum())
	copy(value[1:], v.GetContent())
	rocks.PutObject(rocks.CFDChain, v.GetChainHash(), value)
}

func GetDChain(hash []byte) (*objects.DChain, bool) {
	value, err := rocks.GetObject(rocks.CFDChain, hash)
	if err == rocks.ErrObjNotFound {
		return nil, false
	}
	rdchain, err := objects.NewDChain(int(value[0]), value[1:])
	if err != nil {
		log.Criticalf("Deserialising dchain from db: %v", err)
		panic("Deserialising dchain from dB")
	}
	dchain := rdchain.(*objects.DChain)
	return dchain, true
}

func PutEntity(v *objects.Entity) {
	//We assume all Entities in the DB are valid, so we should make sure it has
	//been checked. This is practically a noop if it has already been checked
	if !v.SigValid() {
		return
	}
	rocks.PutObject(rocks.CFEntity, v.GetVK(), v.GetContent())
}

func GetEntity(vk []byte) (*objects.Entity, bool) {
	value, err := rocks.GetObject(rocks.CFEntity, vk)
	if err == rocks.ErrObjNotFound {
		return nil, false
	}
	rentity, err := objects.NewDChain(int(value[0]), value[1:])
	if err != nil {
		log.Criticalf("Deserialising entity from DB: %v", err)
		panic("Deserialising entity from dB")
	}
	entity := rentity.(*objects.Entity)
	entity.OverrideSetSignatureValid()
	return entity, true
}

func InterlaceURI(uri []string) []string {
	rv := make([]string, len(uri))
	for i := 0; i < len(uri); i += 2 {
		rv[i] = uri[i/2]
		if i+1 < len(uri) {
			rv[i+1] = uri[(len(uri)-1)-i/2]
		}
	}
	return rv
}
func UnInterlaceURI(rv []string) []string {
	uri := make([]string, len(rv))
	for i := 0; i < len(uri); i += 2 {
		uri[i/2] = rv[i]
		if i+1 < len(uri) {
			uri[(len(uri)-1)-i/2] = rv[i+1]
		}
	}
	return uri
}

//Given an interlaced string and some _remaining_ *D. Construct the
//uninterlaced string
func AdvancedUnInterlaceURI(rv []string, frontD []string, backD []string) []string {
	uri := make([]string, len(rv)+len(frontD)+len(backD))
	bidx := len(uri) - 1
	fidx := 0
	//copy interlacing
	for i, v := range rv {
		if i&1 == 0 {
			//front
			uri[fidx] = v
			fidx++
		}
		if i&1 == 1 {
			//back
			uri[bidx] = v
			bidx--
		}
	}
	//copy frontD
	for _, v := range frontD {
		uri[fidx] = v
		fidx++
	}
	for _, v := range backD {
		uri[bidx] = v
		bidx--
	}
	fmt.Printf("Advanced UIURI fidx=%d bidx=%d uri=%v\n", fidx, bidx, uri)
	return uri
}

// a/b/c/d
// a/d/b/c
//PutMessage inserts a message into the database. Note that the topic must be
//well formed and complete (no wildcards etc)
func PutMessage(topic string, payload []byte) {
	ts := strings.Split(topic, "/")
	tb := make([]byte, len(topic)+1)
	copy(tb[1:], []byte(topic))
	tb[0] = byte(len(ts))
	mrg := InterlaceURI(ts)
	fmt.Printf("The merge: %v\n", mrg)
	smrgs := strings.Join(mrg, "/")
	smrg := make([]byte, len(smrgs)+1)
	copy(smrg[1:], []byte(smrgs))
	smrg[0] = byte(len(mrg))
	rocks.PutObject(rocks.CFMsgI, smrg, payload)
	rocks.PutObject(rocks.CFMsg, tb, payload)

	//Put parents
	for i := len(ts) - 1; i > 0; i-- {
		pstrs := []byte(strings.Join(ts[0:i], "/"))
		pstr := make([]byte, len(pstrs)+1)
		pstr[0] = byte(i)
		copy(pstr[1:], pstrs)
		if !rocks.Exists(rocks.CFMsg, pstr) {
			rocks.PutObject(rocks.CFMsg, pstr, []byte{0})
		} else {
			//We assume that if a path exists, all its parents exist
			break
		}
	}
	for i := len(mrg) - 1; i > 0; i-- {
		pstrs := []byte(strings.Join(mrg[0:i], "/"))
		pstr := make([]byte, len(pstrs)+1)
		pstr[0] = byte(i)
		copy(pstr[1:], pstrs)
		if !rocks.Exists(rocks.CFMsgI, pstr) {
			rocks.PutObject(rocks.CFMsgI, pstr, []byte{0})
		} else {
			//We assume that if a path exists, all its parents exist
			break
		}
	}
}

func GetExactMessage(topic string) ([]byte, bool) {
	ts := strings.Split(topic, "/")
	key := make([]byte, len(topic)+1)
	copy(key[1:], []byte(topic))
	key[0] = byte(len(ts))
	value, err := rocks.GetObject(rocks.CFMsg, key)
	if err != nil || IsDummy(value) {
		return nil, false
	}
	return value, true
}

type SM struct {
	uri  string
	body []byte
}

func MakeSMFromParts(uriparts []string, body []byte) SM {
	return SM{uri: strings.Join(uriparts, "/"),
		body: body,
	}
}

func iswild(s string) bool {
	return s == "*" || s == "+"
}
func mkkey(uri []string) []byte {
	ms := strings.Join(uri, "/")
	key := make([]byte, len(ms)+1)
	key[0] = byte(len(uri))
	copy(key[1:], []byte(ms))
	return key
}
func mkchildkey(uri []string) []byte {
	ms := strings.Join(uri, "/")
	key := make([]byte, len(ms)+1)
	key[0] = byte(len(uri) + 1) //This is so we find children
	copy(key[1:], []byte(ms))
	return key
}
func unmakekey(key []byte) []string {
	return strings.Split(string(key[1:]), "/")
}
func IsDummy(value []byte) bool {
	return len(value) == 1 && value[0] == 0
}

//The logic here is a bit fucking over the top, so let me clarify for future me.
//We are handling two cases: interlaced and non-interlaced. For non interlaced everything
//should be simple. frontD should be emtpy and backD can have some stuffs. if interlaced,
//either (but not both) can have some stuff. they represent the delta after the uri is split to
//handle the star. If there is a star, it will be the last element in the uri (interlaced)
//or not. When the base cases for the star expansion are being tested, frontD and backD
//need to be inserted. When the children of an interlaced uri are being inspected,
//evey second level can be skipped and populated by a *D element.
//if the length of the uri is even, it is a frontD element, else a backD
//frontD is in left to right order, backD is in right to left order
func getMatchingMessage(interlaced bool, uri []string, prefix int, frontD []string, backD []string,
	skipbase bool, handle chan SM, wg *sync.WaitGroup) {
	fmt.Printf("GMM in=%v uri=%v pfx=%v frontd=%v backd=%v \n", interlaced, uri, prefix, frontD, backD)
	//Make CF
	cf := rocks.CFMsg
	if interlaced {
		cf = rocks.CFMsgI
	}
	//Extend our prefix until the next wildcard
	nprefix := prefix
	for ; nprefix < len(uri) && !iswild(uri[nprefix]); nprefix++ {
	}
	//if there is no next wildcard, it is the end
	if nprefix == len(uri) {
		if len(backD) != 0 || len(frontD) != 0 {
			panic("invariant failure")
		}
		value, err := rocks.GetObject(cf, mkkey(uri))
		if err == nil && !IsDummy(value) {
			var newUri []string
			if interlaced {
				newUri = UnInterlaceURI(uri)
			}
			handle <- MakeSMFromParts(newUri, value)
		} else {
			fmt.Printf("missing object @ %v\n", uri)
		}
		wg.Done()
		return
	}
	//if the next wildcard is a star, the base case is it being omitted
	//we do extensions via recursion below. We also only query the uninterlaced
	//store here. If the parent call populated a level from a *D then the
	//resulting base case has already been evaluated

	if skipbase {
		fmt.Printf("Skipping base for uri=%v\n", uri)
	}
	if uri[nprefix] == "*" && !skipbase {
		if nprefix != len(uri)-1 {
			panic("invariant failure")
		}
		directUri := AdvancedUnInterlaceURI(uri[:nprefix], frontD, backD)
		fmt.Printf("Finished base expansion uri=%v newuri=%v frontd=%v backd=%v\n", uri, directUri, frontD, backD)
		value, err := rocks.GetObject(rocks.CFMsg, mkkey(directUri))
		if err == nil && !IsDummy(value) {
			fmt.Println("Found base case on *", directUri)
			fmt.Println("Value:", value)
			handle <- MakeSMFromParts(directUri, value)
		} else {
			fmt.Printf("missing object @ uri=%v err=%v value=%v\n", directUri, err, value)
		}
	}

	//if the next wildcard is a star, we also need to scan, expanding *D
	if uri[nprefix] == "*" {
		fmt.Println("%> star splitting at ", uri[:nprefix])
		if !interlaced {
			//No reason to have a frontD if there is no interlacing
			if len(frontD) != 0 {
				panic("invariant failure")
			}
		}
		if interlaced && nprefix%2 == 0 && len(frontD) != 0 { //even == front
			//Skip scan, we can populate from frontD
			newUri := make([]string, len(uri)+1)
			copy(newUri, uri[:nprefix])
			newUri[nprefix] = frontD[0]
			newUri[nprefix+1] = "*"
			fmt.Printf("Using frontD to populate next level\n")
			//Don't increment nprefix because frontD[0] may have been a +
			getMatchingMessage(interlaced, newUri, nprefix, frontD[1:], backD, true, handle, wg)
			return //Don't need to wg because we invoke a function that will decrement
		} else if interlaced && nprefix%2 == 1 && len(backD) != 0 { //odd == back
			//Skip scan we can populate from backD
			newUri := make([]string, len(uri)+1)
			copy(newUri, uri[:nprefix])
			newUri[nprefix] = backD[0] //backD is in reverse order so this is correct
			newUri[nprefix+1] = "*"
			fmt.Printf("Using backD to populate next level\n")
			//Don't increment nprefix because frontD[0] may have been a +
			getMatchingMessage(interlaced, newUri, nprefix, frontD, backD[1:], true, handle, wg)
			return
		}
	}
	//If we got here, we could not skip the scan by using *D
	if uri[nprefix] == "+" || uri[nprefix] == "*" {
		fmt.Println("%> splitting at ", uri[:nprefix], "in total uri", uri)
		pfx := mkchildkey(uri[:nprefix])
		it := rocks.CreateIterator(cf, pfx)
		for it.OK() {
			k := it.Key()
			fmt.Println("%> iterator gave us ", string(k[1:]))
			actualkey := unmakekey(k)
			//base case
			//prefix is fully expanded, *D's are empty
			//opted not to do this because in interlaced mode
			//sometimes frontD will appear in the back portion of
			//the path and this won't cater for that
			/*
				if nprefix == len(uri)-1 && len(frontD) == 0 && len(backD) == 0 {
					v := it.Value()
					if !IsDummy(v) {
						fmt.Printf("found base? uri=%v value=%v\n", actualkey, v)
						realuri := actualkey
						if interlaced {
							realuri = UnInterlaceURI(realuri)
						}
						handle <- MakeSMFromParts(realuri, v)
					}
				}
			*/
			var newUri []string
			if uri[nprefix] == "+" {
				newUri = make([]string, len(uri))
				copy(newUri, actualkey)
				copy(newUri[nprefix+1:], uri[nprefix+1:])
			} else {
				//new uri must include the star
				newUri = make([]string, len(uri)+1)
				copy(newUri, actualkey)
				copy(newUri[nprefix+1:], uri[nprefix:])
			}
			wg.Add(1)
			//TODO we can reduce the total threadcount by not 'go'ing here
			go getMatchingMessage(interlaced, newUri, nprefix, frontD, backD, false, handle, wg)
			it.Next()
		}
		wg.Done()
		return
	}

}
func GetMatchingMessage(uri string, handle chan SM) {
	parts := strings.Split(uri, "/")
	staridx := -1
	pluscount := 0
	for i, v := range parts {
		if v == "*" {
			staridx = i
		}
		if v == "+" {
			pluscount++
		}
	}
	if pluscount == 0 && staridx == -1 {
		m, ok := GetExactMessage(uri)
		if ok {
			handle <- MakeSMFromParts(parts, m)
		}
		close(handle)
		return
	}

	if staridx == -1 {
		wg := &sync.WaitGroup{}
		wg.Add(1)
		getMatchingMessage(false, parts, 0, nil, nil, false, handle, wg)
		wg.Wait()
		close(handle)
		return
	}

	pfxlen := staridx
	sfxlen := len(parts) - staridx - 1
	fmt.Printf("uri=%v pfxlen=%v sfxlen=%v\n", parts, pfxlen, sfxlen)
	//I want to test interlaced, so prefer it
	{
		partslen := pfxlen
		if sfxlen < partslen {
			partslen = sfxlen
		}
		common := partslen
		partslen *= 2
		fmt.Println("Using interlaced find")
		uri := InterlaceURI(parts)[:partslen+1]
		uri[partslen] = "*"
		frontD := make([]string, pfxlen-common)
		backD := make([]string, sfxlen-common)
		fmt.Printf("common=%v lfrontd=%v lbackd=%v\n", common, len(frontD), len(backD))
		for i := 0; i < len(frontD); i++ {
			frontD[i] = parts[common+i]
		}
		for i := 0; i < len(backD); i++ {
			backD[i] = parts[staridx+1+i]
		}
		fmt.Printf("Generated URI uri=%v frontD=%v backD=%v\n", uri, frontD, backD)
		wg := &sync.WaitGroup{}
		wg.Add(1)
		getMatchingMessage(true, uri, 0, frontD, backD, false, handle, wg)
		wg.Wait()
		close(handle)
	}
	//aight so first determine what kind of uri we are
	// -no wildcard: defer to get exact
	// -better for normal-find
	// -better for interlaced-find
	//for now the heuristic is if the length disparity is > suffix length
	//use normal find, else use interlaced find
	/*
		delta := len(parts)/2 - staridx
		if delta < 0 {
			delta = -delta
		}
		if delta > len(parts)-staridx {
			//Rather just do straight up
			fmt.Println("Using left side find")
			wg := &sync.WaitGroup{}
			wg.Add(1)
			getMatchingMessage(false, parts, 0, handle, wg)
			wg.Wait()
			close(handle)
			return
		} else {
			//Interlace
			fmt.Println("Using interlaced find")
			wg := &sync.WaitGroup{}
			wg.Add(1)
			getMatchingMessage(true, InterlaceURI(parts), 0, handle, wg)
			wg.Wait()
			close(handle)
			return
		}
	*/
}

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

package store

//This module stores and retrieves DOTs, Entities and DChains. For now its
//a passthru to the database.
//Note that these parameters must be clean at this stage of the program. The
//topics must be well formed, and the messages must be syntactically valid
//otherwise we will panic when extracting them from the DB

import (
	"strings"
	"sync"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/internal/db"
	dbi "github.com/immesys/bw2/internal/level"
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

func Initialize(dbname string) {
	dbi.RawInitialize(dbname)
}

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
	dbi.PutObject(db.CFDot, v.GetHash(), value)
}

//RetreiveDOT gets a DOT from the DB
func GetDOT(hash []byte) (*objects.DOT, bool) {
	value, err := dbi.GetObject(db.CFDot, hash)
	if err == db.ErrObjNotFound {
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
	dbi.PutObject(db.CFDChain, v.GetChainHash(), value)
}

func GetDChain(hash []byte) (*objects.DChain, bool) {
	value, err := dbi.GetObject(db.CFDChain, hash)
	if err == db.ErrObjNotFound {
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

func ExistsDChain(hash []byte) bool {
	return dbi.Exists(db.CFDChain, hash)
}

func ExistsDOT(hash []byte) bool {
	return dbi.Exists(db.CFDot, hash)
}

func ExistsEntity(vk []byte) bool {
	return dbi.Exists(db.CFEntity, vk)
}

func PutEntity(v *objects.Entity) {
	//We assume all Entities in the DB are valid, so we should make sure it has
	//been checked. This is practically a noop if it has already been checked
	if !v.SigValid() {
		return
	}
	dbi.PutObject(db.CFEntity, v.GetVK(), v.GetContent())
}

func GetEntity(vk []byte) (*objects.Entity, bool) {
	value, err := dbi.GetObject(db.CFEntity, vk)
	if err == db.ErrObjNotFound {
		return nil, false
	}
	rentity, err := objects.NewEntity(objects.ROEntity, value)
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
	smrgs := strings.Join(mrg, "/")
	smrg := make([]byte, len(smrgs)+1)
	copy(smrg[1:], []byte(smrgs))
	smrg[0] = byte(len(mrg))
	dbi.PutObject(db.CFMsgI, smrg, payload)
	dbi.PutObject(db.CFMsg, tb, payload)

	//Put parents
	for i := len(ts) - 1; i > 0; i-- {
		pstrs := []byte(strings.Join(ts[0:i], "/"))
		pstr := make([]byte, len(pstrs)+1)
		pstr[0] = byte(i)
		copy(pstr[1:], pstrs)
		if !dbi.Exists(db.CFMsg, pstr) {
			dbi.PutObject(db.CFMsg, pstr, []byte{0})
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
		if !dbi.Exists(db.CFMsgI, pstr) {
			dbi.PutObject(db.CFMsgI, pstr, []byte{0})
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
	value, err := dbi.GetObject(db.CFMsg, key)
	if err != nil || IsDummy(value) {
		return nil, false
	}
	return value, true
}

type SM struct {
	URI  string
	Body []byte
}

func MakeSMFromParts(uriparts []string, body []byte) SM {
	return SM{URI: strings.Join(uriparts, "/"),
		Body: body,
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
	//Make CF
	cf := db.CFMsg
	if interlaced {
		cf = db.CFMsgI
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
		value, err := dbi.GetObject(cf, mkkey(uri))
		if err == nil && !IsDummy(value) {
			var newUri []string
			if interlaced {
				newUri = UnInterlaceURI(uri)
			}
			handle <- MakeSMFromParts(newUri, value)
		}
		wg.Done()
		return
	}
	//if the next wildcard is a star, the base case is it being omitted
	//we do extensions via recursion below. We also only query the uninterlaced
	//store here. If the parent call populated a level from a *D then the
	//resulting base case has already been evaluated

	if uri[nprefix] == "*" && !skipbase {
		if nprefix != len(uri)-1 {
			panic("invariant failure")
		}
		var directUri []string
		if interlaced {
			directUri = AdvancedUnInterlaceURI(uri[:nprefix], frontD, backD)
		} else {
			directUri = make([]string, len(uri)+len(backD)-1)
			copy(directUri, uri[:nprefix])
			idx := nprefix
			for i := len(backD) - 1; i >= 0; i-- {
				directUri[idx] = backD[i]
				idx++
			}
		}
		value, err := dbi.GetObject(db.CFMsg, mkkey(directUri))
		if err == nil && !IsDummy(value) {
			handle <- MakeSMFromParts(directUri, value)
		}
	}

	//if the next wildcard is a star, we also need to scan, expanding *D
	if uri[nprefix] == "*" {
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
			//Don't increment nprefix because frontD[0] may have been a +
			getMatchingMessage(interlaced, newUri, nprefix, frontD[1:], backD, true, handle, wg)
			return //Don't need to wg because we invoke a function that will decrement
		} else if interlaced && nprefix%2 == 1 && len(backD) != 0 { //odd == back
			//Skip scan we can populate from backD
			newUri := make([]string, len(uri)+1)
			copy(newUri, uri[:nprefix])
			newUri[nprefix] = backD[0] //backD is in reverse order so this is correct
			newUri[nprefix+1] = "*"
			//Don't increment nprefix because frontD[0] may have been a +
			getMatchingMessage(interlaced, newUri, nprefix, frontD, backD[1:], true, handle, wg)
			return
		}
	}
	//If we got here, we could not skip the scan by using *D
	if uri[nprefix] == "+" || uri[nprefix] == "*" {
		pfx := mkchildkey(uri[:nprefix])
		it := dbi.CreateIterator(cf, pfx)
		for it.OK() {
			k := it.Key()
			actualkey := unmakekey(k)
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
		it.Release()
		wg.Done()
		return
	}
}
func ListChildren(uri string, handle chan string) {
	parts := strings.Split(uri, "/")
	ckey := mkchildkey(parts)
	it := dbi.CreateIterator(db.CFMsg, ckey)
	for it.OK() {
		k := it.Key()
		handle <- string(k[1:])
		it.Next()
	}
	it.Release()
	close(handle)
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
	if pfxlen-sfxlen > sfxlen { //Prefix is much longer than suffix, use leftscan
		uri := parts[:pfxlen+1]
		frontD := []string{}
		backD := make([]string, sfxlen)
		for i := 0; i < sfxlen; i++ {
			backD[i] = parts[len(parts)-1-i]
		}
		wg := &sync.WaitGroup{}
		wg.Add(1)
		getMatchingMessage(false, uri, 0, frontD, backD, false, handle, wg)
		wg.Wait()
		close(handle)
	} else {
		partslen := pfxlen
		if sfxlen < partslen {
			partslen = sfxlen
		}
		common := partslen
		partslen *= 2
		uri := InterlaceURI(parts)[:partslen+1]
		uri[partslen] = "*"
		frontD := make([]string, pfxlen-common)
		backD := make([]string, sfxlen-common)
		for i := 0; i < len(frontD); i++ {
			frontD[i] = parts[common+i]
		}
		for i := 0; i < len(backD); i++ {
			backD[i] = parts[len(parts)-1-i-common]
		}
		wg := &sync.WaitGroup{}
		wg.Add(1)
		getMatchingMessage(true, uri, 0, frontD, backD, false, handle, wg)
		wg.Wait()
		close(handle)
	}
}

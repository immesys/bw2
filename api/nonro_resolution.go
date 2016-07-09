package api

import (
	"bytes"
	"encoding/hex"
	"strings"
	"unicode/utf8"

	"github.com/immesys/bw2/bc"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util/bwe"
)

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

package bc

import (
	"strings"

	"github.com/immesys/bw2bc/common"
)

const zerohex = "0000000000000000000000000000000000000000000000000000000000000000"

type UFI [32]byte
type Bytes32 [32]byte
type Address common.Address

//Convert a byte slice to a bytes32. Panic if the slice
//is too big
func SliceToBytes32(s []byte) Bytes32 {
	if len(s) > 32 {
		panic("Byte slice too long for bytes32")
	}
	rv := Bytes32{}
	copy(rv[:], s)
	return rv
}

//Get a (unprefixed) hex string
func (b32 *Bytes32) Hex() string {
	return common.Bytes2Hex(b32[:])
}

func (b32 *Bytes32) Zero() bool {
	return *b32 == Bytes32{}
}

func (a *Address) Hex() string {
	return common.Bytes2Hex(a[:])
}

func (u *UFI) Address() Address {
	rv := Address{}
	copy(rv[:], u[:20])
	return rv
}

//Convert a (possibly 0x prefixed) hex string to bytes32
//padding with zeroes on the right
func HexToBytes32(hex string) Bytes32 {
	if strings.HasPrefix(hex, "0x") {
		hex = hex[2:]
	}
	if len(hex) > 64 {
		panic("Hex string too long for bytes32")
	}
	if len(hex) < 64 {
		hex = hex + zerohex[len(hex):]
	}
	return Bytes32(common.HexToHash(hex))
}

//Convert a (possibly 0x prefixed) hex string to bytes32
//padding with zeroes on the right
func HexToAddress(hex string) Address {
	if strings.HasPrefix(hex, "0x") {
		hex = hex[2:]
	}
	if len(hex) > 40 {
		panic("Hex string too long for address")
	}
	if len(hex) < 40 {
		hex = hex + zerohex[len(hex):40]
	}
	return Address(common.HexToAddress(hex))
}

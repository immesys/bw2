package bn256

import (
	"math/big"
)

import "C"
import "unsafe"

type convertContext struct {
	vPower     *big.Int
	tmp        *big.Int
	acc        *big.Int
	doubles    [12]C.double
	doublesFP2 [24]C.double
}

func newConvertContext() *convertContext {
	return &convertContext{
		vPower: new(big.Int),
		tmp:    new(big.Int),
		acc:    new(big.Int),
	}
}

// doublesToInt sets out to a value decoded from 12 doubles in dclxvi's format.
// dclxvi stores values as described in [1], section 4.1.
func (c *convertContext) doublesToInt(out *big.Int, limbsIn *C.double) *big.Int {
	limbs := (*[12]C.double)(unsafe.Pointer(limbsIn))
	out.SetInt64(int64(limbs[0]))

	c.vPower.Set(v)
	c.tmp.SetInt64(int64(limbs[1]) * 6)
	c.tmp.Mul(c.tmp, c.vPower)
	out.Add(out, c.tmp)

	i := 2
	for factor := int64(6); factor <= 36; factor *= 6 {
		for j := 0; j < 5; j++ {
			c.vPower.Mul(c.vPower, v)
			c.tmp.SetInt64(int64(limbs[i]) * factor)
			c.tmp.Mul(c.tmp, c.vPower)
			out.Add(out, c.tmp)
			i++
		}
	}

	out.Mod(out, p)

	return out
}

// doublesFP2ToInt set out to a value decoded from 24 doubles in dclxvi's F(p²)
// format. dclxvi stores these values as pairs of the scalars where those
// scalars are in the form described in [1], section 4.1. The words of the two
// values are interleaved and phase (which must be either 0 or 1) determines
// which of the two values is decoded.
func (c *convertContext) doublesFP2ToInt(out *big.Int, limbsIn *C.double, phase int) *big.Int {
	limbs2 := (*[24]C.double)(unsafe.Pointer(limbsIn))
	var limbs [12]C.double

	for i := 0; i < 12; i++ {
		limbs[i] = limbs2[2*i+phase]
	}
	return c.doublesToInt(out, &limbs[0])
}

const numBytes = 32

var bigSix = big.NewInt(6)

func (c *convertContext) doublesToBytes(out []byte, v *C.double) {
	c.doublesToInt(c.acc, v)
	bytes := c.acc.Bytes()
	copy(out[numBytes-len(bytes):], bytes)
}

func (c *convertContext) doublesFP2ToBytes(out []byte, v2In *C.double) {
	c.doublesFP2ToInt(c.acc, v2In, 1)
	bytes := c.acc.Bytes()
	copy(out[numBytes-len(bytes):], bytes)

	c.doublesFP2ToInt(c.acc, v2In, 0)
	bytes = c.acc.Bytes()
	copy(out[numBytes*2-len(bytes):], bytes)
}

// bytesToDoubles converts a binary, big-endian number into 12 doubles that are
// in dclxvi's scalar format.
func (c *convertContext) bytesToDoubles(in []byte) {
	c.acc.SetBytes(in)

	c.vPower.Mul(bigSix, v)
	c.acc.DivMod(c.acc, c.vPower, c.tmp)
	c.doubles[0] = C.double(c.tmp.Int64())

	for i := 1; i < 6; i++ {
		c.acc.DivMod(c.acc, v, c.tmp)
		c.doubles[i] = C.double(c.tmp.Int64())
	}
	c.acc.DivMod(c.acc, c.vPower, c.tmp)
	c.doubles[6] = C.double(c.tmp.Int64())
	for i := 7; i < 11; i++ {
		c.acc.DivMod(c.acc, v, c.tmp)
		c.doubles[i] = C.double(c.tmp.Int64())
	}
	c.doubles[11] = C.double(c.acc.Int64())
}

// bytesToDoublesFP2 converts a pair of binary, big-endian values into 24
// doubles that are in dclxvi's F(p²) format.
func (c *convertContext) bytesToDoublesFP2(in []byte) {
	c.bytesToDoubles(in[:numBytes])
	for i := 0; i < 12; i++ {
		c.doublesFP2[2*i+1] = c.doubles[i]
	}
	c.bytesToDoubles(in[numBytes:])
	for i := 0; i < 12; i++ {
		c.doublesFP2[2*i] = c.doubles[i]
	}
}

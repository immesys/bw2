/*
Package bn256 is an optimized implementation of BN-256 for amd64.

It should be about 10x faster than the pure-Go version when run on an amd64
based system. It wraps a patched version of
http://cryptojedi.org/crypto/#dclxvi.

See the original package for documentation.

[1] http://cryptojedi.org/papers/dclxvi-20100714.pdf
*/
package bn256 // import "vuvuzela.io/crypto/bn256"

import (
	"crypto/rand"
	"fmt"
	"io"
	"math/big"
	"strings"
	"unsafe"
)

// #cgo CFLAGS: -std=c99 -O3 -fomit-frame-pointer -DQHASM
// #cgo LDFLAGS: -lm
/*
#include "optate.h"
*/
import "C"

var v = new(big.Int).SetInt64(1868033)

func bigFromBase10(s string) *big.Int {
	n, _ := new(big.Int).SetString(s, 10)
	return n
}

// p is a prime over which we form a basic field: 36u⁴+36u³+24u²+6u+1.
var p = bigFromBase10("65000549695646603732796438742359905742825358107623003571877145026864184071783")

// Order is the number of elements in both G₁ and G₂: 36u⁴+36u³+18u²+6u+1.
var Order = bigFromBase10("65000549695646603732796438742359905742570406053903786389881062969044166799969")

type G1 struct {
	p *curvePoint
}

func (e *G1) Set(a *G1) *G1 {
	if e.p == nil {
		e.p = new(curvePoint)
	}
	e.p.Set(a.p)
	return e
}

func (e *G1) Add(a, b *G1) *G1 {
	if e.p == nil {
		e.p = new(curvePoint)
	}
	e.p.Add(a.p, b.p)
	return e
}

func (e *G1) Neg(a *G1) {
	if e.p == nil {
		e.p = new(curvePoint)
	}
	e.p.Neg(a.p)
}

func (e *G1) ScalarMult(base *G1, k *big.Int) *G1 {
	if e.p == nil {
		e.p = new(curvePoint)
	}
	e.p.Mul(base.p, k)
	return e
}

func (e *G1) ScalarBaseMult(k *big.Int) *G1 {
	if e.p == nil {
		e.p = new(curvePoint)
	}
	e.p.Mul(curveGen, k)
	return e
}

func (e *G1) FromX(x *big.Int) (*G1, bool) {
	xxx := new(big.Int).Mul(x, x)
	xxx.Mul(xxx, x)
	t := new(big.Int).Add(xxx, curveB)

	y := new(big.Int).ModSqrt(t, p)
	if y != nil {
		e.p = new(curvePoint).SetXY(new(fpe).SetInt(x), new(fpe).SetInt(y))
		return e, true
	}
	return e, false
}

func (e *G1) GetXY() (*big.Int, *big.Int) {
	x, y := e.p.GetXY()
	return x.Int(), y.Int()
}

func (e *G1) Marshal() []byte {
	return e.p.Marshal()
}

func (e *G1) Unmarshal(m []byte) (*G1, bool) {
	if e.p == nil {
		e.p = new(curvePoint)
	}
	_, ok := e.p.Unmarshal(m)
	return e, ok
}

func (e *G1) String() string {
	x, y := e.p.GetXY()
	return "bn256.G1(" + x.Int().String() + ", " + y.Int().String() + ")"
}

func (e *G1) HashToPoint(m []byte) *G1 {
	if e.p == nil {
		e.p = new(curvePoint)
	}

	x, y := hashToCurvePoint(m)
	xp := new(fpe).SetInt(x)
	yp := new(fpe).SetInt(y)
	e.p.SetXY(xp, yp)
	return e
}

type G2 struct {
	p *twistPoint
}

func (e *G2) Set(a *G2) *G2 {
	if e.p == nil {
		e.p = new(twistPoint)
	}
	e.p.Set(a.p)
	return e
}

func (e *G2) Add(a, b *G2) *G2 {
	if e.p == nil {
		e.p = new(twistPoint)
	}
	e.p.Add(a.p, b.p)
	return e
}

func (e *G2) Neg(a *G2) {
	if e.p == nil {
		e.p = new(twistPoint)
	}
	e.p.Neg(a.p)
}

func (e *G2) ScalarMult(base *G2, k *big.Int) *G2 {
	if e.p == nil {
		e.p = new(twistPoint)
	}
	e.p.MulSubgroup(base.p, k)
	return e
}

func (e *G2) ScalarBaseMult(k *big.Int) *G2 {
	if e.p == nil {
		e.p = new(twistPoint)
	}
	e.p.MulSubgroup(twistGen, k)
	return e
}

func (e *G2) Marshal() []byte {
	return e.p.Marshal()
}

func (e *G2) Unmarshal(m []byte) (*G2, bool) {
	if e.p == nil {
		e.p = new(twistPoint)
	}
	_, ok := e.p.Unmarshal(m)
	return e, ok
}

func (e *G2) String() string {
	x, y := e.p.GetXY()
	xx, xy := x.GetXY()
	yx, yy := y.GetXY()
	return "bn256.G2((" + xx.String() + ", " + xy.String() + "), (" + yx.String() + ", " + yy.String() + "))"
}

func (e *G2) HashToPoint(m []byte) *G2 {
	e.p = hashToTwistSubgroup(m)
	return e
}

type GT struct {
	p *fp12e
}

func Pair(g1 *G1, g2 *G2) *GT {
	g1p := new(curvePoint).Set(g1.p)
	g1p.MakeAffine()
	g2p := new(twistPoint).Set(g2.p)
	g2p.MakeAffine()

	p := new(fp12e)
	C.optate(
		(*C.struct_fp12e_struct)(p),
		(*C.struct_twistpoint_fp2_struct)(g2p),
		(*C.struct_curvepoint_fp_struct)(g1p),
	)
	return &GT{p}
}

func (e *GT) Add(a, b *GT) *GT {
	if e.p == nil {
		e.p = new(fp12e)
	}
	e.p.Mul(a.p, b.p)
	return e
}

func (e *GT) Neg(a *GT) *GT {
	if e.p == nil {
		e.p = new(fp12e)
	}
	e.p.Invert(a.p)
	return e
}

func (e *GT) ScalarMult(base *GT, k *big.Int) *GT {
	if e.p == nil {
		e.p = new(fp12e)
	}
	e.p.Exp(base.p, k)
	return e
}

func (e *GT) Marshal() []byte {
	return e.p.Marshal()
}

func (e *GT) Unmarshal(m []byte) (*GT, bool) {
	if e.p == nil {
		e.p = new(fp12e)
	}
	_, ok := e.p.Unmarshal(m)
	return e, ok
}

func (e *GT) String() string {
	strs := make([]string, 12)
	gs := e.p.GetFp2e()
	for i, g := range gs {
		x, y := g.GetXY()
		strs[2*i] = x.String()
		strs[2*i+1] = y.String()
	}
	return "GF12(" + strings.Join(strs, ",") + ")"
}

// RandomG1 returns x and g₁ˣ where x is a random, non-zero number read from r.
func RandomG1(r io.Reader) (*big.Int, *G1, error) {
	var k *big.Int
	var err error

	for {
		k, err = rand.Int(r, Order)
		if err != nil {
			return nil, nil, err
		}
		if k.Sign() > 0 {
			break
		}
	}

	return k, new(G1).ScalarBaseMult(k), nil
}

// RandomG2 returns x and g₂ˣ where x is a random, non-zero number read from r.
func RandomG2(r io.Reader) (*big.Int, *G2, error) {
	var k *big.Int
	var err error

	for {
		k, err = rand.Int(r, Order)
		if err != nil {
			return nil, nil, err
		}
		if k.Sign() > 0 {
			break
		}
	}

	return k, new(G2).ScalarBaseMult(k), nil
}

func bigToWords(kIn *big.Int, bound *big.Int) *[4]uint64 {
	k := new(big.Int)
	if kIn.Sign() < 0 || kIn.Cmp(bound) >= 0 {
		k.Mod(kIn, bound)
	} else {
		k.Set(kIn)
	}
	if k.BitLen() > 256 {
		panic(fmt.Sprintf("scalar is too large (%d bits)", k.BitLen()))
	}

	words := new([4]uint64)
	for i := range words {
		words[i] = k.Uint64()
		k.Rsh(k, 64)
	}
	return words
}

// replaces powerToWords
func bigToScalar(kIn *big.Int, bound *big.Int) *C.ulonglong {
	words := bigToWords(kIn, bound)
	return (*C.ulonglong)(unsafe.Pointer(&words[0]))
}

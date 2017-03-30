// Copyright 2016 The Alpenhorn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package bn256

import (
	"crypto/sha256"
	"math/big"
)

var curveB = new(big.Int).SetInt64(3)
var twistB *fp2e
var twistCofactor *big.Int

func init() {
	twistB = new(fp2e).SetXY(
		bigFromBase10("6500054969564660373279643874235990574282535810762300357187714502686418407178"),
		bigFromBase10("45500384786952622612957507119651934019977750675336102500314001518804928850249"),
	)

	twistCofactor = new(big.Int).Mul(big.NewInt(2), p)
	twistCofactor.Sub(twistCofactor, Order)
}

// Hash m into a curve point.
// Based on the try-and-increment method (see hashToTwistPoint).
// NOTE: This is prone to timing attacks.
// TODO: pick positive or negative square root
// TODO: should we hash the counter at every step?
func hashToCurvePoint(m []byte) (*big.Int, *big.Int) {
	one := big.NewInt(1)

	h := sha256.Sum256(m)
	x := new(big.Int).SetBytes(h[:])
	x.Mod(x, p)

	for {
		xxx := new(big.Int).Mul(x, x)
		xxx.Mul(xxx, x)
		t := new(big.Int).Add(xxx, curveB)

		y := new(big.Int).ModSqrt(t, p)
		if y != nil {
			return x, y
		}

		x.Add(x, one)
	}
}

func hashToTwistSubgroup(m []byte) *twistPoint {
	// pt is in E'(F_{p^2}). We must map it into the n-torsion subgroup
	// E'(F_{p^2})[n].  We can do this by multiplying by the cofactor:
	// cofactor = #E'(F_{p^2}) / n  where  #E'(F_{p^2}) = n(2p - n).
	// Order of the twist curve: https://eprint.iacr.org/2005/133.pdf
	pt := hashToTwistPoint(m)

	// TODO: there is a much faster way to multiply by the cofactor:
	// https://eprint.iacr.org/2008/530.pdf
	pt.Mul(pt, twistCofactor)
	pt.MakeAffine()
	return pt
}

// Hash m into a twist point.
// Based on the try-and-increment method:
// https://www.normalesup.org/~tibouchi/papers/bnhash-scis.pdf
// https://eprint.iacr.org/2009/340.pdf
//
// NOTE: This is prone to timing attacks.
// TODO: pick positive or negative square root
// TODO: should we hash the counter at every step?
func hashToTwistPoint(m []byte) *twistPoint {
	one := new(fp2e).SetOne()
	hxx := sha256.Sum256(append(m, 0))
	hxy := sha256.Sum256(append(m, 1))
	xx := new(big.Int).SetBytes(hxx[:])
	xy := new(big.Int).SetBytes(hxy[:])

	x := new(fp2e).SetXY(xx, xy)

	for {
		xxx := new(fp2e).Square(x)
		xxx.Mul(xxx, x)

		t := new(fp2e).Add(xxx, twistB)
		y := new(fp2e).Sqrt(t)
		if y != nil {
			pt := new(twistPoint).SetXY(x, y)
			pt.MakeAffine()
			return pt
		}

		x.Add(x, one)
	}
}

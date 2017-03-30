// Copyright 2016 David Lazar. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package bn256ref

import (
	"crypto/sha256"
	"math/big"
)

var (
	bigZero  = big.NewInt(0)
	bigOne   = big.NewInt(1)
	bigTwo   = big.NewInt(2)
	bigThree = big.NewInt(3)
	bigFour  = big.NewInt(4)
)

// Hash m into a curve point.
// Based on the try-and-increment method (see hashToTwistPoint).
// NOTE: This is prone to timing attacks.
// TODO: pick positive or negative square root
// TODO: should we hash the counter at every step?
func hashToCurvePoint(m []byte) *curvePoint {
	h := sha256.Sum256(m)
	x := new(big.Int).SetBytes(h[:])
	x.Mod(x, p)

	for {
		xxx := new(big.Int).Mul(x, x)
		xxx.Mul(xxx, x)
		t := new(big.Int).Add(xxx, curveB)

		y := new(big.Int).ModSqrt(t, p)
		if y != nil {
			return &curvePoint{x, y, big.NewInt(1), big.NewInt(1)}
		}

		x.Add(x, big.NewInt(1))
	}
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
	pool := new(bnPool)
	one := newGFp2(pool).SetOne()

	hx := sha256.Sum256(append(m, 0))
	hy := sha256.Sum256(append(m, 1))

	x := &GFp2{
		new(big.Int).SetBytes(hx[:]),
		new(big.Int).SetBytes(hy[:]),
	}
	x.Minimal()

	for {
		xxx := newGFp2(pool).Square(x, pool)
		xxx.Mul(xxx, x, pool)

		t := newGFp2(pool).Add(xxx, twistB)
		//t.Minimal()
		y := newGFp2(pool).Sqrt(t)
		if y != nil {
			pt := &twistPoint{
				x,
				y,
				&GFp2{big.NewInt(0), big.NewInt(1)},
				&GFp2{big.NewInt(0), big.NewInt(1)},
			}

			return pt
		}

		x.Add(x, one)
	}
}

func hashToTwistSubgroup(m []byte) *twistPoint {
	pool := new(bnPool)

	pt := hashToTwistPoint(m)

	// pt is in E'(F_{p^2}). We must map it into the n-torsion subgroup
	// E'(F_{p^2})[n].  We can do this by multiplying by the cofactor:
	// cofactor = #E'(F_{p^2}) / n  where  #E'(F_{p^2}) = n(2p - n).
	// Order of the twist curve: https://eprint.iacr.org/2005/133.pdf
	cofactor := new(big.Int).Mul(bigTwo, p)
	cofactor.Sub(cofactor, Order)

	// TODO: there is a much faster way to multiply by the cofactor:
	// https://eprint.iacr.org/2008/530.pdf
	ptc := newTwistPoint(pool).Mul(pt, cofactor, pool)
	ptc.MakeAffine(pool)

	return ptc
}

var gfp2NegativeOne = &GFp2{bigZero, big.NewInt(-1)}

func init() {
	gfp2NegativeOne.Minimal()
}

// Sqrt computes the square root of a in the GFp2 field (F_{p^2}).
// This is Algorithm 9 from https://eprint.iacr.org/2012/685.pdf
// Assumes p is a prime with p = 3 mod 4, and that a is Minimal.
func (e *GFp2) Sqrt(a *GFp2) *GFp2 {
	pool := new(bnPool)

	q := pool.Get().Sub(p, bigThree)
	q.Div(q, bigFour)
	a1 := newGFp2(pool).Exp(a, q, pool)
	alpha := newGFp2(pool).Mul(a1, a, pool)
	alpha.Mul(a1, alpha, pool)
	a0 := newGFp2(pool).Conjugate(alpha)
	a0.Mul(a0, alpha, pool)
	if a0.x.Cmp(gfp2NegativeOne.x) == 0 && a0.y.Cmp(gfp2NegativeOne.y) == 0 {
		return nil
	}

	x0 := newGFp2(pool).Mul(a1, a, pool)
	if alpha.x.Cmp(gfp2NegativeOne.x) == 0 && alpha.y.Cmp(gfp2NegativeOne.y) == 0 {
		i := &GFp2{bigOne, bigZero}
		e.Mul(i, x0, pool)
		return e
	} else {
		q.Sub(p, bigOne)
		q.Div(q, bigTwo)
		b := newGFp2(pool).Add(newGFp2(pool).SetOne(), alpha)
		b.Exp(b, q, pool)
		e.Mul(b, x0, pool)
		return e
	}
}

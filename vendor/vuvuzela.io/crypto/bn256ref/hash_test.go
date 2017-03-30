// Copyright 2016 David Lazar. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package bn256ref

import (
	"bytes"
	"crypto/rand"
	"math/big"
	"testing"
)

func TestHashToCurvePoint(t *testing.T) {
	m := make([]byte, 32)
	for i := 0; i < 1000; i++ {
		rand.Read(m)
		point := hashToCurvePoint(m)
		if !point.IsOnCurve() {
			t.Errorf("hashToPoint(%q) is not on curve", m)
		}

		point2 := hashToCurvePoint(m)
		if point.x.Cmp(point2.x) != 0 || point.y.Cmp(point2.y) != 0 {
			t.Error("hashToPoint is non-deterministic!")
		}
	}
}

func TestHashToTwistSubgroup(t *testing.T) {
	pool := new(bnPool)
	m := make([]byte, 32)
	for i := 0; i < 200; i++ {
		rand.Read(m)
		point := hashToTwistSubgroup(m)

		pointAffine := newTwistPoint(pool)
		pointAffine.Set(point)
		pointAffine.MakeAffine(pool)
		if !pointAffine.IsOnCurve() {
			t.Fatalf("hashToPoint(%#v)=%s is not on curve", m, point)
		}

		point2 := hashToTwistSubgroup(m)
		if point.x.x.Cmp(point2.x.x) != 0 || point.x.y.Cmp(point2.x.y) != 0 {
			t.Fatalf("hashToPoint is non-deterministic!")
		}
		if point.y.x.Cmp(point2.y.x) != 0 || point.y.y.Cmp(point2.y.y) != 0 {
			t.Fatalf("hashToPoint is non-deterministic!")
		}

		po := newTwistPoint(pool).Mul(point, Order, pool)
		if !po.IsInfinity() {
			t.Fatalf("pt * Order is not infinity:\npt=%s\npt*O=%s", point, po)
		}
	}
}

func TestHashToTwistPoint(t *testing.T) {
	twistOrder := bigFromBase10("4225071460736223789158632931970842997974944076512730449869415062641653401945858362165497788692899734927503397351735636815753116967050122103770169737948493")

	pool := new(bnPool)
	m := make([]byte, 32)
	for i := 0; i < 200; i++ {
		rand.Read(m)
		point := hashToTwistPoint(m)

		pointAffine := newTwistPoint(pool)
		pointAffine.Set(point)
		pointAffine.MakeAffine(pool)
		if !pointAffine.IsOnCurve() {
			t.Fatalf("hashToPoint(%#v)=%s is not on curve", m, point)
		}

		po := newTwistPoint(pool).Mul(point, twistOrder, pool)
		if !po.IsInfinity() {
			t.Fatalf("pt * twistOrder is not infinity:\npt=%s\npt*O=%s", point, po)
		}
	}
}

// Confirm that elements of G2 are in the n-torsion subgroup.
func TestRandomG2(t *testing.T) {
	pool := new(bnPool)
	for i := 0; i < 100; i++ {
		_, g2, _ := RandomG2(rand.Reader)
		po := newTwistPoint(pool).Mul(g2.p, Order, pool)
		if !po.IsInfinity() {
			t.Errorf("pt * Order is not infinity: %s", g2.p)
		}
	}
}

// Attempt to test lots of edge cases
func mapGFp2(f func(a *GFp2)) {
	vvs := []int64{-23, -4, -3, -2, -1, 0, 1, 2, 3, 4, 23}
	vs := make([]*big.Int, len(vvs))
	for i := range vs {
		vs[i] = big.NewInt(vvs[i])
	}
	vs = append(vs, u, p, Order)

	a := &GFp2{new(big.Int), new(big.Int)}

	for _, x := range vs {
		for _, y := range vs {
			a.x.Set(x)
			a.y.Set(y)
			a.Minimal()
			f(a)
		}
		for i := 0; i < 20; i++ {
			r, _ := rand.Int(rand.Reader, p)
			a.x.Set(x)
			a.y.Set(r)
			a.Minimal()
			f(a)
		}
	}

	for _, y := range vs {
		for i := 0; i < 20; i++ {
			r, _ := rand.Int(rand.Reader, p)
			a.x.Set(r)
			a.y.Set(y)
			a.Minimal()
			f(a)
		}
	}

	for i := 0; i < 200; i++ {
		x, _ := rand.Int(rand.Reader, p)
		y, _ := rand.Int(rand.Reader, p)
		a.x.Set(x)
		a.y.Set(y)
		a.Minimal()
		f(a)
	}

	f(xiToPMinus1Over6)
	f(xiToPMinus1Over3)
	f(xiToPMinus1Over2)
	f(xiTo2PMinus2Over3)
}

func TestGFP2Sqrt(t *testing.T) {
	pool := new(bnPool)
	mapGFp2(func(a *GFp2) {
		r := newGFp2(pool).Sqrt(a)
		if r != nil {
			b := newGFp2(pool).Square(r, pool)
			if a.x.Cmp(b.x) != 0 || a.y.Cmp(b.y) != 0 {
				t.Errorf("bad: %s", a.String())
			}
		}

		aa := newGFp2(pool).Square(a, pool)
		r = newGFp2(pool).Sqrt(aa)
		// TODO we can probably be more clever here
		if r == nil {
			t.Errorf("square root must exist for %s", aa)
		}
	})
}

func TestExpConjugate(t *testing.T) {
	pool := new(bnPool)
	mapGFp2(func(a *GFp2) {
		e := newGFp2(pool).Exp(a, p, pool)
		c := newGFp2(pool).Conjugate(a)
		e.Minimal()
		c.Minimal()
		if e.x.Cmp(c.x) != 0 || e.y.Cmp(c.y) != 0 {
			t.Fatalf("false: a=%s\ne=%s\nc=%s", a.String(), e.String(), c.String())
		}
	})
}

func BenchmarkGFP2Sqrt(b *testing.B) {
	pool := new(bnPool)
	_, g2, _ := RandomG2(rand.Reader)
	x := g2.p.x
	y := newGFp2(pool)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		y.Sqrt(x)
	}
}

func BenchmarkHashToG1(b *testing.B) {
	m := make([]byte, 32)
	rand.Read(m)
	g1 := new(G1)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		g1.HashToPoint(m)
	}
}

func BenchmarkHashToG2(b *testing.B) {
	m := make([]byte, 32)
	rand.Read(m)
	g2 := new(G2)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		g2.HashToPoint(m)
	}
}

func BenchmarkScalarBaseMultG1(b *testing.B) {
	r, _ := rand.Int(rand.Reader, Order)
	g1 := new(G1)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		g1.ScalarBaseMult(r)
	}
}

func BenchmarkScalarMultG2(b *testing.B) {
	r, _ := rand.Int(rand.Reader, Order)
	_, x, _ := RandomG2(rand.Reader)
	g2 := new(G2)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		g2.ScalarMult(x, r)
	}
}

// confirm g^k = g^(k mod Order)
func TestScalarMultModOrderG2(t *testing.T) {
	_, g, _ := RandomG2(rand.Reader)
	for i := 0; i < 100; i++ {
		m := make([]byte, i)
		rand.Read(m)
		k := new(big.Int).SetBytes(m)
		kmod := new(big.Int).Mod(k, Order)

		gk := new(G2).ScalarMult(g, k)
		gkmod := new(G2).ScalarMult(g, kmod)

		if !bytes.Equal(gk.Marshal(), gkmod.Marshal()) {
			t.Fatalf("expect gk=gkmod: g=%s  k=%s  gk=%s  gkmod=%s", g, k, gk, gkmod)
		}
	}
}

func TestMarshalInfinityG1(t *testing.T) {
	_, o, _ := RandomG1(rand.Reader)
	o.p.SetInfinity()
	bs := o.Marshal()
	oo, ok := new(G1).Unmarshal(bs)
	if !ok {
		t.Fatalf("Unmarshal failed")
	}
	if !o.p.IsInfinity() {
		t.Fatalf("no longer infinity")
	}
	if !oo.p.IsInfinity() {
		t.Fatalf("expected infinity")
	}
}

func TestMarshalInfinityG2(t *testing.T) {
	_, o, _ := RandomG2(rand.Reader)
	o.p.SetInfinity()
	bs := o.Marshal()
	oo, ok := new(G2).Unmarshal(bs)
	if !ok {
		t.Fatalf("Unmarshal failed")
	}
	if !o.p.IsInfinity() {
		t.Fatalf("no longer infinity")
	}
	if !oo.p.IsInfinity() {
		t.Fatalf("expected infinity")
	}
}

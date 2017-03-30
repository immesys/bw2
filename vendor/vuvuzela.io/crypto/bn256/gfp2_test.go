// Copyright 2016 The Alpenhorn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package bn256

import (
	"crypto/rand"
	"math/big"
	"testing"

	"vuvuzela.io/crypto/bn256ref"
)

func (e *fp2e) FromRef(er *bn256ref.GFp2) *fp2e {
	return e.SetXY(er.GetXY())
}

func (e *fp2e) Ref() *bn256ref.GFp2 {
	er := bn256ref.NewGFp2().SetXY(e.GetXY())
	return er
}

func TestConvertGFp2(t *testing.T) {
	mapGFp2(func(aR *bn256ref.GFp2) {
		a := new(fp2e).FromRef(aR)
		ref := a.Ref()
		if !ref.Eq(aR) {
			t.Fatalf("\ngot  %s\nwant %s\n", ref, aR)
		}
	})
}

func TestExpGFp2(t *testing.T) {
	pow := new(big.Int).Sub(p, big.NewInt(3))
	pow.Div(pow, big.NewInt(4))
	mapGFp2(func(aR *bn256ref.GFp2) {
		a := new(fp2e).FromRef(aR)
		eR := bn256ref.NewGFp2().Exp(aR, pow, nil)
		e := new(fp2e).Exp(a, pow)
		if !eR.Eq(e.Ref()) {
			t.Fatalf("\ngot  %s\nwant %s\n", e.Ref(), eR)
		}
	})
}

// Copied from bn256ref:
// Attempt to test lots of edge cases
func mapGFp2(f func(a *bn256ref.GFp2)) {
	vvs := []int64{-23, -4, -3, -2, -1, 0, 1, 2, 3, 4, 23}
	vs := make([]*big.Int, len(vvs))
	for i := range vs {
		vs[i] = big.NewInt(vvs[i])
	}
	vs = append(vs, p, Order)

	a := bn256ref.NewGFp2()

	for _, x := range vs {
		for _, y := range vs {
			a.SetXY(x, y)
			a.Minimal()
			f(a)
		}
		for i := 0; i < 20; i++ {
			r, _ := rand.Int(rand.Reader, p)
			a.SetXY(x, r)
			a.Minimal()
			f(a)
		}
	}

	for _, y := range vs {
		for i := 0; i < 20; i++ {
			r, _ := rand.Int(rand.Reader, p)
			a.SetXY(r, y)
			a.Minimal()
			f(a)
		}
	}

	for i := 0; i < 200; i++ {
		x, _ := rand.Int(rand.Reader, p)
		y, _ := rand.Int(rand.Reader, p)
		a.SetXY(x, y)
		a.Minimal()
		f(a)
	}
}

func expectEqual(t *testing.T, a *fp2e, A *bn256ref.GFp2) {
	if a == nil && A != nil {
		t.Fatalf("got nil, want %s", A)
	}
	if a != nil && A == nil {
		t.Fatalf("want nil, got %s", a)
	}
	if a != nil && A != nil {
		if !A.Eq(a.Ref()) {
			t.Fatalf("\ngot  %s;\nwant %s\n", a.Ref(), A)
		}
	}
}

func TestSqrtGFp2(t *testing.T) {
	mapGFp2(func(A *bn256ref.GFp2) {
		R := bn256ref.NewGFp2().Sqrt(A)
		if R != nil {
			B := bn256ref.NewGFp2().Square(R, nil)
			if !B.Eq(A) {
				t.Fatalf("sqrt(%s)^2 != %s", A, B)
			}
		}

		a := new(fp2e).FromRef(A)
		r := new(fp2e).Sqrt(a)
		expectEqual(t, r, R)

		AA := bn256ref.NewGFp2().Square(A, nil)
		R = bn256ref.NewGFp2().Sqrt(AA)
		// TODO we can probably be more clever here
		if R == nil {
			t.Errorf("square root must exist for %s", AA)
		}

		aa := new(fp2e).FromRef(AA)
		r = new(fp2e).Sqrt(aa)
		expectEqual(t, r, R)
	})
}

func BenchmarkSqrtGFp2(b *testing.B) {
	x, _ := rand.Int(rand.Reader, p)
	y, _ := rand.Int(rand.Reader, p)
	A := bn256ref.NewGFp2().SetXY(x, y)
	A.Square(A, nil)
	A.Minimal()
	a := new(fp2e).FromRef(A)
	r := new(fp2e)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		r.Sqrt(a)
	}
}

func BenchmarkSqrtGFp2Ref(b *testing.B) {
	x, _ := rand.Int(rand.Reader, p)
	y, _ := rand.Int(rand.Reader, p)
	a := bn256ref.NewGFp2().SetXY(x, y)
	a.Square(a, nil)
	a.Minimal()
	r := bn256ref.NewGFp2()

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		r.Sqrt(a)
	}
}

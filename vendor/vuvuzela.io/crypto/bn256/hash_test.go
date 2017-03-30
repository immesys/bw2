// Copyright 2016 The Alpenhorn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package bn256

import (
	"bytes"
	"crypto/rand"
	"testing"

	"vuvuzela.io/crypto/bn256ref"
)

func TestHashG1Ref(t *testing.T) {
	m := make([]byte, 64)
	for i := 0; i < 1000; i++ {
		rand.Read(m)

		g := new(G1).HashToPoint(m)
		G := new(bn256ref.G1).HashToPoint(m)

		gb := g.Marshal()
		Gb := G.Marshal()

		if bytes.Compare(gb, Gb) != 0 {
			t.Fatalf("\nmsg = %x\ngot  %x\nwant %x", m, gb, Gb)
		}
	}
}

func TestHashG2Ref(t *testing.T) {
	m := make([]byte, 64)
	for i := 0; i < 200; i++ {
		rand.Read(m)

		g := new(G2).HashToPoint(m)
		G := new(bn256ref.G2).HashToPoint(m)

		gb := g.Marshal()
		Gb := G.Marshal()

		if bytes.Compare(gb, Gb) != 0 {
			t.Fatalf("\nmsg = %x\ngot  %s\nwant %s", m, g, G)
		}
	}
}

func TestMulCofactor(t *testing.T) {
	for i := 0; i < 100; i++ {
		msg := make([]byte, 64)
		rand.Read(msg)

		pt := hashToTwistPoint(msg)

		g := new(twistPoint).Mul(pt, Order)
		if g.IsInfinity() {
			t.Fatal("did not expect point to be in subgroup")
		}

		pt.Mul(pt, twistCofactor)
		g = new(twistPoint).Mul(pt, Order)
		if !g.IsInfinity() {
			t.Fatal("expecting point to be in subgroup after multiplying by cofactor")
		}
	}
}

// Copyright 2015 The Vuvuzela Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package rand

import (
	"encoding/binary"
	"math"
)

type Laplace struct {
	Mu float64
	B  float64
}

func (l Laplace) Uint32() uint32 {
	x := laplace(l.Mu, l.B)
	if x < 0 {
		return l.Uint32()
	}

	return uint32(x)
}

func laplace(mu, b float64) float64 {
	var r [8]byte
	if _, err := Read(r[:]); err != nil {
		panic(err)
	}

	x := binary.BigEndian.Uint64(r[:])
	u := float64(x)/float64(^uint64(0)) - .5

	var abs, sign float64
	if u < 0 {
		abs = -u
		sign = -1
	} else {
		abs = u
		sign = 1
	}

	return mu - b*sign*math.Log(1-2*abs)
}

// Copyright 2016 The Alpenhorn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package bn256

import (
	"math/big"
)

/*
#include "fpe.h"
*/
import "C"

type fpe C.struct_fpe_struct

func (e *fpe) SetInt(x *big.Int) *fpe {
	c := newConvertContext()
	c.bytesToDoubles(new(big.Int).Mod(x, p).Bytes())
	copy(e.v[:], c.doubles[:])
	return e
}

func (e *fpe) Int() *big.Int {
	c := newConvertContext()
	out := new(big.Int)
	c.doublesToInt(out, &e.v[0])
	return out
}

func (e *fpe) Marshal() []byte {
	out := make([]byte, numBytes)
	bytes := e.Int().Bytes()
	copy(out[numBytes-len(bytes):], bytes)
	return out
}

func (e *fpe) Unmarshal(m []byte) (*fpe, bool) {
	if len(m) != numBytes {
		return nil, false
	}
	c := newConvertContext()
	c.bytesToDoubles(m)
	copy(e.v[:], c.doubles[:])

	return e, true
}

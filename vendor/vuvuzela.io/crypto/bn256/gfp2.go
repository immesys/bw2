// Copyright 2016 The Alpenhorn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package bn256

import (
	"math/big"
)

/*
#include "fp2e.h"
*/
import "C"
import "unsafe"

type fp2e C.struct_fp2e_struct

func (e *fp2e) GetXY() (*big.Int, *big.Int) {
	c := newConvertContext()

	x := new(big.Int)
	y := new(big.Int)
	doubles := (*C.double)(unsafe.Pointer(&e.v))
	c.doublesFP2ToInt(x, doubles, 1)
	c.doublesFP2ToInt(y, doubles, 0)

	return x, y
}

func (e *fp2e) SetXY(x *big.Int, y *big.Int) *fp2e {
	c := newConvertContext()

	xBytes := new(big.Int).Mod(x, p).Bytes()
	yBytes := new(big.Int).Mod(y, p).Bytes()

	xyBytes := make([]byte, numBytes*2)
	copy(xyBytes[1*numBytes-len(xBytes):], xBytes)
	copy(xyBytes[2*numBytes-len(yBytes):], yBytes)

	c.bytesToDoublesFP2(xyBytes)
	copy(e.v[:], c.doublesFP2[:])

	return e
}

func (e *fp2e) SetOne() *fp2e {
	C.fp2e_setone((*C.struct_fp2e_struct)(e))
	return e
}

func (e *fp2e) IsZero() bool {
	x := C.fp2e_iszero((*C.struct_fp2e_struct)(e))
	return x > 0
}

func (e *fp2e) Add(op1 *fp2e, op2 *fp2e) *fp2e {
	C.fp2e_add((*C.struct_fp2e_struct)(e), (*C.struct_fp2e_struct)(op1), (*C.struct_fp2e_struct)(op2))
	return e
}

func (e *fp2e) Mul(op1 *fp2e, op2 *fp2e) *fp2e {
	C.fp2e_mul((*C.struct_fp2e_struct)(e), (*C.struct_fp2e_struct)(op1), (*C.struct_fp2e_struct)(op2))
	return e
}

func (e *fp2e) Square(op *fp2e) *fp2e {
	C.fp2e_square((*C.struct_fp2e_struct)(e), (*C.struct_fp2e_struct)(op))
	return e
}

func (e *fp2e) Exp(base *fp2e, pow *big.Int) *fp2e {
	scalar := bigToScalar(pow, pSquared)
	C.fp2e_exp((*C.struct_fp2e_struct)(e), (*C.struct_fp2e_struct)(base), scalar)
	return e
}

func (e *fp2e) Sqrt(op *fp2e) *fp2e {
	i := C.fp2e_sqrt((*C.struct_fp2e_struct)(e), (*C.struct_fp2e_struct)(op))
	if i == 0 {
		return nil
	} else {
		return e
	}
}

func (e *fp2e) Marshal() []byte {
	out := make([]byte, numBytes*2)
	x, y := e.GetXY()
	xBytes := x.Bytes()
	yBytes := y.Bytes()
	copy(out[1*numBytes-len(xBytes):], xBytes)
	copy(out[2*numBytes-len(yBytes):], yBytes)
	return out
}

func (e *fp2e) Unmarshal(m []byte) (*fp2e, bool) {
	if len(m) != numBytes*2 {
		return nil, false
	}
	c := newConvertContext()
	c.bytesToDoublesFP2(m)
	copy(e.v[:], c.doublesFP2[:])

	return e, true
}

// Copyright 2016 The Alpenhorn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package bn256

import (
	"math/big"
)

/*
#include "fp12e.h"
*/
import "C"

type fp12e C.struct_fp12e_struct

func (e *fp12e) GetFp2e() [6]*fp2e {
	a := (*C.struct_fp6e_struct)(&e.m_a[0])
	b := (*C.struct_fp6e_struct)(&e.m_b[0])
	return [6]*fp2e{
		(*fp2e)(&a.m_a[0]),
		(*fp2e)(&a.m_b[0]),
		(*fp2e)(&a.m_c[0]),
		(*fp2e)(&b.m_a[0]),
		(*fp2e)(&b.m_b[0]),
		(*fp2e)(&b.m_c[0]),
	}
}

func (e *fp12e) Invert(op *fp12e) *fp12e {
	C.fp12e_invert((*C.struct_fp12e_struct)(e), (*C.struct_fp12e_struct)(op))
	return e
}

func (e *fp12e) Mul(op1 *fp12e, op2 *fp12e) *fp12e {
	C.fp12e_mul((*C.struct_fp12e_struct)(e), (*C.struct_fp12e_struct)(op1), (*C.struct_fp12e_struct)(op2))
	return e
}

var pTwelve = new(big.Int).Exp(p, big.NewInt(12), nil)

func (e *fp12e) Exp(base *fp12e, pow *big.Int) *fp12e {
	scalar := bigToScalar(pow, pTwelve)
	C.fp12e_pow_vartime((*C.struct_fp12e_struct)(e), (*C.struct_fp12e_struct)(base), scalar)
	return e
}

func (e *fp12e) Marshal() []byte {
	out := make([]byte, numBytes*12)
	xs := e.GetFp2e()
	for i, x := range xs {
		b := x.Marshal()
		copy(out[i*numBytes*2:], b)
	}
	return out
}

func (e *fp12e) Unmarshal(m []byte) (*fp12e, bool) {
	if len(m) != numBytes*12 {
		return nil, false
	}

	xs := e.GetFp2e()
	for i, x := range xs {
		_, ok := x.Unmarshal(m[i*numBytes*2 : (i+1)*numBytes*2])
		if !ok {
			return nil, false
		}
	}
	return e, true
}

// Copyright 2016 The Alpenhorn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package bn256

import (
	"math/big"
)

/*
#include "curvepoint_fp.h"
#include "parameters.h"
#include "fpe.h"

void curvepoint_fp_affineset_fpe(curvepoint_fp_t rop, const fpe_t x, const fpe_t y)
{
	fpe_set(rop->m_x, x);
	fpe_set(rop->m_y, y);
	fpe_setone(rop->m_z);
	fpe_setzero(rop->m_t);
}
*/
import "C"

type curvePoint C.struct_curvepoint_fp_struct

var curveGen = (*curvePoint)(&C.bn_curvegen[0])

func (c *curvePoint) GetXY() (*fpe, *fpe) {
	p := new(curvePoint).Set(c)
	p.MakeAffine()
	return (*fpe)(&p.m_x[0]), (*fpe)(&p.m_y[0])
}

func (c *curvePoint) Set(a *curvePoint) *curvePoint {
	C.curvepoint_fp_set(
		(*C.struct_curvepoint_fp_struct)(c),
		(*C.struct_curvepoint_fp_struct)(a),
	)
	return c
}

func (c *curvePoint) SetXY(x *fpe, y *fpe) *curvePoint {
	C.curvepoint_fp_affineset_fpe(
		(*C.struct_curvepoint_fp_struct)(c),
		(*C.struct_fpe_struct)(x),
		(*C.struct_fpe_struct)(y),
	)
	return c
}

func (c *curvePoint) MakeAffine() *curvePoint {
	C.curvepoint_fp_makeaffine((*C.struct_curvepoint_fp_struct)(c))
	return c
}

func (c *curvePoint) Neg(a *curvePoint) *curvePoint {
	C.curvepoint_fp_neg(
		(*C.struct_curvepoint_fp_struct)(c),
		(*C.struct_curvepoint_fp_struct)(a),
	)
	return c
}

func (c *curvePoint) Add(a *curvePoint, b *curvePoint) *curvePoint {
	C.curvepoint_fp_add_vartime(
		(*C.struct_curvepoint_fp_struct)(c),
		(*C.struct_curvepoint_fp_struct)(a),
		(*C.struct_curvepoint_fp_struct)(b),
	)
	return c
}

func (c *curvePoint) Mul(a *curvePoint, scalar *big.Int) *curvePoint {
	C.curvepoint_fp_scalarmult_vartime(
		(*C.struct_curvepoint_fp_struct)(c),
		(*C.struct_curvepoint_fp_struct)(a),
		bigToScalar(scalar, Order),
	)
	return c
}

func (c *curvePoint) Marshal() []byte {
	out := make([]byte, numBytes*2)

	x, y := c.GetXY()
	copy(out, x.Marshal())
	copy(out[numBytes:], y.Marshal())

	return out
}

func (c *curvePoint) Unmarshal(m []byte) (*curvePoint, bool) {
	if len(m) != numBytes*2 {
		return nil, false
	}

	x, ok := new(fpe).Unmarshal(m[:numBytes])
	if !ok {
		return nil, false
	}

	y, ok := new(fpe).Unmarshal(m[numBytes:])
	if !ok {
		return nil, false
	}

	c.SetXY(x, y)

	return c, true
}

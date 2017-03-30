// Copyright 2016 The Alpenhorn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package bn256

import (
	"math/big"
)

/*
#include "twistpoint_fp2.h"
#include "parameters.h"
*/
import "C"

type twistPoint C.struct_twistpoint_fp2_struct

var twistGen = (*twistPoint)(&C.bn_twistgen[0])
var twistOrder *big.Int

func init() {
	// twistOrder = n(2p-n)
	twistOrder = new(big.Int).Mul(p, big.NewInt(2))
	twistOrder.Sub(twistOrder, Order)
	twistOrder.Mul(twistOrder, Order)
}

func (c *twistPoint) GetXY() (*fp2e, *fp2e) {
	p := new(twistPoint).Set(c)
	p.MakeAffine()
	return (*fp2e)(&p.m_x[0]), (*fp2e)(&p.m_y[0])
}

func (c *twistPoint) Set(a *twistPoint) *twistPoint {
	C.twistpoint_fp2_set(
		(*C.struct_twistpoint_fp2_struct)(c),
		(*C.struct_twistpoint_fp2_struct)(a),
	)
	return c
}

func (c *twistPoint) SetXY(x *fp2e, y *fp2e) *twistPoint {
	C.twistpoint_fp2_affineset_fp2e(
		(*C.struct_twistpoint_fp2_struct)(c),
		(*C.struct_fp2e_struct)(x),
		(*C.struct_fp2e_struct)(y),
	)
	return c
}

func (c *twistPoint) IsInfinity() bool {
	z := (*fp2e)(&c.m_z[0])
	return z.IsZero()
}

func (c *twistPoint) MakeAffine() *twistPoint {
	C.twistpoint_fp2_makeaffine((*C.struct_twistpoint_fp2_struct)(c))
	return c
}

func (c *twistPoint) Neg(a *twistPoint) *twistPoint {
	C.twistpoint_fp2_neg(
		(*C.struct_twistpoint_fp2_struct)(c),
		(*C.struct_twistpoint_fp2_struct)(a),
	)
	return c
}

func (c *twistPoint) Add(a *twistPoint, b *twistPoint) *twistPoint {
	C.twistpoint_fp2_add_vartime(
		(*C.struct_twistpoint_fp2_struct)(c),
		(*C.struct_twistpoint_fp2_struct)(a),
		(*C.struct_twistpoint_fp2_struct)(b),
	)
	return c
}

// multiply within the entire curve group of size twistOrder
func (c *twistPoint) Mul(a *twistPoint, scalar *big.Int) *twistPoint {
	C.twistpoint_fp2_scalarmult_vartime(
		(*C.struct_twistpoint_fp2_struct)(c),
		(*C.struct_twistpoint_fp2_struct)(a),
		bigToScalar(scalar, twistOrder),
	)
	return c
}

// multiply within the n-torsion subgroup of size Order
func (c *twistPoint) MulSubgroup(a *twistPoint, scalar *big.Int) *twistPoint {
	C.twistpoint_fp2_scalarmult_vartime(
		(*C.struct_twistpoint_fp2_struct)(c),
		(*C.struct_twistpoint_fp2_struct)(a),
		bigToScalar(scalar, Order),
	)
	return c
}

var pSquared = new(big.Int).Mul(p, p)

func (c *twistPoint) Marshal() []byte {
	out := make([]byte, numBytes*4)

	x, y := c.GetXY()
	copy(out, x.Marshal())
	copy(out[numBytes*2:], y.Marshal())

	return out
}

func (c *twistPoint) Unmarshal(m []byte) (*twistPoint, bool) {
	if len(m) != numBytes*4 {
		return nil, false
	}

	x, ok := new(fp2e).Unmarshal(m[:numBytes*2])
	if !ok {
		return nil, false
	}

	y, ok := new(fp2e).Unmarshal(m[numBytes*2:])
	if !ok {
		return nil, false
	}

	c.SetXY(x, y)

	return c, true
}

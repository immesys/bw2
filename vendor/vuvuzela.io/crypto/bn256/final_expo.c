/*
 * File:   dclxvi-20130329/final_expo.c
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#include "final_expo.h"
#include "fpe.h"
#include <stdio.h>

extern const scalar_t bn_u;
extern const scalar_t bn_v_scalar;
extern const unsigned long bn_u_bitsize;

static void fp12e_powv_special_square(fp12e_t rop, const fp12e_t op)
{
	fp12e_t tmp0, tmp1, tmp2;
	//XXX Implement
	fp12e_special_square_finexp(tmp0, op);
	fp12e_special_square_finexp(tmp0, tmp0);
	fp12e_special_square_finexp(tmp0, tmp0); // t0 = op^8
	fp12e_special_square_finexp(tmp1, tmp0);
	fp12e_special_square_finexp(tmp1, tmp1);
	fp12e_special_square_finexp(tmp1, tmp1); // t1 = op^64
	fp12e_conjugate(tmp2, tmp0);             // t2 = op^-8
	fp12e_mul(tmp2, tmp2, op);               // t2 = op^-7
	fp12e_mul(tmp2, tmp2, tmp1);             // tmp2 = op^57
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2); // tmp2 = op^(2^7*57) = op^7296
	fp12e_mul(tmp2, tmp2, op);               // tmp2 = op^7297
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2);
	fp12e_special_square_finexp(tmp2, tmp2); // tmp2 = op^(7297*256) = op^1868032
	fp12e_mul(rop, tmp2, op);                // rop  = op^v
}

static void fp12e_powu_special_square(fp12e_t rop, const fp12e_t op)
{
	fp12e_powv_special_square(rop, op);
	fp12e_powv_special_square(rop, rop);
	fp12e_powv_special_square(rop, rop);
}

void final_expo(fp12e_t rop)
{
	/* This all has to change to support scalar_t instead of mpz_t */
	// First part: (p^6 - 1)
	fp12e_t dummy1, dummy2, fp, fp2, fp3, fu, fu2, fu3, fu2p, fu3p, y0, y1, y2, y3, y4, y5, y6, t0, t1;
	fp12e_set(dummy1, rop);

	// This is exactly the p^6-Frobenius action:
	fp6e_neg(rop->m_a, rop->m_a);

	fp12e_invert(dummy2, dummy1);
	fp12e_mul(rop, rop, dummy2);
	// After this point, rop has norm 1, so we can use
	// special squaring and exponentiation.

	// Second part: (p^2 + 1)
	fp12e_set(dummy1, rop);
	fp12e_frobenius_p2(rop, rop);
	fp12e_mul(rop, rop, dummy1);

	/* Hard part */
	fp12e_frobenius_p(fp, rop);
	fp12e_frobenius_p2(fp2, rop);
	fp12e_frobenius_p(fp3, fp2);

	fp12e_powu_special_square(fu, rop);
	fp12e_powu_special_square(fu2, fu);
	fp12e_powu_special_square(fu3, fu2);
	fp12e_frobenius_p(y3, fu);
	fp12e_frobenius_p(fu2p, fu2);
	fp12e_frobenius_p(fu3p, fu3);
	fp12e_frobenius_p2(y2, fu2);
	fp12e_mul(y0, fp, fp2);
	fp12e_mul(y0, y0, fp3);

	fp12e_conjugate(y1, rop);

	fp12e_conjugate(y5, fu2);
	fp12e_conjugate(y3, y3);
	fp12e_mul(y4, fu, fu2p);
	fp12e_conjugate(y4, y4);

	fp12e_mul(y6, fu3, fu3p);
	fp12e_conjugate(y6, y6);

	//t0 := fp12square(y6);
	fp12e_special_square_finexp(t0, y6);
	//t0 := t0*y4;
	fp12e_mul(t0, t0, y4);
	//t0 := t0*y5;
	fp12e_mul(t0, t0, y5);
	//t1 := y3*y5;
	fp12e_mul(t1, y3, y5);
	//t1 := t1*t0;
	fp12e_mul(t1, t1, t0);
	//t0 := t0*y2;
	fp12e_mul(t0, t0, y2);
	//t1 := t1^2;
	fp12e_special_square_finexp(t1, t1);
	//t1 := t1*t0;
	fp12e_mul(t1, t1, t0);
	//t1 := t1^2;
	fp12e_special_square_finexp(t1, t1);
	//t0 := t1*y1;
	fp12e_mul(t0, t1, y1);
	//t1 := t1*y0;
	fp12e_mul(t1, t1, y0);
	//t0 := t0^2;
	fp12e_special_square_finexp(t0, t0);
	//t0 := t0*t1;
	fp12e_mul(rop, t0, t1);
}

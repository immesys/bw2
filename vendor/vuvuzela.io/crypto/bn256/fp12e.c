/*
 * File:   dclxvi-20130329/fp12e.c
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#include <assert.h>
#include <stdio.h>

#include "fp12e.h"
#include "fp6e.h"

extern const fp2e_t bn_zpminus1;
extern const fpe_t bn_zeta;

// Set fp12e_t rop to given value:
void fp12e_set(fp12e_t rop, const fp12e_t op)
{
	fp6e_set(rop->m_a, op->m_a);
	fp6e_set(rop->m_b, op->m_b);
}

// Initialize an fp12e, set to value given in two fp6es
void fp12e_set_fp6e(fp12e_t rop, const fp6e_t a, const fp6e_t b)
{
	fp6e_set(rop->m_a, a);
	fp6e_set(rop->m_b, b);
}

// Set rop to one:
void fp12e_setone(fp12e_t rop)
{
	fp6e_setzero(rop->m_a);
	fp6e_setone(rop->m_b);
}

// Set rop to zero:
void fp12e_setzero(fp12e_t rop)
{
	fp6e_setzero(rop->m_a);
	fp6e_setzero(rop->m_b);
}

// Compare for equality:
int fp12e_iseq(const fp12e_t op1, const fp12e_t op2)
{
	int ret = fp6e_iseq(op1->m_a, op2->m_a);
	ret = ret && fp6e_iseq(op1->m_b, op2->m_b);
	return ret;
}

int fp12e_isone(const fp12e_t op)
{
	int ret = fp6e_iszero(op->m_a);
	ret = ret && fp6e_isone(op->m_b);
	return ret;
}

int fp12e_iszero(const fp12e_t op)
{
	int ret = fp6e_iszero(op->m_a);
	ret = ret && fp6e_iszero(op->m_b);
	return ret;
}

void fp12e_cmov(fp12e_t rop, const fp12e_t op, int c)
{
	fp6e_cmov(rop->m_a, op->m_a, c);
	fp6e_cmov(rop->m_b, op->m_b, c);
}

// Compute conjugate over Fp6:
void fp12e_conjugate(fp12e_t rop, const fp12e_t op2)
{
	fp6e_neg(rop->m_a, op2->m_a);
	fp6e_set(rop->m_b, op2->m_b);
}

// Add two fp12e, store result in rop:
void fp12e_add(fp12e_t rop, const fp12e_t op1, const fp12e_t op2)
{
	fp6e_add(rop->m_a, op1->m_a, op2->m_a);
	fp6e_add(rop->m_b, op1->m_b, op2->m_b);
}

// Subtract op2 from op1, store result in rop:
void fp12e_sub(fp12e_t rop, const fp12e_t op1, const fp12e_t op2)
{
	fp6e_sub(rop->m_a, op1->m_a, op2->m_a);
	fp6e_sub(rop->m_b, op1->m_b, op2->m_b);
}

// Multiply two fp12e, store result in rop:
void fp12e_mul(fp12e_t rop, const fp12e_t op1, const fp12e_t op2)
{
#ifdef BENCH
	nummultp12++;
	multp12cycles -= cpucycles();
#endif

	fp6e_t tmp1, tmp2, tmp3; // Needed to store intermediary results

	fp6e_mul(tmp1, op1->m_a, op2->m_a);
	fp6e_mul(tmp3, op1->m_b, op2->m_b);

	fp6e_add(tmp2, op2->m_a, op2->m_b);
	fp6e_short_coeffred(tmp2);

	fp6e_add(rop->m_a, op1->m_a, op1->m_b);
	fp6e_short_coeffred(rop->m_a);
	fp6e_set(rop->m_b, tmp3);

	fp6e_mul(rop->m_a, rop->m_a, tmp2);
	fp6e_sub(rop->m_a, rop->m_a, tmp1);
	fp6e_sub(rop->m_a, rop->m_a, rop->m_b);
	fp6e_short_coeffred(rop->m_a);
	fp6e_multau(tmp1, tmp1);
	fp6e_add(rop->m_b, rop->m_b, tmp1);
	fp6e_short_coeffred(rop->m_b);
#ifdef BENCH
	multp12cycles += cpucycles();
#endif
}

void fp12e_mul_fp6e(fp12e_t rop, const fp12e_t op1, const fp6e_t op2)
{
	fp6e_mul(rop->m_a, op1->m_a, op2);
	fp6e_mul(rop->m_b, op1->m_b, op2);
}

// Square an fp12e, store result in rop:
void fp12e_square(fp12e_t rop, const fp12e_t op)
{
#ifdef BENCH
	numsqp12++;
	sqp12cycles -= cpucycles();
#endif
	fp6e_t tmp1, tmp2, tmp3; // Needed to store intermediary results

	fp6e_mul(tmp1, op->m_a, op->m_b);

	fp6e_add(tmp2, op->m_a, op->m_b);
	fp6e_short_coeffred(tmp2);
	fp6e_multau(tmp3, op->m_a);
	fp6e_add(rop->m_b, tmp3, op->m_b);
	fp6e_short_coeffred(rop->m_b);
	fp6e_mul(rop->m_b, rop->m_b, tmp2);

	fp6e_sub(rop->m_b, rop->m_b, tmp1);
	fp6e_multau(tmp2, tmp1);
	fp6e_sub(rop->m_b, rop->m_b, tmp2);
	fp6e_short_coeffred(rop->m_b);

	fp6e_add(rop->m_a, tmp1, tmp1);
	fp6e_short_coeffred(rop->m_a);
#ifdef BENCH
	sqp12cycles += cpucycles();
#endif
}

// Multiply an fp12e by a line function value, store result in rop:
// The line function is given by 3 fp2e elements op2, op3, op4 as
// line = (op2*tau + op3)*z + op4 = a2*z + b2.
void fp12e_mul_line(fp12e_t rop, const fp12e_t op1, const fp2e_t op2, const fp2e_t op3, const fp2e_t op4)
{
#ifdef BENCH
	nummultp12++;
	multp12cycles -= cpucycles();
#endif

	fp2e_t fp2_0, tmp;
	fp6e_t tmp1, tmp2, tmp3; // Needed to store intermediary results

	fp2e_setzero(fp2_0);                      // fp2_0 = 0
	fp6e_set_fp2e(tmp1, fp2_0, op2, op3);     // tmp1 = a2 = op2*tau + op3
	fp6e_mul_shortfp6e(tmp1, op1->m_a, tmp1); // tmp1 = a1*a2
	fp6e_mul_fp2e(tmp3, op1->m_b, op4);       // tmp3 = b1*op4 = b1*b2

	fp2e_add(tmp, op3, op4);
	fp2e_short_coeffred(tmp);
	fp6e_set_fp2e(tmp2, fp2_0, op2, tmp);   // tmp2 = a2 + b2
	fp6e_add(rop->m_a, op1->m_a, op1->m_b); // a3 = a1 + b1
	fp6e_short_coeffred(rop->m_a);

	fp6e_set(rop->m_b, tmp3); // b3 = b1*b2

	fp6e_mul_shortfp6e(rop->m_a, rop->m_a, tmp2); // a3 = (a1+b1)*(a2+b2)
	fp6e_sub(rop->m_a, rop->m_a, tmp1);
	fp6e_sub(rop->m_a, rop->m_a, rop->m_b); // a3 = a1*b2 + a2*b1
	fp6e_short_coeffred(rop->m_a);
	fp6e_multau(tmp1, tmp1);            // tmp1 = a1*a2*tau
	fp6e_add(rop->m_b, rop->m_b, tmp1); // b3 = b1*b2 + a1*a2*tau
	fp6e_short_coeffred(rop->m_b);
#ifdef BENCH
	multp12cycles += cpucycles();
#endif
}

void fp12e_pow_vartime(fp12e_t rop, const fp12e_t op, const scalar_t exp)
{
	fp12e_t dummy;
	unsigned int startbit;

	startbit = scalar_scanb(exp);
	fp12e_set(dummy, op);
	fp12e_set(rop, op);
	int i;
	for (i = startbit; i > 0; i--) {
		fp12e_square(rop, rop);
		if (scalar_getbit(exp, i - 1))
			fp12e_mul(rop, rop, dummy);
	}
}

// Implicit fp4 squaring for Granger/Scott special squaring in final expo
// fp4e_square takes two fp2e op1, op2 representing the fp4 element
// op1*z^3 + op2, writes the square to rop1, rop2 representing rop1*z^3 + rop2.
// (op1*z^3 + op2)^2 = (2*op1*op2)*z^3 + (op1^2*xi + op2^2).
void fp4e_square(fp2e_t rop1, fp2e_t rop2, const fp2e_t op1, const fp2e_t op2)
{
	fp2e_t t1, t2;

	fp2e_square(t1, op1); // t1 = op1^2
	fp2e_square(t2, op2); // t2 = op2^2

	//fp2e_mul(rop1, op1, op2);    // rop1 = op1*op2
	//fp2e_add(rop1, rop1, rop1);  // rop1 = 2*op1*op2
	fp2e_add(rop1, op1, op2);
	fp2e_short_coeffred(rop1);
	fp2e_square(rop1, rop1);
	fp2e_sub2(rop1, t1);
	fp2e_sub2(rop1, t2); // rop1 = 2*op1*op2

	fp2e_mulxi(rop2, t1); // rop2 = op1^2*xi
	fp2e_add2(rop2, t2);  // rop2 = op1^2*xi + op2^2
}

// Special squaring for use on elements in T_6(fp2) (after the
// easy part of the final exponentiation. Used in the hard part
// of the final exponentiation. Function uses formulas in
// Granger/Scott (PKC2010).
void fp12e_special_square_finexp(fp12e_t rop, const fp12e_t op)
{
	fp2e_t f00, f01, f02, f10, f11, f12;
	fp2e_t t00, t01, t02, t10, t11, t12, t;
	fp6e_t f0, f1;

	fp4e_square(t11, t00, op->m_a->m_b, op->m_b->m_c);
	fp4e_square(t12, t01, op->m_b->m_a, op->m_a->m_c);
	fp4e_square(t02, t10, op->m_a->m_a, op->m_b->m_b);

	fp2e_mulxi(t, t02);
	fp2e_set(t02, t10);
	fp2e_set(t10, t);

	fp2e_mul_scalar(f00, op->m_b->m_c, -2);
	fp2e_mul_scalar(f01, op->m_b->m_b, -2);
	fp2e_mul_scalar(f02, op->m_b->m_a, -2);
	fp2e_double(f10, op->m_a->m_c);
	fp2e_double(f11, op->m_a->m_b);
	fp2e_double(f12, op->m_a->m_a);

	fp2e_triple2(t00);
	fp2e_triple2(t01);
	fp2e_triple2(t02);
	fp2e_triple2(t10);
	fp2e_triple2(t11);
	fp2e_triple2(t12);

	fp2e_add2(f00, t00);
	fp2e_add2(f01, t01);
	fp2e_add2(f02, t02);
	fp2e_add2(f10, t10);
	fp2e_add2(f11, t11);
	fp2e_add2(f12, t12);

	fp6e_set_fp2e(f0, f02, f01, f00);
	fp6e_short_coeffred(f0);
	fp6e_set_fp2e(f1, f12, f11, f10);
	fp6e_short_coeffred(f1);
	fp12e_set_fp6e(rop, f1, f0);
}

void fp12e_invert(fp12e_t rop, const fp12e_t op)
{
#ifdef BENCH
	numinvp12++;
	invp12cycles -= cpucycles();
#endif
	fp6e_t tmp1, tmp2; // Needed to store intermediary results

	fp6e_squaredouble(tmp1, op->m_a);
	fp6e_squaredouble(tmp2, op->m_b);
	fp6e_multau(tmp1, tmp1);
	fp6e_sub(tmp1, tmp2, tmp1);
	fp6e_short_coeffred(tmp1);
	fp6e_invert(tmp1, tmp1);
	fp6e_add(tmp1, tmp1, tmp1);
	fp6e_short_coeffred(tmp1);
	fp12e_set(rop, op);
	fp6e_neg(rop->m_a, rop->m_a);
	fp12e_mul_fp6e(rop, rop, tmp1);
#ifdef BENCH
	invp12cycles += cpucycles();
#endif
}

void fp12e_frobenius_p(fp12e_t rop, const fp12e_t op)
{
	fp6e_frobenius_p(rop->m_a, op->m_a);
	fp6e_frobenius_p(rop->m_b, op->m_b);
	fp6e_mul_fp2e(rop->m_a, rop->m_a, bn_zpminus1);
}

void fp12e_frobenius_p2(fp12e_t rop, const fp12e_t op)
{
	fp6e_t t;
	fp6e_frobenius_p2(rop->m_a, op->m_a);
	fp6e_frobenius_p2(rop->m_b, op->m_b);
	fp6e_mul_fpe(t, rop->m_a, bn_zeta);
	fp6e_neg(rop->m_a, t);
}

// Print the element to stdout:
void fp12e_print(FILE *outfile, const fp12e_t op)
{
	fp6e_print(outfile, op->m_a);
	fprintf(outfile, " * Z + ");
	fp6e_print(outfile, op->m_b);
}

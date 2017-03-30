/*
 * File:   dclxvi-20130329/fp6e.c
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#include <assert.h>
#include <stdio.h>

#include "fp6e.h"

extern const fp2e_t bn_ypminus1;
extern const fp2e_t bn_ypminus1_squ;
extern const fpe_t bn_zeta;
extern const fpe_t bn_zeta2;

void fp6e_short_coeffred(fp6e_t rop)
{
	fp2e_short_coeffred(rop->m_a);
	fp2e_short_coeffred(rop->m_b);
	fp2e_short_coeffred(rop->m_c);
}

// Set fp6e_t rop to given value:
void fp6e_set(fp6e_t rop, const fp6e_t op)
{
	fp2e_set(rop->m_a, op->m_a);
	fp2e_set(rop->m_b, op->m_b);
	fp2e_set(rop->m_c, op->m_c);
}

// Initialize an fp6e, set to value given in three fp2es
void fp6e_set_fp2e(fp6e_t rop, const fp2e_t a, const fp2e_t b, const fp2e_t c)
{
	fp2e_set(rop->m_a, a);
	fp2e_set(rop->m_b, b);
	fp2e_set(rop->m_c, c);
}

// Set rop to one:
void fp6e_setone(fp6e_t rop)
{
	fp2e_setzero(rop->m_a);
	fp2e_setzero(rop->m_b);
	fp2e_setone(rop->m_c);
}

// Set rop to zero:
void fp6e_setzero(fp6e_t rop)
{
	fp2e_setzero(rop->m_a);
	fp2e_setzero(rop->m_b);
	fp2e_setzero(rop->m_c);
}

// Compare for equality:
int fp6e_iseq(const fp6e_t op1, const fp6e_t op2)
{
	int ret = fp2e_iseq(op1->m_a, op2->m_a);
	ret = ret && fp2e_iseq(op1->m_b, op2->m_b);
	ret = ret && fp2e_iseq(op1->m_c, op2->m_c);
	return ret;
}

int fp6e_isone(const fp6e_t op)
{
	int ret = fp2e_iszero(op->m_a);
	ret = ret && fp2e_iszero(op->m_b);
	ret = ret && fp2e_isone(op->m_c);
	return ret;
}

int fp6e_iszero(const fp6e_t op)
{
	int ret = fp2e_iszero(op->m_a);
	ret = ret && fp2e_iszero(op->m_b);
	ret = ret && fp2e_iszero(op->m_c);
	return ret;
}

void fp6e_cmov(fp6e_t rop, const fp6e_t op, int c)
{
	fp2e_cmov(rop->m_a, op->m_a, c);
	fp2e_cmov(rop->m_b, op->m_b, c);
	fp2e_cmov(rop->m_c, op->m_c, c);
}

// Add two fp6e, store result in rop:
void fp6e_add(fp6e_t rop, const fp6e_t op1, const fp6e_t op2)
{
	fp2e_add(rop->m_a, op1->m_a, op2->m_a);
	fp2e_add(rop->m_b, op1->m_b, op2->m_b);
	fp2e_add(rop->m_c, op1->m_c, op2->m_c);
}

// Subtract op2 from op1, store result in rop:
void fp6e_sub(fp6e_t rop, const fp6e_t op1, const fp6e_t op2)
{
	fp2e_sub(rop->m_a, op1->m_a, op2->m_a);
	fp2e_sub(rop->m_b, op1->m_b, op2->m_b);
	fp2e_sub(rop->m_c, op1->m_c, op2->m_c);
}

// Subtract op2 from op1, store result in rop:
void fp6e_neg(fp6e_t rop, const fp6e_t op)
{
	fp2e_neg(rop->m_a, op->m_a);
	fp2e_neg(rop->m_b, op->m_b);
	fp2e_neg(rop->m_c, op->m_c);
}

// Multiply two fp6e, store result in rop:
void fp6e_mul(fp6e_t rop, const fp6e_t op1, const fp6e_t op2)
{
	fp2e_t tmp1, tmp2, tmp3, tmp4, tmp5, tmp6; // Needed for intermediary values

	// See "Multiplication and Squaring in Pairing-Friendly Fields", section 4, Karatsuba method
	fp2e_mul(tmp3, op1->m_a, op2->m_a);
	fp2e_mul(tmp2, op1->m_b, op2->m_b);
	fp2e_mul(tmp1, op1->m_c, op2->m_c);

	fp2e_add(tmp4, op1->m_a, op1->m_b);
	//fp2e_short_coeffred(tmp4);
	fp2e_add(tmp5, op2->m_a, op2->m_b);
	//fp2e_short_coeffred(tmp5);
	fp2e_mul(tmp6, tmp4, tmp5);
	fp2e_sub2(tmp6, tmp2);
	//fp2e_short_coeffred(tmp6);
	fp2e_sub2(tmp6, tmp3);
	//fp2e_short_coeffred(tmp6);
	fp2e_mulxi(tmp6, tmp6);
	fp2e_add2(tmp6, tmp1);

	fp2e_add(tmp4, op1->m_b, op1->m_c);
	//fp2e_short_coeffred(tmp4);
	fp2e_add(tmp5, op2->m_b, op2->m_c);
	//fp2e_short_coeffred(tmp5);
	fp2e_mul(rop->m_b, tmp4, tmp5);
	fp2e_sub2(rop->m_b, tmp1);
	fp2e_sub2(rop->m_b, tmp2);
	//fp2e_short_coeffred(rop->m_b);
	fp2e_mulxi(tmp4, tmp3);
	fp2e_add2(rop->m_b, tmp4);
	fp2e_short_coeffred(rop->m_b);

	fp2e_add(tmp4, op1->m_a, op1->m_c);
	//fp2e_short_coeffred(tmp4);
	fp2e_add(tmp5, op2->m_a, op2->m_c);
	//fp2e_short_coeffred(tmp5);

	fp2e_set(rop->m_c, tmp6);
	fp2e_short_coeffred(rop->m_c);

	fp2e_mul(rop->m_a, tmp4, tmp5);
	fp2e_sub2(rop->m_a, tmp1);
	fp2e_add2(rop->m_a, tmp2);
	fp2e_sub2(rop->m_a, tmp3);
	fp2e_short_coeffred(rop->m_a);
}

// Compute the double of the Square of an fp6e, store result in rop, uses Chung-Hasan (CH-SQR3x in pairing-friendly fields)
void fp6e_squaredouble(fp6e_t rop, const fp6e_t op)
{
	//fp6e_mul(rop, op, op); //XXX make faster!
	fp2e_t s0, s1, s2, s3, s4, t;

	fp2e_square(s0, op->m_c);

	fp2e_add(t, op->m_a, op->m_c);

	fp2e_add(s1, t, op->m_b);
	fp2e_short_coeffred(s1);
	fp2e_square(s1, s1);

	fp2e_sub(s2, t, op->m_b);
	fp2e_short_coeffred(s2);
	fp2e_square(s2, s2);

	fp2e_mul(s3, op->m_a, op->m_b);
	fp2e_double(s3, s3);

	fp2e_square(s4, op->m_a);

	fp2e_mulxi(rop->m_c, s3);
	fp2e_add(rop->m_c, rop->m_c, s0);
	fp2e_double(rop->m_c, rop->m_c);
	fp2e_short_coeffred(rop->m_c);

	fp2e_mulxi(rop->m_b, s4);
	fp2e_sub(rop->m_b, s3, rop->m_b);
	fp2e_double(rop->m_b, rop->m_b);
	fp2e_sub(rop->m_b, s1, rop->m_b);
	fp2e_sub(rop->m_b, rop->m_b, s2);
	fp2e_short_coeffred(rop->m_b);

	fp2e_add(rop->m_a, s0, s4);
	fp2e_double(rop->m_a, rop->m_a);
	fp2e_sub(rop->m_a, s1, rop->m_a);
	fp2e_add(rop->m_a, rop->m_a, s2);
	fp2e_short_coeffred(rop->m_a);
}

// Multiply with tau:
void fp6e_multau(fp6e_t rop, const fp6e_t op)
{
	fp2e_t tmp1;
	fp2e_set(tmp1, op->m_b);
	fp2e_set(rop->m_b, op->m_c);
	fp2e_mulxi(rop->m_c, op->m_a);
	fp2e_set(rop->m_a, tmp1);
}

void fp6e_mul_fpe(fp6e_t rop, const fp6e_t op1, const fpe_t op2)
{
	fp2e_mul_fpe(rop->m_a, op1->m_a, op2);
	fp2e_mul_fpe(rop->m_b, op1->m_b, op2);
	fp2e_mul_fpe(rop->m_c, op1->m_c, op2);
}

void fp6e_mul_fp2e(fp6e_t rop, const fp6e_t op1, const fp2e_t op2)
{
	fp2e_mul(rop->m_a, op1->m_a, op2);
	fp2e_mul(rop->m_b, op1->m_b, op2);
	fp2e_mul(rop->m_c, op1->m_c, op2);
}

// Multiply an fp6e by a short fp6e, store result in rop:
// the short fp6e op2 has a2 = 0, i.e. op2 = b2*tau + c2.
void fp6e_mul_shortfp6e(fp6e_t rop, const fp6e_t op1, const fp6e_t op2)
{
	fp2e_t tmp1, tmp2, tmp3, tmp4, tmp5; // Needed for intermediary values

	fp2e_mul(tmp2, op1->m_b, op2->m_b); // tmp2 = b1*b2
	fp2e_mul(tmp1, op1->m_c, op2->m_c); // tmp1 = c1*c2

	fp2e_mul(tmp3, op1->m_a, op2->m_b); // tmp3 = a1*b2
	fp2e_mulxi(tmp3, tmp3);             // tmp3 = a1*b2*xi
	fp2e_add(tmp5, tmp3, tmp1);         // tmp5 = c1*c2 + a1*b2*xi

	fp2e_add(tmp4, op1->m_b, op1->m_c); // tmp4 = b1+c1
	                                    //fp2e_short_coeffred(tmp4);
	fp2e_add(tmp3, op2->m_b, op2->m_c); // tmp3 = b2+c2
	                                    //fp2e_short_coeffred(tmp3);
	fp2e_mul(rop->m_b, tmp4, tmp3);     // b3 = (b1+c1)*(b2+c2)
	fp2e_sub2(rop->m_b, tmp1);
	fp2e_sub2(rop->m_b, tmp2); // b3 = b1*c2 + b2*c1
	fp2e_short_coeffred(rop->m_b);

	fp2e_mul(rop->m_a, op1->m_a, op2->m_c); // a3 = a1*c2
	fp2e_add2(rop->m_a, tmp2);              // a3 = a1*c2 + b1*b2

	fp2e_set(rop->m_c, tmp5); // c3 =  c1*c2 + a1*b2*xi
}

void fp6e_invert(fp6e_t rop, const fp6e_t op)
{
	fp2e_t tmp1, tmp2, tmp3, tmp4, tmp5; // Needed to store intermediary results

	// See "Implementing cryptographic pairings"
	fp2e_square(tmp1, op->m_c);
	fp2e_mul(tmp5, op->m_a, op->m_b);
	fp2e_mulxi(tmp5, tmp5);
	fp2e_sub2(tmp1, tmp5); // A
	fp2e_short_coeffred(tmp1);

	fp2e_square(tmp2, op->m_a);
	fp2e_mulxi(tmp2, tmp2);
	fp2e_mul(tmp5, op->m_b, op->m_c);
	fp2e_sub2(tmp2, tmp5); // B
	fp2e_short_coeffred(tmp2);

	fp2e_square(tmp3, op->m_b);
	fp2e_mul(tmp5, op->m_a, op->m_c);
	fp2e_sub2(tmp3, tmp5); // C
	                       //fp2e_short_coeffred(tmp3);

	fp2e_mul(tmp4, tmp3, op->m_b);
	fp2e_mulxi(tmp4, tmp4);
	fp2e_mul(tmp5, tmp1, op->m_c);
	fp2e_add2(tmp4, tmp5);
	fp2e_mul(tmp5, tmp2, op->m_a);
	fp2e_mulxi(tmp5, tmp5);
	fp2e_add2(tmp4, tmp5); // F
	fp2e_short_coeffred(tmp4);

	fp2e_invert(tmp4, tmp4);

	fp2e_mul(rop->m_a, tmp3, tmp4);
	fp2e_mul(rop->m_b, tmp2, tmp4);
	fp2e_mul(rop->m_c, tmp1, tmp4);
}

void fp6e_frobenius_p(fp6e_t rop, const fp6e_t op)
{
	fp6e_set(rop, op);
	fp2e_conjugate(rop->m_a, rop->m_a);
	fp2e_conjugate(rop->m_b, rop->m_b);
	fp2e_conjugate(rop->m_c, rop->m_c);

	fp2e_mul(rop->m_b, rop->m_b, bn_ypminus1);
	fp2e_mul(rop->m_a, rop->m_a, bn_ypminus1_squ);
}

void fp6e_frobenius_p2(fp6e_t rop, const fp6e_t op)
{
	fp2e_set(rop->m_c, op->m_c);
	fp2e_mul_fpe(rop->m_b, op->m_b, bn_zeta2);
	fp2e_mul_fpe(rop->m_a, op->m_a, bn_zeta);
}

// Print the fp6e:
void fp6e_print(FILE *outfile, const fp6e_t op)
{
	fprintf(outfile, "[");
	fp2e_print(outfile, op->m_a);
	fprintf(outfile, " * Y^2 + ");
	fp2e_print(outfile, op->m_b);
	fprintf(outfile, " * Y + ");
	fp2e_print(outfile, op->m_c);
	fprintf(outfile, "]");
}

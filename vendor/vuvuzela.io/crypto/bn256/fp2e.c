/*
 * File:   dclxvi-20130329/fp2e.c
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#include <assert.h>
#include <math.h>
#include <stdio.h>

#include "fp2e.h"
#include "fpe.h"
#include "mul.h"
#include "scalar.h"

extern const double bn_v;
extern const double bn_v6;
extern const scalar_t bn_pminus2;

#ifdef N_OPS
unsigned long long mulfp2ctr;
unsigned long long mulfp2fpctr;
unsigned long long sqfp2ctr;
unsigned long long invfp2ctr;
unsigned long long double2fp2ctr;
unsigned long long doublefp2ctr;
unsigned long long triple2fp2ctr;
unsigned long long triplefp2ctr;
unsigned long long mul_scalarfp2ctr;
unsigned long long add2fp2ctr;
unsigned long long addfp2ctr;
unsigned long long sub2fp2ctr;
unsigned long long subfp2ctr;
unsigned long long neg2fp2ctr;
unsigned long long negfp2ctr;
unsigned long long mulxifp2ctr;
unsigned long long conjugatefp2ctr;
unsigned long long short_coeffredfp2ctr;
#endif

#ifndef QHASM
void fp2e_short_coeffred_c(fp2e_t rop)
{
#ifdef N_OPS
	short_coeffredfp2ctr++;
#endif
	mydouble carry11 = round(rop->v[22] / bn_v);
	mydouble carry11b = round(rop->v[23] / bn_v);
	rop->v[22] = remround(rop->v[22], bn_v);
	rop->v[23] = remround(rop->v[23], bn_v);
	rop->v[0] = rop->v[0] - carry11;
	rop->v[1] = rop->v[1] - carry11b;
	rop->v[6] = rop->v[6] - carry11;
	rop->v[7] = rop->v[7] - carry11b;
	rop->v[12] = rop->v[12] - 4 * carry11;
	rop->v[13] = rop->v[13] - 4 * carry11b;
	rop->v[18] = rop->v[18] - carry11;
	rop->v[19] = rop->v[19] - carry11b;

	mydouble carry1 = round(rop->v[2] / bn_v);
	mydouble carry1b = round(rop->v[3] / bn_v);
	rop->v[2] = remround(rop->v[2], bn_v);
	rop->v[3] = remround(rop->v[3], bn_v);
	rop->v[4] += carry1;
	rop->v[5] += carry1b;

	mydouble carry3 = round(rop->v[6] / bn_v);
	mydouble carry3b = round(rop->v[7] / bn_v);
	rop->v[6] = remround(rop->v[6], bn_v);
	rop->v[7] = remround(rop->v[7], bn_v);
	rop->v[8] += carry3;
	rop->v[9] += carry3b;

	mydouble carry5 = round(rop->v[10] / bn_v);
	mydouble carry5b = round(rop->v[11] / bn_v);
	rop->v[10] = remround(rop->v[10], bn_v);
	rop->v[11] = remround(rop->v[11], bn_v);
	rop->v[12] += carry5;
	rop->v[13] += carry5b;

	mydouble carry7 = round(rop->v[14] / bn_v);
	mydouble carry7b = round(rop->v[15] / bn_v);
	rop->v[14] = remround(rop->v[14], bn_v);
	rop->v[15] = remround(rop->v[15], bn_v);
	rop->v[16] += carry7;
	rop->v[17] += carry7b;

	mydouble carry9 = round(rop->v[18] / bn_v);
	mydouble carry9b = round(rop->v[19] / bn_v);
	rop->v[18] = remround(rop->v[18], bn_v);
	rop->v[19] = remround(rop->v[19], bn_v);
	rop->v[20] += carry9;
	rop->v[21] += carry9b;

	mydouble carry0 = round(rop->v[0] / bn_v6);
	mydouble carry0b = round(rop->v[1] / bn_v6);
	rop->v[0] = remround(rop->v[0], bn_v6);
	rop->v[1] = remround(rop->v[1], bn_v6);
	rop->v[2] += carry0;
	rop->v[3] += carry0b;

	mydouble carry2 = round(rop->v[4] / bn_v);
	mydouble carry2b = round(rop->v[5] / bn_v);
	rop->v[4] = remround(rop->v[4], bn_v);
	rop->v[5] = remround(rop->v[5], bn_v);
	rop->v[6] += carry2;
	rop->v[7] += carry2b;

	mydouble carry4 = round(rop->v[8] / bn_v);
	mydouble carry4b = round(rop->v[9] / bn_v);
	rop->v[8] = remround(rop->v[8], bn_v);
	rop->v[9] = remround(rop->v[9], bn_v);
	rop->v[10] += carry4;
	rop->v[11] += carry4b;

	mydouble carry6 = round(rop->v[12] / bn_v6);
	mydouble carry6b = round(rop->v[13] / bn_v6);
	rop->v[12] = remround(rop->v[12], bn_v6);
	rop->v[13] = remround(rop->v[13], bn_v6);
	rop->v[14] += carry6;
	rop->v[15] += carry6b;

	mydouble carry8 = round(rop->v[16] / bn_v);
	mydouble carry8b = round(rop->v[17] / bn_v);
	rop->v[16] = remround(rop->v[16], bn_v);
	rop->v[17] = remround(rop->v[17], bn_v);
	rop->v[18] += carry8;
	rop->v[19] += carry8b;

	mydouble carry10 = round(rop->v[20] / bn_v);
	mydouble carry10b = round(rop->v[21] / bn_v);
	rop->v[20] = remround(rop->v[20], bn_v);
	rop->v[21] = remround(rop->v[21], bn_v);
	rop->v[22] += carry10;
	rop->v[23] += carry10b;
}
#endif

void fp2e_to_2fpe(fpe_t ropa, fpe_t ropb, const fp2e_t op)
{
	int i;
	for (i = 0; i < 12; i++) {
		ropb->v[i] = op->v[2 * i];
		ropa->v[i] = op->v[2 * i + 1];
	}
}

void _2fpe_to_fp2e(fp2e_t rop, const fpe_t opa, const fpe_t opb)
{
	int i;
	for (i = 0; i < 12; i++) {
		rop->v[2 * i] = opb->v[i];
		rop->v[2 * i + 1] = opa->v[i];
	}
}

// Set fp2e_t rop to given value:
void fp2e_set(fp2e_t rop, const fp2e_t op)
{
	int i;
	for (i = 0; i < 24; i++)
		rop->v[i] = op->v[i];
}

/* Communicate the fact that the fp2e is reduced (and that we don't know anything more about it) */
void fp2e_isreduced(fp2e_t rop)
{
	setmax(rop->v[0], (long)bn_v6 / 2);
	setmax(rop->v[1], (long)bn_v6 / 2);
	setmax(rop->v[12], (long)bn_v6 / 2);
	setmax(rop->v[13], (long)bn_v6 / 2);

	setmax(rop->v[2], (long)bn_v / 2);
	setmax(rop->v[3], (long)bn_v / 2);
	setmax(rop->v[6], (long)bn_v / 2);
	setmax(rop->v[7], (long)bn_v / 2);
	setmax(rop->v[8], (long)bn_v / 2);
	setmax(rop->v[9], (long)bn_v / 2);
	setmax(rop->v[14], (long)bn_v / 2);
	setmax(rop->v[15], (long)bn_v / 2);
	setmax(rop->v[18], (long)bn_v / 2);
	setmax(rop->v[19], (long)bn_v / 2);
	setmax(rop->v[20], (long)bn_v / 2);
	setmax(rop->v[21], (long)bn_v / 2);

	//XXX: Change additive constant
	setmax(rop->v[4], (long)bn_v / 2 + 2331);  /* TODO: Think about value */
	setmax(rop->v[5], (long)bn_v / 2 + 2331);  /* TODO: Think about value */
	setmax(rop->v[10], (long)bn_v / 2 + 2331); /* TODO: Think about value */
	setmax(rop->v[11], (long)bn_v / 2 + 2331); /* TODO: Think about value */
	setmax(rop->v[16], (long)bn_v / 2 + 2331); /* TODO: Think about value */
	setmax(rop->v[17], (long)bn_v / 2 + 2331); /* TODO: Think about value */
	setmax(rop->v[22], (long)bn_v / 2 + 2331); /* TODO: Think about value */
	setmax(rop->v[23], (long)bn_v / 2 + 2331); /* TODO: Think about value */
}

// Set fp2e_t rop to given value:
void fp2e_set_fpe(fp2e_t rop, const fpe_t op)
{
	int i;
	for (i = 0; i < 12; i++) {
		rop->v[2 * i] = op->v[i];
		rop->v[2 * i + 1] = 0;
	}
}

// Set rop to one
void fp2e_setone(fp2e_t rop)
{
	int i;
	for (i = 1; i < 24; i++)
		rop->v[i] = 0;
	rop->v[0] = 1.;
}

// Set rop to zero
void fp2e_setzero(fp2e_t rop)
{
	int i;
	for (i = 0; i < 24; i++)
		rop->v[i] = 0;
}

// Compare for equality:
int fp2e_iseq(const fp2e_t op1, const fp2e_t op2)
{
	fpe_t a1, b1, a2, b2;
	fp2e_to_2fpe(a1, b1, op1);
	fp2e_to_2fpe(a2, b2, op2);
	return fpe_iseq(a1, a2) && fpe_iseq(b1, b2);
}

int fp2e_isone(const fp2e_t op)
{
	fpe_t ta, tb;
	fp2e_to_2fpe(ta, tb, op);
	int ret = fpe_iszero(ta);
	ret = ret && fpe_isone(tb);
	return ret;
}

int fp2e_iszero(const fp2e_t op)
{
	fpe_t ta, tb;
	fp2e_to_2fpe(ta, tb, op);
	int ret = fpe_iszero(ta);
	ret = ret && fpe_iszero(tb);
	return ret;
}

void fp2e_cmov(fp2e_t rop, const fp2e_t op, int c)
{
	int i;
	for (i = 0; i < 24; i++)
		rop->v[i] = (1 - c) * rop->v[i] + c * op->v[i];
}

#ifndef QHASM
// Double an fp2e:
void fp2e_double2_c(fp2e_t rop)
{
#ifdef N_OPS
	double2fp2ctr++;
#endif
	int i;
	for (i = 0; i < 24; i++)
		rop->v[i] = 2 * rop->v[i];
}
#endif

#ifndef QHASM
// Double an fp2e:
void fp2e_double_c(fp2e_t rop, const fp2e_t op)
{
#ifdef N_OPS
	doublefp2ctr++;
#endif
	int i;
	for (i = 0; i < 24; i++)
		rop->v[i] = 2 * op->v[i];
}
#endif

#ifndef QHASM
// Triple an fp2e:
void fp2e_triple2_c(fp2e_t rop)
{
#ifdef N_OPS
	triple2fp2ctr++;
#endif
	int i;
	for (i = 0; i < 24; i++)
		rop->v[i] = 3 * rop->v[i];
}
#endif

#ifndef QHASM
// Triple an fp2e:
void fp2e_triple_c(fp2e_t rop, const fp2e_t op)
{
#ifdef N_OPS
	triplefp2ctr++;
#endif
	int i;
	for (i = 0; i < 24; i++)
		rop->v[i] = 3 * op->v[i];
}
#endif

void fp2e_mul_scalar(fp2e_t rop, const fp2e_t op, const int s)
{
#ifdef N_OPS
	mul_scalarfp2ctr++;
#endif
	int i;
	for (i = 0; i < 24; i++)
		rop->v[i] = s * op->v[i];
}

// Add two fp2e, store result in op1:
#ifndef QHASM
void fp2e_add2_c(fp2e_t op1, const fp2e_t op2)
{
#ifdef N_OPS
	add2fp2ctr++;
#endif
	int i;
	for (i = 0; i < 24; i++)
		op1->v[i] += op2->v[i];
}
#endif

#ifndef QHASM
// Add two fp2e, store result in rop:
void fp2e_add_c(fp2e_t rop, const fp2e_t op1, const fp2e_t op2)
{
#ifdef N_OPS
	addfp2ctr++;
#endif
	int i;
	for (i = 0; i < 24; i++)
		rop->v[i] = op1->v[i] + op2->v[i];
}
#endif

#ifndef QHASM
// Subtract op2 from op1, store result in op1:
void fp2e_sub2_c(fp2e_t op1, const fp2e_t op2)
{
#ifdef N_OPS
	sub2fp2ctr++;
#endif
	int i;
	for (i = 0; i < 24; i++)
		op1->v[i] -= op2->v[i];
}
#endif

#ifndef QHASM
// Subtract op2 from op1, store result in rop:
void fp2e_sub_c(fp2e_t rop, const fp2e_t op1, const fp2e_t op2)
{
#ifdef N_OPS
	subfp2ctr++;
#endif
	int i;
	for (i = 0; i < 24; i++)
		rop->v[i] = op1->v[i] - op2->v[i];
}
#endif

#ifndef QHASM
// Negate op
void fp2e_neg2_c(fp2e_t op)
{
#ifdef N_OPS
	neg2fp2ctr++;
#endif
	int i;
	for (i = 0; i < 24; i++)
		op->v[i] = -op->v[i];
}
#endif

#ifndef QHASM
// Negate op
void fp2e_neg_c(fp2e_t rop, const fp2e_t op)
{
#ifdef N_OPS
	negfp2ctr++;
#endif
	int i;
	for (i = 0; i < 24; i++)
		rop->v[i] = -op->v[i];
}
#endif

#ifndef QHASM
// Conjugates: aX+b to -aX+b
void fp2e_conjugate_c(fp2e_t rop, const fp2e_t op)
{
#ifdef N_OPS
	conjugatefp2ctr++;
#endif
	int i;
	for (i = 0; i < 24; i += 2) {
		rop->v[i] = op->v[i];
		rop->v[i + 1] = op->v[i + 1] * (-1);
	}
}
#endif

#ifndef QHASM
// Multiply two fp2e, store result in rop:
void fp2e_mul_c(fp2e_t rop, const fp2e_t op1, const fp2e_t op2)
{
#ifdef N_OPS
	mulfp2ctr += 1;
#endif
	fpe_t a1, b1, a2, b2, r1, r2;
	mydouble a3[24], b3[24];
	int i;
	mydouble t0[24], t1[24], t2[24], t3[24];

	fp2e_to_2fpe(a1, b1, op1);
	fp2e_to_2fpe(a2, b2, op2);

	polymul(t1, a1->v, b2->v); // t1 = a1*b2
	polymul(t2, b1->v, a2->v); // t2 = b1*a2

	for (i = 0; i < 12; i++) // t3 = 1*a1
	{
		t3[i] = 1 * a1->v[i];
	}
	polymul(t3, t3, a2->v);    // t3 = 1*a1*a2
	polymul(t0, b1->v, b2->v); // t0 = b1*b2

	for (i = 0; i < 23; i++) {
		a3[i] = t1[i] + t2[i]; // a3 = a1*b2 + b1*a2
		b3[i] = t0[i] - t3[i]; // b3 = b1*b2 - 1*a1*a2
	}
	degred(a3);
	degred(b3);
	coeffred_round_par(a3);
	coeffred_round_par(b3);

	fpe_set_doublearray(r1, a3);
	fpe_set_doublearray(r2, b3);
	_2fpe_to_fp2e(rop, r1, r2);
}
#endif

#ifndef QHASM
// Square an fp2e, store result in rop:
void fp2e_square_c(fp2e_t rop, const fp2e_t op)
{
#ifdef N_OPS
	sqfp2ctr += 1;
#endif
	fpe_t a1, b1, r1, r2;
	mydouble ropa[24], ropb[24];
	fp2e_to_2fpe(a1, b1, op);
	int i;

/* CheckDoubles are not smart enough to recognize 
 * binomial formula to compute b^2-a^2 */
#ifdef CHECK
	mydouble d1[24];
	polymul(d1, a1->v, a1->v);
	polymul(ropb, b1->v, b1->v);
	polymul(ropa, b1->v, a1->v);
	for (i = 0; i < 23; i++) {
		ropb[i] -= d1[i];
		ropa[i] *= 2;
	}
#else
	fpe_t t1, t2, t3;
	for (i = 0; i < 12; i++) {
		t1->v[i] = a1->v[i] + b1->v[i];
		t2->v[i] = b1->v[i] - a1->v[i];
		t3->v[i] = 2 * b1->v[i];
	}
	polymul(ropa, a1->v, t3->v);
	polymul(ropb, t1->v, t2->v);
#endif

	degred(ropa);
	degred(ropb);
	coeffred_round_par(ropa);
	coeffred_round_par(ropb);

	fpe_set_doublearray(r1, ropa);
	fpe_set_doublearray(r2, ropb);
	_2fpe_to_fp2e(rop, r1, r2);
}
#endif

#ifndef QHASM
// Multiply by xi=i+3 which is used to construct F_p^6
// (a*i + b)*(i + 3) = (3*b - 1*a) + (3*a + b)*i
void fp2e_mulxi_c(fp2e_t rop, const fp2e_t op)
{
#ifdef N_OPS
	mulxifp2ctr++;
#endif
	fpe_t a, b, t1, t2, t3, t4, t5;
	fp2e_to_2fpe(a, b, op);
	int i;
	for (i = 0; i < 12; i++) {
		t1->v[i] = 3 * a->v[i]; // t1 = 3*a
		t2->v[i] = 3 * b->v[i]; // t2 = 3*b
		t3->v[i] = 1 * a->v[i]; // t3 = 1*a
	}
	fpe_add(t4, t1, b);  // t4 = 3*a + b
	fpe_sub(t5, t2, t3); // t5 = 3*b - 1*a
	_2fpe_to_fp2e(rop, t4, t5);
}
#endif

// Scalar multiple of an fp2e, store result in rop:
#ifndef QHASM
void fp2e_mul_fpe_c(fp2e_t rop, const fp2e_t op1, const fpe_t op2)
{
#ifdef N_OPS
	mulfp2fpctr += 1;
#endif
	fpe_t a1, b1;
	fp2e_to_2fpe(a1, b1, op1);
	fpe_mul(a1, a1, op2);
	fpe_mul(b1, b1, op2);
	_2fpe_to_fp2e(rop, a1, b1);
}
#endif

#ifndef QHASM
/* computes (op1->m_a*op2->m_a, op1->m_b*op2->m_b) */
void fp2e_parallel_coeffmul_c(fp2e_t rop, const fp2e_t op1, const fp2e_t op2)
{
	fpe_t a1, b1, a2, b2; // Needed for intermediary results
	fp2e_to_2fpe(a1, b1, op1);
	fp2e_to_2fpe(a2, b2, op2);
	fpe_mul(a1, a1, a2);
	fpe_mul(b1, b1, b2);
	_2fpe_to_fp2e(rop, a1, b1);
}
#endif

// Inverse multiple of an fp2e, store result in rop:
void fp2e_invert(fp2e_t rop, const fp2e_t op)
{
#ifdef N_OPS
	invfp2ctr += 1;
#endif
	/* New version */
	fp2e_t d1, d2;
	int i;
	fp2e_parallel_coeffmul(d1, op, op);
	for (i = 0; i < 24; i += 2)
		d1->v[i] = d1->v[i + 1] = d1->v[i] + d1->v[i + 1];
	fp2e_short_coeffred(d1);
	for (i = 0; i < 24; i += 2) {
		d2->v[i] = op->v[i];
		d2->v[i + 1] = -op->v[i + 1];
	}
	fp2e_set(rop, d1);
	for (i = 254; i >= 0; i--) {
		fp2e_parallel_coeffmul(rop, rop, rop);
		if (scalar_getbit(bn_pminus2, i))
			fp2e_parallel_coeffmul(rop, rop, d1);
	}
	fp2e_parallel_coeffmul(rop, rop, d2);
}

// fp2e_exp and fp2e_sqrt added by David Lazar for Alpenhorn

// Exponentiation
void fp2e_exp(fp2e_t rop, const fp2e_t op, const scalar_t exp)
{
	fp2e_t dummy;
	unsigned int startbit;

	startbit = scalar_scanb(exp);
	fp2e_set(dummy, op);
	fp2e_set(rop, op);
	int i;
	for (i = startbit; i > 0; i--) {
		fp2e_square(rop, rop);
		if (scalar_getbit(exp, i - 1))
			fp2e_mul(rop, rop, dummy);
	}
}

const fp2e_t fp2e_one = {{{1., 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}};
const fp2e_t fp2e_negOne = {{{-1., 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}};
const fp2e_t fp2e_i = {{{0, 1., 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}};

const scalar_t pMinus3Div4 = {0x86172b1b17822599, 0x7b96e234482d6d67, 0x6a9bfb2e18613708, 0x23ed4078d2a8e1fe};
const scalar_t pMinus1Div2 = {0xc2e56362f044b33, 0xf72dc468905adacf, 0xd537f65c30c26e10, 0x47da80f1a551c3fc};

// Sets rop to the square root of a in the GFp2 field (F_{p^2}).
// This is Algorithm 9 from https://eprint.iacr.org/2012/685.pdf
// Assumes p is a prime with p = 3 mod 4, and that a is Minimal.
int fp2e_sqrt(fp2e_t rop, const fp2e_t a)
{
	fp2e_t a1, alpha, a0, x0, b;

	fp2e_exp(a1, a, pMinus3Div4);
	fp2e_mul(alpha, a1, a);
	fp2e_mul(alpha, a1, alpha);

	fp2e_conjugate(a0, alpha);
	fp2e_mul(a0, a0, alpha);

	if (fp2e_iseq(a0, fp2e_negOne)) {
		return 0;
	}

	fp2e_mul(x0, a1, a);
	if (fp2e_iseq(alpha, fp2e_negOne)) {
		fp2e_mul(rop, fp2e_i, x0);
		return 1;
	} else {
		fp2e_add(b, fp2e_one, alpha);
		fp2e_exp(b, b, pMinus1Div2);
		fp2e_mul(rop, b, x0);
		return 1;
	}
}

// Print the fp2e:
void fp2e_print(FILE *outfile, const fp2e_t op)
{
	fpe_t a, b;
	fp2e_to_2fpe(a, b, op);
	fpe_print(outfile, a);
	fprintf(outfile, " * X + ");
	fpe_print(outfile, b);
}

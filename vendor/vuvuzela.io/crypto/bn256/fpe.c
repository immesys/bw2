/*
 * File:   dclxvi-20130329/fpe.c
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#include "fpe.h"
#include "mul.h"
#include "scalar.h"
#include <assert.h>
#include <math.h>

extern const scalar_t bn_pminus2;
extern const double bn_v;
extern const double bn_v6;

void fpe_short_coeffred(fpe_t rop)
{
	mydouble carry11 = round(rop->v[11] / bn_v);
	rop->v[11] = remround(rop->v[11], bn_v);
	rop->v[0] = rop->v[0] - carry11;
	rop->v[3] = rop->v[3] - carry11;
	rop->v[6] = rop->v[6] - 4 * carry11;
	rop->v[9] = rop->v[9] - carry11;
	mydouble carry0 = round(rop->v[0] / bn_v6);
	mydouble carry1 = round(rop->v[1] / bn_v);
	mydouble carry2 = round(rop->v[2] / bn_v);
	mydouble carry3 = round(rop->v[3] / bn_v);
	mydouble carry4 = round(rop->v[4] / bn_v);
	mydouble carry5 = round(rop->v[5] / bn_v);
	mydouble carry6 = round(rop->v[6] / bn_v6);
	mydouble carry7 = round(rop->v[7] / bn_v);
	mydouble carry8 = round(rop->v[8] / bn_v);
	mydouble carry9 = round(rop->v[9] / bn_v);
	mydouble carry10 = round(rop->v[10] / bn_v);
	rop->v[0] = remround(rop->v[0], bn_v6);
	rop->v[1] = remround(rop->v[1], bn_v);
	rop->v[2] = remround(rop->v[2], bn_v);
	rop->v[3] = remround(rop->v[3], bn_v);
	rop->v[4] = remround(rop->v[4], bn_v);
	rop->v[5] = remround(rop->v[5], bn_v);
	rop->v[6] = remround(rop->v[6], bn_v6);
	rop->v[7] = remround(rop->v[7], bn_v);
	rop->v[8] = remround(rop->v[8], bn_v);
	rop->v[9] = remround(rop->v[9], bn_v);
	rop->v[10] = remround(rop->v[10], bn_v);
	rop->v[1] += carry0;
	rop->v[2] += carry1;
	rop->v[3] += carry2;
	rop->v[4] += carry3;
	rop->v[5] += carry4;
	rop->v[6] += carry5;
	rop->v[7] += carry6;
	rop->v[8] += carry7;
	rop->v[9] += carry8;
	rop->v[10] += carry9;
	rop->v[11] += carry10;
}

// Set fpe_t rop to given value:
void fpe_set(fpe_t rop, const fpe_t op)
{
	int i;
	for (i = 0; i < 12; i++)
		rop->v[i] = op->v[i];
}

/* Communicate the fact that the fpe is reduced (and that we don't know anything more about it) */
void fpe_isreduced(fpe_t rop)
{
	setmax(rop->v[0], (long)bn_v6 / 2);
	setmax(rop->v[6], (long)bn_v6 / 2);

	setmax(rop->v[1], (long)bn_v / 2);
	setmax(rop->v[3], (long)bn_v / 2);
	setmax(rop->v[4], (long)bn_v / 2);
	setmax(rop->v[7], (long)bn_v / 2);
	setmax(rop->v[9], (long)bn_v / 2);
	setmax(rop->v[10], (long)bn_v / 2);

	//XXX: Change additive constant:
	setmax(rop->v[2], (long)bn_v / 2 + 2331);
	setmax(rop->v[5], (long)bn_v / 2 + 2331);
	setmax(rop->v[8], (long)bn_v / 2 + 2331);
	setmax(rop->v[11], (long)bn_v / 2 + 2331);
}

// Set fpe_t rop to value given in double array of length 12
void fpe_set_doublearray(fpe_t rop, const mydouble op[12])
{
	int i;
	for (i = 0; i < 12; i++)
		rop->v[i] = op[i];
}

// Set rop to one
void fpe_setone(fpe_t rop)
{
	int i;
	for (i = 1; i < 12; i++)
		rop->v[i] = 0.;
	rop->v[0] = 1;
}

// Set rop to zero
void fpe_setzero(fpe_t rop)
{
	int i;
	for (i = 0; i < 12; i++)
		rop->v[i] = 0.;
}

int fpe_iseq(const fpe_t op1, const fpe_t op2)
{
	fpe_t t;
	fpe_sub(t, op1, op2);
	return fpe_iszero(t);
}

int fpe_isone(const fpe_t op)
{
	fpe_t t;
	int i;
	for (i = 1; i < 12; i++)
		t->v[i] = op->v[i];
	t->v[0] = op->v[0] - 1.;
	return fpe_iszero(t);
}

int fpe_iszero(const fpe_t op)
{
	fpe_t t;
	double d;
	int i;
	unsigned long long tr = 0;
	unsigned int differentbits = 0;
	for (i = 0; i < 12; i++)
		t->v[i] = op->v[i];
	coeffred_round_par(t->v);

	//Constant-time comparison
	double zero = 0.;
	unsigned long long *zp = (unsigned long long *)&zero;
	;
	unsigned long long *tp;

	for (i = 0; i < 12; i++) {
		d = todouble(t->v[i]);
		tp = (unsigned long long *)&d;
		tr |= (*tp ^ *zp);
	}
	for (i = 0; i < 8; i++)
		differentbits |= i[(unsigned char *)&tr];

	return 1 & ((differentbits - 1) >> 8);
}

// Compute the negative of an fpe
void fpe_neg(fpe_t rop, const fpe_t op)
{
	int i;
	for (i = 0; i < 12; i++)
		rop->v[i] = -op->v[i];
}

// Double an fpe:
void fpe_double(fpe_t rop, const fpe_t op)
{
	int i;
	for (i = 0; i < 12; i++)
		rop->v[i] = op->v[i] * 2;
}

// Double an fpe:
void fpe_triple(fpe_t rop, const fpe_t op)
{
	int i;
	for (i = 0; i < 12; i++)
		rop->v[i] = op->v[i] * 3;
}

// Add two fpe, store result in rop:
void fpe_add(fpe_t rop, const fpe_t op1, const fpe_t op2)
{
	int i;
	for (i = 0; i < 12; i++)
		rop->v[i] = op1->v[i] + op2->v[i];
}

// Subtract op2 from op1, store result in rop:
void fpe_sub(fpe_t rop, const fpe_t op1, const fpe_t op2)
{
	int i;
	for (i = 0; i < 12; i++)
		rop->v[i] = op1->v[i] - op2->v[i];
}

// Multiply two fpe, store result in rop:
#ifndef QHASM
void fpe_mul_c(fpe_t rop, const fpe_t op1, const fpe_t op2)
{
	mydouble h[24];
	polymul(h, op1->v, op2->v);
	degred(h);
	coeffred_round_par(h);
	int i;
	for (i = 0; i < 12; i++)
		rop->v[i] = h[i];
}
#endif

// Square an fpe, store result in rop:
void fpe_square(fpe_t rop, const fpe_t op)
{
	/* Not used during pairing computation */
	fpe_mul(rop, op, op);
}

// Compute inverse of an fpe, store result in rop:
void fpe_invert(fpe_t rop, const fpe_t op1)
{
	fpe_set(rop, op1);
	int i;
	for (i = 254; i >= 0; i--) {
		fpe_mul(rop, rop, rop);
		if (scalar_getbit(bn_pminus2, i))
			fpe_mul(rop, rop, op1);
	}
}

// Print the element to stdout:
void fpe_print(FILE *outfile, const fpe_t op)
{
	int i;
	for (i = 0; i < 11; i++)
		fprintf(outfile, "%10lf, ", todouble(op->v[i]));
	fprintf(outfile, "%10lf", todouble(op->v[11]));
}

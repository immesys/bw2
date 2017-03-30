/*
 * File:   dclxvi-20130329/fp12e.h
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#ifndef FP12E_H
#define FP12E_H

#include "fp6e.h"
#include "scalar.h"

#ifdef BENCH
unsigned long long multp12cycles;
unsigned long long nummultp12;
unsigned long long sqp12cycles;
unsigned long long numsqp12;
unsigned long long sqp12norm1cycles;
unsigned long long numsqp12norm1;
unsigned long long invp12cycles;
unsigned long long numinvp12;
#endif

// Elements from F_{p^{12}}= F_{p^6}[Z] / (Z^2 - tau)F_{p^6}[Z] are represented as aZ + b
typedef struct fp12e_struct fp12e_struct_t;

struct fp12e_struct {
	fp6e_t m_a;
	fp6e_t m_b;
};

typedef fp12e_struct_t fp12e_t[1];

// Set fp12e_t rop to given value:
void fp12e_set(fp12e_t rop, const fp12e_t op);

// Initialize an fp12e, set to value given in two fp6es
void fp12e_set_fp6e(fp12e_t rop, const fp6e_t a, const fp6e_t b);

// Set rop to one:
void fp12e_setone(fp12e_t rop);

// Set rop to zero:
void fp12e_setzero(fp12e_t rop);

// Compare for equality:
int fp12e_iseq(const fp12e_t op1, const fp12e_t op2);

int fp12e_isone(const fp12e_t op);

int fp12e_iszero(const fp12e_t op);

void fp12e_cmov(fp12e_t rop, const fp12e_t op, int c);

// Compute conjugate over Fp6:
void fp12e_conjugate(fp12e_t rop, const fp12e_t op2);

// Add two fp12e, store result in rop:
void fp12e_add(fp12e_t rop, const fp12e_t op1, const fp12e_t op2);

// Subtract op2 from op1, store result in rop:
void fp12e_sub(fp12e_t rop, const fp12e_t op1, const fp12e_t op2);

// Multiply two fp12e, store result in rop:
void fp12e_mul(fp12e_t rop, const fp12e_t op1, const fp12e_t op2);

void fp12e_mul_fp6e(fp12e_t rop, const fp12e_t op1, const fp6e_t op2);

// Square an fp12e, store result in rop:
void fp12e_square(fp12e_t rop, const fp12e_t op);

// Multiply an fp12e by a line function value, store result in rop:
// The line function is given by 3 fp2e elements op2, op3, op4 as
// line = (op2*tau + op3)*z + op4 = a2*z + b2.
void fp12e_mul_line(fp12e_t rop, const fp12e_t op1, const fp2e_t op2, const fp2e_t op3, const fp2e_t op4);

void fp12e_pow_vartime(fp12e_t rop, const fp12e_t op, const scalar_t exp);

//void fp12e_pow_norm1(fp12e_t rop, const fp12e_t op, const scalar_t exp, const unsigned int exp_bitsize);

// Implicit fp4 squaring for Granger/Scott special squaring in final expo
// fp4e_square takes two fp2e op1, op2 representing the fp4 element
// op1*z^3 + op2, writes the square to rop1, rop2 representing rop1*z^3 + rop2.
// (op1*z^3 + op2)^2 = (2*op1*op2)*z^3 + (op1^2*xi + op2^2).
void fp4e_square(fp2e_t rop1, fp2e_t rop2, const fp2e_t op1, const fp2e_t op2);

// Special squaring for use on elements in T_6(fp2) (after the
// easy part of the final exponentiation. Used in the hard part
// of the final exponentiation. Function uses formulas in
// Granger/Scott (PKC2010).
void fp12e_special_square_finexp(fp12e_t rop, const fp12e_t op);

void fp12e_invert(fp12e_t rop, const fp12e_t op);

void fp12e_frobenius_p(fp12e_t rop, const fp12e_t op);

void fp12e_frobenius_p2(fp12e_t rop, const fp12e_t op);

// Scalar multiple of an fp12e, store result in rop:
void fp12e_mul_scalar(fp12e_t rop, const fp12e_t op1, const scalar_t op2);

// Print the element to stdout:
void fp12e_print(FILE *outfile, const fp12e_t op);

#endif // ifndef FP12E_H

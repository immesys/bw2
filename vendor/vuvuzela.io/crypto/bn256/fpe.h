/*
 * File:   dclxvi-20130329/fpe.h
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#ifndef FPE_H
#define FPE_H

#include "mydouble.h"
#include <stdio.h>

#ifdef BENCH
unsigned long long int multpcycles;
unsigned long long int nummultp;
unsigned long long int nummultzerop;
unsigned long long int nummultonep;
unsigned long long int sqpcycles;
unsigned long long int numsqp;
unsigned long long invpcycles;
unsigned long long numinvp;
#endif

typedef struct fpe_struct fpe_struct_t;

struct fpe_struct {
	mydouble v[12];
} __attribute__((aligned(16)));

typedef fpe_struct_t fpe_t[1];

void fpe_short_coeffred(fpe_t rop);

// Set fpe_t rop to given value:
void fpe_set(fpe_t rop, const fpe_t op);

/* Communicate the fact that the fpe is reduced (and that we don't know anything more about it) */
void fpe_isreduced(fpe_t rop);

// Set fpe_t rop to value given in bytearray -- inverse function to fpe_to_bytearray
void fpe_set_bytearray(fpe_t rop, const unsigned char *op, size_t oplen);

// Set fpe_t rop to value given in double array of length 12
void fpe_set_doublearray(fpe_t rop, const mydouble op[12]);

// Set rop to one
void fpe_setone(fpe_t rop);

// Set rop to zero
void fpe_setzero(fpe_t rop);

// Compare for equality:
int fpe_iseq(const fpe_t op1, const fpe_t op2);

// Is the element equal to 1:
int fpe_isone(const fpe_t op);

// Is the element equal to 0:
int fpe_iszero(const fpe_t op);

// Compute the negative of an fpe
void fpe_neg(fpe_t rop, const fpe_t op);

// Double an fpe:
void fpe_double(fpe_t rop, const fpe_t op);

// Triple an fpe:
void fpe_triple(fpe_t rop, const fpe_t op);

// Add two fpe, store result in rop:
void fpe_add(fpe_t rop, const fpe_t op1, const fpe_t op2);

// Subtract op2 from op1, store result in rop:
void fpe_sub(fpe_t rop, const fpe_t op1, const fpe_t op2);

#ifdef QHASM
#define fpe_mul fpe_mul_qhasm
#else
#define fpe_mul fpe_mul_c
#endif
// Multiply two fpe, store result in rop:
void fpe_mul(fpe_t rop, const fpe_t op1, const fpe_t op2);

// Square an fpe, store result in rop:
void fpe_square(fpe_t rop, const fpe_t op);

// Compute inverse of an fpe, store result in rop:
void fpe_invert(fpe_t rop, const fpe_t op1);

// Print the element to stdout:
void fpe_print(FILE *outfile, const fpe_t op);

// Convert fpe into a bytearray
void fpe_to_bytearray(unsigned char *rop, const fpe_t op);

/*
// Field constants
fpe_t fpe_one;
fpe_t zeta; // Third root of unity in F_p fulfilling Z^{p^2} = -zeta * Z
fpe_t _1o3modp; // 1/3 \in \F_p
// Two constants needed for the cometa-pairing computation
fpe_t cometa_c0_const;
fpe_t cometa_c1_const;
*/

#endif

/*
 * File:   dclxvi-20130329/fp2e.h
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#ifndef FP2E_H
#define FP2E_H

#include "fpe.h"
#include "mydouble.h"
#include "scalar.h"
#include <stdio.h>

// Elements from F_{p^2}= F_p[X] / (x^2 - alpha)F_p[X] are represented as aX + b
typedef struct fp2e_struct {
	// Arrangement in memory: (b0, a0, b1, a1, ... b11,a11)
	mydouble v[24];
} __attribute__((aligned(16))) fp2e_struct_t;

typedef fp2e_struct_t fp2e_t[1];

void fp2e_to_2fpe(fpe_t ropa, fpe_t ropb, const fp2e_t op);
void _2fpe_to_fp2e(fp2e_t rop, const fpe_t opa, const fpe_t opb);

#ifdef QHASM
#define fp2e_short_coeffred fp2e_short_coeffred_qhasm
#else
#define fp2e_short_coeffred fp2e_short_coeffred_c
#endif
void fp2e_short_coeffred(fp2e_t rop);

// Set fp2e_t rop to given value:
void fp2e_set(fp2e_t rop, const fp2e_t op);

/* Communicate the fact that the fp2e is reduced (and that we don't know anything more about it) */
void fp2e_isreduced(fp2e_t rop);

// Set fp2e_t rop to given value contained in the subfield F_p:
void fp2e_set_fpe(fp2e_t rop, const fpe_t op);

// Set rop to one
void fp2e_setone(fp2e_t rop);

// Set rop to zero
void fp2e_setzero(fp2e_t rop);

// Compare for equality:
int fp2e_iseq(const fp2e_t op1, const fp2e_t op2);

int fp2e_isone(const fp2e_t op);

int fp2e_iszero(const fp2e_t op);

void fp2e_cmov(fp2e_t rop, const fp2e_t op, int c);

#ifdef QHASM
#define fp2e_double fp2e_double_qhasm
#else
#define fp2e_double fp2e_double_c
#endif
// Double an fp2e:
void fp2e_double(fp2e_t rop, const fp2e_t op);

// Double an fp2e:
#ifdef QHASM
#define fp2e_double2 fp2e_double2_qhasm
#else
#define fp2e_double2 fp2e_double2_c
#endif
void fp2e_double2(fp2e_t rop);

#ifdef QHASM
#define fp2e_triple fp2e_triple_qhasm
#else
#define fp2e_triple fp2e_triple_c
#endif
// Triple an fp2e:
void fp2e_triple(fp2e_t rop, const fp2e_t op);

// Triple an fp2e:
#ifdef QHASM
#define fp2e_triple2 fp2e_triple2_qhasm
#else
#define fp2e_triple2 fp2e_triple2_c
#endif
void fp2e_triple2(fp2e_t rop);

void fp2e_mul_scalar(fp2e_t rop, const fp2e_t op, const int s);

#ifdef QHASM
#define fp2e_add fp2e_add_qhasm
#else
#define fp2e_add fp2e_add_c
#endif
// Add two fp2e, store result in rop:
void fp2e_add(fp2e_t rop, const fp2e_t op1, const fp2e_t op2);

// Add rop to up, store result in rop:
#ifdef QHASM
#define fp2e_add2 fp2e_add2_qhasm
#else
#define fp2e_add2 fp2e_add2_c
#endif
void fp2e_add2(fp2e_t rop, const fp2e_t op);

// Load from mem
void fp2e_load(fp2e_struct_t *rop, const fp2e_t op);
//void fp2e_load(fp2e_t rop, const fp2e_t op);

// store to mem
void fp2e_store(fp2e_struct_t *rop, const fp2e_t op);
//void fp2e_store(fp2e_t rop, const fp2e_t op);

#ifdef QHASM
#define fp2e_sub fp2e_sub_qhasm
#else
#define fp2e_sub fp2e_sub_c
#endif
// Subtract op2 from op1, store result in rop:
void fp2e_sub(fp2e_t rop, const fp2e_t op1, const fp2e_t op2);

#ifdef QHASM
#define fp2e_sub2 fp2e_sub2_qhasm
#else
#define fp2e_sub2 fp2e_sub2_c
#endif
// Subtract op from rop, store result in rop:
void fp2e_sub2(fp2e_t rop, const fp2e_t op);

#ifdef QHASM
#define fp2e_neg2 fp2e_neg2_qhasm
#else
#define fp2e_neg2 fp2e_neg2_c
#endif
void fp2e_neg2(fp2e_t op);

#ifdef QHASM
#define fp2e_neg fp2e_neg_qhasm
#else
#define fp2e_neg fp2e_neg_c
#endif
void fp2e_neg(fp2e_t rop, const fp2e_t op);

#ifdef QHASM
#define fp2e_conjugate fp2e_conjugate_qhasm
#else
#define fp2e_conjugate fp2e_conjugate_c
#endif
// Conjugates: aX+b to -aX+b
void fp2e_conjugate(fp2e_t rop, const fp2e_t op);

#ifdef QHASM
#define fp2e_mul fp2e_mul_qhasm
#else
#define fp2e_mul fp2e_mul_c
#endif
// Multiply two fp2e, store result in rop:
void fp2e_mul(fp2e_t rop, const fp2e_t op1, const fp2e_t op2);

// Square an fp2e, store result in rop:
#ifdef QHASM
#define fp2e_square fp2e_square_qhasm
#else
#define fp2e_square fp2e_square_c
#endif
void fp2e_square(fp2e_t rop, const fp2e_t op);

// Multiply by xi which is used to construct F_p^6
#ifdef QHASM
#define fp2e_mulxi fp2e_mulxi_qhasm
#else
#define fp2e_mulxi fp2e_mulxi_c
#endif
void fp2e_mulxi(fp2e_t rop, const fp2e_t op);

// Multiple of an fp2e, store result in rop:
#ifdef QHASM
#define fp2e_mul_fpe fp2e_mul_fpe_qhasm
#else
#define fp2e_mul_fpe fp2e_mul_fpe_c
#endif
void fp2e_mul_fpe(fp2e_t rop, const fp2e_t op1, const fpe_t op2);

#ifdef QHASM
#define fp2e_parallel_coeffmul fp2e_parallel_coeffmul_qhasm
#else
#define fp2e_parallel_coeffmul fp2e_parallel_coeffmul_c
#endif
/* computes (op1->m_a*op2->m_a, op1->m_b*op2->m_b) */
void fp2e_parallel_coeffmul(fp2e_t rop, const fp2e_t op1, const fp2e_t op2);

// Inverse multiple of an fp2e, store result in rop:
void fp2e_invert(fp2e_t rop, const fp2e_t op1);

// Exponentiation:
void fp2e_exp(fp2e_t rop, const fp2e_t op, const scalar_t exp);

// Square root:
int fp2e_sqrt(fp2e_t rop, const fp2e_t op);

// Print the element to stdout:
void fp2e_print(FILE *outfile, const fp2e_t op);

#endif // ifndef FP2E_H

/*
 * File:   dclxvi-20130329/scalar.h
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#ifndef SCALAR_H
#define SCALAR_H
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned long long scalar_t[4];

void scalar_sub_nored(scalar_t r, scalar_t x, scalar_t y);

void scalar_setrandom(scalar_t rop, const scalar_t bound);

void scalar_set_lluarray(scalar_t rop, unsigned long long v[4]);

int scalar_getbit(const scalar_t s, unsigned int pos);

// Returns the position of the most significant set bit
int scalar_scanb(const scalar_t s);

int scalar_iszero_vartime(const scalar_t s);

void scalar_window4(signed char r[65], const scalar_t s);

int scalar_lt_vartime(const scalar_t a, const scalar_t b);

void scalar_print(FILE *fh, const scalar_t t);

#ifdef __cplusplus
}
#endif

#endif

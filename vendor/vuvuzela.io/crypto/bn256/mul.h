/*
 * File:   dclxvi-20130329/mul.h
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#ifndef MUL_H
#define MUL_H

#include "mydouble.h"

void polymul(mydouble *h, const mydouble *f, const mydouble *g);
void degred(mydouble *h);
void coeffred_round_par(mydouble *h);

#endif

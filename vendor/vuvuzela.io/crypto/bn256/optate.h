/*
 * File:   dclxvi-20130329/optate.h
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#ifndef OPTATE_H
#define OPTATE_H

#include "curvepoint_fp.h"
#include "fp12e.h"
#include "twistpoint_fp2.h"

void optate(fp12e_t rop, const twistpoint_fp2_t op1, const curvepoint_fp_t op2);
void optate_miller(fp12e_t rop, const twistpoint_fp2_t op1, const curvepoint_fp_t op2);

#endif

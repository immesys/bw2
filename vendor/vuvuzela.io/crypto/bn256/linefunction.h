/*
 * File:   dclxvi-20130329/linefunction.h
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#ifndef LINEFUNCTION_H
#define LINEFUNCTION_H

#include "curvepoint_fp.h"
#include "fp2e.h"
#include "twistpoint_fp2.h"

void linefunction_add_ate(
    fp2e_t rop11,
    fp2e_t rop12,
    fp2e_t rop13,
    twistpoint_fp2_t rop2,
    const twistpoint_fp2_t op1,
    const twistpoint_fp2_t op2,
    const curvepoint_fp_t op3,
    const fp2e_struct_t *r2 // r2 = y^2, see "Faster Computation of Tate Pairings"
    );

void linefunction_double_ate(
    fp2e_t rop11,
    fp2e_t rop12,
    fp2e_t rop13,
    twistpoint_fp2_t rop2,
    const twistpoint_fp2_t op1,
    const curvepoint_fp_t op3);

#endif

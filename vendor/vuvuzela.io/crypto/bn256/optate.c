/*
 * File:   dclxvi-20130329/optate.c
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#include <stdio.h>

#include "curvepoint_fp.h"
#include "final_expo.h"
#include "fp12e.h"
#include "fp2e.h"
#include "fp6e.h"
#include "linefunction.h"
#include "optate.h"
#include "twistpoint_fp2.h"
//#include "parameters.h"

extern const unsigned long bn_naflen_6uplus2;
extern const scalar_t bn_6uplus2;
extern const fpe_t bn_zeta2;
extern const fp2e_t bn_z2p;
extern const fp2e_t bn_z3p;
extern const signed char bn_6uplus2_naf[66];

void optate_miller(fp12e_t rop, const twistpoint_fp2_t op1, const curvepoint_fp_t op2)
{
	// op1 and op2 are assumed to be in affine coordinates!
	twistpoint_fp2_t q1, q2; //, q3;
	fp12e_setone(rop);

	fp2e_t dummy1, dummy2, dummy3;
	fp2e_t tfp2e1, tfp2e2;

	twistpoint_fp2_t r, t, mop1;
	twistpoint_fp2_set(r, op1);
	twistpoint_fp2_neg(mop1, op1);
	fp2e_setone(r->m_t); /* As r has to be in affine coordinates this is ok */
	fp2e_setone(t->m_t); /* As t has to be in affine coordinates this is ok */

	fp2e_t r2;
	fp2e_square(r2, op1->m_y);

	unsigned int i;
	/*
    for(i = bn_bitlen_6uplus2 - 1; i > 0; i--) 
    {
        linefunction_double_ate(dummy1, dummy2, dummy3, r, r, op2);
        if(i != bn_bitlen_6uplus2 -1) fp12e_square(rop, rop);
        fp12e_mul_line(rop, rop, dummy1, dummy2, dummy3);

        if (scalar_getbit(bn_6uplus2, i - 1))
        {
            linefunction_add_ate(dummy1, dummy2, dummy3, r, r, op1, op2, r2);
            fp12e_mul_line(rop, rop, dummy1, dummy2, dummy3);
        }
    }
    */
	for (i = bn_naflen_6uplus2 - 1; i > 0; i--) {
		linefunction_double_ate(dummy1, dummy2, dummy3, r, r, op2);
		if (i != bn_naflen_6uplus2 - 1)
			fp12e_square(rop, rop);
		fp12e_mul_line(rop, rop, dummy1, dummy2, dummy3);

		if (bn_6uplus2_naf[i - 1] == 1) {
			linefunction_add_ate(dummy1, dummy2, dummy3, r, r, op1, op2, r2);
			fp12e_mul_line(rop, rop, dummy1, dummy2, dummy3);
		}
		if (bn_6uplus2_naf[i - 1] == -1) {
			linefunction_add_ate(dummy1, dummy2, dummy3, r, r, mop1, op2, r2);
			fp12e_mul_line(rop, rop, dummy1, dummy2, dummy3);
		}
	}

	/* Compute Q2 */
	fp2e_mul_fpe(tfp2e1, op1->m_x, bn_zeta2);
	twistpoint_fp2_affineset_fp2e(q2, tfp2e1, op1->m_y);

	/* Compute Q1 */
	fp2e_set(tfp2e1, op1->m_x);
	fp2e_conjugate(tfp2e1, tfp2e1);
	fp2e_mul(tfp2e1, tfp2e1, bn_z2p);
	/*
    printf("\n");
    fp2e_print(stdout, bn_z2p);
    printf("\n");
    */
	fp2e_set(tfp2e2, op1->m_y);
	fp2e_conjugate(tfp2e2, tfp2e2);
	fp2e_mul(tfp2e2, tfp2e2, bn_z3p);
	twistpoint_fp2_affineset_fp2e(q1, tfp2e1, tfp2e2);

	/* Compute Q3 */
	//fp2e_mul_fpe(tfp2e3, tfp2e1, bn_zeta2);
	//fp2e_neg(tfp2e2, tfp2e2);
	//twistpoint_fp2_affineset_fp2e(q3, tfp2e3, tfp2e2);

	/* Remaining line functions */
	fp2e_square(r2, q1->m_y);
	linefunction_add_ate(dummy1, dummy2, dummy3, t, r, q1, op2, r2);
	fp12e_mul_line(rop, rop, dummy1, dummy2, dummy3);

	fp2e_square(r2, q2->m_y);
	linefunction_add_ate(dummy1, dummy2, dummy3, t, t, q2, op2, r2);
	fp12e_mul_line(rop, rop, dummy1, dummy2, dummy3);

	//fp2e_square(r2, q3->m_y);
	//linefunction_add_ate(dummy1, dummy2, dummy3, t, t, q3, op2, r2);
	//fp12e_mul_line(rop, rop, dummy1, dummy2, dummy3);
}

void optate(fp12e_t rop, const twistpoint_fp2_t op1, const curvepoint_fp_t op2)
{
	int retone;
	fp12e_t d;
	fp12e_setone(d);
	optate_miller(rop, op1, op2);
	final_expo(rop);
	retone = fp2e_iszero(op1->m_z);
	retone |= fpe_iszero(op2->m_z);
	fp12e_cmov(rop, d, retone);
}

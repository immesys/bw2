/*
 * File:   dclxvi-20130329/curvepoint_fp.c
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#include "curvepoint_fp.h"
#include "fpe.h"
#include <stdio.h>
#include <stdlib.h>

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//            Point initialization and deletion functions
//////////////////////////////////////////////////////////////////////////////////////////////////////////

// Global dummies usable by all curvepoints:

// Set the coordinates of a curvepoint_fp_t by copying the coordinates from another curvepoint_fp
void curvepoint_fp_set(curvepoint_fp_t rop, const curvepoint_fp_t op)
{
	fpe_set(rop->m_x, op->m_x);
	fpe_set(rop->m_y, op->m_y);
	fpe_set(rop->m_z, op->m_z);
	fpe_setzero(rop->m_t);
}

void curvepoint_fp_setneutral(curvepoint_fp_t rop)
{
	fpe_setone(rop->m_x);
	fpe_setone(rop->m_y);
	fpe_setzero(rop->m_z);
	fpe_setzero(rop->m_t);
}

// Addition of two points, op2 is assumed to be in affine coordinates
// For the algorithm see e.g. DA Peter Schwabe
/*
void curvepoint_fp_mixadd(curvepoint_fp_t rop, const curvepoint_fp_t op1, const curvepoint_fp_t op2)
{
	fpe_t tfpe1, tfpe2, tfpe3, tfpe4, tfpe5, tfpe6, tfpe7, tfpe8, tfpe9; // Temporary variables needed for intermediary results
	fpe_square(tfpe1, op1->m_z);
	fpe_mul(tfpe2, op1->m_z, tfpe1);
	fpe_mul(tfpe3, op2->m_x, tfpe1);
	fpe_mul(tfpe4, op2->m_y, tfpe2);
	fpe_sub(tfpe5, tfpe3, op1->m_x);
  fpe_short_coeffred(tfpe5);
	fpe_sub(tfpe6, tfpe4, op1->m_y);
	fpe_square(tfpe7, tfpe5);
	fpe_mul(tfpe8, tfpe7, tfpe5);
	fpe_mul(tfpe9, op1->m_x, tfpe7);

	fpe_double(tfpe1, tfpe9);
	fpe_add(tfpe1, tfpe1, tfpe8);
	fpe_square(rop->m_x, tfpe6);
	fpe_sub(rop->m_x, rop->m_x, tfpe1);
  fpe_short_coeffred(rop->m_x);
	fpe_sub(tfpe1, tfpe9, rop->m_x);
	fpe_mul(tfpe2, tfpe1, tfpe6);
	fpe_mul(tfpe3, op1->m_y, tfpe8);
	fpe_sub(rop->m_y, tfpe2, tfpe3);
  fpe_short_coeffred(rop->m_y);
	fpe_mul(rop->m_z, op1->m_z, tfpe5);
}
*/

void curvepoint_fp_double(curvepoint_fp_t rop, const curvepoint_fp_t op)
{
	fpe_t tfpe1, tfpe2, tfpe3, tfpe4; // Temporary variables needed for intermediary results
	fpe_square(tfpe1, op->m_y);
	fpe_mul(tfpe2, tfpe1, op->m_x);
	fpe_double(tfpe2, tfpe2);
	fpe_double(tfpe2, tfpe2);
	fpe_square(tfpe3, tfpe1);
	fpe_double(tfpe3, tfpe3);
	fpe_double(tfpe3, tfpe3);
	fpe_double(tfpe3, tfpe3);
	fpe_square(tfpe4, op->m_x);
	fpe_triple(tfpe4, tfpe4);
	fpe_short_coeffred(tfpe4);
	fpe_square(rop->m_x, tfpe4);
	fpe_double(tfpe1, tfpe2);
	fpe_sub(rop->m_x, rop->m_x, tfpe1);
	fpe_short_coeffred(rop->m_x);
	fpe_sub(tfpe1, tfpe2, rop->m_x);
	fpe_short_coeffred(tfpe1);
	fpe_mul(rop->m_z, op->m_y, op->m_z);
	fpe_double(rop->m_z, rop->m_z);
	fpe_mul(rop->m_y, tfpe4, tfpe1);
	fpe_sub(rop->m_y, rop->m_y, tfpe3);
	fpe_short_coeffred(rop->m_y);
}

void curvepoint_fp_add_vartime(curvepoint_fp_t rop, const curvepoint_fp_t op1, const curvepoint_fp_t op2)
{
	if (fpe_iszero(op1->m_z))
		curvepoint_fp_set(rop, op2);
	else if (fpe_iszero(op2->m_z))
		curvepoint_fp_set(rop, op1);
	else {
		//See http://www.hyperelliptic.org/EFD/g1p/auto-code/shortw/jacobian-0/addition/add-2007-bl.op3
		fpe_t z1z1, z2z2, r, v, s1, s2, u1, u2, h, i, j, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14;
		//Z1Z1 = Z1^2
		fpe_square(z1z1, op1->m_z);
		//Z2Z2 = Z2^2
		fpe_square(z2z2, op2->m_z);
		//U1 = X1*Z2Z2
		fpe_mul(u1, op1->m_x, z2z2);
		//U2 = X2*Z1Z1
		fpe_mul(u2, op2->m_x, z1z1);
		//t0 = Z2*Z2Z2
		fpe_mul(t0, op2->m_z, z2z2);
		//S1 = Y1*t0
		fpe_mul(s1, op1->m_y, t0);
		//t1 = Z1*Z1Z1
		fpe_mul(t1, op1->m_z, z1z1);
		//S2 = Y2*t1
		fpe_mul(s2, op2->m_y, t1);
		if (fpe_iseq(u1, u2)) {
			if (fpe_iseq(s1, s2))
				curvepoint_fp_double(rop, op1);
			else
				curvepoint_fp_setneutral(rop);
		}
		//H = U2-U1
		fpe_sub(h, u2, u1);
		//t2 = 2*H
		fpe_add(t2, h, h);
		//I = t2^2
		fpe_short_coeffred(t2);
		fpe_square(i, t2);
		//J = H*I
		fpe_mul(j, h, i);
		//t3 = S2-S1
		fpe_sub(t3, s2, s1);
		//r = 2*t3
		fpe_add(r, t3, t3);
		//V = U1*I
		fpe_mul(v, u1, i);
		//t4 = r^2
		fpe_short_coeffred(r);
		fpe_square(t4, r);
		//t5 = 2*V
		fpe_add(t5, v, v);
		//t6 = t4-J
		fpe_sub(t6, t4, j);
		//X3 = t6-t5
		fpe_sub(rop->m_x, t6, t5);
		fpe_short_coeffred(rop->m_x);
		//t7 = V-X3
		fpe_sub(t7, v, rop->m_x);
		//t8 = S1*J
		fpe_mul(t8, s1, j);
		//t9 = 2*t8
		fpe_add(t9, t8, t8);
		//t10 = r*t7
		fpe_mul(t10, r, t7);
		//Y3 = t10-t9
		fpe_sub(rop->m_y, t10, t9);
		fpe_short_coeffred(rop->m_y);
		//t11 = Z1+Z2
		fpe_add(t11, op1->m_z, op2->m_z);
		//t12 = t11^2
		fpe_short_coeffred(t11);
		fpe_square(t12, t11);
		//t13 = t12-Z1Z1
		fpe_sub(t13, t12, z1z1);
		//t14 = t13-Z2Z2
		fpe_sub(t14, t13, z2z2);
		//Z3 = t14*H
		fpe_mul(rop->m_z, t14, h);
		fpe_short_coeffred(rop->m_z);
	}
}

static void curvepoint_fp_add_nocheck(curvepoint_fp_t rop, const curvepoint_fp_t op1, const curvepoint_fp_t op2)
{
	//See http://www.hyperelliptic.org/EFD/g1p/auto-code/shortw/jacobian-0/addition/add-2007-bl.op3
	fpe_t z1z1, z2z2, r, v, s1, s2, u1, u2, h, i, j, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14;
	//Z1Z1 = Z1^2
	fpe_square(z1z1, op1->m_z);
	//Z2Z2 = Z2^2
	fpe_square(z2z2, op2->m_z);
	//U1 = X1*Z2Z2
	fpe_mul(u1, op1->m_x, z2z2);
	//U2 = X2*Z1Z1
	fpe_mul(u2, op2->m_x, z1z1);
	//t0 = Z2*Z2Z2
	fpe_mul(t0, op2->m_z, z2z2);
	//S1 = Y1*t0
	fpe_mul(s1, op1->m_y, t0);
	//t1 = Z1*Z1Z1
	fpe_mul(t1, op1->m_z, z1z1);
	//S2 = Y2*t1
	fpe_mul(s2, op2->m_y, t1);
	//H = U2-U1
	fpe_sub(h, u2, u1);
	//t2 = 2*H
	fpe_add(t2, h, h);
	//I = t2^2
	fpe_short_coeffred(t2);
	fpe_square(i, t2);
	//J = H*I
	fpe_mul(j, h, i);
	//t3 = S2-S1
	fpe_sub(t3, s2, s1);
	//r = 2*t3
	fpe_add(r, t3, t3);
	//V = U1*I
	fpe_mul(v, u1, i);
	//t4 = r^2
	fpe_short_coeffred(r);
	fpe_square(t4, r);
	//t5 = 2*V
	fpe_add(t5, v, v);
	//t6 = t4-J
	fpe_sub(t6, t4, j);
	//X3 = t6-t5
	fpe_sub(rop->m_x, t6, t5);
	fpe_short_coeffred(rop->m_x);
	//t7 = V-X3
	fpe_sub(t7, v, rop->m_x);
	//t8 = S1*J
	fpe_mul(t8, s1, j);
	//t9 = 2*t8
	fpe_add(t9, t8, t8);
	//t10 = r*t7
	fpe_mul(t10, r, t7);
	//Y3 = t10-t9
	fpe_sub(rop->m_y, t10, t9);
	fpe_short_coeffred(rop->m_y);
	//t11 = Z1+Z2
	fpe_add(t11, op1->m_z, op2->m_z);
	//t12 = t11^2
	fpe_short_coeffred(t11);
	fpe_square(t12, t11);
	//t13 = t12-Z1Z1
	fpe_sub(t13, t12, z1z1);
	//t14 = t13-Z2Z2
	fpe_sub(t14, t13, z2z2);
	//Z3 = t14*H
	fpe_mul(rop->m_z, t14, h);
	fpe_short_coeffred(rop->m_z);
}

/*
void curvepoint_fp_scalarmult_vartime_old(curvepoint_fp_t rop, const curvepoint_fp_t op, const scalar_t scalar, const unsigned int scalar_bitsize)
{
	size_t i;
	curvepoint_fp_t r;
	curvepoint_fp_set(r, op);
	for(i = scalar_bitsize-1; i > 0; i--)
	{
		curvepoint_fp_double(r, r);
		if(scalar_getbit(scalar, i - 1)) 
			curvepoint_fp_mixadd(r, r, op);
	}
	curvepoint_fp_set(rop, r);
}
*/

static void choose_t(curvepoint_fp_t t, struct curvepoint_fp_struct *pre, signed char b)
{
	if (b > 0)
		*t = pre[b - 1];
	else {
		*t = pre[-b - 1];
		curvepoint_fp_neg(t, t);
	}
}

void curvepoint_fp_scalarmult_vartime(curvepoint_fp_t rop, const curvepoint_fp_t op, const scalar_t scalar)
{
	signed char s[65];
	int i;
	curvepoint_fp_t t;
	struct curvepoint_fp_struct pre[8];
	scalar_window4(s, scalar);
	/*
  for(i=0;i<64;i++)
    printf("%d ",s[i]);
  printf("\n");
  */

	pre[0] = *op;                                         //  P
	curvepoint_fp_double(&pre[1], &pre[0]);               // 2P
	curvepoint_fp_add_nocheck(&pre[2], &pre[0], &pre[1]); // 3P
	curvepoint_fp_double(&pre[3], &pre[1]);               // 4P
	curvepoint_fp_add_nocheck(&pre[4], &pre[0], &pre[3]); // 5P
	curvepoint_fp_double(&pre[5], &pre[2]);               // 6P
	curvepoint_fp_add_nocheck(&pre[6], &pre[0], &pre[5]); // 7P
	curvepoint_fp_double(&pre[7], &pre[3]);               // 8P

	i = 64;
	while (!s[i] && i > 0)
		i--;

	if (!s[i])
		curvepoint_fp_setneutral(rop);
	else {
		choose_t(rop, pre, s[i]);
		i--;
		for (; i >= 0; i--) {
			curvepoint_fp_double(rop, rop);
			curvepoint_fp_double(rop, rop);
			curvepoint_fp_double(rop, rop);
			curvepoint_fp_double(rop, rop);
			if (s[i]) {
				choose_t(t, pre, s[i]);
				curvepoint_fp_add_nocheck(rop, rop, t);
			}
		}
	}
}

// Negate a point, store in rop:
void curvepoint_fp_neg(curvepoint_fp_t rop, const curvepoint_fp_t op)
{
	fpe_t tfpe1;
	fpe_set(rop->m_x, op->m_x);
	fpe_neg(rop->m_y, op->m_y);
	fpe_set(rop->m_z, op->m_z);
}

// Transform to Affine Coordinates (z=1)
void curvepoint_fp_makeaffine(curvepoint_fp_t point)
{
	fpe_t tfpe1;
	fpe_invert(tfpe1, point->m_z);
	fpe_mul(point->m_x, point->m_x, tfpe1);
	fpe_mul(point->m_x, point->m_x, tfpe1);

	fpe_mul(point->m_y, point->m_y, tfpe1);
	fpe_mul(point->m_y, point->m_y, tfpe1);
	fpe_mul(point->m_y, point->m_y, tfpe1);

	fpe_setone(point->m_z);
}

// Print a point:
void curvepoint_fp_print(FILE *outfile, const curvepoint_fp_t point)
{
	fprintf(outfile, "[");
	fpe_print(outfile, point->m_x);
	fprintf(outfile, ", ");
	fpe_print(outfile, point->m_y);
	fprintf(outfile, ", ");
	fpe_print(outfile, point->m_z);
	fprintf(outfile, "]");
}

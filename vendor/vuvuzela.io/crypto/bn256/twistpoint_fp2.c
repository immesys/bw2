/*
 * File:   dclxvi-20130329/twistpoint_fp2.c
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#include "twistpoint_fp2.h"
#include "fpe.h"
#include <stdio.h>
#include <stdlib.h>

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//            Point initialization and deletion functions
//////////////////////////////////////////////////////////////////////////////////////////////////////////

// Global dummies usable by all curvepoints:

// Set the coordinates of a twistpoint_fp2_t by copying the coordinates from another twistpoint_fp2
void twistpoint_fp2_set(twistpoint_fp2_t rop, const twistpoint_fp2_t op)
{
	fp2e_set(rop->m_x, op->m_x);
	fp2e_set(rop->m_y, op->m_y);
	fp2e_set(rop->m_z, op->m_z);
	fp2e_setzero(rop->m_t);
}

void twistpoint_fp2_setneutral(twistpoint_fp2_t rop)
{
	fp2e_setone(rop->m_x);
	fp2e_setone(rop->m_y);
	fp2e_setzero(rop->m_z);
	fp2e_setzero(rop->m_t);
}

// Addition of two points, op2 is assumed to be in affine coordinates
// For the algorithm see e.g. DA Peter Schwabe
/*
void twistpoint_fp2_mixadd(twistpoint_fp2_t rop, const twistpoint_fp2_t op1, const twistpoint_fp2_t op2)
{
	fp2e_t tfpe1, tfpe2, tfpe3, tfpe4, tfpe5, tfpe6, tfpe7, tfpe8, tfpe9; // Temporary variables needed for intermediary results
	fp2e_square(tfpe1, op1->m_z);
	fp2e_mul(tfpe2, op1->m_z, tfpe1);
	fp2e_mul(tfpe3, op2->m_x, tfpe1);
	fp2e_mul(tfpe4, op2->m_y, tfpe2);
	fp2e_sub(tfpe5, tfpe3, op1->m_x);
  fp2e_short_coeffred(tfpe5);
	fp2e_sub(tfpe6, tfpe4, op1->m_y);
	fp2e_square(tfpe7, tfpe5);
	fp2e_mul(tfpe8, tfpe7, tfpe5);
	fp2e_mul(tfpe9, op1->m_x, tfpe7);

	fp2e_double(tfpe1, tfpe9);
	fp2e_add(tfpe1, tfpe1, tfpe8);
	fp2e_square(rop->m_x, tfpe6);
	fp2e_sub(rop->m_x, rop->m_x, tfpe1);
  fp2e_short_coeffred(rop->m_x);
	fp2e_sub(tfpe1, tfpe9, rop->m_x);
	fp2e_mul(tfpe2, tfpe1, tfpe6);
	fp2e_mul(tfpe3, op1->m_y, tfpe8);
	fp2e_sub(rop->m_y, tfpe2, tfpe3);
  fp2e_short_coeffred(rop->m_y);
	fp2e_mul(rop->m_z, op1->m_z, tfpe5);
}
*/

void twistpoint_fp2_double(twistpoint_fp2_t rop, const twistpoint_fp2_t op)
{
	fp2e_t tfpe1, tfpe2, tfpe3, tfpe4; // Temporary variables needed for intermediary results
	fp2e_square(tfpe1, op->m_y);
	fp2e_mul(tfpe2, tfpe1, op->m_x);
	fp2e_double(tfpe2, tfpe2);
	fp2e_double(tfpe2, tfpe2);
	fp2e_square(tfpe3, tfpe1);
	fp2e_double(tfpe3, tfpe3);
	fp2e_double(tfpe3, tfpe3);
	fp2e_double(tfpe3, tfpe3);
	fp2e_square(tfpe4, op->m_x);
	fp2e_triple(tfpe4, tfpe4);
	fp2e_short_coeffred(tfpe4);
	fp2e_square(rop->m_x, tfpe4);
	fp2e_double(tfpe1, tfpe2);
	fp2e_sub(rop->m_x, rop->m_x, tfpe1);
	fp2e_short_coeffred(rop->m_x);
	fp2e_sub(tfpe1, tfpe2, rop->m_x);
	fp2e_short_coeffred(tfpe1);
	fp2e_mul(rop->m_z, op->m_y, op->m_z);
	fp2e_double(rop->m_z, rop->m_z);
	fp2e_mul(rop->m_y, tfpe4, tfpe1);
	fp2e_sub(rop->m_y, rop->m_y, tfpe3);
	fp2e_short_coeffred(rop->m_y);
}

void twistpoint_fp2_add_vartime(twistpoint_fp2_t rop, const twistpoint_fp2_t op1, const twistpoint_fp2_t op2)
{
	if (fp2e_iszero(op1->m_z))
		twistpoint_fp2_set(rop, op2);
	else if (fp2e_iszero(op2->m_z))
		twistpoint_fp2_set(rop, op1);
	else {
		//See http://www.hyperelliptic.org/EFD/g1p/auto-code/shortw/jacobian-0/addition/add-2007-bl.op3
		fp2e_t z1z1, z2z2, r, v, s1, s2, u1, u2, h, i, j, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14;
		//Z1Z1 = Z1^2
		fp2e_square(z1z1, op1->m_z);
		//Z2Z2 = Z2^2
		fp2e_square(z2z2, op2->m_z);
		//U1 = X1*Z2Z2
		fp2e_mul(u1, op1->m_x, z2z2);
		//U2 = X2*Z1Z1
		fp2e_mul(u2, op2->m_x, z1z1);
		//t0 = Z2*Z2Z2
		fp2e_mul(t0, op2->m_z, z2z2);
		//S1 = Y1*t0
		fp2e_mul(s1, op1->m_y, t0);
		//t1 = Z1*Z1Z1
		fp2e_mul(t1, op1->m_z, z1z1);
		//S2 = Y2*t1
		fp2e_mul(s2, op2->m_y, t1);
		if (fp2e_iseq(u1, u2)) {
			if (fp2e_iseq(s1, s2))
				twistpoint_fp2_double(rop, op1);
			else
				twistpoint_fp2_setneutral(rop);
		}
		//H = U2-U1
		fp2e_sub(h, u2, u1);
		//t2 = 2*H
		fp2e_add(t2, h, h);
		//I = t2^2
		fp2e_short_coeffred(t2);
		fp2e_square(i, t2);
		//J = H*I
		fp2e_mul(j, h, i);
		//t3 = S2-S1
		fp2e_sub(t3, s2, s1);
		//r = 2*t3
		fp2e_add(r, t3, t3);
		//V = U1*I
		fp2e_mul(v, u1, i);
		//t4 = r^2
		fp2e_short_coeffred(r);
		fp2e_square(t4, r);
		//t5 = 2*V
		fp2e_add(t5, v, v);
		//t6 = t4-J
		fp2e_sub(t6, t4, j);
		//X3 = t6-t5
		fp2e_sub(rop->m_x, t6, t5);
		fp2e_short_coeffred(rop->m_x);
		//t7 = V-X3
		fp2e_sub(t7, v, rop->m_x);
		//t8 = S1*J
		fp2e_mul(t8, s1, j);
		//t9 = 2*t8
		fp2e_add(t9, t8, t8);
		//t10 = r*t7
		fp2e_mul(t10, r, t7);
		//Y3 = t10-t9
		fp2e_sub(rop->m_y, t10, t9);
		fp2e_short_coeffred(rop->m_y);
		//t11 = Z1+Z2
		fp2e_add(t11, op1->m_z, op2->m_z);
		//t12 = t11^2
		fp2e_short_coeffred(t11);
		fp2e_square(t12, t11);
		//t13 = t12-Z1Z1
		fp2e_sub(t13, t12, z1z1);
		//t14 = t13-Z2Z2
		fp2e_sub(t14, t13, z2z2);
		//Z3 = t14*H
		fp2e_short_coeffred(t14);
		fp2e_mul(rop->m_z, t14, h);
		fp2e_short_coeffred(rop->m_z);
	}
}

static void twistpoint_fp2_add_nocheck(twistpoint_fp2_t rop, const twistpoint_fp2_t op1, const twistpoint_fp2_t op2)
{
	//See http://www.hyperelliptic.org/EFD/g1p/auto-code/shortw/jacobian-0/addition/add-2007-bl.op3
	fp2e_t z1z1, z2z2, r, v, s1, s2, u1, u2, h, i, j, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14;
	//Z1Z1 = Z1^2
	fp2e_square(z1z1, op1->m_z);
	//Z2Z2 = Z2^2
	fp2e_square(z2z2, op2->m_z);
	//U1 = X1*Z2Z2
	fp2e_mul(u1, op1->m_x, z2z2);
	//U2 = X2*Z1Z1
	fp2e_mul(u2, op2->m_x, z1z1);
	//t0 = Z2*Z2Z2
	fp2e_mul(t0, op2->m_z, z2z2);
	//S1 = Y1*t0
	fp2e_mul(s1, op1->m_y, t0);
	//t1 = Z1*Z1Z1
	fp2e_mul(t1, op1->m_z, z1z1);
	//S2 = Y2*t1
	fp2e_mul(s2, op2->m_y, t1);
	//H = U2-U1
	fp2e_sub(h, u2, u1);
	//t2 = 2*H
	fp2e_add(t2, h, h);
	//I = t2^2
	fp2e_short_coeffred(t2);
	fp2e_square(i, t2);
	//J = H*I
	fp2e_mul(j, h, i);
	//t3 = S2-S1
	fp2e_sub(t3, s2, s1);
	//r = 2*t3
	fp2e_add(r, t3, t3);
	//V = U1*I
	fp2e_mul(v, u1, i);
	//t4 = r^2
	fp2e_short_coeffred(r);
	fp2e_square(t4, r);
	//t5 = 2*V
	fp2e_add(t5, v, v);
	//t6 = t4-J
	fp2e_sub(t6, t4, j);
	//X3 = t6-t5
	fp2e_sub(rop->m_x, t6, t5);
	fp2e_short_coeffred(rop->m_x);
	//t7 = V-X3
	fp2e_sub(t7, v, rop->m_x);
	//t8 = S1*J
	fp2e_mul(t8, s1, j);
	//t9 = 2*t8
	fp2e_add(t9, t8, t8);
	//t10 = r*t7
	fp2e_mul(t10, r, t7);
	//Y3 = t10-t9
	fp2e_sub(rop->m_y, t10, t9);
	fp2e_short_coeffred(rop->m_y);
	//t11 = Z1+Z2
	fp2e_add(t11, op1->m_z, op2->m_z);
	//t12 = t11^2
	fp2e_short_coeffred(t11);
	fp2e_square(t12, t11);
	//t13 = t12-Z1Z1
	fp2e_sub(t13, t12, z1z1);
	//t14 = t13-Z2Z2
	fp2e_sub(t14, t13, z2z2);
	//Z3 = t14*H
	fp2e_short_coeffred(h);
	fp2e_mul(rop->m_z, t14, h);
	fp2e_short_coeffred(rop->m_z);
}

/*
void twistpoint_fp2_scalarmult_vartime_old(twistpoint_fp2_t rop, const twistpoint_fp2_t op, const scalar_t scalar, const unsigned int scalar_bitsize)
{
	size_t i;
	twistpoint_fp2_t r;
	twistpoint_fp2_set(r, op);
	for(i = scalar_bitsize-1; i > 0; i--)
	{
		twistpoint_fp2_double(r, r);
		if(scalar_getbit(scalar, i - 1)) 
			twistpoint_fp2_mixadd(r, r, op);
	}
	twistpoint_fp2_set(rop, r);
}
*/

static void choose_t(twistpoint_fp2_t t, struct twistpoint_fp2_struct *pre, signed char b)
{
	if (b > 0)
		*t = pre[b - 1];
	else {
		*t = pre[-b - 1];
		twistpoint_fp2_neg(t, t);
	}
}

void twistpoint_fp2_scalarmult_vartime(twistpoint_fp2_t rop, const twistpoint_fp2_t op, const scalar_t scalar)
{
	signed char s[65];
	int i;
	twistpoint_fp2_t t;
	struct twistpoint_fp2_struct pre[8];
	scalar_window4(s, scalar);
	/*
  for(i=0;i<64;i++)
    printf("%d ",s[i]);
  printf("\n");
  */

	pre[0] = *op;                                          //  P
	twistpoint_fp2_double(&pre[1], &pre[0]);               // 2P
	twistpoint_fp2_add_nocheck(&pre[2], &pre[0], &pre[1]); // 3P
	twistpoint_fp2_double(&pre[3], &pre[1]);               // 4P
	twistpoint_fp2_add_nocheck(&pre[4], &pre[0], &pre[3]); // 5P
	twistpoint_fp2_double(&pre[5], &pre[2]);               // 6P
	twistpoint_fp2_add_nocheck(&pre[6], &pre[0], &pre[5]); // 7P
	twistpoint_fp2_double(&pre[7], &pre[3]);               // 8P

	i = 64;
	while (!s[i] && i > 0)
		i--;

	if (!s[i])
		twistpoint_fp2_setneutral(rop);
	else {
		choose_t(rop, pre, s[i]);
		i--;
		for (; i >= 0; i--) {
			twistpoint_fp2_double(rop, rop);
			twistpoint_fp2_double(rop, rop);
			twistpoint_fp2_double(rop, rop);
			twistpoint_fp2_double(rop, rop);
			if (s[i]) {
				choose_t(t, pre, s[i]);
				twistpoint_fp2_add_nocheck(rop, rop, t);
			}
		}
	}
}

// Negate a point, store in rop:
void twistpoint_fp2_neg(twistpoint_fp2_t rop, const twistpoint_fp2_t op)
{
	fp2e_t tfpe1;
	fp2e_neg(tfpe1, op->m_y);
	fp2e_set(rop->m_x, op->m_x);
	fp2e_set(rop->m_y, tfpe1);
	fp2e_set(rop->m_z, op->m_z);
}

void twistpoint_fp2_set_fp2e(twistpoint_fp2_t rop, const fp2e_t x, const fp2e_t y, const fp2e_t z)
{
	fp2e_set(rop->m_x, x);
	fp2e_set(rop->m_y, y);
	fp2e_set(rop->m_z, z);
	fp2e_setzero(rop->m_t);
}

void twistpoint_fp2_affineset_fp2e(twistpoint_fp2_t rop, const fp2e_t x, const fp2e_t y)
{
	fp2e_set(rop->m_x, x);
	fp2e_set(rop->m_y, y);
	fp2e_setone(rop->m_z);
	fp2e_setzero(rop->m_t);
}

// Transform to Affine Coordinates (z=1)
void twistpoint_fp2_makeaffine(twistpoint_fp2_t point)
{
	fp2e_t tfpe1;
	fp2e_invert(tfpe1, point->m_z);
	fp2e_mul(point->m_x, point->m_x, tfpe1);
	fp2e_mul(point->m_x, point->m_x, tfpe1);

	fp2e_mul(point->m_y, point->m_y, tfpe1);
	fp2e_mul(point->m_y, point->m_y, tfpe1);
	fp2e_mul(point->m_y, point->m_y, tfpe1);

	fp2e_setone(point->m_z);
}

// Print a point:
void twistpoint_fp2_print(FILE *outfile, const twistpoint_fp2_t point)
{
	fprintf(outfile, "[");
	fp2e_print(outfile, point->m_x);
	fprintf(outfile, ", ");
	fp2e_print(outfile, point->m_y);
	fprintf(outfile, ", ");
	fp2e_print(outfile, point->m_z);
	fprintf(outfile, "]");
}

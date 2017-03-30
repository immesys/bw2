/*
 * File:   dclxvi-20130329/mul.c
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#include "mul.h"
#include "mydouble.h"
#include <math.h>

extern const double bn_v;
extern const double bn_v6;

void polymul(mydouble *h, const mydouble *f, const mydouble *g)
{
	mydouble t[24];
	t[0] = f[0] * g[0];
	t[1] = f[0] * g[1] + f[1] * g[0];
	t[2] = 6 * f[1] * g[1] + (f[0] * g[2] + f[2] * g[0]);
	t[3] = (f[1] * g[2] + f[2] * g[1]) * 6 + (f[0] * g[3] + f[3] * g[0]);
	t[4] = (f[1] * g[3] + f[2] * g[2] + f[3] * g[1]) * 6 + (f[0] * g[4] + f[4] * g[0]);
	t[5] = (f[1] * g[4] + f[2] * g[3] + f[3] * g[2] + f[4] * g[1]) * 6 + (f[0] * g[5] + f[5] * g[0]);
	t[6] = (f[1] * g[5] + f[2] * g[4] + f[3] * g[3] + f[4] * g[2] + f[5] * g[1]) * 6 + f[0] * g[6] + f[6] * g[0];
	t[7] = (f[0] * g[7] + f[1] * g[6] + f[2] * g[5] + f[3] * g[4] + f[4] * g[3] + f[5] * g[2] + f[6] * g[1] + f[7] * g[0]);
	t[8] = (f[1] * g[7] + f[7] * g[1]) * 6 + (f[0] * g[8] + f[2] * g[6] + f[3] * g[5] + f[4] * g[4] + f[5] * g[3] + f[6] * g[2] + f[8] * g[0]);
	t[9] = (f[1] * g[8] + f[2] * g[7] + f[7] * g[2] + f[8] * g[1]) * 6 + (f[0] * g[9] + f[3] * g[6] + f[4] * g[5] + f[5] * g[4] + f[6] * g[3] + f[9] * g[0]);
	t[10] = (f[1] * g[9] + f[2] * g[8] + f[3] * g[7] + f[7] * g[3] + f[8] * g[2] + f[9] * g[1]) * 6 + (f[0] * g[10] + f[4] * g[6] + f[5] * g[5] + f[6] * g[4] + f[10] * g[0]);
	t[11] = (f[1] * g[10] + f[2] * g[9] + f[3] * g[8] + f[4] * g[7] + f[7] * g[4] + f[8] * g[3] + f[9] * g[2] + f[10] * g[1]) * 6 + (f[0] * g[11] + f[5] * g[6] + f[6] * g[5] + f[11] * g[0]);
	t[12] = (f[1] * g[11] + f[2] * g[10] + f[3] * g[9] + f[4] * g[8] + f[5] * g[7] + f[7] * g[5] + f[8] * g[4] + f[9] * g[3] + f[10] * g[2] + f[11] * g[1]) * 6 + f[6] * g[6];
	t[13] = (f[2] * g[11] + f[3] * g[10] + f[4] * g[9] + f[5] * g[8] + f[6] * g[7] + f[7] * g[6] + f[8] * g[5] + f[9] * g[4] + f[10] * g[3] + f[11] * g[2]);
	t[14] = f[7] * g[7] * 6 + (f[3] * g[11] + f[4] * g[10] + f[5] * g[9] + f[6] * g[8] + f[8] * g[6] + f[9] * g[5] + f[10] * g[4] + f[11] * g[3]);
	t[15] = (f[7] * g[8] + f[8] * g[7]) * 6 + (f[4] * g[11] + f[5] * g[10] + f[6] * g[9] + f[9] * g[6] + f[10] * g[5] + f[11] * g[4]);
	t[16] = (f[7] * g[9] + f[8] * g[8] + f[9] * g[7]) * 6 + (f[5] * g[11] + f[6] * g[10] + f[10] * g[6] + f[11] * g[5]);
	t[17] = (f[7] * g[10] + f[8] * g[9] + f[9] * g[8] + f[10] * g[7]) * 6 + (f[6] * g[11] + f[11] * g[6]);
	t[18] = (f[7] * g[11] + f[8] * g[10] + f[9] * g[9] + f[10] * g[8] + f[11] * g[7]) * 6;
	t[19] = (f[8] * g[11] + f[9] * g[10] + f[10] * g[9] + f[11] * g[8]);
	t[20] = (f[9] * g[11] + f[10] * g[10] + f[11] * g[9]);
	t[21] = (f[10] * g[11] + f[11] * g[10]);
	t[22] = f[11] * g[11];
	int i;
	for (i = 0; i < 23; i++)
		h[i] = t[i];
}

void degred(mydouble *h)
{
	h[0] = h[0] - h[12] + 6 * h[15] - 2 * h[18] - 6 * h[21];
	h[1] = h[1] - h[13] + h[16] - 2 * h[19] - h[22];
	h[2] = h[2] - h[14] + h[17] - 2 * h[20];
	h[3] = h[3] - h[12] + 5 * h[15] - h[18] - 8 * h[21];
	h[4] = h[4] - 6 * h[13] + 5 * h[16] - 6 * h[19] - 8 * h[22];
	h[5] = h[5] - 6 * h[14] + 5 * h[17] - 6 * h[20];
	h[6] = h[6] - 4 * h[12] + 18 * h[15] - 3 * h[18];
	h[6] -= 30 * h[21];
	h[7] = h[7] - 4 * h[13] + 3 * h[16] - 3 * h[19] - 5 * h[22];
	h[8] = h[8] - 4 * h[14] + 3 * h[17] - 3 * h[20];
	h[9] = h[9] - h[12] + 2 * h[15] + h[18] - 9 * h[21];
	h[10] = h[10] - 6 * h[13] + 2 * h[16] + 6 * h[19] - 9 * h[22];
	h[11] = h[11] - 6 * h[14] + 2 * h[17] + 6 * h[20];
}

void coeffred_round_par(mydouble *h)
{
	mydouble carry = 0;

	carry = round(h[1] / bn_v);
	h[1] = remround(h[1], bn_v);
	h[2] += carry;
	carry = round(h[4] / bn_v);
	h[4] = remround(h[4], bn_v);
	h[5] += carry;
	carry = round(h[7] / bn_v);
	h[7] = remround(h[7], bn_v);
	h[8] += carry;
	carry = round(h[10] / bn_v);
	h[10] = remround(h[10], bn_v);
	h[11] += carry;

	carry = round(h[2] / bn_v);
	h[2] = remround(h[2], bn_v);
	h[3] += carry;
	carry = round(h[5] / bn_v);
	h[5] = remround(h[5], bn_v);
	h[6] += carry;
	carry = round(h[8] / bn_v);
	h[8] = remround(h[8], bn_v);
	h[9] += carry;
	carry = round(h[11] / bn_v);
	h[11] = remround(h[11], bn_v);

	h[0] = h[0] - carry;
	h[3] = h[3] - carry;
	h[6] = h[6] - 4 * carry;
	h[9] = h[9] - carry;

	carry = round(h[0] / bn_v6);  // h0 = 2^53 - 1
	h[0] = remround(h[0], bn_v6); // carry = (2^53-1)/6v = 763549741
	h[1] += carry;                // h1 = v+763549741 = 765515821
	carry = round(h[3] / bn_v);   // h3 = 2^53 - 1
	h[3] = remround(h[3], bn_v);  // carry = (2^53-1)/v = 4581298449
	h[4] += carry;                // h4 = v + 4581298449 = 4583264529
	carry = round(h[6] / bn_v6);
	h[6] = remround(h[6], bn_v6);
	h[7] += carry;
	carry = round(h[9] / bn_v);
	h[9] = remround(h[9], bn_v);
	h[10] += carry;

	carry = round(h[1] / bn_v); // carry = 765515821/v = 389
	h[1] = remround(h[1], bn_v);
	h[2] += carry;
	carry = round(h[4] / bn_v); // carry = 4583264529/v = 2331
	h[4] = remround(h[4], bn_v);
	h[5] += carry;
	carry = round(h[7] / bn_v);
	h[7] = remround(h[7], bn_v);
	h[8] += carry;
	carry = round(h[10] / bn_v);
	h[10] = remround(h[10], bn_v);
	h[11] += carry;
}

/*
 * File:   dclxvi-20130329/scalar.c
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#include "scalar.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

void scalar_setrandom(scalar_t rop, const scalar_t bound)
{
	int i;
	FILE *urand = fopen("/dev/urandom", "r");
	if (urand == NULL) {
		fprintf(stderr, "Could not open device file /dev/urandom");
		exit(1);
	}
	do {
		for (i = 0; i < 32; i++)
			i[(unsigned char *)rop] = fgetc(urand);
	} while (!scalar_lt_vartime(rop, bound));
	fclose(urand);
}

void scalar_set_lluarray(scalar_t rop, unsigned long long v[4])
{
	int i;
	for (i = 0; i < 4; i++)
		rop[i] = v[i];
}

int scalar_getbit(const scalar_t s, unsigned int pos)
{
	assert(pos < 256);
	return (s[pos >> 6] >> (pos & 0x3f)) & 1;
}

// Returns the position of the most significant set bit
int scalar_scanb(const scalar_t s)
{
	int i;
	unsigned int pos = 0;
	for (i = 255; i > 0; i--)
		if (scalar_getbit(s, i) && pos == 0)
			pos = i;
	return pos;
}

int scalar_iszero_vartime(const scalar_t s)
{
	return ((s[0] | s[1] | s[2] | s[3]) == 0);
}

void scalar_window4(signed char r[65], const scalar_t s)
{
	char carry;
	int i;
	for (i = 0; i < 16; i++)
		r[i] = (s[0] >> (4 * i)) & 15;
	for (i = 0; i < 16; i++)
		r[i + 16] = (s[1] >> (4 * i)) & 15;
	for (i = 0; i < 16; i++)
		r[i + 32] = (s[2] >> (4 * i)) & 15;
	for (i = 0; i < 16; i++)
		r[i + 48] = (s[3] >> (4 * i)) & 15;

	/* Making it signed */
	carry = 0;
	for (i = 0; i < 64; i++) {
		r[i] += carry;
		r[i + 1] += r[i] >> 4;
		r[i] &= 15;
		carry = r[i] >> 3;
		r[i] -= carry << 4;
	}
	r[64] = carry;
}

// Returns 1 if a < b, 0 otherwise
int scalar_lt_vartime(const scalar_t a, const scalar_t b)
{
	if (a[3] < b[3])
		return 1;
	if (a[3] > b[3])
		return 0;
	if (a[2] < b[2])
		return 1;
	if (a[2] > b[2])
		return 0;
	if (a[1] < b[1])
		return 1;
	if (a[1] > b[1])
		return 0;
	if (a[0] < b[0])
		return 1;
	if (a[0] > b[0])
		return 0;
	return 0;
}

void scalar_print(FILE *fh, const scalar_t t)
{
	int i;
	for (i = 3; i >= 0; i--)
		fprintf(fh, "%llx", t[i]);
}

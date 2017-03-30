/*
 * File:   dclxvi-20130329/checkdouble.h
 * Author: Ruben Niederhagen, Peter Schwabe
 * Public Domain
 */

#ifndef CHECKDOUBLE_H
#define CHECKDOUBLE_H

#include <execinfo.h>
#include <inttypes.h>
#include <math.h>
#include <memory.h>
#include <stdio.h>
#include <stdlib.h>

#define MANTISSA_MAX ((1ULL << 53) - 1)

class CheckDouble
{
      public:
	double v;
	unsigned long long mmax;

	CheckDouble()
	{
		v = NAN;
		mmax = MANTISSA_MAX;
	}

	CheckDouble(const double a)
	{
		v = a;
		mmax = (unsigned long long)fabs(a);
	}

	CheckDouble(const CheckDouble &a)
	{
		v = a.v;
		mmax = a.mmax;
	}

	CheckDouble(const double a, const unsigned long long int mmax)
	{
		v = a;
		this->mmax = mmax;
	}

	CheckDouble operator=(const CheckDouble &a)
	{
		v = a.v;
		mmax = a.mmax;
		return *this;
	}

	int operator==(const CheckDouble &a) const
	{
		return v == a.v;
	}

	int operator!=(const CheckDouble &a) const
	{
		return v != a.v;
	}

	CheckDouble operator+(const CheckDouble &a) const
	{
		if ((mmax + a.mmax) > MANTISSA_MAX) {
			fprintf(stderr, "Overflow in %lf + %lf\n", v, a.v);
			fprintf(stderr, "Maximal values: %llu, %llu\n", mmax, a.mmax);
			abort();
		}
		return CheckDouble(a.v + v, mmax + a.mmax);
	}

	CheckDouble operator+=(const CheckDouble &a)
	{
		if ((mmax + a.mmax) > MANTISSA_MAX) {
			fprintf(stderr, "Overflow in %lf += %lf\n", v, a.v);
			fprintf(stderr, "Maximal values: %llu, %llu\n", mmax, a.mmax);
			abort();
		}
		v += a.v;
		mmax += a.mmax;
		return *this;
	}

	CheckDouble operator-(const CheckDouble &a) const
	{
		if ((mmax + a.mmax) > MANTISSA_MAX) {
			fprintf(stderr, "Overflow in %lf - %lf\n", v, a.v);
			fprintf(stderr, "Maximal values: %llu, %llu\n", mmax, a.mmax);
			abort();
		}
		return CheckDouble(v - a.v, mmax + a.mmax);
	}

	CheckDouble operator-=(const CheckDouble &a)
	{
		if ((mmax + a.mmax) > MANTISSA_MAX) {
			fprintf(stderr, "Overflow in %lf += %lf\n", v, a.v);
			fprintf(stderr, "Maximal values: %llu, %llu\n", mmax, a.mmax);
			abort();
		}
		v -= a.v;
		mmax += a.mmax;
		return *this;
	}

	CheckDouble operator-() const
	{
		return CheckDouble(-v, mmax);
	}

	CheckDouble operator*(const CheckDouble &a) const
	{
		uint64_t l1 = mmax & 0xffffffff;
		uint64_t l2 = a.mmax & 0xffffffff;
		uint64_t u1 = mmax >> 32;
		uint64_t u2 = a.mmax >> 32;
		unsigned long long upper = u1 * u2;
		if (upper != 0) {
			fprintf(stderr, "Overflow in %lf * %lf\n", v, a.v);
			fprintf(stderr, "Maximal values: %llu, %llu\n", mmax, a.mmax);
			abort();
		}
		unsigned long long mid = l1 * u2 + u1 * l2;
		unsigned long long lower = l1 * l2;
		if (lower >= MANTISSA_MAX) {
			fprintf(stderr, "Overflow in %lf * %lf\n", v, a.v);
			fprintf(stderr, "Maximal values: %llu, %llu\n", mmax, a.mmax);
			abort();
		}
		if (mid > (MANTISSA_MAX >> 32)) {
			fprintf(stderr, "Overflow in %lf * %lf\n", v, a.v);
			fprintf(stderr, "Maximal values: %llu, %llu\n", mmax, a.mmax);
			abort();
		}
		lower += (mid << 32);
		if (lower > MANTISSA_MAX) {
			fprintf(stderr, "Overflow in %lf * %lf\n", v, a.v);
			fprintf(stderr, "Maximal values: %llu, %llu\n", mmax, a.mmax);
			abort();
		}
		return CheckDouble(v * a.v, mmax * a.mmax);
	}

	CheckDouble operator/(const double &a) const
	{
		if (mmax / fabs(a) > MANTISSA_MAX) {
			fprintf(stderr, "Overflow in %lf / %lf\n", v, a);
			fprintf(stderr, "Maximal values: %llu, %lf\n", mmax, a);
			abort();
		}
		return CheckDouble(v / a, mmax / (unsigned long long)fabs(a) + 1);
	}

	CheckDouble operator*=(const int b)
	{
		CheckDouble op((double)b, abs(b));
		*this = *this * op;
		return *this;
	}

	/*
          friend CheckDouble operator*(const CheckDouble &a,const int b) 
          {
            CheckDouble op((double) b, abs(b));
            return op * a;
          }
          */

	friend CheckDouble operator*(const int32_t b, const CheckDouble &a)
	{
		CheckDouble op((double)b, abs(b));
		return op * a;
	}

	friend int operator<(const CheckDouble &op1, const CheckDouble &op2)
	{
		return op1.v < op2.v;
	}

	friend int operator<=(const CheckDouble &op1, const CheckDouble &op2)
	{
		return op1.v <= op2.v;
	}

	friend int operator>(const CheckDouble &op1, const CheckDouble &op2)
	{
		return op1.v > op2.v;
	}

	friend int operator>=(const CheckDouble &op1, const CheckDouble &op2)
	{
		return op1.v >= op2.v;
	}

	friend CheckDouble round(const CheckDouble &a)
	{
		return CheckDouble(round(a.v), a.mmax);
	}

	friend CheckDouble trunc(const CheckDouble &a)
	{
		return CheckDouble(trunc(a.v), a.mmax);
	}

	friend CheckDouble remround(const CheckDouble &a, const double d)
	{
		double carry = round(a.v / d);
		return CheckDouble(a.v - carry * d, (unsigned long long)((d + 1) / 2));
	}

	friend long long ftoll(const CheckDouble &arg)
	{
		return (long long)arg.v;
	}

	friend void setmax(CheckDouble &arg, unsigned long long max)
	{
		arg.mmax = max;
	}

	friend double todouble(const CheckDouble &arg)
	{
		return arg.v;
	}
};

int printfoff(...);

#endif // #ifndef CHECKDOUBLE_H

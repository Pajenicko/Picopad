
// ****************************************************************************
//
//                              Double-floating-point
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// Most processors on the market are the first B0 version, so missing features
// are always added in this SDK, without using bootrom of higher version.

/*
 * Copyright (c) 2020 Raspberry Pi (Trading) Ltd.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include "../../global.h"	// globals

#if USE_DOUBLE		// use double support

#include "../inc/sdk_double.h"

// constants
#define PINF ( HUGE_VAL)	// plus infinity
#define MINF (-HUGE_VAL)	// minus infinity
#define NANF ((float)NAN)	// infinity, NaN
#define PZERO (+0.0)		// plus zero
#define MZERO (-0.0)		// minus zero
//#define PI       3.14159265358979323846	// pi
#define LOG2     0.69314718055994530941	// log(2)
#define LOG10    2.30258509299404568401	// log(10)
#define LOG2E    1.44269504088896340737	// 1/log(2)
#define LOG10E   0.43429448190325182765	// 1/log(10)
#define ONETHIRD 0.33333333333333333333	// 1/3

// unpack float to exponent and mantissa
#define DUNPACK(x,e,m) e=((x) >> 52) & 0x7ff, m=((x) & 0x000fffffffffffffULL) | 0x0010000000000000ULL

// unpack float to sign, exponent and mantissa
#define DUNPACKS(x,s,e,m) s=((x) >> 63), DUNPACK((x),(e),(m))

// union to take number as double or as u64
typedef union {
	double	d;	// double
	u64	ix;	// u64
} double_u64;

// ==== auxiliary functions

// get number as double type
static inline double u642double(u64 ix)
{
	double_u64 tmp;
	tmp.ix = ix;	// set number as u64
	return tmp.d;	// return as double
}

// get number as u64 type
static inline u64 double2u64(double d)
{
	double_u64 tmp;
	tmp.d = d;	// set number as double
	return tmp.ix;	// return as u64
}

// get sign and exponent
static inline int dgetsignexp(double x)
{
	u64 ix=double2u64(x);	// get number as u64
	return (ix >> 52) & 0xfff; // mask exponent with sign
}

// get exponent
static inline int dgetexp(double x)
{
	u64 ix=double2u64(x);	// get number as u64
	return (ix >> 52) & 0x7ff; // mask exponent
}

// multiply number by power of 2 (num * 2^exp)
static double dldexp(double num, int de)
{
	// get number as u64
	u64 iy;
	u64 ix=double2u64(num);

	// get exponent
	int e=dgetexp(num); // get exponent
	if (e==0 || e==0x7ff) return num; // number is 0 or infinity NaN, return number without changes

	// shift exponent
	e+=de;

	// check result
	if (e<=0) // underflow?
		iy=ix & 0x8000000000000000ULL; // underflow - result will be signed zero (+0 or -0)
	else if (e>=0x7ff) // overflow?
		iy = (ix & 0x8000000000000000ULL) | 0x7ff0000000000000ULL; // overflow - result will be signed infinity NaN
	else
		iy=ix + ((u64)de << 52); // shift exponent if result is OK

	// get number as double
	return u642double(iy);
}

// multiply number by power of 2 (num * 2^exp)
double WRAPPER_FUNC(ldexp)(double num, int exp)
{
	return dldexp(num, exp);
}

// compose floating point with magnitude of 'num' and sign of 'sign'.
static double dcopysign(double num, double sign)
{
	u64 ix=double2u64(num);	// get number 'x' as u64
	u64 iy=double2u64(sign); // get number 'sign' as u64
	ix=((ix & 0x7fffffffffffffffULL) | (iy & 0x8000000000000000ULL)); // compose number
	return u642double(ix);	// return number as double
}

// compose floating point with magnitude of 'num' and sign of 'sign'
double WRAPPER_FUNC(copysign)(double num, double sign)
{
	return dcopysign(num, sign);
}

// checks
static inline int diszero(double x)  { return dgetexp    (x)==0; }	// check if number is zero
static inline int dispzero(double x) { return dgetsignexp(x)==0; }	// check if number is plus zero
static inline int dismzero(double x) { return dgetsignexp(x)==0x800; }	// check if number is minus zero

static inline int disinf(double x)   { return dgetexp    (x)==0x7ff; }	// check if number is infinity
static inline int dispinf(double x)  { return dgetsignexp(x)==0x7ff; }	// check if number is plus infinity
static inline int disminf(double x)  { return dgetsignexp(x)==0xfff; }	// check if number is minus infinity

// check if number is an integer
Bool isintd(double x)
{
	// get number as u64
	u64 ix=double2u64(x);

	// 0 is integer
	int e=dgetexp(x);	// get exponent
	if (e == 0) return True; // 0 is an integer

	// number abs(x) < 1 is not integer
	e -= 0x3ff;		// remove exponent bias (= exponent of 1)
	if (e < 0) return False; // asb(x) < 1, non-integer

	// check max exponent (mantissa is 52 bits long)
	e = 52 - e;		// remaining bits up to 52 bits
	if (e <= 0) return True; // very large number is always integer (no fractional part left)

	// check bits of fractional part - it must be 0
	u64 m = (1ULL << e) - 1; // mask for bits of significance <1
	if((ix & m) != 0) return False; // number is not integer if fractional bits are not 0

	// otherwise number is an interger
	return True;
}

// check if number is odd integer (must be an integer ..., -3, -1, 1, 3, 5,..)
Bool isoddintd(double x)
{
	// get number as u64
	u64 ix=double2u64(x);

	// get absolute integer
	int e=dgetexp(x);	// get exponent
	e -= 0x3ff;		// remove exponent bias (= exponent of 1)

	// number abs(x) < 1 (including 0) is not odd
	if (e < 0) return False; // abs(x) < 1 or 0, number is not odd

	// check max exponent (mantissa is 52 bits long)
	e = 52 - e;		// remaining bits up to 52 bits
	if (e < 0) return False; // large number is not odd

	// check bits of fractional part - it must be 0
	u64 m = (1ULL << e) - 1;	// mask for bits of significance <1
	if ((ix & m) != 0) return False; // number is not integer if fractional bits are not 0

	// value 1 is odd
	if (e == 52) return True; // value is exactly 1, odd integer

	// check mantissa, if number is odd
	return ((ix >> e) & 1) != 0; // check bit 0, it must be '1'
}

// check if number is negative but not zero (strict negative)
static inline Bool disstrictneg(double x)
{
	u64 ix=double2u64(x);	// get numer as u64
	if (diszero(x)) return False; // number must not be zero
	return (ix >> 63) != 0;	// check sign bit
}

// check if number is negative (can be negative zero)
static inline Bool disneg(double x)
{
	u64 ix=double2u64(x);	// get number as u64
	return (ix >> 63) != 0; // check sign bit
}

// negate number
static inline double dneg(double x)
{
	u64 ix=double2u64(x);	// get number as u64
	ix ^= 0x8000000000000000ULL; // invert sign bit
	return u642double(ix);	// return number as double
}

// check if number is power of 2
Bool ispow2d(double x)
{
	u64 ix=double2u64(x);		// get number as u64
	if (diszero(x)) return False;	// zero is not power of 2
	if (disinf(x)) return False;	// infinity is not power of 2
	ix &= 0x000fffffffffffffULL;	// mask mantissa
	return ix == 0;			// mantissa must be zero to be a power of two
}

// ==== rounding

// round number towards zero
double WRAPPER_FUNC(trunc)(double x)
{
	// get number as u64
	u64 ix=double2u64(x);

	// get absolute exponent
	int e=dgetexp(x);	// get exponent
	e -= 0x3ff;		// remove exponent bias (= exponent of 1)

	// truncate number abs(x) < 1 to zero
	if (e < 0)		// number is abs(x) < 1
	{
		ix &= 0x8000000000000000ULL; // set to zero, left only sign bit
		return u642double(ix); // return float 0 or -0
	}

	// check max exponent (mantissa is 52 bits long)
	e = 52 - e;		// remaining bits up to 52 bits
	if (e <= 0) return x;	// very large number is always integer (no fractional part left)

	// clear fractional part
	u64 m = (1ULL << e) - 1; // prepare mask for bits of significance <1
	ix &= ~m;		// clear fractional bits

	return u642double(ix);	// return number as double
}

// round number to nearest integer
double WRAPPER_FUNC(round)(double x)
{
	// get number as u64
	u64 ix=double2u64(x);

	// get absolute exponent
	int e=dgetexp(x);	// get exponent
	e -= 0x3ff;		// remove exponent bias (= exponent of 1)

	// truncate number abs(x) < 0.5 to zero
	if (e < -1)		// number if abs(x) < 0.5
	{
		ix &= 0x8000000000000000ULL; // set to zero, left only sign bit
		return u642double(ix); // return float 0 or -0
	}

	// round number (abs(x) >= 0.5) && (abs(x) < 1) to +-1
	if (e == -1)		// number 0.5..1 (+-)
	{
		ix &= 0x8000000000000000ULL; // set to zero, left only sign bit
		ix |= 0x3ff0000000000000ULL; // add exponent bias 1023, set number to -1 or +1
		return u642double(ix); // return float -1 or +1
	}

	// check max exponent (mantissa is 52 bits long)
	e = 52 - e;		// remaining bits up to 52 bits
	if (e <= 0) return x;	// very large number is always integer (no fractional part left)

	// add rounding 0.5
	u64 m = 1ULL << (e - 1); // prepare mask for bit of significance 0.5
	ix += m;		// add rounding correction

	// clear fractional part
	m = m + m - 1;		// prepare mask for bits of significance <1
	ix &= ~m;		// clear fractional bits

	return u642double(ix);	// return number as double
}

// round number down to integer
double WRAPPER_FUNC(floor)(double x)
{
	// get number as u64
	u64 ix=double2u64(x);

	// get exponent
	int e=dgetexp(x);

	// zero - return +0 or -0
	if (e == 0)		// number is zero
	{
		ix &= 0x8000000000000000ULL; // set to zero, left only sign bit
		return u642double(ix); // return float +0 or -0
	}

	// get absolute exponent
	e -= 0x3ff;		// remove exponent bias (= exponent of 1)

	// number is -1 < x < +1, return -1 or 0
	if (e < 0)		// number is abs(x) < 1, but not zero
	{
		if (disneg(x)) return -1.0; // number is -1 < x < 0, return -1
		return PZERO;	// return +0.0
	}

	// check max exponent (mantissa is 52 bits long)
	e = 52 - e;		// remaining bits up to 52 bits
	if (e <= 0) return x;	// very large number is always integer (no fractional part left)

	// prepare mask of fractional part
	u64 m = (1ULL << e) - 1; // prepare mask for bits of significance <1

	// if the number is negative, round the number up
	if (disneg(x)) ix += m;	// add mask to round number up

	// truncate - clear fractional bits
	ix &= ~m;

	return u642double(ix);	// return number as double
}

// round number up to integer
double WRAPPER_FUNC(ceil)(double x)
{
	// get number as u64
	u64 ix=double2u64(x);

	// get exponent
	int e=dgetexp(x);

	// zero - return +0 or -0
	if (e == 0)		// number is zero
	{
		ix &= 0x8000000000000000ULL; // set to zero, left only sign bit
		return u642double(ix); // return float +0 or -0
	}

	// get absolute exponent
	e -= 0x3ff;		// remove exponent bias (= exponent of 1)

	// number is -1 < x < +1, return -0 or +1
	if (e < 0)		// number is abs(x) < 1, but not zero
	{
		if (disneg(x)) return MZERO; // number is -1 < x < 0, return -0.0
		return 1.0;	// return +1
	}

	// check max exponent (mantissa is 52 bits long)
	e = 52 - e;		// remaining bits up to 52 bits
	if (e <= 0) return x;	// very large number is always integer (no fractional part left)

	// prepare ask of fractional part
	u64 m = (1ULL << e) - 1; // prepare mask for bits of significance <1

	// if the number is not negative, round the number up
	if (!disneg(x)) ix += m; // add mask to round number up

	// truncate - clear fractional bits
	ix &= ~m;

	return u642double(ix);	// return number as double
}

// ==== scientific functions

// arc sine
double WRAPPER_FUNC(asin)(double x)
{
	// check range -1.0 .. +1.0
	double u = (1.0 - x)*(1.0 + x);
	if (disstrictneg(u)) return PINF; // out of range

	// get asin from atan2
	return atan2(x, sqrt(u));
}

// arc cosine
double WRAPPER_FUNC(acos)(double x)
{
	// check range -1.0 .. +1.0
	double u = (1.0 - x)*(1.0 + x);
	if (disstrictneg(u)) return PINF; // out of range

	// get acos from atan2
	return atan2(sqrt(u), x);
}

// arc tangent
double WRAPPER_FUNC(atan)(double x)
{
	// limit values -inf and +inf
	if (dispinf(x)) return +PI/2; // atan(+inf) = +PI/2
	if (disminf(x)) return -PI/2;	// atan(-inf) = -PI/2

	// get atan from atan2
	return atan2(x, 1.0);
}

// hyperbolic sine
double WRAPPER_FUNC(sinh)(double x)
{
	// (e^x - e^-x)/2
	return dldexp(exp(x) - exp(dneg(x)), -1);
}

// hyperbolic cosine
double WRAPPER_FUNC(cosh)(double x)
{
	// (e^x + e^-x)/2
	return dldexp(exp(x) + exp(dneg(x)), -1);
}

// hyperbolic tangent
double WRAPPER_FUNC(tanh)(double x)
{
	// get exponent
	int e = dgetexp(x);

	// check big number
	if (e >= 5+0x3ff) // check exponent 5 (+ bias 1023); number abs(x) >= 32?
	{
		if (!disneg(x)) return 1;  // limit positive result to 1
		return -1; // limit negative result to -1
	}

	// small number = (e^2x - 1) / (e^2x + 1)
	double u=exp(dldexp(x, 1)); // e^(2*x)
	return (u - 1.0)/(u + 1.0);
}

// inverse hyperbolic sine
double WRAPPER_FUNC(asinh)(double x)
{
	// get exponent
	int e = dgetexp(x);

	// check big number
	if (e >= 32+0x3ff) // check exponent 32 (+ bias 1023); number abs(x) >= 2^32?
	{
		if (!disneg(x)) return log(x) + LOG2;  // 1/x^2 << 1
		return dneg(log(dneg(x)) + LOG2); // 1/x^2 << 1
	}

	// positive number
	if (x > 0) // log(sqrt(x^2 + 1) + x)
		return log(sqrt(x*x + 1.0) + x);
	// negative number
	else	// -log(sqrt(x^2 + 1) - x)
		return dneg(log(sqrt(x*x + 1.0) - x));
}

// inverse hyperbolic cosine
double WRAPPER_FUNC(acosh)(double x)
{
	// absolute value of the number
	if (disneg(x)) x=dneg(x);

	// get exponent
	int e = dgetexp(x);

	// check big number; check exponent 32 (+ bias 1023); number abs(x) >= 2^32?
	if (e >= 32+0x3ff) return log(x) + LOG2;

	// log(sqrt((x + 1)*(x - 1)) + x)
	return log(sqrt((x + 1.0)*(x - 1.0)) + x);
}

// inverse hyperbolic tangent
double WRAPPER_FUNC(atanh)(double x)
{
	// log((1 + x) / (1 - x)) / 2
	return dldexp(log((1.0 + x)/(1.0 - x)), -1);
}

// exponent with base 2
double WRAPPER_FUNC(exp2)(double x)
{
	// check underflow
	if (disminf(x) || x <= -4096) return 0; // easily underflows

	// check overflow
	if (x>=4096) return PINF; // easily overflows

	// get integer part
	int e = (int)round(x);
	x-=e;

	// exp(x * log(2))
	return dldexp(exp(x*LOG2), e);
}

// lofarithm with base 2
double WRAPPER_FUNC(log2)(double x)
{
	// log(x) / log(2)
	return log(x)*LOG2E;
}

// exponent with base 10
double WRAPPER_FUNC(exp10)(double x)
{
	// exp(x * log(10))
	return exp(x*LOG10);
}

// lofarithm with base 10
double WRAPPER_FUNC(log10)(double x)
{
	// log(x) / log(10)
	return log(x)*LOG10E;
}

// exp(x) - 1
double WRAPPER_FUNC(expm1)(double x)
{
	return exp(x) - 1;
}

// log(x + 1)
double WRAPPER_FUNC(log1p)(double x)
{
	return log(1 + x);
}

// x*y + z
double WRAPPER_FUNC(fma)(double x, double y, double z)
{
	return x*y + z;
}

// general power, x>0
static inline double dpow_1(double x, double y)
{
	return expd(logd(x)*y);

// This metod is more precise, but slow:
/*
	int a, b, c;
	double t, rt, u, v, v0, v1, w, ry;
	a=dgetexp(x)-0x3ff;
	u=log2(dldexp(x,-a)); // now log_2 x = a+u
	if (u > 0.5) { u -= 1; a++; }   // |u|<=~0.5
	if (a==0) return exp2(u*y);

	// here |log_2 x| >~0.5
	if (y >= 4096)  // then easily over/underflows
	{
		if (a < 0) return 0;
		return PINF;
	}

	if (y <= -4096) // then easily over/underflows
	{
		if (a < 0) return PINF;
		return 0;
	}

	ry = round(y);
	v = y-ry;
	v0 = dldexp(round(ldexp(v,26)),-26);
	v1 = v-v0;
	b = (int)ry; // guaranteed to fit in an int; y=b+v0+v1

	// now the result is exp2( (a+u) * (b+v0+v1) )
	c = a*b;      // integer
	t = a*v0;
	rt = round(t);
	c += (int)rt;
	w = t-rt;
	t = a*v1;
	w += t;
	t = u*b;
	rt = round(t);
	c += (int)rt;
	w += t-rt;
	w += u*v;
	return dldexp(exp2(w),c);
*/
}

// integer power by 2^y
static double dpow_int2(double x, int y)
{
	// end of iterations
	if (y==1) return x;

	// power by even number
	double u=dpow_int2(x, y/2);

	// y^2
	u *= u;

	// odd multiply, y *= x
	if ((y & 1) != 0) u *= x;

	return u;
}

// integer power by 2^y, y can be negative
static inline double dpowint_1(double x, int y)
{
	// y is negative
	if (y < 0)
	{
		x = 1.0/x;
		y = -y;
	}
	return dpow_int2(x, y);
}

// integer power by 2^y, y can be negative, x can be negative
static double dpowint_0(double x, int y)
{
	int e;

	// x is negative (result will be negative if y is odd)
	if (disneg(x))
	{
		x = dpowint_0(dneg(x),y); // power by 2^y (x positive)
		if ((y & 1) != 0) x = dneg(x); // negate result if y is odd
		return x;
	}

	// x is power of 2
	if (ispow2d(x)) // check if x is power of 2
	{
		e=dgetexp(x) - 0x3ff; // get absolute exponent, without base
		if (y >= 2048) y = 2047;  // max. power
		if (y < -2048) y = -2048; // min. power
		y *= e; // get new exponent
		return dldexp(1, y); // get power 2^y
	}

	// power x^0, result is 1
	if (y == 0) return 1;

	// exponent is small
	if (y >= -32 && y <= 32) return dpowint_1(x, y);

	// exponent is large - use double calculations
	return dpow_1(x, y);
}

// power by integer, x^y
double WRAPPER_FUNC(powint)(double x, int y)
{
	// x = 1 or y = 0, result is 1
	if (x == 1.0 || y == 0) return 1;

	// x = 0
	if (diszero(x))
	{
		// exponent is positive
		if (y > 0)
		{
			if ((y & 1) != 0) return x; // exponent is odd, result is x = +0.0 or -0.0
			return 0; // exponent is even, result is +0.0
		}

		// exponent is negative and odd - result is +-INF
		if ((y & 1) != 0) return dcopysign(PINF,x);

		// result is +INF
		return PINF;
	}

	// x is positive infinity NaN
	if (dispinf(x))
	{
		// exponent is negative, result will be 0
		if (y < 0) return 0;
		return PINF; // exponent is positive, result will be infinity NaN
	}

	// x is negative infinity NaN
	if (disminf(x))
	{
		// exponent is positive
		if (y > 0)
		{
			if ((y & 1) != 0) return MINF; // exponent is odd, result is negative infinity
			return PINF; // exponent is even, result is positive infinity
		}

		// exponent is negative and odd - result is -0.0
		if ((y & 1) != 0) return MZERO;

		// result is +0.0
		return PZERO;
	}

	// integer power by 2^y, y can be negative, x can be negative
	return dpowint_0(x, y);
}

// power x^y, y is integer
static double dpow_0(double x, double y)
{
	int e, p;

	// x is negative
	if (disneg(x))
	{
		// y is odd integer - negate result
		if (isoddintd(y)) return dneg(dpow_0(dneg(x),y));

		// y is even or not integer - use absolute value of x
		return dpow_0(dneg(x), y);
	}

	// get integer of power
	p = (int)y;

	// x is power of 2
	if (ispow2d(x)) // check if x is power of 2
	{
		e=dgetexp(x) - 0x3ff; // get absolute exponent, without base
		if (p >= 2048) p = 2047;  // max. power
		if (p < -2048) p = -2048; // min. power
		p *= e; // get new exponent
		return dldexp(1, p); // get power 2^p
	}

	// power is 0, result is 1
	if (p == 0) return 1;

	// power is small number, use integer
	if (p >= -32 && p <= 32) return dpowint_1(x,p);

	// exponent is large - use double calculations
	return dpow_1(x, y);
}

// power x^y
double WRAPPER_FUNC(pow)(double x, double y)
{
	// x is 1 or y is 0, result is 1
	if (x == 1.0 || diszero(y)) return 1;

	// x is -1 and y is infinity, result is +1
	if (x == -1.0 && disinf(y)) return 1;

	// x is zero
	if (diszero(x))
	{
		// y is positive
		if (!disneg(y))
		{
			// y is odd and integer, return +0.0 or -0.0
			if (isoddintd(y)) return x;
			return 0; // else result is 0
		}

		// y is negative, odd and integer - return +-infinity
		if (isoddintd(y)) return dcopysign(PINF, x);

		// y is negative, return positive infinity
		return PINF;
	}

	// x is positive infinity
	if (dispinf(x))
	{
		// y is negative, result will be 0
		if (disneg(y)) return 0;
		return PINF; // y is positive, result is positive infinity
	}

	// x is negative infinity
	if (disminf(x))
	{
		// y is positive
		if (!disneg(y))
		{
			// y is positive and odd integer, result is negative infinity
			if (isoddintd(y)) return MINF;

			// y is negative or not odd integer, result is positive infinity
			return PINF;
		}

		// y is negative and odd integer, result will be -0.0
		if (isoddintd(y)) return MZERO;

		// y is negative, resultwill be +0.0
		return PZERO;
	}

	// y is positive infinity
	if (dispinf(y))
	{
		// x is < 1, result is +0.0
		if (dgetexp(x) < 0x3ff) return PZERO;

		// x is >= 1, result is positive infinity
		return PINF;
	}

	// y is negative infinity
	if (disminf(y))
	{
		// x is < 1, result is positive infinity
		if (dgetexp(x) < 0x3ff) return PINF;

		// x is >= 1, result is +0.0
		return PZERO;
	}

	// y is integer, use power with integer y
	if (isintd(y)) return dpow_0(x,y);

	// x is negative
	if (disneg(x)) return PINF;

	// get power using doubles
	return dpow_1(x,y);
}

// square root of sum of squares (hypotenuse), sqrt(x*x + y*y)
double WRAPPER_FUNC(hypot)(double x, double y)
{
	// get exponents
	int ex = dgetexp(x);
	int ey = dgetexp(y);

	// possible overflow of some square (some number has exponent >= 400)
	if (ex >= 0x3ff + 400 || ey >= 0x3ff + 400)
	{
		// reduce exponents (correction must be even number)
		x = dldexp(x, -600);
		y = dldexp(y, -600);

		// calculate result with reduced exponents
		return dldexp(sqrt(x*x + y*y), 600); // reduce result back
	}

	// possible underflow of both squares (both numbers have exponent <= -400)
	if (ex <= 0x3ff - 400 && ey <= 0x3ff - 400)
	{
		// reduce exponents (correction must be even number)
		x = dldexp(x, 600);
		y = dldexp(y, 600);

		// calculate result with reduced exponents
		return dldexp(sqrt(x*x + y*y), -600); // reduce result back
	}

	// calculate result in normal range
	return sqrt(x*x + y*y);
}

// cube root, sqrt3(x), x^(1/3)
double WRAPPER_FUNC(cbrt)(double x)
{
	int e;

	// x is negative, change sign
	if (disneg(x)) return dneg(cbrt(dneg(x)));

	// x is zero, result will be +0.0 or -0.0
	if (diszero(x)) return dcopysign(PZERO, x);

	// get absolute exponent, without base
	e = dgetexp(x) - 0x3ff;

	// prepare integer exponent = e/3 (rounded)
	//   0x10000 / 3 = 21845.333 = 0x5555, rounded down
	e = (e*0x5555 + 0x8000) >> 16;

	// shift x number by exponent/3
	x = dldexp(x, -e*3);

	// calculate cube root = exp(log(x)/3)
	x = exp(log(x)*ONETHIRD);

	// restore exponent
	return dldexp(x, e);
}

// ==== basic arithmetic

// reduces mx*2^e modulo my, returning bottom bits of quotient at *pquo
// 2^52<=|mx|, my<2^53, e>=0; 0<=result<my
//  mx ... mantissa X
//  my ... mantissa Y
//  e ... binary exponent
static s64 drem_0(s64 mx, s64 my, int e, int* pquo)
{
	int quo=0, q, r=0, s;
	if (e > 0)
	{
		r=0xffffffffU/(u32)(my >> 36);  // reciprocal estimate Q16
	}

	while(e > 0)
	{
		s=e;
		if(s > 12) s=12;    // gain up to 12 bits on each iteration
		q=(mx >> 38)*r;           // Q30
		q=((q >> (29 - s)) + 1) >> 1;  // Q(s), rounded
		mx=(mx << s) - my*q;
		quo=(quo << s) + q;
		e -= s;
	}

	if (mx >= my) mx-=my,quo++; // when e==0 mx can be nearly as big as 2my
	if (mx >= my) mx-=my,quo++;
	if (mx < 0) mx+=my,quo--;
	if (mx < 0) mx+=my,quo--;
	if (pquo) *pquo=quo;

	return mx;
}

// get remainder of division x/y, rounded towards zero
//  fmod (x, y) = x - tquote*y, where tquote is truncated (i.e. rounded towards zero) result of x/y
double WRAPPER_FUNC(fmod)(double x, double y)
{
	// get numbers as u64
	u64 ix=double2u64(x);
	u64 iy=double2u64(y);

	// unpack numbers
	int sx,ex,ey;
	s64 mx,my;
	DUNPACKS(ix,sx,ex,mx);	// unpack X to sign, exponent and mantissa
	DUNPACK(iy,ey,my);	// unpack Y to exponent and mantissa

	// X is infinity NaN or Y is zero, return infinity
	if ((ex == 0x7ff) || (ey == 0))
		return PINF;	// plus infinity

	// X is zero, return +0.0 or -0.0
	if (ex == 0)
	{
		if (!disneg(x)) return PZERO; // positive, return +0.0
		return MZERO;	// negative, return -0.0
	}

	// if abs(x) < abs(y), return whole X as remainder
	if (ex < ey) return x;

	// get remainder
	mx=drem_0(mx, my, ex-ey, 0);

	// correct sign
	if (sx) mx=-mx;

	// convert result to double
	return fix642double(mx, 0x3ff - ey + 52);
}

// compute remainder and quotient of division x/y, rounded towards the even number
//  remainder (x, y) = x - rquote*y, where rquote is result of x/y, rounded towards the nearest integral
double WRAPPER_FUNC(remquo)(double x, double y, int* quo)
{
	// get numbers as u64
	u64 ix=double2u64(x);
	u64 iy=double2u64(y);

	// unpack numbers
	int sx,sy,ex,ey,q;
	s64 mx,my;
	DUNPACKS(ix,sx,ex,mx);	// unpack X to sign, exponent and mantissa
	DUNPACKS(iy,sy,ey,my);	// unpack Y to sign, exponent and mantissa

	// preset quotient
	if (quo) *quo=0;

	// limit values
	if (ex == 0x7ff) return PINF; // X is infinity, result is plus infinity
	if (ey == 0) return PINF; // Y is zero, result is plus infinity
	if (ex == 0) return PZERO; // X is zero, result is +0.0
	if (ey == 0x7ff) return x; // Y is infinity, result is X
	if (ex < ey - 1) return x;  // |x|<|y|/2 ... X is smaller than Y, result is X

	// abs(x) == abs(y)/2
	if (ex == ey - 1)
	{
		if (mx <= my) return x;  // |x|<=|y|/2, even quotient

		// here |y|/2<|x|<|y|
		if (!sx) // x>|y|/2
		{
			mx -= my + my;
			ey--;
			q = 1;
		}
		else // x<-|y|/2
		{
			mx = my + my - mx;
			ey--;
			q = -1;
		}
	}
	else // abs(x) > abs(y)/2
	{
		if (sx) mx = -mx;
		mx=drem_0(mx,my,ex-ey,&q); // get remainder and quotient
		if (mx+mx > my || ((mx+mx == my) && (q & 1)) )
		{ // |x|>|y|/2, or equality and an odd quotient?
			mx-=my;
			q++;
		}
	}

	if (sy) q=-q;
	if (quo) *quo=q;
	return fix642double(mx, 0x3ff - ey + 52);
}

// get remainder of division x/y, rounded towards the even number
//  remainder (x, y) = x - rquote*y, where rquote is result of x/y, rounded towards the nearest integral
double WRAPPER_FUNC(remainder)(double x, double y)
{
	return remquo(x,y,0);
}

// get remainder of division x/y, rounded towards the even number
//  remainder (x, y) = x - rquote*y, where rquote is result of x/y, rounded towards the nearest integral
double WRAPPER_FUNC(drem)(double x, double y) // obsolete synonym
{
	return remquo(x,y,0);
}

// absolute value
double absd(double x)
{
	u64 ix=double2u64(x);	// get number as u64
	ix &= 0x7fffffffffffffffULL; // absolute value
	return u642double(ix);	// return number as double
}

#endif // USE_DOUBLE		// use double support

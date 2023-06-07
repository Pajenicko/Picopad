
// ****************************************************************************
//
//                              Double-floating-point
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#ifndef _SDK_DOUBLE_H
#define _SDK_DOUBLE_H

#ifdef __cplusplus
extern "C" {
#endif

#if USE_DOUBLE		// use double support

// ==== auxiliary functions

// compose floating point with magnitude of 'num' and sign of 'sign'
// Takes 250 ns
double copysign(double num, double sign);
INLINE double copysignd(double num, double sign) { return copysign(num, sign); }

// check if number is an integer
// Takes 580 ns
Bool isintd(double num);

// check if number is odd integer (must be an integer ..., -3, -1, 1, 3, 5,..)
// Takes 700 ns
Bool isoddintd(double num);

// check if number is power of 2
// Takes 270 ns
Bool ispow2d(double num);

// multiply number by power of 2 (num * 2^exp)
// Takes 420 ns
double ldexp(double num, int exp);
INLINE double ldexpd(double num, int exp) { return ldexp(num, exp); }

// ==== basic arithmetic

// Addition, x + y
// Takes 890 ns
double dadd(double x, double y);

// Subtraction, x - y
// Takes 890 ns
double dsub(double x, double y);

// Multiplication, x * y
// Takes 1540 ns
double dmul(double x, double y);

// Square, x^2 
// Takes 1470 ns
double dsqr(double x);

// Division, x / y
// Takes 2100 ns
double ddiv(double x, double y);

// Reciprocal 1 / x
// Takes 2020 ns
double drec(double x);

// get remainder of division x/y, rounded towards zero
//  fmod (x, y) = x - tquote*y, where tquote is truncated (i.e. rounded towards zero) result of x/y
// Takes 2890 ns
double fmod(double x, double y);
INLINE double fmodd(double x, double y) { return fmod(x, y); }

// compute remainder and quotient of division x/y, rounded towards the even number
//  remainder (x, y) = x - rquote*y, where rquote is result of x/y, rounded towards the nearest integral
// Takes 3550 ns
double remquo(double x, double y, int* quo);
INLINE double remquod(double x, double y, int* quo) { return remquo(x, y, quo); }

// get remainder of division x/y, rounded towards the even number
//  remainder (x, y) = x - rquote*y, where rquote is result of x/y, rounded towards the nearest integral
// Takes 3660 ns
double remainder(double x, double y);
INLINE double remainderd(double x, double y) { return remainder(x, y); }
double drem(double x, double y); // obsolete synonym
INLINE double dremd(double x, double y) { return drem(x, y); } // obsolete synonym

// ==== comparison

// Compare, x ? y
// Returns: 0 if x==y, -1 if x<y, +1 if x>y
// Takes 420 ns
s8 dcmp(double x, double y);

// Compare if x==y
// Takes 550 ns
Bool dcmpeq(double x, double y);

// Compare if x<y
// Takes 550 ns
Bool dcmplt(double x, double y);

// Compare if x<=y
// Takes 570 ns
Bool dcmple(double x, double y);

// Compare if x>=y
// Takes 640 ns
Bool dcmpge(double x, double y);

// Compare if x>y
// Takes 640 ns
Bool dcmpgt(double x, double y);

// Check if comparison is unordered (either input is NaN)
// Takes 190 ns
Bool dcmpun(double x, double y);

// ==== convert integer to double

// Convert signed int to double
// Takes 470 ns
double i2d(s32 num);
double int2double(s32 num);

// Convert unsigned int to double
// Takes 470 ns
double ui2d(u32 num);
double uint2double(u32 num);

// Convert 64-bit signed int to double
// Takes 600 ns
double l2d(s64 num);
double int642double(s64 num);

// Convert 64-bit unsigned int to double
// Takes 590 ns
double ul2d(s64 num);
double uint642double(u64 num);

// Convert signed fixed point to double
//  e = number of bits of fractional part (binary exponent)
// Takes 750 ns
double fix2double(s32 num, int e);

// Convert unsigned fixed point to double
//  e = number of bits of fractional part (binary exponent)
// Takes 750 ns
double ufix2double(u32 num, int e);

// Convert 64-bit signed fixed point to double
//  e = number of bits of fractional part (binary exponent)
// Takes 650 ns
double fix642double(s64 num, int e);

// Convert 64-bit unsigned fixed point to double
//  e = number of bits of fractional part (binary exponent)
// Takes 640 ns
double ufix642double(u64 num, int e);

// ==== convert double to integer

// Convert double to signed int, rounding to zero (C-style int conversion)
// Takes 350 ns
s32 d2iz(double num);
s32 double2int_z(double num);

// Convert double to signed int, rounding down
// Takes 760 ns
s32 d2i(double num);
s32 double2int(double num);

// Convert double to unsigned int, rounding down
// Takes 650 ns
u32 d2ui(double num);
u32 double2uint(double num);

// Convert double to 64-bit signed int, rounding to zero (C-style int conversion)
// Takes 760 ns
s64 d2lz(double num);
s64 double2int64_z(double num);

// Convert double to 64-bit signed int, rounding down
// Takes 740 ns
s64 d2l(double num);
s64 double2int64(double num);

// Convert double to 64-bit unsigned int
// Takes 590 ns
u64 d2ul(double num);
u64 double2uint64(double num);

// Convert double to signed fixed point, rounding down
//  e = number of bits of fractional part (binary exponent)
// Takes 760 ns
s32 double2fix(double num, int e);

// Convert double to unsigned fixed point, rounding down
//  e = number of bits of fractional part (binary exponent)
// Takes 620 ns
u32 double2ufix(double num, int e);

// Convert double to 64-bit signed fixed point, rounding down
//  e = number of bits of fractional part (binary exponent)
// Takes 740 ns
s64 double2fix64(double num, int e);

// Convert double to 64-bit unsigned fixed point
//  e = number of bits of fractional part (binary exponent)
// Takes 580 ns
u64 double2ufix64(double num, int e);

// ==== rounding

// round number towards zero
// Takes 660 ns
double trunc(double num);
INLINE double truncd(double num) { return trunc(num); }

// round number to nearest integer
// Takes 930 ns
double round(double num);
INLINE double roundd(double num) { return round(num); }

// round number down to integer
// Takes 800 ns
double floor(double num);
INLINE double floord(double num) { return floor(num); }

// round number up to integer
// Takes 730 ns
double ceil(double num);
INLINE double ceild(double num) { return ceil(num); }

// ==== scientific functions

// Square root
// Takes 1800 ns
double sqrtd(double x);
double sqrt(double x);

// sine (in radians)
// Takes 19100 ns
double sin(double x);
INLINE double sind(double x) { return sin(x); }

// cosine (in radians)
// Takes 19100 ns
double cos(double x);
INLINE double cosd(double x) { return cos(x); }

// sine-cosine (in radians)
// Takes 20100 ns
void sincos(double x, double* psin, double* pcos);
INLINE void sincosd(double x, double* psin, double* pcos) { sincos(x, psin, pcos); }

// tangent
// Takes 21800 ns
double tan(double x);
INLINE double tand(double x) { return tan(x); }

// arc sine
// Takes 25500 ns
double asin(double x);
INLINE double asind(double x) { return asin(x); }

// arc cosine
// Takes 25500 ns
double acos(double x);
INLINE double acosd(double x) { return acos(x); }

// arc tangent
// Takes 21500 ns
double atan(double x);
INLINE double atand(double x) { return atan(x); }

// arc tangent of y/x
// Takes 20300 ns
double atan2(double y, double x);
INLINE double atan2d(double y, double x) { return atan2(y, x); }

// hyperbolic sine
// Takes 17300 ns
double sinh(double x);
INLINE double sinhd(double x) { return sinh(x); }

// hyperbolic cosine
// Takes 17200 ns
double cosh(double x);
INLINE double coshd(double x) { return cosh(x); }

// hyperbolic tangent
// Takes 12500 ns
double tanh(double x);
INLINE double tanhd(double x) { return tanh(x); }

// inverse hyperbolic sine
// Takes 14000 ns
double asinh(double x);
INLINE double asinhd(double x) { return asinh(x); }

// inverse hyperbolic cosine
// Takes 14000 ns
double acosh(double x);
INLINE double acoshd(double x) { return acosh(x); }

// inverse hyperbolic tangent
// Takes 12700 ns
double atanh(double x);
INLINE double atanhd(double x) { return atanh(x); }

// Natural exponent
// Takes 8000 ns
double exp(double x);
INLINE double expd(double x) { return exp(x); }

// Natural logarithm
// Takes 8000 ns
double log(double x);
INLINE double logd(double x) { return log(x); }

// exponent with base 2
// Takes 12500 ns
double exp2(double x);
INLINE double exp2d(double x) { return exp2(x); }

// lofarithm with base 2
// Takes 9500 ns
#ifdef log2
#undef log2 // defined in math.h: #define log2(x) (log (x) / _M_LN2)
#endif
double log2(double x);
INLINE double log2d(double x) { return log2(x); }

// exponent with base 2
// Takes 9800 ns
double exp10(double x);
INLINE double exp10d(double x) { return exp10(x); }

// lofarithm with base 10
// Takes 9500 ns
double log10(double x);
INLINE double log10d(double x) { return log10(x); }

// expf(x) - 1
// Takes 9000 ns
double expm1(double x);
INLINE double expm1d(double x) { return expm1(x); }

// logf(x + 1)
// Takes 9500 ns
double log1p(double x);
INLINE double log1pd(double x) { return log1p(x); }

// x*y + z
// Takes 2600 ns
double fma(double x, double y, double z);
INLINE double fmad(double x, double y, double z) { return fma(x, y, z); }

// power by integer, x^y
// Takes 8100 ns
double powint(double x, int y);
INLINE double powintd(double x, int y) { return powint(x, y); }

// power x^y
// Takes 20300 ns (original method 47300 ns)
double pow(double x, double y);
INLINE double powd(double x, double y) { return pow(x, y); }

// square root of sum of squares (hypotenuse), sqrt(x*x + y*y)
// Takes 6000 ns
double hypot(double x, double y);
INLINE double hypotd(double x, double y) { return hypot(x, y); }

// cube root, sqrt3(x), x^(1/3)
// Takes 18200 ns
double cbrt(double x);
INLINE double cbrtd(double x) { return cbrt(x); }

// absolute value
// Takes 160 ns
double absd(double x);

#endif  // USE_DOUBLE		// use double support

#if USE_FLOAT || USE_DOUBLE	// use float or double support

// Convert double to float
// Takes 280 ns
float d2f(double num);
float double2float(double num);

#endif // USE_FLOAT || USE_DOUBLE	// use float or double support

#ifdef __cplusplus
}
#endif

#endif // _SDK_DOUBLE_H


// ****************************************************************************
//
//                              Single-floating-point
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// Format of float number:
//
//  3 2        1         0
//  10987654321098765432109876543210
//  S\--EXP-/\----------MANT-------/
//
// S ... sign of mantissa, bit position 31 (1=negative, 0=positive)
// EXP ... unsigned biased exponent 8 bits, bit position 23..30, bias 127
// MANT ... mantissa (fraction) 23 bit, bit position 0..22, with hidden bit '1' on position 23

#ifndef _SDK_FLOAT_H
#define _SDK_FLOAT_H

#ifdef __cplusplus
extern "C" {
#endif

#define FLOAT_EXP_BITS	11		// number of bits of exponent
#define FLOAT_EXP_MAX	0xff		// max. value of exponent (= infinity flag)
#define FLOAT_EXP_SHIFT	23		// shift of exponent
#define FLOAT_EXP_BIAS	127		// bias of exponent (= value 1.0)

#if USE_FLOAT		// use float support

// initialize floating-point service
void FloatInit();

// ==== auxiliary functions

// compose floating point with magnitude of 'num' and sign of 'sign'
// Takes 90 ns
float copysignf(float num, float sign);

// check if number is an integer
// Takes 270 ns
Bool isintf(float num);

// check if number is odd integer (must be an integer ..., -3, -1, 1, 3, 5,..)
// Takes 280 ns
Bool isoddintf(float num);

// check if number is power of 2
// Takes 170 ns
Bool ispow2f(float num);

// multiply number by power of 2 (num * 2^exp)
// Takes 330 ns
float ldexpf(float num, int exp);

// ==== basic arithmetic

// Addition, x + y
// Takes 660 ns
float fadd(float x, float y);

// Subtraction, x - y
// Takes 710 ns
float fsub(float x, float y);

// Multiplication, x * y
// Takes 660 ns
float fmul(float x, float y);

// Multiply by unsigned integer u16, x * n
// Takes 650 ns
float fmulu16(float x, u16 n);

// Square, x^2 
// Takes 670 ns
float fsqr(float x);

// Division, x / y
// Takes 790 ns
float fdiv(float x, float y);

// Divide by unsigned integer u16, x / n
// Takes 950 ns
float fdivu16(float x, u16 n);

// Reciprocal 1 / x
// Takes 860 ns
float frec(float x);

// get remainder of division x/y, rounded towards zero
//  fmod (x, y) = x - tquote*y, where tquote is truncated (i.e. rounded towards zero) result of x/y
// Takes 2280 ns
float fmodf(float x, float y);

// compute remainder and quotient of division x/y, rounded towards the even number
//  remainder (x, y) = x - rquote*y, where rquote is result of x/y, rounded towards the nearest integral
// Takes 2650 ns
float remquof(float x, float y, int* quo);

// get remainder of division x/y, rounded towards the even number
//  remainder (x, y) = x - rquote*y, where rquote is result of x/y, rounded towards the nearest integral
// Takes 2660 ns
float remainderf(float x, float y);
float dremf(float x, float y); // obsolete synonym

// ==== comparison

// Compare, x ? y
// Returns: 0 if x==y, -1 if x<y, +1 if x>y
// Takes 280 ns
s8 fcmp(float x, float y);

// Compare if x==y
// Takes 440 ns
Bool fcmpeq(float x, float y);

// Compare if x<y
// Takes 440 ns
Bool fcmplt(float x, float y);

// Compare if x<=y
// Takes 430 ns
Bool fcmple(float x, float y);

// Compare if x>=y
// Takes 490 ns
Bool fcmpge(float x, float y);

// Compare if x>y
// Takes 490 ns
Bool fcmpgt(float x, float y);

// Check if comparison is unordered (either input is NaN)
// Takes 160 ns
Bool fcmpun(float x, float y);

// ==== convert integer to float

// Convert signed int to float
// Takes 460 ns
float i2f(s32 num);
float int2float(s32 num);

// Convert unsigned int to float
// Takes 450 ns
float ui2f(u32 num);
float uint2float(u32 num);

// Convert 64-bit signed int to float
// Takes 560 ns
float l2f(s64 num);
float int642float(s64 num);

// Convert 64-bit unsigned int to float
// Takes 530 ns
float ul2f(s64 num);
float uint642float(u64 num);

// Convert signed fixed point to float
//  e = number of bits of fractional part (binary exponent)
// Takes 1120 ns
float fix2float(s32 num, int e);

// Convert unsigned fixed point to float
//  e = number of bits of fractional part (binary exponent)
// Takes 1150 ns
float ufix2float(u32 num, int e);

// Convert 64-bit signed fixed point to float
//  e = number of bits of fractional part (binary exponent)
// Takes 1170 ns
float fix642float(s64 num, int e);

// Convert 64-bit unsigned fixed point to float
//  e = number of bits of fractional part (binary exponent)
// Takes 1220 ns
float ufix642float(u64 num, int e);

// ==== convert float to integer

// Convert float to signed int, rounding to zero (C-style int conversion)
// Takes 220 ns
s32 f2iz(float num);
s32 float2int_z(float num);

// Convert float to signed int, rounding down
// Takes 400 ns
s32 f2i(float num);
s32 float2int(float num);

// Convert float to unsigned int, rounding down
// Takes 420 ns
u32 f2ui(float num);
u32 float2uint(float num);

// Convert float to 64-bit signed int, rounding to zero (C-style int conversion)
// Takes 620 ns
s64 f2lz(float num);
s64 float2int64_z(float num);

// Convert float to 64-bit signed int, rounding down
// Takes 550 ns
s64 f2l(float num);
s64 float2int64(float num);

// Convert float to 64-bit unsigned int, rounding down
// Takes 440 ns
u64 f2ul(float num);
u64 float2uint64(float num);

// Convert float to signed fixed point, rounding down
//  e = number of bits of fractional part (binary exponent)
// Takes 390 ns
s32 float2fix(float num, int e);

// Convert float to unsigned fixed point, rounding down
//  e = number of bits of fractional part (binary exponent)
// Takes 420 ns
u32 float2ufix(float num, int e);

// Convert float to 64-bit signed fixed point, rounding down
//  e = number of bits of fractional part (binary exponent)
// Takes 520 ns
s64 float2fix64(float num, int e);

// Convert float to 64-bit unsigned fixed point, rounding down
//  e = number of bits of fractional part (binary exponent)
// Takes 450 ns
u64 float2ufix64(float num, int e);

// ==== rounding

// round number towards zero
// Takes 220 ns
float truncf(float num);

// round number to nearest integer
// Takes 310 ns
float roundf(float num);

// round number down to integer
// Takes 280 ns
float floorf(float num);

// round number up to integer
// Takes 280 ns
float ceilf(float num);

// ==== scientific functions

// Square root
// Takes 620 ns
float sqrtf(float x);

// sine (in radians)
// Takes 7700 ns
float sinf(float x);

// cosine (in radians)
// Takes 7750 ns
float cosf(float x);

// sine-cosine (in radians)
// Takes 7780 ns
void sincosf(float x, float* psin, float* pcos);

// tangent
// Takes 8350 ns
float tanf(float x);

// arc sine
// Takes 9320 ns
float asinf(float x);

// arc cosine
// Takes 9190 ns
float acosf(float x);

// arc tangent
// Takes 6700 ns
float atanf(float x);

// arc tangent of y/x
// Takes 6350 ns
float atan2f(float y, float x);

// hyperbolic sine
// Takes 9880 ns
float sinhf(float x);

// hyperbolic cosine
// Takes 9880 ns
float coshf(float x);

// hyperbolic tangent
// Takes 7000 ns
float tanhf(float x);

// inverse hyperbolic sine
// Takes 9910 ns
float asinhf(float x);

// inverse hyperbolic cosine
// Takes 9470 ns
float acoshf(float x);

// inverse hyperbolic tangent
// Takes 9200 ns
float atanhf(float x);

// Natural exponent
// Takes 4400 ns
float expf(float x);

// Natural logarithm
// Takes 6500 ns
float logf(float x);

// exponent with base 2
// Takes 5200 ns
float exp2f(float x);

// lofarithm with base 2
// Takes 7200 ns
float log2f(float x);

// exponent with base 2
// Takes 5200 ns
float exp10f(float x);

// lofarithm with base 10
// Takes 7200 ns
float log10f(float x);

// expf(x) - 1
// Takes 5300 ns
float expm1f(float x);

// logf(x + 1)
// Takes 7200 ns
float log1pf(float x);

// x*y + z
// Takes 1500 ns
float fmaf(float x, float y, float z);

// power by integer, x^y
// Takes 4900 ns
float powintf(float x, int y);

// power x^y
// Takes 13100 ns
float powf(float x, float y);

// square root of sum of squares (hypotenuse), sqrt(x*x + y*y)
// Takes 2900 ns
float hypotf(float x, float y);

// cube root, sqrt3(x), x^(1/3)
// Takes 12300 ns
float cbrtf(float x);

// absolute value
// Takes 130 ns
float absf(float x);

#endif // USE_FLOAT		// use float support


#if USE_FLOAT || USE_DOUBLE	// use float or double support

// Convert float to double
// Takes 200 ns
double f2d(float num);
double float2double(float num);

#endif // USE_FLOAT || USE_DOUBLE	// use float or double support


#ifdef __cplusplus
}
#endif

#endif // _SDK_FLOAT_H

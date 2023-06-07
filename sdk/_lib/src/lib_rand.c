
// ****************************************************************************
//
//                          Random Generator
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_RAND		// use Random number generator (lib_rand.c, lib_rand.h)

#include "../../_sdk/inc/sdk_cpu.h"
#include "../../_sdk/inc/sdk_rosc.h"
#include "../../_sdk/inc/sdk_double.h"
#include "../../_sdk/inc/sdk_float.h"
#include "../inc/lib_rand.h"

// Seed of random number generator (for both CPU cores)
u64 RandSeed[CORE_NUM];

// get seed of random number generator (for current CPU core)
u64 RandGet()
{
	IRQ_LOCK;
	u64 s = RandSeed[CpuID()];
	IRQ_UNLOCK;
	return s;
}

// set seed of random number generator (for current CPU core)
void RandSet(u64 seed)
{
	IRQ_LOCK;
	RandSeed[CpuID()] = seed;
	IRQ_UNLOCK;
}

// initialize seed of random number generator (for current CPU core) (randomize it)
//  Seed will not be fully random if ROSC is used as a CPU clock source.
void RandInit()
{
#if USE_ROSC	// use ROSC ring oscillator (sdk_rosc.c, sdk_rosc.h)
	// load ROSC counter
	u32 k = RoscRand32();
#else
	u32 k = 12345;
#endif

	// disable interrupts
	IRQ_LOCK;

	// randomize seed
	RandSeed[CpuID()] += k + RandSeed[CpuID() ^ 1];

	// some shifts to fill up higher bytes
	RandShift();
	RandShift();
	RandShift();

	// enable interrupts
	IRQ_UNLOCK;
}

// shift random number generator and return 32-bit random number (for current CPU core)
u32 RandShift()
{
	// disable interrupts
	IRQ_LOCK;

	// get pointer to the seed
	u64* s = &RandSeed[CpuID()];

	// shift seed
	u64 k = *s;
	k = k * 214013 + 2531011;
	*s = k;

	// enable interrupts
	IRQ_UNLOCK;

	return (u32)(k >> 32);
}

// generate 8-bit unsigned integer random number
u8 RandU8()
{
	return (u8)(RandShift() >> 24);
}

// generate 16-bit unsigned integer random number
u16 RandU16()
{
	return (u16)(RandShift() >> 16);
}

// generate 64-bit unsigned integer random number
u64 RandU64()
{
	u32 n = RandShift();
	return RandShift() | ((u64)n << 32);
}

#if USE_FLOAT		// use float support
// generate float random number in range 0 (including) to 1 (excluding)
// (maximum number is 0.99999994, minimal step 0.00000006)
float RandFloat()
{
	return (float)(RandShift() >> (32-24))*(1.0f/0x1000000);
}
#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support
// generate double random number in range 0 (including) to 1 (excluding)
// (maximum number is 0.999999999999996, step 0.0000000000000035, 14 valid digits)
double RandDouble()
{
	RandShift();
	return (double)(RandGet() >> (64-48))*(1.0/0x1000000000000ULL);
}
#endif // USE_DOUBLE		// use double support

// generate 8-bit unsigned integer random number in range 0 to MAX (including, signed can be negative)
u8 RandU8Max(u8 max)
{
	u8 res;
	u8 msk;

	// zero maximal value
	if (max == 0) return 0;

	// prepare mask
	msk = (u8)Mask(max);

	// generate random number
	do {
		res = RandU8() & msk;
	} while (res > max);

	return res;
}

// generate 16-bit unsigned integer random number in range 0 to MAX (including)
u16 RandU16Max(u16 max)
{
	u16 res;
	u16 msk;

	// zero maximal value
	if (max == 0) return 0;

	// prepare mask
	msk = (u16)Mask(max);

	// generate random number
	do {
		res = RandU16() & msk;
	} while (res > max);

	return res;
}

// generate 32-bit unsigned integer random number in range 0 to MAX (including)
u32 RandU32Max(u32 max)
{
	u32 res;
	u32 msk;

	// zero maximal value
	if (max == 0) return 0;

	// prepare mask
	msk = (u32)Mask(max);

	// generate random number
	do {
		res = RandU32() & msk;
	} while (res > max);

	return res;
}

// generate 64-bit unsigned integer random number in range 0 to MAX (including)
u64 RandU64Max(u64 max)
{
	u64 res;
	u64 msk;

	// DWORD value
	if (max < 0x100000000ULL) return RandU32Max((u32)max);

	// zero maximal value
	if (max == 0) return 0;

	// prepare mask
	u8 pos = Order((u32)(max >> 32));
	msk = (u64)-1 >> (32 - pos);

	// generate random number
	do {
		res = RandU64() & msk;
	} while (res > max);

	return res;
}

// generate 8-bit signed integer random number in range 0 to MAX (including, 'max' can be negative)
s8 RandS8Max(s8 max)
{
	if (max >= 0)
		return (s8)RandU8Max((u8)max);
	else
		return -(s8)RandU8Max((u8)-max);
}

// generate 16-bit signed integer random number in range 0 to MAX (including, 'max' can be negative)
s16 RandS16Max(s16 max)
{
	if (max >= 0)
		return (s16)RandU16Max((u16)max);
	else
		return -(s16)RandU16Max((u16)-max);
}

// generate 32-bit signed integer random number in range 0 to MAX (including, 'max' can be negative)
s32 RandS32Max(s32 max)
{
	if (max >= 0)
		return (s32)RandU32Max((u32)max);
	else
		return -(s32)RandU32Max((u32)-max);
}

// generate 64-bit signed integer random number in range 0 to MAX (including, 'max' can be negative)
s64 RandS64Max(s64 max)
{
	if (max >= 0)
		return (s64)RandU64Max((u64)max);
	else
		return -(s64)RandU64Max((u64)-max);
}

#if USE_FLOAT		// use float support
// generate float random number in range 0 (including) to MAX (excluding)
float RandFloatMax(float max)
{
	return RandFloat() * max;
}
#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support
// generate double random number in range 0 (including) to MAX (excluding)
double RandDoubleMax(double max)
{
	return RandDouble() * max;
}
#endif // USE_DOUBLE		// use double support

// generate 8-bit unsigned integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
u8 RandU8MinMax(u8 min, u8 max)
{
	return RandU8Max(max - min) + min;
}

// generate 16-bit unsigned integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
u16 RandU16MinMax(u16 min, u16 max)
{
	return RandU16Max(max - min) + min;
}

// generate 32-bit unsigned integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
u32 RandU32MinMax(u32 min, u32 max)
{
	return RandU32Max(max - min) + min;
}

// generate 64-bit unsigned integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
u64 RandU64MinMax(u64 min, u64 max)
{
	return RandU64Max(max - min) + min;
}

// generate 8-bit signed integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
s8 RandS8MinMax(s8 min, s8 max)
{
	return (s8)RandU8Max(max - min) + min;
}

// generate 16-bit signed integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
s16 RandS16MinMax(s16 min, s16 max)
{
	return (s16)RandU16Max(max - min) + min;
}

// generate 32-bit signed integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
s32 RandS32MinMax(s32 min, s32 max)
{
	return (s32)RandU32Max(max - min) + min;
}

// generate 64-bit signed integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
s64 RandS64MinMax(s64 min, s64 max)
{
	return (s64)RandU64Max(max - min) + min;
}

#if USE_FLOAT		// use float support
// generate float random number in range MIN to MAX (excluding)
// If MIN > MAX, then number is generated out of interval.
float RandFloatMinMax(float min, float max)
{
	return RandFloatMax(max - min) + min;
}
#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support
// generate double random number in range MIN to MAX (excluding)
// If MIN > MAX, then number is generated out of interval.
double RandDoubleMinMax(double min, double max)
{
	return RandDoubleMax(max - min) + min;
}
#endif // USE_DOUBLE		// use double support

#if USE_FLOAT		// use float support
// generate Gaussian float random number (mean = center, default use 0, sigma = width, default use 1)
float RandFloatGauss(float mean, float sigma)
{
	float x, y, r;

	do {
		x = RandFloat()*2 - 1;
		y = RandFloat()*2 - 1;
		r = x*x + y*y;
	} while ((r == 0) || (r > 1));

	r = sqrtf(-2*logf(r)/r);
	return x*r*sigma + mean;
}
#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support
// generate Gaussian double random number (mean = center, default use 0, sigma = width, default use 1)
double RandDoubleGauss(double mean, double sigma)
{
	double x, y, r;

	do {
		x = RandDouble()*2 - 1;
		y = RandDouble()*2 - 1;
		r = x*x + y*y;
	} while ((r == 0) || (r > 1));

	r = sqrt(-2*log(r)/r);
	return x*r*sigma + mean;
}
#endif // USE_DOUBLE		// use double support

// generate random test integer number (with random number of bits)
u8 RandTestU8()
{
	u8 num = RandU8();
	u8 shift = RandU8Max(8);
	return num >> shift;
}

u16 RandTestU16()
{
	u16 num = RandU16();
	u8 shift = RandU8Max(16);
	return num >> shift;
}

u32 RandTestU32()
{
	u32 num = RandU32();
	u8 shift = RandU8Max(32);
	return num >> shift;
}

u64 RandTestU64()
{
	u64 num = RandU64();
	u8 shift = RandU8Max(64);
	return num >> shift;
}

s8 RandTestS8()
{
	s8 num = RandS8();
	u8 shift = RandU8Max(8);
	return num >> shift;
}

s16 RandTestS16()
{
	s16 num = RandS16();
	u8 shift = RandU8Max(16);
	return num >> shift;
}

s32 RandTestS32()
{
	s32 num = RandS32();
	u8 shift = RandU8Max(32);
	return num >> shift;
}

s64 RandTestS64()
{
	s64 num = RandS64();
	u8 shift = RandU8Max(64);
	return num >> shift;
}

#if USE_FLOAT || USE_DOUBLE	// use float or double support
// 1D coordinate Perlin noise generator (output -1..+1)
float Noise1D(int x, int seed)
{
	int n = x + seed*1327;
	n = (n << 13) ^ n;
	return 1 - (float)(int)((n*(n*n*15731 + 789221) + 1376312589) & 0x7fffffff)/0x40000000;
}

// 2D coordinate Perlin noise generator (output -1..+1)
float Noise2D(int x, int y, int seed)
{
	int n = x + y*321 + seed*1327;
	n = (n << 13) ^ n;
	return 1 - (float)(int)((n*(n*n*15731 + 789221) + 1376312589) & 0x7fffffff)/0x40000000;
}

// 3D coordinate Perlin noise generator (output -1..+1)
float Noise3D(int x, int y, int z, int seed)
{
	int n = x + y*321 + z*51327 + seed*1327;
	n = (n << 13) ^ n;
	return 1 - (float)(int)((n*(n*n*15731 + 789221) + 1376312589) & 0x7fffffff)/0x40000000;
}

// interpolated 1D Perlin noise (output -1..+1, scale = 1...)
float SmoothNoise1D(float x, int scale, int seed)
{
	// scale coordinates
	x *= scale;

	// remainder
	int x1 = (int)floorf(x);
	x -= x1;

	// coordinates
	x1 = x1 % scale;
	if (x1 < 0) x1 += scale;
	int x0 = (x1 + scale - 1) % scale;
	int x2 = (x1 + 1) % scale;
	int x3 = (x2 + 1) % scale;

	// noise in points
	float k0 = Noise1D(x0, seed);
	float k1 = Noise1D(x1, seed);
	float k2 = Noise1D(x2, seed);
	float k3 = Noise1D(x3, seed);

	// cubic interpolate noise
	float p = (k3 - k2) - (k0 - k1);
	float q = (k0 - k1) - p;
	float r = k2 - k0;
	float s = k1;

	return (((p*x + q)*x + r)*x + s)*(float)0.92;
}

// interpolated 2D Perlin noise (output -1..+1, scale = 1...)
float SmoothNoise2D(float x, float y, int scale, int seed)
{
	// scale coordinates
	x *= scale;
	y *= scale;

	// remainder
	int x1 = (int)floor(x);
	x -= x1;
	int y1 = (int)floor(y);
	y -= y1;

	// coordinates
	x1 = x1 % scale;
	if (x1 < 0) x1 += scale;
	int x2 = (x1 + 1) % scale;
	y1 = y1 % scale;
	if (y1 < 0) y1 += scale;
	int y2 = (y1 + 1) % scale;

	// noise in points
	float k11 = Noise2D(x1, y1, seed);
	float k21 = Noise2D(x2, y1, seed);
	float k12 = Noise2D(x1, y2, seed);
	float k22 = Noise2D(x2, y2, seed);

	// interpolate noise
	float k1 = k11*(1-x) + k21*x;
	float k2 = k12*(1-x) + k22*x;
	return k1*(1-y) + k2*y;
}
#endif // USE_FLOAT || USE_DOUBLE	// use float or double support

#endif // USE_RAND		// use Random number generator (lib_rand.c, lib_rand.h)

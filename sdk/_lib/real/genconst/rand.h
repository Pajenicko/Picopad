
// ****************************************************************************
//
//                          Random number generator
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// 64-bit LCG random number generator
// Each CPU core uses its own random generator to avoid the need to lock access to the generator.

#ifndef _RAND_H
#define _RAND_H

// Seed of random number generator (for both CPU cores)
extern u64 RandSeed[2];

// get seed of random number generator (for current CPU core)
u64 RandGet();

// set seed of random number generator (for current CPU core)
void RandSet(u64 seed);

// shift random number generator and return 32-bit random number (for current CPU core)
//  Takes 1 us
u32 RandShift();

// generate 8-bit unsigned integer random number
//  Takes 1 us
u8 RandU8();

// generate 16-bit unsigned integer random number
//  Takes 1 us
u16 RandU16();

// generate 32-bit unsigned integer random number
//  Takes 1 us
INLINE u32 RandU32() { return RandShift(); }

// generate 64-bit unsigned integer random number
//  Takes 2 us
u64 RandU64();

// generate 8-bit signed integer random number
//  Takes 1 us
INLINE s8 RandS8() { return (s8)RandU8(); }

// generate 16-bit signed integer random number
//  Takes 1 us
INLINE s16 RandS16() { return (s16)RandU16(); }

// generate 32-bit signed integer random number
//  Takes 1 us
INLINE s32 RandS32() { return (s32)RandShift(); }

// generate 64-bit signed integer random number
//  Takes 2 us
INLINE s64 RandS64() { return (s64)RandU64(); }

#if USE_FLOAT		// use float support
// generate float random number in range 0 (including) to 1 (excluding)
// (maximum number is 0.99999994, minimal step 0.00000006)
//  Takes 2 us
float RandFloat();
#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support
// generate double random number in range 0 (including) to 1 (excluding)
// (maximum number is 0.999999999999996, step 0.0000000000000035, 14 valid digits)
//  Takes 4 us
double RandDouble();
#endif // USE_DOUBLE		// use double support

// generate 8-bit unsigned integer random number in range 0 to MAX (including)
//  Takes 2 us
u8 RandU8Max(u8 max);

// generate 16-bit unsigned integer random number in range 0 to MAX (including)
//  Takes 2 us
u16 RandU16Max(u16 max);

// generate 32-bit unsigned integer random number in range 0 to MAX (including)
//  Takes 2 us
u32 RandU32Max(u32 max);

// generate 64-bit unsigned integer random number in range 0 to MAX (including)
//  Takes 3 us
u64 RandU64Max(u64 max);

// generate 8-bit signed integer random number in range 0 to MAX (including, 'max' can be negative)
//  Takes 2 us
s8 RandS8Max(s8 max);

// generate 16-bit signed integer random number in range 0 to MAX (including, 'max' can be negative)
//  Takes 2 us
s16 RandS16Max(s16 max);

// generate 32-bit signed integer random number in range 0 to MAX (including, 'max' can be negative)
//  Takes 2 us
s32 RandS32Max(s32 max);

// generate 64-bit signed integer random number in range 0 to MAX (including, 'max' can be negative)
//  Takes 3 us
s64 RandS64Max(s64 max);

#if USE_FLOAT		// use float support
// generate float random number in range 0 (including) to MAX (excluding)
//  Takes 2 us
float RandFloatMax(float max);
#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support
// generate double random number in range 0 (including) to MAX (excluding)
//  Takes 4 us
double RandDoubleMax(double max);
#endif // USE_DOUBLE		// use double support

// generate 8-bit unsigned integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
//  Takes 2 us
u8 RandU8MinMax(u8 min, u8 max);

// generate 16-bit unsigned integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
//  Takes 2 us
u16 RandU16MinMax(u16 min, u16 max);

// generate 32-bit unsigned integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
//  Takes 2 us
u32 RandU32MinMax(u32 min, u32 max);

// generate 64-bit unsigned integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
//  Takes 3 us
u64 RandU64MinMax(u64 min, u64 max);

// generate 8-bit signed integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
//  Takes 2 us
s8 RandS8MinMax(s8 min, s8 max);

// generate 16-bit signed integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
//  Takes 2 us
s16 RandS16MinMax(s16 min, s16 max);

// generate 32-bit signed integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
//  Takes 2 us
s32 RandS32MinMax(s32 min, s32 max);

// generate 64-bit signed integer random number in range MIN to MAX (including)
// If MIN > MAX, then number is generated out of interval.
//  Takes 3 us
s64 RandS64MinMax(s64 min, s64 max);

#if USE_FLOAT		// use float support
// generate float random number in range MIN (including) to MAX (excluding)
//  The order of MIN and MAX does not matter.
//  Takes 2 us
float RandFloatMinMax(float min, float max);
#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support
// generate double random number in range MIN (including) to MAX (excluding)
//  The order of MIN and MAX does not matter.
//  Takes 4 us
double RandDoubleMinMax(double min, double max);
#endif // USE_DOUBLE		// use double support

#if USE_FLOAT		// use float support
// generate Gaussian float random number (mean = center, default use 0, sigma = width, default use 1)
//  Takes 23 us
float RandFloatGauss(float mean, float sigma);
#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support
// generate Gaussian double random number (mean = center, default use 0, sigma = width, default use 1)
//  Takes 40 us
double RandDoubleGauss(double mean, double sigma);
#endif // USE_DOUBLE		// use double support

// generate random test integer number (with random number of bits)
u8 RandTestU8();
u16 RandTestU16();
u32 RandTestU32();
u64 RandTestU64();
s8 RandTestS8();
s16 RandTestS16();
s32 RandTestS32();
s64 RandTestS64();

#if USE_FLOAT || USE_DOUBLE	// use float or double support
// 1D coordinate Perlin noise generator (output -1..+1)
//  Takes 2 us
float Noise1D(int x, int seed);

// 2D coordinate Perlin noise generator (output -1..+1)
//  Takes 2 us
float Noise2D(int x, int y, int seed);

// 3D coordinate Perlin noise generator (output -1..+1)
//  Takes 2 us
float Noise3D(int x, int y, int z, int seed);

// interpolated 1D Perlin noise (output -1..+1, scale = 1...)
//  Takes 20 us
float SmoothNoise1D(float x, int scale, int seed);

// interpolated 2D Perlin noise (output -1..+1, scale = 1...)
//  Takes 24 us
float SmoothNoise2D(float x, float y, int scale, int seed);
#endif // if USE_FLOAT || USE_DOUBLE	// use float or double support

#endif // _RAND_H

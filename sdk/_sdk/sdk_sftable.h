
// ****************************************************************************
//
//               Boot ROM - offsets of floating-point functions
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// Included from both C and assembly.
// Most processors on the market are the first B0 version, so missing features
// are always added in this SDK, without using bootrom of higher version.

#ifndef _SDK_SF_TABLE_H
#define _SDK_SF_TABLE_H

#if USE_FLOAT		// use float support

// offsets of ROM v1 floating-point functions
#define SF_TABLE_FADD		0x00	// a+b
#define SF_TABLE_FSUB		0x04	// a-b
#define SF_TABLE_FMUL		0x08	// a*b
#define SF_TABLE_FDIV		0x0c	// a/b
#define SF_TABLE_FCMP_FAST	0x10	// ...do not use
#define SF_TABLE_FCMP_FAST_FLAGS 0x14	// ...do not use
#define SF_TABLE_FSQRT		0x18	// float _fsqrt(float v)
#define SF_TABLE_FLOAT2INT	0x1c	// int _float2int(float v) ... convert float to signed int, rounding down
#define SF_TABLE_FLOAT2FIX	0x20	// int _float2fix(float v, int n) ... convert float to signed fixed point
#define SF_TABLE_FLOAT2UINT	0x24	// uint _float2uint(float v) ... convert float to unsigned int, rounding down
#define SF_TABLE_FLOAT2UFIX	0x28	// uint _float2ufix(float v, int n) ... convert float to unsigned fixed point
#define SF_TABLE_INT2FLOAT	0x2c	// float _int2float(int v) ... convert signed int to float
#define SF_TABLE_FIX2FLOAT	0x30	// float _fix2float(int32_t v, int n) ... convert signed fixed point to float
#define SF_TABLE_UINT2FLOAT	0x34	// float _uint2float(uint32_t v) ... convert unsigned int to float
#define SF_TABLE_UFIX2FLOAT	0x38	// float _ufix2float(uint32_t v, int n) ... convert unsigned fixed point to float
#define SF_TABLE_FCOS		0x3c	// float _fcos(float angle) ... cosine (angle -128..+128 radians)
#define SF_TABLE_FSIN		0x40	// float _fsin(float angle) ... sine (angle -128..+128 radians)
#define SF_TABLE_FTAN		0x44	// float _ftan(float angle) ... tangent (angle -128..+128 radians)
#define SF_TABLE_V3_FSINCOS	0x48	// ...do not use
#define SF_TABLE_FEXP		0x4c	// float _fexp(float v) ... exponential
#define SF_TABLE_FLN		0x50	// float _fln(float v) ... logarithm

#define SF_TABLE_SIZE		0x54	// size of table

#endif // USE_FLOAT		// use float support

#endif // _SDK_SF_TABLE_H

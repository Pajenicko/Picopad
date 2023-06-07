
// ****************************************************************************
//                                 
//                           Global common definitions
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#ifndef _GLOBAL_H
#define _GLOBAL_H

// ----------------------------------------------------------------------------
//                              Base data types
// ----------------------------------------------------------------------------

/* Basic data types and their sizes (in bytes) depending on the system:

		8-bit	16-bit	32-bit	64-bit
char		1	1	1	1
short		1	1	2	2
int		2	2	4	4
long		4	4	4	4,8
long long	8	8	8	8
*/

// Note: 'char' can be signed or unsigned

// base types - to check, use CheckTypeSize()
typedef signed char s8;
typedef unsigned char u8;
typedef signed short s16;		// on 8-bit system use "signed int"
typedef unsigned short u16;		// on 8-bit system use "unsigned int"
typedef signed long int s32;		// on 64-bit system use "signed int"
typedef unsigned long int u32;		// on 64-bit system use "unsigned int"
typedef signed long long int s64;
typedef unsigned long long int u64;

typedef unsigned int uint;

typedef unsigned char Bool;
#define True 1
#define False 0

// NULL
#ifndef NULL
#ifdef __cplusplus
#define NULL 0
#else
#define NULL ((void*)0)
#endif
#endif

// count of array entries
#define countof(a) (sizeof(a)/sizeof((a)[0]))

// request to use inline
#define INLINE __forceinline

// avoid to use inline
#define NOINLINE __attribute__((noinline))

// Check size of types (will be omitted by the compiler if everything is OK)
INLINE void CheckTypeSize()
{	if (	(sizeof(s8) != 1) ||
		(sizeof(u8) != 1) ||
		(sizeof(s16) != 2) ||
		(sizeof(u16) != 2) ||
		(sizeof(s32) != 4) ||
		(sizeof(u32) != 4) ||
		(sizeof(s64) != 8) ||
		(sizeof(u64) != 8))
		while (True) {} }	// lock on error


/*
void *operator new(std::size_t n) { return std::malloc(n); }
void *operator new[](std::size_t n) { return std::malloc(n); }
void operator delete(void *p) { std::free(p); }
void operator delete[](void *p) noexcept { std::free(p); }
#if __cpp_sized_deallocation
void operator delete(void *p, __unused std::size_t n) noexcept { std::free(p); }
void operator delete[](void *p, __unused std::size_t n) noexcept { std::free(p); }
#endif
*/

#define WRAPPER_FUNC(x) __wrap_ ## x		// wrapper function (to replace standard library function)

// ----------------------------------------------------------------------------
//                               Constants
// ----------------------------------------------------------------------------

#define	B0 (1<<0)
#define	B1 (1<<1)
#define	B2 (1<<2)
#define	B3 (1<<3)
#define	B4 (1<<4)
#define	B5 (1<<5)
#define	B6 (1<<6)
#define	B7 (1<<7)
#define	B8 (1U<<8)
#define	B9 (1U<<9)
#define	B10 (1U<<10)
#define	B11 (1U<<11)
#define	B12 (1U<<12)
#define	B13 (1U<<13)
#define	B14 (1U<<14)
#define	B15 (1U<<15)
#define B16 (1UL<<16)
#define B17 (1UL<<17)
#define B18 (1UL<<18)
#define	B19 (1UL<<19)
#define B20 (1UL<<20)
#define B21 (1UL<<21)
#define B22 (1UL<<22)
#define B23 (1UL<<23)
#define B24 (1UL<<24)
#define B25 (1UL<<25)
#define B26 (1UL<<26)
#define B27 (1UL<<27)
#define B28 (1UL<<28)
#define B29 (1UL<<29)
#define B30 (1UL<<30)
#define B31 (1UL<<31)

#define BIT(pos) (1UL<<(pos))

#define	BIGINT	0x40000000 // big int value

//#define PI 3.14159265358979324
//#define PI2 (3.14159265358979324*2)

#define KHZ 1000	// kHz multiply
#define MHZ 1000000	// MHz multiply

// ----------------------------------------------------------------------------
//                                   Includes
// ----------------------------------------------------------------------------


#endif // _GLOBAL_H


// ****************************************************************************
//                                 
//                              Common definitions
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#pragma warning(disable : 4996) // function unsafe
//#pragma warning(disable : 4101) // unreferenced

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

// request to use inline
#define INLINE __forceinline

// avoid to use inline
#define NOINLINE __attribute__((noinline))

#define EDITBUF_MAX 3000 //(MAX_DIG+30) // size of edit buffer (without terminating 0)
extern char EditBuf[EDITBUF_MAX+1]; // edit buffer

// system
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "main.h"
#include "../bigint.h"

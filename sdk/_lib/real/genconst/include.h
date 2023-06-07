
// ****************************************************************************
//                                 
//                              Common definitions
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#pragma warning(disable : 4996) // function unsafe
//#pragma warning(disable : 4101) // unreferenced

#define EDITBUF_MAX 3000 //(MAX_DIG+30) // size of edit buffer (without terminating 0)
extern char EditBuf[EDITBUF_MAX+1]; // edit buffer

// system
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <windows.h>
#include <math.h>

#include "global.h"
#include "config.h"

// default floating point type
#if USE_DOUBLE		// use double support
typedef double real;	// floating number, preffered double
#else
typedef float real;	// floating number, preffered double
#endif

extern u8 Unit;		// current angle unit UNIT_* (used by functions ToRad() and FromRad())
extern u8 Base;		// current numeric radix base BASE_*
extern u8 ExpMode;	// current exponent mode EXP_*
extern int Fix;	// current fixed decimal places (0..digits, or FIX_OFF=off)

// configuration of ToText function
extern char CharPlus;	// character of positive number ('+', ' ' or 0=do not use)
extern char CharExp;	// character of exponent ('e', 'E' or 0=do not use)
extern char ExpPlus;	// character of positive exponent ('+', ' ' or 0=do not use)
extern char CharDec;	// character used as decimal separator (',', '.' or B7=add flag to previous digit)
extern Bool RightAlign;	// right align text in buffer
extern int MaxDig;		// max. number of digits of mantissa (0 = default, negative = cut digits from end)

// number editor (and ToText result)
extern int ExpLen;		// number of exponent digits returned by ToText function
extern int EditLen;		// length of mantissa
extern Bool PointOn;	// decimal point was entered

#define EDITBUF_MAX 3000 //(MAX_DIG+30) // size of edit buffer (without terminating 0)
						// - should be big enough to decode BIN format, use MAX_DIG*4
extern char EditBuf[EDITBUF_MAX+1]; // edit buffer

#include "main.h"
#include "rand.h"

// generators
#include "genconst.h"	// generate constants

#include "../../bigint/bigint.h"

#define REAL_PATH	"real_h.h"
#include "../real.h"			// all real numbers

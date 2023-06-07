
// ****************************************************************************
//                                 
//                     Real numbers - codes of all formats
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#ifdef GENERATOR
#include "genconst/include.h"
#else
#include "../../global.h"	// globals
#endif

#if USE_REAL	// use real numbers

#include "../../_sdk/inc/sdk_divider.h"
#include "../../_sdk/inc/sdk_bootrom.h"
#include "../inc/lib_rand.h"
#include "../inc/lib_mem.h"
#include "../bigint/bigint.h"

// === Real numbers control

u8 Unit = UNIT_DEG;		// current angle unit UNIT_* (used by functions ToRad() and FromRad())
u8 Base = BASE_DEC;		// current numeric radix base BASE_*
u8 ExpMode = EXP_AUTO;	// current exponent mode EXP_*
int Fix = FIX_OFF;		// current fixed decimal places (0..digits, or FIX_OFF=off)

// configuration of ToText function
char CharPlus = 0;			// character of positive number ('+', ' ' or 0=do not use)
char CharExp = 'e';			// character of exponent ('e', 'E' or 0=do not use)
char ExpPlus = '+';			// character of positive exponent ('+', ' ' or 0=do not use)
char CharDec = '.';			// character used as decimal separator (',', '.' or B7=add flag to previous digit)
Bool RightAlign = False;	// right align text in buffer
int MaxDig = -1;			// max. number of digits of mantissa (0 = default, negative = cut digits from end)

// number editor (and ToText result)
int ExpLen = 0;			// number of exponent digits returned by ToText function
int EditLen = 0;		// length of mantissa
Bool PointOn = False;	// decimal point was entered

char EditBuf[EDITBUF_MAX+1]; // edit buffer
char EditBuf2[EDITBUF_MAX+1]; // edit buffer
char EditBuf3[EDITBUF_MAX+1]; // edit buffer
char EditBuf4[EDITBUF_MAX+1]; // edit buffer

int Deb_LoopNum;		// number of iteration loops

// === REAL numbers definition

#define REAL_PATH	"real_h.h"
#include "real.h"			// all real numbers

#define REAL_PATH	"real_c.h"
#include "real.h"		// all real numbers

#endif // USE_REAL	// use real numbers

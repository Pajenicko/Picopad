
// ****************************************************************************
//                                 
//                         Global common C definitions
//
// ****************************************************************************

#ifndef _GLOBAL_H
#define _GLOBAL_H

#define SDK_VER		90	// SDK library version in hundredths

// ----------------------------------------------------------------------------
//                               Attributes
// ----------------------------------------------------------------------------

// count of array entries
#define count_of(a) (sizeof(a)/sizeof((a)[0]))

// I/O port prefix
#define __IO	volatile

// request to use inline
#define INLINE __attribute__((always_inline)) inline

// avoid to use inline
#define NOINLINE __attribute__((noinline))

// weak function
#define WEAK __attribute__((weak))

// align array to 4-bytes
#define ALIGNED __attribute__((aligned(4)))

// place time critical function into RAM
#define NOFLASH(fnc) NOINLINE __attribute__((section(".time_critical." #fnc))) fnc

// wrapper function (to replace standard library function)
#define WRAPPER_FUNC(x) __wrap_ ## x

// change endian of u16
#define ENDIAN16(k) ( (((k)>>8)&0xff) | (((k)&0xff)<<8) )

// clamp float value to valid range 0 to 1
#define CLAMP01(val) ( ((val)<=0) ? 0 : ( ((val)>=1) ? 1 : (val) ) )

// clamp value to u8 range
#define CLAMPU8(val) ( ((val)<=0) ? 0 : ( ((val)>=255) ? 255 : (val) ) )

// absolute value
#define ABS(val) ( ((val)<0) ? -(val) : (val) )

// maximal value
#define MAX(val1,val2) ( ((val1)<(val2)) ? (val2) : (val1) )

// minimal value
#define MIN(val1,val2) ( ((val1)<(val2)) ? (val1) : (val2) )

// convert 24-bit RGB to 16-bit color
#define RGBTO16(r,g,b)	( (((r)&0xf8)<<8) | (((g)&0xfc)<<3) | (((b)&0xf8)>>3) )

// convert 24-bit RGB to 15-bit color
#define RGBTO15(r,g,b)	( (((r)&0xf8)<<7) | (((g)&0xf8)<<2) | (((b)&0xf8)>>3) )

// blend 16-bit colors with 25%, 50% and 75% ratio
#define RGBBLEND25(a,b) ((((a)>>2) & ~(B3|B4|B9|B10|B14|B15)) + (((b)>>1) & ~(B4|B10|B15)) + (((b)>>2) & ~(B3|B4|B9|B10|B14|B15)))
#define RGBBLEND50(a,b) ((((a)>>1) & ~(B4|B10|B15)) + (((b)>>1) & ~(B4|B10|B15)))
#define RGBBLEND75(a,b) ((((a)>>1) & ~(B4|B10|B15)) + (((a)>>2) & ~(B3|B4|B9|B10|B14|B15)) + (((b)>>2) & ~(B3|B4|B9|B10|B14|B15)))

#define RGBBLEND4(a,b,c,d) ((((a)>>2) & ~(B3|B4|B9|B10|B14|B15)) + (((b)>>2) & ~(B3|B4|B9|B10|B14|B15)) + (((c)>>2) & ~(B3|B4|B9|B10|B14|B15)) + (((d)>>2) & ~(B3|B4|B9|B10|B14|B15)))

// default LED pin on Raspberry Pico
#define LED_PIN 25

#define PICO_NO_HARDWARE 1	// this switch is not use in other places of the SDK,
				//  it is used only in PIO program to cut-out some unwanted declarations

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

// base types - to check type size, use CheckTypeSize()
typedef signed char s8;
typedef unsigned char u8;
typedef signed short s16;		// on 8-bit system use "signed int"
typedef unsigned short u16;		// on 8-bit system use "unsigned int"
typedef signed long int s32;		// on 64-bit system use "signed int"
typedef unsigned long int u32;		// on 64-bit system use "unsigned int"
typedef signed long long int s64;
typedef unsigned long long int u64;

typedef unsigned int uint;

typedef u16 uint16_t;		// used only by PIO program

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

#define PI 3.14159265358979324
#define PI2 (3.14159265358979324*2)

#define KHZ 1000	// kHz multiply
#define MHZ 1000000	// MHz multiply

// ----------------------------------------------------------------------------
//                               Constants
// ----------------------------------------------------------------------------

// Control characters (ASCII characters)
#define CH_NUL		0x00	// NUL null ^@
#define CH_ALL		0x01	// SOH start of heading ^A	... select all
#define CH_BLOCK	0x02	// STX start of text ^B		... mark block
#define CH_COPY		0x03	// ETX end of text ^C		... copy block, copy file
#define CH_END		0x04	// EOT end of transmission ^D	... end of row, end of files
#define CH_MOVE		0x05	// ENQ enquiry ^E		... rename files, move block
#define CH_FIND		0x06	// ACK acknowledge ^F		... find
#define CH_NEXT		0x07	// BEL bell ^G			... repeat find
#define CH_BS		0x08	// BS backspace ^H		... backspace
#define CH_TAB		0x09	// HT horizontal tabulator ^I	... tabulator
#define CH_LF		0x0A	// LF line feed ^J		... line feed
#define CH_PGUP		0x0B	// VT vertical tabulator ^K	... page up
#define CH_PGDN		0x0C	// FF form feed ^L		... page down
#define CH_FF		CH_PGDN
#define CH_CR		0x0D	// CR carriage return ^M	... enter, next row, run file
#define CH_NEW		0x0E	// SO shift-out ^N		... new file
#define CH_OPEN		0x0F	// SI shift-in ^O		... open file, edit file
#define CH_PRINT	0x10	// DLE data link escape ^P	... print file, send file
#define CH_QUERY	0x11	// DC1 device control 1 ^Q	... display help (query)
#define CH_REPLACE	0x12	// DC2 device control 2 ^R	... find and replace
#define CH_SAVE		0x13	// DC3 device control 3 ^S	... save file
#define CH_INS		0x14	// DC4 device control 4 ^T	... toggle Insert switch, mark file
#define CH_HOME		0x15	// NAK negative acknowledge ^U	... begin of row, begin of files
#define CH_PASTE	0x16	// SYN synchronous idle ^V	... paste from clipboard
#define CH_SYN		CH_PASTE
#define CH_CLOSE	0x17	// ETB end of transmission block ^W ... close file
#define CH_CUT		0x18	// CAN cancel ^X		... cut selected text
#define CH_REDO		0x19	// EM end of medium ^Y		... redo previously undo action
#define CH_UNDO		0x1A	// SUB subtitle character ^Z	... undo action
#define CH_ESC		0x1B	// ESC escape ^[		... break, menu
#define CH_RIGHT	0x1C	// FS file separator ^back_slash ... Right, Shift: End, Ctrl: Word right
#define CH_UP		0x1D	// GS group separator ^]	... Up, Shift: PageUp, Ctrl: Text start
#define CH_LEFT		0x1E	// RS record separator ^^	... Left, Shift: Home, Ctrl: Word left
#define CH_DOWN		0x1F	// US unit separator ^_		... Down, Shift: PageDn, Ctrl: Text end
#define CH_SPC		0x20	// SPC space

#define CH_DEL		0x7F	// delete			... delete character on cursor, Ctrl: delete block, delete file

#define _T(a) a		// not using wide characters

// ----------------------------------------------------------------------------
//                           Real numbers control
// ----------------------------------------------------------------------------

// angle unit
#define UNIT_DEG	0	// degrees
#define UNIT_RAD	1	// radians
#define UNIT_GRAD	2	// grads

// radix numeric base
#define BASE_DEC	0	// decimal
#define BASE_BIN	1	// binary
#define BASE_OCT	2	// octal
#define BASE_HEX	3	// hexadecimal

//extern unsigned char Base;		// current numeric radix base BASE_*

// exponent mode
#define EXP_AUTO	0	// auto mode
#define EXP_FIX		1	// fixed mode (no exponent on small numbers)
#define EXP_EE		2	// exponent mode
#define EXP_ENG		3	// engineering technical mode (exponent multiply of 3)

// rounding
#define FIX_OFF		-1	// fix decimals are off

#define EDITBUF_MAX	3000	// size of edit buffer (without terminating 0)
						// - should be big enough to decode BIN format, use MAX_DIG*4

// ----------------------------------------------------------------------------
//                           Base Includes
// ----------------------------------------------------------------------------

// project configuration
#include "config.h"		// project configuration
#include <string.h>		// memcpy
#include <stdarg.h>		// va_list
#include <math.h>		// HUGE_VAL

#endif // _GLOBAL_H


// ****************************************************************************
//
//                               Text strings
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// - use pText as text object
// - before use, initialize text object using TextInit() (constructor)
// - after use, terminate text object using TextTerm() (destructor)

#ifdef __cplusplus
extern "C" {
#endif

// get length of ASCIIZ text string
int StrLen(const char* text);

// compare ASCIIZ text strings (returns 0=equal or returns character difference)
int StrComp(const char* text1, const char* text2);

#ifdef __cplusplus
}
#endif

#if USE_TEXT	// use Text strings, except StrLen and StrComp (lib_text.c, lib_text.h)

#ifndef _TEXT_H
#define _TEXT_H

#include "lib_mem.h"

#ifdef __cplusplus
extern "C" {
#endif

// Text string data
typedef struct
{
	// reference counter (number of owners, 0=nobody)
	volatile u32	ref;

	// length of text string
	s32		len;

	// ASCIIZ text string (including terminating zero)
	char		data[1];

} sTextData;

// size of text string data header, without text string
#define SIZEOFTEXTDATA (sizeof(u32) + sizeof(s32))

// Text object (pointer to text data)
typedef sTextData* pText;

// empty text string data
extern sTextData EmptyTextData;

// empty text
extern pText EmptyText;

// day of week text, 2 characters
extern const char* DayOfWeekText[7];

// month text, 3 characters
extern const char* MonthText[12];

// pre-set date formats
extern const char* DateForm[11];

#if USE_FLOAT		// use float support
// round coefficients, used in SetFloat function
extern const float SetFloatCoeff[11];
#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support
// round coefficients, used in SetDouble function
extern const double SetDoubleCoeff[19];
#endif // USE_DOUBLE		// use double support

// ============================================================================
//                           ASCIIZ string functions
// ============================================================================

// convert ASCIIZ text to INT number
//  - can be in HEX format 0xN or $N; 
//  - no overflow check
//  - big number can overflow to negative number (use retype to unsigned u32)
s32 StrToInt(const char* text);
INLINE u32 StrToUInt(const char* text) { return (u32)StrToInt(text); }

// convert ASCIIZ text to 64-bit INT number
//  - can be in HEX format 0xN or $N; 
//  - no overflow check
//  - big number can overflow to negative number (use retype to unsigned u64)
s64 StrToInt64(const char* text);
INLINE u64 StrToUInt64(const char* text) { return (u64)StrToInt64(text); }

#if USE_FLOAT		// use float support
// convert ASCIIZ text to FLOAT number
float StrToFloat(const char* text);

// check special float numbers
INLINE Bool CheckInfF(float num) { return ((u16*)&num)[1] == 0x7f80; } // 1#INF
INLINE Bool CheckSInfF(float num) { return ((u16*)&num)[1] == 0xff80; } // -1#INF
INLINE Bool CheckNanF(float num) { return ((u16*)&num)[1] == 0x7fc0; } // 1#NAN
INLINE Bool CheckSNanF(float num) { return ((u16*)&num)[1] == 0xffc0; } // -1#NAN
#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support
// convert ASCIIZ text to DOUBLE number
double StrToDouble(const char* text);

// check special double numbers
INLINE Bool CheckInfD(double num) { return ((u16*)&num)[3] == 0x7ff0; } // 1#INF
INLINE Bool CheckSInfD(double num) { return ((u16*)&num)[3] == 0xfff0; } // -1#INF
INLINE Bool CheckNanD(double num) { return ((u16*)&num)[3] == 0x7ff8; } // 1#NAN
INLINE Bool CheckSNanD(double num) { return ((u16*)&num)[3] == 0xfff8; } // -1#NAN
#endif // USE_DOUBLE		// use double support

// check special numbers
#if USE_FLOAT || USE_DOUBLE	// use float or double support
#if USE_DOUBLE		// use double support
INLINE Bool CheckInf(double num) { return CheckInfD(num); } // 1#INF
INLINE Bool CheckSInf(double num) { return CheckSInfD(num); } // -1#INF
INLINE Bool CheckNan(double num) { return CheckNanD(num); } // 1#NAN
INLINE Bool CheckSNan(double num) { return CheckSNanD(num); } // -1#NAN
#else			// use float support
INLINE Bool CheckInf(float num) { return CheckInfF(num); } // 1#INF
INLINE Bool CheckSInf(float num) { return CheckSInfF(num); } // -1#INF
INLINE Bool CheckNan(float num) { return CheckNanF(num); } // 1#NAN
INLINE Bool CheckSNan(float num) { return CheckSNanF(num); } // -1#NAN
#endif
#endif // USE_FLOAT || USE_DOUBLE	// use float or double support

// ============================================================================
//                     Internal functions - do not use them
// ============================================================================

// create new text data (on memory error returns NULL)
sTextData* TextDataNew(s32 len);

// resize text data (ref must be = 1, returns new pointer or NULL on memory error)
sTextData* TextDataResize(sTextData* data, s32 len);

// attach text data to text object (object must not be attached)
void TextAttach(pText* text, sTextData* data);

// detach (and destroy if needed) text data from text object
void TextDetach(pText* text);

// appropriate text string data before write (returns False on memory error)
Bool TextCopyWrite(pText* text);

// ============================================================================
//                        Base control functions
// ============================================================================

// initialize text object - attach empty text (object must not be attached)
// - to terminate, use TextTerm
void TextInit(pText* text);

// uninitialize text object - detach text data
INLINE void TextTerm(pText* text) { TextDetach(text); }

// get text data reference counter
INLINE u32 TextRef(const pText* text) { return (*text)->ref; }

// get text length
INLINE s32 TextLen(const pText* text) { return (*text)->len; }

// get pointer to ASCIIZ text
INLINE const char* TextPtr(const pText* text) { return (*text)->data; }

// set new length of the text (appropriates text, returns False on memory error)
Bool TextSetLen(pText* text, s32 len);

// empty (clear) text string
void TextEmpty(pText* text);

// check if text string is empty
INLINE Bool TextIsEmpty(const pText* text) { return (*text)->len == 0; }
INLINE Bool TextIsNotEmpty(const pText* text) { return (*text)->len != 0; }

// write text into buffer (without terminating zero), returns text length
int TextWrite(const pText* text, char* buf, int maxlen);

// write text into buffer with terminating zero (maxlen is max. length
//  without terminating zero), returns text length
int TextWriteZ(const pText* text, char* buf, int maxlen);

// NUL correction (check and truncate text if contains NUL character)
void TextCheckNul(pText* text);

// compare text stings (returns 0=equal or returns character difference)
INLINE int TextComp(const pText* text1, const pText* text2)
	{ return StrComp((*text1)->data, (*text2)->data); }

// ============================================================================
//                          Character of text string
// ============================================================================

// check if character index is valid
INLINE Bool TextIsValid(const pText* text, s32 inx) { return inx < (*text)->len; }
INLINE Bool TextIsNotValid(const pText* text, s32 inx) { return inx >= (*text)->len; }

// get character at given position (returns 0 if index is invalid)
char TextAt(const pText* text, s32 inx);

// get first character of text string (returns 0 if text string is empty)
char TextFirst(const pText* text);

// get last character of text string (returns 0 if text string is empty)
char TextLast(const pText* text);

// set character at given position (checks valid position, returns False on memory error)
Bool TextSetAt(pText* text, s32 inx, char ch);

// set first character of text string (checks valid position, returns False on memory error)
Bool TextSetFirst(pText* text, char ch);

// set last character of text string (checks valid position, returns False on memory error)
Bool TextSetLast(pText* text, char ch);

// ============================================================================
//                               Set text
// ============================================================================

// set text to single-CHAR string (returns False on memory error)
Bool TextSetChar(pText* text, char ch);

// set text from ASCII text with length (returns False on memory error)
Bool TextSetStrLen(pText* text, const char* str, s32 len);

// set text from ASCIIZ text (returns False on memory error)
Bool TextSetStr(pText* text, const char* str);

// set text from another text object
void TextSet(pText* dst, const pText* src);

// exchange text objects
void TextExc(pText* text1, pText* text2);

// ============================================================================
//                               Add text
// ============================================================================

// add repeated text (returns False on memory error)
Bool TextAddRep(pText* text, const pText* src, int rep);

// add repeated ASCII text string with length (returns False on memory error)
Bool TextAddRepStrLen(pText* text, const char* str, int rep, s32 len);

// add repeated ASCIIZ text string (returns False on memory error)
Bool TextAddRepStr(pText* text, const char* str, int rep);

// add repeated character (returns False on memory error)
Bool TextAddRepCh(pText* text, char ch, int rep);

// add repeated space character (returns False on memory error)
Bool TextAddRepSpc(pText* text, int rep);

// add text (returns False on memory error)
INLINE Bool TextAdd(pText* text, const pText* src)
	{ return TextAddRep(text, src, 1); }

// add ASCII text string with length (returns False on memory error)
INLINE Bool TextAddStrLen(pText* text, const char* str, s32 len)
	{ return TextAddRepStrLen(text, str, 1, len); }

// add ASCIIZ text string (returns False on memory error)
INLINE Bool TextAddStr(pText* text, const char* str)
	{ return TextAddRepStr(text, str, 1); }

// add character (returns False on memory error)
INLINE Bool TextAddCh(pText* text, char ch)
	{ return TextAddRepCh(text, ch, 1); }

// add space character (returns False on memory error)
INLINE Bool TextAddSpc(pText* text)
	{ return TextAddRepSpc(text, 1); }

// ============================================================================
//                           Set decadic integer
// ============================================================================

// set/add signed/unsigned INT number to text (sep = thousand separator or 0=none; returns False on memory error)
Bool TextSetAddInt(pText* text, s32 num, char sep, Bool add, Bool unsign);

// convert unsigned INT number to text (sep = thousand separator or 0=none; returns False on memory error)
INLINE Bool TextSetUInt(pText* text, u32 num, char sep)
	{ return TextSetAddInt(text, num, sep, False, True); }

// add unsigned INT number to text (sep = thousand separator or 0=none; returns False on memory error)
INLINE Bool TextAddUInt(pText* text, u32 num, char sep)
	{ return TextSetAddInt(text, num, sep, True, True); }

// convert signed INT number to text (sep = thousand separator or 0=none; returns False on memory error)
INLINE Bool TextSetInt(pText* text, s32 num, char sep)
	{ return TextSetAddInt(text, num, sep, False, False); }

// add signed INT number to text (sep = thousand separator or 0=none; returns False on memory error)
INLINE Bool TextAddInt(pText* text, s32 num, char sep)
	{ return TextSetAddInt(text, num, sep, True, False); }

// set/add signed/unsigned 64-bit INT number to text (sep = thousand separator or 0=none; returns False on memory error)
Bool TextSetAddInt64(pText* text, s64 num, char sep, Bool add, Bool unsign);

// convert unsigned INT number to text (sep = thousand separator or 0=none; returns False on memory error)
INLINE Bool TextSetU64(pText* text, u64 num, char sep)
	{ return TextSetAddInt64(text, num, sep, False, True); }

// add unsigned INT number to text (sep = thousand separator or 0=none; returns False on memory error)
INLINE Bool TextAddU64(pText* text, u64 num, char sep)
	{ return TextSetAddInt64(text, num, sep, True, True); }

// convert signed INT number to text (sep = thousand separator or 0=none; returns False on memory error)
INLINE Bool TextSetS64(pText* text, s64 num, char sep)
	{ return TextSetAddInt64(text, num, sep, False, False); }

// add signed INT number to text (sep = thousand separator or 0=none; returns False on memory error)
INLINE Bool TextAddS64(pText* text, s64 num, char sep)
	{ return TextSetAddInt64(text, num, sep, True, False); }

// convert text to signed integer number
//  - can be in HEX format 0xN or $N; 
INLINE s32 TextToInt(const pText* text) { return StrToInt((*text)->data); }

// convert text to unsigned integer number
//  - can be in HEX format 0xN or $N; 
INLINE u32 TextToUInt(const pText* text) { return (u32)StrToInt((*text)->data); }

// convert text to 64-bit signed integer number
//  - can be in HEX format 0xN or $N; 
INLINE s64 TextToS64(const pText* text) { return StrToInt64((*text)->data); }

// convert text to 64-bit unsigned integer number
//  - can be in HEX format 0xN or $N; 
INLINE u64 TextToU64(const pText* text) { return (u64)StrToInt64((*text)->data); }

// ============================================================================
//                             Set digits
// ============================================================================

// set/add 2 digits (returns False on memory error)
Bool TextSetAdd2Dig(pText* text, s8 num, Bool add);

// set 2 digits (returns False on memory error)
INLINE Bool TextSet2Dig(pText* text, s8 num)
	{ return TextSetAdd2Dig(text, num, False); }

// add 2 digits (returns False on memory error)
INLINE Bool TextAdd2Dig(pText* text, s8 num)
	{ return TextSetAdd2Dig(text, num, True); }

// set/add 2 digits with space padding (returns False on memory error)
Bool TextSetAdd2DigSpc(pText* text, s8 num, Bool add);

// set 2 digits with space padding (returns False on memory error)
INLINE Bool TextSet2DigSpc(pText* text, s8 num)
	{ return TextSetAdd2DigSpc(text, num, False); }

// add 2 digits with space padding (returns False on memory error)
INLINE Bool TextAdd2DigSpc(pText* text, s8 num)
	{ return TextSetAdd2DigSpc(text, num, True); }

// set/add 4 digits (returns False on memory error)
Bool TextSetAdd4Dig(pText* text, s16 num, Bool add);

// set 4 digits (returns False on memory error)
INLINE Bool TextSet4Dig(pText* text, s16 num)
	{ return TextSetAdd4Dig(text, num, False); }

// add 4 digits (returns False on memory error)
INLINE Bool TextAdd4Dig(pText* text, s16 num)
	{ return TextSetAdd4Dig(text, num, True); }

// ============================================================================
//                           Set HEX integer
// ============================================================================

// convert integer to text as HEX (digits <= 0 to auto-digits,
//  sep = 4-digit separator or 0=none; returns False on memory error)
Bool TextSetAddHex(pText* text, u32 num, s8 digits, char sep, Bool add);

// convert integer to text as HEX (digits <= 0 to auto-digits,
//  sep = 4-digit separator or 0=none; returns False on memory error)
INLINE Bool TextSetHex(pText* text, u32 num, s8 digits, char sep)
	{ return TextSetAddHex(text, num, digits, sep, False); }

// add integer to text as HEX (digits <= 0 to auto-digits,
//  sep = 4-digit separator or 0=none; returns False on memory error)
INLINE Bool TextAddHex(pText* text, u32 num, s8 digits, char sep)
	{ return TextSetAddHex(text, num, digits, sep, True); }

// convert 64-bit integer to text as HEX (digits <= 0 to auto-digits,
//  sep = 4-digit separator or 0=none; returns False on memory error)
Bool TextSetAddHex64(pText* text, u64 num, s8 digits, char sep, Bool add);

// convert 64-bit integer to text as HEX (digits <= 0 to auto-digits,
//  sep = 4-digit separator or 0=none; returns False on memory error)
INLINE Bool TextSetHex64(pText* text, u64 num, s8 digits, char sep)
	{ return TextSetAddHex64(text, num, digits, sep, False); }

// add 64-bit integer to text as HEX (digits <= 0 to auto-digits,
//  sep = 4-digit separator or 0=none; returns False on memory error)
INLINE Bool TextAddHex64(pText* text, u64 num, s8 digits, char sep)
	{ return TextSetAddHex64(text, num, digits, sep, True); }

// ============================================================================
//                           Set decimal number
// ============================================================================

#if USE_FLOAT		// use float support

// convert FLOAT number to text (returns False on error; recommended digits=6)
Bool TextSetAddFloat(pText* text, float num, s8 digits, Bool add);

// convert FLOAT number to text (returns False on error; recommended digits=6)
INLINE Bool TextSetFloat(pText* text, float num, s8 digits)
	{ return TextSetAddFloat(text, num, digits, False); }

// add FLOAT number to text (returns False on error; recommended digits=6)
INLINE Bool TextAddFloat(pText* text, float num, s8 digits)
	{ return TextSetAddFloat(text, num, digits, True); }

// convert text to float number
INLINE float TextToFloat(const pText* text) { return StrToFloat((*text)->data); }

#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support

// convert DOUBLE number to text (returns False on error; recommended digits=14)
Bool TextSetAddDouble(pText* text, double num, s8 digits, Bool add);

// convert DOUBLE number to text (returns False on error; recommended digits=14)
INLINE Bool TextSetDouble(pText* text, double num, s8 digits)
	{ return TextSetAddDouble(text, num, digits, False); }

// add DOUBLE number to text (returns False on error; recommended digits=14)
INLINE Bool TextAddDouble(pText* text, double num, s8 digits)
	{ return TextSetAddDouble(text, num, digits, True); }

// convert text to double number
INLINE double TextToDouble(const pText* text) { return StrToDouble((*text)->data); }

#endif // USE_DOUBLE		// use double support

// ============================================================================
//                           Date and time
// ============================================================================

// set/add time in Unix format (number of seconds and milliseconds, returns False on memory error)
//   ut: time in Unix format
//   ms: number of milliseconds
//   hour: hour format 0=1:23, 1= 1:23, 2=01:23, 3=1.23p
//   sec: second format 0=1:23, 1=1:23:45, 2=1:23:45.678
//   sep: separator 0=none, 1=":" and ".", 2=":" and ",", 3="." and ","
Bool TextSetAddTime(pText* text, u32 ut, s16 ms, s8 hour, s8 sec, s8 sep, Bool add);

// set time in Unix format (number of seconds and milliseconds, returns False on memory error)
INLINE Bool TextSetTime(pText* text, u32 ut, s16 ms, s8 hour, s8 sec, s8 sep)
	{ return TextSetAddTime(text, ut, ms, hour, sec, sep, False); }

// add time in Unix format (number of seconds and milliseconds, returns False on memory error)
INLINE Bool TextAddTime(pText* text, u32 ut, s16 ms, s8 hour, s8 sec, s8 sep)
	{ return TextSetAddTime(text, ut, ms, hour, sec, sep, True); }

// set/add day of week 2-character text from Unix time
Bool TextSetAddDow(pText* text, u32 ut, Bool add);

// set day of week 2-character text from Unix time
INLINE Bool TextSetDow(pText* text, u32 ut)
	{ return TextSetAddDow(text, ut, False); }

// add day of week 2-character text from Unix time
INLINE Bool TextAddDow(pText* text, u32 ut)
	{ return TextSetAddDow(text, ut, True); }

// set/add date in custom format (returns False on memory error)
//   form: formating string
//    d ... day 1 or 2 digits
//    D ... day 2 digits
//    m ... month 1 or 2 digits
//    M ... month 2 digits
//    N ... month name 3 letters
//    y ... year 2 digits
//    Y ... year 4 digits
Bool TextSetAddDateCustom(pText* text, s16 year, s8 mon, s8 day, const char* form, Bool add);

// set date in custom format (returns False on memory error)
INLINE Bool TextSetDateCustom(pText* text, s16 year, s8 mon, s8 day, const char* form)
	{ return TextSetAddDateCustom(text, year, mon, day, form, False); }

// add date in custom format (returns False on memory error)
INLINE Bool TextAddDateCustom(pText* text, s16 year, s8 mon, s8 day, const char* form)
	{ return TextSetAddDateCustom(text, year, mon, day, form, True); }

// set date in pre-select format (returns False on memory error)
//  USA format
//    0 ... M/D/y (01/25/22)
//    1 ... m/d/Y (1/25/2022)
//    2 ... M/D/Y (01/25/2022)
//    3 ... N d,Y (Jan 25,2022)
//  European format
//    4 ... D.M.y (25.01.22)
//    5 ... d.m.Y (25.1.2022)
//    6 ... D.M.Y (25.01.2022)
//    7 ... d. N Y (25. Jan 2022)
//  ISO format
//    8 ... y-M-D (22-01-25)
//    9 ... Y-M-D (2022-01-25)
//  Technical format
//   10 ... yMD (220125)
Bool TextSetDate(pText* text, s16 year, s8 mon, s8 day, u8 form);

// add date in pre-select format (returns False on memory error)
Bool TextAddDate(pText* text, s16 year, s8 mon, s8 day, u8 form);

// set date in Unix (returns False on memory error)
Bool TextSetDateUnix(pText* text, u32 ut, u8 form);

// add date in Unix (returns False on memory error)
Bool TextAddDateUnix(pText* text, u32 ut, u8 form);

// set/add Unix date and time in technical format yyyymmddhhmmssmmm (17 digits, returns False on memory error)
Bool TextSetAddDateTech(pText* text, u32 ut, u16 ms, Bool add);

// set Unix date and time in technical format yyyymmddhhmmssmmm (17 digits, returns False on memory error)
INLINE Bool TextSetDateTech(pText* text, u32 ut, u16 ms)
	{ return TextSetAddDateTech(text, ut, ms, False); }

// add Unix date and time in technical format yyyymmddhhmmssmmm (17 digits, returns False on memory error)
INLINE Bool TextAddDateTech(pText* text, u32 ut, u16 ms)
	{ return TextSetAddDateTech(text, ut, ms, True); }

// ============================================================================
//                          Find and replace
// ============================================================================

// find character from starting position (returns position or -1=not found)
int TextFindChar(const pText* text, char ch, int pos);

// find character reversed from starting position (returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindCharRev(const pText* text, char ch, int pos);

// find white space character from starting position (space/tab/newline 1..32, returns position or -1=not found)
int TextFindSpace(const pText* text, int pos);

// find white space character reverse from starting position (space/tab/newline 1..32, returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindSpaceRev(const pText* text, int pos);

// find non white space character from starting position (no space/tab/newline > 32, returns position or -1=not found)
int TextFindNoSpace(const pText* text, int pos);

// find non white space character reverse from starting position (no space/tab/newline > 32, returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindNoSpaceRev(const pText* text, int pos);

// find text from starting position (returns position or -1=not found)
int TextFind(const pText* text, const pText* fnd, int pos);

// find string with length from starting position (returns position or -1=not found)
int TextFindStrLen(const pText* text, const char* fnd, s32 len, int pos);

// find string from starting position (returns position or -1=not found)
INLINE int TextFindStr(const pText* text, const char* fnd, int pos)
	{ return TextFindStrLen(text, fnd, -1, pos); }

// find text reverse from starting position (returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindRev(const pText* text, const pText* fnd, int pos);

// find string with length reverse from starting position (returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindStrLenRev(const pText* text, const char* fnd, s32 len, int pos);

// find string reverse from starting position (returns position or -1=not found)
//   use pos=BIGINT to search from the end
INLINE int TextFindStrRev(const pText* text, const char* fnd, int pos)
	{ return TextFindStrLenRev(text, fnd, -1, pos); }

// find characters from string list with length (returns position or -1=not found)
int TextFindListStrLen(const pText* text, const char* list, int len, int pos);

// find characters from string list (returns position or -1=not found)
INLINE int TextFindListStr(const pText* text, const char* list, int pos)
	{ return TextFindListStrLen(text, list, -1, pos); }

// find characters from text list (returns position or -1=not found)
INLINE int TextFindList(const pText* text, const pText* list, int pos)
	{ return TextFindListStrLen(text, (*list)->data, (*list)->len, pos); }

// find characters from string list with length (returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindListStrLenRev(const pText* text, const char* list, int len, int pos);

// find characters from string list (returns position or -1=not found)
//   use pos=BIGINT to search from the end
INLINE int TextFindListStrRev(const pText* text, const char* list, int pos)
	{ return TextFindListStrLenRev(text, list, -1, pos); }

// find characters from text list (returns position or -1=not found)
//   use pos=BIGINT to search from the end
INLINE int TextFindListRev(const pText* text, const pText* list, int pos)
	{ return TextFindListStrLenRev(text, (*list)->data, (*list)->len, pos); }

// find characters except string list with length (returns position or -1=not found)
int TextFindExceptListStrLen(const pText* text, const char* list, int len, int pos);

// find characters except string list (returns position or -1=not found)
INLINE int TextFindExceptListStr(const pText* text, const char* list, int pos)
	{ return TextFindExceptListStrLen(text, list, -1, pos); }

// find characters except string list (returns position or -1=not found)
INLINE int TextFindExceptList(const pText* text, const pText* list, int pos)
	{ return TextFindExceptListStrLen(text, (*list)->data, (*list)->len, pos); }

// find characters reverse except string list with length (returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindExceptListStrLenRev(const pText* text, const char* list, int len, int pos);

// find characters reverse except string list (returns position or -1=not found)
//   use pos=BIGINT to search from the end
INLINE int TextFindExceptListStrRev(const pText* text, const char* list, int pos)
	{ return TextFindExceptListStrLenRev(text, list, -1, pos); }

// find characters reverse except string list (returns position or -1=not found)
//   use pos=BIGINT to search from the end
INLINE int TextFindExceptListRev(const pText* text, const pText* list, int pos)
	{ return TextFindExceptListStrLenRev(text, (*list)->data, (*list)->len, pos); }

// substitute text (returns False on memory error)
Bool TextSubst(pText* text, const pText* find, const pText* subst);

// substitute characters from string list with length (returns False on memory error)
Bool TextSubstListStrLen(pText* text, const char* list, const char* subst, int len);

// substitute characters from string list (returns False on memory error)
INLINE Bool TextSubstListStr(pText* text, const char* list, const char* subst)
	{ return TextSubstListStrLen(text, list, subst, -1); }

// substitute characters from text list (returns False on memory error)
INLINE Bool TextSubstList(pText* text, const pText* list, const pText* subst)
	{ return TextSubstListStrLen(text, (*list)->data, (*subst)->data, -1); }

// ============================================================================
//                              Conversion
// ============================================================================

// convert text to uppercase (returns False on memory error)
Bool TextUpperCase(pText* text);

// convert text to lowercase (returns False on memory error)
Bool TextLowerCase(pText* text);

// convert text to opposite case (returns False on memory error)
Bool TextFlipCase(pText* text);

// convert text to wordcase - first letter upper (returns False on memory error)
Bool TextWordCase(pText* text);

// convert text to reverse order (returns False on memory error)
Bool TextReverse(pText* text);

// ============================================================================
//                              Part of text
// ============================================================================

// left part of text (returns False on memory error)
Bool TextLeft(pText* dst, const pText* src, int len);

// right part of text (returns False on memory error)
Bool TextRight(pText* dst, const pText* src, int len);

// right part of text from position (returns False on memory error)
Bool TextRightFrom(pText* dst, const pText* src, int pos);

// middle part of text (returns False on memory error)
Bool TextMid(pText* dst, const pText* src, int pos, int len);

// ============================================================================
//                              Insert/delete
// ============================================================================

// insert string with length (returns False on memory error)
Bool TextInsertStrLen(pText* dst, int pos, const char* src, int len);

// insert string (returns False on memory error)
INLINE Bool TextInsertStr(pText* dst, int pos, const char* src)
	{ return TextInsertStrLen(dst, pos, src, -1); }

// insert text (returns False on memory error)
INLINE Bool TextInsert(pText* dst, int pos, const pText* src)
	{ return TextInsertStrLen(dst, pos, (*src)->data, (*src)->len); }

// insert character (returns False on memory error)
Bool TextInsertChar(pText* dst, int pos, char ch);

// delete characters (returns False on memory error)
Bool TextDelete(pText* text, int pos, int num);

// delete first character (returns False on memory error)
INLINE Bool TextDelFirst(pText* text) { return TextDelete(text, 0, 1); }

// delete last character (returns False on memory error)
INLINE Bool TextDelLast(pText* text) { return TextDelete(text, (*text)->len - 1, 1); }

// delete text to end (returns False on memory error)
INLINE Bool TextDelToEnd(pText* text, int pos) { return TextDelete(text, pos, BIGINT); }

// delete characters from string list with length (returns False on memory error)
Bool TextDelListStrLen(pText* text, const char* list, int len);

// delete characters from string list (returns False on memory error)
INLINE Bool TextDelListStr(pText* text, const char* list)
	{ return TextDelListStrLen(text, list, -1); }

// delete characters from text list (returns False on memory error)
INLINE Bool TextDelList(pText* text, const pText* list)
	{ return TextDelListStrLen(text, (*list)->data, (*list)->len); }

// delete characters except string list with length (returns False on memory error)
Bool TextDelExceptListStrLen(pText* text, const char* list, int len);

// delete characters except string list (returns False on memory error)
INLINE Bool TextDelExceptListStr(pText* text, const char* list)
	{ return TextDelExceptListStrLen(text, list, -1); }

// delete characters except text list (returns False on memory error)
INLINE Bool TextDelExceptList(pText* text, const pText* list)
	{ return TextDelExceptListStrLen(text, (*list)->data, (*list)->len); }

// find and delete all string words with length (returns False on memory error)
Bool TextDelWordStrLen(pText* text, const char* word, int len);

// find and delete all string words (returns False on memory error)
INLINE Bool TextDelWordStr(pText* text, const char* word)
	{ return TextDelWordStrLen(text, word, -1); }

// find and delete all text words (returns False on memory error)
INLINE Bool TextDelWord(pText* text, pText* word)
	{ return TextDelWordStrLen(text, (*word)->data, (*word)->len); }

// trim white spaces from begin of the string (returns False on memory error)
Bool TextTrimLeft(pText* text);

// trim white spaces from end of the string (returns False on memory error)
Bool TextTrimRight(pText* text);

// trim white spaces from begin and end of the string (returns False on memory error)
INLINE Bool TextTrim(pText* text) { return TextTrimRight(text) && TextTrimLeft(text); }

// ============================================================================
//                              Multi-line text
// ============================================================================

// get number of rows of multi-line text (search LF)
int TextRowsNum(const pText* text);

// get one row from multi-line text (search LF, trim CR, returns False on memory error)
Bool TextRow(pText* dst, const pText* src, int row);

// unformat text - substitute white characters with one space character
Bool TextUnformat(pText* text);

// reformat text to different width of paragraph (inserts LF)
Bool TextReformat(pText* text, int width);

// ============================================================================
//                              Formated print
// ============================================================================

// formated print string into text, with argument list
//  text = NULL to get text length without printing
//  - fmt and destination text cannot be the same
u32 TextPrintArg(pText* text, const char* fmt, va_list args);

// formated print string into text, with variadic arguments
//  text = NULL to get text length without printing
//  - fmt and destination text cannot be the same
NOINLINE u32 TextPrint(pText* text, const char* fmt, ...);

// add formated print string into text, with argument list
//  - fmt and destination text cannot be the same
u32 TextAddPrintArg(pText* text, const char* fmt, va_list args);

// add formated print string into text, with variadic arguments
//  - fmt and destination text cannot be the same
NOINLINE u32 TextAddPrint(pText* text, const char* fmt, ...);

#ifdef __cplusplus
}
#endif

#endif // _TEXT_H

#endif // USE_TEXT	// use Text strings (lib_text.c, lib_text.h)

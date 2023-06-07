
// ****************************************************************************
//
//                      Calendar 64-bit (year range -29227..+29227)
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// Absolute time: number of 100-nanosec since Saturday 1/1/1 CE 0:00:00 (s64 number), year range 29227 BCE to 29227 CE
// Absolute day: number of days since Saturday 1/1/1 CE (= day 0, range -10675162 .. +10674943)
// Julian date: number of days since Monday 1/1/4713 BCE noon 12:00:00 (double number)
// Unix time: number of seconds since Thursday 1/1/1970 CE 0:00:00 (u32 number, =abs. day 719164)
// File time: number of 100-nanosec since Monday 1/1/1601 CE 0:00:00 (=abs. day 584390)

#if USE_CALENDAR64	// use 32-bit calendar (lib_calendar.c, lib_calendar.h)

#ifndef _CALENDAR64_H
#define _CALENDAR64_H

#include "lib_calendar.h"

#ifdef __cplusplus
extern "C" {
#endif

// total 58454 years, 0xE456
#define MINYEAR2 -29226		// min. year (= 29227 BCE)
#define MAXYEAR2 +29227		// max. year (= 29227 CE)

// total 21350106 days, 0x145C6DA
#define MINDAY2 -10675162	// min. absolute day
#define MAXDAY2 +10674943	// max. absolute day

#define JULIANBASE 1721423.5	// base Julian day (1/1/1 CE, 0:00:00)
#define ABSTODAYCOEF 1.1574074074074074074074e-12 // abs. time to Julian days coefficient
#define DAYTOABSCOEF 864000000000.0 // Julian days to absolute time coefficient

//#define MAXTIME (60*60*24-1)	// max. time of day in seconds (=86399, 23:59:59)
#define DAY100NS ((s64)24*60*60*10000000) // one day in 100-ns (=864000000000, 0xC9:2A69:C000)
#define MAXUNIXDT 4102444799	// max. value of Unix date and time value (=0xF48656FF)
				//    0 = 00:00:00 1/1/1970
				//    4102444799 (0xF48656FF) = 23:59:59 12/31/2099

// Last day of Julian calendar: 10/4/1582
// First day of Gregorian calendar: 10/15/1582 (10 days skipped)
#define SPLITYEAR 1582		// split year Julian -> Gregorian
#define SPLITDATE 577737	// split day (first day of Gregorian calendar): 10/15/1582

#define FILETIMEOFF (s64)504912960000000000 // Windows file time base offset
#define FILETIMEDAY 584390	// absolute day of Windows file time base (=day of Monday 1/1/1601 CE 0:00:00)

#define UNIXBASEOFF (s64)621357696000000000 // Unix base offset
#define UNIXBASEDAY 719164	// absolute day of Unix base (=day of Thursday 1/1/1970 CE 0:00:00)

// total 18446491584000000000 ticks, 0xFFFF:1A5C:A88D:8000
#define MINTIME2 (s64)-9223339968000000000 // minimal absolute time, 0x8000:1D2A:9CB2:8000 (Friday 1/1/29227 BCE 0:0:0.0)
#define MAXTIME2 (s64)9223151615999999999 // maximal absolute time, 0x7FFF:3787:453F:FFFF (Friday 12/31/29227 CE 23:59:59.9999999)

/* // Already defined in calendar.h
// days in month
extern const s8 DaysInMonth[12]; // normal year
extern const s8 DaysInMonthLeap[12]; // leap year

// days in months from start of year (in normal year)
extern const s16 DaysInYear[13];

// day of week name - short
extern const LPCTSTR day_of_week_name[7];

// day of week name - long
extern const LPCTSTR day_of_week_name2[7];
*/

// date and time structure
typedef struct {

	union {
		struct {
			// extended entries
			u8	flags;		// flags DTFLAG_*
			s8	week;		// week in year 1..53
			s16	dayofyear;	// day of year 1..366
			// nanoseconds
			s32	nsec;		// nanoseconds 0..999'999'999
			// time
			s8	dayofweek;	// day of week 0=Sunday..6=Saturday
			s8	sec;		// second 0..59
			s8	min;		// minute 0..59
			s8	hour;		// hour 0..23
			// date
			s8	day;		// day in month 1..31
			s8	mon;		// month 1..12
			s16	year;		// year -29226 .. +29227 (value 0 is year 1 BCE)
		};

		struct {
			s32	ext;		// extended entries
			s32	nsec2;		// nanoseconds
			s32	time;		// time (with day of week)
			s32	date;		// date
		};
	};
} sDateTime64;

// datetime flags (special case: year 1582 has 355 days, not leap, 51 weeks)
#define DTFLAG_LEAP	B0	// leap year
#define DTFLAG_GREG	B1	// date of gregorian calendar (or julian otherwise)
#define DTFLAG_W53	B2	// year has 53 weeks (or 52 weeks otherwise)
#define DTFLAG_LASTW	B3	// last week of previous year
#define DTFLAG_FIRSTW 	B4	// first week of next year

// day of week (already defined in calendar.h)
/*
enum {
	DAY_SUN = 0,	// Sunday
	DAY_MON = 1,	// Monday
	DAY_TUE = 2,	// Tuesday
	DAY_WED = 3,	// Wednesday
	DAY_THU = 4,	// Thursday
	DAY_FRI = 5,	// Friday
	DAY_SAT = 6,	// Saturday
};
*/

// get flag - leap year DTFLAG_LEAP
INLINE Bool DateTime64IsLeap(sDateTime64* dt) { return (dt->flags & DTFLAG_LEAP) != 0; } 

// get flag - date of Gregorian calendar (or Julian otherwise) DTFLAG_GREG
INLINE Bool DateTime64IsGreg(sDateTime64* dt) { return (dt->flags & DTFLAG_GREG) != 0; }

// get flag - year has 53 weeks DTFLAG_W53
INLINE Bool DateTime64IsW53(sDateTime64* dt) { return (dt->flags & DTFLAG_W53) != 0; }

// get flag - last week of previous year DTFLAG_LASTW
INLINE Bool DateTime64IsLastW(sDateTime64* dt) { return (dt->flags & DTFLAG_LASTW) != 0; }

// get flag - first week of next year DTFLAG_FIRSTW
INLINE Bool DateTime64IsFirstW(sDateTime64* dt) { return (dt->flags & DTFLAG_FIRSTW) != 0; }

#if USE_DOUBLE		// use double support
// convert absolute time to Julian date
double AbsTimeToJulian(s64 time);

// convert Julian date to absolute time
s64 JulianToAbsTime(double jul);
#endif // USE_DOUBLE

// convert absolute time to absolute day (MINDAY2..MAXDAY2)
s32 AbsTimeToDay(s64 time);

// convert absolute day to absolute time
s64 DayToAbsTime(s32 day);

// convert absolute time to filetime (Windows)
s64 AbsTimeToFileTime(s64 time);

// convert filetime (Windows) to absolute time
s64 FileTimeToAbsTime(s64 time);

// convert absolute time to Unix time and ms (if not NULL)
u32 AbsTimeToUnixTime(s64 time, s16* ms, s16* us);

// convert Unix time and ms to absolute time
s64 UnixTimeToAbsTime(u32 ut, s16 ms, s16 us);

// check if long year is leap year
Bool YearIsLeap64(s16 year);

// get last day in month (28..31, use long year)
u8 GetLastDayMonth64(s8 mon, s16 year);

// get days in long year (355, 365, 366)
s16 GetDaysInYear64(s16 year);

// clear date and time structure (set to 0:0:0 1/1/1)
void DateTime64Clear(sDateTime64* dt);

// set date and time (day of week and flags are not updated)
void DateTime64Set(sDateTime64* dt, s16 year, s8 mon, s8 day, s8 hour, s8 min, s8 sec, s32 nsec);

// copy date and time from another structure
void DateTime64Copy(sDateTime64* dst, const sDateTime64* src);

// compare date and time (day of week is ignored), returns -1 if dt1 < dt2, 0 if dt1 == dt2, 1 if dt1 > dt2
s8 DateTime64Comp(const sDateTime64* dt1, const sDateTime64* dt2);

// validate date and time (not day of week; returns True = no corrections, entries were in valid ranges)
Bool DateTime64Valid(sDateTime64* dt);

// increase date structure by 1 day (extended entries are not updated, returns False on overflow)
Bool DateTime64Inc(sDateTime64* dt);

// decrease date structure by 1 day (extended entries are not updated, returns False on underflow)
Bool DateTime64Dec(sDateTime64* dt);

// pack date into absolute day (day of week is ignored), MINDAY2..MAXDAY2
//  Takes 1.3 us.
s32 DateTime64PackDay(sDateTime64* dt);

// pack date and time into absolute time (day of week is ignored)
//  Takes 2.8 us.
s64 DateTime64PackAbsTime(sDateTime64* dt);

// unpack date from absolute day (updates day of week too, time will be zeroed)
//  Takes 7.5 us.
void DateTime64UnpackDay(sDateTime64* dt, s32 day);

// unpack date and time from Unix time (updates day of week too)
//  Takes 8 us.
void DateTime64UnpackUnixTime(sDateTime64* dt, u32 ut, s16 ms, s16 us);

// unpack date and time from absolute time (updates day of week too)
//  Takes 7 us.
void DateTime64UnpackAbsTime(sDateTime64* dt, s64 time);

// debug test date time structure
extern sDateTime64 DebTestDateTime;
extern sDateTime64 DebTestDateTime2;
extern s64 DebTestAbsTime;
extern s64 DebTestAbsTime2;

// initialize debug test calendar - default set MINYEAR2 (returns False on error)
void DebTestCalendarInit(int year);

// one step of debug test calendar (complete test takes a few minutes)
//  0 = running OK
//  1 = end
//  2 = invalid structure 1
//  3 = invalid structure 2
//  4 = invalid Nsec
//  5 = invalid sec
//  6 = invalid min
//  7 = invalid hour
//  8 = invalid day
//  9 = invalid month
//  10 = invalid year
//  11 = invalid day of week
//  12 = invalid abs. time
//  13 = invalid packed day
int DebTestCalendarStep();

// Calendar test loop
//void DebTestCalendarLoop();

// datetime64 fast check (returns year on error or 0 if OK)
//s16 DateTime64FastCheck(int loops);

#ifdef __cplusplus
}
#endif

#endif // _CALENDAR64_H

#endif // USE_CALENDAR64	// use 32-bit calendar (lib_calendar.c, lib_calendar.h)

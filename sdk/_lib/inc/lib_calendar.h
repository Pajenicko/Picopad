
// ****************************************************************************
//
//                       Calendar 32-bit (year range 1970..2099)
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// This calendar system is based on 32-bit Unix time (number of seconds since 1/1/1970).

#if USE_CALENDAR	// use 32-bit calendar (lib_calendar.c, lib_calendar.h)

#ifndef _CALENDAR_H
#define _CALENDAR_H

#ifdef __cplusplus
extern "C" {
#endif

#define MINYEAR 1970		// min. year
#define MAXYEAR	2099		// max. year
#define MAXDAY 47481		// max. day (12/31/2099)
#define MAXTIME (60*60*24-1)	// max. time of day in seconds (=86399, 23:59:59)
#define MAXUNIXDT 4102444799	// max. value of Unix date and time value (=0xF48656FF)
				//    0 = 00:00:00 1/1/1970
				//    4102444799 (0xF48656FF) = 23:59:59 12/31/2099

// days in month
extern const s8 DaysInMonth[12]; // normal year
extern const s8 DaysInMonthLeap[12]; // leap year

// days in months from start of year (in normal year)
extern const s16 DaysInYear[13];

// day of week name - short
extern const char* DayOfWeekName[7];

// day of week name - long
extern const char* DayOfWeekName2[7];

// date and time structure
typedef struct {

	union {
		struct {
			s16	us;		// microseconds 0..999
			s16	ms;		// milliseconds 0..999
		};
		s32	timelow;	// microseconds and milliseconds
	};	

	union {
		struct {
			s8	dayofweek;	// day of week 0=Sunday..6=Saturday
			s8	sec;		// second 0..59
			s8	min;		// minute 0..59
			s8	hour;		// hour 0..23
		};
		s32	time;		// time (with day of week)
	};

	union {
		struct {
			s8	day;		// day in month 1..31
			s8	mon;		// month 1..12
			s16	year;		// year year 1970..2099
		};
		s32	date;		// date
	};

} sDateTime;

// day of week
enum {
	DAY_SUN = 0,	// Sunday
	DAY_MON = 1,	// Monday
	DAY_TUE = 2,	// Tuesday
	DAY_WED = 3,	// Wednesday
	DAY_THU = 4,	// Thursday
	DAY_FRI = 5,	// Friday
	DAY_SAT = 6,	// Saturday
};

// check if year is leap using Greagorian calendar (=February has 29 days instead of 28)
Bool YearIsLeap(s16 year);

// clear date and time structure (set to 0:0:0 1/1/1970 thursday)
void DateTimeClear(sDateTime* dt);

// set date and time (day of week is cleared)
void DateTimeSet(sDateTime* dt, s16 year, s8 mon, s8 day, s8 hour, s8 min, s8 sec, s16 ms, s16 us);

// copy date and time from another structure
void DateTimeCopy(sDateTime* dst, const sDateTime* src);

// compare date and time (day of week is ignored), returns -1 if dt1 < dt2, 0 if dt1 == dt2, 1 if dt1 > dt2
s8 DateTimeComp(const sDateTime* dt1, const sDateTime* dt2);

// validate date and time (not day of week; returns True = no corrections, entries were in valid ranges)
Bool DateTimeValid(sDateTime* dt);

// increase date by 1 day (returns False on date overflow)
Bool DateTimeInc(sDateTime* dt);

// decrease date by 1 day (returns False on date underflow)
Bool DateTimeDec(sDateTime* dt);

// pack date and time into Unix time, optionally with ms and us if not NULL (day of week is ignored)
//  Takes 1 us
u32 DateTimePack(const sDateTime* dt, s16* ms, s16* us);

// unpack date and time from Unix time (updates day of week too)
//  Takes 2.3 us
void DateTimeUnpack(sDateTime* dt, u32 ut, s16 ms, s16 us);

// datetime check (returns year of error or 0 if OK)
s16 DateTimeCheck();

#ifdef __cplusplus
}
#endif

#endif // _CALENDAR_H

#endif // USE_CALENDAR	// use 32-bit calendar (lib_calendar.c, lib_calendar.h)

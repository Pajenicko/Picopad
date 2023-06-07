
// ****************************************************************************
//
//                      Calendar 64-bit (year range -29227..+29227)
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_CALENDAR64	// use 32-bit calendar (lib_calendar.c, lib_calendar.h)

#include "../inc/lib_calendar64.h"

/*
Julian date: days since 1/1/4713 BCE noon 12:00 (it was Monday)
Julian date has period 7980 years, then starts again.
Julian date range: 1/1/4713 BCE 12:00 to 1/1/3268 CE 12:00, e.g. 0 to 2914673
days. Julian period is 2518277472000000000 100-nanoseconds (e.g. 7980 years).

Julian calendar: till Thursday 10/4/1582 (begins julian date 2299159.5)
Gregorian calendar: from Friday 10/15/1582 (begins julian date 2299160.5)
1/1/1 CE: JD=1721423.5, Saturday (there is no year 0!)
1/1/1 BCE: JD=1721057.5 Thursday
Julian year: 365.25 days, Gregorian year: 365.2425 days.

ISO-8601: date format YYYY-WW-DD (year-week-day_of_week). Week: 1 to 53,
day of week: 1 to 7, 1=Monday. First week of year is such a week, which 
contains first Thursday of Gregorian year, and week containing January 4th.

Normal year, 365 days:
    Mo  Tu  We  Th  Fr  Sa  Su
                             1  no   1 + 51*7 + 7 yes, 52, 4.1. is Th
	                 1   2  no   2 + 51*7 + 6 yes, 52, 4.1. is We
                     1   2   3  no   3 + 51*7 + 5 yes, 52, 4.1. is Tu
                 1   2   3   4  yes  4 + 51*7 + 4 yes, 53, 4.1. is Mo
            1    2   3   4   5  yes  5 + 51*7 + 3 no,  52, 4.1. is Su
        1   2    3   4   5   6  yes  6 + 51*7 + 2 no,  52, 4.1. is Sa
    1   2   3    4   5   6   7  yes  7 + 51*7 + 1 no,  52, 4.1. is Fr

Leap year, 366 days:
    Mo  Tu  We  Th  Fr  Sa  Su
                             1  no   1 + 52*7 + 1 no,  52, 4.1. is Fr
	                 1   2  no   2 + 51*7 + 7 yes, 52, 4.1. is Th
                     1   2   3  no   3 + 51*7 + 6 yes, 52, 4.1. is We
                 1   2   3   4  yes  4 + 51*7 + 5 yes, 53, 4.1. is Tu
            1    2   3   4   5  yes  5 + 51*7 + 4 yes, 53, 4.1. is Mo
        1   2    3   4   5   6  yes  6 + 51*7 + 3 no,  52, 4.1. is Su
    1   2   3    4   5   6   7  yes  7 + 51*7 + 2 no,  52, 4.1. is Fr

Year 1582 has 355 days (it is not leap), 51 weeks.
*/

/* // already defined in calendar.c
// days in month
const s8 days_in_month[12] = {31,28,31,30,31,30,31,31,30,31,30,31}; // normal year
const s8 days_in_month_leap[12] = {31,29,31,30,31,30,31,31,30,31,30,31}; // leap year

// days in months from start of year (in normal year)
const s16 days_in_year[13] = {
		0,					// 1 (=0)
		31,					// 2 (=31)
		31+28,					// 3 (=59)
		31+28+31,				// 4 (=90)
		31+28+31+30,				// 5 (=120)
		31+28+31+30+31,				// 6 (=151)
		31+28+31+30+31+30,			// 7 (=181)
		31+28+31+30+31+30+31,			// 8 (=212)
		31+28+31+30+31+30+31+31,		// 9 (=243)
		31+28+31+30+31+30+31+31+30,		// 10 (=273)
		31+28+31+30+31+30+31+31+30+31,		// 11 (=304)
		31+28+31+30+31+30+31+31+30+31+30,	// 12 (=334)
		31+28+31+30+31+30+31+31+30+31+30+31 };	// (=365)

// day of week name - short
const LPCTSTR day_of_week_name[7] = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };

// day of week name - long
const LPCTSTR day_of_week_name2[7] = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" };
*/

// debug test date time structure
sDateTime64 DebTestDateTime;
sDateTime64 DebTestDateTime2;
s64 DebTestAbsTime;
s64 DebTestAbsTime2;

#if USE_DOUBLE		// use double support
// convert absolute time to Julian date
double AbsTimeToJulian(s64 time)
{
	return (double)(time*(double)ABSTODAYCOEF + (double)JULIANBASE);
}

// convert Julian date to absolute time
s64 JulianToAbsTime(double jul)
{
	return (s64)((jul - (double)JULIANBASE)*(double)DAYTOABSCOEF);
}
#endif // USE_DOUBLE

// convert absolute time to absolute day (MINDAY2..MAXDAY2)
s32 AbsTimeToDay(s64 time)
{
	return (s32)((u64)(time - MINTIME2)/DAY100NS + MINDAY2);
}

// convert absolute day to absolute time
s64 DayToAbsTime(s32 day)
{
	return (s64)((u64)(day - MINDAY2)*DAY100NS + MINTIME2);
}

// convert absolute time to filetime (Windows)
s64 AbsTimeToFileTime(s64 time)
{
	return time - FILETIMEOFF;
}

// convert filetime (Windows) to absolute time
s64 FileTimeToAbsTime(s64 time)
{
	return time + FILETIMEOFF;
}

// convert absolute time to Unix time and ms (if not NULL)
u32 AbsTimeToUnixTime(s64 time, s16* ms, s16* us)
{
	time -= UNIXBASEOFF;

	// convert to us
	if (us != NULL)
	{
		time /= 10;
		*us = (s16)(time % 1000);
		time /= 1000;
	}
	else
		time /= 10000;

	// limit range
	if (time < 0) time = 0;
	if (time > (s64)0xffffffff*1000+999) time = (s64)0xffffffff*1000+999;

	// split to ms and second
	u32 sec = (u32)(time / 1000);
	if (ms != NULL) *ms = (s16)(time - (s64)sec*1000);

	return sec;
}

// convert Unix time and ms to absolute time
s64 UnixTimeToAbsTime(u32 ut, s16 ms, s16 us)
{
	return ((s64)(u64)ut*1000 + ms)*10000 + us*10 + UNIXBASEOFF;
}

// check if long year is leap year
Bool YearIsLeap64(s16 year)
{
	// if not divisible by 4, it cannot be leap year
	if ((year & 3) != 0) return False;

	// if Julian calendar, it will be leap year
	if (year <= SPLITYEAR) return True;

	// split year to century and rest
	int c = year/100;
	int r = year - c*100;

	// if not century, it will be leap
	if (r != 0) return True;

	// century is leap only if it is divisible by 4
	if ((c & 3) == 0) return True;
	return False;
}

// get last day in month (28..31, use long year)
u8 GetLastDayMonth64(s8 mon, s16 year)
{
	if (YearIsLeap64(year))
		return DaysInMonthLeap[mon-1];
	else
		return DaysInMonth[mon-1];
}

// get days in long year (355, 365, 366)
s16 GetDaysInYear64(s16 year)
{
	if (year == SPLITYEAR) return 355; // year 1582
	return YearIsLeap64(year) ? 366 : 365;
}

// clear date and time structure (set to 0:0:0 1/1/1 saturday)
void DateTime64Clear(sDateTime64* dt)
{
	dt->ext = (1 << 8) + (1 << 16);
	dt->nsec = 0;
	dt->time = DAY_SAT;
	dt->date = 1 + (1 << 8);
}

// set date and time (day of week and flags are not updated)
void DateTime64Set(sDateTime64* dt, s16 year, s8 mon, s8 day, s8 hour, s8 min, s8 sec, s32 nsec)
{
	dt->nsec = nsec;
	dt->sec = sec;
	dt->min = min;
	dt->hour = hour;
	dt->day = day;
	dt->mon = mon;
	dt->year = year;
}

// copy date and time from another structure
void DateTime64Copy(sDateTime64* dst, const sDateTime64* src)
{
	dst->ext = src->ext;
	dst->nsec = src->nsec;
	dst->time = src->time;
	dst->date = src->date;
}

// compare date and time (day of week is ignored), returns -1 if dt1 < dt2, 0 if dt1 == dt2, 1 if dt1 > dt2
s8 DateTime64Comp(const sDateTime64* dt1, const sDateTime64* dt2)
{
	s32 d1, d2;

	d1 = dt1->date;
	d2 = dt2->date;
	if (d1 < d2) return -1;
	if (d1 > d2) return 1;

	d1 = dt1->time & 0xffffff00;
	d2 = dt2->time & 0xffffff00;
	if (d1 < d2) return -1;
	if (d1 > d2) return 1;

	d1 = dt1->nsec;
	d2 = dt2->nsec;
	if (d1 < d2) return -1;
	if (d1 > d2) return 1;

	return 0;
}

// validate date and time (not day of week; returns True = no corrections, entries were in valid ranges)
Bool DateTime64Valid(sDateTime64* dt)
{
	Bool ok = True;

	s32 kk = dt->nsec;
	if (kk < 0) { dt->nsec = 0; ok = False; }
	if (kk > 999999999) { dt->nsec = 999999999; ok = False; }

	s8 k = dt->sec;
	if (k < 0) { dt->sec = 0; ok = False; }
	if (k > 59) { dt->sec = 59; ok = False; }

	k = dt->min;
	if (k < 0) { dt->min = 0; ok = False; }
	if (k > 59) { dt->min = 59; ok = False; }

	k = dt->hour;
	if (k < 0) { dt->hour = 0; ok = False; }
	if (k > 23) { dt->hour = 23; ok = False; }

	k = dt->mon;
	if (k < 1) { dt->mon = 1; ok = False; }
	if (k > 12) { dt->mon = 12; ok = False; }

	s16 y = dt->year;
	if (y < MINYEAR2) { dt->year = MINYEAR2; ok = False; }
	if (y > MAXYEAR2) { dt->year = MAXYEAR2; ok = False; }

	s8 d = GetLastDayMonth64(k, y);
	k = dt->day;
	if (k < 1) { dt->day = 1; ok = False; }
	if (k > d) { dt->day = d; ok = False; }

	// invalid days 10/5/1582 .. 10/14/1582
	if ((y == SPLITYEAR) && (dt->mon == 10) && (k > 4) && (k < 15))
	{
		dt->day = 4;
		ok = False;
	}

	return ok;
}

// increase date structure by 1 day (extended entries are not updated, returns False on overflow)
Bool DateTime64Inc(sDateTime64* dt)
{
	// increase day in month
	s8 d = dt->day + 1;
	s8 m = dt->mon;
	s16 y = dt->year;

	// shift from Julian calendar to Gregorian calendar (10/5/1582 -> 10/15/1582)
	if ((y == 1582) && (m == 10) && (d == 5))
	{
		d = 15;
	}
	else if (d > 28) // only meaningful date
	{
		// increase month
		s8 dmax = GetLastDayMonth64(m, y); // max. day in month
		if (d > dmax)
		{
			d = 1;
			m++;

			// increase year
			if (m > 12)
			{
				m = 1;
				y++;

				// overflow year
				if (y > MAXYEAR2) return False;
				dt->year = y;
			}
			dt->mon = m;
		}

	}
	dt->day = d;

	// increase day of week
	s8 w = dt->dayofweek + 1;
	if (w > 6) w = 0;
	dt->dayofweek = w;

	return True;
}

// decrease date structure by 1 day (extended entries are not updated, returns False on underflow)
Bool DateTime64Dec(sDateTime64* dt)
{
	// decrease day in month
	s8 d = dt->day - 1;
	s8 m = dt->mon;
	s16 y = dt->year;

	// shift from Gregorian calendar to Julian calendar (10/14/1582 -> 10/4/1582)
	if ((y == 1582) && (m == 10) && (d == 14))
	{
		d = 4;
	}
	else if (d <= 0) // underflow
	{
		// decrease month
		m--;

		// decrease year
		if (m <= 0)
		{
			m = 12;
			y--;

			// underflow year
			if (y < MINYEAR2) return False;

			dt->year = y;
		}
		dt->mon = m;

		d = GetLastDayMonth64(m, y); // max. day in month
	}
	dt->day = d;

	// decrease day of week
	s8 w = dt->dayofweek - 1;
	if (w < 0) w = 6;
	dt->dayofweek = w;

	return True;
}

// pack date into absolute day (day of week is ignored), MINDAY2..MAXDAY2
//  Takes 1.3 us.
s32 DateTime64PackDay(sDateTime64* dt)
{
	// prepare month flag (0 if >= March, -1 if <= February)
	s8 m = dt->mon - 1;
	s8 a = (m >= 2) ? 0 : -1;

	// year must be always positive, add month correction
	s32 y = dt->year + a + 40000;

	// month (10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
	m = m + (12 & (u8)a) - 2;

	// recalc month to days (306, 337, 0, 31, 61, 92, 122, 153, 184, 214, 245, 275)
	s32 d = dt->day + (153*m + 2)/5 + y*365;

	// add leap year correction, add start offset of Julian calendar
	y = y/4; // number of leaps
	d = d + y - 14610307; // shift start of Julian calendar

	// add correction for Gregorian calendar
	if (d >= SPLITDATE)
	{
		y = y / 25; // century correction
		d = d - y + y/4 + 302; // add 400 years leap correction
	}

	return d;
}

// pack date and time into absolute time (day of week is ignored)
//  Takes 2.8 us.
s64 DateTime64PackAbsTime(sDateTime64* dt)
{
	return (((s64)(DateTime64PackDay(dt)*24 + dt->hour)*60 + dt->min)*60 + dt->sec)*10000000 + dt->nsec/100;
}

// unpack date from absolute day (updates day of week too, time will be zeroed)
//  Takes 7.5 us.
void DateTime64UnpackDay(sDateTime64* dt, s32 day)
{
	s64 t = DayToAbsTime(day);
	DateTime64UnpackAbsTime(dt, t);
}

// unpack date and time from Unix time (updates day of week too)
//  Takes 8 us.
void DateTime64UnpackUnixTime(sDateTime64* dt, u32 ut, s16 ms, s16 us)
{
	s64 t = UnixTimeToAbsTime(ut, ms, us);
	DateTime64UnpackAbsTime(dt, t);
}

// unpack date and time from absolute time (updates day of week too)
//  Takes 7 us.
void DateTime64UnpackAbsTime(sDateTime64* dt, s64 time)
{
	// clear flags
	dt->flags = 0;

// ---- time

	// convert time to positive offset since MINTIME2 (0..18446491583999999999)
	u64 t = (u64)(time - MINTIME2);

	// split time to minutes (0..30744152639) and 100-nsec (0..600000000)
	u64 min = t/(60*10000000);
	u32 nsec = (u32)(t - min*(60*10000000));

	// split 100-nsec to sec (0..59) and 100-nsec (0..10000000)
	int sec = (s8)(nsec/10000000);
	dt->sec = (s8)sec;
	nsec = nsec - sec*10000000;
	dt->nsec = (s32)(nsec*100);

	// split minutes to minutes (0..1439) and days (0..21350105)
	u32 d = (u32)(min/(24*60));
	int min2 = (int)(min - d*(24*60));

	// split minutes to minute (0..59) and hour (0..23)
	int hour = min2 / 60;
	dt->hour = (s8)hour;
	min2 = min2 - hour*60;
	dt->min = (s8)min2;

// ---- date

	// get day of week
	int week = (d + 4)/7;
	dt->dayofweek = (s8)(d - week*7 + 5);

	// prepare Julian calendar
	int b = 0; // century
	int c = d + 14610306 + MINDAY2; // relative day to 3/1/-40000

	// Gregorian calendar, since 10/15/1582
	if (c >= (SPLITDATE + 14610306))
	{
		dt->flags |= DTFLAG_GREG; // set Gregorian flag
		c = c + (14610004-14610306); // relative day for Gregorian
		b = (c*4 + 3)/146097; // century (146097=days per 400 years = ((4*365+1)*25-1)*4+1)
		c = c - (b*146097)/4; // day in this century
	}
	
	// year in this century (1461 = days per 4 years = 4*365+1)
	int y = (c*4 + 3)/1461;

	// year + 40000
	b = b*100 + y;

	// day in year (starting March)
	c = c - (1461*y)/4;

	// month-3 (starting March)
	int mon = (c*5 + 2)/153;

	// day in month
	int day = c - (153*mon + 2)/5 + 1;
	dt->day = (s8)day;

	// flag if month >= 10 (January of Frebruary)
	int e = (mon >= 10) ? 1 : 0;

	// year
	y = b - 40000 + e;
	dt->year = (s16)y;

	// month
	mon = mon + 3 + ((uint)(-12) & (uint)(-e));
	dt->mon = (s8)mon;

// ---- extended

	// set leap flag
	Bool leap = YearIsLeap64(y);
	if (leap) dt->flags |= DTFLAG_LEAP;
	
	// day of year (1..366)
	day = DaysInYear[mon - 1] + day;
	if ((mon > 2) && leap) day++; // leap Februar correction
	dt->dayofyear = day;

	// day of week of January 4th - 1
	day = dt->dayofweek - day + 2 + 53*7;
	day = day - (day / 7)*7;

	// number of weeks in this year
	int w = 52;
	if ((day == 7-1) || ((day == 6-1) && leap))
	{
		w = 53;
		dt->flags |= DTFLAG_W53;
	}

	// week (first week is week with January 4th, ISO-8601)
	week = (dt->dayofyear + day + 4)/7;

	// last week of previous year (only for January 1,2,3)
	if (week == 0)
	{
		dt->flags |= DTFLAG_LASTW;

		// last week of year 1582 (Saturday Januay 1 or Sunday January 2)
		if (y == 1583)
			week = 51;
		else
		{
			week = 52;
			if (day != 3-1) // January 4th is not Wednesday
			{
				// January 4th is Monday or previous year is leap
				if ((day == 1-1) || YearIsLeap64(y-1)) week = 53;
			}
		}
	}

	// first week of following year (1582 year is always OK)
	else if (week > w)
	{
		dt->flags |= DTFLAG_FIRSTW;
		week = 1;
	}
	dt->week = week;

	if (dt->dayofweek == 7) dt->dayofweek = 0;
}

// initialize debug test calendar - default set MINYEAR2 (returns False on error)
void DebTestCalendarInit(int year)
{
	DateTime64Clear(&DebTestDateTime);
	DebTestDateTime.year = MINYEAR2;
	DebTestDateTime.dayofweek = DAY_FRI;
	DebTestAbsTime = MINTIME2;

	DateTime64Clear(&DebTestDateTime2);
	DebTestDateTime2.year = MINYEAR2;
	DebTestDateTime2.dayofweek = DAY_FRI;
	DebTestAbsTime2 = MINTIME2;

	if (year != MINYEAR2)
	{
		DebTestDateTime.year = year;
		DebTestAbsTime = DateTime64PackAbsTime(&DebTestDateTime);
		DateTime64UnpackAbsTime(&DebTestDateTime, DebTestAbsTime);

		DateTime64Copy(&DebTestDateTime2, &DebTestDateTime);
		DebTestAbsTime2 = DebTestAbsTime;
	}
}

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
int DebTestCalendarStep()
{
	// unpack and pack
	DateTime64UnpackAbsTime(&DebTestDateTime2, DebTestAbsTime);
	DebTestAbsTime2 = DateTime64PackAbsTime(&DebTestDateTime);

	// check structure
	if (!DateTime64Valid(&DebTestDateTime)) return 2;

	// check structure 2
	if (!DateTime64Valid(&DebTestDateTime2)) return 3;

	// check packed day
	if (DateTime64PackDay(&DebTestDateTime) != AbsTimeToDay(DebTestAbsTime)) return 13;

	// check entries
	if (DebTestDateTime.nsec != DebTestDateTime2.nsec) return 4;
	if (DebTestDateTime.sec != DebTestDateTime2.sec) return 5;
	if (DebTestDateTime.min != DebTestDateTime2.min) return 6;
	if (DebTestDateTime.hour != DebTestDateTime2.hour) return 7;

	if (DebTestDateTime.day != DebTestDateTime2.day) return 8;
	if (DebTestDateTime.mon != DebTestDateTime2.mon) return 9;
	if (DebTestDateTime.year != DebTestDateTime2.year) return 10;
	if (DebTestDateTime.dayofweek != DebTestDateTime2.dayofweek) return 11;

	// check abs. time
	if (DebTestAbsTime != DebTestAbsTime2) return 12;

	// increase day in structure
	if (!DateTime64Inc(&DebTestDateTime)) return 1;

	// increase day in absolute time
	DebTestAbsTime += DAY100NS;
	return 0;
}

/*
// Calendar test loop
void DebTestCalendarLoop()
{
	int i, j;

	j = -1000000;
	DebTestCalendarInit(MINYEAR2);

	debug("Check long DateTime64:\n");

	while (True)
	{
		i = DebTestCalendarStep();

		if (j != DebTestDateTime2.year)
		{
			j = DebTestDateTime2.year;
			debug("DateTime64: year=%d days=%d", j, get_days_in_year64(j));
			if (datetime64_is_leap(&DebTestDateTime2)) debug(" leap"); else debug(" non-leap");;
			if (datetime64_is_greg(&DebTestDateTime2)) debug(" Greg"); else debug(" Juli");
			if (datetime64_is_w53(&DebTestDateTime2)) debug(" 53_weeks"); else debug(" 52_weeks");
			debug("\n");
		}

		if (i != 0)
		{
			if (i == 1)
			{
				debug("... OK\n");
				break;
			}
			debug("... ERROR %d: year=%d, month=%d, day=%d, dayofweek=%d\n",
				i, DebTestDateTime2.year, DebTestDateTime2.mon, DebTestDateTime2.day, DebTestDateTime2.dayofweek);
			debug_wait();
			hard_fault(HARDFAULT_INIT);
			while(True) {}
		}
	}
}
*/


/* Test loop from main.c

	int i, j;

	int year = -1000000;
	DebTestCalendarInit(MINYEAR2);

	while (True)
	{
		DispCol(COL_FILEBG, COL_FILEFG); // invert color
		DispY = TEXTH-15;
		DispX = 1;

		i = DebTestCalendarStep();

		if (year != DebTestDateTime2.year)
		{
			year = DebTestDateTime2.year;
			DispText("year=");
			DecNum(TempBuf, year, 0);
			DispText(TempBuf);

			DispText(" day=");
			DecNum(TempBuf, GetDaysInYear64(year), 0);
			DispText(TempBuf);

			if (DateTime64IsLeap(&DebTestDateTime2)) DispText(" leap"); else DispText(" nlea");;
			if (DateTime64IsGreg(&DebTestDateTime2)) DispText(" Greg"); else DispText(" Juli");
			if (DateTime64IsW53(&DebTestDateTime2)) DispText(" 53w"); else DispText(" 52w");
		}

		if (i != 0)
		{
			if (i == 1)
			{
				DispText("... OK  ");
				while(True){};
			}

			DispText("ERROR ");
			DecNum(TempBuf, i, 0);
			DispText(TempBuf);

			DispText("year=");
			DecNum(TempBuf, DebTestDateTime2.year, 0);
			DispText(TempBuf);

			DispText("month=");
			DecNum(TempBuf, DebTestDateTime2.mon, 0);
			DispText(TempBuf);

			DispText("day=");
			DecNum(TempBuf, DebTestDateTime2.day, 0);
			DispText(TempBuf);

			DispText("dow=");
			DecNum(TempBuf, DebTestDateTime2.dayofweek, 0);
			DispText(TempBuf);

			while(True) {}
		}
	}

*/

/*
// datetime64 fast check (returns year on error or 0 if OK)
s16 DateTime64FastCheck(int loops)
{
	s64 t;
	sDateTime64 dt;
	sDateTime64 dt2;

	for (; loops > 0; loops--)
	{
		// generate random date and time
		dt.nsec = rand_s32_max(&rand_main, 999999999) / 100 * 100;
		dt.sec = rand_s8_max(&rand_main, 59);
		dt.min = rand_s8_max(&rand_main, 59);
		dt.hour = rand_s8_max(&rand_main, 23);
		dt.day = rand_s8_minmax(&rand_main, 1, 31);
		dt.mon = rand_s8_minmax(&rand_main, 1, 12);
		dt.year = rand_s16_minmax(&rand_main, MINYEAR2, MAXYEAR2);

		// validate
		DateTime64Valid(&dt);

		// pack
		t = DateTime64PackAbsTime(&dt);

		// unpack
		DateTime64UnpackAbsTime(&dt2, t);

		// compare
		if (	(dt2.nsec != dt.nsec) ||
			(dt2.sec != dt.sec) ||
			(dt2.min != dt.min) ||
			(dt2.hour != dt.hour) ||
			(dt2.day != dt.day) ||
			(dt2.mon != dt.mon) ||
			(dt2.year != dt.year))
		{
			if (dt.year == 0) return 1;
			return dt.year;
		}
	}
	return 0;
}
*/

#endif // USE_CALENDAR64	// use 32-bit calendar (lib_calendar.c, lib_calendar.h)

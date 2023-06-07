
// ****************************************************************************
//
//                       Calendar 32-bit (year range 1970..2099)
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_CALENDAR	// use 32-bit calendar (lib_calendar.c, lib_calendar.h)

#include "../inc/lib_calendar.h"

// days in month
const s8 DaysInMonth[12]  = {31,28,31,30,31,30,31,31,30,31,30,31}; // normal year
const s8 DaysInMonthLeap[12] = {31,29,31,30,31,30,31,31,30,31,30,31}; // leap year

// days in months from start of year (in normal year)
const s16 DaysInYear[13] = {
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
const char* DayOfWeekName[7] = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };

// day of week name - long
const char* DayOfWeekName2[7] = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" };

// check if year is leap using Greagorian calendar (=February has 29 days instead of 28)
Bool YearIsLeap(s16 year)
{
	return ((year & 3) == 0) && (((year % 100) != 0) || ((year % 400) == 0));
}

// clear date and time structure (set to 0:0:0 1/1/1970 thursday)
void DateTimeClear(sDateTime* dt)
{
	dt->timelow = 0;
	dt->time = DAY_THU;
	dt->date = (((1970 << 8) + 1) << 8) + 1;
}

// set date and time (day of week is cleared)
void DateTimeSet(sDateTime* dt, s16 year, s8 mon, s8 day, s8 hour, s8 min, s8 sec, s16 ms, s16 us)
{
	dt->us = us;
	dt->ms = ms;
	dt->dayofweek = 0;
	dt->sec = sec;
	dt->min = min;
	dt->hour = hour;
	dt->day = day;
	dt->mon = mon;
	dt->year = year;
}

// copy date and time from another structure
void DateTimeCopy(sDateTime* dst, const sDateTime* src)
{
	dst->timelow = src->timelow;
	dst->time = src->time;
	dst->date = src->date;
}

// compare date and time (day of week is ignored), returns -1 if dt1 < dt2, 0 if dt1 == dt2, 1 if dt1 > dt2
s8 DateTimeComp(const sDateTime* dt1, const sDateTime* dt2)
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

	d1 = dt1->timelow;
	d2 = dt2->timelow;
	if (d1 < d2) return -1;
	if (d1 > d2) return 1;

	return 0;
}

// validate date and time (not day of week; returns True = no corrections, entries were in valid ranges)
Bool DateTimeValid(sDateTime* dt)
{
	Bool ok = True;

	s16 k = dt->us;
	if (k < 0) { dt->us = 0; ok = False; }
	if (k > 999) { dt->us = 999; ok = False; }

	k = dt->ms;
	if (k < 0) { dt->ms = 0; ok = False; }
	if (k > 999) { dt->ms = 999; ok = False; }

	k = dt->sec;
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

	k = dt->year;
	if (k < MINYEAR) { dt->year = MINYEAR; ok = False; }
	if (k > MAXYEAR) { dt->year = MAXYEAR; ok = False; }

	s8 d = YearIsLeap(k) ? DaysInMonthLeap[dt->mon - 1] : DaysInMonth[dt->mon - 1];
	k = dt->day;
	if (k < 1) { dt->day = 1; ok = False; }
	if (k > d) { dt->day = d; ok = False; }

	return ok;
}

// increase date by 1 day (returns False on date overflow)
Bool DateTimeInc(sDateTime* dt)
{
	// increase day in month
	int d = dt->day + 1;
	int k = YearIsLeap(dt->year) ? DaysInMonthLeap[dt->mon - 1] : DaysInMonth[dt->mon - 1];
	if (d > k)
	{
		// increase month
		d = 1;
		int m = dt->mon + 1;
		if (m > 12)
		{
			// increase year
			m = 1;
			int y = dt->year + 1;
			if (y > MAXYEAR) return False;
			dt->year = y;
		}
		dt->mon = m;
	}
	dt->day = d;

	// increase day of week
	int w = dt->dayofweek + 1;
	if (w > 6) w = 0;
	dt->dayofweek = w;

	return True;
}	

// decrease date by 1 day (returns False on date underflow)
Bool DateTimeDec(sDateTime* dt)
{
	// decrease day in month
	int d = dt->day - 1;
	if (d < 1)
	{
		// decrease month
		int m = dt->mon - 1;
		if (m < 1)
		{
			// decrease year
			int y = dt->year - 1;
			if (y < MINYEAR) return False;
			dt->year = y;
			m = 12;
		}
		dt->mon = m;
		d = YearIsLeap(dt->year) ? DaysInMonthLeap[m - 1] : DaysInMonth[m - 1];
	}
	dt->day = d;

	// decrease day of week
	int w = dt->dayofweek - 1;
	if (w < 0) w = 6;
	dt->dayofweek = w;

	return True;
}

// pack date and time into Unix time, optionally with ms and us if not NULL (day of week is ignored)
//  Takes 1 us
u32 DateTimePack(const sDateTime* dt, s16* ms, s16* us)
{
	// ms
	if (ms != NULL) *ms = dt->ms;

	// us
	if (us != NULL) *us = dt->us;

	// pack time
	int t = dt->sec + dt->min*60 + dt->hour*60*60;

	// pack date
	int y = dt->year - 1970;
	u16 d = (u16)(y*365 + (y+1)/4 + DaysInYear[dt->mon - 1] + dt->day - 1);
	if ((dt->mon > 2) && (((y+2) & 3) == 0)) d++; // leap Februar correction

	// compose date and time
	return ((u32)(d * (u16)(24*60*60/2)) << 1) + t;
}

// unpack date and time from Unix time (updates day of week too)
//  Takes 2.3 us
void DateTimeUnpack(sDateTime* dt, u32 ut, s16 ms, s16 us)
{
	// set ms and us
	dt->us = us;
	dt->ms = ms;

	// split Unix time to day and time
	u16 d = (u16)((ut >> 1) / (u16)(24*60*60/2));
	int t = ut - ((u32)(d * (u16)(24*60*60/2)) << 1);

	// day of week
	dt->dayofweek = (d + 4) % 7;

	// unpack time
	int h = t / (60*60);
	dt->hour = (s8)h;
	t -= h * (60*60);
	int m = t / 60;
	dt->min = (s8)m;
	dt->sec = (s8)(t - m*60);

	// year
	int y = (((s32)(d + 365+366) << 2)/(s16)(365*3 + 366) - 2);
	d = (u16)(d - y*365 - (y+1)/4); // subtract days in this year
	y += 1970;
	dt->year = (s16)y;

	// leap correction after 29th February
	if ((y & 3) == 0)
	{
		if (d == 31+28)
		{
			dt->day = 29;
			dt->mon = 2;
			return;
		}
		if (d > 31+28) d--;
	}

	// split days to day and month
	m = d/31 + 1;
	if (d >= DaysInYear[m]) m++;
	dt->mon = (s8)m;	
	dt->day = (s8)(d - DaysInYear[m - 1] + 1);
}

// datetime check (returns year of error or 0 if OK)
//  Takes 0.5 second to check.
s16 DateTimeCheck()
{
	// prepare structures
	u32 ut = 0; // Unix date 1/1/1970 0:0:0
	sDateTime dt;
	DateTimeClear(&dt); // set to 1/1/1970 0:0:0
	sDateTime dt2;
	u8 w = DAY_THU; // day of week

	for (;;)
	{
		// pack date and time into Unix format
		u32 d = DateTimePack(&dt, NULL, NULL);
		if (d != ut) return dt.year;

		// unpack date and time from Unix format
		DateTimeUnpack(&dt2, d, 0, 0);
		if (	(w != dt2.dayofweek) ||
			(dt2.sec != dt.sec) ||
			(dt2.min != dt.min) ||
			(dt2.hour != dt.hour) ||
			(dt2.day != dt.day) ||
			(dt2.mon != dt.mon) ||
			(dt2.year != dt.year))
			return dt.year;

		// time is 00:00:00, shift to time 00:00:01
		if ((dt.hour == 0) && (dt.min == 0) && (dt.sec == 0))
		{
			// increase Unix time by 1 second
			ut++;

			// set DateTime to 00:00:01
			dt.sec = 1;
		}

		// time is 00:00:01, shift to time 23:59:59
		else if ((dt.hour == 0) && (dt.min == 0) && (dt.sec == 1))
		{
			// increase Unix time by 23:59:58
			ut += (23*60 + 59)*60 + 58;

			// set DateTime to 23:59:59
			dt.hour = 23;
			dt.min = 59;
			dt.sec = 59;
		}

		// time is 23:59:59, shift to next day
		else
		{
			// increase Unix time by 1 second
			ut++;

			// reset time to 00:00:00
			dt.hour = 0;
			dt.min = 0;
			dt.sec = 0;

			// increase day of week
			w++;
			if (w > 6) w = 0;

			// increase DateTime (quit if maximum year overflows)
			if (!DateTimeInc(&dt)) return 0;
		}
	}
}

#endif // USE_CALENDAR	// use 32-bit calendar (lib_calendar.c, lib_calendar.h)

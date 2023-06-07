
// ****************************************************************************
//
//                               Text strings
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_TEXT	// use Text strings, except StrLen and StrComp (lib_text.c, lib_text.h)

#include "../../_sdk/inc/sdk_bootrom.h"
#include "../inc/lib_text.h"
#include "../inc/lib_calendar.h"
#include "../inc/lib_print.h"

// empty text string data
sTextData EmptyTextData = { BIGINT, 0, 0 };

// empty text
pText EmptyText = &EmptyTextData;

// day of week text, 2 characters
const char* DayOfWeekText[7] = {
	// Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
	"Su", "Mo", "Tu", "We", "Th", "Fr", "Sa" };

// month text, 3 characters
const char* MonthText[12] = {
	// January, February, March, April, May, June, July, August, September, October, November, December
	"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };

// pre-set date formats
const char* DateForm[11] = {
	// USA format
	"M/D/y",	// 0 (01/25/22)
	"m/d/Y",	// 1 (1/25/2022)
	"M/D/Y",	// 2 (01/25/2022)
	"N d,Y",	// 3 (Jan 25,2022)
	// European format
	"D.M.y",	// 4 (25.01.22)
	"d.m.Y",	// 5 (25.1.2022)
	"D.M.Y",	// 6 (25.01.2022)
	"d. N Y",	// 7 (25. Jan 2022)
	// ISO format
	"y-M-D",	// 8 (22-01-25)
	"Y-M-D",	// 9 (2022-01-25)
	// Technical format
	"yMD",		// 10 (220125)
};

// ============================================================================
//                     Internal functions - do not use them
// ============================================================================

// create new text data (on memory error returns NULL)
sTextData* TextDataNew(s32 len)
{
	sTextData* data = (sTextData*)MemAlloc((len+1) + SIZEOFTEXTDATA);
	if (data == NULL) return NULL;
	data->ref = 1;
	data->len = len;
	data->data[len] = 0;
	return data;
}

// resize text data (ref must be = 1, returns new pointer or NULL on error)
sTextData* TextDataResize(sTextData* data, s32 len)
{
	sTextData* data2 = (sTextData*)MemResize(data, (len+1) + SIZEOFTEXTDATA);
	if (data2 == NULL) return NULL;
	data2->len = len;
	data2->data[len] = 0;
	return data2;
}

// attach text data to text object (object must not be attached)
void TextAttach(pText* text, sTextData* data)
{
	*text = data;
	SafeInc(&data->ref);
}

// detach (and destroy if needed) text data from text object (= uninitialize text object)
void TextDetach(pText* text)
{
	sTextData* data = *text;
	if (SafeDec(&data->ref) == 0) MemFree(data);
}

// appropriate text string data before write (returns False on memory error)
Bool TextCopyWrite(pText* text)
{
	sTextData* data2;
	sTextData* data = *text; // text data
	s32 len;
	if (data->ref > 1) // if more owners, needs to create its own copy of data
	{
		len = data->len; // length of the text
		data2 = TextDataNew(len); // create new buffer
		if (data2 == NULL) return False; // memory error, cannot create copy of the text
		*text = data2; // use new buffer as new text data
	// At this point we can't disconnect the old text yet.
	// Someone else could do it in the meantime and we would lose the data.
		memcpy(data2->data, data->data, len); // copy data into new buffer
	// delete old data - someone else could have disconnected old text in the meantime.
		if (SafeDec(&data->ref) == 0) MemFree(data);
	}
	return True;
}

// ============================================================================
//                        Base control functions
// ============================================================================

// initialize text object - attach empty text (object must not be attached)
// - to terminate, use TextTerm
void TextInit(pText* text)
{
	TextAttach(text, &EmptyTextData);
}

// set new length of the text (appropriates text, returns False on memory error)
Bool TextSetLen(pText* text, s32 len)
{
	if (len == (*text)->len) return True; // text length is already OK
	if (!TextCopyWrite(text)) return False; // appropriate text string
	sTextData* data = TextDataResize(*text, len); // resize text buffer
	if (data == NULL) return False; // memory error
	*text = data; // use new address of the string (ref stays = 1)
	return True;
}

// empty (clear) text string
void TextEmpty(pText* text)
{
	TextSet(text, &EmptyText);
}

// write text into buffer (without terminating zero), returns text length
int TextWrite(const pText* text, char* buf, int maxlen)
{
	int len = (*text)->len;
	if (len > maxlen) len = maxlen;
	if (len < 0) len = 0;
	memcpy(buf, (*text)->data, len);
	return len;
}

// write text into buffer with terminating zero (maxlen is max. length
//   without terminating zero), returns text length
int TextWriteZ(const pText* text, char* buf, int maxlen)
{
	int len = TextWrite(text, buf, maxlen);
	buf[len] = 0;
	return len;
}

// NUL correction (check and truncate text if contains NUL character)
void TextCheckNul(pText* text)
{
	int len = StrLen((*text)->data);
	if (len < (*text)->len) TextSetLen(text, len);
}

// ============================================================================
//                          Character of text string
// ============================================================================

// get character at given position (returns 0 if index is invalid)
char TextAt(const pText* text, s32 inx)
{
	if (TextIsValid(text, inx))
		return (*text)->data[inx];
	else
		return 0;
}

// get first character of text string (returns 0 if text string is empty)
char TextFirst(const pText* text)
{
	return TextAt(text, 0);
}

// get last character of text string (returns 0 if text string is empty)
char TextLast(const pText* text)
{
	return TextAt(text, (*text)->len-1);
}

// set character at given position (checks valid position, returns False on memory error)
Bool TextSetAt(pText* text, s32 inx, char ch)
{
	if (TextIsValid(text, inx)) // if position is valid
	{
		if (!TextCopyWrite(text)) return False; // appropriate text string data
		(*text)->data[inx] = ch;
	}
	return True;
}

// set first character of text string (checks valid position, returns False on memory error)
Bool TextSetFirst(pText* text, char ch)
{
	return TextSetAt(text, 0, ch);
}

// set last character of text string (checks valid position, returns False on memory error)
Bool TextSetLast(pText* text, char ch)
{
	return TextSetAt(text, (*text)->len-1, ch);
}

// ============================================================================
//                               Set text
// ============================================================================

// set text to single-CHAR string (returns False on memory error)
Bool TextSetChar(pText* text, char ch)
{
	TextDetach(text); // detach old text
	sTextData* data = TextDataNew(1); // create new text buffer with length = 1
	if (data == NULL)
	{
		// on memory error, attach empty text
		TextAttach(text, &EmptyTextData);
		return False;
	}
	else
	{
		// set new text
		*text = data;
		data->data[0] = ch;
		return True;
	}
}

// set text from ASCII text with length (returns False on memory error)
Bool TextSetStrLen(pText* text, const char* str, s32 len)
{
	TextDetach(text); // detach old text
	sTextData* data = TextDataNew(len); // create new text buffer
	if (data == NULL)
	{
		// on memory error, attach empty text
		TextAttach(text, &EmptyTextData);
		return False;
	}
	else
	{
		// set new text
		*text = data;
		memcpy(data->data, str, len);
		return True;
	}
}

// set text from ASCIIZ text (returns False on memory error)
Bool TextSetStr(pText* text, const char* str)
{
	int len = StrLen(str); // get length of the text
	return TextSetStrLen(text, str, len);
}

// set text from another text object
void TextSet(pText* dst, const pText* src)
{
	sTextData* d = *dst;
	sTextData* s = *src;
	if (d != s)
	{
		TextDetach(dst);
		TextAttach(dst, s);
	}
}

// exchange text objects
void TextExc(pText* text1, pText* text2)
{
	sTextData* t = *text1;
	*text1 = *text2;
	*text2 = t;
}

// ============================================================================
//                               Add text
// ============================================================================

// add repeated text (returns False on memory error)
Bool TextAddRep(pText* text, const pText* src, int rep)
{
	if (rep <= 0) return True; // invalid number of repeats
	int len1 = (*text)->len; // length of destination text
	int len2 = (*src)->len; // length of source text
	if (!TextSetLen(text, len1 + len2*rep)) return False; // set length of destination buffer (and appropriate it)
	char* d = &(*text)->data[len1]; // destination pointer
	for (; rep > 0; rep--)
	{
		memcpy(d, (*src)->data, len2); // copy one source string
		d += len2; // shift destination pointer
	}
	return True;
}

// add repeated ASCII text string with length (returns False on memory error)
Bool TextAddRepStrLen(pText* text, const char* str, int rep, s32 len)
{
	if ((rep <= 0) || (str == NULL)) return True; // invalid number of repeats or invalid source text
	int len1 = (*text)->len; // length of destination text
	if (!TextSetLen(text, len1 + len*rep)) return False; // set length of destination buffer (and appropriate it)
	char* d = &(*text)->data[len1]; // destination pointer
	for (; rep > 0; rep--)
	{
		memcpy(d, str, len); // copy one source string
		d += len; // shift destination pointer
	}
	return True;
}

// add repeated ASCIIZ text string (returns False on memory error)
Bool TextAddRepStr(pText* text, const char* str, int rep)
{
	return TextAddRepStrLen(text, str, rep, StrLen(str));
}

// add repeated character (returns False on memory error)
Bool TextAddRepCh(pText* text, char ch, int rep)
{
	if (rep <= 0) return True; // invalid number of repeats
	int len = (*text)->len; // length of destination text
	if (!TextSetLen(text, len + rep)) return False; // set length of destination buffer (and appropriate it)
	char* d = &(*text)->data[len]; // destination pointer
	for (; rep > 0; rep--) *d++ = ch; // write character
	return True;
}

// add repeated space character (returns False on memory error)
Bool TextAddRepSpc(pText* text, int rep)
{
	return TextAddRepCh(text, ' ', rep);
}

// ============================================================================
//                           Date and time
// ============================================================================

#define SET2DIG(n) { int k1=(n); int k2=k1/10; k1-=k2*10; *d++=(char)(k2+'0'); *d++=(char)(k1+'0'); }

// set/add time in Unix format (number of seconds and milliseconds, returns False on memory error)
//   ut: time in Unix format
//   ms: number of milliseconds
//   hour: hour format 0=1:23, 1= 1:23, 2=01:23, 3=1.23p
//   sec: second format 0=1:23, 1=1:23:45, 2=1:23:45.678
//   sep: separator 0=none, 1=":" and ".", 2=":" and ",", 3="." and ","
Bool TextSetAddTime(pText* text, u32 ut, s16 ms, s8 hour, s8 sec, s8 sep, Bool add)
{
	sTextData* data;

	// split Unix format to date and time
	u16 day = (u16)((ut >> 1) / (u16)(24*60*60/2));
	int t = ut - ((u32)(day * (u16)(24*60*60/2)) << 1);

	// unpack time h:m:s
	int h = t / (60*60);
	t -= h * (60*60);
	int m = t / 60;
	int s = t - m*60;

	// prepare length of result
	int len0 = 4; // 0123
	if ((hour == 0) && (h < 10)) len0--; // no leading space
	char ampm = 0; // no am/pm
	if (hour == 3) // am/pm format
	{
		ampm = 'a'; // am
		len0++; // add "a" or "b"
		if (h >= 12) // afternoon?
		{
			h -= 12; // 12-hour format
			ampm = 'p'; // pm
		}
		if (h == 0) h = 12; // change 0:23 -> 12:23
		if (h < 10) len0--; // is hour 1 digit?
	}
	if (sec > 0) len0 += 2; // add seconds
	if (sec > 1) len0 += 3; // add milliseconds
	if (sep) len0 += sec + 1; // add separators

	// prepare destination buffer
	int len;
	if (add)
	{
		// add number
		len = (*text)->len; // destination offset
		if (!TextSetLen(text, len + len0)) return False; // set new length of the text
	}
	else
	{
		// set number
		len = 0; // destination offset = 0
		TextDetach(text); // detach old text
		data = TextDataNew(len0); // create new text
		if (data == NULL)
		{
			// on memory error, attach empty text
			TextAttach(text, &EmptyTextData);
			return False;
		}
		*text = data;
	}
	char* d = &(*text)->data[len];

	// prepare separators
	char sep1;
	char sep2;
	switch (sep)
	{
	case 1: sep1 = ':'; sep2 = '.'; break;
	case 2: sep1 = ':'; sep2 = ','; break;
	case 3: sep1 = '.'; sep2 = ','; break;
	default: sep1 = 0; sep2 = 0; break;
	}
	
	// decode hour: 0=1:23, 1= 1:23, 2=01:23, 3=1.23p (case "3" should use separator '.')
	int k = h/10;
	h -= k*10;
	switch (hour)
	{
	case 1: // _1:23
		*d++ = (k == 0) ? ' ' : (char)(k + '0');
		break;

	case 2: // 01:23
		*d++ = (char)(k + '0');
		break;

	default: // 1:23, 1:23p
		if (k > 0) *d++ = (char)(k + '0');
	}
	*d++ = (char)(h + '0');

	// decode minute
	if (sep1 != 0) *d++ = sep1;
	SET2DIG(m);

	// decode second: 0=1:23, 1=1:23:45, 2=1:23:45.678
	if (sec > 0)
	{
		if (sep1 != 0) *d++ = sep1;
		SET2DIG(s);

		// decode milliseconds
		if (sec > 1)
		{
			if (sep2 != 0) *d++ = sep2;
			SET2DIG(ms/10);
			*d++ = (char)((ms%10) + '0');
		}
	}

	// am/pm
	if (ampm != 0) *d++ = ampm;
	return True;
}

// set/add day of week 2-character text from Unix time
Bool TextSetAddDow(pText* text, u32 ut, Bool add)
{
	sTextData* data;

	// increase buffer
	int len;
	if (add)
	{
		// add text
		len = (*text)->len; // destination offset
		if (!TextSetLen(text, len + 2)) return False; // set new length of the text
	}
	else
	{
		// set text
		len = 0; // destination offset = 0
		TextDetach(text); // detach old text
		data = TextDataNew(2); // create new text
		if (data == NULL)
		{
			// on memory error, attach empty text
			TextAttach(text, &EmptyTextData);
			return False;
		}
		*text = data; // set new text
	}

	// prepare day of week
	sDateTime dt;
	DateTimeUnpack(&dt, ut, 0, 0);

	// decode day of week characters
	s8 dow = dt.dayofweek;
	const char* t = DayOfWeekText[dow];
	(*text)->data[len] = *t++;
	(*text)->data[len+1] = *t;

	return True;
}

// set/add date in custom format (returns False on memory error)
//   form: formating string
//    d ... day 1 or 2 digits
//    D ... day 2 digits
//    m ... month 1 or 2 digits
//    M ... month 2 digits
//    N ... month name 3 letters
//    y ... year 2 digits
//    Y ... year 4 digits
Bool TextSetAddDateCustom(pText* text, s16 year, s8 mon, s8 day, const char* form, Bool add)
{
	sTextData* data;

	// prepare length
	int len0 = 0;
	const char* f = form;
	char ch;
	while ((ch = *f++) != 0)
	{
		switch (ch)
		{
		case 'd': len0 += (day < 10) ? 1 : 2; break; // day 1 or 2 digits
		case 'm': len0 += (mon < 10) ? 1 : 2; break; // month 1 or 2 digits
		case 'y': // year 2 digits
		case 'M': // month 2 digits
		case 'D': len0 += 2; break; // day 2 digits
		case 'N': len0 += 3; break; // month name 3 characters
		case 'Y': len0 += 4; break; // year 4 digits
		default: len0++; // other characters
		}
	}

	// increase buffer
	int len;
	if (add)
	{
		// add text
		len = (*text)->len; // destination offset
		if (!TextSetLen(text, len + len0)) return False; // set new length of the text
	}
	else
	{
		// set text
		len = 0; // destination offset = 0
		TextDetach(text); // detach old text
		data = TextDataNew(len0); // create new text
		if (data == NULL)
		{
			// on memory error, attach empty text
			TextAttach(text, &EmptyTextData);
			return False;
		}
		*text = data; // set new text
	}

	// pointer into buffer
	char* d = &(*text)->data[len];

	// decode date
	int k, m;
	f = form;
	const char* t;
	while ((ch = *f++) != 0)
	{
		switch (ch)
		{
		case 'd': // day 1 or 2 digits
			k = day / 10;
			m = day - k*10;
			if (k > 0) *d++ = (char)(k + '0');
			*d++ = (char)(m + '0');
			break;

		case 'm': // month 1 or 2 digits
			k = mon / 10;
			m = mon - k*10;
			if (k > 0) *d++ = (char)(k + '0');
			*d++ = (char)(m + '0');
			break;

		case 'Y': // year 4 digits
			SET2DIG(year/100);

	// --- continue low 2 digits

		case 'y': // year 2 digits
			SET2DIG(year%100);
			break;

		case 'D': // day 2 digits
			SET2DIG(day);
			break;

		case 'M': // month 2 digits
			SET2DIG(mon);
			break;

		case 'N': // month name 3 characters
			t = MonthText[mon - 1];
			*d++ = *t++;
			*d++ = *t++;
			*d++ = *t++;
			break;

		default: // other characters
			*d++ = ch;
		}
	}

	return True;
}

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
Bool TextSetDate(pText* text, s16 year, s8 mon, s8 day, u8 form)
{
	return TextSetDateCustom(text, year, mon, day, DateForm[form]);
}

// add date in pre-select format (returns False on memory error)
Bool TextAddDate(pText* text, s16 year, s8 mon, s8 day, u8 form)
{
	return TextAddDateCustom(text, year, mon, day, DateForm[form]);
}

// set date in Unix (returns False on memory error)
Bool TextSetDateUnix(pText* text, u32 ut, u8 form)
{
	sDateTime dt;
	DateTimeUnpack(&dt, ut, 0, 0);
	return TextSetDateCustom(text, dt.year, dt.mon, dt.day, DateForm[form]);
}

// add date in Unix (returns False on memory error)
Bool TextAddDateUnix(pText* text, u32 ut, u8 form)
{
	sDateTime dt;
	DateTimeUnpack(&dt, ut, 0, 0);
	return TextAddDateCustom(text, dt.year, dt.mon, dt.day, DateForm[form]);
}

// set/add Unix date and time in technical format yyyymmddhhmmssmmm (17 digits, returns False on memory error)
Bool TextSetAddDateTech(pText* text, u32 ut, u16 ms, Bool add)
{
	sTextData* data;

	// unpack date and time
	sDateTime dt;
	DateTimeUnpack(&dt, ut, ms, 0);

	// increase buffer
	int len;
	if (add)
	{
		// add text
		len = (*text)->len; // destination offset
		if (!TextSetLen(text, len + 17)) return False; // set new length of the text
	}
	else
	{
		// set text
		len = 0; // destination offset = 0
		TextDetach(text); // detach old text
		data = TextDataNew(17); // create new text
		if (data == NULL)
		{
			// on memory error, attach empty text
			TextAttach(text, &EmptyTextData);
			return False;
		}
		*text = data; // set new text
	}

	// destination pointer
	char* d = &(*text)->data[len];

	// decode
	SET2DIG(dt.year/100); // year high 2 digits
	SET2DIG(dt.year%100); // year low 2 digits
	SET2DIG(dt.mon); // month
	SET2DIG(dt.day); // day
	SET2DIG(dt.hour); // hour
	SET2DIG(dt.min); // minute
	SET2DIG(dt.sec); // second
	int m = dt.ms;
	SET2DIG(m/10); // millisecond high
	*d++=(char)((m%10)+'0'); // millisecond low

	return True;
}

// ============================================================================
//                          Find and replace
// ============================================================================

// find character from starting position (returns position or -1=not found)
int TextFindChar(const pText* text, char ch, int pos)
{
	if (pos < 0) pos = 0; // limit minimal starting position
	int i = (*text)->len - pos; // number of remaining characters
	const char* data = &(*text)->data[pos]; // pointer to start of text
	for (; i > 0; i--)
	{
		if (*data == ch) return (int)(data - (*text)->data);
		data++;
	}
	return -1;
}

// find character reversed from starting position (returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindCharRev(const pText* text, char ch, int pos)
{
	if (pos >= (*text)->len) pos = (*text)->len-1; // limit maximal starting position
	const char* data = &(*text)->data[pos]; // pointer to end of text
	for (; pos >= 0; pos--)
	{
		if (*data == ch) return pos;
		data--;
	}
	return -1;
}

// find white space character from starting position (space/tab/newline 1..32, returns position or -1=not found)
int TextFindSpace(const pText* text, int pos)
{
	if (pos < 0) pos = 0; // limit minimal starting position
	int i = (*text)->len - pos; // number of remaining characters
	const char* data = &(*text)->data[pos]; // pointer to start of text
	for (; i > 0; i--)
	{
		if ((u8)*data <= (u8)32) return (int)(data - (*text)->data);
		data++;
	}
	return -1;
}

// find white space character reverse from starting position (space/tab/newline 1..32, returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindSpaceRev(const pText* text, int pos)
{
	if (pos >= (*text)->len) pos = (*text)->len-1; // limit maximal starting position
	const char* data = &(*text)->data[pos]; // pointer to end of text
	for (; pos > 0; pos--)
	{
		if ((u8)*data <= (u8)32) return pos;
		data--;
	}
	return -1;
}

// find non white space character from starting position (no space/tab/newline > 32, returns position or -1=not found)
int TextFindNoSpace(const pText* text, int pos)
{
	if (pos < 0) pos = 0; // limit minimal starting position
	int i = (*text)->len - pos; // number of remaining characters
	const char* data = &(*text)->data[pos]; // pointer to start of text
	for (; i > 0; i--)
	{
		if ((u8)*data > (u8)32) return (int)(data - (*text)->data);
		data++;
	}
	return -1;
}

// find non white space character reverse from starting position (no space/tab/newline > 32, returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindNoSpaceRev(const pText* text, int pos)
{
	if (pos >= (*text)->len) pos = (*text)->len-1; // limit maximal starting position
	const char* data = &(*text)->data[pos]; // pointer to end of text
	for (; pos > 0; pos--)
	{
		if ((u8)*data > (u8)32) return pos;
		data--;
	}
	return -1;
}

// find text from starting position (returns position or -1=not found)
int TextFind(const pText* text, const pText* fnd, int pos)
{
	// limit start position
	if (pos < 0) pos = 0; // check minimal position
	s32 i = (*text)->len;
	if (pos > i) return -1; // check maximal position

	// empty text
	s32 len = (*fnd)->len;
	if (len == 0) return pos;

	// one-character text
	const char* f = (*fnd)->data;
	char ch = *f;
	if (len == 1) return TextFindChar(text, ch, pos);

	// find string
	f++;
	len--;
	const char* data = &(*text)->data[pos];
	i = i - pos - len;
	for (; i >= 0; i--)
	{
		if (*data++ == ch)
		{
			if (MemComp(data, f, len) == 0)
				return (int)(data - (*text)->data - 1);
		}
	}
	return -1;
}

// find string with length from starting position (returns position or -1=not found)
int TextFindStrLen(const pText* text, const char* fnd, s32 len, int pos)
{
	// limit start position
	if (pos < 0) pos = 0; // check minimal position
	s32 i = (*text)->len;
	if (pos > i) return -1; // check maximal position

	// get text length
	if (fnd == NULL) len = 0;
	if (len < 0) len = StrLen(fnd);

	// empty text
	if (len == 0) return pos;

	// one-character text
	const char* f = fnd;
	char ch = *f;
	if (len == 1) return TextFindChar(text, ch, pos);

	// find string
	f++;
	len--;
	const char* data = &(*text)->data[pos];
	i = i - pos - len;
	for (; i >= 0; i--)
	{
		if (*data++ == ch)
		{
			if (MemComp(data, f, len) == 0)
				return (int)(data - (*text)->data - 1);
		}
	}
	return -1;
}

// find text reverse from starting position (returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindRev(const pText* text, const pText* fnd, int pos)
{
	// limit start position
	int len = (*fnd)->len;
	if (pos > (*text)->len - len) pos = (*text)->len - len;
	if (pos < 0) return -1;

	// empty text
	if (len == 0) return pos;

	// one-character text
	const char* f = (*fnd)->data;
	char ch = *f;
	if (len == 1) return TextFindChar(text, ch, pos);

	// find string
	f++;
	len--;
	const char* data = &(*text)->data[pos];
	for (; pos >= 0; pos--)
	{
		if (*data == ch)
		{
			if (MemComp(&data[1], f, len) == 0)
				return pos;
		}
		data--;
	}
	return -1;
}

// find string with length reverse from starting position (returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindStrLenRev(const pText* text, const char* fnd, s32 len, int pos)
{
	// get text length
	if (fnd == NULL) len = 0;
	if (len < 0) len = StrLen(fnd);

	// limit start position
	if (pos > (*text)->len - len) pos = (*text)->len - len;
	if (pos < 0) return -1;

	// empty text
	if (len == 0) return pos;

	// one-character text
	const char* f = fnd;
	char ch = *f;
	if (len == 1) return TextFindChar(text, ch, pos);

	// find string
	f++;
	len--;
	const char* data = &(*text)->data[pos];
	for (; pos >= 0; pos--)
	{
		if (*data == ch)
		{
			if (MemComp(&data[1], f, len) == 0)
				return pos;
		}
		data--;
	}
	return -1;
}

// find characters from string list with length (returns position or -1=not found)
int TextFindListStrLen(const pText* text, const char* list, int len, int pos)
{
	// limit start position
	if (pos < 0) pos = 0;
	int len0 = (*text)->len;
	if (pos >= len0) return -1;

	// prepare number of characters
	if (list == NULL) len = 0;
	if (len < 0) len = StrLen(list);
	if (len == 0) return -1;
	len--;

	// find character
	char ch;
	int i;
	for (len0 -= pos; len0 > 0; len0--)
	{
		ch = (*text)->data[pos];
		for (i = len; i >= 0; i--) if (ch == list[i]) return pos;
		pos++;
	}
	return -1;
}

// find characters from string list with length (returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindListStrLenRev(const pText* text, const char* list, int len, int pos)
{
	// limit start position
	int len0 = (*text)->len;
	if (pos >= len0) pos = len0-1;
	if (pos < 0) return -1;

	// prepare number of characters
	if (list == NULL) len = 0;
	if (len < 0) len = StrLen(list);
	if (len == 0) return -1;
	len--;

	// find character
	char ch;
	int i;
	for (; pos >= 0; pos--)
	{
		ch = (*text)->data[pos];
		for (i = len; i >= 0; i--) if (ch == list[i]) return pos;
	}
	return -1;
}

// find characters except string list with length (returns position or -1=not found)
int TextFindExceptListStrLen(const pText* text, const char* list, int len, int pos)
{
	// limit start position
	if (pos < 0) pos = 0;
	int len0 = (*text)->len;
	if (pos >= len0) return -1;

	// prepare number of characters
	if (list == NULL) len = 0;
	if (len < 0) len = StrLen(list);
	if (len == 0) return pos;
	len--;

	// find character
	char ch;
	int i;
	for (len0 -= pos; len0 > 0; len0--)
	{
		ch = (*text)->data[pos];
		for (i = len; i >= 0; i--) if (ch == list[i]) break;
		if (i < 0) return pos;
		pos++;
	}
	return -1;
}

// find characters reverse except string list with length (returns position or -1=not found)
//   use pos=BIGINT to search from the end
int TextFindExceptListStrLenRev(const pText* text, const char* list, int len, int pos)
{
	// limit start position
	int len0 = (*text)->len;
	if (pos >= len0) pos = len0-1;
	if (pos < 0) return -1;

	// prepare number of characters
	if (list == NULL) len = 0;
	if (len < 0) len = StrLen(list);
	if (len == 0) return pos;
	len--;

	// find character
	char ch;
	int i;
	for (; pos >= 0; pos--)
	{
		ch = (*text)->data[pos];
		for (i = len; i >= 0; i--) if (ch == list[i]) break;
		if (i < 0) return pos;
	}
	return -1;
}

// substitute text (returns False on memory error)
Bool TextSubst(pText* text, const pText* find, const pText* subst)
{
	int pos = 0;
	int len;
	int findlen = (*find)->len;
	int substlen = (*subst)->len;
	for (;;)
	{
		// find text
		pos = TextFind(text, find, pos);
		if (pos < 0) break;

		// copy buffer before write
		if (!TextCopyWrite(text)) return False;

		// increase buffer size
		len = (*text)->len;
		if (substlen > findlen)
			if (!TextSetLen(text, len + substlen - findlen)) return False;

		// move second part of the text
		if (substlen != findlen) MemMove(&(*text)->data[pos + substlen],
			&(*text)->data[pos + findlen], (len - pos - findlen));

		// copy substituted text
		memcpy(&(*text)->data[pos], (*subst)->data, substlen);

		// decrease buffer size
		if (substlen < findlen)
			if (!TextSetLen(text, len + substlen - findlen)) return False;

		// shift current position
		pos += substlen;
	}
	return True;
}

// substitute characters from string list with length (returns False on memory error)
Bool TextSubstListStrLen(pText* text, const char* list, const char* subst, int len)
{
	// prepare number of characters
	int len2 = len;
	if (list == NULL) len = 0;
	if (len < 0) len = StrLen(list);
	if (subst == NULL) len2 = 0;
	if (len2 < 0) len2 = StrLen(subst);
	if (len != len2) return False;
	if (len == 0) return True;

	// copy before write
	if (!TextCopyWrite(text)) return False;

	// replace characters
	int len0 = (*text)->len;
	char* data = (*text)->data;
	char ch;
	int i;
	for (; len0 > 0; len0--)
	{
		ch = *data;
		for (i = 0; i < len; i++)
		{
			if (ch == list[i])
			{
				*data = subst[i];
				break;
			}
		}
		data++;
	}
	return True;
}

// ============================================================================
//                              Conversion
// ============================================================================

// convert text to uppercase (returns False on memory error)
Bool TextUpperCase(pText* text)
{
	// copy on write
	if (!TextCopyWrite(text)) return False;

	int len = (*text)->len;
	char* data = (*text)->data;

	char ch;
	for (; len > 0; len--)
	{
		ch = *data;
		if ((ch >= 'a') && (ch <= 'z')) *data = ch - 'a' + 'A';
		data++;
	}

	return True;
}

// convert text to lowercase (returns False on memory error)
Bool TextLowerCase(pText* text)
{
	// copy on write
	if (!TextCopyWrite(text)) return False;

	int len = (*text)->len;
	char* data = (*text)->data;

	char ch;
	for (; len > 0; len--)
	{
		ch = *data;
		if ((ch >= 'A') && (ch <= 'Z')) *data = ch - 'A' + 'a';
		data++;
	}

	return True;
}

// convert text to opposite case (returns False on memory error)
Bool TextFlipCase(pText* text)
{
	// copy on write
	if (!TextCopyWrite(text)) return False;

	int len = (*text)->len;
	char* data = (*text)->data;

	char ch;
	for (; len > 0; len--)
	{
		ch = *data;
		if ((ch >= 'A') && (ch <= 'Z'))
			*data = ch - 'A' + 'a';
		else
			if ((ch >= 'a') && (ch <= 'z'))
				*data = ch - 'a' + 'A';
		data++;
	}

	return True;
}

// convert text to wordcase - first letter upper (returns False on memory error)
Bool TextWordCase(pText* text)
{
	// copy on write
	if (!TextCopyWrite(text)) return False;

	int len = (*text)->len;
	char* data = (*text)->data;

	char ch;
	Bool first = True;
	Bool up, low;
	for (; len > 0; len--)
	{
		ch = *data;

		// check letter
		up = (ch >= 'A') && (ch <= 'Z');
		low = (ch >= 'a') && (ch <= 'z');
		if (up || low)
		{
			// first letter of the word - convert to upper case
			if (first)
			{
				if (low) *data = ch - 'a' + 'A';
			}

			// next letter of the word - convert to lower case
			else
			{
				if (up) *data = ch - 'A' + 'a';
			}

			// not first letter
			first = False;
		}
		else
			// first letter
			first = True;

		data++;
	}

	return True;
}

// convert text to reverse order (returns False on memory error)
Bool TextReverse(pText* text)
{
	// copy on write
	if (!TextCopyWrite(text)) return False;

	char* data = (*text)->data;

	char ch;
	int i = 0;
	int j = (*text)->len - 1;

	for (; i < j;)
	{
		ch = data[i];
		data[i] = data[j];
		data[j] = ch;
		i++;
		j--;
	}

	return True;
}

// ============================================================================
//                              Part of text
// ============================================================================

// left part of text (returns False on memory error)
Bool TextLeft(pText* dst, const pText* src, int len)
{
	// limit text length
	if (len < 0) len = 0;
	int n = (*src)->len;
	if (len > n) len = n;

	// detach old text
	TextDetach(dst);

	// create new buffer
	sTextData* d = TextDataNew(len);
	if (d == NULL)
	{
		// on error attach empty text
		TextInit(dst);
		return False;
	}
	else
	{
		// copy part of text
		(*dst) = d;
		memcpy(d->data, (*src)->data, len);
	}
	return True;
}

// right part of text (returns False on memory error)
Bool TextRight(pText* dst, const pText* src, int len)
{
	// limit text length
	if (len < 0) len = 0;
	int n = (*src)->len;
	if (len > n) len = n;
	int pos = n - len;

	// detach old text
	TextDetach(dst);

	// create new buffer
	sTextData* d = TextDataNew(len);
	if (d == NULL)
	{
		// on error attach empty text
		TextInit(dst);
		return False;
	}
	else
	{
		// copy part of text
		(*dst) = d;
		memcpy(d->data, &(*src)->data[pos], len);
	}
	return True;

}

// right part of text from position (returns False on memory error)
Bool TextRightFrom(pText* dst, const pText* src, int pos)
{
	// limit text length
	if (pos < 0) pos = 0;
	int n = (*src)->len;
	if (pos > n) pos = n;
	int len = n - pos;

	// detach old text
	TextDetach(dst);

	// create new buffer
	sTextData* d = TextDataNew(len);
	if (d == NULL)
	{
		// on error attach empty text
		TextInit(dst);
		return False;
	}
	else
	{
		// copy part of text
		(*dst) = d;
		memcpy(d->data, &(*src)->data[pos], len);
	}
	return True;
}

// middle part of text (returns False on memory error)
Bool TextMid(pText* dst, const pText* src, int pos, int len)
{
	// limit text length
	if (pos < 0) pos = 0;
	int n = (*src)->len;
	if (pos > n) pos = n;
	if (len < 0) len = 0;
	if ((u32)(pos+len) > (u32)n) len = n - pos;

	// detach old text
	TextDetach(dst);

	// create new buffer
	sTextData* d = TextDataNew(len);
	if (d == NULL)
	{
		// on error attach empty text
		TextInit(dst);
		return False;
	}
	else
	{
		// copy part of text
		(*dst) = d;
		memcpy(d->data, &(*src)->data[pos], len);
	}
	return True;
}

// ============================================================================
//                              Insert/delete
// ============================================================================

// insert string with length (returns False on memory error)
Bool TextInsertStrLen(pText* dst, int pos, const char* src, int len)
{
	// prepare text length
	if (src == NULL) len = 0;
	if (len < 0) len = StrLen(src);

	// limit position
	if (pos < 0) pos = 0;
	int len0 = (*dst)->len;
	if (pos > len0) pos = len0;

	// insert text
	if (!TextSetLen(dst, len0 + len)) return False; // set new size of text buffer
	MemMove(&(*dst)->data[pos + len], &(*dst)->data[pos], len0 - pos); // move remaining text
	memcpy(&(*dst)->data[pos], src, len); // copy inserted text
	return True;
}

// insert character (returns False on memory error)
Bool TextInsertChar(pText* dst, int pos, char ch)
{
	// limit position
	if (pos < 0) pos = 0;
	int len = (*dst)->len;
	if (pos > len) pos = len;

	// insert text
	if (!TextSetLen(dst, len + 1)) return False; // set new size of text buffer
	MemMove(&(*dst)->data[pos + 1], &(*dst)->data[pos], len - pos); // move remaining text
	(*dst)->data[pos] = ch; // set new character
	return True;
}

// delete characters (returns False on memory error)
Bool TextDelete(pText* text, int pos, int num)
{
	// limit position
	if (pos < 0) pos = 0;
	int len = (*text)->len;
	if (pos > len) pos = len;

	// limit length
	if (num < 0) num = 0;
	if (num > len) num = len;
	if ((u32)(pos + num) > (u32)len) num = len - pos;

	// delete characters
	if (num > 0)
	{
		if (!TextCopyWrite(text)) return False; // copy on write
		MemMove(&(*text)->data[pos], &(*text)->data[pos + num], len - pos - num); // move remaining text
		return TextSetLen(text, len - num); // set new text length
	}
	return True;
}

// delete characters from string list with length (returns False on memory error)
Bool TextDelListStrLen(pText* text, const char* list, int len)
{
	// prepare number of characters
	if (list == NULL) len = 0;
	if (len < 0) len = StrLen(list);
	if (len == 0) return True;
	len--;

	// empty string
	int len0 = (*text)->len;
	if (len0 == 0) return True;

	// copy before write
	if (!TextCopyWrite(text)) return False;

	// delete characters
	char* dst = (*text)->data;
	char* src = dst;
	char ch;
	int i;
	for (; len0 > 0; len0--)
	{
		ch = *src++;
		for (i = len; i >= 0; i--) if (ch == list[i]) break;
		if (i < 0) *dst++ = ch;
	}

	// resize buffer
	if (src != dst) return TextSetLen(text, (int)(dst - (*text)->data));
	return True;
}

// delete characters except string list with length (returns False on memory error)
Bool TextDelExceptListStrLen(pText* text, const char* list, int len)
{
	// prepare number of characters
	if (list == NULL) len = 0;
	if (len < 0) len = StrLen(list);
	if (len == 0)
	{
		TextEmpty(text);
		return True;
	}
	len--;

	// empty string
	int len0 = (*text)->len;
	if (len0 == 0) return True;

	// copy before write
	if (!TextCopyWrite(text)) return False;

	// delete characters
	char* dst = (*text)->data;
	char* src = dst;
	char ch;
	int i;
	for (; len0 > 0; len0--)
	{
		ch = *src++;
		for (i = len; i >= 0; i--)
		{
 			if (ch == list[i])
			{
				*dst++ = ch;
				break;
			}
		}
	}

	// resize buffer
	if (src != dst) return TextSetLen(text, (int)(dst - (*text)->data));
	return True;
}

// find and delete all string words with length (returns False on memory error)
Bool TextDelWordStrLen(pText* text, const char* word, int len)
{
	// prepare text length
	if (word == NULL) len = 0;
	if (len < 0) len = StrLen(word);
	if (len == 0) return True;

	// find and delete words
	int pos = 0;
	for (;;)
	{
		pos = TextFindStrLen(text, word, len, pos);
		if (pos < 0) break;
		if (!TextDelete(text, pos, len)) return False;
	}
	return True;
}

// trim white spaces from begin of the string (returns False on memory error)
Bool TextTrimLeft(pText* text)
{
	// find start of text
	char* d = (*text)->data;
	char ch;
	do { ch = *d++; } while ((ch > 0) && (ch <= (char)32));

	// delete white spaces
	int len = (int)(d - (*text)->data - 1);
	if (len > 0)
	{
		if (!TextCopyWrite(text)) return False;
		int n = (*text)->len;
		MemMove((*text)->data, &(*text)->data[len], n - len);
		return TextSetLen(text, n - len);
	}
	return True;
}

// trim white spaces from end of the string (returns False on memory error)
Bool TextTrimRight(pText* text)
{
	// find end of text
	int n = (*text)->len;
	char* d = &(*text)->data[n];
	for (; n > 0; n--)
	{
		d--;
		if ((u32)*d > (u32)' ') break;
	}

	// set new text length
	if (n != (*text)->len) return TextSetLen(text, n);
	return True;
}

// ============================================================================
//                              Multi-line text
// ============================================================================

// get number of rows of multi-line text (search LF)
int TextRowsNum(const pText* text)
{
	const char* data = (*text)->data;
	int len = (*text)->len;
	int rows = 0;

	// add last row without LF
	if ((len >= 1) && (data[len - 1] != CH_LF)) rows = 1;

	// calculate number of rows
	for (; len > 0; len--)
	{
		if (*data++ == CH_LF) rows++;
	}
	return rows;
}

// get one row from multi-line text (search LF, trim CR, returns False on memory error)
Bool TextRow(pText* dst, const pText* src, int row)
{
	int len = (*src)->len;
	int start = 0;
	int next = 0;
	const char* data = (*src)->data;

	// find required row
	for (; next < len; next++)
	{
		if (*data == CH_LF)
		{
			row--;
			if (row < 0) break;
			start = next + 1;
		}
		data++;
	}
	if (row > 0) start = next;

	// trim CR
	while ((start < next) && ((*src)->data[start] == CH_CR)) start++;
	while ((next > start) && ((*src)->data[next-1] == CH_CR)) next--;

	// get text
	return TextMid(dst, src, start, next-start);
}

// unformat text - substitute white characters with one space character
Bool TextUnformat(pText* text)
{
	char *dst, *src;
	int len = (*text)->len;
	dst = (*text)->data;
	src = dst;
	Bool lastspace = False; // flag - last character was space
	char ch;

	// copy before write
	if (!TextCopyWrite(text)) return False;

	for (; len > 0;  len--)
	{
		ch = *src++;
		if ((u8)ch <= (u8)32) // white character
		{
			if (!lastspace)
			{
				*dst++ = ' ';
				lastspace = True;
			}
		}
		else
		{
			*dst++ = ch;
			lastspace = False;
		}
	}
	len = (int)(dst - (*text)->data);

	// resize buffer
	if (len != (*text)->len) return TextSetLen(text, len);
	return True;
}

// reformat text to different width of paragraph (inserts LF)
Bool TextReformat(pText* text, int width)
{
	// unformat text (with copy before write)
	if (!TextUnformat(text)) return False;
	if (width < 1) return True;

	u8* s = (*text)->data;
	u8* rowstart = s;
	u8* wordstart = s;
	int len = (*text)->len;
	for (; len > 0; len--)
	{
		// found space character
		if (*s++ == ' ')
		{
			// check row length
			if ((s - 1 - rowstart) > width)
			{
				// row is too long, insert LF before last word, but except very long word
				if (wordstart != rowstart)
				{
					wordstart[-1] = CH_LF;
					rowstart = wordstart;
				}
			}

			// mark start of new word
			wordstart = s;

			// mark last LF at end of text
			if (len == 1)
			{
				s[-1] = CH_LF;
				rowstart = s;
			}
		}
	}

	// end of text (without last space), split last row
	if ((s - rowstart) > width)
	{
		// row is too long, insert LF before last word, but except very long word
		if (wordstart != rowstart) wordstart[-1] = CH_LF;
	}
	return True;
}

// ============================================================================
//                              Formated print
// ============================================================================

// formated print string into text, with argument list
//  text = NULL to get text length without printing
//  - fmt and destination text cannot be the same
u32 TextPrintArg(pText* text, const char* fmt, va_list args)
{
	// delete destination text
	if (text != NULL) TextEmpty(text);

	// NUL print, to get text length
	u32 n = NulPrintArg(fmt, args);
	if ((n == 0) || (text == NULL)) return n;

	// create new buffer
	sTextData* data2 = TextDataNew(n); // create new buffer
	if (data2 == NULL) return 0;
	TextDetach(text); // detach old buffer
	*text = data2; // set new buffer

	// print text
	MemPrintArg((*text)->data, (*text)->len+1, fmt, args);

	return n;
}

// formated print string into text, with variadic arguments
//  text = NULL to get text length without printing
//  - fmt and destination text cannot be the same
NOINLINE u32 TextPrint(pText* text, const char* fmt, ...)
{
	u32 n;
	va_list args;
	va_start(args, fmt);
	n = TextPrintArg(text, fmt, args);
	va_end(args);
	return n;
}

// add formated print string into text, with argument list
//  - fmt and destination text cannot be the same
u32 TextAddPrintArg(pText* text, const char* fmt, va_list args)
{
	// NUL print, to get text length
	u32 n = NulPrintArg(fmt, args);
	if (n == 0) return 0;

	// resize buffer
	u32 oldlen = (*text)->len;
	if (!TextSetLen(text, n + oldlen)) return 0;

	// print text
	MemPrintArg(&(*text)->data[oldlen], n+1, fmt, args);

	return n;
}

// add formated print string into text, with variadic arguments
//  - fmt and destination text cannot be the same
NOINLINE u32 TextAddPrint(pText* text, const char* fmt, ...)
{
	u32 n;
	va_list args;
	va_start(args, fmt);
	n = TextAddPrintArg(text, fmt, args);
	va_end(args);
	return n;
}

#endif // USE_TEXT	// use Text strings, except StrLen and StrComp (lib_text.c, lib_text.h)

// ============================================================================
//                           ASCIIZ string functions
// ============================================================================

// get length of ASCIIZ text string
int StrLen(const char* text)
{
	if (text == NULL) return 0;
	const char* t = text;
	while (*t++ != 0) {};
	return (t - text) - 1;
}

// compare ASCIIZ text strings (returns 0=equal or returns character difference)
int StrComp(const char* text1, const char* text2)
{
	char ch1, ch2;
	for (;;)
	{
		ch1 = *text1++;
		ch2 = *text2++;
		if (ch1 != ch2) return ch1 - ch2;
		if (ch1 == 0) break;
	}
	return 0;
}

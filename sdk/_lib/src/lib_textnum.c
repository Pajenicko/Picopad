
// ****************************************************************************
//
//                       Text strings - number conversion
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_TEXT	// use Text strings, except StrLen and StrComp (lib_text.c, lib_text.h)

#include "../../_sdk/inc/sdk_cpu.h"
#include "../../_sdk/inc/sdk_bootrom.h"
#include "../inc/lib_text.h"

#if USE_FLOAT		// use float support
// round coefficients, used in SetFloat function
const float SetFloatCoeff[11] = { 5e0f, 5e-1f, 5e-2f, 5e-3f, 5e-4f, 5e-5f, 5e-6f,
	5e-7f, 5e-8f, 5e-9f, 5e-10f };
#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support
// round coefficients, used in SetDouble function
const double SetDoubleCoeff[19] = { 5e0, 5e-1, 5e-2, 5e-3, 5e-4, 5e-5, 5e-6, 5e-7,
	5e-8, 5e-9, 5e-10, 5e-11, 5e-12, 5e-13, 5e-14, 5e-15, 5e-16 };
#endif // USE_DOUBLE		// use double support

// ============================================================================
//                           Set decadic integer
// ============================================================================

// set/add signed/unsigned INT number to text (sep = thousand separator or 0=none; returns False on memory error)
Bool TextSetAddInt(pText* text, s32 num, char sep, Bool add, Bool unsign)
{
	// prepare temporary buffer
	char buf[14]; // temporary buffer: 10 digits, 3 separators, 1 NUL
	char* dst = buf+14; // pointer to end of temporary buffer
	int len = 0; // length of the text
	u32 n = num; // number as unsigned
	u32 k;
	sTextData* data;

	// prepare sign
	Bool sign = False;
	if (!unsign && (num < 0))
	{
		sign = True;
		n = -num;
	}

	// convert digits to the buffer
	int sepn = 0;
	do {
		// thousand separator
		if ((sepn == 3) && (sep != 0))
		{
			sepn = 0;
			*--dst = sep;
			len++;
		}
		sepn++;

		// decode digit
		k = n / 10;
		*--dst = (char)((n - k*10) + '0');
		n = k;
		len++;
	} while (n != 0);

	// store sign
	if (sign)
	{
		*--dst = '-';
		len++;
	}

	// copy number into buffer
	int len0; // destination offset
	if (add)
	{
		// add number to destination text
		len0 = (*text)->len; // current length of destination text
		if (!TextSetLen(text, len0 + len)) return False; // set new length of the text
	}
	else
	{
		// set number to destinaton text
		len0 = 0; // destination offset = 0
		TextDetach(text); // detach old text
		data = TextDataNew(len); // create new data
		if (data == NULL) // memory error
		{
			// on memory error, attach empty text
			TextAttach(text, &EmptyTextData);
			return False;
		}
		*text = data; // set new text
	}

	// copy number to destination buffer
	memcpy(&(*text)->data[len0], dst, len);
	return True;
}

// set/add signed/unsigned 64-bit INT number to text (sep = thousand separator or 0=none; returns False on memory error)
Bool TextSetAddInt64(pText* text, s64 num, char sep, Bool add, Bool unsign)
{
	// prepare temporary buffer
	char buf[28]; // temporary buffer: 20 digits, 6 separators, 1 NUL
	char* dst = buf+28; // pointer to end of temporary buffer
	int len = 0; // length of the text
	u64 n = num; // number as unsigned
	u64 k;
	sTextData* data;

	// prepare sign
	Bool sign = False;
	if (!unsign && (num < 0))
	{
		sign = True;
		n = -num;
	}

	// convert digits to the buffer
	int sepn = 0;
	do {
		// thousand separator
		if ((sepn == 3) && (sep != 0))
		{
			sepn = 0;
			*--dst = sep;
			len++;
		}
		sepn++;

		// decode digit
		k = n / 10;
		*--dst = (char)((n - k*10) + '0');
		n = k;
		len++;
	} while (n != 0);

	// store sign
	if (sign)
	{
		*--dst = '-';
		len++;
	}

	// copy number into buffer
	int len0; // destination offset
	if (add)
	{
		// add number to destination text
		len0 = (*text)->len; // current length of destination text
		if (!TextSetLen(text, len0 + len)) return False; // set new length of the text
	}
	else
	{
		// set number to destinaton text
		len0 = 0; // destination offset = 0
		TextDetach(text); // detach old text
		data = TextDataNew(len); // create new data
		if (data == NULL) // memory error
		{
			// on memory error, attach empty text
			TextAttach(text, &EmptyTextData);
			return False;
		}
		*text = data; // set new text
	}

	// copy number to destination buffer
	memcpy(&(*text)->data[len0], dst, len);
	return True;
}

// ============================================================================
//                             Set digits
// ============================================================================

// set/add 2 digits (returns False on memory error)
Bool TextSetAdd2Dig(pText* text, s8 num, Bool add)
{
	s32 len;
	sTextData* data;

	// limit range of the number
	if (num < 0) num = 0;
	if (num > 99) num = 99;

	if (add)
	{
		// add number
		len = (*text)->len; // destination offset
		if (!TextSetLen(text, len + 2)) return False; // set new length of the text
	}
	else
	{
		// set number
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

	// decode number to the buffer
	int n = num/10;
	(*text)->data[len] = (char)(n + '0');
	(*text)->data[len+1] = (char)((num - n*10) + '0');
	return True;
}


// set/add 2 digits with space padding (returns False on memory error)
Bool TextSetAdd2DigSpc(pText* text, s8 num, Bool add)
{
	s32 len;
	sTextData* data;

	// limit range of the number
	if (num < 0) num = 0;
	if (num > 99) num = 99;

	if (add)
	{
		// add number
		len = (*text)->len; // destination offset
		if (!TextSetLen(text, len + 2)) return False; // set new length of the text
	}
	else
	{
		// set number
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

	// decode number to the buffer
	int n = num/10;
	(*text)->data[len] = (num < 10) ? ' ' : (char)(n + '0');
	(*text)->data[len+1] = (char)((num - n*10) + '0');
	return True;
}

// set/add 4 digits (returns False on memory error)
Bool TextSetAdd4Dig(pText* text, s16 num, Bool add)
{
	s32 len;
	sTextData* data;

	// limit range of the number
	if (num < 0) num = 0;
	if (num > 9999) num = 9999;

	if (add)
	{
		// add number
		len = (*text)->len; // destination offset
		if (!TextSetLen(text, len + 4)) return False; // set new length of the text
	}
	else
	{
		// set number
		len = 0; // destination offset = 0
		TextDetach(text); // detach old text
		data = TextDataNew(4); // create new text
		if (data == NULL)
		{
			// on memory error, attach empty text
			TextAttach(text, &EmptyTextData);
			return False;
		}
		*text = data; // set new text
	}

	// decode number to the buffer
	int n = num/100;
	int k = n/10;
	(*text)->data[len] = (char)(k + '0');
	(*text)->data[len+1] = (char)((n - k*10) + '0');
	n = num - n*100;
	k = n/10;
	(*text)->data[len+2] = (char)(k + '0');
	(*text)->data[len+3] = (char)((n - k*10) + '0');
	return True;
}

// ============================================================================
//                           Set HEX integer
// ============================================================================

// convert integer to text as HEX (digits <= 0 to auto-digits,
//  sep = 4-digit separator or 0=none; returns False on memory error)
Bool TextSetAddHex(pText* text, u32 num, s8 digits, char sep, Bool add)
{
	s32 len;
	sTextData* data;

	// prepare default number of digits
	if (digits <= 0) digits = (Order(num)+3)/4;
	if (digits == 0) digits = 1;

	// prepare number of separators
	int sepn = 0;
	if (sep != 0) sepn = (digits - 1)/4;

	if (add)
	{
		// add number
		len = (*text)->len; // destination offset
		if (!TextSetLen(text, len + digits + sepn)) return False; // set new length of the text
	}
	else
	{
		// set number
		len = 0; // destination offset = 0
		TextDetach(text); // detach old text
		data = TextDataNew(digits + sepn); // create new text
		if (data == NULL)
		{
			// on memory error, attach empty text
			TextAttach(text, &EmptyTextData);
			return False;
		}
		*text = data; // set new text
	}

	// destination pointer to end of number
	char* d = &(*text)->data[len + digits + sepn];

	// decode digits
	char ch;
	sepn = 0;
	for (; digits > 0; digits--)
	{
		// thousand separator
		if ((sepn == 4) && (sep != 0))
		{
			sepn = 0;
			*--d = sep;
		}
		sepn++;

		// decode digt
		ch = (char)(num & 0xf);
		*--d = (char)((ch <= 9) ? (ch + '0') : (ch - 10 + 'A'));
		num >>= 4;
	}
	return True;
}

// convert 64-bit integer to text as HEX (digits <= 0 to auto-digits,
//  sep = 4-digit separator or 0=none; returns False on memory error)
Bool TextSetAddHex64(pText* text, u64 num, s8 digits, char sep, Bool add)
{
	s32 len;
	sTextData* data;

	// prepare default number of digits
	if (digits <= 0) digits = (Order64(num)+3)/4;
	if (digits == 0) digits = 1;

	// prepare number of separators
	int sepn = 0;
	if (sep != 0) sepn = (digits - 1)/4;

	if (add)
	{
		// add number
		len = (*text)->len; // destination offset
		if (!TextSetLen(text, len + digits + sepn)) return False; // set new length of the text
	}
	else
	{
		// set number
		len = 0; // destination offset = 0
		TextDetach(text); // detach old text
		data = TextDataNew(digits + sepn); // create new text
		if (data == NULL)
		{
			// on memory error, attach empty text
			TextAttach(text, &EmptyTextData);
			return False;
		}
		*text = data; // set new text
	}

	// destination pointer to end of number
	char* d = &(*text)->data[len + digits + sepn];

	// decode digits
	char ch;
	sepn = 0;
	for (; digits > 0; digits--)
	{
		// thousand separator
		if ((sepn == 4) && (sep != 0))
		{
			sepn = 0;
			*--d = sep;
		}
		sepn++;

		// decode digt
		ch = (char)(num & 0xf);
		*--d = (char)((ch <= 9) ? (ch + '0') : (ch - 10 + 'A'));
		num >>= 4;
	}
	return True;
}

#if USE_FLOAT		// use float support

// ============================================================================
//                           Set decimal number
// ============================================================================

// convert FLOAT number to text (returns False on error; recommended digits=6)
Bool TextSetAddFloat(pText* text, float num, s8 digits, Bool add)
{
	sTextData* data;

	// limit number of digits
	if (digits < 1) digits = 1;
	if (digits > 8) digits = 8;

	// overflow
	if (CheckInfF(num))  { if (!add) TextEmpty(text); return TextAddStrLen(text, "INF", 3); }
	if (CheckSInfF(num)) { if (!add) TextEmpty(text); return TextAddStrLen(text, "-INF", 4); }
	if (CheckNanF(num))  { if (!add) TextEmpty(text); return TextAddStrLen(text, "NAN", 3); }
	if (CheckSNanF(num)) { if (!add) TextEmpty(text); return TextAddStrLen(text, "-NAN", 4); }

	// zero
	if (num == 0)
	{
		if (!add) TextEmpty(text);
		return TextAddCh(text, (char)'0');
	}

	// prepare sign
	Bool sign = False;
	if (num < 0)
	{
		sign = True;
		num = -num;
	}

	// split number to exponent and mantissa
	int expI = 0;
	float mantD = num;
	if (mantD >= 1)
	{
		if (mantD >= 1e32f)  { mantD *= 1e-32f;  expI += 32;  };
		if (mantD >= 1e16f)  { mantD *= 1e-16f;  expI += 16;  };
		if (mantD >= 1e8f)   { mantD *= 1e-8f;   expI += 8;   };
		if (mantD >= 1e4f)   { mantD *= 1e-4f;   expI += 4;   };
		if (mantD >= 1e2f)   { mantD *= 1e-2f;   expI += 2;   };
		if (mantD >= 1e1f)   { mantD *= 1e-1f;   expI += 1;   };
	}
	else
	{
		if (mantD < 1e-32f)  { mantD *= 1e33f;   expI -= 33;  };
		if (mantD < 1e-16f)  { mantD *= 1e17f;   expI -= 17;  };
		if (mantD < 1e-8f)   { mantD *= 1e9f;    expI -= 9;   };
		if (mantD < 1e-4f)   { mantD *= 1e5f;    expI -= 5;   };
		if (mantD < 1e-2f)   { mantD *= 1e3f;    expI -= 3;   };
		if (mantD < 1e-1f)   { mantD *= 1e2f;    expI -= 2;   };
		if (mantD < 1e0f)    { mantD *= 1e1f;    expI -= 1;   };
	}

	// round last digit
	mantD += SetFloatCoeff[digits];

	// mantissa correction - prepare to split to HIGH part (4 digits) and LOW part (4 digits)
	mantD *= 1e3f;
	if (mantD >= 1e4f)
	{
		mantD /= 10;
		expI++;
	}

	// split mantissa to LOW and HIGH part
	int mantH = (int)(mantD); // high part of 4 digits
	int mantL = (int)((mantD - mantH)*1e4f); // low part of 4 digits

	// decode mantissa (LOW and HIGH part)
	int i;
	char mantT[8]; // mantissa buffer (4 + 4 = 8 digits)
	char* mantP = mantT + 8; // pointer into buffer

	int k;
	for (i = 4; i > 0; i--) // decode LOW part
	{
		mantP--;
		k = mantL/10;
		*mantP = (char)((mantL - k*10) + '0');
		mantL = k;
	}

	for (i = 4; i > 0; i--) // decode HIGH part
	{
		mantP--;
		k = mantH/10;
		*mantP = (char)((mantH - k*10) + '0');
		mantH = k;
	}

	// get number of significant digits (skip terminating '0' digits)
	char* dst = mantT + digits; // pointer to end of mantissa
	int dig = digits;
	for (; dig > 1; dig--)
	{
		dst--;
		if (*dst != (char)'0') break;
	}

	// prepare sign
	char buf[20]; // destination buffer (sign + 0000 + 8 digits + decimal + e + sign + 2 exp + NUL = 19)
	dst = buf;
	if (sign)
	{
		// store sign
		*dst = '-';
		dst++;
	}

	// decode number without exponent, number >= 1
	if ((expI < digits) && (expI >= 0))
	{
		for (;;)
		{
			*dst++ = *mantP++;
			dig--;
			if ((expI <= 0) && (dig <= 0)) break;
			if (expI == 0) *dst++ = '.';
			expI--;
		}
	}
	else
	{
		// decode number without exponent, number < 1
		if ((expI < 0) && (expI >= -3))
		{
			*dst++ = '0';
			*dst++ = '.';
			expI++;
			for (; expI < 0; expI++) *dst++ = '0';
			for (; dig > 0; dig--) *dst++ = *mantP++;
		}

		// decode number with exponent
		else
		{
			*dst++ = *mantP++;
			dig--;
			if (dig > 0)
			{
				*dst++ = '.';
				for (; dig > 0; dig--) *dst++ = *mantP++;
			}

			*dst++ = 'e';
			if (expI < 0)
			{
				*dst++ = '-';
				expI = -expI;
			}

			if (expI > 9)
			{
				k = expI/10;
				*dst++ = (char)(k + '0');
				expI = expI - k*10;
			}
			
			*dst++ = (char)(expI + '0');
		}
	}

	// save number into buffer
	int len = (int)(dst - buf);
	int len0;
	if (add)
	{
		// add number
		len0 = (*text)->len; // destination offset
		if (!TextSetLen(text, len0 + len)) return False; // set new length of the text
	}
	else
	{
		// set number
		len0 = 0; // destination offset = 0
		TextDetach(text); // detach old text
		data = TextDataNew(len); // create new text
		if (data == NULL)
		{
			// on memory error, attach empty text
			TextAttach(text, &EmptyTextData);
			return False;
		}
		*text = data; // set new text
	}

	// copy number into buffer
	memcpy(&(*text)->data[len0], buf, len);
	return True;
}

#endif // USE_FLOAT		// use float support

#if USE_DOUBLE		// use double support
// convert DOUBLE number to text (returns False on error; recommended digits=14)
Bool TextSetAddDouble(pText* text, double num, s8 digits, Bool add)
{
	sTextData* data;

	// limit number of digits
	if (digits < 1) digits = 1;
	if (digits > 16) digits = 16;

	// overflow
	if (CheckInfD(num))  { if (!add) TextEmpty(text); return TextAddStrLen(text, "INF", 3); }
	if (CheckSInfD(num)) { if (!add) TextEmpty(text); return TextAddStrLen(text, "-INF", 4); }
	if (CheckNanD(num))  { if (!add) TextEmpty(text); return TextAddStrLen(text, "NAN", 3); }
	if (CheckSNanD(num)) { if (!add) TextEmpty(text); return TextAddStrLen(text, "-NAN", 4); }

	// zero
	if (num == 0)
	{
		if (!add) TextEmpty(text);
		return TextAddCh(text, (char)'0');
	}

	// prepare sign
	Bool sign = False;
	if (num < 0)
	{
		sign = True;
		num = -num;
	}

	// split number to exponent and mantissa
	int expI = 0;
	double mantD = num;
	if (mantD >= 1)
	{
		if (mantD >= 1e256) { mantD *= 1e-256; expI += 256; };
		if (mantD >= 1e128) { mantD *= 1e-128; expI += 128; };
		if (mantD >= 1e64)  { mantD *= 1e-64;  expI += 64;  };
		if (mantD >= 1e32)  { mantD *= 1e-32;  expI += 32;  };
		if (mantD >= 1e16)  { mantD *= 1e-16;  expI += 16;  };
		if (mantD >= 1e8)   { mantD *= 1e-8;   expI += 8;   };
		if (mantD >= 1e4)   { mantD *= 1e-4;   expI += 4;   };
		if (mantD >= 1e2)   { mantD *= 1e-2;   expI += 2;   };
		if (mantD >= 1e1)   { mantD *= 1e-1;   expI += 1;   };
	}
	else
	{
		if (mantD < 1e-256) { mantD *= 1e257;  expI -= 257; };
		if (mantD < 1e-128) { mantD *= 1e129;  expI -= 129; };
		if (mantD < 1e-64)  { mantD *= 1e65;   expI -= 65;  };
		if (mantD < 1e-32)  { mantD *= 1e33;   expI -= 33;  };
		if (mantD < 1e-16)  { mantD *= 1e17;   expI -= 17;  };
		if (mantD < 1e-8)   { mantD *= 1e9;    expI -= 9;   };
		if (mantD < 1e-4)   { mantD *= 1e5;    expI -= 5;   };
		if (mantD < 1e-2)   { mantD *= 1e3;    expI -= 3;   };
		if (mantD < 1e-1)   { mantD *= 1e2;    expI -= 2;   };
		if (mantD < 1e0)    { mantD *= 1e1;    expI -= 1;   };
	}

	// round last digit
	mantD += SetDoubleCoeff[digits];

	// mantissa correction - prepare to split to HIGH part (8 digits) and LOW part (8 digits)
	mantD *= 1e7;
	if (mantD >= 1e8)
	{
		mantD /= 10;
		expI++;
	}

	// split mantissa to LOW and HIGH part
	int mantH = (int)(mantD); // high part of 8 digits
	int mantL = (int)((mantD - mantH)*1e8); // low part of 8 digits

	// decode mantissa (LOW and HIGH part)
	int i;
	char mantT[16]; // mantissa buffer (8 + 8 = 16 digits)
	char* mantP = mantT + 16; // pointer into buffer

	int k;
	for (i = 8; i > 0; i--) // decode LOW part
	{
		mantP--;
		k = mantL/10;
		*mantP = (char)((mantL - k*10) + '0');
		mantL = k;
	}

	for (i = 8; i > 0; i--) // decode HIGH part
	{
		mantP--;
		k = mantH/10;
		*mantP = (char)((mantH - k*10) + '0');
		mantH = k;
	}

	// get number of significant digits (skip terminating '0' digits)
	char* dst = mantT + digits; // pointer to end of mantissa
	int dig = digits;
	for (; dig > 1; dig--)
	{
		dst--;
		if (*dst != (char)'0') break;
	}

	// prepare sign
	char buf[30]; // destination buffer (sign + 0000 + 16 digits + decimal + e + sign + 3 exp + NUL = 28)
	dst = buf;
	if (sign)
	{
		// store sign
		*dst = '-';
		dst++;
	}

	// decode number without exponent, number >= 1
	if ((expI < digits) && (expI >= 0))
	{
		for (;;)
		{
			*dst++ = *mantP++;
			dig--;
			if ((expI <= 0) && (dig <= 0)) break;
			if (expI == 0) *dst++ = '.';
			expI--;
		}
	}

	else
	{
		// decode number without exponent, number < 1
		if ((expI < 0) && (expI >= -3))
		{
			*dst++ = '0';
			*dst++ = '.';
			expI++;
			for (; expI < 0; expI++) *dst++ = '0';
			for (; dig > 0; dig--) *dst++ = *mantP++;
		}

		// decode number with exponent
		else
		{
			*dst++ = *mantP++;
			dig--;
			if (dig > 0)
			{
				*dst++ = '.';
				for (; dig > 0; dig--) *dst++ = *mantP++;
			}

			*dst++ = 'e';
			if (expI < 0)
			{
				*dst++ = '-';
				expI = -expI;
			}

			if (expI > 99)
			{
				k = expI/100;
				*dst++ = (char)(k + '0');
				expI = expI - k*100;

				k = expI/10;
				*dst++ = (char)(k + '0');
				expI = expI - k*10;
			}
			else
			{
				if (expI > 9)
				{
					k = expI/10;
					*dst++ = (char)(k + '0');
					expI = expI - k*10;
				}
			}
			
			*dst++ = (char)(expI + '0');
		}
	}

	// save number into buffer
	int len = (int)(dst - buf);
	int len0;
	if (add)
	{
		// add number
		len0 = (*text)->len; // destination offset
		if (!TextSetLen(text, len0 + len)) return False; // set new length of the text
	}
	else
	{
		// set number
		len0 = 0; // destination offset = 0
		TextDetach(text); // detach old text
		data = TextDataNew(len); // create new text
		if (data == NULL)
		{
			// on memory error, attach empty text
			TextAttach(text, &EmptyTextData);
			return False;
		}
		*text = data; // set new text
	}

	// copy number into buffer
	memcpy(&(*text)->data[len0], buf, len);
	return True;
}
#endif // USE_DOUBLE		// use double support

// ============================================================================
//                           ASCIIZ string functions
// ============================================================================

// convert ASCIIZ text to INT number
//  - can be in HEX format 0xN or $N; 
//  - no overflow check
//  - big number can overflow to negative number (use retype to unsigned u32)
s32 StrToInt(const char* text)
{
	u32 res;
	char ch;
	Bool sign, hex;

	// NULL pointer
	if (text == NULL) return 0;

	// get sign and skip spaces
	sign = False;
	for (;;)
	{
		// load next character
		ch = *text++;
		if (ch == 0) return 0;

		// negative sign
		if (ch == '-')
			sign = !sign;
		else
			// skip positive sign or whitespace
			if ((ch != '+') && ((ch > ' ') || (ch < 0))) break;
	}

	// check HEX format
	hex = False;
	if (ch == '$')
	{
		ch = *text++;
		hex = True;
	}
	else
	{
		if ((ch == '0') && ((*text == 'x') || (*text == 'X')))
		{
			text++;
			ch = *text++;
			hex = True;
		}
	}

	// load HEX digits
	res = 0;
	if (hex)
	{
		for (;;)
		{
			// convert to upper case letter
			if ((ch >= 'a') && (ch <= 'f')) ch -= 'a' - 'A';

			// invalid character
			if (((ch < '0') || (ch > '9')) &&
				((ch < 'A') || (ch > 'F'))) break;

			// add digit
			ch = ch - '0';
			if (ch >= 10) ch -= 7;
			res <<= 4;
			res |= ch;

			// load next character
			ch = *text++;
			if (ch == 0) break;
		}
	}
	else
	{	
		// load decimal digits
		while ((ch >= '0') && (ch <= '9')) // digit?
		{
			// add digit
			res *= 10; // multiply accumulator
			res += (u32)(ch - '0'); // add digit

			// load next character
			ch = *text++;
			if (ch == 0) break;
		}
	}

	// negative result
	if (sign) return -(s32)res;
	return res;
}

// convert ASCIIZ text to 64-bit INT number
//  - can be in HEX format 0xN or $N; 
//  - no overflow check
//  - big number can overflow to negative number (use retype to unsigned u64)
s64 StrToInt64(const char* text)
{
	u64 res;
	char ch;
	Bool sign, hex;

	// NULL pointer
	if (text == NULL) return 0;

	// get sign and skip spaces
	sign = False;
	for (;;)
	{
		// load next character
		ch = *text++;
		if (ch == 0) return 0;

		// negative sign
		if (ch == '-')
			sign = !sign;
		else
			// skip positive sign or whitespace
			if ((ch != '+') && ((ch > ' ') || (ch < 0))) break;
	}

	// check HEX format
	hex = False;
	if (ch == '$')
	{
		ch = *text++;
		hex = True;
	}
	else
	{
		if ((ch == '0') && ((*text == 'x') || (*text == 'X')))
		{
			text++;
			ch = *text++;
			hex = True;
		}
	}

	// load HEX digits
	res = 0;
	if (hex)
	{
		for (;;)
		{
			// convert to upper case letter
			if ((ch >= 'a') && (ch <= 'f')) ch -= 'a' - 'A';

			// invalid character
			if (((ch < '0') || (ch > '9')) &&
				((ch < 'A') || (ch > 'F'))) break;

			// add digit
			ch = ch - '0';
			if (ch >= 10) ch -= 7;
			res <<= 4;
			res |= ch;

			// load next character
			ch = *text++;
			if (ch == 0) break;
		}
	}
	else
	{	
		// load decimal digits
		while ((ch >= '0') && (ch <= '9')) // digit?
		{
			// add digit
			res *= 10; // multiply accumulator
			res += (u32)(ch - '0'); // add digit

			// load next character
			ch = *text++;
			if (ch == 0) break;
		}
	}

	// negative result
	if (sign) return -(s64)res;
	return res;
}

#if USE_FLOAT		// use float support

// convert ASCIIZ text to FLOAT number
float StrToFloat(const char* text)
{
	// get sign and skip spaces
	char ch;
	Bool sign = False;
	for (;;)
	{
		// load next character
		ch = *text++;
		if (ch == 0) return 0;

		// negative sign
		if (ch == '-')
			sign = !sign;
		else
			// skip positive sign or whitespace
			if ((ch != '+') && ((ch > ' ') || (ch < 0))) break;
	}

	// load digits of integer part
	float res = 0;
	while ((ch >= '0') && (ch <= '9'))
	{
		res *= 10;
		res += ch - '0';

		// load next character
		ch = *text++;
		if (ch == 0)
		{
			text--;
			break;
		}
	}

	// load digits of fractional part
	float frac = 1;
	if ((ch == '.') || (ch == ','))
	{
		// load next character
		ch = *text;
		if (ch != 0)
		{
			text++;

			while ((ch >= '0') && (ch <= '9'))
			{
				frac *= 10;
				res += (ch - '0')/frac;

				// load next character
				ch = *text++;
				if (ch == 0)
				{
					text--;
					break;
				}
			}
		}
	}

	// check exponent
	int expN = 0;
	Bool signE = False;
	if ((ch == 'E') || (ch == 'e'))
	{
		// get sign and skip spaces
		for (;;)
		{
			// load next character
			ch = *text++;
			if (ch == 0)
			{
				text--;
				break;
			}

			if (ch == '-')
				signE = !signE;
			else
				if (ch != '+') break;
		}

		// load exponent digits
		while ((ch >= '0') && (ch <= '9'))
		{
			expN *= 10;
			expN += ch - '0';

			// load next character
			ch = *text++;
			if (ch == 0)
			{
				text--;
				break;
			}
		}

		// multiply number by exponent
		if (expN != 0)
		{
			if (signE)
			{
				if (expN >=  32) { res *=  1e-32f; expN -=  32; };
				if (expN >=  16) { res *=  1e-16f; expN -=  16; };
				if (expN >=   8) { res *=   1e-8f; expN -=   8; };
				if (expN >=   4) { res *=   1e-4f; expN -=   4; };
				if (expN >=   2) { res *=   1e-2f; expN -=   2; };
				if (expN >=   1) { res *=   1e-1f;              };
			}
			else
			{
				if (expN >=  32) { res *=  1e32f; expN -=  32; };
				if (expN >=  16) { res *=  1e16f; expN -=  16; };
				if (expN >=   8) { res *=   1e8f; expN -=   8; };
				if (expN >=   4) { res *=   1e4f; expN -=   4; };
				if (expN >=   2) { res *=   1e2f; expN -=   2; };
				if (expN >=   1) { res *=   1e1f;              };
			}
		}
	}

	// result with sign
	if (sign) return -res;
	return res;
}

#endif // USE_FLOAT		// use float support


#if USE_DOUBLE		// use double support
// convert ASCIIZ text to DOUBLE number
double StrToDouble(const char* text)
{
	// get sign and skip spaces
	char ch;
	Bool sign = False;
	for (;;)
	{
		// load next character
		ch = *text++;
		if (ch == 0) return 0;

		// negative sign
		if (ch == '-')
			sign = !sign;
		else
			// skip positive sign or whitespace
			if ((ch != '+') && ((ch > ' ') || (ch < 0))) break;
	}

	// load digits of integer part
	double res = 0;
	while ((ch >= '0') && (ch <= '9'))
	{
		res *= 10;
		res += ch - '0';

		// load next character
		ch = *text++;
		if (ch == 0)
		{
			text--;
			break;
		}
	}

	// load digits of fractional part
	double frac = 1;
	if ((ch == '.') || (ch == ','))
	{
		// load next character
		ch = *text;
		if (ch != 0)
		{
			text++;

			while ((ch >= '0') && (ch <= '9'))
			{
				frac *= 10;
				res += (ch - '0')/frac;

				// load next character
				ch = *text++;
				if (ch == 0)
				{
					text--;
					break;
				}
			}
		}
	}

	// check exponent
	int expN = 0;
	Bool signE = False;
	if ((ch == 'E') || (ch == 'e'))
	{
		// get sign and skip spaces
		for (;;)
		{
			// load next character
			ch = *text++;
			if (ch == 0)
			{
				text--;
				break;
			}

			if (ch == '-')
				signE = !signE;
			else
				if (ch != '+') break;
		}

		// load exponent digits
		while ((ch >= '0') && (ch <= '9'))
		{
			expN *= 10;
			expN += ch - '0';

			// load next character
			ch = *text++;
			if (ch == 0)
			{
				text--;
				break;
			}
		}

		// multiply number by exponent
		if (expN != 0)
		{
			if (signE)
			{
				if (expN >= 256) { res *= 1e-256; expN -= 256; };
				if (expN >= 128) { res *= 1e-128; expN -= 128; };
				if (expN >=  64) { res *=  1e-64; expN -=  64; };
				if (expN >=  32) { res *=  1e-32; expN -=  32; };
				if (expN >=  16) { res *=  1e-16; expN -=  16; };
				if (expN >=   8) { res *=   1e-8; expN -=   8; };
				if (expN >=   4) { res *=   1e-4; expN -=   4; };
				if (expN >=   2) { res *=   1e-2; expN -=   2; };
				if (expN >=   1) { res *=   1e-1;              };
			}
			else
			{
				if (expN >= 256) { res *= 1e256; expN -= 256; };
				if (expN >= 128) { res *= 1e128; expN -= 128; };
				if (expN >=  64) { res *=  1e64; expN -=  64; };
				if (expN >=  32) { res *=  1e32; expN -=  32; };
				if (expN >=  16) { res *=  1e16; expN -=  16; };
				if (expN >=   8) { res *=   1e8; expN -=   8; };
				if (expN >=   4) { res *=   1e4; expN -=   4; };
				if (expN >=   2) { res *=   1e2; expN -=   2; };
				if (expN >=   1) { res *=   1e1;              };
			}
		}
	}

	// result with sign
	if (sign) return -res;
	return res;
}
#endif // USE_DOUBLE		// use double support

#endif // USE_TEXT	// use Text strings, except StrLen and StrComp (lib_text.c, lib_text.h)

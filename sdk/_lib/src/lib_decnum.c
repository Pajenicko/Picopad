
// ****************************************************************************
//
//                              Decode number
//
// ****************************************************************************

#include "../../global.h"	// globals

#if USE_DECNUM		// use DecNum (decnum.c, decnum.h)

#include "../inc/lib_decnum.h"

// temporary decode text buffer
char DecNumBuf[DECNUMBUF_SIZE];

// decode unsigned number into ASCIIZ text buffer (returns number of digits)
//  sep = thousand separator, 0=none
int DecUNum(char* buf, u32 num, char sep)
{
	// temporary buffer (max. 10 digits + 3 separators + 1 NUL)
	char b[14];

	// decode number
	char* d = &b[13];
	*d = 0;
	int n = 0;
	u32 k;
	int sepn = 0;
	do {
		// thousand separator
		if ((sepn == 3) && (sep != 0))
		{
			sepn = 0;
			d--;
			*d = sep;
			n++;
		}

		k = num / 10;
		num -= k*10;
		d--;
		*d = (char)(num + '0');
		num = k;
		n++;
		sepn++;
	} while (num != 0);

	// copy number to destination buffer
	memcpy(buf, d, n+1);
	return n;
}

// decode signed number into ASCIIZ text buffer (returns number of digits)
//  sep = thousand separator, 0=none
int DecNum(char* buf, s32 num, char sep)
{
	if (num >= 0) return DecUNum(buf, num, sep);

	num = -num;
	*buf++ = '-';
	return DecUNum(buf, num, sep) + 1;
}

// decode hex number (dig = number of digits)
void DecHexNum(char* buf, u32 num, u8 dig)
{
	buf += dig;
	*buf = 0;
	u8 ch;

	for (; dig > 0; dig--)
	{
		buf--;
		ch = (num & 0x0f) + '0';
		if (ch > '9') ch += 'A' - ('9'+1);
		*buf = ch;
		num >>= 4;
	}
}

// decode 2 digits of number
void Dec2Dig(char* buf, u8 num)
{
	u8 n = num/10;
	*buf++ = (char)(n + '0');
	num -= n*10;
	*buf++ = (char)(num + '0');
	*buf = 0;
}

// decode 2 digits of number with space character
void Dec2DigSpc(char* buf, u8 num)
{
	u8 n = num/10;
	if (n == 0)
		*buf++ = ' ';
	else
		*buf++ = (char)(n + '0');
	num -= n*10;
	*buf++ = (char)(num + '0');
	*buf = 0;
}

#endif // USE_DECNUM		// use DecNum (decnum.c, decnum.h)

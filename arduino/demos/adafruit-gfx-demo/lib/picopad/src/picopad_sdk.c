// Interface and part of the code taken from PicoLibSDK:
//
// PicoLibSDK - Alternative SDK library for Raspberry Pico and RP2040
// Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz, hardyplotter2@gmail.com
// 	https://github.com/Panda381/PicoLibSDK
//	https://www.breatharian.eu/hw/picolibsdk/index_en.html
//	https://github.com/pajenicko/picopad
//	https://picopad.eu/en/

#include "picopad.h"

const u8 OrdBitsTab[16] = { 0, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4 };

// do single conversion with denoise (returns value 0..0xffff; takes 32 us on 48 MHz clock
u16 ADC_SingleDenoise()
{
	int i;
	u16 t = 0;
	for (i = 16; i > 0; i--) t += ADC_Single();
	return t;
}

// do single conversion and recalculate to voltage on 3.3V
float ADC_SingleU()
{
	return ADC_SingleDenoise() * 3.3f / (4096*16);
}

// do single conversion and recalculate to voltage on 3.3V, integer in mV (range 0..3300)
int ADC_SingleUint()
{
	return ADC_SingleDenoise() * 3300 / (4096*16);
}

void ADC_Disable() {
	adc_hw->cs = 0;
}

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
int DecNum(char *buf, s32 num, char sep) {
	if (num >= 0) return DecUNum(buf, num, sep);

	num = -num;
	*buf++ = '-';
	return DecUNum(buf, num, sep) + 1;
}

// get bit order of value (logarithm, returns position of highest bit + 1: 1..32, 0=no bit)
u8 Order(u32 val)
{
	int i = 0;
	if (val >= 0x10000)
	{
		i = 16;
		val >>= 16;
	}

	if (val >= 0x100)
	{
		i += 8;
		val >>= 8;
	}

	if (val >= 0x10)
	{
		i += 4;
		val >>= 4;
	}
	return OrdBitsTab[val] + i;
}
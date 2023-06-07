
// ****************************************************************************
//
//                            ROSC ring oscillator
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_ROSC	// use ROSC ring oscillator (sdk_rosc.c, sdk_rosc.h)

#include "../inc/sdk_rosc.h"

// Current ROSC frequency level set by the RoscSetLevel function
u8 RoscLevel = 0;

// ROSC frequency level table (bit 15: range bit 0, bit 31: range bit 1)
#define RFT_LOW		0		// 0xFA4 = 0xFA4+0, low frequency, 8 stages (0..7)
#define RFT_MEDIUM	B15		// 0xFA5 = 0xFA4+1, medium frequency, 6 stages (2..7)
#define RFT_HIGH	(B15+B31)	// 0xFA7 = 0xFA4+3, high frequency, 4 stages (4..7)
#define RFT_TOOHIGH	B31		// 0xFA6 = 0xFA4+2, too high frequency, 2 stages (6..7)
#define RFT0(stages)	(0x11111111UL<<(32-stages*4))	// bit 0
#define RFT1(stages)	(0x22222222UL<<(32-stages*4))	// bit 1
#define RFT2(stages)	(0x44444444UL<<(32-stages*4))	// bit 2

const u32 RoscLevelTab[ROSC_FREQ_NUM] = {

// --- low frequency, 8 stages (0..7)

	// 0 bits
	RFT_LOW, // 0 (81 MHz)

	// 1 bit
	RFT_LOW+RFT0(1), // 1 (84 MHz)
	RFT_LOW+RFT0(2), // 2 (88 MHz)
	RFT_LOW+RFT0(3), // 3 (92 MHz)
	RFT_LOW+RFT0(4), // 4 (97 MHz)
	RFT_LOW+RFT0(5), // 5 (100 MHz)
	RFT_LOW+RFT0(6), // 6 (106 MHz)
	RFT_LOW+RFT0(7), // 7 (113 MHz)
	RFT_LOW+RFT0(8), // 8 (116 MHz)

	// 2 bits
	RFT_LOW+RFT0(8)+RFT1(1), // 9 (118 MHz)
	RFT_LOW+RFT0(8)+RFT1(2), // 10 (121 MHz)
	RFT_LOW+RFT0(8)+RFT1(3), // 11 (123 MHz)
	RFT_LOW+RFT0(8)+RFT1(4), // 12 (126 MHz)
	RFT_LOW+RFT0(8)+RFT1(5), // 13 (128 MHz)
	RFT_LOW+RFT0(8)+RFT1(6), // 14 (131 MHz)
	RFT_LOW+RFT0(8)+RFT1(7), // 15 (134 MHz)
	RFT_LOW+RFT0(8)+RFT1(8), // 16 (136 MHz)

	// 3 bits
	RFT_LOW+RFT0(8)+RFT1(8)+RFT2(1), // 17 (137 MHz)
	RFT_LOW+RFT0(8)+RFT1(8)+RFT2(2), // 18 (139 MHz)
	RFT_LOW+RFT0(8)+RFT1(8)+RFT2(3), // 19 (141 MHz)
	RFT_LOW+RFT0(8)+RFT1(8)+RFT2(4), // 20 (143 MHz)
	RFT_LOW+RFT0(8)+RFT1(8)+RFT2(5), // 21 (145 MHz)
	RFT_LOW+RFT0(8)+RFT1(8)+RFT2(6), // 22 (147 MHz)
	RFT_LOW+RFT0(8)+RFT1(8)+RFT2(7), // 23 (149 MHz)
	RFT_LOW+RFT0(8)+RFT1(8)+RFT2(8), // 24 (150 MHz)

// --- medium frequency, 6 stages (2..7)

	// 0 bits
	RFT_MEDIUM, // 25 (101 MHz)

	// 1 bit
	RFT_MEDIUM+RFT0(1), // 26 (105 MHz)
	RFT_MEDIUM+RFT0(2), // 27 (112 MHz)
	RFT_MEDIUM+RFT0(3), // 28 (118 MHz)
	RFT_MEDIUM+RFT0(4), // 29 (126 MHz)
	RFT_MEDIUM+RFT0(5), // 30 (132 MHz)
	RFT_MEDIUM+RFT0(6), // 31 (143 MHz)

	// 2 bits
	RFT_MEDIUM+RFT0(6)+RFT1(1), // 32 (145 MHz)
	RFT_MEDIUM+RFT0(6)+RFT1(2), // 33 (149 MHz)
	RFT_MEDIUM+RFT0(6)+RFT1(3), // 34 (153 MHz)
	RFT_MEDIUM+RFT0(6)+RFT1(4), // 35 (158 MHz)
	RFT_MEDIUM+RFT0(6)+RFT1(5), // 36 (161 MHz)
	RFT_MEDIUM+RFT0(6)+RFT1(6), // 37 (166 MHz)

	// 3 bits
	RFT_MEDIUM+RFT0(6)+RFT1(6)+RFT2(1), // 38 (167 MHz)
	RFT_MEDIUM+RFT0(6)+RFT1(6)+RFT2(2), // 39 (170 MHz)
	RFT_MEDIUM+RFT0(6)+RFT1(6)+RFT2(3), // 40 (173 MHz)
	RFT_MEDIUM+RFT0(6)+RFT1(6)+RFT2(4), // 41 (176 MHz)
	RFT_MEDIUM+RFT0(6)+RFT1(6)+RFT2(5), // 42 (178 MHz)
	RFT_MEDIUM+RFT0(6)+RFT1(6)+RFT2(6), // 43 (181 MHz)

// --- high frequency, 4 stages (4..7)

	// 0 bits
	RFT_HIGH, // 44 (136 MHz)

	// 1 bit
	RFT_HIGH+RFT0(1), // 45 (143 MHz)
	RFT_HIGH+RFT0(2), // 46 (156 MHz)
	RFT_HIGH+RFT0(3), // 47 (167 MHz)
	RFT_HIGH+RFT0(4), // 48 (187 MHz)

	// 2 bits
	RFT_HIGH+RFT0(4)+RFT1(1), // 49 (190 MHz)
	RFT_HIGH+RFT0(4)+RFT1(2), // 50 (198 MHz)
	RFT_HIGH+RFT0(4)+RFT1(3), // 51 (204 MHz)
	RFT_HIGH+RFT0(4)+RFT1(4), // 52 (213 MHz)

	// 3 bits
	RFT_HIGH+RFT0(4)+RFT1(4)+RFT2(1), // 53 (216 MHz)
	RFT_HIGH+RFT0(4)+RFT1(4)+RFT2(2), // 54 (221 MHz)
	RFT_HIGH+RFT0(4)+RFT1(4)+RFT2(3), // 55 (225 MHz)
	RFT_HIGH+RFT0(4)+RFT1(4)+RFT2(4), // 56 (232 MHz)

// --- too high frequency, 2 stages (6..7)

	// 0 bits
	RFT_TOOHIGH, // 57 (217 MHz)

// Note: Oscillator instability was observed when only 2 active stages were boosted.
// By boosting the next 3rd stage as well, the stability increased.

	// 1 bit
	RFT_TOOHIGH+RFT0(1), // 58 (237 MHz)
	RFT_TOOHIGH+RFT0(3), // 59 (278 MHz)

	// 2 bits
	RFT_TOOHIGH+RFT0(3)+RFT1(1), // 60 (286 MHz)
	RFT_TOOHIGH+RFT0(3)+RFT1(3), // 61 (305 MHz)

	// 3 bits
	RFT_TOOHIGH+RFT0(3)+RFT1(3)+RFT2(1), // 62 (310 MHz)
	RFT_TOOHIGH+RFT0(3)+RFT1(3)+RFT2(3), // 63 (321 MHz)
};

#define ROSCFREQTAB_MIN	79	// minimal frequency in the table

// ROSC typical frequencies of the levels
const u8 RoscFreqTab[ROSC_FREQ_NUM] = {

// --- low frequency, 8 stages (0..7)

	81, // 0
	84, 88, 92, 97, 100, 106, 113, 116, // 1..8
	118, 121, 123, 126, 128, 131, 134, 136, // 9..16
	137, 139, 141, 143, 145, 147, 149, 150, // 17..24

// --- medium frequency, 6 stages (2..7)

	101, // 25
	105, 112, 118, 126, 132, 143, // 26..31
	145, 149, 153, 158, 161, 166, // 32..37
	167, 170, 173, 176, 178, 181, // 38..43

// --- high frequency, 4 stages (4..7)

	136, // 44
	143, 156, 167, 187, // 45..48
	190, 198, 204, 213, // 49..52
	216, 221, 225, 232, // 53..56

// --- too high frequency, 2 stages (6..7)

	217, // 57
	237, 255, // 58..59
	255, 255, // 60..61
	255, 255, // 62..63
};

// set ring oscillator frequency level (level is in range 0..63, 0..ROSC_FREQ_NUM-1; 0 is default level)
//  Typical frequency ranges:
//    level 0..24, low frequency range (8 stages), 81..150 MHz
//    level 25..43, medium frequency range (6 stages), 101..181 MHz
//    level 44..56, high frequency range (4 stages), 136..232 MHz
//    level 57..63, too high frequency range (2 stages), 217..321 MHz
// Currently set frequency level can be read from the RoscLevel variable.
void RoscSetLevel(u8 level)
{
	// save current level
	RoscLevel = level;

	// get word from setup table
	u32 k = RoscLevelTab[level];

	// prepare frequency range (= number of delay invertor stages)
	u32 range = 0xFA4;
	if ((k & B15) != 0) range += 1;
	if ((k & B31) != 0) range += 2;
	k &= 0x77777777; // clear range bits

	// set ROSC registers
	RegMask(ROSC_CTRL, range, 0xFFF); // set frequency range (number of delay stages)
	*ROSC_FREQA = (k & 0xFFFF) | 0x96960000; // set drive strength of stages 0..3
	*ROSC_FREQB = (k >> 16) | 0x96960000; // set drive strength of stages 4..7
}

// get ROSC divider 1..32
u8 RoscGetDiv()
{
	u8 div = *ROSC_DIV & 0x1F;
	if (div == 0) div = 32;
	return div;
}

// initialize ROSC ring oscillator to its default state (typical frequency 6 MHz)
void RoscInit()
{
	// set frequency range to LOW
	RegMask(ROSC_CTRL, 0xFA4, 0xFFF);

	// set drive strength of stages to LOW
	*ROSC_FREQA = 0x96960000; // set drive strength of stages 0..3
	*ROSC_FREQB = 0x96960000; // set drive strength of stages 4..7

	// set divider to 16
	RoscSetDiv(16);

	// Enable ring oscillator
	RoscEnable();

	// update current frequency
	CurrentFreq[CLK_ROSC] = ROSC_MHZ*MHZ; // default ROSC ring oscillator is 6 MHz

	// wait for stable state of the ring oscillator
	RoscWait();
}

// select ring oscillator frequency in range 2.5 .. 255 MHz (input value freq10 means required frequency * 10)
//  Selected frequency is very approximate, it can vary from 50% to 200%. 
//  The main usage of the function is in conjunction with the XOSC oscillator
//    so that frequency can be continuously changed during calibration.
//  Function takes 2 to 10 us.
void RoscSetFreq(int freq10)
{
	// limit range
	if (freq10 < 25) freq10 = 25;
	if (freq10 > 2550) freq10 = 2550;

	// prepare divider (divider of power-of-2 is preferred, levels can reach smoother steps)
	int div = 1;
	int freq;
	for (;;)
	{
		freq = (freq10 * div) / 10;
		if (freq >= ROSCFREQTAB_MIN) break;
		div <<= 1;
	}

	// search best frequency
	u8 f = (u8)freq; // f is in range ROSCFREQTAB_MIN..255
	int level;
	for (level = 0; level < ROSC_FREQ_NUM-1; level++)
	{
		if ((f <= (u8)((RoscFreqTab[level] + RoscFreqTab[level+1])/2)) ||
			(f <= RoscFreqTab[level]+1)) break;
	}

	// get old divider
	int olddiv = RoscGetDiv();

	// set level and divider (order is important so that the high frequency is not exceeded)
	if (div >= olddiv) // divider is increased
	{
		RoscSetDiv(div); // set divider
		RoscSetLevel(level); // set frequency level
	}
	else // divider is decreased
	{
		RoscSetLevel(level); // set frequency level
		RoscSetDiv(div); // set divider
	}

	// wait for stable state of the ring oscillator (ROSC must be enabled)
	RoscWait();
}

// get random data from the ring oscillator
//  Random data from the ring generator cannot be used as a random generator because
//  generated randomness is very uneven. However, it is an excellent source for the
//  initial seed of another random generator because its state is unpredictable.
u8 RoscRand8()
{
	int i;
	u8 k;
	for (i = 8; i > 0; i--) k = (k << 1) | RoscRandBit();
	return k;
}

u16 RoscRand16()
{
	int i;
	u16 k;
	for (i = 16; i > 0; i--) k = (k << 1) | RoscRandBit();
	return k;
}

u32 RoscRand32()
{
	int i;
	u32 k;
	for (i = 32; i > 0; i--) k = (k << 1) | RoscRandBit();
	return k;
}

#endif // USE_ROSC	// use ROSC ring oscillator (sdk_rosc.c, sdk_rosc.h)

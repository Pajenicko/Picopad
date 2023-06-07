
// ****************************************************************************
//
//                               Clocks
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals
#include "../inc/sdk_clocks.h"
#include "../inc/sdk_rosc.h"
#include "../inc/sdk_xosc.h"
#include "../inc/sdk_pll.h"
#include "../inc/sdk_watchdog.h"

// current clock frequency in Hz (clock lines and clock generators)
u32 CurrentFreq[CLK_SRC_NUM];

// current clock source of clock lines
u8 CurrentClkSrc[CLK_NUM];

// convert clock source index to internal source index (-1 unsupported, B6=glitchless)
const s8 ClockSourceTab[5*12] = {
// src:	REF	SYS	PERI	USB	ADC	RTC	ROSC	XOSC	PLLSYS	PLLUSB	GPIN0	GPIN1

// CLK_GPOUT0..CLK_GPOUT1 clock line
	10,	6,	-1,	7,	8,	9,	4,	5,	0,	3,	1,	2,

// CLK_REF clock line
	-1,	-1,	-1,	-1,	-1,	-1,	0+B6,	2+B6,	-1,	0,	1,	2,

// CLK_SYS clock line
	0+B6,	-1,	-1,	-1,	-1,	-1,	2,	3,	0,	1,	4,	5,

// CLK_PERI clock line
	-1,	0,	-1,	-1,	-1,	-1,	3,	4,	1,	2,	5,	6,

// CLK_USB, CLK_ADC, CLK_RTC clock line
	-1,	-1,	-1,	-1,	-1,	-1,	2,	3,	1,	0,	4,	5,
};

// convert clock line to frequency counter internal index
const u8 ClockFreqTab[] = {
	8,	// CLK_REF
	9,	// CLK_SYS
	10,	// CLK_PERI
	11,	// CLK_USB
	12,	// CLK_ADC
	13,	// CLK_RTC
	3,	// CLK_ROSC
	5,	// CLK_XOSC
	1,	// CLK_PLL_SYS
	2,	// CLK_PLL_USB
	6,	// CLK_GPIN0
	7,	// CLK_GPIN1
};

// clock source names
const char* ClockName[CLK_SRC_NUM] = {
	"GPOUT0", "GPOUT1", "GPOUT2", "GPOUT3", "REF", "SYS", "PERI", "USB",
	"ADC", "RTC", "ROSC", "XOSC", "PLL_SYS", "PLL_USB", "GPIN0", "GPIN1" };

// stop clock CLK_* (cannot stop SYS and REF clocks)
void ClockStop(u8 clk)
{
	// clear ENABLE bit (SYS and REF does not have ENABLE bit, will not stop)
	RegClr(CLK_CTRL(clk), B11);

	// clear current frequency
	CurrentFreq[clk] = 0;
}

// setup clock line (returns new frequency in Hz or 0 on error)
//  clk ... clock line index CLK_GPOUT0..CLK_RTC
//  clksrc ... clock source CLK_REF..CLK_GPIN1 (see table which sources are supported)
//  freq ... required frequency in Hz, 0=use source frequency
//  freqsrc ... frequency in Hz of source, 0=get from table (must be freqsrc >= freq)
u32 ClockSetup(u8 clk, u8 clksrc, u32 freq, u32 freqsrc)
{
	if (clk >= CLK_NUM) return 0; // invalid clock line index

	// get frequency from table
	if (freqsrc == 0) freqsrc = CurrentFreq[clksrc];
	if (freq == 0) freq = freqsrc;
	if (freq > freqsrc) return 0; // invalid frequency

	// convert clock source to internal source index
	clksrc -= 4; // CLK_GPOUTn as clock source not supported
	if ((u8)clksrc >= CLK_SRC_NUM-4) return 0; // invalid clock source index

	int i = clk - 3; // CLK_GPOUT3 as base of table
	if (i < 0) i = 0; // CLK_GPOUT0..CLK_GPOUT3 as index 0
	if (i > CLK_USB-3) i = CLK_USB-3; // combine CLK_USB, CLK_ADC and CLK_RTC
	i = ClockSourceTab[i*(CLK_SRC_NUM-4) + clksrc]; // get internal source index
	if (i < 0) return 0; // invalid clock source

	// save current clock source
	CurrentClkSrc[clk] = clksrc + 4;

	// prepare source indices
	u8 aux = (i & 0x0f); // auxiliary mux index
	u8 src = 1; // glitchless mux source is auxiliary mux
	if ((i & B6) != 0) // clock source is glitchless mux
	{
		aux = 0; // not using auxiliary mux
		src = i & 3; // glitcless mux source
	}

	// prepare registers
	volatile u32* ctrl = CLK_CTRL(clk); // control
	volatile u32* div = CLK_DIV(clk); // divisor
	volatile u32* sel = CLK_SEL(clk); // selected

	// divider, including 8-bit fraction (so multiply result by 2^8)
	u32 d = (u32)((((u64)freqsrc << 8) + freq/2) / freq);

	// increasing divisor, so set divisor before source (to avoid overspeed)
	if (d > *div) *div = d;

	// If swithing glitchless clock (REF or SYS) to aux source,
	// switch away from aux to avoid glitches.
	if (GLITCHLESS_MUX(clk) && (src == 1))
	{
		RegClr(ctrl, B0|B1);	// switch to base source 0
		while((*sel & B0) == 0) {} // wait for switching to source 0
	}
	else
	{
		// stop clock, on REF and SYS clock it does nothing
		RegClr(ctrl, B11);

		// if clock is running, wait a while
		if (CurrentFreq[clk] > 0)
		{
			// wait 3 cycles of target clock to stop
			//  required number of loops = system_clock / current_clock + 1
			u32 delay = CurrentFreq[CLK_SYS] / CurrentFreq[clk] + 1;

			// delay in assembler
			__asm volatile (
				".syntax unified\n"
				"1:\n"
				"subs %0, #1\n"		// [1 clock]
				"bne 1b\n"		// [2 clocks]
				: "+r" (delay));
		}
	}

	// set aux mux
	RegMask(ctrl, (u32)aux << 5, 0xf << 5);

	// set glitchless mux
	if (GLITCHLESS_MUX(clk))
	{
		RegMask(ctrl, src, 3); // set src
		while((*sel & BIT(src)) == 0) {} // wait for switching to src
	}

	// set divisor after selecting mux
	*div = d;

	// start clock, on REF and SYS clock it does nothing
	RegSet(ctrl, B11);

	// store new current frequency in Hz
	freq = (u32)(((u64)freqsrc << 8) / d);
	CurrentFreq[clk] = freq;

	return freq;
}

// initialize clocks after start
void ClockInit()
{
	int i;

	// initialize frequency table
	for (i = 0; i < CLK_SRC_NUM; i++) CurrentFreq[i] = 0; // clear all frequencies

	// diable resus
	*CLK_RES_CTRL = 0;

	// enable ROSC ring oscillator
#if USE_ROSC	// use ROSC ring oscillator (sdk_rosc.c, sdk_rosc.h)
	RoscInit();
#else
	CurrentFreq[CLK_ROSC] = ROSC_MHZ*MHZ; // default ROSC ring oscillator is 6 MHz
#endif

	// enable XOSC crystal oscillator
#if USE_XOSC	// use XOSC crystal oscillator (sdk_xosc.c, sdk_xosc.h)
	XoscInit();
#else
	CurrentFreq[CLK_XOSC] = XOSC_MHZ*MHZ; // default XOR crystal oscillator is 12 MHz
#endif

	// start tick in watchdog
#if USE_WATCHDOG || USE_TIMER // use Watchdog or Timer
#if USE_XOSC	// use XOSC crystal oscillator (sdk_xosc.c, sdk_xosc.h)
	WatchdogStart(XOSC_MHZ);
#else
	WatchdogStart(ROSC_MHZ);
#endif
#endif

	// disable aux sources of SYS and REF, to enable changes of PLLs
	RegClr(CLK_CTRL(CLK_SYS), B0|B1);	// glitchless switch SYS to base source 0 (= CLK_REF)
	while((*CLK_SEL(CLK_SYS) & B0) == 0) {} // wait for switching to source 0
	RegClr(CLK_CTRL(CLK_REF), B0|B1);	// glitchless switch REF to base source 0 (= CLK_ROSC)
	while((*CLK_SEL(CLK_REF) & B0) == 0) {} // wait for switching to source 0

#if USE_PLL	// use PLL phase-locked loop (sdk_pll.c, sdk_pll.h)

	// set PLL_SYS to default 125 MHz
	PllSetFreq(PLL_SYS, PLL_KHZ);

	// set PLL_USB to default 48 MHz
	PllSetFreq(PLL_USB, 48000);

	// setup CLK_REF to XOSC
	ClockSetup(CLK_REF, CLK_XOSC, 0, 0);

	// setup CLK_SYS to PLL_SYS
	ClockSetup(CLK_SYS, CLK_PLL_SYS, 0, 0);

	// setup CLK_USB to PLL_USB
	ClockSetup(CLK_USB, CLK_PLL_USB, 0, 0);

	// setup CLK_ADC to PLL_USB
	ClockSetup(CLK_ADC, CLK_PLL_USB, 0, 0);

	// setup CLK_RTC to PLL_USB, 48MHz/1024 = 46875 Hz
	ClockSetup(CLK_RTC, CLK_PLL_USB, CurrentFreq[CLK_PLL_USB]/1024, 0);

	// setup CLK_PERI to PLL_USB
	ClockSetup(CLK_PERI, CLK_PLL_USB, 0, 0);

#elif USE_XOSC	// use XOSC crystal oscillator (sdk_xosc.c, sdk_xosc.h)

	// setup CLK_REF to XOSC
	ClockSetup(CLK_REF, CLK_XOSC, 0, 0);

	// setup CLK_SYS to XOSC
	ClockSetup(CLK_SYS, CLK_XOSC, 0, 0);

	// setup CLK_USB to XOSC
	ClockSetup(CLK_USB, CLK_XOSC, 0, 0);

	// setup CLK_ADC to XOSC
	ClockSetup(CLK_ADC, CLK_XOSC, 0, 0);

	// setup CLK_RTC to XOSC, 12MHz/256 = 46875 Hz
	ClockSetup(CLK_RTC, CLK_XOSC, CurrentFreq[CLK_XOSC]/256, 0);

	// setup CLK_PERI to XOSC
	ClockSetup(CLK_PERI, CLK_XOSC, 0, 0);


#else 	// else use ROSC ring oscillator

	// setup CLK_REF to ROSC
	ClockSetup(CLK_REF, CLK_ROSC, 0, 0);

	// setup CLK_SYS to ROSC
	ClockSetup(CLK_SYS, CLK_ROSC, 0, 0);

	// setup CLK_USB to ROSC
	ClockSetup(CLK_USB, CLK_ROSC, 0, 0);

	// setup CLK_ADC to ROSC
	ClockSetup(CLK_ADC, CLK_ROSC, 0, 0);

	// setup CLK_RTC to ROSC, 6MHz/128 = 46875 Hz
	ClockSetup(CLK_RTC, CLK_ROSC, CurrentFreq[CLK_ROSC]/128, 0);

	// setup CLK_PERI to ROSC
	ClockSetup(CLK_PERI, CLK_ROSC, 0, 0);

#endif

}

#if USE_PLL	// use PLL phase-locked loop (sdk_pll.c, sdk_pll.h)

// set system clock PLL to new setup (dependent clocks are not updated)
//   fbdiv ... feedback divisor, 16..320
//   div1 ... post divider 1, 1..7
//   div2 ... post divider 2, 1..7 (should be div1 >= div2, but auto-corrected)
void ClockPllSysSetup(int fbdiv, u8 div1, u8 div2)
{
	// temporary reconnect CLK_SYS to PLL_USB
	ClockSetup(CLK_SYS, CLK_PLL_USB, 0, 0);

	// setup PLL generator
	PllSetup(PLL_SYS, 1, fbdiv, div1, div2);

	// reconnect CLK_SYS back to PLL_SYS
	ClockSetup(CLK_SYS, CLK_PLL_SYS, 0, 0);
}

// set system clock PLL to new frequency in kHz (dependent clocks are not updated)
void ClockPllSysFreq(u32 freq)
{
	// temporary reconnect CLK_SYS to PLL_USB
	ClockSetup(CLK_SYS, CLK_PLL_USB, 0, 0);

	// setup PLL generator
	PllSetFreq(PLL_SYS, freq);

	// reconnect CLK_SYS back to PLL_SYS
	ClockSetup(CLK_SYS, CLK_PLL_SYS, 0, 0);
}

#endif // USE_PLL	// use PLL phase-locked loop (sdk_pll.c, sdk_pll.h)

// precise measure frequency of clock CLK_REF..CLK_GPIN1 with result in Hz (returns 0 on error)
//  - measure interval: 128 ms, accuracy +-15 Hz
u32 FreqCount(u8 clk)
{
	// convert to internal clock index
	clk -= 4;
	if (clk >= CLK_SRC_NUM-4) return 0;
	clk = ClockFreqTab[clk];

	// set reference frequency in kHz * 4 (frequency counter is clocked by CLK_REF reference clock)
	*CLK_FC0_REF = CurrentFreq[CLK_REF]/250; // 20 bits, max. 1'048'575 kHz

	// set limits (25 bits, max. 33'554'431 kHz)
	*CLK_FC0_MIN = 0;
	*CLK_FC0_MAX = 0x1ffffff;

	// initial delay in number of reference clock periods
	*CLK_FC0_DELAY = 3;

	// length of test interval (0..15 gives interval 2^0..2^15 reference ticks = 1 us ... 32 ms)
	*CLK_FC0_INTERVAL = 15;

	// select source clock and start measurement
	*CLK_FC0_SRC = clk;

	// wait to end of measurement
	while ((*CLK_FC0_STATUS & B4) == 0) {} // check DONE flag

	// get result in kHz
	u32 freq = (*CLK_FC0_RESULT * 125 + 4) >> 4;

	// stop frequency counter
	*CLK_FC0_SRC = 0;

	return freq;
}

// fast measure frequency of clock CLK_REF..CLK_GPIN1 with result in kHz (returns 0 on error)
//  - measure interval: 2 ms, accuracy +-1 kHz
u32 FreqCountkHz(u8 clk)
{
	// convert to internal clock index
	clk -= 4;
	if (clk >= CLK_SRC_NUM-4) return 0;
	clk = ClockFreqTab[clk];

	// set reference frequency in kHz * 4 (frequency counter is clocked by CLK_REF reference clock)
	*CLK_FC0_REF = CurrentFreq[CLK_REF]/1000; // 20 bits, max. 1'048'575 kHz

	// set limits (25 bits, max. 33'554'431 kHz)
	*CLK_FC0_MIN = 0;
	*CLK_FC0_MAX = 0x1ffffff;

	// initial delay in number of reference clock periods
	*CLK_FC0_DELAY = 3;

	// length of test interval (0..15 gives interval 2^0..2^15 reference ticks = 1 us ... 32 ms)
	*CLK_FC0_INTERVAL = 11;

	// select source clock and start measurement
	*CLK_FC0_SRC = clk;

	// wait to end of measurement
	while ((*CLK_FC0_STATUS & B4) == 0) {} // check DONE flag

	// get result in kHz
	u32 freq = (*CLK_FC0_RESULT + 4) >> 5;

	// stop frequency counter
	*CLK_FC0_SRC = 0;

	return freq;
}

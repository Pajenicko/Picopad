
// ****************************************************************************
//
//                               Clocks
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// (RP2040 datasheet page 199)

#ifndef _SDK_CLOCKS_H
#define _SDK_CLOCKS_H

#include "../sdk_addressmap.h"		// Register address offsets

#ifdef __cplusplus
extern "C" {
#endif

// clock lines
#define CLK_GPOUT0	0	// GPIO muxing output GPOUT0 (max. 50 MHz)
#define CLK_GPOUT1	1	// GPIO muxing output GPOUT1 (max. 50 MHz)
#define CLK_GPOUT2	2	// GPIO muxing output GPOUT2 (max. 50 MHz)
#define CLK_GPOUT3	3	// GPIO muxing output GPOUT3 (max. 50 MHz)
#define CLK_REF		4	// watchdog and timers reference clock (6..12 Mhz) ... has glitchless mux
#define CLK_SYS		5	// system clock to processors, bus fabric, memory,
				//      memory mapped registers (125 MHz, up to 133 MHz) ... has glitchless mux
#define CLK_PERI	6	// peripheral clock for UART and SPI (12..125 MHz)
#define CLK_USB		7	// USB clock (must be 48 MHz)
#define CLK_ADC		8	// ADC clock (must be 48 MHz)
#define CLK_RTC		9	// RTC real-time counter clock (46875 Hz)

#define CLK_NUM		10	// number of clock lines

// clock generators
#define CLK_ROSC	10	// ring oscillator ROSC (6 MHz)
#define CLK_XOSC	11	// crystal oscillator XOSC (12 MHz)
#define CLK_PLL_SYS	12	// system PLL (125 MHz)
#define CLK_PLL_USB	13	// USB PLL (48 MHz)
#define CLK_GPIN0	14	// GPIO muxing input GPIN0
#define CLK_GPIN1	15	// GPIO muxing input GPIN1

#define CLK_SRC_NUM	16	// number of clock sources

/* supported clock source of clock lines GPOUT..RTC (x=auxiliary mux, o=glitchless mux, !=default mux)
              GPOUT  REF  SYS  PERI  USB  ADC  RTC
CLK_GPOUT0      .     .    .     .    .    .    .
CLK_GPOUT1      .     .    .     .    .    .    .
CLK_GPOUT2      .     .    .     .    .    .    .
CLK_GPOUT3      .     .    .     .    .    .    .
CLK_REF	        x     .    o!    .    .    .    .
CLK_SYS         x     .    .     x!   .    .    .
CLK_PERI        .     .    .     .    .    .    .
CLK_USB	        x     .    .     .    .    .    .
CLK_ADC	        x     .    .     .    .    .    .
CLK_RTC	        x     .    .     .    .    .    .
CLK_ROSC        x     o!   x     x    x    x    x
CLK_XOSC        x     o    x     x    x    x    x
CLK_PLL_SYS     x!    .    x     x    x    x    x
CLK_PLL_USB     x     x    x     x    x!   x!   x!
CLK_GPIN0       x     x    x     x    x    x    x
CLK_GPIN1       x     x    x     x    x    x    x
*/

// clock line setup registers
//#define CLOCKS_BASE		0x40008000	// clocks
#define CLK(clk)		(CLOCKS_BASE + (clk)*12)	// clock base
#define CLK_CTRL(clk)		((volatile u32*)(CLK(clk)+0)) // control
#define CLK_DIV(clk)		((volatile u32*)(CLK(clk)+4)) // divisor
#define CLK_SEL(clk)		((volatile u32*)(CLK(clk)+8)) // bits of selected glitchless source src

// resus registers
#define CLK_RES_CTRL		((volatile u32*)(CLOCKS_BASE+0x78)) // resus CTRL
#define CLK_RES_STATUS		((volatile u32*)(CLOCKS_BASE+0x7C)) // resus status

// frequency counter
#define CLK_FC0_REF		((volatile u32*)(CLOCKS_BASE+0x80)) // reference clock frequency in kHz
#define CLK_FC0_MIN		((volatile u32*)(CLOCKS_BASE+0x84)) // minimum pass frequency in kHz
#define CLK_FC0_MAX		((volatile u32*)(CLOCKS_BASE+0x88)) // maximum pass frequency in kHz
#define CLK_FC0_DELAY		((volatile u32*)(CLOCKS_BASE+0x8C)) // delay start of frequency counting
#define CLK_FC0_INTERVAL	((volatile u32*)(CLOCKS_BASE+0x90)) // text interval
#define CLK_FC0_SRC		((volatile u32*)(CLOCKS_BASE+0x94)) // clock sent to frequency counter
#define CLK_FC0_STATUS		((volatile u32*)(CLOCKS_BASE+0x98)) // status of frequency counter
#define CLK_FC0_RESULT		((volatile u32*)(CLOCKS_BASE+0x9C)) // result of frequency measurement

// sleep state
#define CLK_WAKE_EN0		((volatile u32*)(CLOCKS_BASE+0xA0)) // enable clock in wake mode
#define CLK_WAKE_EN1		((volatile u32*)(CLOCKS_BASE+0xA4)) // enable clock in wake mode
#define CLK_SLEEP_EN0		((volatile u32*)(CLOCKS_BASE+0xA8)) // enable clock in sleep mode
#define CLK_SLEEP_EN1		((volatile u32*)(CLOCKS_BASE+0xAC)) // enable clock in sleep mode
#define CLK_ENABLED0		((volatile u32*)(CLOCKS_BASE+0xB0)) // state of clock enable
#define CLK_ENABLED1		((volatile u32*)(CLOCKS_BASE+0xB4)) // state of clock enable

// resus interrupts
#define CLK_INTR		((volatile u32*)(CLOCKS_BASE+0xB8)) // raw interrupts of resus
#define CLK_INTE		((volatile u32*)(CLOCKS_BASE+0xBC)) // interrupt enable of resus
#define CLK_INTF		((volatile u32*)(CLOCKS_BASE+0xC0)) // interrupt force of resus
#define CLK_INTS		((volatile u32*)(CLOCKS_BASE+0xC4)) // interrupt status of resus

// check if clock has glitchless mux
#define GLITCHLESS_MUX(clk) (((clk) == CLK_SYS) || ((clk) == CLK_REF))

// current clock frequency in Hz (clock lines and clock generators)
extern u32 CurrentFreq[CLK_SRC_NUM];
INLINE u32 ClockGetHz(u8 clk) { return CurrentFreq[clk]; }

// current clock source of clock lines
extern u8 CurrentClkSrc[CLK_NUM];

// clock source names
extern const char* ClockName[CLK_SRC_NUM];

// stop clock CLK_* (cannot stop SYS and REF clocks)
void ClockStop(u8 clk);

// setup clock line (returns new frequency in Hz or 0 on error)
//  clk ... clock line index CLK_GPOUT0..CLK_RTC
//  clksrc ... clock source CLK_REF..CLK_GPIN1 (see table which sources are supported)
//  freq ... required frequency in Hz, 0=use source frequency
//  freqsrc ... frequency in Hz of source, 0=get from table (must be freqsrc >= freq)
u32 ClockSetup(u8 clk, u8 clksrc, u32 freq, u32 freqsrc);

// initialize clocks after start
void ClockInit();

#if USE_PLL	// use PLL phase-locked loop (sdk_pll.c, sdk_pll.h)

// set system clock PLL to new setup (dependent clocks are not updated)
//   fbdiv ... feedback divisor, 16..320
//   div1 ... post divider 1, 1..7
//   div2 ... post divider 2, 1..7 (should be div1 >= div2, but auto-corrected)
void ClockPllSysSetup(int fbdiv, u8 div1, u8 div2);

// set system clock PLL to new frequency in kHz (dependent clocks are not updated)
void ClockPllSysFreq(u32 freq);

#endif // USE_PLL	// use PLL phase-locked loop (sdk_pll.c, sdk_pll.h)

// precise measure frequency of clock CLK_REF..CLK_GPIN1 with result in Hz
//  - measure interval: 128 ms, accuracy +-15 Hz
u32 FreqCount(u8 clk);

// fast measure frequency of clock CLK_REF..CLK_GPIN1 with result in kHz
//  - measure interval: 2 ms, accuracy +-1 kHz
u32 FreqCountkHz(u8 clk);

#ifdef __cplusplus
}
#endif

#endif // _SDK_CLOCKS_H

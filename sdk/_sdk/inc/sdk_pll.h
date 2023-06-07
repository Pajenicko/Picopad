
// ****************************************************************************
//
//                            PLL phase-locked loop
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// (RP2040 datasheet page 245)

// In config_def.h:
// #define XOSC_MHZ	12	// crystal oscillator frequency in MHz (must be in range 1..15 MHz)

#if USE_PLL	// use PLL phase-locked loop (sdk_pll.c, sdk_pll.h)

#ifndef _SDK_PLL_H
#define _SDK_PLL_H

//#include "resource.h"		// Resources (get frequency XOSC_MHZ 12)
#include "../sdk_addressmap.h"		// Register address offsets

#ifdef __cplusplus
extern "C" {
#endif

#define PLL_SYS		0	// system PLL (generate system clock, default 125 MHz, max. 133 MHz)
#define PLL_USB		1	// USB PLL (generate 48 MHz USB reference clock)

//#define PLL_SYS_BASE		0x40028000
//#define PLL_USB_BASE		0x4002c000
#define PLL(pll)	(PLL_SYS_BASE + (pll)*0x4000)	// PLL base

#define PLL_CS(pll)	((volatile u32*)(PLL(pll)+0x00)) // control and status
#define PLL_PWR(pll)	((volatile u32*)(PLL(pll)+0x04)) // power control
#define PLL_DIV(pll)	((volatile u32*)(PLL(pll)+0x08)) // feedback divisor (0..4095, but should be 16..320)
#define PLL_PRIM(pll)	((volatile u32*)(PLL(pll)+0x0C)) // post dividers (they should be 1..7)

// ranges
#define PLL_VCO_MIN	400		// VCO min. frequency in MHz
#define PLL_VCO_MAX	1600		// VCO max. frequency in MHz
#define PLL_FBDIV_MIN	16		// min. feedback divisor
#define PLL_FBDIV_MAX	320		// max. feedback divisor
#define PLL_DIV_MIN	1		// min. post divider
#define PLL_DIV_MAX	7		// max. post divider

// PLL output frequency:
//  freq = (XOSC_MHZ / REFDIV) * FBDIV / (DIV1 * DIV2)
//  - minimum reference frequency XOSC_MHZ / REFDIV is 5 MHz
//  - oscillator frequency VOSC = (XOSC_MHZ / REFDIV) * FBDIV must be in range 400 MHz .. 1600 MHz
//      High VCO frequency minimises jittering, low VCO frequency reduces power consumption.
//  - feedback divider FBDIV must be in range 16..320
//  - post dividers DIV1 and DIV2 must be in range 1..7

// get PLL refdiv divider (1..63)
INLINE u8 PllGetRefDiv(u8 pll) { return (u8)(*PLL_CS(pll) & 0x3f); }

// get PLL feedback divisor (16..320)
INLINE int PllGetFBDiv(u8 pll) { return *PLL_DIV(pll) & 0xfff; }

// get PLL post divider 1
INLINE u8 PllGetDiv1(u8 pll) { return (u8)((*PLL_PRIM(pll) >> 16) & 7); }

// get PLL post divider 2
INLINE u8 PllGetDiv2(u8 pll) { return (u8)((*PLL_PRIM(pll) >> 12) & 7); }

// get PLL VCO frequency in Hz
u32 PllGetVco(u8 pll);

// PLL setup (returns result frequency in Hz)
//   pll ... PLL select, PLL_SYS or PLL_USB
//   refdiv ... divide input reference clock, 1..63 (minimum reference frequency XOSC/refdiv is 5 MHz)
//   fbdiv ... feedback divisor, 16..320
//   div1 ... post divider 1, 1..7
//   div2 ... post divider 2, 1..7 (should be div1 >= div2, but auto-corrected)
// XOSC must be initialized to get its frequency from the table.
// All clocks should be disconnected from the PLL.
// Result frequency = (XOSC / refdiv) * fbdiv / (div1 * div2).
// Do not call this function directly, if SYS clock is connected, call the ClockPllSysSetup function.
u32 PllSetup(u8 pll, u8 refdiv, int fbdiv, u8 div1, u8 div2);

// Search PLL setup
//  reqkhz ... required output frequency in kHz
//  input ... PLL input reference frequency in kHz (default 12000)
//  vcomin ... minimal VCO frequency in kHz (default 400000)
//  vcomax ... maximal VCO frequency in kHz (default 1600000)
//  lowvco ... prefer low VCO (lower power but more jiter)
// outputs:
//  outkhz ... output achieved frequency in kHz (0=not found)
//  outvco ... output VCO frequency in kHz
//  outfbdiv ... output fbdiv (16..320)
//  outpd1 ... output postdiv1 (1..7)
//  outpd2 ... output postdiv2 (1..7)
// Returns true if precise frequency has been found, or near frequency used otherwise.
Bool PllCalc(u32 reqkhz, u32 input, u32 vcomin, u32 vcomax, Bool lowvco,
		u32* outkhz, u32* outvco, u16* outfbdiv, u8* outpd1, u8* outpd2);

// Search PLL setup, using defaults
//  reqkhz ... required output frequency in kHz
// outputs:
//  outkhz ... output achieved frequency in kHz (0=not found)
//  outvco ... output VCO frequency in kHz
//  outfbdiv ... output fbdiv (16..320)
//  outpd1 ... output postdiv1 (1..7)
//  outpd2 ... output postdiv2 (1..7)
// Returns true if precise frequency has been found, or near frequency used otherwise.
Bool PllCalcDef(u32 reqkhz, u32* outkhz, u32* outvco, u16* outfbdiv, u8* outpd1, u8* outpd2);

// setup PLL frequency in kHz (returns result frequency in kHz, or 0 if cannot setup)
// Do not call this function directly, if SYS clock is connected, call the ClockPllSysFreq function.
u32 PllSetFreq(u8 pll, u32 freq);

#ifdef __cplusplus
}
#endif

#endif // _SDK_PLL_H

#endif // USE_PLL	// use PLL phase-locked loop (sdk_pll.c, sdk_pll.h)

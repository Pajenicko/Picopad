
// ****************************************************************************
//
//                            ROSC ring oscillator
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// Ring Oscillator (ROSC) is an on-chip oscillator built from a ring of inverters.
// During boot the ROSC runs at a nominal 6.5MHz (with tolerance 1.8MHz to 12MHz).
// (RP2040 datasheet page 238)

#if USE_ROSC	// use ROSC ring oscillator (sdk_rosc.c, sdk_rosc.h)

#ifndef _SDK_ROSC_H
#define _SDK_ROSC_H

#include "../sdk_addressmap.h"		// Register address offsets
#include "sdk_clocks.h"			// clocks

#ifdef __cplusplus
extern "C" {
#endif

//#define ROSC_BASE		0x40060000	// ROSC ring oscillator
#define ROSC_CTRL	((volatile u32*)(ROSC_BASE+0x00)) // ROSC control
#define ROSC_FREQA	((volatile u32*)(ROSC_BASE+0x04)) // ROSC frequency control A
#define ROSC_FREQB	((volatile u32*)(ROSC_BASE+0x08)) // ROSC frequency control B
#define ROSC_DORMANT	((volatile u32*)(ROSC_BASE+0x0C)) // ROSC pause control
#define ROSC_DIV	((volatile u32*)(ROSC_BASE+0x10)) // ROSC output divider
#define ROSC_PHASE	((volatile u32*)(ROSC_BASE+0x14)) // ROSC phase shifted output
#define ROSC_STATUS	((volatile u32*)(ROSC_BASE+0x18)) // ROSC status
#define ROSC_RANDBIT	((volatile u32*)(ROSC_BASE+0x1C)) // ROSC random bit
#define ROSC_COUNT	((volatile u32*)(ROSC_BASE+0x20)) // ROSC down counter

#define ROSC_FREQ_NUM	64	// number of ROSC frequency levels

// Enable ring oscillator
INLINE void RoscEnable() { RegMask(ROSC_CTRL, 0xFAB << 12, 0xFFF << 12); }

// Disable ring oscillator (cannot be disabled, if CPU uses it as a clock source)
INLINE void RoscDisable() { RegMask(ROSC_CTRL, 0xD1E << 12, 0xFFF << 12); }

// Current ROSC frequency level set by the RoscSetLevel function
extern u8 RoscLevel;

// set ring oscillator frequency level (level is in range 0..63, 0..ROSC_FREQ_NUM-1; 0 is default level)
//  Typical frequency ranges:
//    level 0..24, low frequency range (8 stages), 81..150 MHz
//    level 25..43, medium frequency range (6 stages), 101..181 MHz
//    level 44..56, high frequency range (4 stages), 136..232 MHz
//    level 57..63, too high frequency range (2 stages), 217..321 MHz
// Currently set frequency level can be read from the RoscLevel variable.
void RoscSetLevel(u8 level);

// set ROSC divider 1..32 (default value 16)
//  Default frequency level 0 and default divider value 16 give typical default frequency 81/16 = 5 MHz
INLINE void RoscSetDiv(u8 div) { *ROSC_DIV = 0xAA0 + (div & 0x1F); }

// get ROSC divider 1..32
u8 RoscGetDiv();

// initialize ROSC ring oscillator to its default state (typical frequency 6 MHz)
void RoscInit();

// select ring oscillator frequency in range 2.5 .. 255 MHz (input value freq10 means required frequency * 10)
//  Selected frequency is very approximate, it can vary from 50% to 200%. 
//  The main usage of the function is in conjunction with the XOSC oscillator
//    so that frequency can be continuously changed during calibration.
//  Function takes 2 to 10 us.
void RoscSetFreq(int freq10);

// start dormant mode of the ring oscillator
INLINE void RoscDormant() { *ROSC_DORMANT = 0x636f6d61; }

// wake up ring oscillator from dormant mode
INLINE void RoscWake() { *ROSC_DORMANT = 0x77616b65; }

// check if ring oscillator is running and stable
INLINE Bool RoscIsStable() { return (*ROSC_STATUS & B31) != 0; }

// wait for stable state of the ring oscillator (ROSC must be enabled)
//  Usually not needed, ring oscillator stabilizes almost immediately.
INLINE void RoscWait() { while (!RoscIsStable()) {} }

// get random data from the ring oscillator
//  Random data from the ring generator cannot be used as a random generator because
//  generated randomness is very uneven. However, it is an excellent source for
//  initial seed of another random generator because its state is unpredictable.
INLINE u8 RoscRandBit() { return (u8)(*ROSC_RANDBIT & 1); }
u8 RoscRand8();
u16 RoscRand16();
u32 RoscRand32();

// set counter of ring oscillator
INLINE void RoscSetCount(u8 count) { *ROSC_COUNT = count; }

// get counter of ring oscillator (after setting the value, it runs down to zero and stops there)
INLINE u8 RoscGetCount() { return (u8)*ROSC_COUNT; }

#ifdef __cplusplus
}
#endif

#endif // _SDK_ROSC_H

#endif // USE_ROSC	// use ROSC ring oscillator (sdk_rosc.c, sdk_rosc.h)


// ****************************************************************************
//
//                            XOSC crystal oscillator
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// Raspberry Pico uses 12MHz crystal. RP2040 supports 1MHz to 15MHz crystals.
// (RP2040 datasheet page 234)

#if USE_XOSC	// use XOSC crystal oscillator (sdk_xosc.c, sdk_xosc.h)

#ifndef _SDK_XOSC_H
#define _SDK_XOSC_H

#include "../sdk_addressmap.h"		// Register address offsets
#include "sdk_clocks.h"			// clocks

#ifdef __cplusplus
extern "C" {
#endif

//#define XOSC_BASE		0x40024000	// XOSC crystal oscillator
#define XOSC_CTRL	((volatile u32*)(XOSC_BASE+0x00)) // control
#define XOSC_STATUS	((volatile u32*)(XOSC_BASE+0x04)) // status
#define XOSC_DORMANT	((volatile u32*)(XOSC_BASE+0x08)) // dormant control
#define XOSC_STARTUP	((volatile u32*)(XOSC_BASE+0x0C)) // startup delay
#define XOSC_COUNT	((volatile u32*)(XOSC_BASE+0x1C)) // down counter (stops at 0)

// XOSC startup delay (12MHz, 1 ms): del = (freq x delay) / 256
#define XOSC_STARTUP_DELAY_MS	1	// XOSC startup in [ms]
#define XOSC_STARTUP_DELAY (((XOSC_MHZ * 1000 * XOSC_STARTUP_DELAY_MS) + 128) / 256) // = 47

// Enable crystal oscillator
INLINE void XoscEnable() { RegMask(XOSC_CTRL, 0xFAB << 12, 0xFFF << 12); }

// Disable crystal oscillator (cannot be disabled, if CPU uses it as a clock source)
INLINE void XoscDisable() { RegMask(XOSC_CTRL, 0xD1E << 12, 0xFFF << 12); }

// initialize crystal oscillator
void XoscInit();

// start dormant mode of the crystal oscillator
INLINE void XoscDormant() { *XOSC_DORMANT = 0x636f6d61; }

// wake up crystal oscillator from dormant mode
INLINE void XoscWake() { *XOSC_DORMANT = 0x77616b65; }

// check if crystal oscillator is running and stable
INLINE Bool XoscIsStable() { return (*XOSC_STATUS & B31) != 0; }

// wait for stable state of crystal oscillator (XOSC must be enabled)
INLINE void XoscWait() { while (!XoscIsStable()) {} }

// set counter of crystal oscillator
INLINE void XoscSetCount(u8 count) { *XOSC_COUNT = count; }

// get counter of crystal oscillator (after setting the value, it runs down to zero and stops there)
INLINE u8 XoscGetCount() { return (u8)*XOSC_COUNT; }

#ifdef __cplusplus
}
#endif

#endif // _SDK_XOSC_H

#endif // USE_XOSC	// use XOSC crystal oscillator (sdk_xosc.c, sdk_xosc.h)

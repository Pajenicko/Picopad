
// ****************************************************************************
//
//                             SysTick system timer
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// SysTick is 24-bit counter of ARMv6-M CPU cure. Each core has its own systick timer.
// SysTick in RP2040 uses 1 us ticks as clock source.

#if USE_SYSTICK		// use SysTick system timer (sdk_systime.c, sdk_systime.h)

#ifndef _SDK_SYSTICK_H
#define _SDK_SYSTICK_H

#include "../sdk_addressmap.h"		// Register address offsets

#ifdef __cplusplus
extern "C" {
#endif

// SysTick period (number of 1 us ticks to interrupt every SYSTICK_MS ms)
#define SYSTICK_TICKS	5000

// increment of system time on SysTick interrupt
#define SYSTICK_MS	5

// system time counter, counts time from system start - incremented every SYSTICK_MS ms
// with overflow after 49 days (use difference, not absolute value!)
extern volatile u32 SysTime;

// current date and time (incremented every SYSTICK_MS ms from CPU core 0)
extern volatile u32 UnixTime;		// current date and time in Unix format
					// - number of seconds since 1/1/1970 (thursday) up to 12/31/2099
extern volatile s16 TimeMs;		// current time in [ms] 0..999

// === System control block (RP2040 datasheet page 74)
//#define PPB_BASE		0xe0000000	// Cortex-M0+ internal registers (system control block)

#define SYSTICK_CSR ((volatile u32*)(PPB_BASE + 0xE010))	// SysTick control and status register
#define SYSTICK_RVR ((volatile u32*)(PPB_BASE + 0xE014))	// SysTick reload value register
#define SYSTICK_CVR ((volatile u32*)(PPB_BASE + 0xE018))	// SysTick current value register
#define SYSTICK_CALIB ((volatile u32*)(PPB_BASE + 0xE01C))	// SysTick calibration value register

// initialize SysTick timer for this CPU core to interrupt every SYSTICK_MS ms
// - AlarmInit() function must be called before initializing SysTick timers.
// - It must be called from each CPU core separately.
void SysTickInit();

// terminate SysTick timer
void SysTickTerm();

// get current date and time in Unix format with [ms] and [us], synchronized (NULL = entries not required)
//  Takes 1 us
u32 GetUnixTime(s16* ms, s16* us);

// set current date and time in Unix format with [ms] (0..999)
// - Should be called from CPU core 0. From core 1, the setting may be inaccurate.
//  Takes 280 ns
void SetUnixTime(u32 time, s16 ms);

#ifdef __cplusplus
}
#endif

#endif // _SDK_SYSTICK_H

#endif // USE_SYSTICK		// use SysTick system timer (sdk_systime.c, sdk_systime.h)

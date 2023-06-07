
// ****************************************************************************
//
//                              Watchdog Timer
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// Time source is shared with main timer counter.

#ifndef _SDK_WATCHDOG_H
#define _SDK_WATCHDOG_H

#include "../sdk_addressmap.h"		// Register address offsets
#include "sdk_reset.h"			// register PSM_WDSEL

#ifdef __cplusplus
extern "C" {
#endif

//#define WATCHDOG_BASE		0x40058000	// Watchdog timer
#define WATCHDOG_CTRL	((volatile u32*)(WATCHDOG_BASE + 0x00)) // control register
#define WATCHDOG_LOAD	((volatile u32*)(WATCHDOG_BASE + 0x04)) // load
#define WATCHDOG_REASON	((volatile u32*)(WATCHDOG_BASE + 0x08)) // reason
#define WATCHDOG_SCRATCH ((volatile u32*)(WATCHDOG_BASE + 0x0C)) // 8 scratch registers u32
#define WATCHDOG_TICK	((volatile u32*)(WATCHDOG_BASE + 0x2C)) // tick

// Control register WATCHDOG_CTRL
#define WATCHDOG_CTRL_TIMEMASK	0x00ffffff		// number of ticks*2
#define WATCHDOG_REBOOT_MAGIC	0xB007C0D3		// magic of soft reset (for using in scratch registers)
#define WATCHDOG_LOADER_MAGIC	0x64616F4C		// magic of boot loader (= text "Load")

#if USE_WATCHDOG || USE_TIMER // use Watchdog or Timer
// Start watchdog tick generator (generated ticks are shared with main timer counter!)
void WatchdogStart(u32 xosc_mhz);
#endif // USE_WATCHDOG || USE_TIMER // use Watchdog or Timer

#if USE_WATCHDOG	// use Watchdog timer (sdk_watchdog.c, sdk_watchdog.h)

// Watchdog soft reboot
//   scratch register 4: magic number 0xb007c0d3 (will be cleared before transferring control)
//   scratch register 5: entry point XORed with magic -0xb007c0d3 (0x4ff83f2d)
//   scratch register 6: stack pointer
//   scratch register 7: entry point

// watchdog update value (to restart time counting) = time in [us] * 2
extern u32 WatchdogUpdateValue;

// update watchdog (restart time counting)
INLINE void WatchdogUpdate() { *WATCHDOG_LOAD = WatchdogUpdateValue; }

// Get current value of watchdog generator in number of us
INLINE u32 WatchdogGetCount() { return (*WATCHDOG_CTRL & WATCHDOG_CTRL_TIMEMASK) / 2; }

// Setup watchdog generator to do hard reset
//  us = delay before reset in [us], max. 0x7fffff us (8388607 us = 8.4 seconds)
//  pause_debug = pause watchdog on debugging
void WatchdogSetupReset(u32 us, Bool pause_debug);

// Setup watchdog genererator to do soft reset
//  pc = pointer to code to restart in soft reset (0 = do hard reset)
//  sp = stack pointer
//  us = delay before reset in [us], max. 0x7fffff us (8388607 us = 8.4 seconds)
void WatchdogSetupReboot(u32 us, u32 pc, u32 sp);

// Trigger watchdog reset
INLINE void WatchdogTrigger() { RegSet(WATCHDOG_CTRL, B31); }

// Get reset reason (0=hardware, 1=watchdog timer, 2=force trigger)
INLINE u8 WatchdogReason() { return (u8)(*WATCHDOG_REASON & (B0|B1)); }

// reset to boot loader
void ResetToBootLoader();

#endif // USE_WATCHDOG	// use Watchdog timer (sdk_watchdog.c, sdk_watchdog.h)

#ifdef __cplusplus
}
#endif

#endif // _SDK_WATCHDOG_H

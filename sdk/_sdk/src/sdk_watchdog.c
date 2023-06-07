
// ****************************************************************************
//
//                              Watchdog Timer
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals
#include "../inc/sdk_watchdog.h"

#if USE_WATCHDOG || USE_TIMER // use Watchdog or Timer
// Start watchdog tick generator (generated ticks are shared with main timer counter!)
void WatchdogStart(u32 xosc_mhz)
{
	*WATCHDOG_TICK = xosc_mhz | B9; // setup ticks and run tick generator
}
#endif // USE_WATCHDOG || USE_TIMER // use Watchdog or Timer

#if USE_WATCHDOG	// use Watchdog timer (sdk_watchdog.c, sdk_watchdog.h)

// watchdog update value (to restart time counting) = time in [us] * 2
u32 WatchdogUpdateValue;

// Setup watchdog generator
//  us = delay before reset in [us], max. 0x7fffff us (8388607 us = 8.4 seconds)
//  pause_debug = pause watchdog on debugging
static void WatchdogSetup(u32 us, Bool pause_debug)
{
	// pause watchdog
	RegClr(WATCHDOG_CTRL, B30);

	// select which peripherals to reset (reset everything apart from ROSC and XOSC)
	RegSet(PSM_WDSEL, PSM_WDSEL_RESETBITS);

	// pause on debug
	if (pause_debug)
		RegSet(WATCHDOG_CTRL, B24|B25|B26);
	else
		RegClr(WATCHDOG_CTRL, B24|B25|B26);

	// limit max. value
	if (us > WATCHDOG_CTRL_TIMEMASK/2) us = WATCHDOG_CTRL_TIMEMASK/2;

	// update time counter
	WatchdogUpdateValue = us*2;
	WatchdogUpdate();

	// run watchdog
	RegSet(WATCHDOG_CTRL, B30);
}

// Setup watchdog generator to do hard reset
//  us = delay before reset in [us], max. 0x7fffff us (8388607 us = 8.4 seconds)
//  pause_debug = pause watchdog on debugging
void WatchdogSetupReset(u32 us, Bool pause_debug)
{
	// clear scratch register 4 with magic word to jump into code
	WATCHDOG_SCRATCH[4] = 0;

	// enable watchdog generator
	WatchdogSetup(us, pause_debug);
}

// Setup watchdog genererator to do soft reset
//  pc = pointer to code to restart in soft reset (0 = do hard reset)
//  sp = stack pointer
//  us = delay before reset in [us], max. 0x7fffff us (8388607 us = 8.4 seconds)
void WatchdogSetupReboot(u32 us, u32 pc, u32 sp)
{
	// pause watchdog before setting up scratch registers
	RegClr(WATCHDOG_CTRL, B30);

	// setup scratch registers
	if (pc != 0)
	{
		WATCHDOG_SCRATCH[4] = WATCHDOG_REBOOT_MAGIC; // set magic
		WATCHDOG_SCRATCH[5] = pc ^ -WATCHDOG_REBOOT_MAGIC; // set PC with magic
		WATCHDOG_SCRATCH[6] = sp; // set SP
		WATCHDOG_SCRATCH[7] = pc; // set PS
	}
	else
		// do hard reset; clear scratch register 4 with magic word to jump into code
		WATCHDOG_SCRATCH[4] = 0;

	// enable watchdog generator (no pause on debugging)
	WatchdogSetup(us, False);
}

// reset to boot loader
void ResetToBootLoader()
{
	// set loader magic
	WATCHDOG_SCRATCH[4] = WATCHDOG_LOADER_MAGIC;

	// enable watchdog generator
	WatchdogSetup(1000, False);

	// trigger watchdog
	WatchdogTrigger();
}

#endif // USE_WATCHDOG	// use Watchdog timer (sdk_watchdog.c, sdk_watchdog.h)


// ****************************************************************************
//
//                            XOSC crystal oscillator
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_XOSC	// use XOSC crystal oscillator (sdk_xosc.c, sdk_xosc.h)

#include "../inc/sdk_xosc.h"

// initialize crystal oscillator
void XoscInit()
{
	// set frequency range to 1..15 MHz
	*XOSC_CTRL = 0xAA0;

	// set startup delay
	*XOSC_STARTUP = XOSC_STARTUP_DELAY;

	// enable oscillator
	XoscEnable();

	// update current frequency
	CurrentFreq[CLK_XOSC] = XOSC_MHZ*MHZ; // default XOR crystal oscillator is 12 MHz

	// wait for XOSC to be stable
	XoscWait();
}

#endif // USE_XOSC	// use XOSC crystal oscillator (sdk_xosc.c, sdk_xosc.h)


// ****************************************************************************
//
//                             Reset and power-on
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#include "../inc/sdk_reset.h"

// stop resetting periphery specified by the mask RESET_* and wait
void ResetPeripheryOffWait(u32 mask)
{
	ResetPeripheryOff(mask);  // stop resetting periphery
	while (!ResetPeripheryDone(mask)) {} // wait periphery to be done
}

// hard reset periphery (and wait to be accessed again)
//  Takes 0.5 us.
void ResetPeriphery(u32 mask)
{
	ResetPeripheryOn(mask);  // start resetting periphery
	ResetPeripheryOffWait(mask); // stop resetting periphery and wait
}

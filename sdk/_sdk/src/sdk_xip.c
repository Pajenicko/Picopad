
// ****************************************************************************
//
//                            XIP flash control
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals
#include "../inc/sdk_xip.h"

// flush flash cache and wait to complete
void FlashCacheFlushWait()
{
	// flush flash cache
	*XIP_FLUSH = 1;

	// Read blocks until flush completion
	(void)*XIP_FLUSH;

	// Enable the cache
	RegSet(XIP_CTRL, B0);
}


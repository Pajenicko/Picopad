
// ****************************************************************************
//
//                                 Open screen
//
// ****************************************************************************

#include "../include.h"

const char* const OpenCharName[4] = { "SHADOW", "SPEEDY", "BASHFUL", "POKEY" };
const char* const OpenCharNick[4] = { "\"BLINKY\"", "\"PINKY\"", "\"INKY\"", "\"CLYDE\"" };
const char* const OpenScore[4] = { "200", "400", "800", "1600" };
const u16 OpenCharCol[4] = { COL_BLINKY, COL_PINKY, COL_INKY, COL_CLYDE };

u32 LastTime;

// update display and wait
void DispWait(u32 ms)
{
	ms *= 1000;
	u32 t;
	DispUpdate();
	do t = Time(); while ((u32)(t - LastTime) < (u32)ms);
	LastTime = t;
}


// ****************************************************************************
//
//                                 Open screen
//
// ****************************************************************************

#ifndef _OPEN_H
#define _OPEN_H

#include "include.h"

extern u32 LastTime;

// update display and wait
void DispWait(u32 ms);

// open screen (break with a valid key)
void OpenScreen();

#endif // _OPEN_H


// ****************************************************************************
//
//                                 Mushrooms
//
// ****************************************************************************

#ifndef _MUSHROOMS_H
#define _MUSHROOMS_H

#define MUSHROOMS_MAX		32 // (min. 10) max. number of mushrooms

extern sObj Mushrooms[MUSHROOMS_MAX]; // mushrooms
extern int MushroomsNum; // initial number of mushrooms
extern int MushroomsStock;	// mushrooms in stock

// display mushrooms in stock
void DispMushrooms();

// move mushrooms
void MoveMushrooms();

#endif // _MUSHROOMS_H

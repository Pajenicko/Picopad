
// ****************************************************************************
//
//                          Random Number Generator
//
// ****************************************************************************
// The game uses a custom random number generator to ensure repeatability of the scene solving macros.

#ifndef _RANDOM_H
#define _RANDOM_H

// Seed of random number generator
extern u32 RandomSeed;

// set seed of random number generator
void RandomSet(u32 seed);

// shift random number generator
void RandomShift();

// generate random byte
u8 RandomByte();

// generate random word
u16 RandomWord();

#endif // _RANDOM_H

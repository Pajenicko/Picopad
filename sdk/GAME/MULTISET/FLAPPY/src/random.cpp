
// ****************************************************************************
//
//                          Random Number Generator
//
// ****************************************************************************

#include "../include.h"

// Seed of random number generator
u32 RandomSeed;

// set seed of random number generator
void RandomSet(u32 seed)
{
	RandomSeed = seed;
}

// shift random number generator
void RandomShift()
{
	RandomSeed = RandomSeed * 214013 + 2531011;
}

// generate random byte
u8 RandomByte()
{
	RandomShift();
	return (u8)(RandomSeed >> 24);
}

// generate random word
u16 RandomWord()
{
	RandomShift();
	return (u16)(RandomSeed >> 16);
}



// ****************************************************************************
//
//                                 CPU control
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals
#include "../inc/sdk_cpu.h"
#include "../inc/sdk_bootrom.h"

// reverse bit table
const u8 RevBitsTab[16] = {
	0x00, 0x08, 0x04, 0x0C, 0x02, 0x0A, 0x06, 0x0E,
	0x01, 0x09, 0x05, 0x0D, 0x03, 0x0B, 0x07, 0x0F };

// order bit table
//                          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
const u8 OrdBitsTab[16] = { 0, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4 };

// reverse 8 bits (takes 10 ns)
u8 Reverse8(u8 val)
{
	return RevBitsTab[val >> 4] | (RevBitsTab[val & 0xf] << 4);
}

// reverse 16 bits (takes 17 ns)
u16 Reverse16(u16 val)
{
	return ((u16)Reverse8((u8)val) << 8) | Reverse8((u8)(val >> 8));
}

// reverse 32 bits (takes 50 ns) ... use faster ROM function reverse()
/*u32 Reverse32(u32 val)
{
	return ((u32)Reverse16((u16)val) << 16) | Reverse16((u16)(val >> 16));
}*/

// get bit order of value (logarithm, returns position of highest bit + 1: 1..32, 0=no bit)
u8 Order(u32 val)
{
	int i = 0;
	if (val >= 0x10000)
	{
		i = 16;
		val >>= 16;
	}

	if (val >= 0x100)
	{
		i += 8;
		val >>= 8;
	}

	if (val >= 0x10)
	{
		i += 4;
		val >>= 4;
	}
	return OrdBitsTab[val] + i;
}

// get bit order of 64-bit value (logarithm, returns position of highest bit + 1: 1..64, 0=no bit)
u8 Order64(u64 val)
{
	if (val >= 0x100000000ULL)
		return Order((u32)(val >> 32)) + 32;
	else
		return Order((u32)val);
}

// get number of leading zeros of u32 number
// takes 350 ns ... use bootrom version, it takes 170 ns
/*
u8 clz(u32 val)
{
	u8 i = 32;

	if (val >= 0x10000)
	{
		i = 16;
		val >>= 16;
	}

	if (val >= 0x100)
	{
		i -= 8;
		val >>= 8;
	}

	if (val >= 0x10)
	{
		i -= 4;
		val >>= 4;
	}

	if (val >= 4)
	{
		i -= 2;
		val >>= 2;
	}

	if (val >= 2)
	{
		i -= 1;
		val >>= 1;
	}

	if (val >= 1) i--;

	return i;
}
*/
// get number of leading zeros of u64 number
u8 clz64(u64 num)
{
	if (num >= 0x100000000ULL)
		return clz((u32)(num >> 32));
	else
		return clz((u32)num) + 32;
}

#if USE_STACKCHECK	// use Stack check (sdk_cpu.c, sdk_cpu.h)

// feed stack of current CPU core with the food (returns free space, or 0 on stack error)
u32 StackFeed()
{
	// prepare stack pointers
	u32 bot = (((u32)StackBottom() + 3) & ~3); // stack bottom
	u32 top = ((u32)StackTop() & ~3); // stack top
	u32 sp = (u32)GetSp(); // stack pointer

	// check stack pointer
	if ((sp < bot) || (sp > top)) return 0;

	// feed stack
	u32* s = (u32*)bot;
	int n = (sp - bot)/4;
	for (; n > 0; n--) *s++ = 0x600DF00D; // fill with pattern "Good Food"

	return sp - bot;
}

// check stack limit of current CPU core (check used stack space)
u32 StackCheck()
{
	u32 bot = (((u32)StackBottom() + 3) & ~3); // stack bottom
	u32* s = (u32*)bot;
	while (*s == 0x600DF00D) s++; // check pattern "Good Food"
	return (u32)s - bot;
}

#endif // USE_STACKCHECK	// use Stack check (sdk_cpu.c, sdk_cpu.h)

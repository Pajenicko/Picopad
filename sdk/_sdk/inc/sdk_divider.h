
// ****************************************************************************
//
//                              Integer Divider
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// (RP2040 datasheet page 29)
// Every CPU core has its own integer divider unit.
//
// This SDK does not use the DIRTY flag (so it does not depend on the order
// of register reads), but locks the IRQ interrupt during access to the divider.
// Thus, there is no need to store the state of the divider during the interrupt.

// This SDK implementation does not trap the division by zero error (__aeabi_idiv0).
// The result of division by zero is undefined.

#ifndef _SDK_DIVIDER_H
#define _SDK_DIVIDER_H

#include "../sdk_addressmap.h"		// Register address offsets

#ifdef __cplusplus
extern "C" {
#endif

//#define SIO_BASE		0xd0000000	// SIO registers
//  (SIO does not support aliases for atomic access!)
#define DIV_UDIVIDEND	((volatile u32*)(SIO_BASE+0x60)) // unsigned dividend 'p'
#define DIV_UDIVISOR	((volatile u32*)(SIO_BASE+0x64)) // unsigned divisor 'q'
#define DIV_SDIVIDEND	((volatile u32*)(SIO_BASE+0x68)) // signed dividend 'p'
#define DIV_SDIVISOR	((volatile u32*)(SIO_BASE+0x6C)) // signed divisor 'q'
#define DIV_QUOTIENT	((volatile u32*)(SIO_BASE+0x70)) // result quotient = p / q (must be read last, after remainder)
#define DIV_REMAINDER	((volatile u32*)(SIO_BASE+0x74)) // result remainder = p % q (quotient must be read too)
#define DIV_CSR		((volatile u32*)(SIO_BASE+0x78)) // control and status register

// start signed division p/q
INLINE void DivStartS32(s32 p, s32 q) { *DIV_SDIVIDEND=(u32)p; *DIV_SDIVISOR=(u32)q; }

// start unsigned division p/q
INLINE void DivStartU32(u32 p, u32 q) { *DIV_UDIVIDEND=p; *DIV_UDIVISOR=q; }

// wait for divide to complete calculation (takes 8 clock cycles)
INLINE void DivWait() { while((*DIV_CSR & B0) == 0) {} }

// get result remainder after complete calculation (must read quotient after remainder)
INLINE u32 DivRemainder() { return *DIV_REMAINDER; } // retype to (s32) after signed division

// get result quotient after complete calculation
INLINE u32 DivQuotient() { return *DIV_QUOTIENT; } // retype to (s32) after signed division

// get result after complete calculation: quotient p/q in low 32 bits, remainder p%q in high 32 bits
INLINE u64 DivResult() { return ((u64)*DIV_REMAINDER << 32) | *DIV_QUOTIENT; }

// Divide signed S32
//   a ... signed dividend s32
//   b ... signed divisor s32
//   result ... signed quotient s32 c=a/b
// Temporary disables interrupt to protect divider state.
// takes 280 ns
s32 DivS32(s32 a, s32 b);

// Divide unsigned U32
//   a ... unsigned dividend u32
//   b ... unsigned divisor u32
//   result ... unsigned quotient u32 c=a/b
// Temporary disables interrupt to protect divider state.
// takes 280 ns
u32 DivU32(u32 a, u32 b);

// Modulo signed S32
//   a ... signed dividend s32
//   b ... signed divisor s32
//   result ... signed remainder s32 d=a%b
// Temporary disables interrupt to protect divider state.
// takes 280 ns
s32 ModS32(s32 a, s32 b);

// Modulo unsigned U32
//   a ... unsigned dividend u32
//   b ... unsigned divisor u32
//   result ... unsigned remainder u32 d=a%b
// Temporary disables interrupt to protect divider state.
// takes 280 ns
u32 ModU32(u32 a, u32 b);

// Divide modulo signed S32
//   a ... signed dividend s32
//   b ... signed divisor s32
//   rem ... pointer to store remainder s32 d=a%b
//   result ... signed quotient s32 c=a/d
// Temporary disables interrupt to protect divider state.
s32 DivModS32(s32 a, s32 b, s32* rem);

// Divide modulo unsigned U32
//   a ... unsigned dividend u32
//   b ... unsigned divisor u32
//   rem ... pointer to store remainder u32 d=a%b
//   result ... unsigned quotient u32 c=a/d
// Temporary disables interrupt to protect divider state.
u32 DivModU32(u32 a, u32 b, u32* rem);

// Divide signed S64
//   a ... signed dividend s64
//   b ... signed divisor s64
//   result ... signed quotient s64 c=a/b
// Temporary disables interrupt to protect divider state.
// Takes 500 ns to 8 us
s64 DivS64(s64 a, s64 b);

// Divide unsigned U64
//   a ... unsigned dividend u64
//   b ... unsigned divisor u64
//   result ... unsigned quotient u64 c=a/b
// Temporary disables interrupt to protect divider state.
// Takes 500 ns to 8 us
u64 DivU64(u64 a, u64 b);

// Modulo signed S64
//   a ... signed dividend s64
//   b ... signed divisor s64
//   result ... signed remainder s64 d=a%b
// Temporary disables interrupt to protect divider state.
// Takes 500 ns to 8 us
s64 ModS64(s64 a, s64 b);

// Modulo unsigned U64
//   a ... unsigned dividend u64
//   b ... unsigned divisor u64
//   result ... unsigned remainder u64 d=a%b
// Temporary disables interrupt to protect divider state.
// Takes 500 ns to 8 us
u64 ModU64(u64 a, u64 b);

// Divide modulo signed S64
//   a ... signed dividend s64
//   b ... signed divisor s64
//   rem ... pointer to store remainder s64 d=a%b
//   result ... signed quotient s64 c=a/d
// Temporary disables interrupt to protect divider state.
// Takes 500 ns to 8 us
s64 DivModS64(s64 a, s64 b, s64* rem);

// Divide modulo unsigned U64
//   a ... unsigned dividend u64
//   b ... unsigned divisor u64
//   rem ... pointer to store remainder u64 d=a%b
//   result ... unsigned quotient u64 c=a/d
// Temporary disables interrupt to protect divider state.
// Takes 500 ns to 8 us
u64 DivModU64(u64 a, u64 b, u64* rem);

// Unsigned multiply u32*u32 with result u64
// Takes 330 ns
u64 UMul(u32 a, u32 b);

// Signed multiply s32*s32 with result s64
// Takes 370 ns
s64 SMul(s32 a, s32 b);

// Square u32*u32 with result u64
// Takes 240 ns
u64 Sqr(u32);

// Signed/unsigned multiply u64*u64 with result u64 (= __aeabi_lmul)
u64 UMul64(u64 a, u64 b);
s64 SMul64(s64 a, s64 b);

#ifdef __cplusplus
}
#endif

#endif // _SDK_DIVIDER_H

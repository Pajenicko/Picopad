
// ****************************************************************************
//
//                               Integer Divider
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz
// Copyright (c) 2020 Raspberry Pi (Trading) Ltd. - SPDX-License-Identifier: BSD-3-Clause

#include "../asm_include.inc"

	.syntax unified
	.cpu cortex-m0plus
	.thumb

// ----------------------------------------------------------------------------
//                         Divide signed S32 DivS32
// ----------------------------------------------------------------------------
//   a ... signed dividend s32
//   b ... signed divisor s32
//   result ... signed quotient s32 c=a/b
// Temporary disables interrupt to protect divider state.
// s32 DivS32(s32 a, s32 b);
// takes 280 ns

// input:
//  R0 ... signed dividend s32 'a'
//  R1 ... signed divisor s32 'b'
// output:
//  R0 ... signed quotient s32 c=a/b
//  R1 ... signed remainder s32 d=a%b

regular_func_text DivS32
wrapper_func __aeabi_idiv		// wrapper of library function idiv
wrapper_func __aeabi_idivmod		// wrapper of library function idivmod

	// save and disable interrupt
	ldr	r2,=SIO_BASE		// get address of SIO base
	irq_lock r12			// save interrupt into R12, disable interrupt

	// start operation
	str	r0,[r2,#0x68]		// set signed dividend 'a'
	str	r1,[r2,#0x6c]		// set signed divisor 'b'

	// [8] wait 8 clock cycles
	nop8				// [8] delay 8 clock cycles

	// get result (load remainder before loading quotient)
	ldr	r1,[r2,#0x74]		// load remainder 'd'
	ldr	r0,[r2,#0x70]		// load quotient 'c'

	// restore interrupt
	irq_unlock r12			// restore interrupt from R12
	bx	lr			// return from the function

// ----------------------------------------------------------------------------
//                       Divide unsigned U32 DivU32
// ----------------------------------------------------------------------------
//   a ... unsigned dividend u32
//   b ... unsigned divisor u32
//   result ... unsigned quotient u32 c=a/b
// Temporary disables interrupt to protect divider state.
// u32 DivU32(u32 a, u32 b);
// takes 280 ns

// input:
//  R0 ... unsigned dividend u32 'a'
//  R1 ... unsigned divisor u32 'b'
// output:
//  R0 ... unsigned quotient u32 c=a/b
//  R1 ... unsigned remainder u32 d=a%b

regular_func_text DivU32
wrapper_func __aeabi_uidiv		// wrapper of library function uidiv
wrapper_func __aeabi_uidivmod		// wrapper of library function uidivmod

	// save and disable interrupt
	ldr	r2,=SIO_BASE		// get address of SIO base
	irq_lock r12			// save interrupt into R12, disable interrupt

	// start operation
	str	r0,[r2,#0x60]		// set unsigned dividend 'a'
	str	r1,[r2,#0x64]		// set unsigned divisor 'b'

	// [8] wait 8 clock cycles
	nop8				// [8] delay 8 clock cycles

	// get result (load remainder before loading quotient)
	ldr	r1,[r2,#0x74]		// load remainder 'd'
	ldr	r0,[r2,#0x70]		// load quotient 'c'

	// restore interrupt
	irq_unlock r12			// restore interrupt from R12
	bx	lr			// return from the function

// ----------------------------------------------------------------------------
//                      Modulo signed S32 ModS32
// ----------------------------------------------------------------------------
//   a ... signed dividend s32
//   b ... signed divisor s32
//   result ... signed remainder s32 d=a%b
// Temporary disables interrupt to protect divider state.
// s32 ModS32(s32 a, s32 b);
// takes 280 ns

// input:
//  R0 ... signed dividend s32 'a'
//  R1 ... signed divisor s32 'b'
// output:
//  R0 ... signed remainder s32 d=a%b
// destroys: R2, R12

regular_func_text ModS32

	// save and disable interrupt
	ldr	r2,=SIO_BASE		// get address of SIO base
	irq_lock r12			// save interrupt into R12, disable interrupt

	// start operation
	str	r0,[r2,#0x68]		// set signed dividend 'a'
	str	r1,[r2,#0x6c]		// set signed divisor 'b'

	// [8] wait 8 clock cycles
	nop8				// [8] delay 8 clock cycles

	// get result (load remainder before loading quotient)
	ldr	r0,[r2,#0x74]		// load remainder 'd'
	// ldr	r1,[r2,#0x70]		// load quotient 'c' ... no need to read, the DIRTY flag stays set

	// restore interrupt
	irq_unlock r12			// restore interrupt from R12
	bx	lr			// return from the function

// ----------------------------------------------------------------------------
//                         Modulo unsigned U32 ModU32
// ----------------------------------------------------------------------------
//   a ... unsigned dividend u32
//   b ... unsigned divisor u32
//   result ... unsigned remainder u32 d=a%b
// Temporary disables interrupt to protect divider state.
// u32 ModU32(u32 a, u32 b);
// takes 280 ns

// input:
//  R0 ... unsigned dividend u32 'a'
//  R1 ... unsigned divisor u32 'b'
// output:
//  R0 ... unsigned remainder u32 d=a%b
// destroys: R2, R12

regular_func_text ModU32

	// save and disable interrupt
	ldr	r2,=SIO_BASE		// get address of SIO base
	irq_lock r12			// save interrupt into R12, disable interrupt

	// start operation
	str	r0,[r2,#0x60]		// set unsigned dividend 'a'
	str	r1,[r2,#0x64]		// set unsigned divisor 'b'

	// [8] wait 8 clock cycles
	nop8				// [8] delay 8 clock cycles

	// get result (load remainder before loading quotient)
	ldr	r0,[r2,#0x74]		// load remainder 'd'
	// ldr	r1,[r2,#0x70]		// load quotient 'c' ... no need to read, the DIRTY flag stays set

	// restore interrupt
	irq_unlock r12			// restore interrupt from R12
	bx	lr			// return from the function

// ----------------------------------------------------------------------------
//                    Divide modulo signed S32 DivModS32
// ----------------------------------------------------------------------------
//   a ... signed dividend s32
//   b ... signed divisor s32
//   rem ... pointer to store remainder s32 d=a%b
//   result ... signed quotient s32 c=a/d
// Temporary disables interrupt to protect divider state.
// s32 DivModS32(s32 a, s32 b, s32* rem);

// input:
//  R0 ... signed dividend s32 'a'
//  R1 ... signed divisor s32 'b'
//  R2 ... pointer to store signed remainder s32 d=a%b
// output:
//  R0 ... signed quotient s32 c=a/b

regular_func_text DivModS32

	push	{r2,lr}
	bl	DivS32
	pop	{r2}
	str	r1,[r2,#0]
	pop	{pc}

// ----------------------------------------------------------------------------
//                    Divide modulo unsigned U32 DivModU32
// ----------------------------------------------------------------------------
//   a ... unsigned dividend u32
//   b ... unsigned divisor u32
//   rem ... pointer to store remainder u32 d=a%b
//   result ... unsigned quotient u32 c=a/d
// Temporary disables interrupt to protect divider state.
// u32 DivModU32(u32 a, u32 b, u32* rem);

// input:
//  R0 ... unsigned dividend u32 'a'
//  R1 ... unsigned divisor u32 'b'
//  R2 ... pointer to store unsigned remainder u32 d=a%b
// output:
//  R0 ... unsigned quotient u32 c=a/b

regular_func_text DivModU32

	push	{r2,lr}
	bl	DivU32
	pop	{r2}
	str	r1,[r2,#0]
	pop	{pc}

// ----------------------------------------------------------------------------
//                       Divide signed S64 DivS64
// ----------------------------------------------------------------------------
//   a ... signed dividend s64
//   b ... signed divisor s64
//   result low 64 bits ... signed quotient s64 c=a/b
//   (result high 64 bits ... signed remainder s64 d=a%b)
// Temporary disables interrupt to protect divider state.
// When dividing by zero, the result is undefined.
// s64 DivS64(s64 a, s64 b);
// Takes:
//    1..32 bits / 1..32 bits ... 500 ns
//    33..64 bits / 1..16 bits ... 800 ns
//    1..64 bits / 17..32 bits ... 6 us
//    1..64 bits / 33..64 bits ... 8 us

// input:
//  R1:R0 ... signed dividend s64 'a'
//  R3:R2 ... signed divisor s64 'b'
// output:
//  R1:R0 ... signed quotient s64 c=a/b
//  R3:R2 ... signed remainder s64 d=a%b

regular_func_text DivS64
wrapper_func __aeabi_ldiv		// wrapper of library function ldiv
wrapper_func __aeabi_ldivmod		// wrapper of library function ldivmod

	// check if divisor 'b' is negative
	cmp	r3,#0			// is divisor 'b' negative?
	blt	1f			// divisor 'b' is negative

	// divisor 'b' is positive, check if dividend 'a' is negative
	cmp	r1,#0			// is dividend 'a' negative?
	blt	3f			// dividend 'a' is negative
	b	DivU64			// both numbers are positive, do unsigned division

	// divisor 'b' is positive, dividend 'a' is negative - negate dividend 'a' and result
3:	push	{lr}			// push link register
	dneg	r0,r1			// negate dividend 'a' in R1:R0
	bl	DivU64			// unsigned division
	dneg	r0,r1			// negate result quotient 'c' in R1:R0
	dneg	r2,r3			// negate result remainder 'd' in R3:R2
	pop	{pc}			// return

	// divisor 'b' is negative, check if dividend 'a' is negative
1:	push	{lr}			// push link register
	cmp	r1,#0			// is dividend 'a' negative?
	blt	1f			// dividen 'a' is negative too

	// divisor 'b' is negative, dividend 'a' is positive - negate divisor 'b' and result quotient 'c' (remainder 'd' will stay positive)
	dneg	r2,r3			// negate divisor 'b' in R3:R2
	bl	DivU64			// unsigned division
	dneg	r0,r1			// negate result quotient 'c' in R1:R0
	pop	{pc}			// return

	// divisor 'b' is negative, dividend 'a' is negative - negate divisor 'b', dividend 'a' and result remainder 'd' (quotient 'c' will stay positive)
1:	dneg	r0,r1			// negate dividend 'a' in R1:R0
	dneg	r2,r3			// negate divisor 'b' in R3:R2
	bl	DivU64			// unsigned division
	dneg	r2,r3			// negate result remainder 'd' in R3:R2
	pop	{pc}			// return

// ----------------------------------------------------------------------------
//                       Divide unsigned U64 DivU64
// ----------------------------------------------------------------------------
//   a ... unsigned dividend u64
//   b ... unsigned divisor u64
//   result low 64 bits ... unsigned quotient u64 c=a/d
//   (result high 64 bits ... unsigned remainder u64 d=a%b)
// Temporary disables interrupt to protect divider state.
// When dividing by zero, the result is undefined.
// u64 DivU64(u64 a, u64 b);
// Takes 500 ns to 8 us.

// input:
//  R1:R0 ... unsigned dividend u64 'a'
//  R3:R2 ... unsigned divisor u64 'b'
// output:
//  R1:R0 ... unsigned quotient u64 c=a/b
//  R3:R2 ... unsigned remainder u64 d=a%b

regular_func_text DivU64
wrapper_func __aeabi_uldiv		// wrapper of library function uldiv
wrapper_func __aeabi_uldivmod		// wrapper of library function uldivmod

	// check if dividend 'a' fits in 32 bits
	cmp	r1,#0			// check dividend 'a' high
	bne	2f			// dividend 'a' does not fit in 32 bits

	// dividend 'a' fits in 32 bits, check if divisor 'b' fits in 32 bits too
	cmp	r3,#0			// check divisor 'b' high
	bne	1f			// divisor 'b' does not fit in 32 bits - result will be 0


// ---- both divisor and dividend fit in 32 bits, use fast division

	// push register R4
	push	{r4}

	// save and disable interrupt
	irq_lock r12			// save interrupt into R12, disable interrupt
	ldr	r4,=SIO_BASE		// get address of SIO base

	// start operation
	str	r0,[r4,#0x60]		// set unsigned dividend 'a'
	str	r2,[r4,#0x64]		// set unsigned divisor 'b'

	// [2] clear result high (wait 2 clock cycles)
	movs	r1,#0			// [1] clear result quotient 'c' high
	movs	r3,#0			// [1] clear result remainder 'd' high

	// [6] wait 6 clock cycles (we need total delay [8])
	nop6				// [6] delay 6 clock cycles

	// get result
	ldr	r2,[r4,#0x74]		// load remainder 'd' -> R3:R2
	ldr	r0,[r4,#0x70]		// load quotient 'c' -> R1:R0

	// restore interrupt
	irq_unlock r12			// restore interrupt from R12

	// restore register R4
	pop	{r4}			// pop registers
	bx	lr			// return


// ---- divisor 'b' is greater than dividend 'a', result will be 0 with remainder 'a'

1:	mov	r2,r0			// copy dividend 'a' into remainder 'd'
	mov	r3,r1
	movs	r0,#0			// quotient will be 0
	movs	r1,#0
	bx	lr			// return


	// dividend 'a' does not fit in 32 bits, check if divisor 'b' fits in 32 bits
2:	cmp	r3,#0			// check divisor 'b' high
	bne	DivU64_2		// divisor 'b' does not fit in 32 bits

	// check if divisor 'b' fits in 16 bits (at this place, we can destroy R3 register, it contains #0)
	lsrs	r3,r2,#16		// check higher 16 bits of register R2 (shift 16 bits right -> R3)
	bne	DivU64_1		// divisor 'b' does not fit in 16 bits


// ---- dividend 'a' is greater than 32 bits, divisor 'b' fits in 16 bits, use 16-bit division

	// save and disable interrupt
	irq_lock r12			// save interrupt into R12, disable interrupt
	ldr	r3,=SIO_BASE		// get address of SIO base

    // (R1:R0) aaaa'aaaa'----'---- / (R2) bbbb -> (R1) cccc'cccc'----'---- + (R2) 0000'dddd'----'----

	// start operation
	str	r1,[r3,#0x60]		// set unsigned dividend 'a' bits 32..63
	str	r2,[r3,#0x64]		// set unsigned divisor 'b' ... we will not need to set divisor again

	// [4] delay (we need total delay [8])
	nop4				// [4] delay 4 clock cycles

	// [3] push registers R4 and R5
	push	{r4, r5}		// [3] push registers R4 and R5

	// [1] get bits 16..32 of dividend 'a' into R4
	lsrs	r4,r0,#16		// [1] shift dividend 'a' 16 bits right, bits 16..32 -> R4

	// get result
	ldr	r2,[r3,#0x74]		// load remainder 'd' -> R2
	ldr	r1,[r3,#0x70]		// load result quotient 'c' high -> R1

    // (R2:R0) ----'aaaa'aaaa'---- / bbbb -> (R5) ----'cccc'cccc'---- + (R2) ----'0000'dddd'----

	// prepare new dividend 'a', middle bits
	lsls	r2,#16			// shift remainder 'd' 16 bits left
	orrs	r2,r4			// add dividend 'a' bits 16..31

	// start operation (divisor 'b' stays unchanged)
	str	r2,[r3,#0x60]		// set new unsigned dividend 'a'

	// [7] delay (we need total delay [8])
	nop6				// [6] delay 6 clock cycles
	nop				// [1]

	// [1] get bits 0..15 od dividend 'a' into R4
	uxth	r4,r0			// [1] load bits 0..15 od dividend 'a' -> R4

	// get result
	ldr	r2,[r3,#0x74]		// load remainder 'd' -> R2
	ldr	r5,[r3,#0x70]		// load quotient 'c' -> R5

    // (R2:R0) ----'----'aaaa'aaaa / bbbb -> (R0) ----'----'cccc'cccc + (R2) ----'----'0000'dddd

	// prepare new dividend 'a', lower bits
	lsls	r2,#16			// shift remainder 'd' 16 bits left
	orrs	r2,r4			// add dividend 'a' bits 0..15

	// start operation (divisor 'b' stays unchanged)
	str	r2,[r3,#0x60]		// set new unsigned dividend 'a'

	// [6] delay (we need total delay [8])
	nop6				// [6] delay 6 clock cycles

	// [2] prepare middle quotient
	lsls	r4,r5,#16		// get middle quotient 'c' low bits 16..31 -> R4
	lsrs	r5,#16			// middle quotient 'c' bits high bits 32..47 -> R5

	// get result
	ldr	r2,[r3,#0x74]		// load result remainder 'd'-> R2
	ldr	r0,[r3,#0x70]		// load result quotient 'c' low -> R0

	// add previsou result quotient
	adds	r0,r4			// add result quotient 'c' low
	adcs	r1,r5			// add result quotient 'c' high with carry
	movs	r3,#0			// clear result remainder 'd' high

	// restore interrupt
	irq_unlock r12			// restore interrupt from R12

	// restore registers R4, R5 and return
	pop	{r4, r5}		// pop registers R4 and R5
	bx	lr			// return


// ---- dividend 'a' is greater than 32 bits, divisor 'b' is greater than 16 bits, use slow division

DivU64_1:
	movs	r3,#0

DivU64_2:

// Registers:
//   R1:R0 ... dividend 'a' (numerator) and quotient 'c'
//   R3:R2 ... divisor 'b' (denominator)
//   R5:R4 ... remainder
//   R6 ... counter
//   R12 ... loop decrement (= -1)

	// save registers R4, R5 and R6
	push	{r4-r6}

	// clear remainder
	movs	r4,#0
	movs	r5,#0

	// number of loops -> R6, loop decrement -> R12
	movs	r6,#1			// loop increment
	negs	r6,r6			// loop decrement -1
	mov	r12,r6			// loop decrement -> R12
	movs	r6,#64			// number of bits -> R6

	// shift dividend left, get highest bit -> carry
	adds	r0,r0
	adcs	r1,r1

	// shift remainder left (on input: carry from dividend)
2:	adcs	r4,r4
	adcs	r5,r5

	// try to subtract divisor from remainder
	subs	r4,r2
	sbcs	r5,r3
	bcs	4f			// remainder >= divisor, carry = 1

	// underflow (remainder < divisor), rollback subtraction
	adds	r4,r2
	adcs	r5,r3
	adds	r5,r5,#0		// clear carry flag

	// shift dividend left (on input: carry=0 if remainder < divisor)
4:	adcs	r0,r0
	adcs	r1,r1

	// loop counter (we must maintain carry)
	add	r6,r12			// derement loop counter
	tst	r6,r6			// test loop counter
	bne	2b			// next loop

	// get remainder
	movs	r2,r4
	movs	r3,r5

	// restore registers R4, R5, R6 and return
	pop	{r4-r6}			// restore registers
	bx	lr			// return

// ----------------------------------------------------------------------------
//                       Modulo signed S64 ModS64
// ----------------------------------------------------------------------------
//   a ... signed dividend s64
//   b ... signed divisor s64
//   result ... signed remainder s64 d=a%b
// Temporary disables interrupt to protect divider state.
// When dividing by zero, the result is undefined.
// s64 ModS64(s64 a, s64 b);

// input:
//  R1:R0 ... signed dividend s64 'a'
//  R3:R2 ... signed divisor s64 'b'
// output:
//  R1:R0 ... signed remainder s64 d=a%b

regular_func_text ModS64

	push	{lr}
	bl	DivS64
	mov	r0,r2
	mov	r1,r3
	pop	{pc}

// ----------------------------------------------------------------------------
//                       Modulo unsigned U64 ModU64
// ----------------------------------------------------------------------------
//   a ... unsigned dividend u64
//   b ... unsigned divisor u64
//   result ... unsigned remainder u64 d=a%b
// Temporary disables interrupt to protect divider state.
// When dividing by zero, the result is undefined.
// u64 ModU64(u64 a, u64 b);

// input:
//  R1:R0 ... unsigned dividend u64 'a'
//  R3:R2 ... unsigned divisor u64 'b'
// output:
//  R1:R0 ... unsigned remainder u64 d=a%b

regular_func_text ModU64

	push	{lr}
	bl	DivU64
	mov	r0,r2
	mov	r1,r3
	pop	{pc}

// ----------------------------------------------------------------------------
//                    Divide modulo signed S64 DivModS64
// ----------------------------------------------------------------------------
//   a ... signed dividend s64
//   b ... signed divisor s64
//   rem ... pointer to store remainder s64 d=a%b
//   result ... signed quotient s64 c=a/d
// Temporary disables interrupt to protect divider state.
// When dividing by zero, the result is undefined.
// s64 DivModS64(s64 a, s64 b, s64* rem);

// input:
//  R1:R0 ... signed dividend s64 'a'
//  R3:R2 ... signed divisor s64 'b'
//  [sp,#0] ... pointer to store signed remainder s64 d=a%b
// output:
//  R1:R0 ... unsigned quotient u64 c=a/b

regular_func_text DivModS64

	push	{r4,lr}
	bl	DivS64
	ldr	r4,[sp,#8]
	stmia	r4!, {r2,r3}
	pop	{r4,pc}

// ----------------------------------------------------------------------------
//                    Divide modulo unsigned U64 DivModU64
// ----------------------------------------------------------------------------
//   a ... unsigned dividend u64
//   b ... unsigned divisor u64
//   rem ... pointer to store remainder u64 d=a%b
//   result ... unsigned quotient u64 c=a/d
// Temporary disables interrupt to protect divider state.
// When dividing by zero, the result is undefined.
// u64 DivModU64(u64 a, u64 b, u64* rem);

// input:
//  R1:R0 ... unsigned dividend u64 'a'
//  R3:R2 ... unsigned divisor u64 'b'
//  [sp,#0] ... pointer to store unsigned remainder u64 d=a%b
// output:
//  R1:R0 ... unsigned quotient u64 c=a/b

regular_func_text DivModU64

	push	{r4,lr}
	bl	DivU64
	ldr	r4,[sp,#8]
	stmia	r4!, {r2,r3}
	pop	{r4,pc}

// ----------------------------------------------------------------------------
//                  Unsigned multiply u32*u32 with result u64
// ----------------------------------------------------------------------------
// u64 UMul(u32 a, u32 b);

regular_func_text UMul

// macro - unsigned multiply u32 * u32 -> u64
//  input: RX = u32 x
//         RY = u32 y
// output: RZH:RZL = u64 z (result)
// trashes: RT0, RT1, RT2
// - can have RZL=RX, in which case RX trashed.
// - can have RZH=RY, in which case RY trashed.
//.macro mul32_32_64 rx,ry,rzl,rzh,rt0,rt1,rt2

	push	{r4}
	mul32_32_64	r0, r1, r0, r1, r2, r3, r4
	pop	{r4}
	bx	lr

// ----------------------------------------------------------------------------
//                  Signed multiply s32*s32 with result s64
// ----------------------------------------------------------------------------
// s64 SMul(s32 a, s32 b);

regular_func_text SMul

// macro - signed multiply s32 * s32 -> s64
//  input: RX = s32 x
//         RY = s32 y
// output: RZH:RZL = s64 z (result)
// trashes: RT0, RT1, RT2
// - can have RZL=RX, in which case RX trashed.
// - can have RZH=RY, in which case RY trashed.
//.macro muls32_s32_64 rx,ry,rzl,rzh,rt0,rt1,rt2

	push	{r4}
	muls32_s32_64	r0, r1, r0, r1, r2, r3, r4
	pop	{r4}
	bx	lr

// ----------------------------------------------------------------------------
//                        Square u32*u32 with result u64
// ----------------------------------------------------------------------------
// u64 Sqr(u32);

regular_func_text Sqr

// macro - square u32 -> u64
//  input: RX = u32 x
// output: RZH:RZL = u64 z (result)
// trashes: RT0, RT1
// - can have RZH==RX or RZL==RX
//.macro square32_64 rx,rzl,rzh,rt0,rt1

	square32_64	r0, r0, r1, r2, r3
	bx	lr

// ----------------------------------------------------------------------------
//     Signed/unsigned multiply u64*u64 with result u64 (= __aeabi_lmul)
// ----------------------------------------------------------------------------
// u64 UMul64(u64 a, u64 b);
// s64 SMul64(s64 a, s64 b);

// input:
//  R1:R0 ... u64 'a'
//  R3:R2 ... u64 'b'
// output:
//  R1:R0 ... result u64 c=a*b
// destroys: R2, R12

regular_func_text UMul64
regular_func SMul64
wrapper_func __aeabi_lmul

	// aH*bL + bH*aL -> R12
	muls	r1,r2		// aH*bL -> R1
	muls	r3,r0		// bH*aL -> R3
	adds	r1,r3		// aH*bL + bH*aL
	mov	r12,r1		// save high result -> R12

	// bL(H)*aL(L) -> R3
	lsrs	r1,r2,#16	// bL(H) -> R1
	uxth	r3,r0		// aL(L) -> R3
	muls	r3,r1		// bL(H)*aL(L) -> R3

	push	{r4}		// push R4

	// aL(H)*bL(H) -> R1
	lsrs	r4,r0,#16	// aL(H) -> R4
	muls	r1,r4		// aL(H)*bL(H) -> R1

	// aL(L)*bL(L) -> R0
	uxth	r2,r2		// bL(L) -> R2
	uxth	r0,r0		// aL(L) -> R0
	muls	r0,r2		// aL(L)*bL(L) -> R0

	// bL(L)*aL(H) -> R2
	muls	r2,r4		// bL(L)*aL(H) -> R2

	// sum result LOW
	lsls	r4,r3,#16	// result LOW bL(H)*aL(L) -> R4
	lsrs	r3,#16		// result HIGH bL(H)*aL(L) -> R3
	adds	r0,r4		// add aL(L)*bL(L) + LOW bL(H)*aL(L) -> R0

	pop	{r4}

	// sum result HIGH
	adcs	r1,r3		// add aL(H)*bL(H) + HIGH bL(H)*aL(L) -> R1

	// sum result LOW #2
	lsls	r3,r2,#16	// result LOW bL(L)*aL(H) -> R3
	lsrs	r2,#16		// result HIGH bL(L)*aL(H) -> R2
	adds	r0,r3		// add result LOW + LOW bL(L)*aL(H)

	// sum result HIGH #2
	adcs	r1,r2		// add result HIGH + HIGH bL(L)*aL(H)

	// add high result
	add	r1,r12		// add result HIGH + aH*bL + bH*aL

	bx	lr

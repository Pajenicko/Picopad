
// ****************************************************************************
//
//                        Double-floating-point assembler
//
// ****************************************************************************
// Copyright (c) 2020 Mark Owen https://www.quinapalus.com - GPLv2 licence
// Copyright (c) 2020 Raspberry Pi (Trading) Ltd. - SPDX-License-Identifier: BSD-3-Clause
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../asm_include.inc"

	.syntax unified
	.cpu cortex-m0plus
	.thumb

#if USE_DOUBLE		// use double support


// macro - unpack double to unsigned mantissa
// input: RB:RA = double number
// output: RB:RA = unsigned mantissa with hidden implied '1' set (53 significant bits)
//         RE = exponent (-128 if zero, 1919 if infinity)
//         RS = sign (0 positive or 1 negative)
// trashes: RT
.macro mdunpack ra,rb,re,rs,rt

	// extract sign and exponent -> RE
	lsrs	\re,\rb,#20	// extract sign and exponent -> RE

	// isolate mantissa (destroy exponent) and add hidden implied bit '1' -> RB:RA
	subs	\rs,\re,#1	// exponent - 1 -> RS (to include implied 1)
	lsls	\rs,#20		// shift exponent-1 and sign back to position 20
	subs	\rb,\rs		// clear sign and exponent in mantissa, insert implied 1

	// isolate sign -> RS
	lsrs	\rs,\re,#11	// isolate sign bit

	// isolate exponent (destroy sign bit) -> RE
	lsls	\re,#21		// shift exponent left, destroy sign bit
	lsrs	\re,#21		// shift exponent back
	beq	l\@_1		// exponent is zero

	// check if exponent is infinity
	adds	\rt,\re,#1	// exponent + 1
	lsrs	\rt,#11		// check infinity (value == 0x800)
	beq	l\@_2		// not infinity

l\@_1:
	// exponent is zero or infinity
	movs	\ra,#0		// number low = 0
	movs	\rb,#1		// number high = 1
	lsls	\rb,#20		// shift hidden implied bit '1' to position 52
	subs	\re,#128	// exponent = -128 if zero, or 1919 if infinity
	lsls	\re,#12		// shift exponent to position 12
l\@_2:
.endm

// macro - unpack double to signed mantissa
// input: RB:RA = double number
// output: RB:RA = signed mantissa with hidden implied '1' set (53 significant bits)
//         RE = exponent (-128 if zero, 1919 if infinity)
// trashes: RT0, RT1
// +zero, +denormal -> exponent = -0x80000
// -zero, -denormal -> exponent = -0x80000
// +Inf, +NaN -> exponent = +0x77f000
// -Inf, -NaN -> exponent = +0x77e000
.macro mdunpacks ra,rb,re,rt0,rt1

	// extract sign and exponent -> RE
	lsrs	\re,\rb,#20	// extract sign and exponent -> RE

	// extract sign -> RT1
	lsrs	\rt1,\rb,#31

	// isolate mantissa (destroy exponent with sign) and add hidden implied bit '1'
	subs	\rt0,\re,#1	// exponent - 1 -> RT0 (to include implied 1)
	lsls	\rt0,#20	// shift exponent-1 and sign back to position 20
	subs	\rb,\rt0	// clear sign and exponent in mantissa, insert implied 1

	// isolate exponent (destroy sign bit)
	lsls	\re,#21		// shift exponent left, destroy sign bit
	bcc	l\@_1		// skip if number is positive

	// number is negative, negate mantissa
	mvns	\rb,\rb		// NOT mantissa high
	negs	\ra,\ra		// negate mantissa low
	bcc	l\@_1		// no carry
	adds	\rb,#1		// mantissa low = 0, add mantissa high + 1

l\@_1:
	// check if exponent is zero
	lsrs	\re,#21		// shift exponent back
	beq	l\@_2		// exponent is zero

	// check if exponent is infinity
	adds	\rt0,\re,#1	// exponent + 1 -> RT0
	lsrs	\rt0,#11	// check infinity (value == 0x800)
	beq	l\@_3		// not infinity
	subs	\re,\rt1	// exponent is infinity, subtract sign bit to get negative infinity

l\@_2:
	// exponent is zero or infinity
	movs	\ra,#0		// number low = 0
	lsls	\rt1,#1		// +ve: 0  -ve: 2
	adds	\rb,\rt1,#1	// +ve: 1  -ve: 3
	lsls	\rb,#30		// create +/-1 mantissa
	asrs	\rb,#10		// normalise mantissa
	subs	\re,#128
	lsls	\re,#12		// shift exponent to position 12
l\@_3:
.endm


// ==== basic arithmetic


// ----------------------------------------------------------------------------
//                        Reverse subtraction, y - a
// ----------------------------------------------------------------------------

section_text drsub

wrapper_func __aeabi_drsub

	// exchange operands
	eors	r0,r2
	eors	r2,r0
	eors	r0,r2

	eors	r1,r3
	eors	r3,r1
	eors	r1,r3

// ---- continue to function dsub (do not use *_text !)

// ----------------------------------------------------------------------------
//                         Subtraction, x - y
// ----------------------------------------------------------------------------
// double dsub(double x, double y);

regular_func dsub
wrapper_func __aeabi_dsub

	// push registers
	push	{r4-r7,lr}

	// change sign of 2nd argument
	movs	r4,#1		// R4 <- 1
	lsls	r4,#31		// R4 <- bit 31
	eors	r3,r4		// flip sign of second argument
	b	da_entry	// continue to dadd

// ----------------------------------------------------------------------------
//                         Addition, x + y
// ----------------------------------------------------------------------------
// double dadd(double x, double y);

regular_func dadd
wrapper_func __aeabi_dadd

	// push registers
	push	{r4-r7,lr}

da_entry:
	// unpack operands
// input: RB:RA = double number
// output: RB:RA = signed mantissa with hidden implied '1' set (53 significant bits)
//         RE = exponent (-128 if zero, 1919 if infinity)
// trashes: RT0, RT1
// +zero, +denormal -> exponent = -0x80000
// -zero, -denormal -> exponent = -0x80000
// +Inf, +NaN -> exponent = +0x77f000
// -Inf, -NaN -> exponent = +0x77e000
//.macro mdunpacks ra,rb,re,rt0,rt1

	mdunpacks r0,r1,r4,r6,r7 // unpack double x R1:R0 to mantissa xm R1:R0 and exponent xe R4, trashes R6, R7
	mdunpacks r2,r3,r5,r6,r7 // unpack double y R3:R2 to mantissa ym R3:R2 and exponent ye R5, trashes R6, R7

	// difference of exponents
	subs	r7,r5,r4	// ye-xe
	subs	r6,r4,r5	// xe-ye
	bmi	da_ygtx		// y > x

	// here xe>=ye: need to shift y down R6 places
	mov	r12,r4		// save exponent xe -> R12
	cmp	r6,#32		// number of shifts > 32 ?
	bge	da_xrgty	// xe is rather greater than ye

	// prepare sticky bits of ym
	adds	r7,#32		// R7 <- 32 + ye - xe
	movs	r4,r2		// R4 <- mantissa ym low
	lsls	r4,r4,r7	// R4 <- rounding bit + sticky bits

da_xgty0:
	// shift mantissa ym right, to be same exponent as x
	movs	r5,r3		// R5 <- mantissa ym high
	lsls	r5,r5,r7	// R5 <- shift mantissa ym high left
	lsrs	r2,r6		// shift mantissa ym low right
	asrs	r3,r6		// shift mantissa ym high right
	orrs	r2,r5		// add carry from mantissa ym high to mantissa ym low

da_add:
	// sum mantissas x += y (R4 contains sticky bits)
	adds	r0,r2
	adcs	r1,r3

da_pack:  // Pack result back ... here is: R1:R0 mantissa, R12 exponent, R4 rounding

	// get sign bit -> R3
	lsrs	r3,r1,#31	// get sign bit -> R3
	beq	1f		// result is positive

	// absolute value of the mantissa (negate mantissa R1:R0:R4)
	mvns	r1,r1		// not mantissa high
	mvns	r0,r0		// not mantissa low
	movs	r2,#0		// R2 <- 0
	negs	r4,r4		// negate mantissa sticky bits
	adcs	r0,r2		// carry to mantissa low
	adcs	r1,r2		// carry to mantissa high

	// check mantissa overflow - shift down required
1:	mov	r2,r12		// exponent -> R2
	lsrs	r5,r1,#21	// check highest 11 bits of the mantissa, if overflow
	bne	da_0		// mantissa is > 53 bits, shift down required

	// check if mantissa is normalised (must have 53 bits)
	lsrs	r5,r1,#20	// get highest 12 bits of mantissa high
	bne	da_1		// mantissa already normalised

	// check if mantissa is zero (zero mantissa cannot be normalised)
	cmp	r0,#0		// check mantissa low
	beq	da_5		// mantissa could be zero, check it

da_2:
	// shift result mantissa left, to normalise
	adds	r4,r4		// sticky bits << 1
	adcs	r0,r0		// mantissa low << 1
	adcs	r1,r1		// mantissa high << 1

	// adjust exponent
	subs	r2,#1		// eponent - 1
	lsrs	r5,r1,#20	// get highest 12 bits of mantissa high, to check normalisation
	beq	da_2		// not normalised yer, shift left one more time

da_1:
	// normalisation done, check rounding bit
	lsls	r4,#1		// check rounding bit
	bcc	da_3		// no rounding

da_4:
	// round mantissa up
	adds	r0,#1		// add mantissa low + 1 to round up
	bcc	2f		// no carry
	adds	r1,#1		// add mantissa high + 1

	// if sticky bits are = 0, round mantissa to even number
2:	cmp	r4,#0		// sticky bits are zero?
	bne	da_3		// not zero
	lsrs	r0,#1		// destroy bit 0
	lsls	r0,#1		// shift mantissa back

da_3:
	// check exponent underflow
	subs	r2,#1		// exponent - 1
	bmi	da_6		// exponent underflow or zero - limit to 0

	// check exponent overflow
	adds	r4,r2,#2	// exponent + 1
	lsrs	r4,#11		// check if exponent is >= 0x800
	bne	da_7		// exponent overflow

	// pack exponent and sign
	lsls	r2,#20		// shift exponent - 1 (do destroy hidden bit '1') to position 52
	add	r1,r2		// add exponent and mantissa high, destroy hidden bit '1'
	lsls	r3,#31		// shift sign bit to position 31
	add	r1,r3		// add sign bit to mantissa
	pop	{r4-r7,pc}	// pop registers and return

da_7:
	// exponent overflow - return signed infinity
	lsls	r1,r3,#31	// get sign -> R1
	ldr	r3,=0x7ff00000	// overflow value -> R1
	orrs	r1,r3		// add sign bit
	b	1f

da_6:
	// exponent underflow - return signed zero
	lsls	r1,r3,#31	// get sign -> R1
1:	movs	r0,#0		// mantissa low = 0
	pop	{r4-r7,pc}	// pop registers and return

da_5:
	// check if mantissa is zero (and cannot normalise it)
	cmp	r1,#0		// check mantissa high
	bne	da_2		// mantissa is not zero, can continue with normalisation
	cmp	r4,#0		// check sticky bits
	bne	da_2		// mantissa is not zero, can continue with normalisation

	// mantissa is zero, result will be 0
	pop {r4-r7,pc}		// pop registers and return

da_0:
	// shift mantissa down by 1 bit, to normalise it
	adds	r2,#1		// adjust exponent
	lsls	r6,r0,#31	// save rounding bit -> R6 bit 31
	lsrs	r0,#1		// shift mantissa low >> 1 bit
	lsls	r5,r1,#31	// get mantissa high lowest bit -> R5
	orrs	r0,r5		// add carry from mantissa high to mantissa low
	lsrs	r1,#1		// shift mantissa high >> 1 bit
	cmp	r6,#0		// rounding bit is set?
	beq	da_3		// rounding bit not set
	b	da_4		// round mantissa up

da_xrgty: 
	// xe is rather greater than ye (xe>ye and shift>=32 places)
	cmp	r6,#60		// number of shifts > 60 ?
	bge	da_xmgty	// xe is much greater than ye, result is just X

	subs	r6,#32		// number of shifts - 32
	adds	r7,#64		// 64 - number of shifts
	movs	r4,r2		// R4 <- mantissa ym low
	lsls	r4,r4,r7	// these would be shifted off the bottom of the sticky bits
	beq	1f		// sticky bits = 0
	movs	r4,#1

1:	lsrs	r2,r2,r6	// shift mantissa ym low right
	orrs	r4,r2		// add carry from ym low to sticky bits
	movs	r2,r3		// mantissa ym high -> R2
	lsls	r3,r3,r7	// shift mantissa ym high left
	orrs	r4,r3		// sum carry and mantissa high
	asrs	r3,r2,#31	// propagate sign bit
	b	da_xgty0

da_ygtx:
	// here ye>xe - need to shift x down R7 places
	mov	r12,r5		// save exponent -> R12
	cmp	r7,#32
	bge	da_yrgtx	// ye rather greater than xe
	adds	r6,#32
	movs	r4,r0
	lsls	r4,r4,r6	// rounding bit + sticky bits

da_ygtx0:
	// shift mantissa xm right, to be same exponent as y
	movs	r5,r1		// R5 <- mantissa xm high
	lsls	r5,r5,r6	// R5 <- shift mantissa xm high left
	lsrs	r0,r7		// shift mantissa xm low right
	asrs	r1,r7		// shift mantissa xm high right
	orrs	r0,r5		// add carry from mantissa xm high to mantissa xm low
	b	da_add		// sum mantissas

da_yrgtx:
	// ye rather greater than xe
	cmp	r7,#60		// number of shits > 60 ?
	bge	da_ymgtx	// ye is much greater than xe, result is just Y

	subs	r7,#32		// number of shifts - 32
	adds	r6,#64		// 64 - number of shifts
	movs	r4,r0		// R4 <- mantissa xm low
	lsls	r4,r4,r6	// these would be shifted off the bottom of the sticky bits
	beq	1f		// sticky bits = 0
	movs	r4,#1

1:	lsrs	r0,r0,r7	// shift mantissa xm low right
	orrs	r4,r0		// add carry from xm low to sticky bits
	movs	r0,r1		// mantissa xm high -> R0
	lsls	r1,r1,r6	// shift mantissa xm high left
	orrs	r4,r1		// sum carry and mantissa high
	asrs	r1,r0,#31	// propagate sign bit
	b	da_ygtx0

da_ymgtx:
	// ye is much greater than xe, result is just Y
	movs	r0,r2		// use Y as result
	movs	r1,r3

da_xmgty:
	// xe is much greater than ye, result is just X
	movs	r4,#0		// clear sticky bits
	b	da_pack		// pack result back

// ----------------------------------------------------------------------------
//                             Square, x^2
// ----------------------------------------------------------------------------
// double dsqr(double x);

regular_func_text dsqr
wrapper_func __aeabi_dsqr

	// duplicate operand
	movs	r2,r0
	movs	r3,r1

// ---- continue to dmul (do not use *_text !)

// ----------------------------------------------------------------------------
//                        Multiplication, x * y
// ----------------------------------------------------------------------------
// double dmul(double x, double y);

regular_func dmul
wrapper_func __aeabi_dmul

	// push registers R4..R7 and LR
	push	{r4-r7,lr}

	// unpack numbers
// macro - unpack double to unsigned mantissa
// input: RB:RA = double number
// output: RB:RA = unsigned mantissa with hidden implied '1' set (53 significant bits, 11 unused bits)
//         RE = exponent (-128 if zero, 1919 if infinity)
//         RS = sign (0 positive or 1 negative)
// trashes: RT
//.macro mdunpack ra,rb,re,rs,rt

	mdunpack r0,r1,r4,r6,r5	// unpack number x in R1:R0 -> R1:R0 mantissa xm, R4 exponent xe, R6 sign xs
	mov	r12,r4		// save exponent xe -> R12
	mdunpack r2,r3,r4,r7,r5	// unpack number y in R3:R2 -> R3:R2 mantissa ym, R4 exponent ye, R7 sign ys

	// prepare sign of result -> R7
	eors	r7,r6		// sign of result -> R7

	// prepare exponent of result -> R4
	add	r4,r12		// exponent of result -> R4

// Here is:
//  R0 = xmL
//  R1 = xmH
//  R2 = ymL
//  R3 = ymH
//  R4 = result exponent
//  R7 = sign of result

	// save registers
	push	{r0-r2,r4,r7}

	// xmL * ymL -> M0 R5:R12
// macro - unsigned multiply u32 * u32 -> u64
//  input: RX = u32 x
//         RY = u32 y
// output: RZH:RZL = u64 z (result)
// trashes: RT0, RT1, RT2
// - can have RZL=RX, in which case RX trashed.
// - can have RZH=RY, in which case RY trashed.
//.macro mul32_32_64 rx,ry,rzl,rzh,rt0,rt1,rt2

	mul32_32_64 r0,r2, r0,r5, r4,r6,r7 // xmL (R0) * ymL (R2) -> M0 (R5:R0), trashes R4, R6, R7
	mov	r12,r0		// save M0 low

// Here is:
//  R1 = xmH
//  R2 = ymL
//  R3 = ymH
//  R5 = M0H
//  R12 = M0L

	// xmH * ymH -> M3 R7:R6
	mul32_32_64 r1,r3, r6,r7, r0,r2,r4 // xmH (R1) * ymH (R3) -> M3 (R7:R6), trashes R0, R2, R4
	pop	{r0}		// xmL

// Here is:
//  R0 = xmL
//  R1 = xmH
//  R3 = ymH
//  R5 = M0H
//  R6 = M3L
//  R7 = M3H
//  R12 = M0L

	// xmL * ymH -> M1 R3:R0
	mul32_32_64 r0,r3, r0,r3, r1,r2,r4 // xmL (R0) * ymH (R3) -> M1 (R3:R0), trashes R1, R2, R4

// Here is:
//  R0 = M1L
//  R3 = M1H
//  R5 = M0H
//  R6 = M3L
//  R7 = M3H
//  R12 = M0L

	// add middle part M1 to high and low M3:M0 -> R7:R6:R5:R12
	adds	r5,r0		// M0H + M1L -> R5
	adcs	r6,r3		// M3L + M1H + carry -> R6
	movs	r0,#0		// R0 <- 0
	adcs	r7,r0		// M3H + carry -> R7
	pop	{r1,r2}		// xmH, ymL

// Here is:
//  R0 = 0
//  R1 = xmH
//  R2 = ymL
//  R3 = M1H
//  R5 = M0H+M1L
//  R6 = M3L+M1H
//  R7 = M3H
//  R12 = M0L

	// xmH * ymL -> M2 R2:R1
	mul32_32_64 r1,r2, r1,r2, r0,r3,r4 // xmH (R1) * ymL (R2) -> M2 (R2:R1), trashes R0, R3, R4

// Here is:
//  R1 = M2L
//  R2 = M2H
//  R5 = M0H+M1L
//  R6 = M3L+M1H
//  R7 = M3H
//  R12 = M0L

	// add middle part M2 to high and low M3:M0 -> R7:R6:R5:R12
	adds	r5,r1		// M0H+M1L + M2L -> R5
	adcs	r6,r2		// M3L+M1H + M2H -> R6
	movs	r0,#0		// R0 <- 0
	adcs	r7,r0		// M3H + carry -> R7

// Here is: R7:R6:R5:R12 product of mantissas xm*ym (22 unused bits + 106 significant bits)

	// restore exponent -> R3, and sign -> R4
	pop	{r3,r4}		// exponent in r3, sign in r4

	// shift result mantissa to normal position, shift 11 bits left -> R1:R0(:R5), extra low bits R12
	lsls	r1,r7,#11	// R7 shift 11 bits left -> R1
	lsrs	r2,r6,#21	// R6 shift 21 (=32-11) bits right -> R2
	orrs	r1,r2		// assemble mantissa high -> R1

	lsls	r0,r6,#11	// R6 shift 11 bits left -> R0
	lsrs	r2,r5,#21	// R5 shift 21 (=32-11) bits right -> R2
	orrs	r0,r2		// assembler mantissa low -> R0

	lsls	r5,#11		// shift sticky bits 11 bits left -> R5 (extra bits stay in R12)

	// check highest bit, if result mantissa is normalised
	lsrs	r2,r1,#20	// check bit 52 -> R2
	bne	1f		// mantissa is normalised OK

	// mantissa is not normalized, shift mantissa 1 bit left (and correct exponent + 1)
	adds	r5,r5		// shift R5 left
	adcs	r0,r0		// shift R0 left + carry
	adcs	r1,r1		// shift R1 left + carry
	subs	r3,#1		// correct exponent

	// exponent bias correction
1:	ldr	r6,=0x3ff	// correction 1023
	subs	r3,r6		// correct for exponent bias, exp - 1023

	// check exponent overflow or underflow
	lsls	r6,#1		// R6 = 0x7fe
	cmp	r3,r6		// check exponent
	bhs	dm_0		// exponent over- or underflow

	// check sticky bits, if rounding is needed
	lsls	r5,#1		// rounding bit to carry
	bcc	1f		// result is correctly rounded

	// add mantissa + 1 to round up
	adds	r0,#1		// mantissa low + 1
	movs	r6,#0		// R6 <- 0
	adcs	r1,r6		// mantissa high + carry

	// check remaining sticky bits - if they are zero, round to even
	mov	r6,r12		// remaining sticky bits
	orrs	r5,r6		// check sticky bits
	bne	1f		// some sticky bits are set
	lsrs	r0,#1		// discard bit 0 (to round to even)
	lsls	r0,#1		// shift back

	// add exponent to result
1:	lsls	r3,#20		// shift exponent to position 20
	adds	r1,r3		// add exponent to mantissa

dm_2:
	// add sign bit to result
	lsls	r4,#31		// shift sign bit to position 31
	add	r1,r4		// add sign bit to result
	pop	{r4-r7,pc}	// restore registers and return

dm_0:
	// here for exponent over- or underflow
	bge	dm_1		// overflow

	// exponent underflow
	adds	r3,#1		// would-be zero exponent?
	bne	1f		// underflow, not zero

	// result is near zero
	adds	r0,#1		// check is mantissa low is 0xfff...
	bne	1f		// not all-ones, go underflow
	adds	r1,#1		// check is mantissa high is 0xfff...
	lsrs	r7,r1,#21	// check is mantissa is all-ones
	beq	1f		// not all-ones
	lsrs	r1,#1		// mantissa is 0xfff with exponent 0
	b	dm_2		// add sign bit

	// exponent underflow, result is +0.0 or -0.0
1:	lsls	r1,r4,#31	// shift sign bit to position 31 -> R1
	movs	r0,#0		// mantissa low = 0
	pop	{r4-r7,pc}	// restore registers and return

dm_1:
	// here for exponent overflow
	adds	r6,#1		// R6 = 0x7ff, exponent overflow
	lsls	r1,r6,#20	// shift exponent to position 20 -> R1
	movs	r0,#0		// mantissa low = 0
	b	dm_2		// add sign bit

// ----------------------------------------------------------------------------
//                        Reciprocal 1 / x
// ----------------------------------------------------------------------------
// double drec(double x);

regular_func_text drec

	// first operand is 1.0
	movs	r3,r1
	movs	r2,r0
	ldr	r1,=0x3ff00000
	movs	r0,#0

// ---- continue to function ddiv (do not use *_text !)

// ----------------------------------------------------------------------------
//                         Division, y / x
// ----------------------------------------------------------------------------
// double ddivd(double y, double x);

regular_func ddiv
wrapper_func __aeabi_ddiv

// Approach to division y/x is as follows.
//
// First generate u1, an approximation to 1/x to about 29 bits. Multiply this by the top
// 32 bits of y to generate a0, a first approximation to the result (good to 28 bits or so).
// Calculate the exact remainder r0=y-a0*x, which will be about 0. Calculate a correction
// d0=r0*u1, and then write a1=a0+d0. If near a rounding boundary, compute the exact
// remainder r1=y-a1*x (which can be done using r0 as a basis) to determine whether to
// round up or down.
//
// The calculation of 1/x is as given in dreciptest.c. That code verifies exhaustively
// that | u1*x-1 | < 10*2^-32.
//
// More precisely:
//
// x0=(q16)x;
// x1=(q30)x;
// y0=(q31)y;
// u0=(q15~)"(0xffffffffU/(unsigned int)roundq(x/x_ulp))/powq(2,16)"(x0);
//          q15 approximation to 1/x, "~" denotes rounding rather than truncation
// v=(q30)(u0*x1-1);
// u1=(q30)u0-(q30~)(u0*v);
//
// a0=(q30)(u1*y0);
// r0=(q82)y-a0*x;
// r0x=(q57)r0;
// d0=r0x*u1;
// a1=d0+a0;
//
// Error analysis
//
// Use Greek letters to represent the errors introduced by rounding and truncation.
//
//               r0 = y - a0x
//                  = y - [ u1 ( y - alpha ) - beta ] x    where 0 <= alpha < 2^-31, 0 <= beta < 2^-30
//                  = y ( 1 - u1*x ) + ( u1*alpha + beta) x
//
//     Hence
//
//       | r0 / x | < 2 * 10*2^-32 + 2^-31 + 2^-30
//                  = 26*2^-32
//
//               r1 = y - a1x
//                  = y - a0x - d0x
//                  = r0 - d0x
//                  = r0 - u1 ( r0 - lambda ) x    where 0 <= lambda < 2^-57
//                  = r0 ( 1 - u1x ) + u2*lambda*x
//
//     Hence
//
//       | r1 / x | < 26*2^-32 * 10*2^-32 + 2^-57
//                  = (260+128)*2^-64
//                  < 2^-55
//
// Empirically it seems to be nearly twice as good as this.
//
// To determine correctly whether the exact remainder calculation can be skipped we need a result
// accurate to < 0.25ulp. In the case where x>y the quotient will be shifted up one place for normalisation
// and so 1ulp is 2^-53 and so the calculation above suffices.

	// push registers
	push	{r4-r7,lr}

	// unpack divisor x R3:R2 -> R3:R2 mantissa xm, R4 exponent xe, R7 sign xs, R6 temporary
// macro - unpack double to unsigned mantissa
// input: RB:RA = double number
// output: RB:RA = unsigned mantissa with hidden implied '1' set (53 significant bits)
//         RE = exponent (-128 if zero, 1919 if infinity)
//         RS = sign (0 positive or 1 negative)
// trashes: RT
//.macro mdunpack ra,rb,re,rs,rt
	mdunpack r2,r3,r4,r7,r6	// unpack divisor

	// lock interrupts
	push	{r2}		// save register R2
	irq_lock r2		// save interrupt into R2, disable interrupt

	// prepare to calculate 1/x (1/divisor)
	movs	r5,#DIV_PORT>>24 // divider port>>24 -> R5
	lsls	r5,#24		// R5 <- divider port
	movs	r6,#0		// R6 <- 0
	mvns	r6,r6		// R6 <- -1
	str	r6,[r5,#DIV_UDIVIDEND] // dividend = -1
	lsrs	r6,r3,#4	// x0=(q16)x (53 - 4 - 32 = 17 bits)
	str	r6,[r5,#DIV_UDIVISOR] // set divisor = x

	// prepare result sign bit in R12
	lsrs	r6,r1,#31	// sign bit of dividend y -> R6
	adds	r6,r7		// add sign of xs
	mov	r12,r6		// store result sign in r12 bit0 (r12 bit1 is trashed)

	// prepare exponent of dividend ye	
	lsls	r1,#1		// destroys sign bit from dividend y (shift 1 bit left)
	lsrs	r7,r1,#21	// exponent of dividen ye -> R7
	beq	1f		// zero exponent of y

	// check infinity of dividend ye
	adds	r6,r7,#1	// exponent of y + 1 to check infinity
	lsrs	r6,#11		// check infinity
	beq	2f		// y is not infinity (exponent != 0x7ff)

	// dividend y is zero or infinity
1:	movs	r0,#0		// R0 <- 0
	movs	r1,#0		// R1 <- 0
	subs	r7,#64		// less drastic fiddling of exponents to get 0/0, Inf/Inf correct
	lsls	r7,#12

	// isolate mantissa of dividend y
2:	subs	r6,r7,r4	// result exponent y - x -> R6
	lsls	r6,#2		// result exponent * 4
	add	r12,r12,r6	// store signed exponent into r12[31..8]
	subs	r7,#1		// exponent y - 1, to add hidden implied bit '1' to mantissa
	lsls	r7,#21		// shift exponent to position 21
	subs	r1,r7		// isolate mantissa of y and add hidden implied bit '1'
	lsrs	r1,#1		// shift mantissa back to its position

	// get result of division 1/x -> R6
	ldr	r6,[r5,#DIV_QUOTIENT]

	// restore interrupt
	irq_unlock r2		// restore interrupt from R2
	pop	{r2}

	// round 1/x division up (first approximation u0)
	adds	r6,#1		// result + 1
	lsrs	r6,#1		// (result + 1)/2

// Here is:
//  R1:R0 = mantissa ymH:ymL
//  R3:R2 = mantissa xmH:xmL
//  R6 = u0, first approximation to 1/x Q15
//  R12: result sign and exponent

	// get second approximation
	lsls	r4,r3,#10	// R4 <- mantissa xmH << 10
	lsrs	r5,r2,#22	// R5 <- mantissa xmL >> 22
	orrs	r5,r4		// x1=(q30)x, mantissa xm << 10

	// v=(q30)(u0*x1-1);
	muls	r5,r6		// x1*u0 Q45
	asrs	r5,#15		// v=u0*x1-1 Q30

	// u1=(q30)u0-(q30~)(u0*v);
	muls	r5,r6		// v*u0 Q45
	asrs	r5,#14
	adds	r5,#1
	asrs	r5,#1		// round u0*v to Q30
	lsls	r6,#15
	subs	r6,r5		// u1 Q30 (=u0-u0*v)

// Here is:
//  R1:R0 = mantissa ymH:ymL
//  R3:R2 = mantissa xmH:xmL
//  R6 = u1, second approximation to 1/x Q30
//  R12: result sign and exponent

	// get a0=(q30)(u1*y0);
	push	{r2,r3}
	lsls	r4,r1,#11
	lsrs	r5,r0,#21
	orrs	r4,r5		// y0=(q31)y
	mul32_32_64 r4,r6, r4,r5, r2,r3,r7  // y0*u1 Q61
	adds	r4,r4
	adcs	r5,r5		// a0=(q30)(y0*u1)

// Here is:
//  R1:R0 = mantissa ymH:ymL
//  R5 = a0, first approximation to y/x Q30
//  R6 = u1, second approximation to 1/x Q30
//  R12: result sign and exponent

	// get r0=(q82)y-a0*x, r0x=(q57)r0;
	ldr	r2,[r13,#0]	// xL
	mul32_32_64 r2,r5, r2,r3, r1,r4,r7  // xL*a0
	ldr	r4,[r13,#4]	// xH
	muls	r4,r5		// xH*a0
	adds	r3,r4		// r2:r3 now x*a0 Q82
	lsrs	r2,#25
	lsls	r1,r3,#7
	orrs	r2,r1		// r2 now x*a0 Q57; r7:r2 is x*a0 Q89
	lsls	r4,r0,#5	// y Q57
	subs	r0,r4,r2	// r0x=y-x*a0 Q57 (signed)

// here
// r0  r0x Q57
// r5  a0, first approximation to y/x Q30
// r4  yL  Q57
// r6  u1 Q30
// r12 result sign, exponent

	muls32_32_64 r0,r6, r7,r6, r1,r2,r3   // r7:r6 r0x*u1 Q87
	asrs	r3,r6,#25
	adds	r5,r3
	lsls	r3,r6,#7	// r3:r5 a1 Q62 (but bottom 7 bits are zero so 55 bits of precision after binary point)

// here we could recover another 7 bits of precision (but not accuracy) from the top of r7
// but these bits are thrown away in the rounding and conversion to Q52 below

// here
// r3:r5  a1 Q62 candidate quotient [0.5,2) or so
// r4     yL Q57
// r12    result sign, exponent

	movs	r6,#0
	adds	r3,#128		// for initial rounding to Q53
	adcs	r5,r5,r6
	lsrs	r1,r5,#30
	bne	dd_0

// here candidate quotient a1 is in range [0.5,1)
// so 30 significant bits in r5

	lsls	r4,#1		// y now Q58
	lsrs	r1,r5,#9	// to Q52
	lsls	r0,r5,#23
	lsrs	r3,#9		// 0.5ulp-significance bit in carry: if this is 1 we may need to correct result
	orrs	r0,r3
	bcs	dd_1
	b	dd_2
dd_0:

// here candidate quotient a1 is in range [1,2)
// so 31 significant bits in r5

	movs	r2,#4
	add	r12,r12,r2	// fix exponent; r3:r5 now effectively Q61
	adds	r3,#128		// complete rounding to Q53
	adcs	r5,r5,r6
	lsrs	r1,r5,#10
	lsls	r0,r5,#22
	lsrs	r3,#10		// 0.5ulp-significance bit in carry: if this is 1 we may need to correct result
	orrs	r0,r3
	bcc	dd_2
dd_1:

// here
// r0:r1  rounded result Q53 [0.5,1) or Q52 [1,2), but may not be correctly rounded-to-nearest
// r4     yL Q58 or Q57
// r12    result sign, exponent
// carry set

	adcs	r0,r0,r0
	adcs	r1,r1,r1	// z Q53 with 1 in LSB
	lsls	r4,#16		// Q105-32=Q73
	ldr	r2,[r13,#0]	// xL Q52
	ldr	r3,[r13,#4]	// xH Q20

	movs	r5,r1		// zH Q21
	muls	r5,r2		// zH*xL Q73
	subs	r4,r5
	muls	r3,r0		// zL*xH Q73
	subs	r4,r3
	mul32_32_64 r2,r0, r2,r3, r5,r6,r7  // xL*zL
	negs	r2,r2		// borrow from low half?
	sbcs	r4,r3		// y-xz Q73 (remainder bits 52..73)

	cmp	r4,#0

	bmi	1f
	movs	r2,#0		// round up
	adds	r0,#1
	adcs	r1,r2

1:	lsrs	r0,#1		// shift back down to Q52
	lsls	r2,r1,#31
	orrs	r0,r2
	lsrs	r1,#1
dd_2:
	add	r13,#8
	mov	r2,r12
	lsls	r7,r2,#31	// result sign
	asrs	r2,#2		// result exponent
	ldr	r3,=0x3fd
	adds	r2,r3
	ldr	r3,=0x7fe
	cmp	r2,r3
	bhs	dd_3		// over- or underflow?
	lsls	r2,#20
	adds	r1,r2		// pack exponent
dd_5:
	adds	r1,r7		// pack sign
	pop	{r4-r7,pc}

dd_3:
	movs	r0,#0
	cmp	r2,#0
	bgt	dd_4		// overflow?
	movs	r1,r7
	pop	{r4-r7,pc}

dd_4:
	adds	r3,#1		// 0x7ff
	lsls	r1,r3,#20
	b	dd_5


// ==== comparison

// ----------------------------------------------------------------------------
//               Reverse compare, y ? x (internal aeabi function)
// ----------------------------------------------------------------------------
// Input: R0 = 1st operand 'x'
//	  R1 = 2nd operand 'y'
// Output set flags Z (x==y) and C (x<=y) as with "cmp y,x"
// Saves all registers.

wrapper_func_text __aeabi_cdrcmple

	// save registers R0..R5 and LR
	push	{r0-r5,lr}

	// exchange operands
	eors	r0,r2
	eors	r2,r0
	eors	r0,r2

	eors	r1,r3
	eors	r3,r1
	eors	r1,r3
	b	__aeabi_drcmp_2

// ----------------------------------------------------------------------------
//                   Compare, x ? y (internal aeabi function)
// ----------------------------------------------------------------------------
// Input: R0 = 1st operand 'x'
//	  R1 = 2nd operand 'y'
// Output set flags Z (x==y) and C (x>=y) as with "cmp x,y"
// Saves all registers.

wrapper_func __aeabi_cdcmple
wrapper_func __aeabi_cdcmpeq

	// save registers R0..R4, r5 and LR
	push	{r0-r5,lr}

__aeabi_drcmp_2:

	// prepare infinity exponent -> F5
	ldr	r5,=#0x7ff	// flush NaNs and denormals

	// check if 1st operand is zero
	lsls	r4,r1,#1	// shift 1 bit left, get 1st operand 'x' without sign -> R4
	lsrs	r4,#21		// shift right, get exponent of 1st number - number is 0 if exponent is 0
	beq	1f		// 1st operand is zero

	// check if 1st operand is infinity
	cmp	r4,r5		// is 1st operand infinity?
	bne	2f		// 1st operand is in normal range

	// 1st operand is zero or infinity, clear mantissa
1:	movs	r0,#0		// mantissa low = 0
	lsrs	r1,#20		// clear mantissa high
	lsls	r1,#20		// return exponent back

	// check if 2nd operand is zero
2:	lsls	r4,r3,#1	// shift 1 bit left, get 2nd operand 'y' without sign -> R4
	lsrs	r4,#21		// shift right, get exponent of 2nd number - number is 0 if exponent is 0
	beq	1f		// 2nd operand is zero

	// check if 2nd operand is infinity
	cmp	r4,r5		// is 2nd operand infinity?
	bne	2f		// 2nd operand is in normal range

	// 2nd operand is zero or infinity, clear mantissa
1:	movs	r2,#0		// mantissa low = 0
	lsrs	r3,#20		// clear mantissa high
	lsls	r3,#20		// return exponent back

	// compare signs
2:	eors	r3,r1		// compare signs 
	bmi	4f		// opposite signs, can proceed with sign of x

	// identical signs - check sign of 'y'
	eors	r3,r1		// restore 'y'
	bpl	2f		// 'y' is positive or zero

	// both numbers are negative, reverse compare 'y' with 'x'
	cmp	r3,r1		// compare 'y' with 'x' high
	bne	7f
1:	cmp	r2,r0		// compare 'y' with 'x' low
7:	pop	{r0-r5,pc}

	// both numbers are positive, compare 'x' with 'y'
2:	cmp	r1,r3		// compare 'x' with 'y' high
	bne	7b
1:	cmp	r0,r2		// compare 'x' with 'y' low
	pop	{r0-r5,pc}

	// signs are opposite, compare zero (ignore sign flag)
4:	orrs	r3,r1		// check zero numbers
	adds	r3,r3		// set C flag (sign bit was set)
	orrs	r3,r0
	orrs	r3,r2
	beq	7b		// numbers was equal (sign flag of zero ignored)

	// signs are opposite, compare only 
	mvns	r1,r1		// carry inverse of 'x' sign
	adds	r1,r1		// carry set if 'x' was positive (x > y)
	pop	{r0-r5,pc}

// ----------------------------------------------------------------------------
//                        Compare, x ? y
// ----------------------------------------------------------------------------
// Returns: 0 if x==y, -1 if x<y, +1 if x>y
// s8 dcmp(double x, double y);

regular_func_text dcmp

	// save registers R4,R5 and LR
	push	{r4,r5,lr}

dcmp_2:

	// prepare infinity exponent -> F5
	ldr	r5,=#0x7ff	// flush NaNs and denormals

	// check if 1st operand is zero
	lsls	r4,r1,#1	// shift 1 bit left, get 1st operand 'x' without sign -> R4
	lsrs	r4,#21		// shift right, get exponent of 1st number - number is 0 if exponent is 0
	beq	1f		// 1st operand is zero

	// check if 1st operand is infinity
	cmp	r4,r5		// is 1st operand infinity?
	bne	2f		// 1st operand is in normal range

	// 1st operand is zero or infinity, clear mantissa
1:	movs	r0,#0		// mantissa low = 0
	lsrs	r1,#20		// clear mantissa high
	lsls	r1,#20		// return exponent back

	// check if 2nd operand is zero
2:	lsls	r4,r3,#1	// shift 1 bit left, get 2nd operand 'y' without sign -> R4
	lsrs	r4,#21		// shift right, get exponent of 2nd number - number is 0 if exponent is 0
	beq	1f		// 2nd operand is zero

	// check if 2nd operand is infinity
	cmp	r4,r5		// is 2nd operand infinity?
	bne	2f		// 2nd operand is in normal range

	// 2nd operand is zero or infinity, clear mantissa
1:	movs	r2,#0		// mantissa low = 0
	lsrs	r3,#20		// clear mantissa high
	lsls	r3,#20		// return exponent back

	// compare signs
2:      movs	r5,#1		// preset result, +1 if x>y
	eors	r3,r1		// compare signs 
	bmi	4f		// opposite signs, can proceed with sign of x

	// identical signs, check sign of 'y'
	eors	r3,r1		// restore 'y'
	bpl	1f		// 'y' is positive or zero
	negs	r5,r5		// result will be -1, x<y

	// identical signs, compare 'x' and 'y'
1:	cmp	r1,r3		// compare 'x' and 'y' high
	bne	1f		// high not equal
	cmp	r0,r2		// compare 'x' and 'y' low
	bhi	2f		// 'x' > 'y', return result
	blo	3f		// 'x' < 'y', negate result
5:	movs	r5,#0		// result is 0 if numbers are equal
1:	bgt	2f		// 'x' > 'y', result result
3:	negs	r5,r5		// negate result

	// move result from R5 to R0
2:	subs	r0,r5,#0	// copy and set flags
	pop	{r4,r5,pc}	// pop registers and return

	// opposite signs
4:	orrs	r3,r1		// check zero numbers
	adds	r3,r3		// set C flag (sing bit was set)
	orrs	r3,r0
	orrs	r3,r2
	beq	5b		// numbers was equal (sign flag or zero ignored)

	// signs are opposite, compare only 
	cmp	r1,#0		// check if number 'x' is negative
	bge	2b		// number 'x' is positive, result will be +1 (x>y)
	b	3b		// invert result to -1 (x<y)

// ----------------------------------------------------------------------------
//                        Compare if x==y
// ----------------------------------------------------------------------------
// Bool dcmpeq(double x, double y);

regular_func_text dcmpeq
wrapper_func __aeabi_dcmpeq

	push	{lr}
	bl	__aeabi_cdcmpeq		// compare numbers
	beq	1f			// numbers are equal x==y
	movs	r0,#0			// result False
	pop	{pc}

1:	movs	r0,#1			// result True
	pop	{pc}

// ----------------------------------------------------------------------------
//                        Compare if x<y
// ----------------------------------------------------------------------------
// Bool dcmplt(double x, double y);

regular_func_text dcmplt
wrapper_func __aeabi_dcmplt

	push	{lr}
	bl	__aeabi_cdcmple		// compare numbers
	sbcs	r0,r0			// set to -1 if x<y
	negs	r0,r0			// negate, result 0 or +1
	pop	{pc}

// ----------------------------------------------------------------------------
//                        Compare if x<=y
// ----------------------------------------------------------------------------
// Bool dcmple(double x, double y);

regular_func_text dcmple
wrapper_func __aeabi_dcmple

	push	{lr}
	bl	__aeabi_cdcmple		// compare numbers
	bls	1f			// numbers are x<=y
	movs	r0,#0			// result False
	pop	{pc}

1:	movs	r0,#1			// result True
	pop	{pc}

// ----------------------------------------------------------------------------
//                        Compare if x>=y
// ----------------------------------------------------------------------------
// Bool dcmpge(double x, double y);

regular_func_text dcmpge
wrapper_func __aeabi_dcmpge

	push	{lr}
	bl	__aeabi_cdrcmple	// reverse compare numbers
	bls	1f			// numbers are x<=y
	movs	r0,#0			// result False
	pop	{pc}

1:	movs	r0,#1			// result True
	pop	{pc}

// ----------------------------------------------------------------------------
//                        Compare if x>y
// ----------------------------------------------------------------------------
// Bool dcmpgt(double x, double y);

regular_func_text dcmpgt
wrapper_func __aeabi_dcmpgt

	push	{lr}
	bl	__aeabi_cdrcmple	// reverse compare numbers
	sbcs	r0,r0			// set to -1 if x>y
	negs	r0,r0			// negate, result 0 or +1
	pop	{pc}

// ----------------------------------------------------------------------------
//          Check if comparison is unordered (either input is NaN)
// ----------------------------------------------------------------------------
// Bool dcmpun(double x, double y);

regular_func_text dcmpun
wrapper_func __aeabi_dcmpun

	// check if exponent of 'x' is NaN (= 0x7ff)
	movs	r0,#1			// R0 <- 1
	lsls	r0,#21			// R0 <- shift '1' to lowest bit of exponent
	lsls	r2,r1,#1		// load number 'x' without sign flag -> R2
	adds	r2,r0			// exponent + 1
	bhi	1f			// number 'x' is NaN

	// check if exponent of 'y' is NaN (= 0x7ff)
	lsls	r2,r3,#1		// load number 'y' without sign flag -> R2
	adds	r2,r0			// exponent + 1
	bhi	1f			// number 'y' is NaN

	// return False
	movs	r0,#0
	bx	lr

	// return True
1:	movs	r0,#1
	bx	lr


// ==== convert integer to double


// ----------------------------------------------------------------------------
//                      Convert unsigned int to double
// ----------------------------------------------------------------------------
// double ui2d(u32 num);
// double uint2double(u32 num);

regular_func_text ui2d
regular_func uint2double
wrapper_func __aeabi_ui2d

	// check if number is zero
	movs	r1,#0		// prepare positive result sign 0 -> R1
	cmp	r0,#0		// is number zero?
	bne	i2d_2		// number is not zero
ui2d_2:	bx	lr		// result is 0

// ----------------------------------------------------------------------------
//                      Convert signed int to double
// ----------------------------------------------------------------------------
// double i2d(s32 num);
// double int2double(s32 num);

regular_func i2d
regular_func int2double
wrapper_func __aeabi_i2d

	// prepare sign 0 or -1 -> R1
	asrs	r1,r0,#31	// get sign bit -> R1 (0 or -1)

	// absolute value of the number
	eors	r0,r1		// invert number if number is negative
	subs	r0,r1		// +1 if number is negative -> absolute value

	// check if number is zero
	beq	ui2d_2		// number is zero, exit

	// prepare result sign in bit 21
	lsls	r1,#31		// shift sign bit to position 31

	// count leading zeroes -> R0
i2d_2:	push	{r0,r1,r4,lr}	// push registers
	ldr	r3,=clz		// ROM function clz
	ldr	r3,[r3]		// get function address
	blx	r3		// call clz function
	pop	{r2,r3}		// pop registers

// here is: R0 count of leading zeros, R2 absolute value of input integer number, R3 sign bit in bit 31

	// normalize number (shift left) -> R2
	adds	r4,r0,#1	// count of zeros + 1 -> R4
	lsls	r2,r4		// normalize number - shift bits left -> R2

	// prepare mantissa -> R2:R0
	lsls	r0,r2,#20	// shift number to position 20 -> R0 (lower 12 bits of mantissa)
	lsrs	r2,#12		// delete lower 12 bits of mantissa

	// prepare exponent -> R1
	ldr	r1,=1055	// bias of exponent = 1023 + 32
	subs	r1,r4		// bias - (count of zeros+1) = new exponent
	lsls	r1,#20		// shift exponent to position 20

	// assemble double number -> R1:R0
	orrs	r1,r3		// assemble exponent and sign
	orrs	r1,r2		// assemble with mantissa high
	pop	{r4,pc}		// pop register R4 and return

// ----------------------------------------------------------------------------
//                 Convert signed fixed point to double
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// double fix2double(s32 num, int e);

regular_func_text fix2double

	// convert using 64-bit
	movs	r2,r1		// exponent -> R2
	asrs	r1,r0,#31	// number high = 0 or -1
	b	fix642double

// ----------------------------------------------------------------------------
//                 Convert unsigned fixed point to double
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// double ufix2double(u32 num, int e);

regular_func_text ufix2double

	// convert using 64-bit
	movs	r2,r1		// exponent -> R2
	movs	r1,#0		// number high = 0
	b	ufix642double

// ----------------------------------------------------------------------------
//                    Convert 64-bit unsigned int to double
// ----------------------------------------------------------------------------
// double ul2d(s64 num);
// double uint642double(u64 num);

regular_func_text ul2d
regular_func uint642double
wrapper_func __aeabi_ul2d

	// set number of fraction bits = 0
	movs	r2,#0			// 2nd parameter - number of bits = 0

// ---- continue to ufix642double (do not use *_text !)

// ----------------------------------------------------------------------------
//                 Convert 64-bit unsigned fixed point to double
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// double ufix642double(u64 num, int e);

regular_func ufix642double

	movs	r3,#0		// sign flag 0 = positive
	b	uf2d

// ----------------------------------------------------------------------------
//                     Convert 64-bit signed int to double
// ----------------------------------------------------------------------------
// double l2d(s64 num);
// double int642double(s64 num);

regular_func_text l2d
regular_func int642double
wrapper_func __aeabi_l2d

	// set number of fraction bits = 0
	movs	r2,#0			// 2nd parameter - number of bits = 0

// ---- continue to fix642double (do not use *_text !)

// ----------------------------------------------------------------------------
//                 Convert 64-bit signed fixed point to double
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// double fix642double(s64 num, int e);

regular_func fix642double

	// prepare sign flag
	asrs	r3,r1,#31	// get sign 0 or -1

	// absolute value of the number
	eors	r0,r3		// not number low if negative
	eors	r1,r3		// not number high if negative
	subs	r0,r3		// + 1 if negative (to get absolute value)
	sbcs	r1,r3		// + 1 + carry

	// push registers
uf2d:	push	{r4,r5,lr}

	// prepare exponent -> R2
	ldr	r4,=0x432	// 1074 = 1023 + 51
	subs	r2,r4,r2	// form biased exponent

// Here is:
// R1:R0 = unnormalised mantissa
// R2 = -Q (will become exponent)
// R3 = sign across all bits

	// check if number high is zero
	cmp	r1,#0		// check number high
	bne	1f		// number high is not zero, only short normalising shift

	// normalize number by 32 shifts
	movs	r1,r0		// R1 <- number low
	beq	2f		// number is zero, exit with zero result
	movs	r0,#0		// number low = 0
	subs	r2,#32		// shift exponent by 32

	// check if number is already normalised
1:	asrs	r4,r1,#21	// shift mantissa right to test bit 21
	bne	3f		// will need shift down (and rounding?)
	bcs	4f		// already normalised

	// normalize number (shift left)
5:	subs	r2,#1		// shift exponent
	adds	r0,r0		// mantissa*2 to shift left
	adcs	r1,r1		// carry high
	lsrs	r4,r1,#21	// shift mantissa right to test bit 21
	bcc	5b		// shift continue

	// check over/underflow (here is "exponent - 1")
4:	ldr	r4,=0x7fe	// unsigned exponent max = 2046
	cmp	r2,r4		// check exponent
	bhs	6f		// over/underflow? return signed zero/infinity

	// assemble number
	// - here is "exponent - 1" to remove hidden implied bit "1"
7:	lsls	r2,#20		// shift exponent to position
	adds	r1,r2		// add exponent to mantissa and remove hidden implied bit "1"
	lsls	r3,#31		// shift sign to position 31
	adds	r1,r3		// add sign to mantissa

	// pop registers and return
2:	pop	{r4,r5,pc}

	// return signed zero/infinity according to unclamped exponent in r2
6:	mvns	r2,r2		// not exponent
	lsrs	r2,#21		// shift exponent to position 21
	movs	r0,#0		// mantissa low = 0
	movs	r1,#0		// mantissa high = 0
	b	7b		// assemble number

	// here we need to shift down to normalise and possibly round
3:	bmi	1f		// already normalised to Q63
2:	subs	r2,#1		// shift exponent
	adds	r0,r0		// mantissa*2 to shift left
	adcs	r1,r1		// carry high
	bpl	2b		// shift continue

	// here we have a 1 in b63 of r0:r1
1:	adds	r2,#11		// correct exponent for subsequent shift down
	lsls	r4,r0,#21	// save bits for rounding -> R4
	lsrs	r0,#11		// shift number low >> 11
	lsls	r5,r1,#21	// get carry from number high -> R5
	orrs	r0,r5		// add carry from high to low
	lsrs	r1,#11		// shift number high >> 11
	lsls	r4,#1		// check sticky bits
	beq	1f		// sticky bits are zero

	// sticky bits are not zero, rounding up if bit is set
8:	movs	r4,#0		// carry 0 -> R4
	adcs	r0,r4		// increment number low if carry is set
	adcs	r1,r4		// increment number high if carry is set
	b	4b		// checks

	// sticky bits are zero, check highest bit and round to even
1:	bcc	4b		// sticky bits are zero but not on rounding boundary
	lsrs	r4,r0,#1	// increment if odd (force round to even)
	b	8b		// do rounding


// ==== convert double to integer


// ----------------------------------------------------------------------------
//     Convert double to signed int, rounding to zero (C-style int conversion)
// ----------------------------------------------------------------------------
// s32 d2iz(double num);
// s32 double2int_z(double num);

regular_func_text d2iz
regular_func double2int_z
wrapper_func __aeabi_d2iz

	// save register R4 and LR
	push	{r4, lr}

	// get exponent -> R2
	lsls	r4,r1,#1	// shift 1 bit left to get double number without sign -> R4
	lsrs	r2,r4,#21	// shift 21 bits right to get exponent -> R2

	// prepare overflow number 0x800...
	movs	r3,#0x80	// R3 <- overflow number base
	adds	r2,r3		// exponent + 0x80
	lsls	r3,#3		// R3 <- number 0x400
	subs	r2,r3		// exponent + 0x80 - 0x400 = exponent - 0x380 (current bias is 127, real bias is would be 0x3ff)
	lsls	r3, #21		// R3 <- number 0x800...

	// check minimal exponent - result will be 0
	cmp	r2,#126		// check minimal exponent of 0.5
	ble	1f		// number is too small - result will be 0

	// check maximal exponent
	subs	r2,#158		// exponent - current exponent bias 127 - max. mantissa bits 31 = exponent - 158
	bge	2f		// number is too big, limit overflow result

	// prepare sign
	asrs	r4,r1,#31	// prepare sign: positive 0, negative -1

	// prepare mantissa
	lsls	r1,#12		// delete sign and exponent
	lsrs	r1,#1		// mantissa is in bits 11..30
	orrs	r1,r3		// restore highest hidden bit '1'

	// relative exponent
	negs	r2,r2		// relative exponent -> R2

	// shift mantissa high to integer position
	lsrs	r1,r2		// shift mantissa high right by exponent bits

	// prepare sign
	lsls	r4,#1		// shift sign left
	adds	r4,#1		// sign: positive 1, negative -1

	// prepare shifts for mantissa low
	adds	r2,#21		// shifts for mantissa low
	cmp	r2,#32		// more than 32 bits?
	bge	3f		// more than 32 bits, use only mantissa high

	// result with mantissa high and mantissalow
	lsrs	r0,r2		// shift mantissa low
	orrs	r0,r1		// add carry from mantissa high

	// compose mantissa with sign
	muls	r0,r4		// multiply mantissa with sign 1 or -1
	pop	{r4, pc}	// pop register R4 and return

	// result is number 0
1:	movs	r0,#0		// R0 <- 0
	pop	{r4,pc}		// pop register R4 and return

	// result with only mantissa high
3:	mov	r0,r1		// R0 <- shifted mantissa high
	muls	r0,r4		// multiply mantissa with sign 1 or -1
	pop	{r4,pc}		// pop register R4 and return

	// number is too big - limit number on overflow
2:	lsrs	r0,r1,#31	// get sign flag into R0 bit 0
	adds	r0,r3		// add overflow number 0x80000000
	subs	r0,#1		// -1 -> limited result is 0x7FFFFFFF for positive number, 0x80000000 for negative
	pop	{r4,pc}		// pop register R4 and return

// ----------------------------------------------------------------------------
//                 Convert double to signed int, rounding down
// ----------------------------------------------------------------------------
// s32 d2i(double x);
// s32 double2int(double x);

regular_func_text double2int
regular_func d2i

        movs	r2,#0		// 2nd argument, exponent = 0
	
// ---- continue to double2fix (do not use *_text !)

// ----------------------------------------------------------------------------
//               Convert double to signed fixed point, rounding down
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// s32 double2fix(double x, int e);

regular_func double2fix

	push	{lr}		// push LR
	adds	r2,#32		// shift exponent
	bl	double2fix64	// convert double to long signed fixed point
	movs	r0,r1		// R0 <- result high
	pop	{pc}		// return

// ----------------------------------------------------------------------------
//                 Convert double to unsigned int, rounding down
// ----------------------------------------------------------------------------
// u32 d2ui(double x);
// u32 double2uint(double x);

regular_func_text double2uint
regular_func d2ui
wrapper_func __aeabi_d2uiz

        movs	r2,#0		// 2nd argument, exponent = 0
	
// ---- continue to double2ufix (do not use *_text !)

// ----------------------------------------------------------------------------
//               Convert double to unsigned fixed point, rounding down
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// u32 double2ufix(double x, int e);

regular_func double2ufix

	push	{lr}		// push LR
	adds	r2,#32		// shift exponent
	bl	double2ufix64	// convert double to long unsigned fixed point
	movs	r0,r1		// R0 <- result high
	pop	{pc}		// return

// ----------------------------------------------------------------------------
// Convert double to 64-bit signed int, rounding to zero (C-style int conversion)
// ----------------------------------------------------------------------------
// s64 d2lz(double num);
// s64 double2int64_z(double num);

regular_func_text double2int64_z
regular_func d2lz
wrapper_func __aeabi_d2lz

	// if number is not negative, convert with rounding down
	cmn	r1,r1		// R0+R0 ? ... is number negative?
	bcc	double2int64	// number is not negative - convert with rounding down

	// convert as unsigned, using absolute value
	push	{lr}
	lsls	r1,#1		// discard sign bit
	lsrs	r1,#1		// shift back
	bl	double2uint64	// convert to u64

	// check overflow signed range
	cmp	r1,#0		// overflow signed?
	bmi	1f		// overflow

	// negate result
	movs	r2,#0
	negs	r0,r0		// negate result low
	sbcs	r2,r1		// carry to result high
	mov	r1,r2		// R1 <- result high
	pop	{pc}		// return

	// return max. negative value
1:	movs	r1,#128		// R1 <- 0x80
	lsls	r1,#24		// R1 <- 0x800... max. negative value
	movs	r0,#0		// R0 <- 0
	pop	{pc}		// return

// ----------------------------------------------------------------------------
//              Convert double to 64-bit signed int, rounding down
// ----------------------------------------------------------------------------
// s64 d2l(double num);
// s64 double2int64(double num);

regular_func d2l
regular_func double2int64

	movs r2,#0		// 2nd parameter - number of bits = 0

// ---- continue to double2fix64 (do not use *_text !)

// ----------------------------------------------------------------------------
//         Convert double to 64-bit signed fixed point, rounding down
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// s64 double2fix64(double num, int e);

regular_func double2fix64

	// convert double to signed fixed point
	push	{lr}		// push LR
// input: R1:R0 = float number
//        R2 = result exponent (number of bits after decimal point of output integer)
// output: R3:R1:R0 = signed fixed point (clamped, R3 is 0 or -1)
// trashes: R12
	bl	d2fix		// convert double to signed fixed point

	// check overflow signed int64
	asrs	r2,r1,#31	// get sign bit of R1 -> R2
	cmp	r2,r3		// overflow int64 ?
	bne	1f		// sign extension bits fail to match sign of result?
	pop	{pc}		// return

	// signed int64 overflow, return max. number
1:	mvns	r0,r3		// not sign -> R0 (0 on negative, -1 on positive)
	movs	r1,#1		// R1 <- 1
	lsls	r1,#31		// R1 <- bit 31
	eors	r1,r1,r0	// max. integer -> R1 (0x800.. on negative, 0x7FF.. on positive)
	pop	{pc}		// return

// ----------------------------------------------------------------------------
//                    Convert double to 64-bit unsigned int
// ----------------------------------------------------------------------------
// u64 d2ul(double num);
// u64 double2uint64(double num);

regular_func_text double2uint64
regular_func d2ul
wrapper_func __aeabi_d2ulz

	movs	r2,#0			// 2nd parameter - number of bits = 0

// ---- continue to double2ufix64 (do not use *_text !)

// ----------------------------------------------------------------------------
//                  Convert double to 64-bit unsigned fixed point
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// u64 double2ufix64(double num, int e);

regular_func double2ufix64

	// check if number is negative - return 0 to be clamped to unsigned int
	asrs	r3,r1,#20	// get sign and exponent -> R3
	bmi	ret_dzero	// number is negative, return -0.0

// ---- convert double to signed fixed point, rounding down

// input: R1:R0 = double number
//        R2 = result exponent (number of bits after decimal point of output integer)
// output: R3:R1:R0 = signed fixed point (clamped, R3 is 0 or -1)
// trashes: R12

d2fix:
	// save register R4 and LR
	push	{r4,lr}
	mov	r12,r2		// required exponent -> R12

	// unpack double number -> R1:R0 signed mantissa, R2 absolute exponent
// input: R1:R0 = double number
// output: R1:R0 = signed mantissa with hidden implied '1' set (53 significant bits)
//         R2 = absolute exponent without offset
// trashes: R3, R4
	bl	dunpacks	// unpack number

	// prepare mantissa
	asrs	r4,r2,#16	// shift exponent to position 16
	adds	r4,#1		// exponent + 1
	bge	1f		// not zero
	movs	r1,#0		// -0 -> +0
1:	asrs	r3,r1,#31	// 
	ldr	r4,=d2fix_a	// (cannot use 'b d2fix_a', label is too far)
	bx	r4		// shift mantissa R3:R1:R0 by R2+R12 bits (function is locaten at float sources)
 
ret_dzero:
	// result is minus zero -0.0 (here is R3 = sign 0 or -1)
	movs	r0,#0		// 0 -> R0
	movs	r1,#0		// 0 -> R1
	bx	lr		// return

// ==== unpack double number
// input: R1:R0 = double number
// output: R1:R0 = signed mantissa with hidden implied '1' set (53 significant bits)
//         R2 = absolute exponent without offset
// trashes: R3, R4

regular_func_text dunpacks

// macro - unpack double to signed mantissa
// input: RB:RA = double number
// output: RB:RA = signed mantissa with hidden implied '1' set (53 significant bits)
//         RE = exponent (-128 if zero, 1919 if infinity)
// trashes: RT0, RT1
// +zero, +denormal -> exponent = -0x80000
// -zero, -denormal -> exponent = -0x80000
// +Inf, +NaN -> exponent = +0x77f000
// -Inf, -NaN -> exponent = +0x77e000
//.macro mdunpacks ra,rb,re,rt0,rt1

	mdunpacks r0,r1,r2,r3,r4
	ldr	r3,=0x3ff
	subs	r2,r3		// exponent without offset
	bx	lr

// ----------------------------------------------------------------------------
//                            Square root
// ----------------------------------------------------------------------------
// double sqrtd(double x);
// double sqrt(double x);

section_text sqrtd

/*
Approach to square root x=sqrt(y) is as follows.

First generate a3, an approximation to 1/sqrt(y) to about 30 bits. Multiply this by y
to give a4~sqrt(y) to about 28 bits and a remainder r4=y-a4^2. Then, because
d sqrt(y) / dy = 1 / (2 sqrt(y)) let d4=r4*a3/2 and then the value a5=a4+d4 is
a better approximation to sqrt(y). If this is near a rounding boundary we
compute an exact remainder y-a5*a5 to decide whether to round up or down.

The calculation of a3 and a4 is as given in dsqrttest.c. That code verifies exhaustively
that | 1 - a3a4 | < 10*2^-32, | r4 | < 40*2^-32 and | r4/y | < 20*2^-32.

More precisely, with "y" representing y truncated to 30 binary places:

u=(q3)y;                          // 24-entry table
a0=(q8~)"1/sqrtq(x+x_ulp/2)"(u);  // first approximation from table
p0=(q16)(a0*a0) * (q16)y;
r0=(q20)(p0-1);
dy0=(q15)(r0*a0);                 // Newton-Raphson correction term
a1=(q16)a0-dy0/2;                 // good to ~9 bits

p1=(q19)(a1*a1)*(q19)y;
r1=(q23)(p1-1);
dy1=(q15~)(r1*a1);                // second Newton-Raphson correction
a2x=(q16)a1-dy1/2;                // good to ~16 bits
a2=a2x-a2x/1t16;                  // prevent overflow of a2*a2 in 32 bits

p2=(a2*a2)*(q30)y;                // Q62
r2=(q36)(p2-1+1t-31);
dy2=(q30)(r2*a2);                 // Q52->Q30
a3=(q31)a2-dy2/2;                 // good to about 30 bits
a4=(q30)(a3*(q30)y+1t-31);        // good to about 28 bits

Error analysis

          r4 = y - a4^2
          d4 = 1/2 a3*r4
          a5 = a4 + d4
          r5 = y - a5^2
             = y - ( a4 + d4 )^2
             = y - a4^2 - a3a4r4 - 1/4 a3^2*r4^2
             = r4 - a3a4r4 - 1/4 a3^2*r4^2

      | r5 | < | r4 | | 1 - a3*a4 | + 1/4 r4^2

          a5 = sqrt(y) sqrt( 1 - r5/y )
             = sqrt(y) ( 1 - 1/2 r5/y + ... )

So to first order (second order being very tiny)

     sqrt(y) - a5 = 1/2 r5/y

and

 | sqrt(y) - a5 | < 1/2 ( | r4/y | | 1 - a3*a4 | + 1/4 r4^2/y )

From dsqrttest.c (conservatively):

             < 1/2 ( 20*2^-32 * 10*2^-32 + 1/4 * 40*2^-32*20*2^-32 )
             = 1/2 ( 200 + 200 ) * 2^-64
             < 2^-56

Empirically we see about 1ulp worst-case error including rounding at Q57.

To determine correctly whether the exact remainder calculation can be skipped we need a result
accurate to < 0.25ulp at Q52, or 2^-54.
*/

dq_2:
	bge	dq_3		// +Inf?
	movs	r1,#0
	b	dq_4

dq_0:
	lsrs	r1,#31
	lsls	r1,#31		// preserve sign bit
	lsrs	r2,#21		// extract exponent
	beq	dq_4		// -0? return it
	asrs	r1,#11		// make -Inf
	b	dq_4

dq_3:
	ldr	r1,=0x7ff
	lsls	r1,#20		// return +Inf
dq_4:
	movs	r0,#0
dq_1:
	bx	lr

regular_func sqrtd
regular_func sqrt
wrapper_func sqrt

	lsls	r2,r1,#1
	bcs	dq_0		// negative?
	lsrs	r2,#21		// extract exponent
	subs	r2,#1
	ldr	r3,=0x7fe
	cmp	r2,r3
	bhs	dq_2		// catches 0 and +Inf
	push	{r4-r7,lr}
	lsls	r4,r2,#20
	subs	r1,r4		// insert implied 1
	lsrs	r2,#1
	bcc	1f		// even exponent? skip
	adds	r0,r0,r0	// odd exponent: shift up mantissa
	adcs	r1,r1,r1

1:	lsrs	r3,#2
	adds	r2,r3
	lsls	r2,#20
	mov	r12,r2		// save result exponent

// here
// r0:r1  y mantissa Q52 [1,4)
// r12    result exponent

.equ drsqrtapp_minus_8, (drsqrtapp-8)

	adr	r4,drsqrtapp_minus_8 // first eight table entries are never accessed because of the mantissa's leading 1
	lsrs	r2,r1,#17	// y Q3
	ldrb	r2,[r4,r2]	// initial approximation to reciprocal square root a0 Q8
	lsrs	r3,r1,#4	// first Newton-Raphson iteration
	muls	r3,r2
	muls	r3,r2		// i32 p0=a0*a0*(y>>14);          // Q32
	asrs	r3,r3,#12	// i32 r0=p0>>12;                 // Q20
	muls	r3,r2
	asrs	r3,#13		// i32 dy0=(r0*a0)>>13;           // Q15
	lsls	r2,#8
	subs	r2,r3		// i32 a1=(a0<<8)-dy0;         // Q16

	movs	r3,r2
	muls	r3,r3
	lsrs	r3,#13
	lsrs	r4,r1,#1
	muls	r3,r4		// i32 p1=((a1*a1)>>11)*(y>>11);  // Q19*Q19=Q38
	asrs	r3,#15		// i32 r1=p1>>15;                 // Q23
	muls	r3,r2
	asrs	r3,#23
	adds	r3,#1
	asrs	r3,#1		// i32 dy1=(r1*a1+(1<<23))>>24;   // Q23*Q16=Q39; Q15
	subs	r2,r3		// i32 a2=a1-dy1;                 // Q16
	lsrs	r3,r2,#16
	subs	r2,r3		// if(a2>=0x10000) a2=0xffff; to prevent overflow of a2*a2

// here
// r0:r1 y mantissa
// r2    a2 ~ 1/sqrt(y) Q16
// r12   result exponent

	movs	r3,r2
	muls	r3,r3
	lsls	r1,#10
	lsrs	r4,r0,#22
	orrs	r1,r4		// y Q30
	mul32_32_64 r1,r3, r4,r3, r5,r6,r7  // i64 p2=(ui64)(a2*a2)*(ui64)y;  // Q62 r4:r3
	lsls	r5,r3,#6
	lsrs	r4,#26
	orrs	r4,r5
	adds	r4,#0x20	// i32 r2=(p2>>26)+0x20;          // Q36 r4
	uxth	r5,r4
	muls	r5,r2
	asrs	r4,#16
	muls	r4,r2
	lsrs	r5,#16
	adds	r4,r5
	asrs	r4,#6		// i32 dy2=((i64)r2*(i64)a2)>>22; // Q36*Q16=Q52; Q30
	lsls	r2,#15
	subs	r2,r4

// here
// r0    y low bits
// r1    y Q30
// r2    a3 ~ 1/sqrt(y) Q31
// r12   result exponent

	mul32_32_64 r2,r1, r3,r4, r5,r6,r7
	adds	r3,r3,r3
	adcs	r4,r4,r4
	adds	r3,r3,r3
	movs	r3,#0
	adcs	r3,r4		// ui32 a4=((ui64)a3*(ui64)y+(1U<<31))>>31; // Q30

// here
// r0    y low bits
// r1    y Q30
// r2    a3 Q31 ~ 1/sqrt(y)
// r3    a4 Q30 ~ sqrt(y)
// r12   result exponent

	square32_64 r3, r4,r5, r6,r7
	lsls	r6,r0,#8
	lsrs	r7,r1,#2
	subs	r6,r4
	sbcs	r7,r5		// r4=(q60)y-a4*a4

// by exhaustive testing, r4 = fffffffc0e134fdc .. 00000003c2bf539c Q60

	lsls	r5,r7,#29
	lsrs	r6,#3
	adcs	r6,r5		// r4 Q57 with rounding
	muls32_32_64 r6,r2, r6,r2, r4,r5,r7 // d4=a3*r4/2 Q89

// r4+d4 is correct to 1ULP at Q57, tested on ~9bn cases including all extreme values of r4 for each possible y Q30

	adds	r2,#8
	asrs	r2,#5		// d4 Q52, rounded to Q53 with spare bit in carry

// here
// r0    y low bits
// r1    y Q30
// r2    d4 Q52, rounded to Q53
// C flag contains d4_b53
// r3    a4 Q30

	bcs	dq_5

	lsrs	r5,r3,#10	// a4 Q52
	lsls	r4,r3,#22

	asrs	r1,r2,#31
	adds	r0,r2,r4
	adcs	r1,r5		// a4+d4

	add	r1,r12		// pack exponent
	pop	{r4-r7,pc}

.ltorg
.align 2		// align to 4-byte boundary
// round(sqrt(2^22./[68:8:252]))
drsqrtapp:
	.byte	0xf8,0xeb,0xdf,0xd6,0xcd,0xc5,0xbe,0xb8
	.byte	0xb2,0xad,0xa8,0xa4,0xa0,0x9c,0x99,0x95
	.byte	0x92,0x8f,0x8d,0x8a,0x88,0x85,0x83,0x81

.align 2		// align to 4-byte boundary
dq_5:
// here we are near a rounding boundary, C is set
	adcs	r2,r2,r2	// d4 Q53+1ulp
	lsrs	r5,r3,#9
	lsls	r4,r3,#23	// r4:r5 a4 Q53
	asrs	r1,r2,#31
	adds	r4,r2,r4
	adcs	r5,r1		// r4:r5 a5=a4+d4 Q53+1ulp
	movs	r3,r5
	muls	r3,r4
	square32_64 r4,r1,r2,r6,r7
	adds	r2,r3
	adds	r2,r3		// r1:r2 a5^2 Q106
	lsls	r0,#22		// y Q84

	negs	r1,r1
	sbcs	r0,r2		// remainder y-a5^2
	bmi	1f		// y<a5^2: no need to increment a5
	movs	r3,#0
	adds	r4,#1
	adcs	r5,r3		// bump a5 if over rounding boundary

1:	lsrs	r0,r4,#1
	lsrs	r1,r5,#1
	lsls	r5,#31
	orrs	r0,r5
	add	r1,r12
	pop	{r4-r7,pc}

// ----------------------------------------------------------------------------
//                              Double Cordic
// ----------------------------------------------------------------------------

// double-length CORDIC rotation step

// r0:r1   omega
// r6      32-i (complementary shift)
// r7      i (shift)
// r8:r9   x
// r10:r11 y
// r12     coefficient pointer

// an option in rotation mode would be to compute the sequence of delta values
// in one pass, rotate the initial vector by the residual omega and then run a
// second pass to compute the final x and y. This would relieve pressure
// on registers and hence possibly be faster. The same trick does not work
// in vectoring mode (but perhaps one could work to single precision in
// a first pass and then double precision in a second pass?).

regular_func_text dcordic_vec_step

	mov	r2,r12
	ldmia	r2!,{r3,r4}
	mov	r12,r2
	mov	r2,r11
	cmp	r2,#0
	blt	1f
	b	2f

regular_func dcordic_rot_step

	mov	r2,r12
	ldmia	r2!,{r3,r4}
	mov	r12,r2
	cmp	r1,#0
	bge	1f

// omega<0 / y>=0
// omega+=domega
// x+=y>>i, y-=x>>i

2:	adds	r0,r3
	adcs	r1,r4

	mov	r3,r11
	asrs	r3,r7
	mov	r4,r11
	lsls	r4,r6
	mov	r2,r10
	lsrs	r2,r7
	orrs	r2,r4		// r2:r3 y>>i, rounding in carry
	mov	r4,r8
	mov	r5,r9		// r4:r5 x
	adcs	r2,r4
	adcs	r3,r5		// r2:r3 x+(y>>i)
	mov	r8,r2
	mov	r9,r3

	mov	r3,r5
	lsls	r3,r6
	asrs	r5,r7
	lsrs	r4,r7
	orrs	r4,r3		// r4:r5 x>>i, rounding in carry
	mov	r2,r10
	mov	r3,r11
	sbcs	r2,r4
	sbcs	r3,r5		// r2:r3 y-(x>>i)
	mov	r10,r2
	mov	r11,r3
	bx	lr

// omega>0 / y<0
// omega-=domega
// x-=y>>i, y+=x>>i

1:	subs	r0,r3
	sbcs	r1,r4

	mov	r3,r9
	asrs	r3,r7
	mov	r4,r9
	lsls	r4,r6
	mov	r2,r8
	lsrs	r2,r7
	orrs	r2,r4		// r2:r3 x>>i, rounding in carry
	mov	r4,r10
	mov	r5,r11		// r4:r5 y
	adcs	r2,r4
	adcs	r3,r5		// r2:r3 y+(x>>i)
	mov	r10,r2
	mov	r11,r3

	mov	r3,r5
	lsls	r3,r6
	asrs	r5,r7
	lsrs	r4,r7
	orrs	r4,r3		// r4:r5 y>>i, rounding in carry
	mov	r2,r8
	mov	r3,r9
	sbcs	r2,r4
	sbcs	r3,r5		// r2:r3 x-(y>>i)
	mov	r8,r2
	mov	r9,r3
	bx	lr

// sincostan remainder (modulo 2*PI)
section_text sincostan_remainder
sincostan_remainder:

	// save link register
	push	{lr}

	// check angle range - rom version only works for -1024 < angle < 1024
	lsls	r2,r1,#2		// delete sign bit and bias
	bcc	2f			// angle is ok
	lsrs	r2,#22			// delete mantissa, get only exponent -> R2
	cmp	r2,#9			// check max. exponent 1024
	blt	2f			// exponent is ok

	// angle is too big, modulo angle range
	ldr	r2,=0x54442D18		// 2*M_PI
	ldr	r3,=0x401921FB
	bl	remainder		// calculate remainder of division angle/(2*pi) -> R1:R0

	// return
2:	pop	{pc}

// push registers R8..R11 (trashes R4..R7)
regular_func_text push_r8_r11
	mov	r4,r8
	mov	r5,r9
	mov	r6,r10
	mov	r7,r11
	push	{r4-r7}
	bx	lr

// pop registers R8..R11 (trashes R4..R7)
regular_func_text pop_r8_r11
	pop	{r4-r7}
	mov	r8,r4
	mov	r9,r5
	mov	r10,r6
	mov	r11,r7
	bx	lr

// ----------------------------------------------------------------------------
//                              Sine
// ----------------------------------------------------------------------------
// double sin(double x);

wrapper_func_text sin

	// modulo angle
	push	{lr}
	bl	sincostan_remainder	// modulo angle if angle is too big

	// calculate sin
	push	{r4-r7}			// push registers R4..R7 and LR
	bl	push_r8_r11		// push registers R8..R11 (trashes R4..R7)
	bl	dsincos_internal	// calculate sin and cos internal
	bl	dsin_finish		// finish sin
sin_ret:
	bl	pop_r8_r11		// pop registers R8..R11 (trashes R4..R7)
	pop	{r4-r7,pc}		// pop registers R4..R7 and return

// ----------------------------------------------------------------------------
//                              Cosine
// ----------------------------------------------------------------------------
// double cos(double x);

wrapper_func_text cos

	// modulo angle
	push	{lr}
	bl	sincostan_remainder	// modulo angle if angle is too big

	// calculate cos
	push	{r4-r7}			// push registers R4..R7 and LR
	bl	push_r8_r11		// push registers R8..R11 (trashes R4..R7)
	bl	dsincos_internal	// calculate sin and cos internal
	bl	dcos_finish		// finish cos
	b	sin_ret

// ----------------------------------------------------------------------------
//                              Sine-cosine
// ----------------------------------------------------------------------------
// void sincos(double x, double* psin, double* pcos);

wrapper_func_text sincos

	// push registers (r1:r0=num, r2=sin pointer, r3=cos pointer)
	push	{r2-r7, lr}		// save registers

	// modulo angle
	bl	sincostan_remainder	// modulo angle if angle is too big

	// calculate sincos
	bl	push_r8_r11		// push registers R8..R11 (trashes R4..R7)
	bl	dsincos_internal	// calculate sin and cos internal
	push	{r0}			// save eps
	bl	dcos_finish		// finish cos
	pop	{r4}			// restore eps
	push	{r0,r1}			// save R0 and R1 (cos result)
	mov	r0,r4			// eps
	bl	dsin_finish		// finish sin
	pop	{r2,r3}			// pop R2 and R3 (cos result)
	bl	pop_r8_r11		// pop registers R8..R11 (trashes R4..R7)

	// store result and return
	pop	{r4,r5}			// restore pointers
	stmia	r4!,{r0,r1}		// store sin
	stmia	r5!,{r2,r3}		// store cos
	pop	{r4-r7,pc}		// restore R4..R7, return

// ----------------------------------------------------------------------------
//                              Tangent
// ----------------------------------------------------------------------------
// double tan(double x);

wrapper_func_text tan

	// save registers
	push	{r4, lr}	// save registers

	// modulo angle
	bl	sincostan_remainder	// modulo angle if angle is too big

	// disable interrupts (tan uses hardware divider)
	irq_lock r4		// save interrupt into R4, disable interrupt

	// save registers R4..R11
	push	{r4-r7}		// push registers R4..R7
	bl	push_r8_r11	// push registers R8..R11 (trashes R4..R7)

	// calculate sin and cos internal
	bl	dsincos_internal

	// finish cos
	push	{r0}		// save eps
	bl	dcos_finish
	pop	{r4}		// restore eps

	// finish sin
	push	{r0,r1}
	mov	r0,r4		// eps
	bl	dsin_finish
	pop	{r2,r3}

	// restore registers R8..R11
	bl	pop_r8_r11	// (trashes R4..R7)

	// divide sin x / cos x
	bl	ddiv		// compute sin x/cos x

	// restore registers R4..R7
	pop	{r4-r7}

	// restore interrupt and return
	irq_unlock r4		// restore interrupt from R4
	pop	{r4, pc}	// restore R4 and return


// === calculate sin and cos internal
// unpack double theta in r0:r1, range reduce and calculate eps, cos alpha and sin alpha such that
// theta=alpha+eps and abs(eps)<=2^-32
// on return:
// r0:r1   eps (residual omega, where theta=alpha+eps) Q62, abs(eps)<=2^-32 (so fits in r0)
// r8:r9   cos alpha Q62
// r10:r11 sin alpha Q62

section_text dsincos_internal
dsincos_internal:

	push	{lr}

// input: R1:R0 = double number
// output: R1:R0 = signed mantissa with hidden implied '1' set (53 significant bits)
//         R2 = absolute exponent without offset
// trashes: R3, R4

	bl	dunpacks

// angle reduction
// r0:r1  signed mantissa Q52
// r2     unbiased exponent < 10 (i.e., abs(x)<2^10)
// r4     pointer to:
//          - divisor reciprocal approximation r=1/d Q15
//          - divisor d Q62  0..20
//          - divisor d Q62 21..41
//          - divisor d Q62 42..62
// returns:
// r0:r1  reduced result y Q62, -0.6 d < y < 0.6 d (better in practice)
// r2     quotient q (number of reductions)
// if exponent >=10, returns r0:r1=0, r2=1024*mantissa sign
// designed to work for 0.5<d<2, in particular d=ln2 (~0.7) and d=pi/2 (~1.6)
// trashes R3..R7

	ldr	r4,=dreddata0
	bl	dreduce

	movs	r4,#0
	ldr	r5,=0x9df04dbb	// this value compensates for the non-unity scaling of the CORDIC rotations
	ldr	r6,=0x36f656c5
	lsls	r2,#31
	bcc	1f

// quadrant 2 or 3
	mvns	r6,r6
	negs	r5,r5
	adcs	r6,r4
1:	lsls	r2,#1
	bcs	1f

// even quadrant
	mov	r10,r4
	mov	r11,r4
	mov	r8,r5
	mov	r9,r6
	b	2f

// odd quadrant
1:	mov	r8,r4
	mov	r9,r4
	mov	r10,r5
	mov	r11,r6
2:	ldr	r4,=dtab_cc
	mov	r12,r4
	movs	r7,#1
	movs	r6,#31

1:	bl	dcordic_rot_step
	adds	r7,#1
	subs	r6,#1
	cmp	r7,#33
	bne	1b
	pop	{pc}

.ltorg

regular_data_text dreddata0

	.word 0x0000517d	// 2/pi Q15
	.word 0x0014611A	// pi/2 Q62=6487ED5110B4611A split into 21-bit pieces
	.word 0x000A8885
	.word 0x001921FB

// angle reduction
// r0:r1  signed mantissa Q52
// r2     unbiased exponent < 10 (i.e., abs(x)<2^10)
// r4     pointer to:
//          - divisor reciprocal approximation r=1/d Q15
//          - divisor d Q62  0..20
//          - divisor d Q62 21..41
//          - divisor d Q62 42..62
// returns:
// r0:r1  reduced result y Q62, -0.6 d < y < 0.6 d (better in practice)
// r2     quotient q (number of reductions)
// if exponent >=10, returns r0:r1=0, r2=1024*mantissa sign
// designed to work for 0.5<d<2, in particular d=ln2 (~0.7) and d=pi/2 (~1.6)
// trashes R3..R7

section_text dreduce
dreduce:

	adds	r2,#2		// e+2
	bmi	1f		// abs(x)<0.25, too small to need adjustment
	cmp	r2,#12
	bge	4f

2:	movs	r5,#17
	subs	r5,r2		// 15-e
	movs	r3,r1		// Q20
	asrs	r3,r5		// x Q5
	adds	r2,#8		// e+10
	adds	r5,#7		// 22-e = 32-(e+10)
	movs	r6,r0
	lsrs	r6,r5
	lsls	r0,r2
	lsls	r1,r2
	orrs	r1,r6		// r0:r1 x Q62

	ldmia	r4,{r4-r7}

	muls	r3,r4		// rx Q20
	asrs	r2,r3,#20
	movs	r3,#0
	adcs	r2,r3		// rx Q0 rounded = q; for e.g. r=1.5 abs(q)<1.5*2^10
	muls	r5,r2		// qd in pieces: L Q62
	muls	r6,r2		//               M Q41
	muls	r7,r2		//               H Q20
	lsls	r7,#10
	asrs	r4,r6,#11
	lsls	r6,#21
	adds	r6,r5
	adcs	r7,r4
	asrs	r5,#31
	adds	r7,r5		// r6:r7 qd Q62
	subs	r0,r6
	sbcs	r1,r7		// remainder Q62
	bx 	lr

4:	movs	r2,#12		// overflow: clamp to +/-1024
	movs	r0,#0
	asrs	r1,#31
	lsls	r1,#1
	adds	r1,#1
	lsls	r1,#20
	b	2b

1:	lsls	r1,#8
	lsrs	r3,r0,#24
	orrs	r1,r3
	lsls	r0,#8		// r0:r1 Q60, to be shifted down -r2 places
	negs	r3,r2
	adds	r2,#32		// shift down in r3, complementary shift in r2
	bmi	1f		// long shift?

2:	movs	r4,r1
	asrs	r1,r3
	lsls	r4,r2
	lsrs	r0,r3
	orrs	r0,r4
	movs	r2,#0		// rounding
	adcs	r0,r2
	adcs	r1,r2
	bx	lr

1:	movs	r0,r1		// down 32 places
	asrs	r1,#31
	subs	r3,#32
	adds	r2,#32
	bpl	2b
	movs	r0,#0		// very long shift? return 0
	movs	r1,#0
	movs	r2,#0
	bx	lr


regular_data_text dtab_cc

	.word 0x61bb4f69, 0x1dac6705   // atan 2^-1 Q62
	.word 0x96406eb1, 0x0fadbafc   // atan 2^-2 Q62
	.word 0xab0bdb72, 0x07f56ea6   // atan 2^-3 Q62
	.word 0xe59fbd39, 0x03feab76   // atan 2^-4 Q62
	.word 0xba97624b, 0x01ffd55b   // atan 2^-5 Q62
	.word 0xdddb94d6, 0x00fffaaa   // atan 2^-6 Q62
	.word 0x56eeea5d, 0x007fff55   // atan 2^-7 Q62
	.word 0xaab7776e, 0x003fffea   // atan 2^-8 Q62
	.word 0x5555bbbc, 0x001ffffd   // atan 2^-9 Q62
	.word 0xaaaaadde, 0x000fffff   // atan 2^-10 Q62
	.word 0xf555556f, 0x0007ffff   // atan 2^-11 Q62
	.word 0xfeaaaaab, 0x0003ffff   // atan 2^-12 Q62
	.word 0xffd55555, 0x0001ffff   // atan 2^-13 Q62
	.word 0xfffaaaab, 0x0000ffff   // atan 2^-14 Q62
	.word 0xffff5555, 0x00007fff   // atan 2^-15 Q62
	.word 0xffffeaab, 0x00003fff   // atan 2^-16 Q62
	.word 0xfffffd55, 0x00001fff   // atan 2^-17 Q62
	.word 0xffffffab, 0x00000fff   // atan 2^-18 Q62
	.word 0xfffffff5, 0x000007ff   // atan 2^-19 Q62
	.word 0xffffffff, 0x000003ff   // atan 2^-20 Q62
	.word 0x00000000, 0x00000200   // atan 2^-21 Q62 // consider optimising these
	.word 0x00000000, 0x00000100   // atan 2^-22 Q62
	.word 0x00000000, 0x00000080   // atan 2^-23 Q62
	.word 0x00000000, 0x00000040   // atan 2^-24 Q62
	.word 0x00000000, 0x00000020   // atan 2^-25 Q62
	.word 0x00000000, 0x00000010   // atan 2^-26 Q62
	.word 0x00000000, 0x00000008   // atan 2^-27 Q62
	.word 0x00000000, 0x00000004   // atan 2^-28 Q62
	.word 0x00000000, 0x00000002   // atan 2^-29 Q62
	.word 0x00000000, 0x00000001   // atan 2^-30 Q62
	.word 0x80000000, 0x00000000   // atan 2^-31 Q62
	.word 0x40000000, 0x00000000   // atan 2^-32 Q62


regular_func_text dcos_finish

// here
// r0:r1   eps (residual omega, where theta=alpha+eps) Q62, abs(eps)<=2^-32 (so fits in r0)
// r8:r9   cos alpha Q62
// r10:r11 sin alpha Q62
// and we wish to calculate cos theta=cos(alpha+eps)~cos alpha - eps sin alpha

	mov	r1,r11
// mov r2,r10
// lsrs r2,#31
// adds r1,r2                    // rounding improves accuracy very slightly
	muls32_s32_64 r0,r1, r2,r3, r4,r5,r6
// r2:r3   eps sin alpha Q(62+62-32)=Q92
	mov	r0,r8
	mov	r1,r9
	lsls	r5,r3,#2
	asrs	r3,r3,#30
	lsrs	r2,r2,#30
	orrs	r2,r5
	sbcs	r0,r2		// include rounding
	sbcs	r1,r3
	movs	r2,#62
	b 	fix642double

regular_func_text dsin_finish

// here
// r0:r1   eps (residual omega, where theta=alpha+eps) Q62, abs(eps)<=2^-32 (so fits in r0)
// r8:r9   cos alpha Q62
// r10:r11 sin alpha Q62
// and we wish to calculate sin theta=sin(alpha+eps)~sin alpha + eps cos alpha

	mov	r1,r9
	muls32_s32_64 r0,r1, r2,r3, r4,r5,r6
// r2:r3   eps cos alpha Q(62+62-32)=Q92
	mov	r0,r10
	mov	r1,r11
	lsls	r5,r3,#2
	asrs	r3,r3,#30
	lsrs	r2,r2,#30
	orrs	r2,r5
	adcs	r0,r2		// include rounding
	adcs	r1,r3
	movs	r2,#62
	b	fix642double

// ----------------------------------------------------------------------------
//                        Arc tangent of y/x
// ----------------------------------------------------------------------------
// double atan2(double y, double x);

wrapper_func_text atan2

// r0:r1 y
// r2:r3 x

	// save registers
	push	{r4-r7,lr}
	bl	push_r8_r11

	// check zero or infinity of 'y'
	ldr	r5,=0x7ff00000
	movs	r4,r1
	ands	r4,r5		// y==0?
	beq	1f
	cmp	r4,r5		// or Inf/NaN?
	bne	2f

	// clear mantissa of 'y'
1:	lsrs	r1,#20		// flush
	lsls	r1,#20
	movs	r0,#0

	// check zero or infinity of 'x'
2:	movs	r4,r3
	ands	r4,r5		// x==0?
	beq	1f
	cmp	r4,r5		// or Inf/NaN?
	bne	2f

	// clear mantissa of 'x'
1:	lsrs	r3,#20		// flush
	lsls	r3,#20
	movs	r2,#0

	// check sign of 'x' to determine quadrant
2:	movs	r6,#0		// quadrant offset = 0
	lsls	r5,#11		// constant 0x80000000
	cmp	r3,#0
	bpl	1f		// skip if x positive

	// 'x' is negative, prepare quadrant from 'y' -> R6
	movs	r6,#2
	eors	r3,r5
	eors	r1,r5
	bmi	1f		// quadrant offset=+2 if y was positive
	negs	r6,r6		// quadrant offset=-2 if y was negative

	// now in quadrant 0 or 3
1:	adds	r7,r1,r5	// r7=-r1
	bpl	1f

	// y>=0: in quadrant 0
	cmp	r1,r3
	ble	2f		// y<~x so 0<=theta<~pi/4: skip
	adds	r6,#1
	eors	r1,r5		// negate x
	b	3f		// and exchange x and y = rotate by -pi/2

1:	cmp	r3,r7
	bge	2f		// -y<~x so -pi/4<~theta<=0: skip
	subs	r6,#1
	eors	r3,r5		// negate y and ...

	// exchange x and y
3:	movs	r7,r0
	movs	r0,r2
	movs	r2,r7
	movs	r7,r1
	movs	r1,r3
	movs	r3,r7

// here -pi/4<~theta<~pi/4
// r6 has quadrant offset

2:	push	{r6}		// quadrant

	cmp	r2,#0
	bne	1f
	cmp	r3,#0
	beq	10f		// x==0 going into division?
	lsls	r4,r3,#1
	asrs	r4,#21
	adds	r4,#1
	bne	1f		// x==Inf going into division?
	lsls	r4,r1,#1
	asrs	r4,#21
	adds	r4,#1		// y also ±Inf?
	bne	10f
	subs	r1,#1		// make them both just finite
	subs	r3,#1
	b	1f

10:	movs	r0,#0
	movs	r1,#0
	b	12f

	// divide y/x
1:	bl	ddiv
	movs	r2,#62
	bl	double2fix64

// r0:r1 y/x

	mov	r10,r0
	mov	r11,r1
	movs	r0,#0		// omega=0
	movs	r1,#0
	mov	r8,r0
	movs	r2,#1
	lsls	r2,#30
	mov	r9,r2		// x=1

	ldr	r4,=dtab_cc
	mov	r12,r4
	movs	r7,#1
	movs	r6,#31

	// cordic calculation
1:	bl	dcordic_vec_step
	adds	r7,#1
	subs	r6,#1
	cmp	r7,#33
	bne	1b

// r0:r1   atan(y/x) Q62
// r8:r9   x residual Q62
// r10:r11 y residual Q62

	mov	r2,r9
	mov	r3,r10
	subs	r2,#12		// this makes atan(0)==0

// the following is basically a division residual y/x ~ atan(residual y/x)

	movs	r4,#1
	lsls	r4,#29
	movs	r7,#0

2:	lsrs	r2,#1
	movs	r3,r3		// preserve carry
	bmi	1f
	sbcs	r3,r2
	adds	r0,r4
	adcs	r1,r7
	lsrs	r4,#1
	bne	2b
	b	3f

1:	adcs	r3,r2
	subs	r0,r4
	sbcs	r1,r7
	lsrs	r4,#1
	bne	2b

3:	lsls	r6,r1,#31
	asrs	r1,#1
	lsrs	r0,#1
	orrs	r0,r6		// Q61

12:	pop	{r6}		// quadrant

	// shift result by quadrant
	cmp	r6,#0
	beq	1f
	ldr	r4,=0x885A308D	// pi/2 Q61
	ldr	r5,=0x3243F6A8
	bpl	2f
	mvns	r4,r4		// negative quadrant offset
	mvns	r5,r5

2:	lsls	r6,#31
	bne	2f		// skip if quadrant offset is ±1
	adds	r0,r4
	adcs	r1,r5
2:	adds	r0,r4
	adcs	r1,r5
1:	movs	r2,#61
	bl	fix642double

	// pop registers
	bl	pop_r8_r11
	pop	{r4-r7,pc}

// ----------------------------------------------------------------------------
//                            Natural exponent
// ----------------------------------------------------------------------------
// double exp(double x);

wrapper_func_text exp

	push	{r4-r7,r14}
// input: R1:R0 = double number
// output: R1:R0 = signed mantissa with hidden implied '1' set (53 significant bits)
//         R2 = absolute exponent without offset
// trashes: R3, R4
	bl	dunpacks
	ldr	r4,=dreddata1
	bl	dreduce
	cmp	r1,#0
	bge	1f
	ldr	r4,=0xF473DE6B
	ldr	r5,=0x2C5C85FD	// ln2 Q62
	adds	r0,r4
	adcs	r1,r5
	subs	r2,#1

1:	push	{r2}
	movs	r7,#1		// shift
	ldr	r6,=dtab_exp
	movs	r2,#0
	movs	r3,#1
	lsls	r3,#30		// x=1 Q62

3:	ldmia	r6!,{r4,r5}
	mov	r12,r6
	subs	r0,r4
	sbcs	r1,r5
	bmi	1f

	negs	r6,r7
	adds	r6,#32		// complementary shift
	movs	r5,r3
	asrs	r5,r7
	movs	r4,r3
	lsls	r4,r6
	movs	r6,r2
	lsrs	r6,r7		// rounding bit in carry
	orrs	r4,r6
	adcs	r2,r4
	adcs	r3,r5		// x+=x>>i
	b	2f

1:	adds	r0,r4		// restore argument
	adcs	r1,r5
2:	mov	r6,r12
	adds	r7,#1
	cmp	r7,#33
	bne	3b

// here
// r0:r1   eps (residual x, where x=a+eps) Q62, abs(eps)<=2^-32 (so fits in r0)
// r2:r3   exp a Q62
// and we wish to calculate exp x=exp a exp eps~(exp a)(1+eps)

	muls32_32_64 r0,r3, r4,r1, r5,r6,r7

// r4:r1 eps exp a Q(62+62-32)=Q92

	lsrs	r4,#30
	lsls	r0,r1,#2
	orrs	r0,r4
	asrs	r1,#30
	adds	r0,r2
	adcs	r1,r3

	pop	{r2}
	negs	r2,r2
	adds	r2,#62
	bl	fix642double	// in principle we can pack faster than this because we know the exponent
	pop	{r4-r7,pc}

// ----------------------------------------------------------------------------
//                            Natural logarithm
// ----------------------------------------------------------------------------
// double log(double x);

wrapper_func_text log

	push	{r4-r7,lr}
	lsls	r7,r1,#1
	bcs	5f		// <0 ...
	asrs	r7,#21
	beq	5f		// ... or =0? return -Inf
	adds	r7,#1
	beq	6f		// Inf/NaN? return +Inf
// input: R1:R0 = double number
// output: R1:R0 = signed mantissa with hidden implied '1' set (53 significant bits)
//         R2 = absolute exponent without offset
// trashes: R3, R4
	bl	dunpacks
	push	{r2}
	lsls	r1,#9
	lsrs	r2,r0,#23
	orrs	r1,r2
	lsls	r0,#9

// r0:r1 m Q61 = m/2 Q62 0.5<=m/2<1

	movs	r7,#1		// shift
	ldr	r6,=dtab_exp
	mov	r12,r6
	movs	r2,#0
	movs	r3,#0		// y=0 Q62

3:	negs	r6,r7
	adds	r6,#32		// complementary shift
	movs	r5,r1
	asrs	r5,r7
	movs	r4,r1
	lsls	r4,r6
	movs	r6,r0
	lsrs	r6,r7
	orrs	r4,r6		// x>>i, rounding bit in carry
	adcs	r4,r0
	adcs	r5,r1		// x+(x>>i)

	lsrs	r6,r5,#30
	bne	1f		// x+(x>>i)>1?
	movs	r0,r4
	movs	r1,r5		// x+=x>>i
	mov	r6,r12
	ldmia	r6!,{r4,r5}
	subs	r2,r4
	sbcs	r3,r5

1:	movs	r4,#8
	add	r12,r4
	adds	r7,#1
	cmp	r7,#33
	bne	3b

// here:
// r0:r1 residual x, nearly 1 Q62
// r2:r3 y ~ ln m/2 = ln m - ln2 Q62
// result is y + ln2 + ln x ~ y + ln2 + (x-1)

	lsls	r1,#2
	asrs	r1,#2		// x-1
	adds	r2,r0
	adcs	r3,r1

	pop	{r7}

// here:
// r2:r3 ln m/2 = ln m - ln2 Q62
// r7    unbiased exponent

.equ dreddata1_plus_4, (dreddata1+4)

	ldr	r4,=dreddata1_plus_4
	ldmia	r4,{r0,r1,r4}
	adds	r7,#1
	muls	r0,r7		// Q62
	muls	r1,r7		// Q41
	muls	r4,r7		// Q20
	lsls	r7,r1,#21
	asrs	r1,#11
	asrs	r5,r1,#31
	adds	r0,r7
	adcs	r1,r5
	lsls	r7,r4,#10
	asrs	r4,#22
	asrs	r5,r1,#31
	adds	r1,r7
	adcs	r4,r5

// r0:r1:r4 exponent*ln2 Q62

	asrs	r5,r3,#31
	adds	r0,r2
	adcs	r1,r3
	adcs	r4,r5

// r0:r1:r4 result Q62

	movs	r2,#62
1:	asrs	r5,r1,#31
	cmp	r4,r5
	beq	2f		// r4 a sign extension of r1?
	lsrs	r0,#4		// no: shift down 4 places and try again
	lsls	r6,r1,#28
	orrs	r0,r6
	lsrs	r1,#4
	lsls	r6,r4,#28
	orrs	r1,r6
	asrs	r4,#4
	subs	r2,#4
	b	1b

	// return number
2:	bl	fix642double
	pop	{r4-r7,pc}

	// return overflow
5:	ldr	r1,=0xfff00000
	movs	r0,#0
	pop	{r4-r7,pc}

	// return 1
6:	ldr	r1,=0x7ff00000
	movs	r0,#0
	pop	{r4-r7,pc}

.ltorg

regular_data_text dreddata1

	.word 0x0000B8AA	// 1/ln2 Q15
	.word 0x0013DE6B	// ln2 Q62 Q62=2C5C85FDF473DE6B split into 21-bit pieces
	.word 0x000FEFA3
	.word 0x000B1721

regular_data_text dtab_exp

	.word 0xbf984bf3, 0x19f323ec   // log 1+2^-1 Q62
	.word 0xcd4d10d6, 0x0e47fbe3   // log 1+2^-2 Q62
	.word 0x8abcb97a, 0x0789c1db   // log 1+2^-3 Q62
	.word 0x022c54cc, 0x03e14618   // log 1+2^-4 Q62
	.word 0xe7833005, 0x01f829b0   // log 1+2^-5 Q62
	.word 0x87e01f1e, 0x00fe0545   // log 1+2^-6 Q62
	.word 0xac419e24, 0x007f80a9   // log 1+2^-7 Q62
	.word 0x45621781, 0x003fe015   // log 1+2^-8 Q62
	.word 0xa9ab10e6, 0x001ff802   // log 1+2^-9 Q62
	.word 0x55455888, 0x000ffe00   // log 1+2^-10 Q62
	.word 0x0aa9aac4, 0x0007ff80   // log 1+2^-11 Q62
	.word 0x01554556, 0x0003ffe0   // log 1+2^-12 Q62
	.word 0x002aa9ab, 0x0001fff8   // log 1+2^-13 Q62
	.word 0x00055545, 0x0000fffe   // log 1+2^-14 Q62
	.word 0x8000aaaa, 0x00007fff   // log 1+2^-15 Q62
	.word 0xe0001555, 0x00003fff   // log 1+2^-16 Q62
	.word 0xf80002ab, 0x00001fff   // log 1+2^-17 Q62
	.word 0xfe000055, 0x00000fff   // log 1+2^-18 Q62
	.word 0xff80000b, 0x000007ff   // log 1+2^-19 Q62
	.word 0xffe00001, 0x000003ff   // log 1+2^-20 Q62
	.word 0xfff80000, 0x000001ff   // log 1+2^-21 Q62
	.word 0xfffe0000, 0x000000ff   // log 1+2^-22 Q62
	.word 0xffff8000, 0x0000007f   // log 1+2^-23 Q62
	.word 0xffffe000, 0x0000003f   // log 1+2^-24 Q62
	.word 0xfffff800, 0x0000001f   // log 1+2^-25 Q62
	.word 0xfffffe00, 0x0000000f   // log 1+2^-26 Q62
	.word 0xffffff80, 0x00000007   // log 1+2^-27 Q62
	.word 0xffffffe0, 0x00000003   // log 1+2^-28 Q62
	.word 0xfffffff8, 0x00000001   // log 1+2^-29 Q62
	.word 0xfffffffe, 0x00000000   // log 1+2^-30 Q62
	.word 0x80000000, 0x00000000   // log 1+2^-31 Q62
	.word 0x40000000, 0x00000000   // log 1+2^-32 Q62

#endif // USE_DOUBLE		// use double support

#if USE_FLOAT || USE_DOUBLE	// use float or double support

// ----------------------------------------------------------------------------
//                       Convert double to float
// ----------------------------------------------------------------------------
// float d2f(double num);
// float double2float(double num);

regular_func_text double2float
regular_func d2f
wrapper_func __aeabi_d2f

	// prepare exponent -> R2
	lsls	r2,r1,#1	// remove sign bit
	lsrs	r2,#21		// isolate exponent
	ldr	r3,=0x3ff-0x7f	// difference of exponent biases
	subs	r2,r3		// fix exponent bias
	ble	1f		// underflow or zero

	// overflow or infinity
	cmp	r2,#0xff	// check max. exponent of float
	bge	2f		// overflow or infinity

	// shift exponent to its final position -> R2
	lsls	r2,#23		// position exponent of result

	// isolate sign bit -> R3
	lsrs	r3,r1,#31	// isolate sign bit
	lsls	r3,#31		// shift sign bit on its final position

	// add sign bit to exponent -> R2
	orrs	r2,r3

	// prepare rounding bits -> R3
	lsls	r3,r0,#3	// rounding bits -> R3

	// prepare mantissa
	lsrs	r0,#29		// get 3 lowest bits -> R0
	lsls	r1,#12		// remove exponent from mantissa high
	lsrs	r1,#9		// shift mantissa to its position
	orrs	r0,r1		// assemble low and high mantissa

	// assemble number
	orrs	r0,r2		// insert exponent and sign to mantissa
	lsls	r3,#1		// check rounding bit
	bcc	3f		// no rounding, exit
	beq	4f		// all sticky bits are 0, do even rounding

	// rounding up
5:	adds	r0,#1		// increase mantissa
				// In the case of mantissa 0xfff..., the mantissa 
				//   is changed to 0x000 and the exponent is incremented.
3:	bx	lr

	// all sticky bits are 0, do rounding to even
4:	lsrs	r3,r0,#1	// check if mantissa is odd
	bcs	5b		// mantissa is odd, than do rounding
	bx	lr

	// underflow, result is +0.0 or -0.0
1:	beq	6f		// check case where value is just less than smallest normal
7:	lsrs	r0,r1,#31	// isolate sign bit
	lsls	r0,#31		// shift sign bit back
	bx	lr

	// near underflow ... check if top 20 bits (in R1) are all 1s
6:	lsls	r2,r1,#12	// 20 1s at top of mantissa?
	asrs	r2,#12		// duplicate top bit
	adds	r2,#1		// add 1 to check if R2 is all 1s
	bne	7b		// not all 1s, result is zero

	// check if lower 3 bits (in R0) are all 1s
	lsrs	r2,r0,#29	// sift 3 bits down
	cmp	r2,#7		// all 3 bits are 1s ?
	bne	7b		// not all 1s, result is zero

	// result is smallest normal with correct sign
	movs	r2,#1		// return smallest normal with correct sign, exponent = 1
	b	8f

	// overflow or infinity
2:	movs	r2,#0xff	// infinity exponent -> R2
8:	lsrs	r0,r1,#31	// isolate sign bit
	lsls	r0,#8		// sift sign bit to position of exponent
	adds	r0,r2		// add sign bit with exponent
	lsls	r0,#23		// shift sign bit with exponent to its position
	bx	lr

#endif // USE_FLOAT || USE_DOUBLE	// use float or double support

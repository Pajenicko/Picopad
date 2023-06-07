
// ****************************************************************************
//
//                        Single-floating-point assembler
//
// ****************************************************************************
// Copyright (c) 2020 Mark Owen https://www.quinapalus.com - GPLv2 licence
// Copyright (c) 2020 Raspberry Pi (Trading) Ltd. - SPDX-License-Identifier: BSD-3-Clause
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../asm_include.inc"

	.syntax unified
	.cpu cortex-m0plus
	.thumb

#define FLOAT_EXP_BITS	8		// number of bits of exponent
#define FLOAT_EXP_MAX	0xFF		// max. value of exponent
#define FLOAT_EXP_SHIFT	23		// shift of exponent
#define FLOAT_EXP_BIAS	127		// bias of exponent (= value 1.0)
#define FLOAT_MANT_BITS	23		// number of bits of mantissa
#define FLOAT_MANT_MASK	0x007FFFFF	// mantissa mask


#if USE_FLOAT		// use float support


// macro - jump to function from single-floating-point table
.macro sf_jump sf_offset
	ldr	r3,=SFTable		// get pointer to single-floating-point table
	ldr	r3,[r3,#\sf_offset]	// get pointer to function
	bx	r3			// jump to function
.endm

// macro - call functon from single-floating-point table
.macro sf_call sf_offset
	ldr	r3,=SFTable		// get pointer to single-floating-point table
	ldr	r3,[r3,#\sf_offset]	// get pointer to function
	blx	r3			// call function
.endm


// ==== basic arithmetics


// ----------------------------------------------------------------------------
//                    Reverse subtraction, y - x
// ----------------------------------------------------------------------------

wrapper_func_text __aeabi_frsub

	// exchange operands
	eors	r0,r1
	eors	r1,r0
	eors	r0,r1

// ---- continue to function fsub

// ----------------------------------------------------------------------------
//                         Subtraction, x - y
// ----------------------------------------------------------------------------
// float fsub(float x, float y);

regular_func fsub
wrapper_func __aeabi_fsub

	sf_jump	SF_TABLE_FSUB		// jump to bootrom a-b

// ----------------------------------------------------------------------------
//                         Addition, x + y
// ----------------------------------------------------------------------------
// float fadd(float x, float y);

regular_func_text fadd
wrapper_func __aeabi_fadd

	sf_jump	SF_TABLE_FADD		// jump to bootrom a+b


// ==== original bootrom commented code, for illustration only

#if 0

	// push registers
	push	{r4,r5,r6,lr}		// push registers

	// get sign of 'x' -> R4
	asrs	r4,r0,#31		// isolate sign of 'x' 0 or -1 -> R4

	// get exponent of 'x' -> R2, check zero
	lsls	r2,r0,#1		// remove sign of 'x'
	lsrs	r2,#24			// isolate exponent of 'x' -> R2
	beq	fa_xe0			// number 'x' is zero

	// check infinity of 'x'
	cmp	r2,#255			// infinity?
	beq	fa_xe255		// number 'x' is infinity

// Here is R2 = -32 for +0, -33 for -0, 0xff00 for +Inf, 0xfeff for -Inf

fa_xe:
	// get sign of 'y' -> R5
	asrs	r5,r1,#31		// isolate sign of 'y' 0 or -1 -> R5

	// get exponent of 'y' -> R3, check zero
	lsls	r3,r1,#1		// remove sign of 'y'
	lsrs	r3,#24			// isolat exponent of 'y' -> R3
	beq	fa_ye0			// number 'y' is zero

	// check infinity of 'y'
	cmp	r3,#255			// infinity?
	beq	fa_ye255		// number 'y' is infinity

// Here is R3 = -32 for +0, -33 for -0, 0xff00 for +Inf, 0xfeff for -Inf

fa_ye:
	// isolate mantissas
	ldr	r6,=#0x007fffff		// mask of mantissa -> R6
	ands	r0,r0,r6		// isolate mantissa of 'x' -> R0
	ands	r1,r1,r6		// isolate mantissa of 'y' -> R1

	// set implied hidden bit '1'
	adds	r6,#1			// implied bit 0x00800000 -> R6
	orrs	r0,r0,r6		// set hidden implied bit '1' to 'x' -> R0
	orrs	r1,r1,r6		// set hidden implied bit '1' to 'y' -> R1

	// negate mantissas
	eors	r0,r0,r4		// complement mantissa 'x' if sign1 = -1
	eors	r1,r1,r5		// complement mantissa 'y' if sign2 = -1
	subs	r0,r0,r4		// add 1 to 'x' if sign bit sign1 is set -> negate 'x'
	subs	r1,r1,r5		// add 1 to 'y' if sign bit sign2 is set -> negate 'y'

	// difference of exponents
	subs	r5,r3,r2		// difference of exponents ye-xe -> R5
	subs	r4,r2,r3		// difference of exponents xe-ye -> R4
	bmi	fa_ygtx			// go to case of 'y' > 'x'

// here is 'x' >= 'y'

	// check max. difference
	cmp	r4,#30			// check max. difference of numbers
	bge	fa_xmgty		// 'x' is much greater than 'y'

	// prepare shifts
	adds	r5,#32			// ye-xe+32, difference to shift 'y'
	movs	r3,r2			// save exponent 'x' as result exponent

	// here y in R1 must be shifted down R4 places to align with x in R0
	movs	r2,r1			// mantissa 'y' -> R2
	lsls	r2,r2,r5		// save low part of 'y' -> R2 (will be used as carry)
	asrs	r1,r1,r4		// shift 'y' right
	b	fa_0

fa_ymgtx:
	// 'y' is much greater than 'x', result will be just 'y'
	movs	r2,#0			// clear carry from lower part
	movs	r0,r1			// mantissa of 'y' as result mantissa -> R0
	b	fa_1

fa_xmgty:
	// 'x' is much greater than 'y', result will be just 'x'
	movs	r3,r2			// exponent of 'x' as result exponent -> R3
	movs	r2,#0			// clear carry from lower part
	b	fa_1

// here is 'x' < 'y'

fa_ygtx:
	// check max. difference
	cmp	r5,#30			// check max. difference of numbers
	bge	fa_ymgtx		// 'y' is much greater than 'x'

	// prepare shifts
	adds	r4,#32			// xe-ye+32, difference to shift 'x'

	// here x in R0 must be shifted down R5 places to align with y in R1
	movs	r2,r0			// mantissa 'x' -> R2
	lsls	r2,r2,r4		// save low part of 'x' -> R2 (will be used as carry)
	asrs	r0,r0,r5		// shift 'x' right

fa_0:
	// sum mantissas
	adds	r0,r1			// sum mantissas (low carry part is in R2)
	beq	fa_9			// result mantissa is zero, return will be 0 (check the lower part yet)

fa_1:
	// check sign of result
	lsrs	r1,r0,#31		// get sign of result -> R1
	beq	fa_8			// result is positive

	// absolute value of result
	mvns	r0,r0			// not high part of result -> R1
	rsbs	r2,r2,#0		// ngate lower part -> R2
	bne	fa_8			// lower part is not 0
	adds	r0,#1			// correct higher part

fa_8:
	// check if mantissa is normalised
	adds	r6,r6			// 0x00800000 -> 0x01000000 in R6, to chceck higher carry bit
	cmp	r0,r6			// check sum overflow
	bhs	fa_2			// overflow

fa_3:
	// normalise mantissa (shift left)
	adds	r2,r2			// shift mantissa low
	adcs	r0,r0			// shift mantissa high
	subs	r3,#1			// adjust exponent
	cmp	r0,r6			// is mantissa already normalised?
	blo	fa_3			// next normalisation step
fa_2:
	// shift mantissa right and check rounding bit
	lsrs	r0,#1			// shift mantissa right
	bcc	fa_4			// no rounding

	// rounding mantissa up
	adds	r0,#1			// increment mantissa to round up
	cmp	r2,#0			// check sticky bits of lower part
	beq	fa_5			// sticky bits are all zero, round to even mantissa

fa_4:
	// check overflow (here is "exponent - 1")
	cmp	r3,#254			// check overflow or underflow
	bhs	fa_6			// exponent is too large or negative

	// pack result (here is "exponent - 1" to remove hidden bit '1')
	lsls	r1,#31			// shift result sign to bit 31 -> R1
	add	r0,r1			// assembler mantissa and sign
	lsls	r3,#23			// shift exponent to position
	add	r0,r3			// add exponent and remove hidden bit '1'

fa_end:
	// pop registers and exit
	pop	{r4,r5,r6,pc}

fa_9:
	// sum of mantissas is zero, check lower part to round
	cmp	r2,#0		// check lower part of sum
	beq	fa_end		// result will be 0
	b	fa_1		// not all number is zero

fa_5:
	// sticky bits are all zero, round to even mantissa
	lsrs	r0,#1		// destroys lowest bit of mantissa
	lsls	r0,#1		// restore, now rounded to even
	b	fa_4		// continue

fa_6:
	// exponent is too large or negative
	bge	fa_7		// exponent is infinity

	// underflow
	lsls	r0,r1,#31	// get sign bit, result will be +0.0 or -0.0
	pop	{r4,r5,r6,pc}	// pop registers and exit

fa_7:
	// overflow
	lsls	r0,r1,#8	// shift sign to bit 8
	adds	r0,#255		// add overflow exponent, here is 0x1ff if negative, 0x0ff if positive
	lsls	r0,#23		// shift exponent to position (+inf or -inf)
	pop	{r4,r5,r6,pc}	// pop registers and exit

fa_xe0:
	// number 'x' is zero
	subs	r2,#32		// R2 <- -32
	adds	r2,r4		// add sign of 'x' 0 or -1 ... exponent -32 for +0, -33 for -0
	b	fa_xe		// continue

fa_xe255:
	// number 'x' is infinity
	lsls	r2,#8		// R2 <- 0xff00
	add	r2,r2,r4	// add sign of 'x' 0 or -1 ... exponent 0xff00 for +Inf, 0xfeff for -Inf
	b	fa_xe		// continue

fa_ye0:
	// number 'y' is zero
	subs	r3,#32		// R3 <- -32
	adds	r3,r5		// add sign of 'y' 0 or -1 ... exponent -32 for +0, -33 for -0
	b	fa_ye		// continue

fa_ye255:
	// number 'y' is infinity
	lsls	r3,#8		// R3 <- 0xff00
	add	r3,r3,r5	// add sign of 'y' 0 or -1 ... exponent 0xff00 for +Inf, 0xfeff for -Inf
	b	fa_ye		// continue

#endif

// ----------------------------------------------------------------------------
//                             Square, x^2
// ----------------------------------------------------------------------------
// float fsqr(float x);

regular_func_text fsqr

	// duplicate operand
	movs	r1,r0

// ---- continue to fmul

// ----------------------------------------------------------------------------
//                        Multiplication, x * y
// ----------------------------------------------------------------------------
// float fmul(float x, float y);

regular_func fmul
wrapper_func __aeabi_fmul

	sf_jump	SF_TABLE_FMUL		// jump to bootrom a*b


// ==== original bootrom commented code, for illustration only

#if 0

	// push registers
	push	{r7,lr}

	// prepare result sign -> LR, bit 31
	mov	r2,r0		// number 'x' -> R2
	eors	r2,r1		// 'x' XOR 'y' to get result sign
	lsrs	r2,#31		// isolate sign bit
	lsls	r2,#31		// return sign bit to position 31
	mov	lr,r2		// save sign -> LR

	// remove sign bit
	lsls	r0,#1		// remove sign bit from 'x'
	lsls	r1,#1		// remove sign bit from 'y'

	// get exponent of 'x' -> R2, check range
	lsrs	r2,r0,#24	// isolate exponent of 'x' -> R2
	beq	fm_xe0		// 'x' is zero
	cmp	r2,#255		// check if 'x' is infinity
	beq	fm_xe255	// 'x' is infinity

fm_xe:
	// get exponent of 'y' -> R3, check range
	lsrs	r3,r1,#24	// isolate exponent of 'y' -> R3
	beq	fm_ye0		// 'y' is zero
	cmp	r3,#255		// check if 'y' is infinity
	beq	fm_ye255	// 'y' is infinity

fm_ye:
	// prepare result exponent -> R7
	adds	r7,r2,r3	// sum of exponents -> R7
	subs	r7,#128		// subtract bias + 1

	// isolate mantissas -> R0, R1
	lsls	r0,#8		// remove exponent from 'x'
	lsls	r1,#8		// remove exponent from 'y'
	lsrs	r0,#9		// shift mantissa of 'x' back
	lsrs	r1,#9		// shift mantissa of 'y' back

// Here is:
//  R0 = mantissa of 'x', bits 0..22 (23 bits)
//  R1 = mantissa of 'y', bits 0..22 (23 bits)
//  R7 = result exponent
//  LR = result sign at bit 31

	// save sum of mantissas 'x'+'y' for later -> R12 (24 bits)
	adds	r2,r0,r1	// sum of mantissas -> R2
	mov	r12,r2		// sum of mantissas -> R12

	// multiply high parts of mantissas, to get high part of result -> R2
	lsrs	r2,r0,#7	// isolate top 16 bits of mantissa 'x' -> R2
	lsrs	r3,r1,#7	// isolate top 16 bits of mantissa 'y' -> R3
	muls	r2,r2,r3	// multiply top 16 bits of mantissas -> R2 (32 high bits) 

	// multiply mantissas, to get low part of result -> R0
	muls	r0,r0,r1	// multiply mantissas -> R0 (32 low bits)

	// shift high part
	lsrs	r2,#18		// get top 14 bits of high result -> R2
	bcc	1f		// no carry to low part
	cmp	r0,#0		// check bit 32 of low result
	bmi	1f		// bit 32 of low result is set
	adds	r2,#1		// high result + 1

	// combine multiply parts
1:	lsls	r3,r0,#9	// get low 23 bits of low result -> R3
	lsrs	r0,#23		// get high 9 bits of low result -> R0
	lsls	r2,#9		// shift 14 bits of high result to result position 9
	adds	r0,r2		// add high 9 bits od low result to 14 bits of high result -> R0
	add	r0,r12		// add sum of mantissas (implied 1*(x+y) to compensate for no insertion of implied 1s)

// result-1 is in R0:R3

	// check if result is normalized (result is 2.xxxx)
	lsrs	r1,r0,#23	// check next bit above mantissa
	bne	fm_0		// we need to shift down one place

	// result is OK at interval 1.xxx <= R0 < 2.xxxx, check exponent
	cmp	r7,#254		// check exponent
	bhs	fm_3a		// exponent is underflow or overflow

	// rounding
	lsls	r3,#1		// check sticky bits at top of R3
	bcc	fm_1		// no rounding
	beq	fm_2		// sticky bits are = 0, rounding to even mantissa
	adds	r0,#1		// round mantissa up

fm_1:
	// assembler result
	adds	r7,#1		// add implied 1 to exponent
	lsls	r7,#23		// shift exponent to position
	add	r0,r7		// add exponent to mantissa
	add	r0,lr		// add sign bit to result
	pop	{r7,pc}		// pop registers and return

fm_2:
	// rounding up to even mantissa
	adds	r0,#1		// mantissa + 1 to round up

fm_3:
	// get even mantissa
	lsrs	r0,#1		// shift mantissa right, to delete bit 0
	lsls	r0,#1		// return mantissa back, mantissa is now even
	b	fm_1		// continue

fm_0:
	// check overflow and underflow
	adds	r7,#1		// increment exponent
	cmp	r7,#254		// check overflow
	bhs	fm_3b		// underflow and overflow

	// shift mantissa down and check rounding
	lsrs	r0,#1		// shift mantissa down
	bcc	fm_1a		// no rounding

	// rounding
	adds	r0,#1		// round manitssa up
	cmp	r3,#0		// check sticky bits
	beq	fm_3c		// sticky bits are 0, rounding to even mantissa

fm_1a:
	// assemble result
	adds	r7,r7		// shift exponent left
	adds	r7,#1		// add implied 1 to exponent
	lsls	r7,#22		// shift exponent to its position
	add	r0,r7		// add exponent to mantissa
	add	r0,lr		// add sign bit
	pop	{r7,pc}		// pop registrs and return

fm_3c:
	// rounding to even mantissa
	lsrs	r0,#1		// shift mantissa down to delete bit 0
	lsls	r0,#1		// shift mantissa back, mantissa is now even
	b	fm_1a		// continue

fm_xe0:
	// 'x' is zero
	subs	r2,#16		// R2 <- -16, exponent of zero

fm_xe255:
	// 'x' is infinity
	lsls	r2,#8		// R2 <- 0xff00, exponent of infinity
	b	fm_xe		// continue

fm_ye0:
	// 'y' is zero
	subs	r3,#16		// R3 <- -16, exponent of zero

fm_ye255:
	// 'y' is infinity
	lsls	r3,#8		// R3 <- 0xff00, exponent of infinity
	b	fm_ye		// continue

fm_3b:
	// result is underflow or overflow
	bge	fm_4		// result is overflow

	// result is underflow - trap case with rounding denormal "0x007fffff + 0.5"
	adds	r7,#1		// exponent + 1
	bne	fm_5		// exponent not zero, result will be +0.0 or -0.0

	// mantissa is 2.FFFFFC
	adds	r0,#2		// add rounding correction
	lsrs	r0,#23		// get top bits above mantissa
	cmp	r0,#3		// is mantissa 3.xxx ?
	bne	fm_5		// no, result will be +0.0 or -0.0
	b	fm_6		// result will be smallest normal

fm_3a:
	// result is underflow or overflow
	bge	fm_4		// result is overflow

	// result is underflow - trap case with rounding denormal "0x007fffff + 0.5"
	adds	r7,#1		// exponent + 1
	bne	fm_5		// exponent not zero, result will be +0.0 or -0.0

	// check mantissa 0xffffff
	adds	r0,#1		// mantissa + 1
	lsrs	r0,#23		// check next bit above mantissa
	beq	fm_5		// result will be +0.0 or -0.0

fm_6:
	// result will be smallest normal
	movs	r0,#1		// R0 <- smallest exponent 1
	lsls	r0,#23		// shift '1' to exponent position
	add	r0,lr		// add sign bit
	pop	{r7,pc}		// pop registers and return

fm_5:
	// result will be +0.0 or -0.0
	mov	r0,lr		// get sign bit at position 31 -> result in R0
	pop	{r7,pc}		// pop registers and return

fm_4:
	// result is overflow
	movs	r0,#0xff	// R0 <- infinity exponent 0xff
	lsls	r0,#23		// shift exponent to position
	add	r0,lr		// add sign bit
	pop	{r7,pc}		// pop registers and return

#endif

// ----------------------------------------------------------------------------
//                 Multiply by unsigned integer u16, x * n
// ----------------------------------------------------------------------------
// float fmulu16(float x, u16 n);

regular_func_text fmulu16

	// get exponent of 'x' -> R2
	lsls	r2,r0,#1		// destroy sign bit of 'x'
	lsrs	r2,#FLOAT_EXP_SHIFT+1	// isolate exponent of 'x'
	beq	fmulu16_x		// 'x' is zero, result will be 'x'
	cmp	r2,#FLOAT_EXP_MAX	// check infinity
	beq	fmulu16_x		// 'x' is infinity, result will be 'x'

	// check number 'n'
	uxth	r1,r1			// expand to 16-bit unsigned -> R1
	cmp	r1,#1			// check '1'
	beq	fmulu16_x		// 'n' is 1, result will be 'x'
	blo	fmulu16_0		// 'n' is 0, result will be 0

	// prepare result sign -> R12
	lsrs	r3,r0,#31		// isolate sign bit from 'x'
	lsls	r3,#31			// shift sign bit back to its position
	mov	r12,r3			// save result sign -> R12

	// isolate mantissa -> R0 (shift mantissa to position 8..30)
	lsls	r0,#FLOAT_EXP_BITS	// remove sign and exponent

	// restore hidden bit '1'
	movs	r3,#1			// R3 <- 1
	lsls	r3,#31			// shift to position 31, 0x80000000 -> R3
	orrs	r0,r3			// restore hidden bit '1' in 'x'

// Here is:
//  R0 = unsigned mantissa of 1st number mant1 (24 bits on bit position 8..31)
//  R1 = unsigned number u16
//  R2 = result exponent exp
//  R12 = result sign 0 or 0x80000000

	// multiply mantissa R0 * R1 -> R1 (16 bits) : R0 (32 bits)
	lsrs	r3,r0,#16		// high 16 bits of mantissa -> R3
	muls	r3,r1			// multiply high 16 bits -> R3
	uxth	r0,r0			// extract low 16 bits of mantissa -> R0
	muls	r0,r1			// multiply low 16 bits -> R0
	lsls	r1,r3,#16		// low 16 bits of result high -> R1
	lsrs	r3,#16			// high 16 bits of result high -> R3
	adds	r0,r1			// add low 16 bits of result high to result low -> R0
	movs	r1,#0			// R1 <- 0 (carry will stay unchanged)
	adcs	r1,r3			// carry to result high

	// normalize mantissa, shift right by 8 bits
	lsrs	r3,r1,#8		// check R1 > 8 bits
	beq	1f			// result high is <= 8 bits
	lsrs	r0,#8			// shift mantissa low
	lsls	r3,r1,#24		// get lower 8 bits -> R3
	orrs	r0,r3			// carry to lower part
	lsrs	r1,#8			// shift mantissa high
	adds	r2,#8			// shift exponent

	// normalize mantissa, shift right by 4 bits
1:	lsrs	r3,r1,#4		// check R1 > 4 bits
	beq	1f			// result high is <= 4 bits
	lsrs	r0,#4			// shift mantissa low
	lsls	r3,r1,#28		// get lower 4 bits -> R3
	orrs	r0,r3			// carry to lower part
	lsrs	r1,#4			// shift mantissa high
	adds	r2,#4			// shift exponent

	// normalize mantissa, shift right by 2 bits
1:	lsrs	r3,r1,#2		// check R1 > 2 bits
	beq	1f			// result high is <= 2 bits
	lsrs	r0,#2			// shift mantissa low
	lsls	r3,r1,#30		// get lower 2 bits -> R3
	orrs	r0,r3			// carry to lower part
	lsrs	r1,#2			// shift mantissa high
	adds	r2,#2			// shift exponent

	// normalize mantissa, shift right by 1 bit
1:	lsrs	r3,r1,#1		// check R1 > 1 bit
	beq	1f			// result high is <= 1 bits
	lsrs	r0,#1			// shift mantissa low
	lsls	r3,r1,#31		// get lower 1 bit -> R3
	orrs	r0,r3			// carry to lower part
	lsrs	r1,#1			// shift mantissa high
	adds	r2,#1			// shift exponent

	// normalize mantissa, shift right by last 1 bit
1:	cmp	r1,#0			// check R1 > 0 bit
	beq	1f			// result high is < 1 bits
	lsrs	r0,#1			// shift mantissa low
	lsls	r3,r1,#31		// get lower 1 bit -> R3
	orrs	r0,r3			// carry to lower part
	adds	r2,#1			// shift exponent

	// shift mantissa right -> R0
1:	lsrs	r0,#FLOAT_EXP_BITS	// shift mantissa right
	bcc	5f			// no rounding

	// rounding mantissa
	adds	r0,#1			// rounding mantissa up
	lsrs	r1,r0,#FLOAT_MANT_BITS+1 // check carry
	beq	5f			// no carry

	// mantissa shift if carry
	lsrs	r0,#1			// shift mantissa right
	adds	r2,#1			// adjust exponent

	// check exponent underflow
5:	subs	r2,#1			// exponent - 1 (to destroy hidden bit '1')
	bmi	3f			// underflow or zero, result will be zero

	// check exponent overflow
	cmp	r2,#FLOAT_EXP_MAX-1	// check max. exponent
	bhs	4f			// overflow

	// pack number
	lsls	r2,#FLOAT_EXP_SHIFT	// shift exponent-1 to position
	adds	r0,r2			// add exponent to mantissa, remove hidden implied bit '1'
	add	r0,r12			// add sign bit to the result
	bx	lr			// return

	// result is 0
3:	mov	r0,r12			// result = +0.0 or -0.0
	bx	lr			// return

	// result is overflow
4:	movs	r0,#FLOAT_EXP_MAX	// max. exponent
	lsls	r0,#FLOAT_EXP_SHIFT	// shift exponent to position
	add	r0,r12			// add sign to the result
	bx	lr			// return

fmulu16_0:
	// result is zero
	movs	r0,#0

fmulu16_x:
	// result is 'x' from R0
	bx	lr

// ----------------------------------------------------------------------------
//                        Reciprocal 1 / x
// ----------------------------------------------------------------------------
// float frec(float x);

regular_func_text frec

	// first operand is 1.0
	movs	r1,r0
	ldr	r0,=0x3f800000

// ---- continue to fdiv

// ----------------------------------------------------------------------------
//                       Division, x / y
// ----------------------------------------------------------------------------
// float fdiv(float x, float y);

regular_func fdiv
wrapper_func __aeabi_fdiv

	// disable IRQ to protect hardware divider
	push	{r4,lr}			// save registers R4 and LR
	irq_lock r4			// save interrupt into R4, disable interrupt
	sf_call	SF_TABLE_FDIV		// call bootrom a/b
	irq_unlock r4			// restore interrupt from R4
	pop	{r4,pc}			// pop register R4 and return


// ==== original bootrom commented code, for illustration only

#if 0

// This version of the division algorithm uses external divider hardware to estimate the
// reciprocal of the divisor to about 14 bits; then a multiplication step to get a first
// quotient estimate; then the remainder based on this estimate is used to calculate a
// correction to the quotient. The result is good to about 27 bits and so we only need
// to calculate the exact remainder when close to a rounding boundary.

	// push registers
	push	{r4,r5,r6,lr}

fdiv_n:
	// prepare temporary dividend 0xffffffff
	movs	r4,#1		// R4 <- 1
	rsbs	r6,r4,#0	// R6 <- 0xffffffff

	// prepare 17 top bits of divisor -> R3
	lsls	r4,#23		// R4 <- bit '1' on position 23 (0x00800000), implied hidden '1'
	lsls	r2,r1,#9	// clear sign and exponent from num2
	lsrs	r2,r2,#9	// isolate mantissa of num2 -> R2
	orrs	r2,r2,r4	// set implied hidden bit '1' of num2 mantissa (= 24 bits of num2)
	lsrs	r3,r2,#7	// 17 top bits of divisor (include hidden bit '1') -> R3

	// start division to get rough reciprocal value of the divisor 1/num2
	movs	r5,#DIV_PORT>>24 // port of divisor >> 24
	lsls	r5,#24		// port of divisor -> R5
	str	r6,[r5,#DIV_UDIVIDEND] // set temporary dividend
	str	r3,[r5,#DIV_UDIVISOR] // set 17 top bits of divisor

// Here is:
// R0=packed dividend
// R1=packed divisor
// R2=24 bits of divisor mantissa (including hidden implied bit '1')
// R4=1<<23
// R5=base address of DIV_PORT space

	// isolate exponent of dividend num1 -> R3
	lsrs	r6,r0,#23	// get exponent and sign of dividend num1 -> R6
	uxtb	r3,r6		// get dividend exponent -> R3

	// prepare dividend mantissa num1 (including hidden implied bit '1') -> R0
	lsls	r0,#9		// shift dividend num1 left to clear sign and exponent
	lsrs	r0,#9		// shift dividend num1 back, to isolate mantissa of num1
	orrs	r0,r0,r4	// set implied hidden bit '1' of num1 mantissa (= 24 bits of num1)

	// get exponent and sign of divisor num2 -> R1
	lsrs	r1,#23

	// prepare result sign in bit 31 -> R6
	eors	r6,r1		// XOR exponents with signs of num1 and num2
	lsrs	r6,#8		// clear exponent, result sign in bit 0
	lsls	r6,#31		// shift result sign to position 31 -> R6

	// load result reciprocal value of the divisor -> R5
	ldr	r5,[r5,#DIV_QUOTIENT] // load quotient

// Here is:
// R0=24 bits of dividend num1 mantissa (including hidden implied bit '1')
// R1=exponent and sign of divisor num2
// R2=24 bits of divisor num2 mantissa (including hidden implied bit '1')
// R3=dividend num1 exponent
// R4=1<<23
// R5=reciprocal estimate 1/num2 (16 bits)
// R6=result sign in bit 31

	// get and check divisor num2 exponent -> R1
	uxtb	r1,r1		// get divisor exponent -> R1
	cmp	r1,#0		// is divisor num2 zero?
	beq	retinf		// divisor num2 is zero, result will be infinity
	cmp	r1,#255		// is divisor num2 infinity?
	beq	20f		// divisor is infinite, result will be zero

	// check dividend num1 exponent
	cmp	r3,#0		// is dividend num1 zero?
	beq	retzero		// dividend num1 is zero, result will be zero
	cmp	r3,#255		// is dividend num1 infinity?
	beq	retinf		// dividend num1 is infinity, result will be infinity

	// prepare result exponent -> R3
	subs	r3,r1		// difference of exponents
	adds	r3,#125		// add bias - 2

	// get high 16 bits of dividend num1 mantissa -> R1
	lsrs	r1,r0,#8	// dividend mantissa, top 16 bits -> R1

// Here is:
// R0=24 bits of dividend num1 mantissa (including hidden implied bit '1')
// R1=16 bits of dividend num1 mantissa (including hidden implied bit '1')
// R2=24 bits of divisor num2 mantissa (including hidden implied bit '1')
// R3=result exponent
// R4=1<<23
// R5=reciprocal estimate 1/num2 (16 bits)
// R6=result sign in bit 31

	// get first estimate of quotient to 16 bits qu0 -> R1
	muls	r1,r5		// multiply reciproval estimate 1/num2 (16 bits) * dividen num1 (16 bits) = quotient 16 bits << 16
	lsrs	r1,#16		// get first estimate of quotient (16 bits) -> R1

	// get difference of first estimation, remainder re0 -> R4
	lsls	r0,r0,#15	// bottom 17 bits of dividend num1 mantissa
	movs	r4,r2		// divisor -> R4
	muls	r4,r1		// multiply first result qu0 * divisor num2 (Q38 qu0*x) = first estimate dividend
	subs	r4,r0,r4	// difference of dividend minus estimate dividend (Q38 re0=(y<<15)-qu0*x; note this remainder is signed)

	// get first refinement of quotient to 28 bits -> R1
	asrs	r4,#10		// remainder re0 >> 10
	muls	r4,r5		// multiply remainder re0 * reciprocal 1/num2 (Q44 qu1=(re0>>10)*u; this quotient correction is also signed)
	asrs	r4,#16		// Q28
	lsls	r1,#13		// first estimate quotient << 13
	adds	r1,r1,r4	// first refinement Q28 qu=(qu0<<13)+(qu1>>16);

// Here is:
// R0=dividend mantissa Q38
// R1=quotient Q28
// R2=divisor mantissa Q23
// R3=initial result exponent
// R6b31=sign of result

	lsrs	r4,r1,#28
	bne	1f

// here the quotient is less than 1<<28 (i.e., result mantissa <1.0)

	adds	r1,#5
	lsrs	r4,r1,#4	// rounding + small reduction in systematic bias
	bcc	2f		// skip if we are not near a rounding boundary
	lsrs	r1,#3		// quotient Q25
	lsls	r0,#10		// dividend mantissa Q48
	muls	r1,r1,r2	// quotient*divisor Q48
	subs	r0,r0,r1	// remainder Q48
	bmi	2f
	b	3f

// here the quotient is at least 1<<28 (i.e., result mantissa >=1.0)

1:	adds	r3,#1		// bump exponent (and shift mantissa down one more place)
	adds	r1,#9
	lsrs	r4,r1,#5	// rounding + small reduction in systematic bias
	bcc	2f		// skip if we are not near a rounding boundary

	lsrs	r1,#4		// quotient Q24
	lsls	r0,#9		// dividend mantissa Q47
	muls	r1,r1,r2	// quotient*divisor Q47
	subs	r0,r0,r1	// remainder Q47
	bmi	2f

3:	adds	r4,#1		// increment quotient as we are above the rounding boundary

// Here is:
// R3=result exponent
// R4=correctly rounded quotient Q23 in range [1,2] *note closed interval*
// R6b31=sign of result

2:	cmp	r3,#254
	bhs	10f		// this catches both underflow and overflow
	lsls	r1,r3,#23
	adds	r0,r4,r1
	adds	r0,r6
	pop	{r4,r5,r6,pc}

	// divisor num2 is infinite, check dividend num1 in R3
20:	cmp	r3,#255		// is dividend infinity too?
	bne	retzero		// dividend is not infinity, result will be zero

retinf:
	// result will be infinity
	movs	r0,#255		// result exponent = infinity
21:	lsls	r0,#23		// shift exponent to its position
	orrs	r0,r6		// add sign to result
	pop	{r4,r5,r6,pc}	// pop registers and return

10:	bge	retinf		// overflow?
	adds	r1,r3,#1
	bne	retzero		// exponent <-1? return 0

// here exponent is exactly -1

	lsrs	r1,r4,#25
	bcc	retzero		// mantissa is not 01000000?

// return minimum normal

	movs	r0,#1
	lsls	r0,#23
	orrs	r0,r6
	pop	{r4,r5,r6,pc}

retzero:
	// result will be zero
	movs	r0,r6		// sign -> result R0
	pop	{r4,r5,r6,pc}	// pop registers and return

#endif

// ----------------------------------------------------------------------------
//                 Divide by unsigned integer u16, x / n
// ----------------------------------------------------------------------------
// float fdivu16(float x, u16 n);

regular_func_text fdivu16

	// get exponent of 'x' -> R2
	lsls	r2,r0,#1		// destroy sign bit of 'x'
	lsrs	r2,#FLOAT_EXP_SHIFT+1	// isolate exponent of 'x'
	beq	fdivu16_x		// 'x' is zero, result will be 'x'
	cmp	r2,#FLOAT_EXP_MAX	// check infinity
	beq	fdivu16_x		// 'x' is infinity, result will be 'x'

	// check number 'n'
	uxth	r1,r1			// expand to 16-bit unsigned -> R1
	cmp	r1,#1			// check '1'
	beq	fdivu16_x		// 'n' is 1, result will be 'x'
	blo	fdivu16_inf		// 'n' is 0, result will be infinity

	// prepare result sign -> R12
	lsrs	r3,r0,#31		// isolate sign bit from 'x'
	lsls	r3,#31			// shift sign bit back to its position
	mov	r12,r3			// save result sign -> R12

	// isolate mantissa -> R0
	lsls	r0,#FLOAT_EXP_BITS	// remove sign and exponent
	lsrs	r0,#FLOAT_EXP_BITS	// restore mantissa position

	// restore hidden bit '1'
	movs	r3,#1			// R3 <- 1
	lsls	r3,#FLOAT_MANT_BITS	// shift to position 23, 0x00800000 -> R3
	orrs	r0,r3			// restore hidden bit '1' in 'x'

// Here is:
//  R0 = unsigned mantissa of 1st number mant1 (24 bits)
//  R1 = unsigned number u16
//  R2 = result exponent exp
//  R12 = result sign 0 or 0x80000000

	// push registers
	push	{r4,lr}

	// prepare port of divisor -> R4
	movs	r4,#DIV_PORT>>24	// port of divisor >> 24
	lsls	r4,#24			// port of divisor -> R4

	// disable interrupts
	irq_lock lr			// save interrupt into LR, disable interrupt

// divide dividend -> R3

	// start divide dividend R0/R1
	str	r1,[r4,#DIV_UDIVISOR]	// set divisor
	str	r0,[r4,#DIV_UDIVIDEND]	// set dividend

	// [8] wait 8 clock cycles
	nop8				// [8] delay 8 clock cycles

	// get result -> R0 (R1)
	ldr	r0,[r4,#DIV_QUOTIENT]	// load quotient -> R3
	ldr	r1,[r4,#DIV_REMAINDER]	// load remainder -> R1

// divide carry from remainder -> R1

	// start divide remainder
	lsls	r1,#16			// shift carry
	str	r1,[r4,#DIV_UDIVIDEND]	// set mantissa

	// [8] wait 8 clock cycles
	nop8				// [8] delay 8 clock cycles

	// get result -> R1
	ldr	r1,[r4,#DIV_QUOTIENT]	// load quotient -> R1

	// restore interrupts and return
	irq_unlock lr			// restore interrupt from LR

	// prepare sticky bits
	lsls	r1,#16

	// normalize mantissa R0:R1, shift left by 8 bits
	lsrs	r3,r0,#16		// check top 8 bits
	bne	1f			// result high is >= 16 bits
	lsls	r0,#8			// shift mantissa left
	lsrs	r3,r1,#24		// get high 8 bits -> R3
	orrs	r0,r3			// carry to higher part
	lsls	r1,#8			// shift mantissa low
	subs	r2,#8			// shift exponent

	// normalize mantissa R0:R1, shift left by 4 bits
1:	lsrs	r3,r0,#20		// check top 4 bits
	bne	1f			// result high is >= 20 bits
	lsls	r0,#4			// shift mantissa left
	lsrs	r3,r1,#28		// get high 4 bits -> R3
	orrs	r0,r3			// carry to higher part
	lsls	r1,#4			// shift mantissa low
	subs	r2,#4			// shift exponent

	// normalize mantissa R0:R1, shift left by 2 bits
1:	lsrs	r3,r0,#22		// check top 2 bits
	bne	1f			// result high is >= 22 bits
	lsls	r0,#2			// shift mantissa left
	lsrs	r3,r1,#30		// get high 2 bits -> R3
	orrs	r0,r3			// carry to higher part
	lsls	r1,#2			// shift mantissa low
	subs	r2,#2			// shift exponent

	// normalize mantissa R0:R1, shift left by 1 bit
1:	lsrs	r3,r0,#23		// check top 1 bit
	bne	1f			// result high is >= 23 bits
	lsls	r0,#1			// shift mantissa left
	lsrs	r3,r1,#31		// get high 1 bit -> R3
	orrs	r0,r3			// carry to higher part
	lsls	r1,#1			// shift mantissa low
	subs	r2,#1			// shift exponent

	// normalize mantissa R0:R1, shift left by last 1 bit
1:	lsrs	r3,r0,#23		// check top 1 bit
	bne	1f			// result high is >= 23 bits
	lsls	r0,#1			// shift mantissa left
	lsrs	r3,r1,#31		// get high 1 bit -> R3
	orrs	r0,r3			// carry to higher part
	lsls	r1,#1			// shift mantissa low
	subs	r2,#1			// shift exponent

	// round mantissa R0
1:	lsls    r1,#1                   // check next bit
	bcc	2f			// no carry
	adds	r0,#1			// increment mantissa
	lsrs	r3,r0,#FLOAT_MANT_BITS+1 // check mantissa range
	beq	2f			// mantissa is normalized

	// shift mantissa right
	lsrs	r0,#1			// shift mantissa right
	adds	r2,#1			// adjust exponent

	// check exponent underflow
2:	subs	r2,#1			// exponent - 1 (to destroy hidden bit '1')
	bmi	3f			// underflow or zero, result will be zero

	// check exponent overflow
	cmp	r2,#FLOAT_EXP_MAX-1	// check max. exponent
	bhs	4f			// overflow

	// pack number
	lsls	r2,#FLOAT_EXP_SHIFT	// shift exponent-1 to position
	adds	r0,r2			// add exponent to mantissa, remove hidden implied bit '1'
	add	r0,r12			// add sign bit to mantissa

	// pop registes and return
	pop	{r4,pc}

	// result is 0
3:	mov	r0,r12			// result is 0 + sign bit
	pop	{r4,pc}

	// result is overflow
4:	movs	r0,#FLOAT_EXP_MAX	// max. exponent
	lsls	r0,#FLOAT_EXP_SHIFT	// shift exponent to position
	add	r0,r12			// add sign bit to mantissa
	pop	{r4,pc}

fdivu16_x:
	// result is 'x'
	bx	lr

fdivu16_inf:
	// result is infinity
	movs	r0,#FLOAT_EXP_MAX	// max. exponent
	lsls	r0,#FLOAT_EXP_SHIFT	// shift exponent to position
	bx	lr			// return


// ==== comparison


// ----------------------------------------------------------------------------
//               Reverse compare, y ? x (internal aeabi function)
// ----------------------------------------------------------------------------
// Input: R0 = 1st operand 'x'
//	  R1 = 2nd operand 'y'
// Output set flags Z (x==y) and C (x<=y) as with "cmp y,x"
// Saves all registers.

wrapper_func_text __aeabi_cfrcmple

	// save registers R0, R1, R2 and LR
	push	{r0-r2,lr}

	// exchange operands
	eors	r0,r1
	eors	r1,r0
	eors	r0,r1
	b	__aeabi_frcmp_2

// ----------------------------------------------------------------------------
//                   Compare, x ? y (internal aeabi function)
// ----------------------------------------------------------------------------
// Input: R0 = 1st operand 'x'
//	  R1 = 2nd operand 'y'
// Output set flags Z (x==y) and C (x>=y) as with "cmp x,y"
// Saves all registers.

wrapper_func __aeabi_cfcmple
wrapper_func __aeabi_cfcmpeq

	// save registers R0, R1, R2 and LR
	push	{r0-r2,lr}

__aeabi_frcmp_2:

	// check if 1st operand is zero
	lsls	r2,r0,#1		// shift 1 bit left, get 1st operand 'x' without sign -> R2
	lsrs	r2,#24			// shift right, get exponent of 1st number - number is 0 if exponent is 0
	beq	1f			// 1st operand is zero

	// check if 1st operand is infinity
	cmp	r2,#0xff		// is 1st operand infinity?
	bne	2f			// 1st operand is in normal range

	// 1st operand is zero or infinity, clear mantissa
1:	lsrs	r0,#23			// clear mantissa
	lsls	r0,#23			// return exponent back

	// check if 2nd operand is zero
2:	lsls	r2,r1,#1		// shift 1 bit left, get 2nd operand 'y' without sign -> R2
	lsrs	r2,#24			// shift right, get exponent of 2nd number - number is 0 if exponent is 0
	beq	1f			// 2nd operand is zero

	// check if 2nd operand is infinity
	cmp	r2,#0xff		// is 2nd operand infinity?
	bne	2f			// 2nd operand is in normal range

	// 2nd operand is zero or infinity, clear mantissa
1:	lsrs	r1,#23			// clear mantissa
	lsls	r1,#23			// return exponent back

	// compare signs
2:	eors	r1,r0			// compare signs of 'y' and 'x'
	bmi	2f			// opposite signs, can proceed with sign of 'x'

	// identical signs - check sign of 'y'
	eors	r1,r0			// restore 'y'
	bpl	1f			// 'y' is positive or zero

	// both numbers are negative, reverse compare 'y' with 'x'
	cmp	r1,r0			// compare 'y' with 'x'
	pop	{r0-r2, pc}

	// both numbers are positive, compare 'x' with 'y'
1:	cmp	r0,r1			// compare 'x' with 'y'
	pop	{r0-r2, pc}

	// signs are opposite, compare zero (ignoring sign flag)
2:	orrs	r1,r0			// check zero numbers
	adds	r1,r1			// set C flag (sign bit was set)
	beq	3f			// numbers was both zero (sign flag of zero is ignored)

	// signs are opposite and numbers are not zero
	mvns	r0,r0			// not R0, carry inverse of 'x' sign
	adds	r0,r0			// carry set if 'x' was positive (x > y), zero flag not set

	// restore registers R0, R1, R2 and return
3:	pop	{r0-r2, pc}

// ----------------------------------------------------------------------------
//                        Compare, x ? y
// ----------------------------------------------------------------------------
// Returns: 0 if x==y, -1 if x<y, +1 if x>y
// s8 fcmp(float x, float y);

regular_func_text fcmp

	// check if 1st operand is zero
	lsls	r2,r0,#1		// shift 1 bit left, get 1st operand 'x' without sign -> R2
	lsrs	r2,#24			// shift right, get exponent of 1st number - number is 0 if exponent is 0
	beq	1f			// 1st operand is zero

	// check if 1st operand is infinity
	cmp	r2,#0xff		// is 1st operand infinity?
	bne	2f			// 1st operand is in normal range

	// 1st operand is zero or infinity, clear mantissa
1:	lsrs	r0,#23			// clear mantissa
	lsls	r0,#23			// return exponent back

	// check if 2nd operand is zero
2:	lsls	r2,r1,#1		// shift 1 bit left, get 2nd operand 'y' without sign -> R2
	lsrs	r2,#24			// shift right, get exponent of 2nd number - number is 0 if exponent is 0
	beq	1f			// 2nd operand is zero

	// check if 2nd operand is infinity
	cmp	r2,#0xff		// is 2nd operand infinity?
	bne	2f			// 2nd operand is in normal range

	// 2nd operand is zero or infinity, clear mantissa
1:	lsrs	r1,#23			// clear mantissa
	lsls	r1,#23			// return exponent back

	// compare signs
2:	movs	r2,#1			// initialize result (+1 if x>y)
	eors	r1,r0			// compare signs or 'y' and 'x'
	bmi	4f			// opposite signs, can proceed with sign of 'x'

	// identical signs - check sign of 'y'
	eors	r1,r0			// restore 'y'
	bpl	1f			// 'y' is positive or zero
	rsbs	r2,#0			// both numbers are negative, invert result (R2 = 0 - R2 = -1)

	// compare 'x' with 'y'
1:	cmp	r0,r1			// compare 'x' with 'y'
	bgt	2f			// x > y
	blt	3f			// x < y

	// numbers are equal
5:	movs	r2,#0			// numbers are equal, result 0

	// invert result
3:	rsbs	r2,#0			// invert result (R2 = 0 - R2)

	// move result to R0 and return
2:	subs	r0,r2,#0		// move result to R0
	bx	lr			// return

	// signs are opposite, compare zero (ignoring sign flag)
4:	orrs	r1,r0			// check zero numbers
	adds	r1,r1			// set C flag (sign bit was set)
	beq	5b			// numbers was both zero (sign flag of zero ignored)

	// signs are opposite and numbers are not zero
	cmp	r0,#0			// check if number 'x' is negative
	bge	2b			// number 'x' is positive, result will be +1 (x>y)
	b	3b			// invert result to -1 (x<y)

// ----------------------------------------------------------------------------
//                        Compare if x==y
// ----------------------------------------------------------------------------
// Bool fcmpeq(float x, float y);

regular_func_text fcmpeq
wrapper_func __aeabi_fcmpeq

	push	{lr}
	bl	__aeabi_cfcmpeq		// compare numbers
	beq	1f			// numbers are equal x==y
	movs	r0,#0			// result False
	pop	{pc}

1:	movs	r0,#1			// result True
	pop	{pc}

// ----------------------------------------------------------------------------
//                        Compare if x<y
// ----------------------------------------------------------------------------
// Bool fcmplt(float x, float y);

regular_func_text fcmplt
wrapper_func __aeabi_fcmplt

	push	{lr}
	bl	__aeabi_cfcmple		// compare numbers
	sbcs	r0,r0			// set to -1 if x<y
	negs	r0,r0			// negate, result 0 or +1
	pop	{pc}

// ----------------------------------------------------------------------------
//                        Compare if x<=y
// ----------------------------------------------------------------------------
// Bool fcmple(float x, float y);

regular_func_text fcmple
wrapper_func __aeabi_fcmple

	push	{lr}
	bl	__aeabi_cfcmple		// compare numbers
	bls	1f			// numbers are x<=y
	movs	r0,#0			// result False
	pop	{pc}

1:	movs	r0,#1			// result True
	pop	{pc}

// ----------------------------------------------------------------------------
//                        Compare if x>=y
// ----------------------------------------------------------------------------
// Bool fcmpge(float x, float y);

regular_func_text fcmpge
wrapper_func __aeabi_fcmpge

	push	{lr}
	bl	__aeabi_cfrcmple	// reverse compare numbers
	bls	1f			// numbers are x<=y
	movs	r0,#0			// result False
	pop	{pc}

1:	movs	r0,#1			// result True
	pop	{pc}

// ----------------------------------------------------------------------------
//                        Compare if x>y
// ----------------------------------------------------------------------------
// Bool fcmpgt(float x, float y);

regular_func_text fcmpgt
wrapper_func __aeabi_fcmpgt

	push	{lr}
	bl	__aeabi_cfrcmple	// reverse compare numbers
	sbcs	r0,r0			// set to -1 if x>y
	negs	r0,r0			// negate, result 0 or +1
	pop	{pc}

// ----------------------------------------------------------------------------
//          Check if comparison is unordered (either input is NaN)
// ----------------------------------------------------------------------------
// Bool fcmpun(float x, float y);

regular_func_text fcmpun
wrapper_func __aeabi_fcmpun

	// check if exponent of 'x' is NaN (= 0xff)
	movs	r3,#1			// R3 <- 1
	lsls	r3,#24			// R3 <- lowest bit of exponent
	lsls	r2,r0,#1		// load number 'x' without sign flag -> R2
	adds	r2,r3			// exponent + 1
	bhi	1f			// number 'x' is NaN

	// check if exponent of 'y' is NaN (= 0xff)
	lsls	r2,r1,#1		// load number 'y' without sign flag -> R2
	adds	r2,r3			// exponent + 1
	bhi	1f			// number 'y' is NaN

	// return False
	movs	r0,#0
	bx	lr

	// return True
1:	movs	r0,#1
	bx	lr


// ==== convert integer to float


// ----------------------------------------------------------------------------
//                      Convert unsigned int to float
// ----------------------------------------------------------------------------
// float ui2f(u32 num);
// float uint2float(u32 num);

regular_func_text ui2f
regular_func uint2float
wrapper_func __aeabi_ui2f

	// check if number is zero
	subs	r1,r1			// prepare positive result sign -> R1
	cmp	r0,#0			// is number zero?
	bne	i2f_2			// number is not zero
ui2f_2:	bx	lr			// result is 0

// ----------------------------------------------------------------------------
//                      Convert signed int to float
// ----------------------------------------------------------------------------
// float i2f(s32 num);
// float int2float(s32 num);

regular_func i2f
regular_func int2float
wrapper_func __aeabi_i2f

	// prepare result sign -> R1
	lsrs	r1,r0,#31		// get sign bit -> R1
	lsls	r1,#31			// shift sign bit back to position 31

	// absolute value of the number
	bpl	1f			// number is positive
	negs	r0,r0			// absolute value of the number

	// check if number is zero
1:	cmp	r0,#0			// zero number?
	beq	ui2f_2			// result is 0

	// count leading zeroes -> R0
i2f_2:	push	{r0, r1, lr}		// push registers
	ldr	r3,=clz			// ROM function clz
	ldr	r3,[r3]			// get function address
	blx	r3			// call clz function
	pop	{r1, r2, r3}		// pop registers
	mov	lr,r3			// return address -> LR
// here is: R0 count of leading zeros, R1 integer number, R2 sign in bit 31, LR return address

	// normalize number (shift left) -> R1
	lsls	r1,r0			// normalize number - shift bits to left -> R1

	// prepare result exponent -> R0
	//   exponent 127 represents '1' + 31 bits of integer without high '1' - count of zeros (=number of shift left)
	subs	r0,#158			// count of zeros - 158
	negs	r0,r0			// R0 <- 158 - count of zeros

	// rounding input number
	//  float mantissa is 23 bits + 1 bit '1' = 24 bits, 8 bits of integer stays unused (=hidden decimal part)
	adds	r1,#0x80		// rounding least bit of the mantissa
	bcs	5f			// overflow (carry)

	// check bottom 8 bits (unused float bits) to carry rounding
	lsls	r3,r1,#24		// check bottom 8 bits of R1
	beq	6f			// lowest bits of mantissa are = 0, round to even number

	// remove leading hidden bit '1'
	lsls	r1,#1			// remove leading 1 (hidden 1)

	// composing float number
3:	lsrs	r1,#9			// align mantissa to its position (shift to bits 0..22)
	lsls	r0,#23			// align exponent (shift to bits 23..30)
	orrs	r0,r2			// assembler exponent and mantissa
4:	orrs	r0,r1			// apply sign (add to bit 31)
	bx	lr			// return

	// overflow number after rounding - increase exponent and skip shift left
5:	adds	r0,#1			// correct exponent
	b	3b			// skip shift left

	// lowest 8 bits are = 0, round mantissa to even number
6:	lsrs	r1,#9			// ensure even result (destroy lowest bit of mantissa)
	lsls	r1,#10			// shift mantissa back and remove leading hidden bit '1'
	b	3b			// skip shift left

// ----------------------------------------------------------------------------
//                 Convert signed fixed point to float
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// float fix2float(s32 num, int e);

regular_func_text fix2float

	sf_jump	SF_TABLE_FIX2FLOAT		// jump to bootrom fix2float

// ----------------------------------------------------------------------------
//                 Convert unsigned fixed point to float
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// float ufix2float(u32 num, int e);

regular_func_text ufix2float

	sf_jump	SF_TABLE_UFIX2FLOAT		// jump to bootrom ufix2float

// ----------------------------------------------------------------------------
//                    Convert 64-bit unsigned int to float
// ----------------------------------------------------------------------------
// float ul2f(s64 num);
// float uint642float(u64 num);

section_text uint642float

	// convert small 32-bit unsigned number
1:	ldr	r2,=__aeabi_ui2f
	bx	r2

regular_func uint642float
regular_func ul2f
wrapper_func __aeabi_ul2f

	// check if number is 32-bits
	cmp	r1,#0			// 32-bit unsigned number?
	beq	1b			// convert small 32-bit unsigned number

	// set number of fraction bits = 0
	movs	r2,#0			// 2nd parameter - number of bits = 0

// ---- continue to ufix642float

// ----------------------------------------------------------------------------
//                 Convert 64-bit unsigned fixed point to float
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// float ufix642float(u64 num, int e);

regular_func ufix642float

	// push registers 
	push	{r4, r5, lr}

	// check range (if it fits into signed number)
	cmp	r1,#0			// is signed positive range?
	bpl	fix642float_3		// number fits to signed positive range

	lsls	r5,r1,#31		// contribution to sticky bits
	orrs	r5,r0
	lsrs	r0,r1,#1
	subs	r2,#1
	b	4f

// ---- continue to int642float

// ----------------------------------------------------------------------------
//                     Convert 64-bit signed int to float
// ----------------------------------------------------------------------------
// float l2f(s64 num);
// float int642float(s64 num);

	// convert small 32-bit signed number
1:	ldr	r2,=__aeabi_i2f
	bx	r2

regular_func int642float
regular_func l2f
wrapper_func __aeabi_l2f

	// check if number is 32-bits
	asrs	r2,r0,#31		// prepare sign word -> R2
	cmp	r1,r2			// 32-bit signed number?
	beq	1b			// convert small 32-bit signed number

	// set number of fraction bits = 0
	movs	r2,#0			// 2nd parameter - number of bits = 0

// ---- continue to fix642float (do not use *_text !)

// ----------------------------------------------------------------------------
//                 Convert 64-bit signed fixed point to float
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// float fix642float(s64 num, int e);

regular_func fix642float

	// push registers 
	push	{r4, r5, lr}

fix642float_3:

	// check if number is 0 (result will be +0.0)
3:	movs	r5,r0		// number low -> R5
	orrs	r5,r1		// or number high -> R5
	beq	6f		// number is zero, return +0.0

	// prepare sign bit 0 or -1 -> R5
	asrs	r5,r1,#31

	// checking the upper 7 bits if they are insignificant
2:	asrs	r4,r1,#24	// try shifting 7 bits at a time
	cmp	r4,r5		// significant bits has been found?
	bne	1f		// next shift will overflow

	// shift number by 7 bits left (to fast normalize)
	lsls	r1,#7		// shift number high by 7 bits left
	lsrs	r4,r0,#25	// high 7 bits of number low -> R4
	orrs	r1,r4		// carry 7 bits to number high -> R1
	lsls	r0,#7		// shift number low by 7 bits left
	adds	r2,#7		// shift exponent by 7
	b	2b		// next normalisation iterations

	// pack float number
1:	movs	r5,r0		// sticky bits (used for rounding) -> R5
	movs	r0,r1		// partially normalised number -> R0
4:	negs	r2,r2		// negate exponent in R2
	adds	r2,#32 + 29	// absolute exponent -> R2
// input: R0 = signed mantissa (24 significant bits)
//        R2 = signed exponent (bias removed) (zero = -380, infinity = +640)
//        R5 = sticky bits (used for rounding)
// output: R0 = float number
// trashes: R4
	bl	packx		// pack float number

	// pop registers and return
6:	pop	{r4,r5,pc}


// ==== convert float to integer


// ----------------------------------------------------------------------------
//     Convert float to signed int, rounding to zero (C-style int conversion)
// ----------------------------------------------------------------------------
// s32 f2iz(float num);
// s32 float2int_z(float num);

regular_func_text f2iz
regular_func float2int_z
wrapper_func __aeabi_f2iz

	// get exponent of float number -> R2
	lsls	r1,r0,#1		// shift 1 bit left to get float number without sign -> R1
	lsrs	r2,r1,#24		// shift 24 bits right to get exponent -> R2

	// prepare overflow number 0x80000000
	movs	r3,#0x80		// overflow number base
	lsls	r3,#24			// shift and get number 0x80000000

	// check minimal exponent - result will be 0
	cmp	r2,#126			// check minimal exponent of 0.5
	ble	1f			// number is too small - result will be 0

	// check maximal exponent
	subs	r2,#158			// exponent - exponent bias 127 - max. mantissa bits 31 = exponent - 158
	bge	2f			// number is too big, limit overflow result

	// prepare sign
	asrs	r1,r0,#31		// prepare sign: positive 0, negative 0xffffffff

	// prepare mantissa
	lsls	r0,#9			// delete sign and exponent
	lsrs	r0,#1			// mantissa is in bits 8..30
	orrs	r0,r3			// restore highest hidden bit '1'

	// relative exponent
	negs	r2,r2			// relative exponent -> R2

	// shift mantissa to integer position
	lsrs	r0,r2			// shift mantissa right by exponent bits

	// compose mantissa with sign
	lsls	r1,#1			// sign (0 or 0xffffffff) shift left -> 0 or 0xfffffffe
	adds	r1,#1			// sign + 1 -> positive 1, negative 0xffffffff
	muls	r0,r1			// multiply mantissa with sign 1 or -1
	bx	lr			// return

	// result is number 0
1:	movs	r0,#0			// R0 <- 0
	bx	lr			// return

	// number is too big - limit number on overflow
2:	lsrs	r0,#31			// get sign flag into bit 0
	adds	r0,r3			// add overflow number 0x80000000
	subs	r0,#1			// -1 -> limited result is 0x7FFFFFFF for positive number, 0x80000000 for negative
	bx	lr			// return

// ----------------------------------------------------------------------------
//                   Convert float to signed int, rounding down
// ----------------------------------------------------------------------------
// s32 float2int(float num);
// s32 f2i(float num);

regular_func_text float2int
regular_func f2i

	sf_jump	SF_TABLE_FLOAT2INT		// jump to bootrom float2int

// ----------------------------------------------------------------------------
//                 Convert float to unsigned int, rounding down
// ----------------------------------------------------------------------------
// u32 f2ui(float num);
// u32 float2uint(float num);

regular_func_text float2uint
regular_func f2ui
wrapper_func __aeabi_f2uiz

	sf_jump	SF_TABLE_FLOAT2UINT		// jump to bootrom float2uint

// ----------------------------------------------------------------------------
//               Convert float to signed fixed point, rounding down
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// s32 float2fix(float num, int e);

regular_func_text float2fix

	sf_jump	SF_TABLE_FLOAT2FIX		// jump to bootrom float2fix

// ----------------------------------------------------------------------------
//             Convert float to unsigned fixed point, rounding down
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// u32 float2ufix(float num, int e);

regular_func_text float2ufix

	sf_jump	SF_TABLE_FLOAT2UFIX		// jump to bootrom float2ufix

// ----------------------------------------------------------------------------
// Convert float to 64-bit signed int, rounding to zero (C-style int conversion)
// ----------------------------------------------------------------------------
// s64 f2lz(float num);
// s64 float2int64_z(float num);

regular_func_text float2int64_z
regular_func f2lz
wrapper_func __aeabi_f2lz

	// if number is not negative, convert with rounding down
	cmn	r0,r0		// R0+R0 ? ... is number negative?
	bcc	float2int64	// number is not negative - convert with rounding down

	// convert as unsigned, using absolute value
	push	{lr}
	lsls	r0,#1		// discard sign bit
	lsrs	r0,#1		// shift back
	bl	float2uint64	// convert to u64

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
//              Convert float to 64-bit signed int, rounding down
// ----------------------------------------------------------------------------
// s64 f2l(float num);
// s64 float2int64(float num);

regular_func f2l
regular_func float2int64

	movs r1,#0		// 2nd parameter - number of bits = 0

// ---- continue to float2fix64 (do not use *_text !)

// ----------------------------------------------------------------------------
//         Convert float to 64-bit signed fixed point, rounding down
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// s64 float2fix64(float num, int e);

regular_func float2fix64

	// convert float to signed fixed point
	push	{lr}		// push LR
// input: R0 = float number
//        R1 = result exponent (number of bits after decimal point of output integer)
// output: R3:R1:R0 = signed fixed point (clamped, R3 is 0 or -1)
// trashes: R12
	bl	f2fix		// convert float to signed fixed point

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
//                    Convert float to 64-bit unsigned int
// ----------------------------------------------------------------------------
// u64 f2ul(float num);
// u64 float2uint64(float num);

regular_func_text float2uint64
regular_func f2ul
wrapper_func __aeabi_f2ulz

	movs	r1,#0			// 2nd parameter - number of bits = 0

// ---- continue to float2ufix64 (do not use *_text !)

// ----------------------------------------------------------------------------
//                  Convert float to 64-bit unsigned fixed point
// ----------------------------------------------------------------------------
//  e = number of bits of fractional part (binary exponent)
// u64 float2ufix64(float num, int e);

regular_func float2ufix64

	// check if number is negative - return 0 to be clamped to unsigned int
	asrs	r3,r0,#23	// get sign and exponent -> R3
	bmi	ret_dzero	// number is negative, return -0.0

// ---- convert float to signed fixed point, rounding down

// input: R0 = float number
//        R1 = result exponent (number of bits after decimal point of output integer)
// output: R3:R1:R0 = signed fixed point (clamped, R3 is 0 or -1)
// trashes: R12

f2fix:
	// save register R4 and LR
	push	{r4,lr}
	mov	r12,r1		// required exponent -> R12

	// get sign -> R3
	asrs	r3,r0,#31	// get sign bit 0 or -1 -> R3
	lsls	r0,#1		// delete sign bit from float

	// get exponent -> R2
	lsrs	r2,r0,#24	// isolate exponent -> R2
	beq	1f		// zero number, result is zero
	cmp	r2,#0xff	// infinity?
	beq	2f		// infinity, result is max number

	// get absolute exponent
	subs	r1,r2,#1	// exponent - 1 -> R1
	subs	r2,#0x7f	// subtract exponent bias 127 - 1

	// isolate mantissa and restore hidden implied bit '1' -> R0
	lsls	r1,#24		// shift 'exponent - 1' back to position 24
	subs	r0,r1		// insert back hidden implied highest bit '1'

	// absolute value of mantissa
	eors	r0,r3		// NOT mantissa with negative sign -1
	subs	r0,r3		// negative mantissa correction to get two's complement

	// shift mantissa
	asrs	r1,r0,#4	// convert mantissa to int
	lsls	r0,#28		// mantissa low
	b	d2fix_a		// shift mantissa R3:R1:R0 by R2+R12 bits

	// result is plus zero +0.0
1:	movs	r0,#0		// 0 -> R0
	movs	r1,r0		// 0 -> R1
	movs	r3,r0		// 0 -> R3
	pop	{r4, pc}	// pop R4 and return

	// result is overflow, return max integer (0 on negative number, -1 on positive)
2:	mvns	r0,r3		// inverse sign -> R0
	mvns	r1,r3		// inverse sign -> R1
	pop	{r4, pc}	// pop R4 and return

ret_dzero:
	// result is minus zero -0.0 (here is R3 = sign 0 or -1)
	movs	r0,#0		// 0 -> R0
	movs	r1,#0		// 0 -> R1
	bx	lr		// return

// ---- continue conversion float/double to int64 ... shift mantissa R3:R1:R0 by R2+R12 bits

// input: R1:R0 = two's complement mantissa
//        R2 = unbaised exponent
//        R3 = mantissa sign extension bits (0 or -1)
//        R12 = required output exponent
// output: R3:R1:R0 = signed fixed point (clamped, R3 is 0 or -1)
// R4 and LR are in the stack

regular_func_text d2fix_a

	// prepare shift up by R2 bits
	add	r2,r12		// exponent plus offset for required binary point position
	subs	r2,#52		// required shift
	bmi	1f		// shift down?

	// check shift up overflow
	cmp	r2,#12		// will clamp?
	bge	2f		// clamp shift up

	// shift mantissa by R2 bits
	movs	r4,r0		// save mantissa low -> R4
	lsls	r1,r2		// shift mantissa high by R2 bits left -> R1
	lsls	r0,r2		// shift mantissa low by R2 bits left -> R0
	negs	r2,r2		// negate number of shifts
	adds	r2,#32		// complementary shift 32-R2
	lsrs	r4,r2		// shift mantissa low by 32-R2 bits right
	orrs	r1,r4		// add carry from mantissa low to new mantissa high -> R1
	pop	{r4, pc}	// pop R4 and return

	// clamp shift up, return max integer (0 on negative number, -1 on positive)
2:	mvns	r0,r3		// not sign -> R0
	mvns	r1,r3		// not sign -> R1
	pop	{r4, pc}	// pop R4 and return

	// prepare shift down by R2 bits
1:	adds	r2,#32		// required shift
	bmi	1f		// long shift down

	// shift mantissa down by R2 bits
	mov	r4,r1		// save mantissa high -> R4
	lsls	r4,r2		// shift mantissa high by R2 bits left -> R4
	negs	r2,r2		// negate number of shifts
	adds	r2,#32		// complementary shift
	asrs	r1,r2		// shift mantissa high by R2 bits right -> R1
	lsrs	r0,r2		// shift mantissa low by R2 bits right -> R0
	orrs	r0,r4		// add carry from mantissa high to new mantissa low -> R0
	pop	{r4, pc}	// pop R4 and return

	// long shift down
1:	movs	r0,r1		// R0 <- mantissa high
	asrs	r1,#31		// shift mantissa high by 31 bits to get only sign 0 or -1
	adds	r2,#32		// required number of shifts
	bmi	1f		// very long shift
	negs	r2,r2		// negate number of shifts
	adds	r2,#32		// complementary shift 32-R2
	asrs	r0,r2		// shift mantissa low by R2 bits right
	pop	{r4, pc}	// pop R4 and return

	// very long shift down
1:	movs	r0,r3		// result will be 0 or -1 (taken from sign R2)
	movs	r1,r3		// result high
	pop	{r4, pc}	// pop R4 and return

// ----------------------------------------------------------------------------
//                       Unpack float number
// ----------------------------------------------------------------------------
// input: R0 = float number
// output: R0 = signed mantissa (24 significant bits)
//         R2 = signed exponent (bias removed) (zero = -380, infinity = +640)
// trashes: R4

section_text unpackx
unpackx:
	// extract exponent and sign -> R2
	lsrs	r2,r0,#23

	// extract mantissas -> R0 (including sign)
	lsls	r0,#9
	lsrs	r0,#9

	// restore implied leading 1 in mantissa (sign is overwritten)
	movs	r4,#1		// R4 <- 1
	lsls	r4,#23		// R4 <- bit 23, hidden leading '1' bit
	orrs	r0,r4		// add hidden leading bit to mantissa

	// negate mantissa
	cmp	r2,#255		// check sign bit
	uxtb	r2,r2		// clear sign bit (load only 8 bits of exponent)
	bls	1f		// no sign, number is positive or 0         @ branch on positive
	rsbs	r0,#0		// negate mantissa

	// check zero/inf
1:	subs	r2,#1		// exponent - 1 (0 becomes 0xffffffff)
	cmp	r2,#254		// zero or inf?
	bhs	2f		// number is zero or infinity

	// convert exponent to signed
	subs	r2,#126		// remove exponent bias (= 127 - 1)
	bx	lr		// return

	// zero or infinity - limit mantissa to +1 or -1
2:	cmp	r0,#0		// is mantissa negative?
	mov	r0,r4		// set mantissa to +1 (= 0x00800000)
	bpl	3f		// mantissa is positive
	rsbs	r0,#0		// set mantissa to -1 (= 0xff800000)

	// exponent correction
3:	subs	r2,#126		// exponent - 126: zero -> -127, infinity -> 128
	lsls	r2,#2		// exponent * 4: zero -> -508, infinity -> 512
	adds	r2,#128		// exponent + 128: zero -> -380, infinity -> 640
	bx	lr		// return

// ----------------------------------------------------------------------------
//                      Normalize and pack signed mantissa
// ----------------------------------------------------------------------------
// input: R0 = signed mantissa (24 significant bits)
//        R2 = signed exponent (bias removed) (zero = -380, infinity = +640)
//        R5 = sticky bits (used for rounding)
// output: R0 = float number
// trashes: R4

section_text packx
packx:
	// extract sign bit from mantissa -> R4 bit 31
	lsrs	r4,r0,#31	// shift mantissa 31 bits right
	lsls	r4,r4,#31	// shift sign bit back to position 31

	// absolulte value of mantissa (and add carry from sticky bits in R5)
	bpl	2f		// mantissa is positive
	cmp	r5,#0		// do rounding?
	beq	11f		// do not rounding
	adds	r0,#1		// round mantissa up
11:	rsbs	r0,#0 		// negate mantissa
	bmi	3f		// mantissa was 0x80000000, skip normalization

	// normalize mantissa
2:	subs	r2,#1		// shift exponent
	adds	r0,r0		// shift mantissa left
	beq	1f		// mantissa is zero, stop normalization
	bpl	2b		// repeat normalization loop until initial 1 in bit 31 is reached

	// add exponent bias
3:	adds	r2,#129		// add bias + 2
	bne	12f		// not zero exponent
	adds	r0,#0x80	// zero exponent - add rounding 256 to mantissa
	bcs	4f		// carry, skip rounding

	// rounding mantissa
12:	adds	r0,#0x80	// add rounding correction 128 to mantissa
	bcs	4f		// carry, skip rounding from sticky bits
	cmp	r5,#0		// sticky bits are zero?
	beq	7f		// sticky bits are zero

	// shift mantissa left to remove leading bit 1
8:	lsls	r0,#1		// remove leading bit 1
9:	subs	r2,#1		// compensate exponent

	// check exponent overflow
4:	cmp	r2,#254		// exponent overflow?
	bge	5f		// exponent overflow

	// correct exponent offset
	adds	r2,#1		// correct exponent offset
	ble	10f		// zero or underflow

	// assembler exponent and mantissa
	lsrs	r0,#9		// align mantissa
	lsls	r2,#23		// align exponent
	orrs	r0,r2		// assemble exponent and mantissa
6:	orrs	r0,r4		// apply sign
1:	bx	lr		// return

	// overflow, return +-infinity
5:	movs	r0,#0xff	// result will be infinity
	lsls	r0,#23		// shift exponent to position
	b	6b		// appli sign

	// underflow, return 0
10:	movs	r0,#0		// result will be 0
	bx	lr		// return

	// rounding using sticky bits
7:	lsls	r5,r0,#24	// check bottom 8 bits of r0
	bne	8b		// rounding in normal way
	lsrs	r0,#9		// ensure even result of mantissa if sticky bits = 0
	lsls	r0,#10		// shift mantissa back
	b	9b		// compentase exponent

// ----------------------------------------------------------------------------
//                              Float Cordic
// ----------------------------------------------------------------------------
// All the scientific functions are implemented using the CORDIC algorithm. For notation,
// details not explained in the comments below, and a good overall survey see
// "50 Years of CORDIC: Algorithms, Architectures, and Applications" by Meher et al.,
// IEEE Transactions on Circuits and Systems Part I, Volume 56 Issue 9.

// Register use:
// r0: x
// r1: y
// r2: z/omega
// r3: coefficient pointer
// r4,r12: m
// r5: i (shift)

section_text cordic

	// initialisation
cordic_start:
	movs	r5,#0		// initial shift=0
	mov	r12,r4
	b	5f

	// one step of algorithm in vector mode
cordic_vstep:
	cmp	r1,#0		// check sign of y
	bgt	4f
	b	1f

	// one step of algorithm in rotation mode
cordic_rstep:
	cmp	r2,#0		// check sign of angle
	bge	1f

4:	subs	r1,r6		// negative rotation: y=y-(x>>i)
	rsbs	r7,#0
	adds	r2,r4		// accumulate angle
	b	2f

1:	adds	r1,r6		// positive rotation: y=y+(x>>i)
	subs	r2,r4		// accumulate angle

2:	mov	r4,r12
	muls	r7,r4		// apply sign from m
	subs	r0,r7		// finish rotation: x=x{+/-}(y>>i)

5:	ldmia	r3!,{r4}	// fetch next angle from table and bump pointer
	lsrs	r4,#1		// repeated angle?
	bcs	3f
	adds	r5,#1		// adjust shift if not

3:	mov	r6,r0
	asrs	r6,r5		// x>>i
	mov	r7,r1
	asrs	r7,r5		// y>>i
	lsrs	r4,#1		// shift end flag into carry
	bx	lr

// CORDIC vector mode
cordic_vec:
	push	{r6,r7,lr}
	bl	cordic_start	// initialise

1:	bl	cordic_vstep
	bcc	1b		// step until table finished

4:	cmp	r1,#0		// continue as in cordic_vstep but without using table; x is not affected as y is small
	bgt	2f		// check sign of y
	adds	r1,r6		// positive rotation: y=y+(x>>i)
	subs	r2,r4		// accumulate angle
	b	3f

2:	subs	r1,r6		// negative rotation: y=y-(x>>i)
	adds	r2,r4		// accumulate angle

3:	asrs	r6,#1
	asrs	r4,#1		// next "table entry"
	bne	4b
	pop	{r6,r7,pc}

// ----------------------------------------------------------------------------
//                            Square root
// ----------------------------------------------------------------------------
// float sqrtf(float x);

wrapper_func_text sqrtf
regular_func sqrtf

	sf_jump	SF_TABLE_FSQRT		// jump to bootrom sqrtf

// ----------------------------------------------------------------------------
//                              Sine
// ----------------------------------------------------------------------------
// float sinf(float x);

wrapper_func_text sinf

	// check angle range - rom version only works for -128 < angle < 128
	lsls	r1,r0,#1		// delete sign bit
	lsrs	r1,#24			// delete mantissa, get only exponent -> R1
	cmp	r1,#127 + 7		// check max. exponent = 2^7 = 128
	blt	2f			// exponent is ok

	// angle is too big, modulo angle range
	ldr	r1,=0x40c90fdb		// modulo = angle 2*pi (6.2831853f)
	push	{lr}			// save link register
	bl	remainderf		// get remainder of division angle/(2*pi) -> R0
	pop	{r1}			// return link register
	mov	lr,r1			// restore link register

	// calculate sinf
2:	sf_jump	SF_TABLE_FSIN		// jump to bootrom sinf

// ----------------------------------------------------------------------------
//                              Cosine
// ----------------------------------------------------------------------------
// float cosf(float x);

wrapper_func_text cosf

	// check angle range - rom version only works for -128 < angle < 128
	lsls	r1,r0,#1		// delete sign bit
	lsrs	r1,#24			// delete mantissa, get only exponent -> R1
	cmp	r1,#127 + 7		// check max. exponent = 2^7 = 128
	blt	2f			// exponent is ok

	// angle is too big, modulo angle range
	ldr	r1,=0x40c90fdb		// modulo = angle 2*pi (6.2831853f)
	push	{lr}			// save link register
	bl	remainderf		// get remainder of division angle/(2*pi) -> R0
	pop	{r1}			// return link register
	mov	lr,r1			// restore link register

	// calculate cosf
2:	sf_jump	SF_TABLE_FCOS		// jump to bootrom cosf

// ----------------------------------------------------------------------------
//                              Sine-cosine
// ----------------------------------------------------------------------------
// void sincosf(float x, float* sin, float* cos);

wrapper_func_text sincosf

	// push registers (r0=num, r1=sin pointer, r2=cos pointer)
	push	{r1, r2, lr}

	// check angle range - rom version only works for -128 < angle < 128
	lsls	r3,r0,#1		// delete sign bit
	lsrs	r3,#24			// delete mantissa, get only exponent -> R3
	cmp	r3,#127 + 7		// check max. exponent = 2^7 = 128
	blt	2f			// exponent is ok

	// angle is too big, modulo angle range
	ldr	r1,=0x40c90fdb		// modulo = angle 2*pi (6.2831853f)
	push	{lr}			// save link register
	bl	remainderf		// get remainder of division angle/(2*pi) -> R0
	pop	{r1}			// return link register
	mov	lr,r1			// restore link register

	// call sinf from bootrom
2:	sf_call	SF_TABLE_FSIN		// call bootrom sinf

	// store result and return
	pop	{r2, r3}		// pop pointers, r2=sin pointer, r3=cos pointer
	str	r0,[r2]			// store sin
	str	r1,[r3]			// store cos
	pop	{pc}			// return

// ----------------------------------------------------------------------------
//                              Tangent
// ----------------------------------------------------------------------------
// float tanf(float x);

wrapper_func_text tanf

	// check angle range - rom version only works for -128 < angle < 128
	lsls	r1,r0,#1		// delete sign bit
	lsrs	r1,#24			// delete mantissa, get only exponent -> R1
	cmp	r1,#127 + 7		// check max. exponent = 2^7 = 128
	blt	2f			// exponent is ok

	// modulo angle range
	ldr	r1,=0x40c90fdb		// modulo = angle 2*pi (6.2831853f)
	push	{lr}			// save link register
	bl	remainderf		// get remainder of division angle/(2*pi) -> R0
	pop	{r1}			// return link register
	mov	lr,r1			// restore link register

	// disable interrupts (tanf uses hardware divider)
2:	push	{r4, lr}		// save registers
	irq_lock r4			// save interrupt into R4, disable interrupt

	// call tanf from bootrom
	sf_call	SF_TABLE_FTAN		// call bootrom tanf

	// restore interrupt and return
	irq_unlock r4			// restore interrupt from R4
	pop	{r4, pc}		// restore registers and return

// ----------------------------------------------------------------------------
//                              Arc tangent of y/x
// ----------------------------------------------------------------------------
// float atan2f(float y, float x);

wrapper_func_text atan2f

	// push registers
	push {r4,r5,lr}

	// unpack number y
// input: R0 = float number
// output: R0 = signed mantissa (24 significant bits)
//         R2 = signed exponent (bias removed) (zero = -380, infinity = +640)
// trashes: R4
	bl	unpackx		// unpack number y
	mov	r4,r0		// signed mantissa y -> R4
	mov	r0,r1		// x -> R0
	mov	r1,r4		// signed mantissa y -> R1
	mov	r3,r2		// signed exponent y -> R3
// here is: R0 = x, R1 = mantissa y, R3 = exponent y

	// unpack number x
	bl	unpackx		// unpack number x
// here is: R0 = mantissa x, R1 = mantissa y, R2 = exponent x, R3 = exponent y

	// shift mantissas left
	lsls	r0,r0,#5	// shift mantissa x to bits 5..27
	lsls	r1,r1,#5	// shift mantissa y to bits 5..27

	// sum exponents
	adds	r4,r2,r3	// R4 <- exponents x + y, -760 if both are 0
	asrs	r4,#9		// sum / 512
	adds	r4,#1		// sum + 1
	bmi	2f		// force y to 0 proper, so result will be zero

	// prepare shift
	subs	r4,r2,r3	// calculate shift
	bge	1f		// ex >= ey ?
	negs	r4,r4		// make shift positive
	asrs	r0,r4
	cmp	r4,#28
	blo	3f
	asrs	r0,#31
	b	3f

1:	asrs	r1,r4
	cmp	r4,#28
	blo	3f

	// here abs(x) >> abs(y), or both x and y are +-0
2:	cmp	r0,#0
	bge	4f		// x positive, return signed 0
	ldr	r0,pi_q29	// x negative, return +/- pi
	asrs	r1,#31
	eors	r0,r1
	b	7f

4:	asrs	r0,r1,#31
	b	7f

3:	movs	r2,#0		// initial angle
	cmp	r0,#0		// x negative
	bge	5f
	negs	r0,r0		// rotate to 1st/4th quadrants
	negs	r1,r1
	ldr	r2,pi_q29	// pi Q29

5:	adr	r3,tab_cc	// circular coefficients
	movs	r4,#1		// m=1
	bl	cordic_vec	// also produces magnitude (with scaling factor 1.646760119), which is discarded
	mov	r0,r2		// result here is -pi/2..3pi/2 Q29
	// asrs r2,#29
	// subs r0,r2
	ldr	r2,pi_q29	// pi Q29
	adds	r4,r0,r2	// attempt to fix -3pi/2..-pi case
	bcs	6f		// -pi/2..0? leave result as is
	subs	r4,r0,r2	// <pi? leave as is
	bmi	6f
	subs	r0,r4,r2	// >pi: take off 2pi

6:	subs	r0,#1		// fiddle factor so atan2(0,1)==0
7:	movs	r2,#0		// exponent for pack
packretns:			// pack and return, sticky bits=0
	movs	r5,#0
packret:			// common return point: "pack and return"
	bl	packx		// pack number
	pop	{r4,r5,pc}

.ltorg		// can collect and assemble literals into a literal pool

.align 2		// align to 4-byte boundary

// first entry in following table is pi Q29
pi_q29:
// circular CORDIC coefficients: atan(2^-i), b0=flag for preventing shift, b1=flag for end of table
tab_cc:
	.word	0x1921fb54*4+1     @ no shift before first iteration
	.word	0x0ed63383*4+0
	.word	0x07d6dd7e*4+0
	.word	0x03fab753*4+0
	.word	0x01ff55bb*4+0
	.word	0x00ffeaae*4+0
	.word	0x007ffd55*4+0
	.word	0x003fffab*4+0
	.word	0x001ffff5*4+0
	.word	0x000fffff*4+0
	.word	0x0007ffff*4+0
	.word	0x00040000*4+0
	.word	0x00020000*4+0+2   @ +2 marks end

// ----------------------------------------------------------------------------
//                            Natural exponent
// ----------------------------------------------------------------------------
// float expf(float x);

wrapper_func_text expf

	sf_jump	SF_TABLE_FEXP		// jump to bootrom expf

// ----------------------------------------------------------------------------
//                            Natural logarithm
// ----------------------------------------------------------------------------
// float logf(float x);

wrapper_func_text logf

	sf_jump	SF_TABLE_FLN		// jump to bootrom logf


#endif // USE_FLOAT		// use float support


#if USE_FLOAT || USE_DOUBLE	// use float or double support


// ----------------------------------------------------------------------------
//                       Convert float to double
// ----------------------------------------------------------------------------
// double f2d(float num);
// double float2double(float num);

regular_func_text float2double
regular_func f2d
wrapper_func __aeabi_f2d

	// prepare sign bit -> R3
	lsrs	r3,r0,#31		// get sign bit -> R3
	lsls	r3,#31			// shift sign bit back to position 31

	// isolate exponent -> R2
	lsls	r1,r0,#1		// destroy sign bit
	lsrs	r2,r1,#24		// isolate exponent
	beq	1f			// number is zero

	// check infinity NaN
	cmp	r2,#0xff		// infinity?
	beq	2f			// number is infinity

	// prepare new exponent -> R3 (float exponent: 8 bits, double exponent: 11 bits)
	lsrs	r1,#4			// shift exponent and top 20 bits of mantissa (difference is 3 bits + 1 bit already shifted)
	ldr	r2,=#(0x3ff-0x7f)<<20	// prepare difference of bias of exponents
	adds	r1,r2			// shift bias of exponent

	// add sign bit
	orrs	r1,r3			// add sign bit

	// prepare bottom 3 bits of mantissa -> R0
	lsls	r0,#29			// shift bottom 3 bits of mantissa to position 29
	bx	lr

	// result number is 0
1:	movs	r1,r3			// sign bit -> R1 (zero can be negative)
3:	movs	r0,#0			// number low = 0
	bx	lr			// return

	// result number is infinity NaN
2:	ldr	r1,=#0x7ff00000		// set number high to NaN
	adds	r1,r3			// add sign bit
	b	3b			// set number low = 0


#endif // USE_FLOAT || USE_DOUBLE	// use float or double support

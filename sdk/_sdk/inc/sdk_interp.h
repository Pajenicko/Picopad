
// ****************************************************************************
//
//                               Interpolator
//
// ****************************************************************************
// Each CPU core has its own 2 interpolators.

/*
Lane 0 and 1: Value from accumulator is right shifted, masked and added to base.
Both results from Lane 0 and 1 can added to base 2 (without base 0 and base 1) to full result.
Results can be written back to the accumulators.
*/

#if USE_INTERP	// use interpolator (sdk_interp.c, sdk_interp.h)

#ifndef _SDK_INTERP_H
#define _SDK_INTERP_H

#include "../sdk_addressmap.h"		// Register address offsets

#ifdef __cplusplus
extern "C" {
#endif

#define INTERP_NUM	2		// number of interpolator per CPU cure
#define INTERP_LANE_NUM	2		// number of lanes per interpolator

// interp = 0 or 1 (index of interpolator), lane = 0 or 1 (index of lane) or 2 for common value
//#define SIO_BASE		0xd0000000	// SIO registers
//    (SIO does not support aliases for atomic access!)
#define INTERP_ACCUM(interp, lane)	((volatile u32*)(SIO_BASE+(interp)*0x40+(lane)*4+0x80)) // R/W accumulator (lane = 0 or 1)
#define INTERP_BASE(interp, lane)	((volatile u32*)(SIO_BASE+(interp)*0x40+(lane)*4+0x88)) // R/W base (lane = 0 or 1, or 2 to common base)
#define INTERP_POP(interp, lane)	((volatile u32*)(SIO_BASE+(interp)*0x40+(lane)*4+0x94)) // RO read lane result and write to accumulators (lane = 0 or 1, or 2 for full result)
#define INTERP_PEEK(interp, lane)	((volatile u32*)(SIO_BASE+(interp)*0x40+(lane)*4+0xA0)) // RO read lane result without altering state (lane = 0 or 1, or 2 for full result)
#define INTERP_CTRL(interp, lane)	((volatile u32*)(SIO_BASE+(interp)*0x40+(lane)*4+0xAC)) // control register (lane = 0 or 1)
#define INTERP_ADD(interp, lane)	((volatile u32*)(SIO_BASE+(interp)*0x40+(lane)*4+0xB4)) // R/W add to accumulator (lane = 0 or 1)
#define INTERP_BASE01(interp)		((volatile u32*)(SIO_BASE+(interp)*0x40+0xBC)) // W0 write LOW 16 bits to BASE0, HIGH 16 bits to BASE1

// save interpolator state 
typedef struct {
	u32	accum0;		// accumulator 0
	u32	accum1;		// accumulator 1
	u32	base0;		// base 0
	u32	base1;		// base 1
	u32	base2;		// base 2
	u32	ctrl0;		// control 0
	u32	ctrl1;		// control 1
} sInterpSave;

// save interpolator state (for current CPU core)
void InterpSave(u8 interp, sInterpSave* save);

// load interpolator state (for current CPU core)
void InterpLoad(u8 interp, const sInterpSave* save);

// reset interpolator to default state
//  interp ... interpolator 0 or 1
void InterpReset(u8 interp);

// set interpolator accumulator
//  interp ... interpolator 0 or 1
//  accum ... accumulator 0 or 1
//  val ... value to set
INLINE void InterpAccum(u8 interp, u8 accum, u32 val) { *INTERP_ACCUM(interp, accum) = val; }

// get interpolator accumulator
//  interp ... interpolator 0 or 1
//  accum ... accumulator 0 or 1
INLINE u32 InterpGetAccum(u8 interp, u8 accum) { return *INTERP_ACCUM(interp, accum); }

// add atomically to interpolator accumulator
//  interp ... interpolator 0 or 1
//  accum ... accumulator 0 or 1
//  val ... value to add
INLINE void InterpAdd(u8 interp, u8 accum, u32 val) { *INTERP_ADD(interp, accum) = val; }

// get interpolator raw lane value (result of shift+mask operation)
//  interp ... interpolator 0 or 1
//  lane ... lane 0 or 1
INLINE u32 InterpRaw(u8 interp, u8 lane) { return *INTERP_ADD(interp, lane); }

// set interpolator base
//  interp ... interpolator 0 or 1
//  base ... base 0, 1 or 2
//  val ... value to set
INLINE void InterpBase(u8 interp, u8 base, u32 val) { *INTERP_BASE(interp, base) = val; }

// get interpolator base
//  interp ... interpolator 0 or 1
//  base ... base 0, 1 or 2
INLINE u32 InterpGetBase(u8 interp, u8 base) { return *INTERP_BASE(interp, base); }

// set interpolator both bases
//  interp ... interpolator 0 or 1
//  val ... value to set, lower 16 bits go to BASE0, upper 16 bits go to BASE1 (can be signed)
INLINE void InterpBaseBoth(u8 interp, u32 val) { *INTERP_BASE01(interp) = val; }

// set interpolator both bases
//  interp ... interpolator 0 or 1
//  val0 ... value to set to BASE0
//  val1 ... value to set to BASE1
INLINE void InterpBaseBoth16(u8 interp, u16 val0, u16 val1) { *INTERP_BASE01(interp) = ((u32)val1 << 16) | val0; }

// get lane result and write to both accumulators
//  interp ... interpolator 0 or 1
//  lane ... lane 0 or 1, 2 = full result
INLINE u32 InterpPop(u8 interp, u8 lane) { return *INTERP_POP(interp, lane); }

// get lane result without altering any internal state
//  interp ... interpolator 0 or 1
//  lane ... lane 0 or 1, 2 = full result
INLINE u32 InterpPeek(u8 interp, u8 lane) { return *INTERP_PEEK(interp, lane); }

// set interpolator shift (right-shift applied to accumulator before masking)
//  interp ... interpolator 0 or 1
//  lane ... lane 0 or 1
//  shift ... shift value 0 to 31
INLINE void InterpShift(u8 interp, u8 lane, u8 shift)
	{ *INTERP_CTRL(interp, lane) = (*INTERP_CTRL(interp, lane) & ~0x1f) | shift; }

// set interpolator mask range (range of bits that are allowed to pass)
//  interp ... interpolator 0 or 1
//  lane ... lane 0 or 1
//  lsb ... least significant bit allowed to pass, inclusive, 0 to 31
//  msb ... most significant bit allowed to pass, inclusive, 0 to 31 (lsb <= msb)
INLINE void InterpMask(u8 interp, u8 lane, u8 lsb, u8 msb)
	{ *INTERP_CTRL(interp, lane) = (*INTERP_CTRL(interp, lane) &
		~((0x1f<<5)|(0x1f<<10)) | ((u32)lsb<<5) | ((u32)msb<<10)); }

// set interpolator signed mode (values are sign-extended to 32 bits)
//  interp ... interpolator 0 or 1
//  lane ... lane 0 or 1
INLINE void InterpSigned(u8 interp, u8 lane) { *INTERP_CTRL(interp, lane) |= B15; }

// set interpolator unsigned mode (default state)
//  interp ... interpolator 0 or 1
//  lane ... lane 0 or 1
INLINE void InterpUnsigned(u8 interp, u8 lane) { *INTERP_CTRL(interp, lane) &= ~B15; }

// feed opposite lane's accumulator into this lane's shift+mask input
//  interp ... interpolator 0 or 1
//  lane ... lane 0 or 1
//  en ... True = feed opposite lane's accumulator to this input, False = use input from own accumulator
INLINE void InterpCrossInput(u8 interp, u8 lane, Bool en)
	{ *INTERP_CTRL(interp, lane) = (*INTERP_CTRL(interp, lane) & ~B16) | (en ? B16 : 0); }

// feed opposite lane's result into this lane's accumulator on POP
//  interp ... interpolator 0 or 1
//  lane ... lane 0 or 1
//  en ... True = feed opposite lane's result to this accumulator, False = no auto-feed from result
INLINE void InterpCrossResult(u8 interp, u8 lane, Bool en)
	{ *INTERP_CTRL(interp, lane) = (*INTERP_CTRL(interp, lane) & ~B17) | (en ? B17 : 0); }

// mask+shift is bypassed for this result, add raw input value (does not affect FULL result)
//  interp ... interpolator 0 or 1
//  lane ... lane 0 or 1
//  en ... True = shift+mask is bypassed, False = shif+mask is applied
INLINE void InterpAddRaw(u8 interp, u8 lane, Bool en)
	{ *INTERP_CTRL(interp, lane) = (*INTERP_CTRL(interp, lane) & ~B18) | (en ? B18 : 0); }

// Two data bits ORed into bits 29:28 of lane result presented to the processor (no effect on internal paths)
// - handy for using lane to generate sequence of pointers into flash or SRAM.
//  interp ... interpolator 0 or 1
//  lane ... lane 0 or 1
//  bits ... two bits to be ORed into bits 29:28, value 0 to 3
//            0 ... base address 0x00000000
//            1 ... base address 0x10000000, flash memory
//            2 ... base address 0x20000000, SRAM memory
//            3 ... base address 0x30000000
INLINE void InterpMSB(u8 interp, u8 lane, u8 bits)
	{ *INTERP_CTRL(interp, lane) = (*INTERP_CTRL(interp, lane) & ~(3<<19)) | ((u32)bits << 19); }

// blending mode (only on interpolator 0 of each CPU core)
//  en ... True = LANE1 result is linear interpolation between BASE0 and BASE1,
//         controlled by 8 LSB bits of LANE1 shift+mask value (fractional number 0 to 255 / 256),
//         LANE0 result does not have BASE0 added (yields only 8 LSB of LANE1 shift+mask),
//         FULL result does not have lane 1 shift+mask value addes (BASE2 + lane0 shift+mask),
// LANE1 SIGNED flag controls whether interpolation is signed or unsigned
INLINE void InterpBlend(Bool en)
	{ *INTERP_CTRL(0, 0) = (*INTERP_CTRL(0, 0) & ~B21) | (en ? B21 : 0); }

// clamping mode (only on interpolator 1 of each CPU core)
//  en ... True = LANE0 result is shifted and masked ACCUM0, clamped by
//         lower bound of BASE0 and upper bound of BASE1.
// LANE0 SIGNED flag controls whether comparisons are is signed or unsigned
INLINE void InterpClamp(Bool en)
	{ *INTERP_CTRL(1, 0) = (*INTERP_CTRL(1, 0) & ~B22) | (en ? B22 : 0); }

// check if any masked-off MSBs in ACCUM are set
//  interp ... interpolator 0 or 1
//  accum ... accumulator 0 or 1, 2 = either 0 or 1 is set
INLINE Bool InterpOver(u8 interp, u8 accum) { return ((*INTERP_CTRL(interp, 0) >> (23 + accum)) & 1) != 0; }

#ifdef __cplusplus
}
#endif

#endif // _SDK_INTERP_H

#endif // USE_INTERP	// use interpolator (sdk_interp.c, sdk_interp.h)

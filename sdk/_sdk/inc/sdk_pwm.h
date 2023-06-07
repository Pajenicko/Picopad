
// ****************************************************************************
//
//                           PWM Pulse Width Modulator
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// CPU has 8 PWM slices, each slice has 2 output channels (A or B).
// Same PWM output channel can be selected on two GPIO pins.
// If two PWM B pins are used as input, multiply GPIO pins will be OR of those inputs.

#if USE_PWM	// use PWM (sdk_pwm.c, sdk_pwm.h)

#ifndef _SDK_PWM_H
#define _SDK_PWM_H

#include "../sdk_addressmap.h"		// Register address offsets
#include "sdk_gpio.h"
#include "sdk_irq.h"

#ifdef __cplusplus
extern "C" {
#endif

#define PWM_NUM			8		// number of PWM slices

// Registers of PWM (pwm = 0 to 7)
//#define PWM_BASE		0x40050000	// PWM Pulse Width Modulator
#define PWM(pwm)	(PWM_BASE + (pwm)*20)	// PWM base (pwm = 0 to 7)

#define PWM_CSR(pwm)	((volatile u32*)(PWM(pwm)+0)) // control and status register
#define PWM_DIV(pwm)	((volatile u32*)(PWM(pwm)+4)) // divider
#define PWM_CTR(pwm)	((volatile u32*)(PWM(pwm)+8)) // counter
#define PWM_CC(pwm)	((volatile u32*)(PWM(pwm)+12)) // counter compare
#define PWM_TOP(pwm)	((volatile u32*)(PWM(pwm)+16)) // counter wrap

#define PWM_EN		((volatile u32*)(PWM_BASE+0xa0)) // enables
#define PWM_INTR	((volatile u32*)(PWM_BASE+0xa4)) // raw interrups
#define PWM_INTE	((volatile u32*)(PWM_BASE+0xa8)) // interrupt enable
#define PWM_INTF	((volatile u32*)(PWM_BASE+0xac)) // interrupt force
#define PWM_INTS	((volatile u32*)(PWM_BASE+0xb0)) // interrupt status

// clkdiv mode
#define PWM_DIV_FREE	0	// free-running at rate of divider
#define PWM_DIV_HIGH	1	// divider gated by PWM B pin
#define PWM_DIV_RISE	2	// divider advances with rising edge of PWM B pin
#define PWM_DIV_FALL	3	// divider advances with falling edge of PWM B pin

// output channels
#define PWM_CHAN_A	0	// output channel A
#define PWM_CHAN_B	1	// output channel B

// reset PWM slice to default values
void PWM_Reset(u8 pwm);

// convert GPIO pin to PWM output channels PWM_CHAN_* (returns 0=A or 1=B)
INLINE u8 PWM_GpioToChan(u8 gpio) { return gpio & 1; }
#define PWM_GPIOTOCHAN(gpio) ((gpio)&1)

// convert GPIO pin to PWM slice (returns 0 to 7)
INLINE u8 PWM_GpioToSlice(u8 gpio) { return (u8)((gpio >> 1) & 7); }
#define PWM_GPIOTOSLICE(gpio) (((gpio)>>1)&7)

// initialize GPIO to use as PWM pin
INLINE void PWM_GpioInit(u8 gpio) { GPIO_Fnc(gpio, GPIO_FNC_PWM); }

// enable PWM slice
INLINE void PWM_Enable(u8 pwm) { RegSet(PWM_CSR(pwm), B0); }

// enable PWM slices by mask
INLINE void PWM_EnableMask(u8 mask) { RegSet(PWM_EN, mask); }

// disable PWM slice
INLINE void PWM_Disable(u8 pwm) { RegClr(PWM_CSR(pwm), B0); }

// disable PWM slices by mask
INLINE void PWM_DisableMask(u8 mask) { RegClr(PWM_EN, mask); }

// enable phase-correct modulation
INLINE void PWM_PhaseCorrect(u8 pwm) { RegSet(PWM_CSR(pwm), B1); }

// enable trailing-edge modulation (disable phase-correct modulation)
INLINE void PWM_TrailingEdge(u8 pwm) { RegClr(PWM_CSR(pwm), B1); }

// inverting output channel enable (chan is output channel PWM_CHAN_*)
INLINE void PWM_InvEnable(u8 pwm, u8 chan) { RegSet(PWM_CSR(pwm), B2 << chan); }

// inverting output channel disable (chan is output channel PWM_CHAN_*)
INLINE void PWM_InvDisable(u8 pwm, u8 chan) { RegClr(PWM_CSR(pwm), B2 << chan); }

// set divider mode PWM_DIV_*
INLINE void PWM_DivMode(u8 pwm, u8 divmode) { RegMask(PWM_CSR(pwm), (u32)divmode << 4, B4+B5); }

// retard phase of counter by 1 (must be running)
INLINE void PWM_Retard(u8 pwm) { RegSet(PWM_CSR(pwm), B6); }

// advance phase of counter by 1 (must be running)
INLINE void PWM_Advance(u8 pwm) { RegSet(PWM_CSR(pwm), B7); }

// set clock divider for free-running mode
//  clkdiv ... clock divider * 16, value 0..0xfff (lower 4 bits are fractional part, upper 8 bits are integer part)
INLINE void PWM_ClkDiv(u8 pwm, u16 clkdiv) { *PWM_DIV(pwm) = clkdiv; }

// set clock counter (16-bit value)
INLINE void PWM_Count(u8 pwm, u16 cnt) { *PWM_CTR(pwm) = cnt; }

// get clock counter
INLINE u16 PWM_GetCount(u8 pwm) { return (u16)(*PWM_CTR(pwm) & 0xffff); }

// set compare value of output channel PWM_CHAN_* (cmp is 16-bit value)
INLINE void PWM_Comp(u8 pwm, u8 chan, u16 cmp) { RegMask(PWM_CC(pwm), (u32)cmp << (chan*16), 0xffff << (chan*16)); }

// get compare value of output channel PWM_CHAN_*
INLINE u16 PWM_GetComp(u8 pwm, u8 chan) { return (u16)(*PWM_CC(pwm) >> (chan*16)); }

// set counter top wrap value (counter period = top + 1)
INLINE void PWM_Top(u8 pwm, u16 top) { *PWM_TOP(pwm) = top; }

// get counter top wrap value
INLINE u16 PWM_GetTop(u8 pwm) { return (u16)*PWM_TOP(pwm); }

// get raw interrupt flag (not masked by EN)
INLINE Bool PWM_IntRaw(u8 pwm) { return ((*PWM_INTR >> pwm) & 1) != 0; }

// clear interrupt flag
INLINE void PWM_IntClear(u8 pwm) { *PWM_INTR = 1 << pwm; }

// enable interrupt
INLINE void PWM_IntEnable(u8 pwm) { RegSet(PWM_INTE, 1 << pwm); }

// disable interrupt
INLINE void PWM_IntDisable(u8 pwm) { RegClr(PWM_INTE, 1 << pwm); }

// force interrupt
INLINE void PWM_IntForce(u8 pwm) { *PWM_INTF = 1 << pwm; }

// get interrupt status (masked by EN)
INLINE Bool PWM_IntState(u8 pwm) { return ((*PWM_INTS >> pwm) & 1) != 0; }

// set clock frequency in Hz for free-running mode
//  freq ... frequency, for clk_sys = 125 MHz in range 488 kHz to 125 MHz
//     (for TOP=256 sampling rate 1.9 kHz to 488 kHz)
void PWM_Clock(u8 pwm, u32 freq);

#ifdef __cplusplus
}
#endif

#endif // _SDK_PWM_H

#endif // USE_PWM	// use PWM (sdk_pwm.c, sdk_pwm.h)

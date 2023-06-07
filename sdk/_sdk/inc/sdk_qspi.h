
// ****************************************************************************
//
//                           QSPI flash pins
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// 6 QSPI pins: SCLK, SS, SD0, SD1, SD2, SD3

// QSPI functions are almost identical to GPIO functions, but use different register addresses.

// Groups of functions:
//  1) get QSPI pin status (signal before override and after override)
//  2) set QSPI pin function select and overrides
//  3) QSPI IRQ interrupt control
//  4) QSPI pads setup - pulls, output strength
//  5) QSPI pin data - input, output, output enable

#ifndef _SDK_QSPI_H
#define _SDK_QSPI_H

#include "../sdk_addressmap.h"		// Register address offsets
#include "sdk_cpu.h"

#ifdef __cplusplus
extern "C" {
#endif

// QSPI pins
#define QSPI_PIN_SCLK	0
#define QSPI_PIN_SS	1
#define QSPI_PIN_SD0	2
#define QSPI_PIN_SD1	3
#define QSPI_PIN_SD2	4
#define QSPI_PIN_SD3	5

#define QSPI_PIN_NUM	6		// number of QSPI pins
#define QSPI_PIN_ALLMASK 0x3f		// mask of all QSPI pins

//#define IO_QSPI_BASE		0x40018000	// QSPI pads
#define QSPI_STATUS(pin) ((volatile u32*)(IO_QSPI_BASE+(pin)*8)) // QSPI status (read only), pin = QSPI_PIN_*
#define QSPI_CTRL(pin) ((volatile u32*)(IO_QSPI_BASE+(pin)*8+4)) // QSPI pin control, pin = QSPI_PIN_*
#define QSPI_IRQ_INTR ((volatile u32*)(IO_QSPI_BASE+0x30)) // raw interrupt of both CPUs
#define QSPI_IRQ_INTE(cpu) ((volatile u32*)(IO_QSPI_BASE+(cpu)*12+0x34)) // interrupt enable
#define QSPI_IRQ_INTF(cpu) ((volatile u32*)(IO_QSPI_BASE+(cpu)*12+0x38)) // force interrupt
#define QSPI_IRQ_INTS(cpu) ((volatile u32*)(IO_QSPI_BASE+(cpu)*12+0x3C)) // interrupt status

//#define PADS_QSPI_BASE		0x40020000	// QSPI pad control
#define QSPI_PAD(pin) ((volatile u32*)(PADS_QSPI_BASE+(pin)*4+4)) // QSPI pad control register, pin = QSPI_PIN_*

// QSPI pin data registers (bit 0..5 = pin QSPI_PIN_*)
//#define SIO_BASE		0xd0000000	// SIO registers
//   (SIO does not support aliases for atomic access!)
#define QSPI_IN		((volatile u32*)(SIO_BASE+8))		// QSPI input
#define QSPI_OUT	((volatile u32*)(SIO_BASE+0x30))	// QSPI output (read: last value written to output)
#define QSPI_OUT_SET	((volatile u32*)(SIO_BASE+0x34))	// QSPI output set
#define QSPI_OUT_CLR	((volatile u32*)(SIO_BASE+0x38))	// QSPI output clear
#define QSPI_OUT_XOR	((volatile u32*)(SIO_BASE+0x3C))	// QSPI output XOR
#define QSPI_OE		((volatile u32*)(SIO_BASE+0x40))	// QSPI output enable (read: last value written)
#define QSPI_OE_SET	((volatile u32*)(SIO_BASE+0x44))	// QSPI output enable set
#define QSPI_OE_CLR	((volatile u32*)(SIO_BASE+0x48))	// QSPI output enable clear
#define QSPI_OE_XOR	((volatile u32*)(SIO_BASE+0x4C))	// QSPI output enable XOR

// QSPI pin functions (identical to GPIO_FNC_* functions)
#define QSPI_FNC_XIP	0	// external Flash
#define QSPI_FNC_SPI	1	// SPI
#define QSPI_FNC_UART	2	// UART
#define QSPI_FNC_I2C	3	// I2C
#define QSPI_FNC_PWM	4	// PWM
#define QSPI_FNC_SIO	5	// SIO (QSPI)
#define QSPI_FNC_PIO0	6	// PIO 0
#define QSPI_FNC_PIO1	7	// PIO 1
#define QSPI_FNC_GPCK	8	// clock (only pins 20..25)
#define QSPI_FNC_USB	9	// USB
#define QSPI_FNC_NULL	31	// no function

// interrupt events (values are identical to IRQ_EVENT_* for GPIO)
#define IRQ_EVENT_LEVELLOW	B0	// level low
#define IRQ_EVENT_LEVELHIGH	B1	// level high
#define IRQ_EVENT_EDGELOW	B2	// edge low
#define IRQ_EVENT_EDGEHIGH	B3	// edge high

#define IRQ_EVENT_ALL		0x0f	// all events
#define IRQ_EVENT_NONE		0	// no event

// get output (0 or 1) from peripheral, before override (pin = QSPI_PIN_*)
INLINE u8 QSPI_OutPeri(u8 pin) { return (u8)((*QSPI_STATUS(pin) >> 8) & 1); }

// get output (0 or 1) to pad, after override (pin = QSPI_PIN_*)
INLINE u8 QSPI_OutPad(u8 pin) { return (u8)((*QSPI_STATUS(pin) >> 9) & 1); }

// get output enable (0 or 1) from peripheral, before override (pin = QSPI_PIN_*)
INLINE u8 QSPI_OePeri(u8 pin) { return (u8)((*QSPI_STATUS(pin) >> 12) & 1); }

// get output enable (0 or 1) to pad, after override (pin = QSPI_PIN_*)
INLINE u8 QSPI_OePad(u8 pin) { return (u8)((*QSPI_STATUS(pin) >> 13) & 1); }

// get input (0 or 1) from pad, before override (pin = QSPI_PIN_*)
INLINE u8 QSPI_InPad(u8 pin) { return (u8)((*QSPI_STATUS(pin) >> 17) & 1); }

// get input (0 or 1) to peripheral, after override (pin = QSPI_PIN_*)
INLINE u8 QSPI_InPeri(u8 pin) { return (u8)((*QSPI_STATUS(pin) >> 19) & 1); }

// get interrupt (0 or 1) from pad, before override (pin = QSPI_PIN_*)
INLINE u8 QSPI_IrqPad(u8 pin) { return (u8)((*QSPI_STATUS(pin) >> 24) & 1); }

// get interrupt (0 or 1) to processor, after override (pin = QSPI_PIN_*)
INLINE u8 QSPI_IrqProc(u8 pin) { return (u8)((*QSPI_STATUS(pin) >> 26) & 1); }

// set QSPI function QSPI_FNC_*, reset overrides to normal mode, reset pad setup (pin = QSPI_PIN_*)
void QSPI_Fnc(u8 pin, u8 fnc);

// set QSPI function QSPI_FNC_* with mask (bit '1' to set function of this pin)
// To use pin mask in range (first..last), use function RangeMask.
void QSPI_FncMask(u32 mask, u8 fnc);

// set Output pin override - normal (default state; pin = QSPI_PIN_*)
INLINE void QSPI_OutOverNormal(u8 pin) { RegClr(QSPI_CTRL(pin), B8|B9); }

// set Output pin override - invert (pin = QSPI_PIN_*)
INLINE void QSPI_OutOverInvert(u8 pin) { RegMask(QSPI_CTRL(pin), B8, B8|B9); }

// set Output pin override - low (pin = QSPI_PIN_*)
INLINE void QSPI_OutOverLow(u8 pin) { RegMask(QSPI_CTRL(pin), B9, B8|B9); }

// set Output pin override - high (pin = QSPI_PIN_*)
INLINE void QSPI_OutOverHigh(u8 pin) { RegSet(QSPI_CTRL(pin), B8|B9); }

// set Output enable pin override - normal (default state; pin = QSPI_PIN_*)
INLINE void QSPI_OEOverNormal(u8 pin) { RegClr(QSPI_CTRL(pin), B12|B13); }

// set Output enable pin override - invert (pin = QSPI_PIN_*)
INLINE void QSPI_OEOverInvert(u8 pin) { RegMask(QSPI_CTRL(pin), B12, B12|B13); }

// set Output enable pin override - disable (pin = QSPI_PIN_*)
INLINE void QSPI_OEOverDisable(u8 pin) { RegMask(QSPI_CTRL(pin), B13, B12|B13); }

// set Output enable pin override - enable (pin = QSPI_PIN_*)
INLINE void QSPI_OEOverEnable(u8 pin) { RegSet(QSPI_CTRL(pin), B12|B13); }

// set Input pin override - normal (default state; pin = QSPI_PIN_*)
INLINE void QSPI_InOverNormal(u8 pin) { RegClr(QSPI_CTRL(pin), B16|B17); }

// set Input pin override - invert (pin = QSPI_PIN_*)
INLINE void QSPI_InOverInvert(u8 pin) { RegMask(QSPI_CTRL(pin), B16, B16|B17); }

// set Input pin override - low (pin = QSPI_PIN_*)
INLINE void QSPI_InOverLow(u8 pin) { RegMask(QSPI_CTRL(pin), B17, B16|B17); }

// set Input pin override - high (pin = QSPI_PIN_*)
INLINE void QSPI_InOverHigh(u8 pin) { RegSet(QSPI_CTRL(pin), B16|B17); }

// set IRQ pin override - normal (default state; pin = QSPI_PIN_*)
INLINE void QSPI_IRQOverNormal(u8 pin) { RegClr(QSPI_CTRL(pin), B28|B29); }

// set IRQ pin override - invert (pin = QSPI_PIN_*)
INLINE void QSPI_IRQOverInvert(u8 pin) { RegMask(QSPI_CTRL(pin), B28, B28|B29); }

// set IRQ pin override - low (pin = QSPI_PIN_*)
INLINE void QSPI_IRQOverLow(u8 pin) { RegMask(QSPI_CTRL(pin), B29, B28|B29); }

// set IRQ pin override - high (pin = QSPI_PIN_*)
INLINE void QSPI_IRQOverHigh(u8 pin) { RegSet(QSPI_CTRL(pin), B28|B29); }

// acknowledge IRQ interrupt for both CPU
//   pin = QSPI_PIN_*
//   events = bit mask with IRQ_EVENT_* of events to acknowledge
INLINE void QSPI_IRQAck(u8 pin, u8 events) { *QSPI_IRQ_INTR = (u32)events << (4*pin); }

// enable IRQ interrupt for selected/current CPU
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = QSPI_PIN_*
//   events = bit mask with IRQ_EVENT_* of events to enable

// After enabling interrupt from pin, following steps are necessary:
//   - set handler of IRQ_IO_QSPI (use function SetHandler), or use isr_io_qspi handler
//   - not necessary, but rather clear pending interrupt of IRQ_IO_QSPI (use function NVIC_IRQClear)
//   - enable NVIC interrupt of IRQ_IO_QSPI (use function NVIC_IRQEnable)
//   - enable global interrupt ei()

INLINE void QSPI_IRQEnableCpu(u8 cpu, u8 pin, u8 events) { RegSet(QSPI_IRQ_INTE(cpu), (u32)events << (4*pin)); }
INLINE void QSPI_IRQEnable(u8 pin, u8 events) { QSPI_IRQEnableCpu(CpuID(), pin, events); }

// disable IRQ interrupt for selected/current CPU
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = QSPI_PIN_*
//   events = bit mask with IRQ_EVENT_* of events to disable
INLINE void QSPI_IRQDisableCpu(u8 cpu, u8 pin, u8 events) { RegClr(QSPI_IRQ_INTE(cpu), (u32)events << (4*pin)); }
INLINE void QSPI_IRQDisable(u8 pin, u8 events) { QSPI_IRQDisableCpu(CpuID(), pin, events); }

// force IRQ interrupt for selected/current CPU
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = QSPI_PIN_*
//   events = bit mask with IRQ_EVENT_* of events to force
INLINE void QSPI_IRQForceCpu(u8 cpu, u8 pin, u8 events) { RegSet(QSPI_IRQ_INTF(cpu), (u32)events << (4*pin)); }
INLINE void QSPI_IRQForce(u8 pin, u8 events) { QSPI_IRQForceCpu(CpuID(), pin, events); }

// clear force IRQ interrupt for selected/current CPU
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = QSPI_PIN_*
//   events = bit mask with IRQ_EVENT_* of events to unforce
INLINE void QSPI_IRQUnforceCpu(u8 cpu, u8 pin, u8 events) { RegClr(QSPI_IRQ_INTF(cpu), (u32)events << (4*pin)); }
INLINE void QSPI_IRQUnforce(u8 pin, u8 events) { QSPI_IRQUnforceCpu(CpuID(), pin, events); }

// check IRQ interrupt status for selected/current CPU (returns 1 if IRQ is pending)
//   core = CPU core 0 or 1, use CpuID() to get current core
//   pin = QSPI_PIN_*
//   returns events = bit mask with IRQ_EVENT_* of incoming events
INLINE u8 QSPI_IRQIsPendingCpu(u8 cpu, u8 pin) { return (u8)((*QSPI_IRQ_INTS(cpu) >> (4*pin)) & IRQ_EVENT_ALL); }
INLINE u8 QSPI_IRQIsPending(u8 pin) { return QSPI_IRQIsPendingCpu(CpuID(), pin); }

// QSPI output enable; disable has priority over QSPI_DirOut (default state; pin = QSPI_PIN_*)
INLINE void QSPI_OutEnable(u8 pin) { RegClr(QSPI_PAD(pin), B7); }

// QSPI output disable; disable has priority over QSPI_DirOut (pin = QSPI_PIN_*)
INLINE void QSPI_OutDisable(u8 pin) { RegSet(QSPI_PAD(pin), B7); }

// enable pin input (default state; pin = QSPI_PIN_*)
INLINE void QSPI_InEnable(u8 pin) { RegSet(QSPI_PAD(pin), B6); }

// disable pin input (should be used on ADC input; pin = QSPI_PIN_*)
INLINE void QSPI_InDisable(u8 pin) { RegClr(QSPI_PAD(pin), B6); }

// set output strength to 2 mA (pin = QSPI_PIN_*)
INLINE void QSPI_Drive2mA(u8 pin) { RegClr(QSPI_PAD(pin), B4|B5); }

// set output strength to 4 mA (default state; pin = QSPI_PIN_*)
INLINE void QSPI_Drive4mA(u8 pin) { RegMask(QSPI_PAD(pin), B4, B4|B5); }

// set output strength to 8 mA (pin = QSPI_PIN_*)
INLINE void QSPI_Drive8mA(u8 pin) { RegMask(QSPI_PAD(pin), B5, B4|B5); }

// set output strength to 12 mA (pin = QSPI_PIN_*)
INLINE void QSPI_Drive12mA(u8 pin) { RegSet(QSPI_PAD(pin), B4|B5); }

// set no pulls (pin = QSPI_PIN_*)
INLINE void QSPI_NoPull(u8 pin) { RegClr(QSPI_PAD(pin), B2|B3); }

// set pull down (default state; pin = QSPI_PIN_*)
INLINE void QSPI_PullDown(u8 pin) { RegMask(QSPI_PAD(pin), B2, B2|B3); }

// set pull up (pin = QSPI_PIN_*)
INLINE void QSPI_PullUp(u8 pin) { RegMask(QSPI_PAD(pin), B3, B2|B3); }

// set bus keep (weak pull up and down; pin = QSPI_PIN_*)
INLINE void QSPI_BusKeep(u8 pin) { RegSet(QSPI_PAD(pin), B2|B3); }

// enable schmitt trigger (use hysteresis on input; default state; pin = QSPI_PIN_*)
INLINE void QSPI_SchmittEnable(u8 pin) { RegSet(QSPI_PAD(pin), B1); }

// disable schmitt trigger (do not use hysteresis on input; pin = QSPI_PIN_*)
INLINE void QSPI_SchmittDisable(u8 pin) { RegClr(QSPI_PAD(pin), B1); }

// use slow slew rate control on output (default state; pin = QSPI_PIN_*)
INLINE void QSPI_Slow(u8 pin) { RegClr(QSPI_PAD(pin), B0); }

// use fast slew rate control on output (pin = QSPI_PIN_*)
INLINE void QSPI_Fast(u8 pin) { RegSet(QSPI_PAD(pin), B0); }

// get input pin (returns 0 or 1; pin = QSPI_PIN_*)
INLINE u8 QSPI_In(u8 pin) { return (u8)((*QSPI_IN >> pin) & 1); }

// get all input pins (bit 0..5 = pin QSPI_PIN_*)
INLINE u32 QSPI_InAll() { return *QSPI_IN; }

// output 0 to pin (pin = QSPI_PIN_*)
INLINE void QSPI_Out0(u8 pin) { *QSPI_OUT_CLR = BIT(pin); }

// output 1 to pin (pin = QSPI_PIN_*)
INLINE void QSPI_Out1(u8 pin) { *QSPI_OUT_SET = BIT(pin); }

// flip output to pin (pin = QSPI_PIN_*)
INLINE void QSPI_Flip(u8 pin) { *QSPI_OUT_XOR = BIT(pin); }

// output value to pin (val = 0 or val != 0; pin = QSPI_PIN_*)
INLINE void QSPI_Out(u8 pin, int val) { if (val == 0) QSPI_Out0(pin); else QSPI_Out1(pin); }

// output masked values to pins
// To use pin mask in range (first..last), use function RangeMask.
INLINE void QSPI_OutMask(u32 mask, u32 value) { *QSPI_OUT_XOR = (*QSPI_OUT ^ value) & mask; }

// clear output pins masked
// To use pin mask in range (first..last), use function RangeMask.
INLINE void QSPI_ClrMask(u32 mask) { *QSPI_OUT_CLR = mask; }

// set output pins masked
// To use pin mask in range (first..last), use function RangeMask.
INLINE void QSPI_SetMask(u32 mask) { *QSPI_OUT_SET = mask; }

// flip output pins masked
// To use pin mask in range (first..last), use function RangeMask.
INLINE void QSPI_FlipMask(u32 mask) { *QSPI_OUT_XOR = mask; }

// get last output value to pin (returns 0 or 1; pin = QSPI_PIN_*)
INLINE u8 QSPI_GetOut(u8 pin) { return (u8)((*QSPI_OUT >> pin) & 1); }

// get all last output values to pins
INLINE u32 QSPI_GetOutAll() { return *QSPI_OUT; }

// set output direction of pin (enable output mode; pin = QSPI_PIN_*)
INLINE void QSPI_DirOut(u8 pin) { *QSPI_OE_SET = BIT(pin); }

// set input direction of pin (disable output mode; pin = QSPI_PIN_*)
INLINE void QSPI_DirIn(u8 pin) { *QSPI_OE_CLR = BIT(pin); }

// set output direction of pin masked
// To use pin mask in range (first..last), use function RangeMask.
INLINE void QSPI_DirOutMask(u32 mask) { *QSPI_OE_SET = mask; }

// set input direction of pin masked
// To use pin mask in range (first..last), use function RangeMask.
INLINE void QSPI_DirInMask(u32 mask) { *QSPI_OE_CLR = mask; }

// get output direction of pin (returns 0=input or 1=output; pin = QSPI_PIN_*)
INLINE u8 QSPI_GetDir(u8 pin) { return (u8)((*QSPI_OE >> pin) & 1); }

// get output direction of all pins (0=input, 1=output)
INLINE u32 QSPI_GetDirAll() { return *QSPI_OE; }

// initialize QSPI pin base function, set input mode, LOW output value (pin = QSPI_PIN_*)
void QSPI_Init(u8 pin);

// initialize QSPI pin base function masked (bit '1' = initialize this pin)
// To use pin mask in range (first..last), use function RangeMask.
void QSPI_InitMask(u32 mask);

// reset QSPI pin (return to reset state)
void QSPI_Reset(u8 pin);

// reset QSPI pins masked (return to reset state)
// To use pin mask in range (first..last), use function RangeMask.
void QSPI_ResetMask(u32 mask);

#ifdef __cplusplus
}
#endif

#endif // _SDK_QSPI_H

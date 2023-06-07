
// ****************************************************************************
//
//                                GPIO pins
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// 30 GPIO pins: index 0..29
//
// Groups of functions:
//  1) get GPIO pin status (signal before override and after override)
//  2) set GPIO pin function select and overrides
//  3) GPIO IRQ interrupt control
//  4) GPIO pads setup - pulls, output strength
//  5) GPIO pin data - input, output, output enable

#ifndef _SDK_GPIO_H
#define _SDK_GPIO_H

#include "../sdk_addressmap.h"		// Register address offsets
#include "sdk_cpu.h"

#ifdef __cplusplus
extern "C" {
#endif

#define GPIO_PIN_NUM	30		// number of GPIO pins
#define GPIO_PIN_ALLMASK 0x3FFFFFFF	// mask of all GPIO pins

// registes (pin = 0..29)
//#define IO_BANK0_BASE		0x40014000	// GPIO pads
#define GPIO_STATUS(pin) ((volatile u32*)(IO_BANK0_BASE+(pin)*8)) // GPIO status (read only), pin = 0..29
#define GPIO_CTRL(pin) ((volatile u32*)(IO_BANK0_BASE+(pin)*8+4)) // GPIO pin control, pin = 0..29
// IRQ control registers, array of 4*u32 (cpu = processor core 0 or 1)
#define GPIO_IRQ_INTR ((volatile u32*)(IO_BANK0_BASE+0xf0)) // raw interrupt of both CPUs
#define GPIO_IRQ_INTE(cpu) ((volatile u32*)(IO_BANK0_BASE+(cpu)*0x30+0x100)) // interrupt enable
#define GPIO_IRQ_INTF(cpu) ((volatile u32*)(IO_BANK0_BASE+(cpu)*0x30+0x110)) // force interrupt
#define GPIO_IRQ_INTS(cpu) ((volatile u32*)(IO_BANK0_BASE+(cpu)*0x30+0x120)) // interrupt status

//#define PADS_BANK0_BASE		0x4001c000	// GPIO pad control
#define GPIO_PAD(pin) ((volatile u32*)(PADS_BANK0_BASE+(pin)*4+4)) // GPIO pad control register, pin = 0..29

// GPIO pin data registers (bit 0..29 = pin 0..29)
//#define SIO_BASE		0xd0000000	// SIO registers
//  (SIO does not support aliases for atomic access!)
#define GPIO_IN		((volatile u32*)(SIO_BASE+4))		// GPIO input
#define GPIO_OUT	((volatile u32*)(SIO_BASE+0x10))	// GPIO output (read: last value written to output)
#define GPIO_OUT_SET	((volatile u32*)(SIO_BASE+0x14))	// GPIO output set
#define GPIO_OUT_CLR	((volatile u32*)(SIO_BASE+0x18))	// GPIO output clear
#define GPIO_OUT_XOR	((volatile u32*)(SIO_BASE+0x1C))	// GPIO output XOR
#define GPIO_OE		((volatile u32*)(SIO_BASE+0x20))	// GPIO output enable (read: last value written)
#define GPIO_OE_SET	((volatile u32*)(SIO_BASE+0x24))	// GPIO output enable set
#define GPIO_OE_CLR	((volatile u32*)(SIO_BASE+0x28))	// GPIO output enable clear
#define GPIO_OE_XOR	((volatile u32*)(SIO_BASE+0x2C))	// GPIO output enable XOR

// GPIO pin functions
#define GPIO_FNC_XIP	0	// external Flash
#define GPIO_FNC_SPI	1	// SPI
#define GPIO_FNC_UART	2	// UART
#define GPIO_FNC_I2C	3	// I2C
#define GPIO_FNC_PWM	4	// PWM
#define GPIO_FNC_SIO	5	// SIO (GPIO)
#define GPIO_FNC_PIO0	6	// PIO 0
#define GPIO_FNC_PIO1	7	// PIO 1
#define GPIO_FNC_GPCK	8	// clock (only pins 20..25)
#define GPIO_FNC_USB	9	// USB
#define GPIO_FNC_NULL	31	// no function (use in case of ADC input)

// interrupt events
#define IRQ_EVENT_LEVELLOW	B0	// level low
#define IRQ_EVENT_LEVELHIGH	B1	// level high
#define IRQ_EVENT_EDGELOW	B2	// edge low
#define IRQ_EVENT_EDGEHIGH	B3	// edge high

#define IRQ_EVENT_ALL		0x0f	// all events
#define IRQ_EVENT_NONE		0	// no event

// get output (0 or 1) from peripheral, before override (pin = 0..29)
INLINE u8 GPIO_OutPeri(u8 pin) { return (u8)((*GPIO_STATUS(pin) >> 8) & 1); }

// get output (0 or 1) to pad, after override (pin = 0..29)
INLINE u8 GPIO_OutPad(u8 pin) { return (u8)((*GPIO_STATUS(pin) >> 9) & 1); }

// get output enable (0 or 1) from peripheral, before override (pin = 0..29)
INLINE u8 GPIO_OePeri(u8 pin) { return (u8)((*GPIO_STATUS(pin) >> 12) & 1); }

// get output enable (0 or 1) to pad, after override (pin = 0..29)
INLINE u8 GPIO_OePad(u8 pin) { return (u8)((*GPIO_STATUS(pin) >> 13) & 1); }

// get input (0 or 1) from pad, before override (pin = 0..29)
INLINE u8 GPIO_InPad(u8 pin) { return (u8)((*GPIO_STATUS(pin) >> 17) & 1); }

// get input (0 or 1) to peripheral, after override (pin = 0..29)
INLINE u8 GPIO_InPeri(u8 pin) { return (u8)((*GPIO_STATUS(pin) >> 19) & 1); }

// get interrupt (0 or 1) from pad, before override (pin = 0..29)
INLINE u8 GPIO_IrqPad(u8 pin) { return (u8)((*GPIO_STATUS(pin) >> 24) & 1); }

// get interrupt (0 or 1) to processor, after override (pin = 0..29)
INLINE u8 GPIO_IrqProc(u8 pin) { return (u8)((*GPIO_STATUS(pin) >> 26) & 1); }

// set GPIO function GPIO_FNC_*, reset overrides to normal mode, reset pad setup (pin = 0..29)
void GPIO_Fnc(u8 pin, u8 fnc);

// set GPIO function GPIO_FNC_* with mask (bit '1' to set function of this pin)
// To use pin mask in range (first..last), use function RangeMask.
void GPIO_FncMask(u32 mask, u8 fnc);

// set Output pin override - normal (default state; pin = 0..29)
INLINE void GPIO_OutOverNormal(u8 pin) { RegClr(GPIO_CTRL(pin), B8|B9); }

// set Output pin override - invert (pin = 0..29)
INLINE void GPIO_OutOverInvert(u8 pin) { RegMask(GPIO_CTRL(pin), B8, B8|B9); }

// set Output pin override - low (pin = 0..29)
INLINE void GPIO_OutOverLow(u8 pin) { RegMask(GPIO_CTRL(pin), B9, B8|B9); }

// set Output pin override - high (pin = 0..29)
INLINE void GPIO_OutOverHigh(u8 pin) { RegSet(GPIO_CTRL(pin), B8|B9); }

// set Output enable pin override - normal (default state; pin = 0..29)
INLINE void GPIO_OEOverNormal(u8 pin) { RegClr(GPIO_CTRL(pin), B12|B13); }

// set Output enable pin override - invert (pin = 0..29)
INLINE void GPIO_OEOverInvert(u8 pin) { RegMask(GPIO_CTRL(pin), B12, B12|B13); }

// set Output enable pin override - disable (pin = 0..29)
INLINE void GPIO_OEOverDisable(u8 pin) { RegMask(GPIO_CTRL(pin), B13, B12|B13); }

// set Output enable pin override - enable (pin = 0..29)
INLINE void GPIO_OEOverEnable(u8 pin) { RegSet(GPIO_CTRL(pin), B12|B13); }

// set Input pin override - normal (default state; pin = 0..29)
INLINE void GPIO_InOverNormal(u8 pin) { RegClr(GPIO_CTRL(pin), B16|B17); }

// set Input pin override - invert (pin = 0..29)
INLINE void GPIO_InOverInvert(u8 pin) { RegMask(GPIO_CTRL(pin), B16, B16|B17); }

// set Input pin override - low (pin = 0..29)
INLINE void GPIO_InOverLow(u8 pin) { RegMask(GPIO_CTRL(pin), B17, B16|B17); }

// set Input pin override - high (pin = 0..29)
INLINE void GPIO_InOverHigh(u8 pin) { RegSet(GPIO_CTRL(pin), B16|B17); }

// set IRQ pin override - normal (default state; pin = 0..29)
INLINE void GPIO_IRQOverNormal(u8 pin) { RegClr(GPIO_CTRL(pin), B28|B29); }

// set IRQ pin override - invert (pin = 0..29)
INLINE void GPIO_IRQOverInvert(u8 pin) { RegMask(GPIO_CTRL(pin), B28, B28|B29); }

// set IRQ pin override - low (pin = 0..29)
INLINE void GPIO_IRQOverLow(u8 pin) { RegMask(GPIO_CTRL(pin), B29, B28|B29); }

// set IRQ pin override - high (pin = 0..29)
INLINE void GPIO_IRQOverHigh(u8 pin) { RegSet(GPIO_CTRL(pin), B28|B29); }

// acknowledge IRQ interrupt for both CPU
//   pin = 0..29
//   events = bit mask with IRQ_EVENT_* of events to acknowledge
void GPIO_IRQAck(u8 pin, u8 events);

// enable IRQ interrupt for selected/current CPU
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = 0..29
//   events = bit mask with IRQ_EVENT_* of events to enable

// After enabling interrupt from pin, following steps are necessary:
//   - set handler of IRQ_IO_BANK0 (use function SetHandler), or use isr_io_bank0 handler
//   - not necessary, but rather clear pending interrupt of IRQ_IO_BANK0 (use function NVIC_IRQClear)
//   - enable NVIC interrupt of IRQ_IO_BANK0 (use function NVIC_IRQEnable)
//   - enable global interrupt ei()

void GPIO_IRQEnableCpu(u8 cpu, u8 pin, u8 events);
INLINE void GPIO_IRQEnable(u8 pin, u8 events) { GPIO_IRQEnableCpu(CpuID(), pin, events); }

// disable IRQ interrupt for selected/current CPU
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = 0..29
//   events = bit mask with IRQ_EVENT_* of events to disable
void GPIO_IRQDisableCpu(u8 cpu, u8 pin, u8 events);
INLINE void GPIO_IRQDisable(u8 pin, u8 events) { GPIO_IRQDisableCpu(CpuID(), pin, events); }

// force IRQ interrupt for selected/current CPU
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = 0..29
//   events = bit mask with IRQ_EVENT_* of events to force
void GPIO_IRQForceCpu(u8 cpu, u8 pin, u8 events);
INLINE void GPIO_IRQForce(u8 pin, u8 events) { GPIO_IRQForceCpu(CpuID(), pin, events); }

// clear force IRQ interrupt for selected/current CPU
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = 0..29
//   events = bit mask with IRQ_EVENT_* of events to unforce
void GPIO_IRQUnforceCpu(u8 cpu, u8 pin, u8 events);
INLINE void GPIO_IRQUnforce(u8 pin, u8 events) { GPIO_IRQUnforceCpu(CpuID(), pin, events); }

// check IRQ interrupt status for selected/current CPU (returns 1 if IRQ is pending)
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = 0..29
//   returns events = bit mask with IRQ_EVENT_* of incoming events
u8 GPIO_IRQIsPendingCpu(u8 cpu, u8 pin);
INLINE u8 GPIO_IRQIsPending(u8 pin) { return GPIO_IRQIsPendingCpu(CpuID(), pin); }

// GPIO output enable; disable has priority over GPIO_DirOut (default state; pin = 0..29)
INLINE void GPIO_OutEnable(u8 pin) { RegClr(GPIO_PAD(pin), B7); }

// GPIO output disable; disable has priority over GPIO_DirOut (pin = 0..29)
INLINE void GPIO_OutDisable(u8 pin) { RegSet(GPIO_PAD(pin), B7); }

// enable pin input (default state; pin = 0..29)
INLINE void GPIO_InEnable(u8 pin) { RegSet(GPIO_PAD(pin), B6); }

// disable pin input (should be used on ADC input; pin = 0..29)
INLINE void GPIO_InDisable(u8 pin) { RegClr(GPIO_PAD(pin), B6); }

// set output strength to 2 mA (pin = 0..29)
INLINE void GPIO_Drive2mA(u8 pin) { RegClr(GPIO_PAD(pin), B4|B5); }

// set output strength to 4 mA (default state; pin = 0..29)
INLINE void GPIO_Drive4mA(u8 pin) { RegMask(GPIO_PAD(pin), B4, B4|B5); }

// set output strength to 8 mA (pin = 0..29)
INLINE void GPIO_Drive8mA(u8 pin) { RegMask(GPIO_PAD(pin), B5, B4|B5); }

// set output strength to 12 mA (pin = 0..29)
INLINE void GPIO_Drive12mA(u8 pin) { RegSet(GPIO_PAD(pin), B4|B5); }

// set no pulls (pin = 0..29)
INLINE void GPIO_NoPull(u8 pin) { RegClr(GPIO_PAD(pin), B2|B3); }

// set pull down (default state; pin = 0..29)
INLINE void GPIO_PullDown(u8 pin) { RegMask(GPIO_PAD(pin), B2, B2|B3); }

// set pull up (pin = 0..29)
INLINE void GPIO_PullUp(u8 pin) { RegMask(GPIO_PAD(pin), B3, B2|B3); }

// set bus keep (weak pull up and down; pin = 0..29)
INLINE void GPIO_BusKeep(u8 pin) { RegSet(GPIO_PAD(pin), B2|B3); }

// enable schmitt trigger (use hysteresis on input; default state; pin = 0..29)
INLINE void GPIO_SchmittEnable(u8 pin) { RegSet(GPIO_PAD(pin), B1); }

// disable schmitt trigger (do not use hysteresis on input; pin = 0..29)
INLINE void GPIO_SchmittDisable(u8 pin) { RegClr(GPIO_PAD(pin), B1); }

// use slow slew rate control on output (default state; pin = 0..29)
INLINE void GPIO_Slow(u8 pin) { RegClr(GPIO_PAD(pin), B0); }

// use fast slew rate control on output (pin = 0..29)
INLINE void GPIO_Fast(u8 pin) { RegSet(GPIO_PAD(pin), B0); }

// get input pin (returns 0 or 1; pin = 0..29)
INLINE u8 GPIO_In(u8 pin) { return (u8)((*GPIO_IN >> pin) & 1); }

// get all input pins (bit 0..29 = pin 0..29)
INLINE u32 GPIO_InAll() { return *GPIO_IN; }

// output 0 to pin (pin = 0..29)
INLINE void GPIO_Out0(u8 pin) { *GPIO_OUT_CLR = BIT(pin); }

// output 1 to pin (pin = 0..29)
INLINE void GPIO_Out1(u8 pin) { *GPIO_OUT_SET = BIT(pin); }

// flip output to pin (pin = 0..29)
INLINE void GPIO_Flip(u8 pin) { *GPIO_OUT_XOR = BIT(pin); }

// output value to pin (val = 0 or val != 0; pin = 0..29)
INLINE void GPIO_Out(u8 pin, int val) { if (val == 0) GPIO_Out0(pin); else GPIO_Out1(pin); }

// output masked values to pins
// To use pin mask in range (first..last), use function RangeMask.
INLINE void GPIO_OutMask(u32 mask, u32 value) { *GPIO_OUT_XOR = (*GPIO_OUT ^ value) & mask; }

// clear output pins masked
// To use pin mask in range (first..last), use function RangeMask.
INLINE void GPIO_ClrMask(u32 mask) { *GPIO_OUT_CLR = mask; }

// set output pins masked
// To use pin mask in range (first..last), use function RangeMask.
INLINE void GPIO_SetMask(u32 mask) { *GPIO_OUT_SET = mask; }

// flip output pins masked
// To use pin mask in range (first..last), use function RangeMask.
INLINE void GPIO_FlipMask(u32 mask) { *GPIO_OUT_XOR = mask; }

// get last output value to pin (returns 0 or 1; pin = 0..29)
INLINE u8 GPIO_GetOut(u8 pin) { return (u8)((*GPIO_OUT >> pin) & 1); }

// get all last output values to pins
INLINE u32 GPIO_GetOutAll() { return *GPIO_OUT; }

// set output direction of pin (enable output mode; pin = 0..29)
INLINE void GPIO_DirOut(u8 pin) { *GPIO_OE_SET = BIT(pin); }

// set input direction of pin (disable output mode; pin = 0..29)
INLINE void GPIO_DirIn(u8 pin) { *GPIO_OE_CLR = BIT(pin); }

// set output direction of pin masked
// To use pin mask in range (first..last), use function RangeMask.
INLINE void GPIO_DirOutMask(u32 mask) { *GPIO_OE_SET = mask; }

// set input direction of pin masked
// To use pin mask in range (first..last), use function RangeMask.
INLINE void GPIO_DirInMask(u32 mask) { *GPIO_OE_CLR = mask; }

// get output direction of pin (returns 0=input or 1=output; pin = 0..29)
INLINE u8 GPIO_GetDir(u8 pin) { return (u8)((*GPIO_OE >> pin) & 1); }

// get output direction of all pins (0=input, 1=output)
INLINE u32 GPIO_GetDirAll() { return *GPIO_OE; }

// initialize GPIO pin base function, set input mode, LOW output value (pin = 0..29)
void GPIO_Init(u8 pin);

// initialize GPIO pin base function masked (bit '1' = initialize this pin)
// To use pin mask in range (first..last), use function RangeMask.
void GPIO_InitMask(u32 mask);

// reset GPIO pin (return to reset state)
void GPIO_Reset(u8 pin);

// reset GPIO pins masked (return to reset state)
// To use pin mask in range (first..last), use function RangeMask.
void GPIO_ResetMask(u32 mask);

#ifdef __cplusplus
}
#endif

#endif // _SDK_GPIO_H

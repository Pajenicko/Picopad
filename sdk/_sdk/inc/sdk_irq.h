
// ****************************************************************************
//
//                             IRQ interrupt request
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// NVIC = nested vector interrupt control
// VTOR = vector table offset register

// Each core has its own pointer to vector table VTOR and its own interrupt controller NVIC.
// Almost all functions can only be used for interrupts from the RP2040 devices (IRQ >= 0).
// A few functions can be used to setup Cortex-M0+ core exceptions SVCall, PendSV and SysTick.

#if USE_IRQ	// use IRQ interrupts (sdk_irq.c, sdk_irq.h)

#ifndef _SDK_IRQ_H
#define _SDK_IRQ_H

#include "../sdk_addressmap.h"		// Register address offsets
#include "sdk_cpu.h"

#ifdef __cplusplus
extern "C" {
#endif

// ARM Cortex-M0+ core interrupt request indices - Exceptions
#define IRQ_RESET	-15
#define IRQ_NMI		-14
#define IRQ_HARDFAULT	-13
#define IRQ_SVCALL	-5
#define IRQ_PENDSV	-2
#define IRQ_SYSTICK	-1
// RP2040 device interrupt request indices - Interrupts
#define IRQ_TIMER_0	0
#define IRQ_TIMER_1	1
#define IRQ_TIMER_2	2
#define IRQ_TIMER_3	3
#define IRQ_PWM_WRAP	4
#define IRQ_USBCTRL	5
#define IRQ_XIP		6
#define IRQ_PIO0_0	7
#define IRQ_PIO0_1	8
#define IRQ_PIO1_0	9
#define IRQ_PIO1_1	10
#define IRQ_DMA_0	11
#define IRQ_DMA_1	12
#define IRQ_IO_BANK0	13
#define IRQ_IO_QSPI	14
#define IRQ_SIO_PROC0	15
#define IRQ_SIO_PROC1	16
#define IRQ_CLOCKS	17
#define IRQ_SPI0	18
#define IRQ_SPI1	19
#define IRQ_UART0	20
#define IRQ_UART1	21
#define IRQ_ADC_FIFO	22
#define IRQ_I2C0	23
#define IRQ_I2C1	24
#define IRQ_RTC		25

#define IRQ_NUM		32		// number of IRQs

// symbolic names of interrupt services
//  isr_nmi
//  isr_hardfault
//  isr_svcall
//  isr_pendsv
//  isr_systick
#define isr_timer_0	isr_irq0
#define isr_timer_1	isr_irq1
#define isr_timer_2	isr_irq2
#define isr_timer_3	isr_irq3
#define isr_pwm_wrap	isr_irq4
#define isr_usbctrl	isr_irq5
#define isr_xip		isr_irq6
#define isr_pio0_0	isr_irq7
#define isr_pio0_1	isr_irq8
#define isr_pio1_0	isr_irq9
#define isr_pio1_1	isr_irq10
#define isr_dma_0	isr_irq11
#define isr_dma_1	isr_irq12
#define isr_io_bank0	isr_irq13
#define isr_io_qspi	isr_irq14
#define isr_sio_proc0	isr_irq15
#define isr_sio_proc1	isr_irq16
#define isr_clocks	isr_irq17
#define isr_spi0	isr_irq18
#define isr_spi1	isr_irq19
#define isr_uart0	isr_irq20
#define isr_uart1	isr_irq21
#define isr_adc_fifo	isr_irq22
#define isr_i2c0	isr_irq23
#define isr_i2c1	isr_irq24
#define isr_rtc		isr_irq25
// isr_irq26..isr_irq31

// interrupt hardware priority
#define IRQ_PRIO_REALTIME	0	// highest priority - real-time time-critical interrupts
#define IRQ_PRIO_SYSTICK	1	// high priority - SysTick (must have higher priority than normal interrupts)
#define IRQ_PRIO_NORMAL		2	// default normal priority - normal code, normal interrupts
#define IRQ_PRIO_PENDSV		3	// lowest priority - PendSV handler (must have lowest priority!)

// common interrupt handler definition
// - remember to keep the state of the divider in the interrupt handler in case division is used in the handler
typedef void (*irq_handler_t)();

// === System control block (RP2040 datasheet page 74)
//#define PPB_BASE		0xe0000000	// Cortex-M0+ internal registers (system control block)

// address of interrupt set-enable register
#define NVIC_ISER ((volatile u32*)(PPB_BASE + 0xE100))

// address of interrupt clear-enable register
#define NVIC_ICER ((volatile u32*)(PPB_BASE + 0xE180))

// address of interrupt set-pending register
#define NVIC_ISPR ((volatile u32*)(PPB_BASE + 0xE200))

// address of interrupt clear-pending register
#define NVIC_ICPR ((volatile u32*)(PPB_BASE + 0xE280))

// address of interrupt priority registers, array of 8*u32 (each entry is 8 bits big, but only top 2 bits are used)
#define NVIC_IPR0 ((volatile u32*)(PPB_BASE + 0xE400))

// === System control block of the Cortex M0+ CPU core

// address of Cortex M0+ interrupt control state register (bit 31: 1=NMI pending, bit 28: 1=PendSV pending,
//   bit 27: 1=clear pending PendSV, bit 26: 1=SysTick pending, bit 25: 1=clear pending SysTick)
#define SCB_ICSR ((volatile u32*)(PPB_BASE + 0xED04))

// address of register of Cortex M0+ interrupt vector table VTOR
#define SCB_VTOR ((volatile u32*)(PPB_BASE + 0xED08))

// address of reset control register of Cortex M0+
#define SCB_AIRCR ((volatile u32*)(PPB_BASE + 0xED0C))

// address of system handler priority 2 of Cortex M0+ (bit 30..31 = priority of SVCall)
#define SCB_SHPR2 ((volatile u32*)(PPB_BASE + 0xED1C))

// address of system handler priority 3 of Cortex M0+ (bit 30..31: priority of SysTick, bit 22..23: priority of PendSV)
#define SCB_SHPR3 ((volatile u32*)(PPB_BASE + 0xED20))

// get address of interrupt vector table of this CPU core
INLINE irq_handler_t* GetVTOR() { return (irq_handler_t*)*SCB_VTOR; }

// set address of interrupt vector table of this CPU core
INLINE void SetVTOR(irq_handler_t* addr) { cb(); *SCB_VTOR = (u32)addr; cb(); }

// set interrupt service handler (irq = interrupt request indice IRQ_* -15..+25)
// - vector table must be located in RAM
// - if vector table is not in RAM, use services with names isr_*
// - vector table in this SDK is shared between both CPU cores
// - can be used to set Cortex-M0+ exception handlers (irq < 0)
// - remember to save state of the divider in the interrupt handler
//    for case division is used in the handler
INLINE void SetHandler(s8 irq, irq_handler_t handler) { cb(); GetVTOR()[16 + irq] = handler; dmb(); }

// enable interrupts of NVIC masked of this CPU core
INLINE void NVIC_IRQEnableMask(u32 mask) { cb(); *NVIC_ISER = mask; cb(); }

// enable interrupt of NVIC of this CPU core (irq = 0..25)
INLINE void NVIC_IRQEnable(u8 irq) { cb(); NVIC_IRQEnableMask(BIT(irq)); cb(); }

// disable interrupts of NVIC masked of this CPU core
INLINE void NVIC_IRQDisableMask(u32 mask) { cb(); *NVIC_ICER = mask; dsb(); isb(); }

// disable interrupt of NVIC of this CPU core (irq = 0..25)
INLINE void NVIC_IRQDisable(u8 irq) { NVIC_IRQDisableMask(BIT(irq)); }

// check if interrupt of NVIC of this CPU core is enabled (irq = 0..25)
INLINE Bool NVIC_IRQIsEnabled(u8 irq) { return (*NVIC_ISER & BIT(irq)) != 0; }

// clear pending interrupt of NVIC of this CPU core (irq = 0..25)
INLINE void NVIC_IRQClear(u8 irq) { *NVIC_ICPR = BIT(irq); }

// set pending interrupt of NVIC of this CPU core (force interrupt) (irq = 0..25)
INLINE void NVIC_IRQForce(u8 irq) { *NVIC_ISPR = BIT(irq); }

// check if interrupt of NVIC of this CPU core is pending (irq = 0..25)
INLINE Bool NVIC_IRQIsPending(u8 irq) { return (*NVIC_ISPR & BIT(irq)) != 0; }

// set interrupt priority of NVIC of this CPU core (prio = priority IRQ_PRIO_*) (irq = 0..25)
void NVIC_IRQPrio(u8 irq, u8 prio);

// set all interrupt priorities of NVIC of this CPU core to default value
void NVIC_IRQPrioDef();

// set interrupt priority of SVCall exception -5 of this CPU core (prio = priority IRQ_PRIO_*)
INLINE void NVIC_SVCallPrio(u8 prio)
	{ *SCB_SHPR2 = (*SCB_SHPR2 & ~(B30 | B31)) | ((u32)prio << 30); }

// set interrupt priority of PendSV exception -2 of this CPU core (prio = priority IRQ_PRIO_*)
INLINE void NVIC_PendSVPrio(u8 prio)
	{ *SCB_SHPR3 = (*SCB_SHPR3 & ~(B22 | B23)) | ((u32)prio << 22); }

// raise PendSV exception of this CPU core (reschedule multitak system)
INLINE void NVIC_PendSVForce() { *SCB_ICSR |= B28; }

// check if PendSV exception of this CPU core is pending
INLINE Bool NVIC_PendSVIsPending() { return (*SCB_ICSR & B28) != 0; }

// clear PendSV pending state of this CPU core
INLINE void NVIC_PendSVClear() { *SCB_ICSR |= B27; }

// set interrupt priority of SysTick exception -1 of this CPU core (prio = priority IRQ_PRIO_*)
INLINE void NVIC_SysTickPrio(u8 prio)
	{ *SCB_SHPR3 = (*SCB_SHPR3 & ~(B30 | B31)) | ((u32)prio << 30); }

// raise SysTick exception of this CPU core
INLINE void NVIC_SysTickForce() { *SCB_ICSR |= B26; }

// check if SysTick exception of this CPU core is pending
INLINE Bool NVIC_SysTickIsPending() { return (*SCB_ICSR & B26) != 0; }

// clear SysTick pending state of this CPU core
INLINE void NVIC_SystickClear() { *SCB_ICSR |= B25; }

// raise NMI exception of this CPU core
INLINE void NVIC_NMIForce() { *SCB_ICSR |= B31; }

// system reset (send reset signal)
//void SystemReset();

#ifdef __cplusplus
}
#endif

#endif // _SDK_IRQ_H

#endif // USE_IRQ	// use IRQ interrupts (sdk_irq.c, sdk_irq.h)

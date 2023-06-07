
// ****************************************************************************
//
//                             Reset and power-on
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#ifndef _SDK_RESET_H
#define _SDK_RESET_H

#include "../sdk_addressmap.h"		// Register address offsets

#ifdef __cplusplus
extern "C" {
#endif

// === Power-on state machine (RP2040 datasheet page 191) - use mask of bits BIT(POWER_*)
//#define PSM_BASE		0x40010000	// power-on state machine
#define PSM_ON		((volatile u32*)(PSM_BASE+0)) // force block out of reset (power it on)
#define PSM_OFF		((volatile u32*)(PSM_BASE+4)) // force into reset (power it off)
#define PSM_WDSEL	((volatile u32*)(PSM_BASE+8)) // 1=peripheral should be reset from watchdog
#define PSM_DONE	((volatile u32*)(PSM_BASE+12)) // 1=peripheral's registers are ready to access (read only)

// power-on peripherals
#define POWER_PROC1	16	// processor core 1
#define POWER_PROC0	15	// processor core 0
#define POWER_SIO	14
#define POWER_VREG	13	// VREG and chip reset
#define POWER_XIP	12	// flash memory interface
#define POWER_SRAM5	11
#define POWER_SRAM4	10
#define POWER_SRAM3	9
#define POWER_SRAM2	8
#define POWER_SRAM1	7
#define POWER_SRAM0	6
#define POWER_ROM	5
#define POWER_BUS	4	// bus fabric
#define POWER_RESETS	3
#define POWER_CLOCKS	2
#define POWER_XOSC	1
#define POWER_ROSC	0

// select which peripherals to reset by watchdog (reset everything apart from ROSC and XOSC)
#define PSM_WDSEL_RESETBITS	0x1fffc

// === Reset (RP2040 datasheet page 195) - use mask of bits BIT(RESET_*)
//#define RESETS_BASE		0x4000c000	// subsystem resets
#define RESETS_RESET	((volatile u32*)(RESETS_BASE+0)) // 1=peripheral is in reset
#define RESETS_WDSEL	((volatile u32*)(RESETS_BASE+4)) // 1=watchdog will reset this peripheral
#define RESETS_DONE	((volatile u32*)(RESETS_BASE+8)) // 1=peripheral's registers are ready to access (read only)

// reset peripherals (use BIT(RESET_...) to use in the mask)
#define RESET_USBCTRL	24
#define RESET_UART1	23
#define RESET_UART0	22
#define RESET_TIMER	21
#define RESET_TBMAN	20
#define RESET_SYSINFO	19
#define RESET_SYSCFG	18
#define RESET_SPI1	17
#define RESET_SPI0	16
#define RESET_RTC	15
#define RESET_PWM	14
#define RESET_PLL_USB	13
#define RESET_PLL_SYS	12
#define RESET_PIO1	11
#define RESET_PIO0	10
#define RESET_PADS_QSPI	9
#define RESET_PADS_BANK0 8
#define RESET_JTAG	7
#define RESET_IO_QSPI	6
#define RESET_IO_BANK0	5
#define RESET_I2C1	4
#define RESET_I2C0	3
#define RESET_DMA	2
#define RESET_BUSCTRL	1
#define RESET_ADC	0

#define RESET_ALLBITS	0x01ffffff

// start resetting periphery specified by the mask RESET_*
INLINE void ResetPeripheryOn(u32 mask) { RegSet(RESETS_RESET, mask); }

// stop resetting periphery specified by the mask RESET_*
INLINE void ResetPeripheryOff(u32 mask) { RegClr(RESETS_RESET, mask); }

// check if periphery is ready to be accessed after reset
INLINE Bool ResetPeripheryDone(u32 mask) { return (~*RESETS_DONE & mask) == 0; }

// stop resetting periphery specified by the mask RESET_* and wait
void ResetPeripheryOffWait(u32 mask);

// enable reset periphery by watchdog of mask RESET_*
INLINE void WDPeripheryEnable(u32 mask) { RegSet(RESETS_WDSEL, mask); }

// disable reset periphery by watchdog of mask RESET_*
INLINE void WDPeripheryDisable(u32 mask) { RegClr(RESETS_WDSEL, mask); }

// hard reset periphery (and wait to be accessed again)
//  Takes 0.5 us.
void ResetPeriphery(u32 mask);

#ifdef __cplusplus
}
#endif

#endif // _SDK_RESET_H

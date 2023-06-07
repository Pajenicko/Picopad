
// ****************************************************************************
//
//                         SSI synchronous serial interface
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// SSI (synchronous serial interface) is used to communicate with external Flash
// device using 6 pins: QSPI_SCLK, QSPI_SS, QSPI_SD0..QSP_SD3.

#ifndef _SDK_SSI_H
#define _SDK_SSI_H

#include "../sdk_addressmap.h"		// Register address offsets

#ifdef __cplusplus
extern "C" {
#endif

// === SSI control registers (RP2040 datasheet page 609)

//#define XIP_SSI_BASE		0x18000000	// SSI flash interface
#define SSI_CTRLR0	((volatile u32*)(XIP_SSI_BASE+0))	// control register 0
#define SSI_CTRLR1	((volatile u32*)(XIP_SSI_BASE+4))	// master controlr register 1
#define SSI_SSIENR	((volatile u32*)(XIP_SSI_BASE+8))	// SSI enable
#define SSI_MWCR	((volatile u32*)(XIP_SSI_BASE+0x0C))	// Microwire control
#define SSI_SER		((volatile u32*)(XIP_SSI_BASE+0x10))	// slave enable
#define SSI_BAUDR	((volatile u32*)(XIP_SSI_BASE+0x14))	// baud rate
#define SSI_TXFTLR	((volatile u32*)(XIP_SSI_BASE+0x18))	// TX FIFO threshold level
#define SSI_RXFTLR	((volatile u32*)(XIP_SSI_BASE+0x1C))	// RX FIFO threshold level
#define SSI_TXFLR	((volatile u32*)(XIP_SSI_BASE+0x20))	// TX FIFO level
#define SSI_RXFLR	((volatile u32*)(XIP_SSI_BASE+0x24))	// RX FIFO level
#define SSI_SR		((volatile u32*)(XIP_SSI_BASE+0x28))	// status register
#define SSI_IMR		((volatile u32*)(XIP_SSI_BASE+0x2C))	// interrupt mask
#define SSI_ISR		((volatile u32*)(XIP_SSI_BASE+0x30))	// interrupt status
#define SSI_RISR	((volatile u32*)(XIP_SSI_BASE+0x34))	// raw interrupt status
#define SSI_TXOICR	((volatile u32*)(XIP_SSI_BASE+0x38))	// TX FIFO overflow interrupt clear
#define SSI_RXOICR	((volatile u32*)(XIP_SSI_BASE+0x3C))	// RX FIFO overflow interrupt clear
#define SSI_RXUICR	((volatile u32*)(XIP_SSI_BASE+0x40))	// RX FIFO underflow interrupt clear
#define SSI_MSTICR	((volatile u32*)(XIP_SSI_BASE+0x44))	// multi-master interrupt clear
#define SSI_ICR		((volatile u32*)(XIP_SSI_BASE+0x48))	// interrupt clear
#define SSI_DMACR	((volatile u32*)(XIP_SSI_BASE+0x4C))	// DMA control
#define SSI_DMATDLR	((volatile u32*)(XIP_SSI_BASE+0x50))	// DMA TX data level
#define SSI_DMARDLR	((volatile u32*)(XIP_SSI_BASE+0x54))	// DMA RX data level
#define SSI_IDR		((volatile u32*)(XIP_SSI_BASE+0x58))	// identification register
#define SSI_VERSION_ID	((volatile u32*)(XIP_SSI_BASE+0x5C))	// version ID
#define SSI_DR0		((volatile u32*)(XIP_SSI_BASE+0x60))	// data register 0 (od 36)

#define SSI_RX_SAMP_DLY	((volatile u32*)(XIP_SSI_BASE+0xF0))	// RX sample delay
#define SSI_SPI_CTRLR0	((volatile u32*)(XIP_SSI_BASE+0xF4))	// SPI control
#define SSI_TX_DRV_EDGE	((volatile u32*)(XIP_SSI_BASE+0xF8))	// TX drive edge

// set SSI data frame size to 1..32 bits
INLINE void SSI_SetDataFrameSize(u8 dfs) { RegMask(SSI_CTRLR0, (u32)(dfs-1)<<16, B16|B17|B18|B19|B20); }

// get SSI data frame size (returns 1..32)
INLINE u8 SSI_GetDataFrameSize() { return (u8)(((*SSI_CTRLR0 >> 16) & 0x1f)+1); }

// set frame format
INLINE void SSI_SetFrameFormat(u8 form) { RegMask(SSI_CTRLR0, (u32)form<<4, B4|B5); }

// get frame format
INLINE u8 SSI_GetFrameFormat() { return (u8)((*SSI_CTRLR0 >> 4) & 3); }


#ifdef __cplusplus
}
#endif

#endif // _SDK_SSI_H

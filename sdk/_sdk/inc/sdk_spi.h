
// ****************************************************************************
//
//                            SPI interface
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// (RP2040 datasheet page 515)

#if USE_SPI	// use SPI interface (sdk_spi.c, sdk_spi.h)

#ifndef _SDK_SPI_H
#define _SDK_SPI_H

#include "../sdk_addressmap.h"		// Register address offsets

#ifdef __cplusplus
extern "C" {
#endif

#define SPI_NUM			2		// number of SPI controllers

//#define SPI0_BASE		0x4003c000	// SPI0 interface
//#define SPI1_BASE		0x40040000	// SPI1 interface
#define SPI_BASE(spi) (SPI0_BASE+(spi)*0x4000)		// SPI base address (spi = 0 or 1)

#define SPI_CR0(spi) ((volatile u32*)(SPI_BASE(spi)+0x00))	// control register 0 (spi = 0 or 1)
#define SPI_CR1(spi) ((volatile u32*)(SPI_BASE(spi)+0x04))	// control register 1 (spi = 0 or 1)
#define SPI_DR(spi) ((volatile u32*)(SPI_BASE(spi)+0x08))	// data register (spi = 0 or 1)
#define SPI_SR(spi) ((volatile u32*)(SPI_BASE(spi)+0x0C))	// status register (spi = 0 or 1; read only)
#define SPI_CPSR(spi) ((volatile u32*)(SPI_BASE(spi)+0x10))	// clock prescaler divisor 2..254 (spi = 0 or 1)
#define SPI_IMSC(spi) ((volatile u32*)(SPI_BASE(spi)+0x14))	// interrupt mask
#define SPI_RIS(spi) ((volatile u32*)(SPI_BASE(spi)+0x18))	// raw interrupt status
#define SPI_MIS(spi) ((volatile u32*)(SPI_BASE(spi)+0x1C))	// masked interrupt status
#define SPI_ICR(spi) ((volatile u32*)(SPI_BASE(spi)+0x20))	// clear interrupt status
#define SPI_DMACR(spi) ((volatile u32*)(SPI_BASE(spi)+0x24))	// DMA control register

// frame format
#define SPI_FORMAT_SPI	0	// Motorola SPI
#define SPI_FORMAT_SS	1	// TI synchronous serial
#define SPI_FORMAT_MW	2	// National Microwire

// SPI reset (spi = 0 or 1)
void SPI_Reset(u8 spi);

// SPI initialize to Motorola 8-bit Master mode (polarity 0, phase 0)
void SPI_Init(u8 spi, u32 baudrate);

// SPI terminate
void SPI_Term(u8 spi);

// set SPI baudrate (check real baudrate with SPI_GetBaudrate)
void SPI_Baudrate(u8 spi, u32 baudrate);

// get current SPI baudrate
u32 SPI_GetBaudrate(u8 spi);

// set SPI data size to 4..16 bits (spi = 0 or 1)
INLINE void SPI_DataSize(u8 spi, u8 size) { RegMask(SPI_CR0(spi), (u32)(size-1), 0x0f); }

// set SPI frame format to SPI_FORM_* (spi = 0 or 1)
INLINE void SPI_Format(u8 spi, u8 form) { RegMask(SPI_CR0(spi), (u32)form << 4, B4|B5); }

// set SPI clock polarity to steady state 0=LOW or 1=HIGH (only Motorola SPI frame format; spi = 0 or 1)
INLINE void SPI_Pol(u8 spi, u8 pol) { RegMask(SPI_CR0(spi), (pol << 6), B6); }

// set SPI clock phase to data captured on 0=first or 1=second clock edge (only Motorola SPI frame format; spi = 0 or 1)
INLINE void SPI_Phase(u8 spi, u8 phase) { RegMask(SPI_CR0(spi), (phase << 7), B7); }

// set loop back mode ON (spi = 0 or 1)
INLINE void SPI_LoopBackOn(u8 spi) { RegSet(SPI_CR1(spi), B0); }

// set loop back mode OFF (default state; spi = 0 or 1)
INLINE void SPI_LoopBackOff(u8 spi) { RegClr(SPI_CR1(spi), B0); }

// enable SPI (spi = 0 or 1)
INLINE void SPI_Enable(u8 spi) { RegSet(SPI_CR1(spi), B1); }

// disable SPI (default state; spi = 0 or 1)
INLINE void SPI_Disable(u8 spi) { RegClr(SPI_CR1(spi), B1); }

// set SPI master mode (default state; spi = 0 or 1)
INLINE void SPI_Master(u8 spi) { RegClr(SPI_CR1(spi), B2); }

// set SPI slave mode (spi = 0 or 1)
INLINE void SPI_Slave(u8 spi) { RegSet(SPI_CR1(spi), B2); }

// enable SPI output, if in slave mode (default state; spi = 0 or 1)
INLINE void SPI_OutEnable(u8 spi) { RegClr(SPI_CR1(spi), B3); }

// disable SPI output, if in slave mode (spi = 0 or 1)
INLINE void SPI_OutDisable(u8 spi) { RegSet(SPI_CR1(spi), B3); }

// send data to transmit FIFO (does not check status register; spi = 0 or 1)
INLINE void SPI_Write(u8 spi, u16 data) { *SPI_DR(spi) = data; }

// receive data from receive FIFO (does not check status register; spi = 0 or 1)
INLINE u16 SPI_Read(u8 spi) { return (u16)*SPI_DR(spi); }

// check if transmit FIFO is empty
INLINE Bool SPI_TxIsEmpty(u8 spi) { return (*SPI_SR(spi) & B0) != 0; }

// check if transmit FIFO is full
INLINE Bool SPI_TxIsFull(u8 spi) { return (*SPI_SR(spi) & B1) == 0; }

// check if receive FIFO is empty
INLINE Bool SPI_RxIsEmpty(u8 spi) { return (*SPI_SR(spi) & B2) == 0; }

// check if receive FIFO is full
INLINE Bool SPI_RxIsFull(u8 spi) { return (*SPI_SR(spi) & B3) != 0; }

// flush receive FIFO
INLINE void SPI_RxFlush(u8 spi) { while (!SPI_RxIsEmpty(spi)) SPI_Read(spi); }

// check if SPI is busy (currently transmitting/receiving frame)
INLINE Bool SPI_IsBusy(u8 spi) { return (*SPI_SR(spi) & B4) != 0; }

// enable interrupt on receive overrun
INLINE void SPI_RxOverEnable(u8 spi) { RegSet(SPI_IMSC(spi), B0); }

// disable interrupt on receive overrun
INLINE void SPI_RxOverDisable(u8 spi) { RegClr(SPI_IMSC(spi), B0); }

// clear interrupt on receive overrun status
INLINE void SPI_RxOverClear(u8 spi) { *SPI_ICR(spi) = B0; }

// get raw status of interrupt on receive overrun (0 or 1)
INLINE u8 SPI_GetRxOverRaw(u8 spi) { return (u8)(*SPI_RIS(spi) & 1); }

// get masked status of interrupt on receive overrun (0 or 1)
INLINE u8 SPI_GetRxOver(u8 spi) { return (u8)(*SPI_MIS(spi) & 1); }

// enable interrupt on receive timeout
INLINE void SPI_RxToutEnable(u8 spi) { RegSet(SPI_IMSC(spi), B1); }

// disable interrupt on receive timeout
INLINE void SPI_RxToutDisable(u8 spi) { RegClr(SPI_IMSC(spi), B1); }

// clear interrupt on receive timeout status
INLINE void SPI_RxToutClear(u8 spi) { *SPI_ICR(spi) = B1; }

// get raw status of interrupt on receive timeout (0 or 1)
INLINE u8 SPI_GetRxToutRaw(u8 spi) { return (u8)((*SPI_RIS(spi) >> 1) & 1); }

// get masked status of interrupt on receive timeout (0 or 1)
INLINE u8 SPI_GetRxTout(u8 spi) { return (u8)((*SPI_MIS(spi) >> 1) & 1); }

// enable interrupt on receive half FIFO
INLINE void SPI_RxFifoEnable(u8 spi) { RegSet(SPI_IMSC(spi), B2); }

// disable interrupt on receive half FIFO
INLINE void SPI_RxFifoDisable(u8 spi) { RegClr(SPI_IMSC(spi), B2); }

// get raw status of interrupt on receive half FIFO (0 or 1)
INLINE u8 SPI_GetRxFifoRaw(u8 spi) { return (u8)((*SPI_RIS(spi) >> 2) & 1); }

// get masked status of interrupt on receive half FIFO (0 or 1)
INLINE u8 SPI_GetRxFifo(u8 spi) { return (u8)((*SPI_MIS(spi) >> 2) & 1); }

// enable interrupt on send half FIFO
INLINE void SPI_TxFifoEnable(u8 spi) { RegSet(SPI_IMSC(spi), B3); }

// disable interrupt on send half FIFO
INLINE void SPI_TxFifoDisable(u8 spi) { RegClr(SPI_IMSC(spi), B3); }

// get raw status of interrupt on send half FIFO (0 or 1)
INLINE u8 SPI_GetTxFifoRaw(u8 spi) { return (u8)((*SPI_RIS(spi) >> 3) & 1); }

// get masked status of interrupt on send half FIFO (0 or 1)
INLINE u8 SPI_GetTxFifo(u8 spi) { return (u8)((*SPI_MIS(spi) >> 3) & 1); }

// enable transmit DMA
INLINE void SPI_TxDmaEnable(u8 spi) { RegSet(SPI_DMACR(spi), B1); }

// disable transmit DMA
INLINE void SPI_TxDmaDisable(u8 spi) { RegClr(SPI_DMACR(spi), B1); }

// enable receive DMA
INLINE void SPI_RxDmaEnable(u8 spi) { RegSet(SPI_DMACR(spi), B0); }

// disable receive DMA
INLINE void SPI_RxDmaDisable(u8 spi) { RegClr(SPI_DMACR(spi), B0); }

// send and receive 8-bit data simultaneously
void SPI_Send8Recv(u8 spi, const u8* src, u8* dst, int len);

// send 8-bit data, discard any data received back
void SPI_Send8(u8 spi, const u8* src, int len);

// receive 8-bit data, send repeated byte (usually 0)
void SPI_Recv8(u8 spi, u8 repeated_tx, u8* dst, int len);

// send and receive 16-bit data simultaneously
void SPI_Send16Recv(u8 spi, const u16* src, u16* dst, int len);

// send 16-bit data, discard any data received back
void SPI_Send16(u8 spi, const u16* src, int len);

// receive 16-bit data, send repeated word (usually 0)
void SPI_Recv16(u8 spi, u16 repeated_tx, u16* dst, int len);

#ifdef __cplusplus
}
#endif

#endif // _SDK_SPI_H

#endif // USE_SPI	// use SPI interface (sdk_spi.c, sdk_spi.h)

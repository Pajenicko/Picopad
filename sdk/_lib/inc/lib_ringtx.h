
// ****************************************************************************
//
//                   Ring Buffer with DMA in transmitter mode
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// Usage:
//  - define required resources in the config_def.h file. Spinlock is not required
//    (can be "-1"), if buffer is not used in the second core.
//  - create ring buffer in *.c file using RIBGTX (buffer must be aligned to its
//    size - to optimize space loss during alignment it may be better to allocate
//    buffer in aligned data stack e.g. in "core1" - add attribute with section)
//  - declare ring buffer in *.h file
//  - run RingTxPrep to prepare DMA channel (not needed if you use the RingTxStart
//    function as immediately next)
// You can now proceed in "stream mode", which is a continuous flow of data,
// or "single mode", where only written data is sent.
// 1) To use fast stream mode (continuous transmission):
//  - fill the buffer with some data to be sent first
//  - start DMA stream transfer with function RingTxStart
//  - Repeatedly write more data to the buffer. The buffer must not become empty,
//    the transmit function does not wait for data.
// 2) To use single mode (only written data is sent):
//  - Send data using RingTxWrite* functions.
//  - After sending block of data, call the RingTxSend function to ensure that
//    the remaining data in the buffer is sent (not necessary after RingTxWriteSend).

#if USE_RINGTX	// use Ring buffer with DMA transmitter (lib_ringtx.c, lib_ringtx.h)

#ifndef _RINGTX_H
#define _RINGTX_H

#include "lib_stream.h"

#ifdef __cplusplus
extern "C" {
#endif

// DMA ring buffer
typedef struct {
	u8*		buf;		// pointer to data buffer (address and size must be aligned to '1 << order' bytes)
	u32		size;		// size of buffer in bytes (= 1 << order; max. 32 KB)
	volatile u32	write;		// write offset in the buffer
	volatile u32*	port;		// pointer to periphery data register (data port)
	int		spinlock; 	// index of spinlock (-1 = not used)
	u8		order;		// order of buffer size 1..15 (size = 1 << order)
	u8		dma;		// DMA channel
	u8		dreq;		// DMA channel data request DREQ_*
	u8		entry;		// entry size DMA_SIZE_*
} sRingTx;

// create DMA ring buffer with static buffer (in *.c file)
//   name = name
//   port = pointer to periphery data register (data port)
//   spin = index of spinlock (-1 = not used)
//   order = order of buffer size 1..15 (size = 1 << order; e.g. 8 means buffer of size 256 bytes)
//   dma = DMA channel
//   dreq = DMA channel data request DREQ_*
//   entry = entry size DMA_SIZE_*
// Declare in *.h file: extern sRingTx name;
// Note: Buffers start address must be aligned to '1 << order' bytes (attribute aligned...)
#define RINGTX(name,port,spin,order,dma,dreq,entry) __attribute__((aligned(1<<(order)))) u8 name ## _buf[1<<(order)]; \
	sRingTx name = { name ## _buf, 1<<(order), 0, (port), (spin), (order), (dma), (dreq), (entry) }

// initialize DMA ring buffer (not needed with static ring buffer, created with RINGTX() macro)
//   ring = pointer to DMA ring buffer
//   buf = data buffer (of size '1 << order' bytes; start address must be aligned to '1 << order' bytes)
//   port = pointer to periphery data register (data port)
//   spin = index of spinlock (-1 = not used)
//   order = order of buffer size 1..15 (size = 1 << order; e.g. 8 means buffer of size 256 bytes)
//   dma = DMA channel
//   dreq = DMA channel data request DREQ_*
//   entry = entry size DMA_SIZE_*
void RingTxInit(sRingTx* ring, u8* buf, volatile u32* port, int spin, u8 order, u8 dma, u8 dreq, u8 entry);

// start DMA write transfer in fast stream mode (continuous transmission)
void RingTxStart(sRingTx* ring);

// prepare DMA ring buffer, if created with RINGTX() macro and not with RingTxInit function
//  - must be called before any other function (not needed before RingTxStart function)
void RingTxPrep(sRingTx* ring);

// pause DMA write transfer
void RingTxPause(sRingTx* ring);

// unpause DMA write transfer
void RingTxUnpause(sRingTx* ring);

// stop DMA write transfer 
void RingTxStop(sRingTx* ring);

// send remaining data in the buffer (use in single-run mode, do not use in stream mode)
void RingTxSend(sRingTx* ring);

// get free space for writing
u32 RingTxFree(sRingTx* ring);

// get bytes in buffer
u32 RingTxNum(sRingTx* ring);

// check if ring buffer is ready to write required number of bytes
Bool RingTxReady(sRingTx* ring, u32 len);

// write whole data into ring buffer, without waiting (returns False if buffer has not free space)
// Data is written only if there is enough space in the ring buffer. Cannot write only part of the data.
Bool RingTxWrite(sRingTx* ring, const void* src, u32 len);

// write part of data into ring buffer, without waiting (returns number of written bytes)
Bool RingTxWriteData(sRingTx* ring, const void* src, u32 len);

// write 8-bit data into ring buffer, without waiting (data is lost if buffer is full - returns False on buffer overflow)
Bool RingTxWrite8(sRingTx* ring, u8 data);

// write 16-bit data into ring buffer, without waiting (data is lost if buffer is full - returns False on buffer overflow)
Bool RingTxWrite16(sRingTx* ring, u16 data);

// write 32-bit data into ring buffer, without waiting (data is lost if buffer is full - returns False on buffer overflow)
Bool RingTxWrite32(sRingTx* ring, u32 data);

// write data into ring buffer, wait until ready
void RingTxWriteWait(sRingTx* ring, const void* src, u32 len);

// write 8-bit data into ring buffer, wait until ready
void RingTxWrite8Wait(sRingTx* ring, u8 data);

// write 16-bit data into ring buffer, wait until ready
void RingTxWrite16Wait(sRingTx* ring, u16 data);

// write 32-bit data into ring buffer, wait until ready
void RingTxWrite32Wait(sRingTx* ring, u32 data);

// write data into ring buffer and send remaining data
void RingTxWriteSend(sRingTx* ring, const void* src, u32 len);

// initialize stream to write to ring buffer
void StreamWriteRingTxInit(sStream* str, sRingTx* ring);

// formated print string into ring buffer, with argument list
u32 RingTxPrintArg(sRingTx* ring, const char* fmt, va_list args);

// formated print string into ring buffer, with variadic arguments
NOINLINE u32 RingTxPrint(sRingTx* ring, const char* fmt, ...);

#ifdef __cplusplus
}
#endif

#endif // _RINGTX_H

#endif // USE_RINGTX	// use Ring buffer with DMA transmitter (lib_ringtx.c, lib_ringtx.h)

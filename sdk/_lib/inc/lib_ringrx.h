
// ****************************************************************************
//
//                   Ring Buffer with DMA in receiver mode
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// Usage:
//  - define required resources in the config_def.h file. Spinlock is not required
//    (can be "-1"), if buffer is not used in the second core.
//  - create ring buffer in *.c file using RIBGRX (buffer must be aligned to its
//    size - to optimize space loss during alignment it may be better to allocate
//    buffer in aligned data stack e.g. in "core1" - add attribute with section)
//  - declare ring buffer in *.h file
//  - start DMA transfer with function RingRxStart
//  - extract data from the buffer using functions RingRxRead*. Data must be
//    extracted from the buffer fast enough to prevent buffer overflows.

#if USE_RINGRX		// use Ring buffer with DMA receiver (lib_ringrx.c, lib_ringrx.h)

#ifndef _RINGRX_H
#define _RINGRX_H

#ifdef __cplusplus
extern "C" {
#endif

// DMA ring buffer
typedef struct {
	u8*		buf;		// pointer to data buffer (address and size must be aligned to '1 << order' bytes)
	u32		size;		// size of buffer in bytes (= 1 << order; max. 32 KB)
	volatile u32	read;		// read offset from the buffer
	volatile u32*	port;		// pointer to periphery data register (data port)
	int		spinlock; 	// index of spinlock (-1 = not used)
	u8		order;		// order of buffer size 1..15 (size = 1 << order)
	u8		dma;		// DMA channel
	u8		dreq;		// DMA channel data request DREQ_*
	u8		entry;		// entry size DMA_SIZE_*
} sRingRx;

// create DMA ring buffer with static buffer (in *.c file)
//   name = name
//   port = pointer to periphery data register (data port)
//   spin = index of spinlock (-1 = not used)
//   order = order of buffer size 1..15 (size = 1 << order; e.g. 8 means buffer of size 256 bytes)
//   dma = DMA channel
//   dreq = DMA channel data request DREQ_*
//   entry = entry size DMA_SIZE_*
// Declare in *.h file: extern sRingRx name;
// Note: Buffers start address must be aligned to '1 << order' bytes (attribute aligned...)
#define RINGRX(name,port,spin,order,dma,dreq,entry) __attribute__((aligned(1<<(order)))) u8 name ## _buf[1<<(order)]; \
	sRingRx name = { name ## _buf, 1<<(order), 0, (port), (spin), (order), (dma), (dreq), (entry) }

// initialize DMA ring buffer (not needed with static ring buffer, created with RINGRX() macro)
//   ring = pointer to the ring buffer
//   buf = data buffer (of size '1 << order' bytes; start address must be aligned to '1 << order' bytes)
//   port = pointer to periphery data register (data port)
//   spin = index of spinlock (-1 = not used)
//   order = order of buffer size 1..15 (size = 1 << order; e.g. 8 means buffer of size 256 bytes)
//   dma = DMA channel
//   dreq = DMA channel data request DREQ_*
//   entry = entry size DMA_SIZE_*
void RingRxInit(sRingRx* ring, u8* buf, volatile u32* port, int spin, u8 order, u8 dma, u8 dreq, u8 entry);

// start DMA read transfer (data will be read from the port permanently, without checking for buffer overflow)
void RingRxStart(sRingRx* ring);

//  >>> The RingRxStart function must be started first before using any of the following functions. <<<

// pause DMA read transfer
void RingRxPause(sRingRx* ring);

// unpause DMA read transfer
void RingRxUnpause(sRingRx* ring);

// stop DMA read transfer 
void RingRxStop(sRingRx* ring);

// get free space in buffer
u32 RingRxFree(sRingRx* ring);

// get bytes available for reading
u32 RingRxNum(sRingRx* ring);

// check if ring buffer is ready to read required number of bytes
Bool RingRxReady(sRingRx* ring, u32 len);

// read whole data from ring buffer, without waiting (returns False if buffer has not enough data)
// Data is read only if there is enough data in the ring buffer. Cannot read only part of the data.
Bool RingRxRead(sRingRx* ring, void* dst, u32 len);

// read part of data from ring buffer, without waiting (returns number of read bytes)
u32 RingRxReadData(sRingRx* ring, void* dst, u32 len);

// read 8-bit data from ring buffer, without waiting (returns False if buffer has not enough data)
Bool RingRxRead8(sRingRx* ring, u8* dst);

// read 16-bit data from ring buffer, without waiting (returns False if buffer has not enough data)
Bool RingRxRead16(sRingRx* ring, u16* dst);

// read 32-bit data from ring buffer, without waiting (returns False if buffer has not enough data)
Bool RingRxRead32(sRingRx* ring, u32* dst);

// read data from ring buffer, wait until ready
void RingRxReadWait(sRingRx* ring, void* dst, u32 len);

// read 8-bit data from ring buffer and wait until ready
u8 RingRxRead8Wait(sRingRx* ring);

// read 16-bit data from ring buffer and wait until ready
u16 RingRxRead16Wait(sRingRx* ring);

// read 32-bit data from ring buffer and wait until ready
u32 RingRxRead32Wait(sRingRx* ring);

#ifdef __cplusplus
}
#endif

#endif // _RINGRX_H

#endif // USE_RINGRX		// use Ring buffer with DMA receiver (lib_ringrx.c, lib_ringrx.h)

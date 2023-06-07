
// ****************************************************************************
//
//                               Ring Buffer
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#if USE_RING	// use Ring buffer (lib_ring.c, lib_ring.h)

#ifndef _RING_H
#define _RING_H

#include "../../_sdk/inc/sdk_spinlock.h"	// spinlock
#include "lib_stream.h"

#ifdef __cplusplus
extern "C" {
#endif

struct sRing_;

// wake-up function to force handler to send data
typedef void (*pRingForce)(struct sRing_*);

// ring buffer
typedef struct sRing_ {
	u8*		buf;		// pointer to data buffer
	u32		size;		// size of buffer (number of bytes)
	volatile u32	write;		// write offset into buffer
	volatile u32	read;		// read offset from buffer
	int		spinlock; 	// index of spinlock (-1 = not used)
	pRingForce	force;		// wake-up function to send data (NULL = none)
	u32		cookie;		// user data (uart index)
} sRing;

// create ring buffer with static buffer (in *.c file)
//   name = name
//   len = size in bytes
//   spin = index of spinlock (-1 = not used)
//   force = wake-up function to force handler to send data (NULL = none)
//   cookie = user data (uart index)
// Declare in *.h file: extern sRing name;
#define RING(name,len,spin,force,cookie) u8 name ## _buf[len]; sRing name = \
	{ name ## _buf, (len), 0, 0, (spin), (force), (cookie) }

// initialize ring buffer (not needed with static ring buffer, created with RING() macro)
//   ring = pointer to ring buffer
//   buf = data buffer (of size 'len' bytes)
//   len = buffer size in bytes
//   spin = index of spinlock (-1 = not used)
//   force = wake-up function to force handler to send data (NULL = none)
//   cookie = user data (uart index)
void RingInit(sRing* ring, u8* buf, u32 size, int spinlock, pRingForce force, u32 cookie);

// get free space for writing
u32 RingFree(sRing* ring);

// get bytes available for reading
u32 RingNum(sRing* ring);

// check if ring buffer is ready to write required number of bytes
Bool RingWriteReady(sRing* ring, u32 len);

// check if ring buffer is ready to read required number of bytes
Bool RingReadReady(sRing* ring, u32 len);

// write whole data into ring buffer, without waiting (returns False if buffer has not free space)
// Data is written only if there is enough space in the ring buffer. Cannot write only part of the data.
Bool RingWrite(sRing* ring, const void* src, u32 len);

// write part of data into ring buffer, without waiting (returns number of written bytes)
u32 RingWriteData(sRing* ring, const void* src, u32 len);

// write 8-bit data into ring buffer, without waiting (data is lost if buffer is full - returns False on buffer overflow)
Bool RingWrite8(sRing* ring, u8 data);

// write 16-bit data into ring buffer, without waiting (data is lost if buffer is full - returns False on buffer overflow)
Bool RingWrite16(sRing* ring, u16 data);

// write 32-bit data into ring buffer, without waiting (data is lost if buffer is full - returns False on buffer overflow)
Bool RingWrite32(sRing* ring, u32 data);

// write data into ring buffer, wait until ready
void RingWriteWait(sRing* ring, const void* src, u32 len);

// write 8-bit data into ring buffer, wait until ready
void RingWrite8Wait(sRing* ring, u8 data);

// write 16-bit data into ring buffer, wait until ready
void RingWrite16Wait(sRing* ring, u16 data);

// write 32-bit data into ring buffer, wait until ready
void RingWrite32Wait(sRing* ring, u32 data);

// read whole data from ring buffer, without waiting (return False if buffer has not enough data)
// Data is read only if there is enough data in the ring buffer. Cannot read only part of the data.
Bool RingRead(sRing* ring, void* dst, u32 len);

// read part of data from ring buffer, without waiting (returns number of read bytes)
u32 RingReadData(sRing* ring, void* dst, u32 len);

// read 8-bit data from ring buffer, without waiting (returns False if buffer has not enough data)
Bool RingRead8(sRing* ring, u8* dst);

// read 16-bit data from ring buffer, without waiting (returns False if buffer has not enough data)
Bool RingRead16(sRing* ring, u16* dst);

// read 32-bit data from ring buffer, without waiting (returns False if buffer has not enough data)
Bool RingRead32(sRing* ring, u32* dst);

// read data from ring buffer, wait until ready
void RingReadWait(sRing* ring, void* dst, u32 len);

// read 8-bit data from ring buffer and wait until ready
u8 RingRead8Wait(sRing* ring);

// read 16-bit data from ring buffer and wait until ready
u16 RingRead16Wait(sRing* ring);

// read 32-bit data from ring buffer and wait until ready
u32 RingRead32Wait(sRing* ring);

// initialize stream to write to ring buffer
void StreamWriteRingInit(sStream* str, sRing* ring);

// formated print string into ring buffer, with argument list
u32 RingPrintArg(sRing* ring, const char* fmt, va_list args);

// formated print string into ring buffer, with variadic arguments
NOINLINE u32 RingPrint(sRing* ring, const char* fmt, ...);

#ifdef __cplusplus
}
#endif

#endif // _RING_H

#endif // USE_RING	// use Ring buffer (lib_ring.c, lib_ring.h)

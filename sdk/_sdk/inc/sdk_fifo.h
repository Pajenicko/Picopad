
// ****************************************************************************
//
//                              Inter-core FIFO
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#if USE_FIFO	// use Inter-core FIFO (sdk_fifo.c, sdk_fifo.h)

#ifndef _SDK_FIFO_H
#define _SDK_FIFO_H

#include "../sdk_addressmap.h"		// Register address offsets

#ifdef __cplusplus
extern "C" {
#endif

// === Inter-core FIFO

//#define SIO_BASE		0xd0000000	// SIO registers
//  (SIO does not support aliases for atomic access!)
#define FIFO_STATE	((volatile u32*)(SIO_BASE+0x50)) // inter-core FIFO status
#define FIFO_WRITE	((volatile u32*)(SIO_BASE+0x54)) // inter-core TX FIFO, write access
#define FIFO_READ	((volatile u32*)(SIO_BASE+0x58)) // inter-core RX FIFO, read access

// inter-core FIFO status (register FIFO_STATE)
#define FIFO_ROE	B3	// sticky flag, RX FIFO was read when empty (underflow error; write to clear)
#define FIFO_WOF	B2	// sticky flag, TX FIFO was written when full (overflow error, write to clear)
#define FIFO_RDY	B1	// 1=this core's TX FIFO is not full (ready for write; read only)
#define FIFO_VLD	B0	// 1=this core's RX FIFO is not empty (ready for read; read only)

// check if inter-core RX FIFO is ready to read
INLINE Bool FifoReadReady() { return (*FIFO_STATE & FIFO_VLD) != 0; }

// check if inter-core TX FIFO is ready to write
INLINE Bool FifoWriteReady() { return (*FIFO_STATE & FIFO_RDY) != 0; }

// write message to other core (wait if not ready)
void FifoWrite(u32 data);

// write message to other core with time-out in [us] (wait if not ready, max. 71 minutes, returns False on time-out)
Bool FifoWriteTime(u32 data, u32 us);

// read message from other core (wait if not ready)
u32 FifoRead();

// read message from other core with time-out in [us] (wait if not ready, max. 71 minutes, returns False on time-out)
Bool FifoReadTime(u32* data, u32 us);

// FIFO hanshake - send code and wait for same response
void FifoHandshake(u32 code);

// get FIFO status (FIFO_STATE register)
INLINE u32 FifoState() { return *FIFO_STATE; }

// flush all read messages
INLINE void FifoReadFlush() { while (FifoReadReady()) (void)*FIFO_READ; }

// clear FIFO interrupt request (clear FIFO_ROE and FIFO_WOF error flags)
INLINE void FifoClear() { *FIFO_STATE = 0xff; }

#ifdef __cplusplus
}
#endif

#endif // _SDK_FIFO_H

#endif // USE_FIFO	// use Inter-core FIFO (sdk_fifo.c, sdk_fifo.h)

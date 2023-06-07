
// ****************************************************************************
//
//                              Spinlock
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// 32 spinlocks with index 0..31
// (RP2040 datasheet page 40)

#if USE_SPINLOCK	// use Spinlock (sdk_spinlock.c, sdk_spinlock.h)

#ifndef _SDK_SPINLOCK_H
#define _SDK_SPINLOCK_H

#include "../sdk_addressmap.h"		// Register address offsets
#include "sdk_cpu.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SPINLOCK_NUM	32	// number of spinlocks
//#define SIO_BASE		0xd0000000	// SIO registers
//   (SIO does not support aliases for atomic access!)
#define SPINLOCK_STATE	((volatile u32*)(SIO_BASE+0x5c)) // spinlock states
#define SPINLOCK(lock)	((volatile u32*)(SIO_BASE+(lock)*4+0x100)) // spinlock 0..31

// try to lock spinlock - returns False if not locked (lock = 0..31)
INLINE Bool SpinTryLock(u8 lock)
{
	// reading from spinlock will claim the lock
	Bool res = *SPINLOCK(lock) != 0;
	dmb(); // data memory barrier
	return res;
}

// lock spinlock and wait, if already locked (lock = 0..31)
INLINE void SpinLock(u8 lock)
{
	while (*SPINLOCK(lock) == 0) {}
	dmb(); // data memory barrier
}

// unlock spinlock (default state; lock = 0..31)
INLINE void SpinUnlock(u8 lock)
{
	// writing any value releases the lock
	dmb(); // data memory barrier
	*SPINLOCK(lock) = 0;
}

// check if spinlock is locked (lock = 0..31)
INLINE Bool SpinIsLocked(u8 lock) { return (*SPINLOCK_STATE & BIT(lock)) != 0; }

// initialize spinlock (all spinlocks are at unlocked state after reset; lock = 0..31)
INLINE void SpinInit(u8 lock) { SpinUnlock(lock); }

// reset all spinlocks
void SpinResetAll();

// get state of all spinlocks
INLINE u32 SpinGetAll() { return *SPINLOCK_STATE; }

// lock spinlock and IRQ (to share resources with interrupt)
#define SPINLOCK_LOCK(lock) IRQ_LOCK; if ((lock) >= 0) SpinLock(lock)

// unlock spinlock and IRQ
#define SPINLOCK_UNLOCK(lock) if ((lock) >= 0) SpinUnlock(lock); IRQ_UNLOCK

#ifdef __cplusplus
}
#endif

#endif // _SDK_SPINLOCK_H

#endif // USE_SPINLOCK	// use Spinlock (sdk_spinlock.c, sdk_spinlock.h)

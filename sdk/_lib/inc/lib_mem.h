
// ****************************************************************************
//
//                                Memory allocator
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// used spinlock: #define SYS_SPIN 31 // system spinlock
// start of free RAM for memory allocator: __malloc_start__
// end of free RAM for memory allocator: __malloc_end__

#if USE_MEM	// use Memory Allocator (lib_mem.c, lib_mem.h)

#ifndef _MEM_H
#define _MEM_H

#include "lib_list.h"			// Doubly Linked List

#ifdef __cplusplus
extern "C" {
#endif

// memory chunk header (size 8 bytes + data)
//  Allocable memory region starts with START empty chunk (marked as used,
//  no data) and ends with END empty chunk (marked as used, no data)
typedef struct sMemChunk_
{
	// pointer to previous memory block (NULL=first block)
	struct sMemChunk_* prev;

	// size of this memory chunk (including header, > 0 free, < 0 used block)
	s32 size;

// --- here start data of the block

	// list entry in list of free memory chunks
	// - this entry is rewritten by memory block data
	sListEntry list;

} sMemChunk;

// size of used memory chunk header (must be power of 2; = 8 bytes)
#define MEMHEAD_SIZE (sizeof(sMemChunk) - sizeof(sListEntry))

// maximum size of allocated data block
#define MEMALLOC_MAX (0x7FFFFFFF - 2*MEMHEAD_SIZE)

// memory allocation align (must be power of 2; = 8 bytes)
#define MEMALLOC_ALIGN MEMHEAD_SIZE

// minimal size of allocated data block (= 8 bytes)
#define MEMALLOC_MIN MEMALLOC_ALIGN

// memory align mask
#define MEMALLOC_MASK ~(MEMALLOC_ALIGN-1)

extern u8 __malloc_start__;	// start of memory region - must be aligned to 8 bytes
extern u8 __malloc_end__;	// end of memory region - must be aligned to 8 bytes

// list of free chunks (contains number of free memory blocks)
extern sNumList MemFreeList;

// size of free memory (without headers)
extern u32 MemFreeSize;

// total size of used memory (without headers)
extern u32 MemUsedSize;

// number of used memory blocks (without START and STOP chunk)
extern int MemUsedNum;

// get memory region base address
INLINE void* MemGetBase() { return ((void*)&__malloc_start__); }

// memory region total size (including headers)
INLINE u32 MemGetTotal() { return (u32)((u8*)&__malloc_end__ - (u8*)&__malloc_start__); }

// get total number of blocks (used and free)
INLINE int MemGetTotalNum() { return MemFreeList.num + MemUsedNum; }

// get total size of free memory (without headers)
INLINE u32 MemGetFree() { return MemFreeSize; }

// get number of free RAM blocks
INLINE int MemGetFreeNum() { return MemFreeList.num; }

// get used RAM (in bytes)
INLINE u32 MemGetUsed() { return MemUsedSize; }

// get number of used RAM blocks
INLINE int MemGetUsedNum() { return MemUsedNum; }

// get largest free block (in bytes)
u32 MemGetMax();

// initialize memory allocator
void MemInit();

// allocate memory block (returns NULL on error), block address is aligned to 8 bytes
//  Takes 5 to 20 us
void* MemAlloc(u32 size);

// get size of memory block, without chunk header (returns 0 in case of invalid memory block)
// - can be used to base check block validity
u32 MemSize(void* addr);

// release memory block (addr can be NULL)
//  Takes 1 to 3 us
void MemFree(void* addr);

// resize memory block (returns new block or NULL on error)
//  Takes 2 to 25 us
void* MemResize(void* addr, u32 size);

// Copy memory (returns destination address)
//  - do not use on overlapped memory areas
//void* MemCopy(void* dst, const void* src, u32 size);

// Move memory (can overlap, returns destination address)
void* MemMove(void* dst, const void* src, u32 size);

// Fill memory (returns destination address)
//void* MemSet(void* dst, int val, u32 size);

// Compare memory (returns difference of last character:
// <0 if buf1 < buf2, 0 if buf1 == buf2, >0 if buf1 > buf2)
int MemComp(const void* buf1, const void* buf2, u32 size);

// check memory integrity (returns 0=OK or returns error code)
// 0=OK
// 1=invalid START chunk
// 2=invalid STOP chunk
// 3=invalid chunk Prev pointer
// 4=invalid chunk size
// 5=invalid summary
// 6=invalid free chunks size
// 7=invalid number of free chunks
int MemCheck();

// fast check memory allocator (returns 0 if OK)
int MemFastCheck();

#if USE_RAND		// use Random number generator (lib_rand.c, lib_rand.h)

// initialize long check memory manager
void MemLongCheckInit();

// Long check memory manager (returns 0 if OK)
int MemLongCheck(int loop);

#endif // USE_RAND		// use Random number generator (lib_rand.c, lib_rand.h)

// atomic increment, returns resulting incremented value
u32 SafeInc(volatile u32* num);

// atomic decrement, returns resulting decremented value
u32 SafeDec(volatile u32* num);

// atomic add, returns result of the operation
u32 SafeAdd(volatile u32* num, s32 val);

// atomic sub, returns result of the operation
u32 SafeSub(volatile u32* num, s32 val);

// atomic and, returns result of the operation
u32 SafeAnd(volatile u32* num, u32 val);

// atomic or, returns result of the operation
u32 SafeOr(volatile u32* num, u32 val);

// atomic xor, returns result of the operation
u32 SafeXor(volatile u32* num, u32 val);

// atomic not, returns result of the operation
u32 SafeNot(volatile u32* num);

// atomic exchange, returns old value
u32 SafeExc(volatile u32* num, u32 val);

// atomic compare and exchange, returns old value
//  If 'num' is equal to 'comp', the 'val' is stored to the 'num',
//  otherwise no operation is performed.
u32 SafeCompExc(volatile u32* num, u32 val, u32 comp);

#ifdef __cplusplus
}
#endif

#endif // _MEM_H

#endif // USE_MEM	// use Memory Allocator (lib_mem.c, lib_mem.h)

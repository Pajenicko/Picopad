
// ****************************************************************************
//
//                                Memory allocator
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_MEM	// use Memory Allocator (lib_mem.c, lib_mem.h)

#include "../../_sdk/inc/sdk_spinlock.h"	// spinlock
#include "../../_sdk/inc/sdk_cpu.h"
#include "../../_sdk/inc/sdk_bootrom.h"
#include "../inc/lib_mem.h"
#include "../inc/lib_rand.h"

#if USE_MEMLOCK		// use multicore lock of Memory Allocator (lib_mem.c, lib_mem.h)
#define MEM_LOCK() SPINLOCK_LOCK(SYS_SPIN)
#define MEM_UNLOCK() SPINLOCK_UNLOCK(SYS_SPIN)
#else
#define MEM_LOCK()
#define MEM_UNLOCK()
#endif

// list of free chunks (contains number of free memory blocks)
sNumList MemFreeList;

// total size of free memory (without headers)
u32 MemFreeSize;

// total size of used memory (without headers)
u32 MemUsedSize;

// number of used memory blocks (without START and STOP chunk)
int MemUsedNum;

// get largest free block (in bytes)
u32 MemGetMax()
{
	u32 mx = 0;
	sListEntry* entry;
	sMemChunk* block;

	// lock IRQ and spinlock
	MEM_LOCK();

	// walk through the list of free memory chunks
	NUMLISTFOREACH(entry, MemFreeList)
	{
		// prepare pointer to memory chunk
		//   block ... pointer to memory chunk (of type sMemChunk)
		//   entry ... pointer to list entry (of type sListEntry)
		//   sMemChunk ... type of the "block" result
		//   list ... name of variable in memory chunk
		block = BASEFROMLIST(entry, sMemChunk, list);

		// check large free block
		if (block->size > mx) mx = block->size;
	}

	// unlock spinlock and IRQ
	MEM_UNLOCK();

	return mx;
}

// initialize memory allocator
void MemInit()
{
	// initialize list of free chunks (and number of free blocks)
	NumListInit(&MemFreeList);

	// prepare size counters
	MemFreeSize = MemGetTotal() - 3*MEMHEAD_SIZE; // size of free memory
	MemUsedSize = 0; // size of used memory
	MemUsedNum = 0; // number of used blocks

	// prepare chunk addresses
	u32 size = MemGetTotal() - 2*MEMHEAD_SIZE;; // size of free block including chunk header
	sMemChunk* chunk = (sMemChunk*)MemGetBase(); // pointer to START chunk
	sMemChunk* block = (sMemChunk*)((u32)chunk + MEMHEAD_SIZE); // pointer to free block
	sMemChunk* chunk2 = (sMemChunk*)((u32)block + size); // pointer to END chunk

	// create START chunk
	chunk->prev = NULL; // no previous chunk
	chunk->size = -MEMHEAD_SIZE; // size of this memory chunk, mark it as used block

	// create free chunk
	block->prev = chunk; // previous block is START chunk
	block->size = size; // size of this block, including header
	NumListAddFirst(&MemFreeList, &block->list); // add this block to list of free blocks

	// create STOP chunk
	chunk2->prev = block; // previous block is free chunk
	chunk2->size = -MEMHEAD_SIZE; // size of this memory chunk, mark it as used block
}

// allocate memory block (returns NULL on error), block address is aligned to 8 bytes
void* MemAlloc(u32 size)
{
	// invalid block size or insufficient free memory
	if ((size == 0) || (size > MemFreeSize) || (size > MEMALLOC_MAX)) return NULL;

	// minimum block size
	if (size < MEMALLOC_MIN) size = MEMALLOC_MIN;

	// add size of header and align size UP
	size = ((size + MEMHEAD_SIZE) + MEMALLOC_ALIGN-1) & MEMALLOC_MASK;

	// lock IRQ and spinlock
	MEM_LOCK();

	// walk through list of free chunks and find best one to fit
	sListEntry* entry; // pointer to current memory block (to list entry)
	sListEntry* best = NULL; // found best memory block
	s32 bestsize = MEMALLOC_MAX + 1; // size of best memory block (set to big number at this moment)
	sMemChunk* block; // pointer to checked memory block
	s32 blocksize; // size of checked memory block

	NUMLISTFOREACH(entry, MemFreeList) // walking through the list
	{
		// prepare pointer to memory chunk
		//   block ... pointer to memory chunk (of type sMemChunk)
		//   entry ... pointer to list entry (of type sListEntry)
		//   sMemChunk ... type of the "block" result
		//   list ... name of variable in memory chunk
		block = BASEFROMLIST(entry, sMemChunk, list);
		blocksize = block->size; // size of this memory chunk (including header ... it must be > 0 in free list)

		// check if this block is better (smaller than old best block)
		if ((blocksize >= (s32)size) && (blocksize < bestsize))
		{
			// we will use this block as new "best block"
			best = entry;
			bestsize = blocksize;
			if (blocksize == (s32)size) break; // size is exact, stop searching
		}

	}

	// cannot find such free memory block
	if (best == NULL)
	{
		MEM_UNLOCK();
		return NULL;
	}

	// remove block from list of free chunks
	NumListRemove(&MemFreeList, best);
	MemFreeSize -= bestsize - MEMHEAD_SIZE; // decrease total free memory

	// split block to smaller parts
	sMemChunk* block2; // next free block
	block = BASEFROMLIST(best, sMemChunk, list); // pointer to memory chunk of this free block
	bestsize -= size; // remaining size after this block
	if (bestsize >= (s32)(MEMALLOC_MIN + MEMHEAD_SIZE)) // is it big enough, to hold free memory chunk?
	{
		// create next free chunk
		block2 = (sMemChunk*)((u32)block + size); // next block
		block2->prev = block; // link to previous chunk
		block2->size = bestsize; // size of this new free chunk
		((sMemChunk*)((u32)block2 + bestsize))->prev = block2; // link from following chunk

		// add new chunk to list of free chunks		
		NumListAddLast(&MemFreeList, &block2->list);
		MemFreeSize += bestsize - MEMHEAD_SIZE;
	}

	// block will stay unchanged
	else
	{
		size += bestsize; // return real size of the block
	}

	// mark this block as used
	block->size = -size; // mark block as used

	// increase number of used memory blocks
	MemUsedNum++;
	MemUsedSize += size - MEMHEAD_SIZE;

	// unlock spinlock and IRQ
	MEM_UNLOCK();

	return (void*)best;
}

// get size of memory block, without chunk header (returns 0 in case of invalid memory block)
// - can be used to base check block validity
u32 MemSize(void* addr)
{
	// NULL pointer
	if (addr == NULL) return 0;

	// check address of the region, check address alignment
	if (((u32)addr < (u32)MemGetBase() + 2*MEMHEAD_SIZE) || // address lies before beginning of memory region
		((u32)addr > (u32)MemGetBase() + MemGetTotal() - MEMHEAD_SIZE - MEMALLOC_MIN) || // address lies behind end of memory region
		((((u32)addr - MEMHEAD_SIZE) & (MEMALLOC_ALIGN-1)) != 0)) // check address alignment
		return 0;

	// address of memory chunk
	sMemChunk* block = (sMemChunk*)((u32)addr - MEMHEAD_SIZE);

	// get chunk size
	s32 size = -block->size;
	if ((size < (s32)(MEMHEAD_SIZE + MEMALLOC_MIN)) || // size is too small or it was not negative
		(((sMemChunk*)((u32)block + size))->prev != block)) // invalid pointer from next block to this block
		return 0;

	// return allocated size
	return size - MEMHEAD_SIZE;
}

// release memory block (addr can be NULL)
void MemFree(void* addr)
{
	// ignore NULL pointer
	if (addr == NULL) return;

	// check address of the region, check address alignment
	if (((u32)addr < (u32)MemGetBase() + 2*MEMHEAD_SIZE) || // address lies before beginning of memory region
		((u32)addr > (u32)MemGetBase() + MemGetTotal() - MEMHEAD_SIZE - MEMALLOC_MIN) || // address lies behind end of memory region
		((((u32)addr - MEMHEAD_SIZE) & (MEMALLOC_ALIGN-1)) != 0)) // check address alignment
		return;

	// address of memory chunk
	sMemChunk* block = (sMemChunk*)((u32)addr - MEMHEAD_SIZE);

	// lock IRQ and spinlock
	MEM_LOCK();

	// get chunk size
	s32 size = -block->size;
	if ((size < (s32)(MEMHEAD_SIZE + MEMALLOC_MIN)) || // size is too small or it was not negative
		(((sMemChunk*)((u32)block + size))->prev != block)) // invalid pointer from next block to this block
	{
		MEM_UNLOCK();
		return;
	}

	// mark chunk as free
	block->size = size;

	// decrease number of used memory blocks
	MemUsedNum--;
	MemUsedSize -= size - MEMHEAD_SIZE;

	// link with previous free chunk
	sMemChunk* block2 = block->prev; // pointer to previous chunk
	if (block2->size > 0) // is it free chunk?
	{
		// previous chunk is free chunk, link with it
		MemFreeSize += size; // add to free size (including header, we will reduce it)
		block2->size += size; // increase size of previous block
		((sMemChunk*)((u32)block + size))->prev = block2; // update link from next block to previous block
		block = block2; // previous block will be "current" block
		size = block2->size; // get size of new "current" block
	}
	else
	{
		// previous chunk is not free chunk, only add this chunk to list of free chunks
		NumListAddLast(&MemFreeList, &block->list); // add to list of free chunks
		MemFreeSize += size - MEMHEAD_SIZE; // add to free size (without header)
	}

	// link with next chunk
	block2 = (sMemChunk*)((u32)block + size); // pointer to next chunk
	s32 size2 = block2->size; // size of next chunk
	if (size2 > 0) // is it free chunk?
	{
		NumListRemove(&MemFreeList, &block2->list); // remove next chunk from list of free chunks
		MemFreeSize += MEMHEAD_SIZE; // add header to free size
		size += size2; // increase size of current block
		block->size = size; // update size of the block
		((sMemChunk*)((u32)block + size))->prev = block; // update link from next block to this block
	}

	// unlock spinlock and IRQ
	MEM_UNLOCK();
}

// resize memory block (returns new block or NULL on error)
void* MemResize(void* addr, u32 size)
{
	// release memory block
	if (size == 0)
	{
		MemFree(addr);
		return NULL;
	}

	// create new block
	if (addr == NULL) return MemAlloc(size);

	// invalid block size or insufficient free memory
	if ((size > MemFreeSize) || (size > MEMALLOC_MAX)) return NULL;

	// check address of the region, check address alignment
	if (((u32)addr < (u32)MemGetBase() + 2*MEMHEAD_SIZE) || // address lies before beginning of memory region
		((u32)addr > (u32)MemGetBase() + MemGetTotal() - MEMHEAD_SIZE - MEMALLOC_MIN) || // address lies behind end of memory region
		((((u32)addr - MEMHEAD_SIZE) & (MEMALLOC_ALIGN-1)) != 0)) // check address alignment
		return NULL;

	// minimum block size
	u32 size0 = size;
	if (size < MEMALLOC_MIN) size = MEMALLOC_MIN;

	// add size of header and align size UP
	size = ((size + MEMHEAD_SIZE) + MEMALLOC_ALIGN-1) & MEMALLOC_MASK;

	// address of memory chunk
	sMemChunk* block = (sMemChunk*)((u32)addr - MEMHEAD_SIZE);

	// lock IRQ and spinlock
	MEM_LOCK();

	// get chunk old size
	s32 oldsize = -block->size;
	sMemChunk* block2 = (sMemChunk*)((u32)block + oldsize); // next chunk
	if ((oldsize < (s32)(MEMHEAD_SIZE + MEMALLOC_MIN)) || // size is too small or it was not negative
		(block2->prev != block)) // invalid pointer from next block to this block
	{
		MEM_UNLOCK(); // unlock
		return NULL;
	}

	// block does not need to be changed
	if (size == oldsize)
	{
		MEM_UNLOCK(); // unlock
		return addr;
	}

	// increase block size
	if ((s32)size > oldsize)
	{
		// increase block size in place - join with next free block
		s32 n = block2->size; // get size of next block
		if ((n > (s32)MEMHEAD_SIZE) && (oldsize + n >= (s32)size)) // it must be free block and it must fit
		{
			NumListRemove(&MemFreeList, &block2->list); // remove next free block from the list of free blocks
			MemFreeSize -= n - MEMHEAD_SIZE; // decrease free memory
			MemUsedSize += n; // increase used memory
			oldsize += n; // increase old size
			block->size = -oldsize; // set new size of the block (mark it as used)
			((sMemChunk*)((u32)block + oldsize))->prev = block; // update link from next block to this block

			// size is OK
			if (size == oldsize)
			{
				MEM_UNLOCK(); // unlock
				return addr;
			}
		}
		else
		{
			MEM_UNLOCK(); // unlock

			// reallocate using new block
			oldsize -= MEMHEAD_SIZE; // old size without header
			void* addr2 = MemAlloc(size0); // allocate new memory block
			if (addr2 == NULL) return NULL; // memory error
			memcpy(addr2, addr, oldsize); // copy data to new memory block
			MemFree(addr); // release old memory block
			return addr2;
		}
	}

	// size < oldsize, block will be decreased (by "oldsize")
	oldsize -= size;

	// block cannot be decreased (new block would be too small)
	if (oldsize < (s32)(MEMALLOC_MIN + MEMHEAD_SIZE))
	{
		MEM_UNLOCK(); // unlock
		return addr;
	}

	// set new size of the block
	block->size = -size;

	// create next free chunk
	block2 = (sMemChunk*)((u32)block + size); // next block
	block2->prev = block; // link to previous chunk
	block2->size = oldsize; // size of this new free chunk

	// add new chunk to list of free chunks
	NumListAddLast(&MemFreeList, &block2->list);
	MemFreeSize += oldsize - MEMHEAD_SIZE; // increase free memory
	MemUsedSize -= oldsize; // decrease used memory

	// link new free chunk with next free chunk
	sMemChunk* block3 = (sMemChunk*)((u32)block2 + oldsize); // next-next chunk
	block3->prev = block2; // link from following chunk
	s32 size3 = block3->size; // size of next-next chunk
	if (size3 > 0) // is that chunk free?
	{
		NumListRemove(&MemFreeList, &block3->list);
		MemFreeSize += MEMHEAD_SIZE; // increase free memory
		oldsize += size3; // new size of connected free block
		block2->size = oldsize; // set size of connected free block
		((sMemChunk*)((u32)block2 + oldsize))->prev = block2; // link from next block to the free block
	}

	MEM_UNLOCK(); // unlock
	return addr;
}

/*
// Copy memory (returns destination address)
void* MemCopy(void* dst, const void* src, u32 size)
{
	u8* d = (u8*)dst;
	const u8* s = (const u8*)src;
	while (size--) *d++ = *s++;
	return dst;
}
*/

// Move memory (can overlap, returns destination address)
void* MemMove(void* dst, const void* src, u32 size)
{		 
	u8* d = (u8*)dst;
	const u8* s = (const u8*)src;
	if (((u32)d <= (u32)s) || ((u32)d >= (u32)s + size))
	{
		// Do not use MemCopy - it does not support overlapped memory areas
		while (size--) *d++ = *s++;
	}
	else
	{
		d += size;
		s += size;
		while (size--) *--d = *--s;
	}
	return dst;
}

/*
// Fill memory (returns destination address)
void* MemSet(void* dst, int val, u32 size)
{
	u8* d = (u8*)dst;
	while (size--) *d++ = (u8)val;
	return dst;
}
*/

// Compare memory (returns difference of last character:
// <0 if buf1 < buf2, 0 if buf1 == buf2, >0 if buf1 > buf2)
int MemComp(const void* buf1, const void* buf2, u32 size)
{
	const u8* s = (const u8*)buf1;
	const u8* d = (const u8*)buf2;

	while (size--)
	{
		if (*s != *d) return *s - *d;
		s++;
		d++;
	}
	return 0;
}

// check memory integrity (returns 0=OK or returns error code)
// 0=OK
// 1=invalid START chunk
// 2=invalid STOP chunk
// 3=invalid chunk Prev pointer
// 4=invalid chunk size
// 5=invalid summary
// 6=invalid free chunks size
// 7=invalid number of free chunks
int MemCheck()
{
	// check START chunk
	sMemChunk* block = (sMemChunk*)MemGetBase();
	if ((block->size != -MEMHEAD_SIZE) || (block->prev != NULL)) return 1;

	// check STOP chunk
	sMemChunk* block2 = (sMemChunk*)((u32)MemGetBase() + MemGetTotal() - MEMHEAD_SIZE);
	if (block->size != -MEMHEAD_SIZE) return 2;

	// lock IRQ and spinlock
	MEM_LOCK();

	// check memory chunks
	int freenum = 0;
	u32 freesize = 0;
	int usednum = 0;
	u32 usedsize = 0;
	sMemChunk* b = (sMemChunk*)((u32)block + MEMHEAD_SIZE);
	s32 s;
	while ((u32)b < (u32)block2)
	{
		// check previous pointer
		if (b->prev != block)
		{
			MEM_UNLOCK(); // unlock
			return 3;
		}

		// block size
		s = b->size;
		if (s < 0)
		{
			// used block
			s = -s;
			usednum++;
			usedsize += s - MEMHEAD_SIZE;
		}
		else
		{
			// free block
			freenum++;
			freesize += s - MEMHEAD_SIZE;
		}

		// check size
		if ((s < (s32)(MEMHEAD_SIZE + MEMALLOC_MIN)) || ((u32)s >= MemGetTotal()) ||
			((u32)b + (u32)s >= ((u32)MemGetBase() + MemGetTotal())))
		{
			MEM_UNLOCK(); // unlock
			return 4;
		}

		// next block
		block = b;
		b = (sMemChunk*)((u32)b + s);
	}

	// check summary
	if ((freenum != MemGetFreeNum()) ||
		(freesize != MemGetFree()) ||
		(usedsize != MemGetUsed()) ||
		(usednum != MemGetUsedNum()))
	{
		MEM_UNLOCK(); // unlock
		return 5;
	}

	// check free chunks
	freesize = 0;
	int i = MemGetFreeNum();
	block = BASEFROMLIST(NumListGetFirst(&MemFreeList), sMemChunk, list);
	while ((&block->list != NumListGetHead(&MemFreeList)) && (i > 0))
	{
		// check block size
		s = block->size;
		if((s < (s32)(MEMHEAD_SIZE + MEMALLOC_MIN)) || ((u32)s >= MemGetTotal()) ||
			((sMemChunk*)((u32)block + s))->prev != block)
		{
			MEM_UNLOCK(); // unlock
			return 6;
		}

		// next free block
		block = BASEFROMLIST(block->list.next, sMemChunk, list);
		i--;
	}

	// invalid number of blocks
	if ((&block->list != NumListGetHead(&MemFreeList)) || (i != 0))
	{
		MEM_UNLOCK(); // unlock
		return 7;
	}

	MEM_UNLOCK(); // unlock
	return 0;
}

// fast check memory allocator (returns 0 if OK)
int MemFastCheck()
{
	int i;
	void *a, *b;

	// check memory integrity
	i = MemCheck();
	if (i != 0) return i;

	// allocate 1/2 of largest free block
	a = MemAlloc(MemGetMax() / 2);
	if (a == NULL) return 10;

	// check memory integrity
	i = MemCheck();
	if (i != 0) return i;

	// allocate 1/2 of largest free block
	b = MemAlloc(MemGetMax() / 2);
	if (a == NULL) return 11;

	// check memory integrity
	i = MemCheck();
	if (i != 0) return i;

	// free 1st block
	MemFree(a);

	// check memory integrity
	i = MemCheck();
	if (i != 0) return i;
	
	// free 2nd block
	MemFree(b);

	// check memory integrity
	return MemCheck();
}

#if USE_RAND		// use Random number generator (lib_rand.c, lib_rand.h)

#define MEMCHECK_NUM 400
void* MemCheckBuf[2*MEMCHECK_NUM]; // buffer of allocated blocks

// initialize long check memory manager
void MemLongCheckInit()
{
	int i;
	for (i = 0; i < 2*MEMCHECK_NUM; i++) MemCheckBuf[i] = NULL;
}

// Long check memory manager (returns 0 if OK)
int MemLongCheck(int loop)
{
	int n = 0;
	int i;
	void* a;
	u32 s;
	int level = 100;

	void** mem = &MemCheckBuf[CpuID()*MEMCHECK_NUM];

	for (; loop > 0; loop--)
	{
		// check memory
		i = MemCheck();
		if (i != 0) return i;

		// random operation
		i = RandU32Max(MEMCHECK_NUM-1);

		// shift block level (small block ... big block)
		level += RandS8MinMax(-1, +1);
		if (level < 2) level = 2;
		if (level > 999) level = 999;

		// create new block
		if (mem[i] == NULL)
		{
			s = MemGetFree()/level;
			mem[i] = MemAlloc(RandU32Max(s));
		}
		else
		{
			// free block
			if ((RandU32() & 3) != 0)
			{
				MemFree(mem[i]);
				mem[i] = NULL;
			}

			// reallocate
			else
			{
				s = MemGetFree()/level;
				s = RandU32Max(s + MemSize(mem[i]));
				a = MemResize(mem[i], s);
				if ((a != NULL) || (s == 0)) mem[i] = a;
			}
		}

		n++;
	}

	return 0;
}

#endif // USE_RAND		// use Random number generator (lib_rand.c, lib_rand.h)

// atomic increment, returns resulting incremented value
u32 SafeInc(volatile u32* num)
{
	u32 res;
	MEM_LOCK();
	res = *num + 1;
	*num = res;
	MEM_UNLOCK();
	return res;
}

// atomic decrement, returns resulting decremented value
u32 SafeDec(volatile u32* num)
{
	u32 res;
	MEM_LOCK();
	res = *num - 1;
	*num = res;
	MEM_UNLOCK();
	return res;
}

// atomic add, returns result of the operation
u32 SafeAdd(volatile u32* num, s32 val)
{
	u32 res;
	MEM_LOCK();
	res = *num + val;
	*num = res;
	MEM_UNLOCK();
	return res;
}

// atomic sub, returns result of the operation
u32 SafeSub(volatile u32* num, s32 val)
{
	u32 res;
	MEM_LOCK();
	res = *num - val;
	*num = res;
	MEM_UNLOCK();
	return res;
}

// atomic and, returns result of the operation
u32 SafeAnd(volatile u32* num, u32 val)
{
	u32 res;
	MEM_LOCK();
	res = *num & val;
	*num = res;
	MEM_UNLOCK();
	return res;
}

// atomic or, returns result of the operation
u32 SafeOr(volatile u32* num, u32 val)
{
	u32 res;
	MEM_LOCK();
	res = *num | val;
	*num = res;
	MEM_UNLOCK();
	return res;
}

// atomic xor, returns result of the operation
u32 SafeXor(volatile u32* num, u32 val)
{
	u32 res;
	MEM_LOCK();
	res = *num ^ val;
	*num = res;
	MEM_UNLOCK();
	return res;
}

// atomic not, returns result of the operation
u32 SafeNot(volatile u32* num)
{
	u32 res;
	MEM_LOCK();
	res = ~*num;
	*num = res;
	MEM_UNLOCK();
	return res;
}

// atomic exchange, returns old value
u32 SafeExc(volatile u32* num, u32 val)
{
	u32 res;
	MEM_LOCK();
	res = *num;
	*num = val;
	MEM_UNLOCK();
	return res;
}

// atomic compare and exchange, returns old value
//  If 'num' is equal to 'comp', the 'val' is stored to the 'num',
//  otherwise no operation is performed.
u32 SafeCompExc(volatile u32* num, u32 val, u32 comp)
{
	u32 res;
	MEM_LOCK();
	res = *num;
	if (res == comp) *num = val;
	MEM_UNLOCK();
	return res;
}

#endif // USE_MEM	// use Memory Allocator (lib_mem.c, lib_mem.h)

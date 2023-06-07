
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// get number of leading zeros of u32 number
u8 clz(u32 num);

// count trailing zeros
u8 ctz(u32 val);

// get number of leading zeros of u64 number
u8 clz64(u64 num);

// Divide modulo unsigned U32
u32 DivModU32(u32 a, u32 b, u32* rem);

// Unsigned multiply u32*u32 with result u64
u64 UMul(u32 a, u32 b);

extern const char* ChebProgTab;

// Chebyshev progress
void ChebProg(int permille);

// memory allocator
INLINE void* MemAlloc(u32 size) { return malloc(size); }
INLINE void MemFree(void* mem) { free(mem); }
INLINE void* MemResize(void* addr, u32 size) { return realloc(addr, size); }

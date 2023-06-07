
// ****************************************************************************
//
//                               Data stream
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_STREAM	// use Data stream (lib_stream.c, lib_stream.h)

#include "../../_sdk/inc/sdk_bootrom.h"
#include "../inc/lib_stream.h"
#include "../inc/lib_mem.h"

// callback - nul write stream function
u32 StreamWrite0(sStream* str, const void* buf, u32 num)
{
	return num;
}

// callback - nul read stream function
u32 StreamRead0(sStream* str, void* buf, u32 num)
{
	return 0;
}

// initialize nul stream (used to get number of characters)
void Stream0Init(sStream* str)
{
	str->pos = 0;
	str->size = 0;
	str->cookie = 0;
	str->open = NULL;
	str->close = NULL;
	str->write = StreamWrite0;
	str->read = StreamRead0;
}

// callback - write data to memory buffer
u32 StreamWriteBuf(sStream* str, const void* buf, u32 num)
{
	// get current position and buffer size
	u32 pos = str->pos;
	u32 size = str->size;

	// limit write position
	if (pos > size) pos = size;

	// limit number of bytes
	if ((pos + num > size) || (pos + num < pos)) num = size - pos;

	// shift position
	str->pos = pos + num;

	// transfer data
	u8* d = (u8*)str->cookie;
	if ((num > 0) && (d != NULL)) memcpy(&d[pos], buf, num);

	return num;
}

// callback - read data from memory buffer
u32 StreamReadBuf(sStream* str, void* buf, u32 num)
{
	// get current position and buffer size
	u32 pos = str->pos;
	u32 size = str->size;

	// limit read position
	if (pos > size) pos = size;

	// limit number of bytes
	if ((pos + num > size) || (pos + num < pos)) num = size - pos;

	// shift position
	str->pos = pos + num;

	// transfer data
	const u8* d = (const u8*)str->cookie;
	if (num > 0) memcpy(buf, &d[pos], num);

	return num;
}

// initialize stream to read from memory buffer
void StreamReadBufInit(sStream* str, const void* buf, u32 num)
{
	Stream0Init(str);
	str->size = num;
	str->cookie = (u32)buf;
	str->read = StreamReadBuf;
}

// initialize stream to write to memory buffer
void StreamWriteBufInit(sStream* str, void* buf, u32 num)
{
	Stream0Init(str);
	str->size = num;
	str->cookie = (u32)buf;
	str->write = StreamWriteBuf;
}

#endif // USE_STREAM	// use Data stream (lib_stream.c, lib_stream.h)

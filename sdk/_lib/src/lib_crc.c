
// ****************************************************************************
//
//                                CRC Check Sum
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_CRC	// use CRC Check Sum (lib_crc.c, lib_crc.h)

#include "../../_sdk/inc/sdk_dma.h"	// DMA
#include "../../_sdk/inc/sdk_cpu.h"
#include "../../_sdk/inc/sdk_bootrom.h"
#include "../inc/lib_crc.h"

// check patterns
const char ALIGNED CrcPat1[] = "123456789";
const u8 ALIGNED CrcPat2[CRCPAT2LEN+1] = { 0xFC, 0x05, 0x4A, 0x3E };

// ============================================================================
//                           CRC-32 Normal (CRC32A)
// ============================================================================

// CRC-32 Normal (CRC32A) table (1 KB)
const u32 Crc32ATable[256] = {
	0x00000000, 0x04c11db7, 0x09823b6e, 0x0d4326d9, 0x130476dc, 0x17c56b6b, 0x1a864db2, 0x1e475005,
	0x2608edb8, 0x22c9f00f, 0x2f8ad6d6, 0x2b4bcb61, 0x350c9b64, 0x31cd86d3, 0x3c8ea00a, 0x384fbdbd,
	0x4c11db70, 0x48d0c6c7, 0x4593e01e, 0x4152fda9, 0x5f15adac, 0x5bd4b01b, 0x569796c2, 0x52568b75,
	0x6a1936c8, 0x6ed82b7f, 0x639b0da6, 0x675a1011, 0x791d4014, 0x7ddc5da3, 0x709f7b7a, 0x745e66cd,
	0x9823b6e0, 0x9ce2ab57, 0x91a18d8e, 0x95609039, 0x8b27c03c, 0x8fe6dd8b, 0x82a5fb52, 0x8664e6e5,
	0xbe2b5b58, 0xbaea46ef, 0xb7a96036, 0xb3687d81, 0xad2f2d84, 0xa9ee3033, 0xa4ad16ea, 0xa06c0b5d,
	0xd4326d90, 0xd0f37027, 0xddb056fe, 0xd9714b49, 0xc7361b4c, 0xc3f706fb, 0xceb42022, 0xca753d95,
	0xf23a8028, 0xf6fb9d9f, 0xfbb8bb46, 0xff79a6f1, 0xe13ef6f4, 0xe5ffeb43, 0xe8bccd9a, 0xec7dd02d,
	0x34867077, 0x30476dc0, 0x3d044b19, 0x39c556ae, 0x278206ab, 0x23431b1c, 0x2e003dc5, 0x2ac12072,
	0x128e9dcf, 0x164f8078, 0x1b0ca6a1, 0x1fcdbb16, 0x018aeb13, 0x054bf6a4, 0x0808d07d, 0x0cc9cdca,
	0x7897ab07, 0x7c56b6b0, 0x71159069, 0x75d48dde, 0x6b93dddb, 0x6f52c06c, 0x6211e6b5, 0x66d0fb02,
	0x5e9f46bf, 0x5a5e5b08, 0x571d7dd1, 0x53dc6066, 0x4d9b3063, 0x495a2dd4, 0x44190b0d, 0x40d816ba,
	0xaca5c697, 0xa864db20, 0xa527fdf9, 0xa1e6e04e, 0xbfa1b04b, 0xbb60adfc, 0xb6238b25, 0xb2e29692,
	0x8aad2b2f, 0x8e6c3698, 0x832f1041, 0x87ee0df6, 0x99a95df3, 0x9d684044, 0x902b669d, 0x94ea7b2a,
	0xe0b41de7, 0xe4750050, 0xe9362689, 0xedf73b3e, 0xf3b06b3b, 0xf771768c, 0xfa325055, 0xfef34de2,
	0xc6bcf05f, 0xc27dede8, 0xcf3ecb31, 0xcbffd686, 0xd5b88683, 0xd1799b34, 0xdc3abded, 0xd8fba05a,

	0x690ce0ee, 0x6dcdfd59, 0x608edb80, 0x644fc637, 0x7a089632, 0x7ec98b85, 0x738aad5c, 0x774bb0eb,
	0x4f040d56, 0x4bc510e1, 0x46863638, 0x42472b8f, 0x5c007b8a, 0x58c1663d, 0x558240e4, 0x51435d53,
	0x251d3b9e, 0x21dc2629, 0x2c9f00f0, 0x285e1d47, 0x36194d42, 0x32d850f5, 0x3f9b762c, 0x3b5a6b9b,
	0x0315d626, 0x07d4cb91, 0x0a97ed48, 0x0e56f0ff, 0x1011a0fa, 0x14d0bd4d, 0x19939b94, 0x1d528623,
	0xf12f560e, 0xf5ee4bb9, 0xf8ad6d60, 0xfc6c70d7, 0xe22b20d2, 0xe6ea3d65, 0xeba91bbc, 0xef68060b,
	0xd727bbb6, 0xd3e6a601, 0xdea580d8, 0xda649d6f, 0xc423cd6a, 0xc0e2d0dd, 0xcda1f604, 0xc960ebb3,
	0xbd3e8d7e, 0xb9ff90c9, 0xb4bcb610, 0xb07daba7, 0xae3afba2, 0xaafbe615, 0xa7b8c0cc, 0xa379dd7b,
	0x9b3660c6, 0x9ff77d71, 0x92b45ba8, 0x9675461f, 0x8832161a, 0x8cf30bad, 0x81b02d74, 0x857130c3,
	0x5d8a9099, 0x594b8d2e, 0x5408abf7, 0x50c9b640, 0x4e8ee645, 0x4a4ffbf2, 0x470cdd2b, 0x43cdc09c,
	0x7b827d21, 0x7f436096, 0x7200464f, 0x76c15bf8, 0x68860bfd, 0x6c47164a, 0x61043093, 0x65c52d24,
	0x119b4be9, 0x155a565e, 0x18197087, 0x1cd86d30, 0x029f3d35, 0x065e2082, 0x0b1d065b, 0x0fdc1bec,
	0x3793a651, 0x3352bbe6, 0x3e119d3f, 0x3ad08088, 0x2497d08d, 0x2056cd3a, 0x2d15ebe3, 0x29d4f654,
	0xc5a92679, 0xc1683bce, 0xcc2b1d17, 0xc8ea00a0, 0xd6ad50a5, 0xd26c4d12, 0xdf2f6bcb, 0xdbee767c,
	0xe3a1cbc1, 0xe760d676, 0xea23f0af, 0xeee2ed18, 0xf0a5bd1d, 0xf464a0aa, 0xf9278673, 0xfde69bc4,
	0x89b8fd09, 0x8d79e0be, 0x803ac667, 0x84fbdbd0, 0x9abc8bd5, 0x9e7d9662, 0x933eb0bb, 0x97ffad0c,
	0xafb010b1, 0xab710d06, 0xa6322bdf, 0xa2f33668, 0xbcb4666d, 0xb8757bda, 0xb5365d03, 0xb1f740b4,
};

// Check CRC-32 Normal (CRC32A) table (returns False on error; can be used to generate table)
Bool Crc32ATableCheck()
{
	int i, j;
	u32 k;

	for(i = 0; i < 256; i++)
	{
		k = (u32)i << 24;
		for (j = 8; j > 0; j--)
		{
			if ((k & 0x80000000) == 0)
				k <<= 1;
			else
				k = (k << 1) ^ CRC32A_POLY;
		}
		//Crc32ATable[i] = k; // generate table
		if (Crc32ATable[i] != k) return False; // check table
	}
	return True;
}

// Calculate CRC-32 Normal (CRC32A), 1 byte - tabled version (requires 1 KB of flash memory)
u32 Crc32AByteTab(u32 crc, u8 data)
{
	return Crc32ATable[(crc >> 24) ^ data] ^ (crc << 8);
}

// Calculate CRC-32 Normal (CRC32A), 1 byte - slow version
u32 Crc32AByteSlow(u32 crc, u8 data)
{
	int i;
	crc ^= (u32)data << 24;
	for (i = 8; i > 0; i--)
	{
		if ((crc & 0x80000000) == 0)
			crc <<= 1;
		else
			crc = (crc << 1) ^ CRC32A_POLY;
	}
	return crc;
}

// Calculate CRC-32 Normal (CRC32A), 1 byte - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u32 Crc32AByteDMA(u32 crc, u8 data)
{
	return DMA_CRC(DMA_CRC_CRC32, crc, DMA_TEMP_CHAN(), &data, 1);
}

// Calculate CRC-32 Normal (CRC32A), buffer - tabled version (requires 1 KB of flash memory)
u32 Crc32ABufTab(u32 crc, const void* buf, int len)
{
	const u8* s = (const u8*)buf;

	for (; len > 0; len--)
	{
		// Normal formula
		crc = Crc32ATable[(crc >> 24) ^ *s++] ^ (crc << 8);
	}
	return crc;
}

// Calculate CRC-32 Normal (CRC32A), buffer - slow version
u32 Crc32ABufSlow(u32 crc, const void* buf, int len)
{
	const u8* s = (const u8*)buf;
	int i;

	for (; len > 0; len--)
	{
		crc ^= (u32)*s++ << 24;
		for (i = 8; i > 0; i--)
		{
			if ((crc & 0x80000000) == 0)
				crc <<= 1;
			else
				crc = (crc << 1) ^ CRC32A_POLY;
		}
	}
	return crc;
}

// Calculate CRC-32 Normal (CRC32A), buffer - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u32 Crc32ABufDMA(u32 crc, const void* buf, int len)
{
	return DMA_CRC(DMA_CRC_CRC32, crc, DMA_TEMP_CHAN(), buf, len);
}

// Calculate CRC-32 Normal (CRC32A) - tabled version (requires 1 KB of flash memory)
//   Calculation speed: 160 us per 1 KB
u32 Crc32ATab(const void* buf, int len)
{
	return Crc32ABufTab(CRC32A_INIT, buf, len);
}

// Calculate CRC-32 Normal (CRC32A) - slow version
//   Calculation speed: 790 us per 1 KB
u32 Crc32ASlow(const void* buf, int len)
{
	return Crc32ABufSlow(CRC32A_INIT, buf, len);
}

// Calculate CRC-32 Normal (CRC32A) - DMA version (uses DMA_TEMP_CHAN() temporary channel)
//   Calculation speed: 2 us per 1 KB
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u32 Crc32ADMA(const void* buf, int len)
{
	return Crc32ABufDMA(CRC32A_INIT, buf, len);
}

// Check CRC-32 Normal (CRC32A) calculations (returns False on error)
Bool Crc32ACheck()
{
	u32 crc;
	int i;
	const u8* src;

	// Check CRC-32 table
	if (!Crc32ATableCheck()) return False;

	// Check CRC-32 pattern
#define CRC32A_RES1 0x0376E6E7
#define CRC32A_RES2 0x8E10D720
#define CRC32A_RES3 0x5796333D
	if (Crc32ATab(CrcPat1, CRCPAT1LEN) != CRC32A_RES1) return False;
	if (Crc32ATab(CrcPat2, CRCPAT2LEN) != CRC32A_RES2) return False;
	if (Crc32ATab(CrcPat3, CRCPAT3LEN) != CRC32A_RES3) return False;

	if (Crc32ASlow(CrcPat1, CRCPAT1LEN) != CRC32A_RES1) return False;
	if (Crc32ASlow(CrcPat2, CRCPAT2LEN) != CRC32A_RES2) return False;
	if (Crc32ASlow(CrcPat3, CRCPAT3LEN) != CRC32A_RES3) return False;

	if (Crc32ADMA(CrcPat1, CRCPAT1LEN) != CRC32A_RES1) return False;
	if (Crc32ADMA(CrcPat2, CRCPAT2LEN) != CRC32A_RES2) return False;
	if (Crc32ADMA(CrcPat3, CRCPAT3LEN) != CRC32A_RES3) return False;

	// CRC-32 buffer version
#define CRC32A_SPLIT 503
	crc = Crc32ABufTab(CRC32A_INIT, CrcPat3, CRC32A_SPLIT);
	crc = Crc32ABufTab(crc, (const u8*)CrcPat3+CRC32A_SPLIT, CRCPAT3LEN-CRC32A_SPLIT);
	if (crc != CRC32A_RES3) return False;

	crc = Crc32ABufSlow(CRC32A_INIT, CrcPat3, CRC32A_SPLIT);
	crc = Crc32ABufSlow(crc, (const u8*)CrcPat3+CRC32A_SPLIT, CRCPAT3LEN-CRC32A_SPLIT);
	if (crc != CRC32A_RES3) return False;
	
	crc = Crc32ABufDMA(CRC32A_INIT, CrcPat3, CRC32A_SPLIT);
	crc = Crc32ABufDMA(crc, (const u8*)CrcPat3+CRC32A_SPLIT, CRCPAT3LEN-CRC32A_SPLIT);
	if (crc != CRC32A_RES3) return False;
	
	// CRC-32 byte version
	crc = CRC32A_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc32AByteTab(crc, *src++);
	if (crc != CRC32A_RES3) return False;

	crc = CRC32A_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc32AByteSlow(crc, *src++);
	if (crc != CRC32A_RES3) return False;

	crc = CRC32A_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc32AByteDMA(crc, *src++);
	if (crc != CRC32A_RES3) return False;

	return True;
}

// ============================================================================
//                          CRC-32 Reversed (CRC32B)
// ============================================================================

// CRC-32 Reversed (CRC32B) table (1 KB)
const u32 Crc32BTable[256] = {
	0x00000000, 0x77073096, 0xee0e612c, 0x990951ba, 0x076dc419, 0x706af48f, 0xe963a535, 0x9e6495a3,
	0x0edb8832, 0x79dcb8a4, 0xe0d5e91e, 0x97d2d988, 0x09b64c2b, 0x7eb17cbd, 0xe7b82d07, 0x90bf1d91,
	0x1db71064, 0x6ab020f2, 0xf3b97148, 0x84be41de, 0x1adad47d, 0x6ddde4eb, 0xf4d4b551, 0x83d385c7,
	0x136c9856, 0x646ba8c0, 0xfd62f97a, 0x8a65c9ec, 0x14015c4f, 0x63066cd9, 0xfa0f3d63, 0x8d080df5,
	0x3b6e20c8, 0x4c69105e, 0xd56041e4, 0xa2677172, 0x3c03e4d1, 0x4b04d447, 0xd20d85fd, 0xa50ab56b,
	0x35b5a8fa, 0x42b2986c, 0xdbbbc9d6, 0xacbcf940, 0x32d86ce3, 0x45df5c75, 0xdcd60dcf, 0xabd13d59,
	0x26d930ac, 0x51de003a, 0xc8d75180, 0xbfd06116, 0x21b4f4b5, 0x56b3c423, 0xcfba9599, 0xb8bda50f,
	0x2802b89e, 0x5f058808, 0xc60cd9b2, 0xb10be924, 0x2f6f7c87, 0x58684c11, 0xc1611dab, 0xb6662d3d,
	0x76dc4190, 0x01db7106, 0x98d220bc, 0xefd5102a, 0x71b18589, 0x06b6b51f, 0x9fbfe4a5, 0xe8b8d433,
	0x7807c9a2, 0x0f00f934, 0x9609a88e, 0xe10e9818, 0x7f6a0dbb, 0x086d3d2d, 0x91646c97, 0xe6635c01,
	0x6b6b51f4, 0x1c6c6162, 0x856530d8, 0xf262004e, 0x6c0695ed, 0x1b01a57b, 0x8208f4c1, 0xf50fc457,
	0x65b0d9c6, 0x12b7e950, 0x8bbeb8ea, 0xfcb9887c, 0x62dd1ddf, 0x15da2d49, 0x8cd37cf3, 0xfbd44c65,
	0x4db26158, 0x3ab551ce, 0xa3bc0074, 0xd4bb30e2, 0x4adfa541, 0x3dd895d7, 0xa4d1c46d, 0xd3d6f4fb,
	0x4369e96a, 0x346ed9fc, 0xad678846, 0xda60b8d0, 0x44042d73, 0x33031de5, 0xaa0a4c5f, 0xdd0d7cc9,
	0x5005713c, 0x270241aa, 0xbe0b1010, 0xc90c2086, 0x5768b525, 0x206f85b3, 0xb966d409, 0xce61e49f,
	0x5edef90e, 0x29d9c998, 0xb0d09822, 0xc7d7a8b4, 0x59b33d17, 0x2eb40d81, 0xb7bd5c3b, 0xc0ba6cad,

	0xedb88320, 0x9abfb3b6, 0x03b6e20c, 0x74b1d29a, 0xead54739, 0x9dd277af, 0x04db2615, 0x73dc1683,
	0xe3630b12, 0x94643b84, 0x0d6d6a3e, 0x7a6a5aa8, 0xe40ecf0b, 0x9309ff9d, 0x0a00ae27, 0x7d079eb1,
	0xf00f9344, 0x8708a3d2, 0x1e01f268, 0x6906c2fe, 0xf762575d, 0x806567cb, 0x196c3671, 0x6e6b06e7,
	0xfed41b76, 0x89d32be0, 0x10da7a5a, 0x67dd4acc, 0xf9b9df6f, 0x8ebeeff9, 0x17b7be43, 0x60b08ed5,
	0xd6d6a3e8, 0xa1d1937e, 0x38d8c2c4, 0x4fdff252, 0xd1bb67f1, 0xa6bc5767, 0x3fb506dd, 0x48b2364b,
	0xd80d2bda, 0xaf0a1b4c, 0x36034af6, 0x41047a60, 0xdf60efc3, 0xa867df55, 0x316e8eef, 0x4669be79,
	0xcb61b38c, 0xbc66831a, 0x256fd2a0, 0x5268e236, 0xcc0c7795, 0xbb0b4703, 0x220216b9, 0x5505262f,
	0xc5ba3bbe, 0xb2bd0b28, 0x2bb45a92, 0x5cb36a04, 0xc2d7ffa7, 0xb5d0cf31, 0x2cd99e8b, 0x5bdeae1d,
	0x9b64c2b0, 0xec63f226, 0x756aa39c, 0x026d930a, 0x9c0906a9, 0xeb0e363f, 0x72076785, 0x05005713,
	0x95bf4a82, 0xe2b87a14, 0x7bb12bae, 0x0cb61b38, 0x92d28e9b, 0xe5d5be0d, 0x7cdcefb7, 0x0bdbdf21,
	0x86d3d2d4, 0xf1d4e242, 0x68ddb3f8, 0x1fda836e, 0x81be16cd, 0xf6b9265b, 0x6fb077e1, 0x18b74777,
	0x88085ae6, 0xff0f6a70, 0x66063bca, 0x11010b5c, 0x8f659eff, 0xf862ae69, 0x616bffd3, 0x166ccf45,
	0xa00ae278, 0xd70dd2ee, 0x4e048354, 0x3903b3c2, 0xa7672661, 0xd06016f7, 0x4969474d, 0x3e6e77db,
	0xaed16a4a, 0xd9d65adc, 0x40df0b66, 0x37d83bf0, 0xa9bcae53, 0xdebb9ec5, 0x47b2cf7f, 0x30b5ffe9,
	0xbdbdf21c, 0xcabac28a, 0x53b39330, 0x24b4a3a6, 0xbad03605, 0xcdd70693, 0x54de5729, 0x23d967bf,
	0xb3667a2e, 0xc4614ab8, 0x5d681b02, 0x2a6f2b94, 0xb40bbe37, 0xc30c8ea1, 0x5a05df1b, 0x2d02ef8d,
};

// Check CRC-32 Reversed (CRC32B) table (returns False on error; can be used to generate table)
Bool Crc32BTableCheck()
{
	int i, j;
	u32 k;

	for(i = 0; i < 256; i++)
	{
		k = i;
		for (j = 8; j > 0; j--)
		{
			if ((k & 1) == 0)
				k >>= 1;
			else
				k = (k >> 1) ^ CRC32B_POLY;
		}
		// Crc32BTable[i] = k; // generate table
		if (Crc32BTable[i] != k) return False; // check table
	}
	return True;
}

// Calculate CRC-32 Reversed (CRC32B), 1 byte - tabled version (requires 1 KB of flash memory)
u32 Crc32BByteTab(u32 crc, u8 data)
{
	crc = ~crc;
	return ~Crc32BTable[(crc ^ data) & 0xff] ^ (crc >> 8);
}

// Calculate CRC-32 Reversed (CRC32B), 1 byte - slow version
u32 Crc32BByteSlow(u32 crc, u8 data)
{
	int i;
	crc = ~crc;
	crc ^= data;
	for (i = 8; i > 0; i--)
	{
		if ((crc & 1) == 0)
			crc >>= 1;
		else
			crc = (crc >> 1) ^ CRC32B_POLY;
	}
	return ~crc;
}

// Calculate CRC-32 Reversed (CRC32B), 1 byte - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u32 Crc32BByteDMA(u32 crc, u8 data)
{
	return DMA_CRC(DMA_CRC_CRC32REV | DMA_CRC_REV | DMA_CRC_INV, reverse(~crc), DMA_TEMP_CHAN(), &data, 1);
}

// Calculate CRC-32 Reversed (CRC32B), buffer - tabled version (requires 1 KB of flash memory)
u32 Crc32BBufTab(u32 crc, const void* buf, int len)
{
	const u8* s = (const u8*)buf;
	crc = ~crc;

	for (; len > 0; len--)
	{
		// Reflect formula
		crc = Crc32BTable[(crc ^ *s++) & 0xff] ^ (crc >> 8);
	}
	return ~crc;
}

// Calculate CRC-32 Reversed (CRC32B), buffer - slow version
u32 Crc32BBufSlow(u32 crc, const void* buf, int len)
{
	const u8* s = (const u8*)buf;
	crc = ~crc;
	int i;

	for (; len > 0; len--)
	{
		crc ^= *s++;
		for (i = 8; i > 0; i--)
		{
			if ((crc & 1) == 0)
				crc >>= 1;
			else
				crc = (crc >> 1) ^ CRC32B_POLY;
		}
	}
	return ~crc;
}

// Calculate CRC-32 Reversed (CRC32B), buffer - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u32 Crc32BBufDMA(u32 crc, const void* buf, int len)
{
	return DMA_CRC(DMA_CRC_CRC32REV | DMA_CRC_REV | DMA_CRC_INV, reverse(~crc), DMA_TEMP_CHAN(), buf, len);
}

// Calculate CRC-32 Reversed (CRC32B) - tabled version (requires 1 KB of flash memory)
//   Calculation speed: 160 us per 1 KB
u32 Crc32BTab(const void* buf, int len)
{
	return Crc32BBufTab(CRC32B_INIT, buf, len);
}

// Calculate CRC-32 Reversed (CRC32B) - slow version
//   Calculation speed: 900 us per 1 KB
u32 Crc32BSlow(const void* buf, int len)
{
	return Crc32BBufSlow(CRC32B_INIT, buf, len);
}

// Calculate CRC-32 Reversed (CRC32B) - DMA version (uses DMA_TEMP_CHAN() temporary channel)
//   Calculation speed: 2 us per 1 KB
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u32 Crc32BDMA(const void* buf, int len)
{
	return Crc32BBufDMA(CRC32B_INIT, buf, len);
}

// Check CRC-32 Reversed (CRC32B) calculations (returns False on error)
Bool Crc32BCheck()
{
	u32 crc;
	int i;
	const u8* src;

	// Check CRC-32 table
	if (!Crc32BTableCheck()) return False;

	// Check CRC-32 pattern
#define CRC32B_RES1 0xCBF43926
#define CRC32B_RES2 0xA8E10F6D
#define CRC32B_RES3 0x6FCF9E13
	if (Crc32BTab(CrcPat1, CRCPAT1LEN) != CRC32B_RES1) return False;
	if (Crc32BTab(CrcPat2, CRCPAT2LEN) != CRC32B_RES2) return False;
	if (Crc32BTab(CrcPat3, CRCPAT3LEN) != CRC32B_RES3) return False;

	if (Crc32BSlow(CrcPat1, CRCPAT1LEN) != CRC32B_RES1) return False;
	if (Crc32BSlow(CrcPat2, CRCPAT2LEN) != CRC32B_RES2) return False;
	if (Crc32BSlow(CrcPat3, CRCPAT3LEN) != CRC32B_RES3) return False;

	if (Crc32BDMA(CrcPat1, CRCPAT1LEN) != CRC32B_RES1) return False;
	if (Crc32BDMA(CrcPat2, CRCPAT2LEN) != CRC32B_RES2) return False;
	if (Crc32BDMA(CrcPat3, CRCPAT3LEN) != CRC32B_RES3) return False;

	// CRC-32 buffer version
#define CRC32B_SPLIT 503
	crc = Crc32BBufTab(CRC32B_INIT, CrcPat3, CRC32B_SPLIT);
	crc = Crc32BBufTab(crc, (const u8*)CrcPat3+CRC32B_SPLIT, CRCPAT3LEN-CRC32B_SPLIT);
	if (crc != CRC32B_RES3) return False;

	crc = Crc32BBufSlow(CRC32B_INIT, CrcPat3, CRC32B_SPLIT);
	crc = Crc32BBufSlow(crc, (const u8*)CrcPat3+CRC32B_SPLIT, CRCPAT3LEN-CRC32B_SPLIT);
	if (crc != CRC32B_RES3) return False;

	crc = Crc32BBufDMA(CRC32B_INIT, CrcPat3, CRC32B_SPLIT);
	crc = Crc32BBufDMA(crc, (const u8*)CrcPat3+CRC32B_SPLIT, CRCPAT3LEN-CRC32B_SPLIT);
	if (crc != CRC32B_RES3) return False;

	// CRC-32 byte version
	crc = CRC32B_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc32BByteTab(crc, *src++);
	if (crc != CRC32B_RES3) return False;

	crc = CRC32B_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc32BByteSlow(crc, *src++);
	if (crc != CRC32B_RES3) return False;

	crc = CRC32B_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc32BByteDMA(crc, *src++);
	if (crc != CRC32B_RES3) return False;

	return True;
}

// ============================================================================
//                       CRC-16 CCITT Normal (CRC16A)
// ============================================================================

// CRC-16 CCITT Normal (CRC16A) table (512 B)
const u16 Crc16ATable[256] = {
	0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50a5, 0x60c6, 0x70e7,
	0x8108, 0x9129, 0xa14a, 0xb16b, 0xc18c, 0xd1ad, 0xe1ce, 0xf1ef,
	0x1231, 0x0210, 0x3273, 0x2252, 0x52b5, 0x4294, 0x72f7, 0x62d6,
	0x9339, 0x8318, 0xb37b, 0xa35a, 0xd3bd, 0xc39c, 0xf3ff, 0xe3de,
	0x2462, 0x3443, 0x0420, 0x1401, 0x64e6, 0x74c7, 0x44a4, 0x5485,
	0xa56a, 0xb54b, 0x8528, 0x9509, 0xe5ee, 0xf5cf, 0xc5ac, 0xd58d,
	0x3653, 0x2672, 0x1611, 0x0630, 0x76d7, 0x66f6, 0x5695, 0x46b4,
	0xb75b, 0xa77a, 0x9719, 0x8738, 0xf7df, 0xe7fe, 0xd79d, 0xc7bc,
	0x48c4, 0x58e5, 0x6886, 0x78a7, 0x0840, 0x1861, 0x2802, 0x3823,
	0xc9cc, 0xd9ed, 0xe98e, 0xf9af, 0x8948, 0x9969, 0xa90a, 0xb92b,
	0x5af5, 0x4ad4, 0x7ab7, 0x6a96, 0x1a71, 0x0a50, 0x3a33, 0x2a12,
	0xdbfd, 0xcbdc, 0xfbbf, 0xeb9e, 0x9b79, 0x8b58, 0xbb3b, 0xab1a,
	0x6ca6, 0x7c87, 0x4ce4, 0x5cc5, 0x2c22, 0x3c03, 0x0c60, 0x1c41,
	0xedae, 0xfd8f, 0xcdec, 0xddcd, 0xad2a, 0xbd0b, 0x8d68, 0x9d49,
	0x7e97, 0x6eb6, 0x5ed5, 0x4ef4, 0x3e13, 0x2e32, 0x1e51, 0x0e70,
	0xff9f, 0xefbe, 0xdfdd, 0xcffc, 0xbf1b, 0xaf3a, 0x9f59, 0x8f78,

	0x9188, 0x81a9, 0xb1ca, 0xa1eb, 0xd10c, 0xc12d, 0xf14e, 0xe16f,
	0x1080, 0x00a1, 0x30c2, 0x20e3, 0x5004, 0x4025, 0x7046, 0x6067,
	0x83b9, 0x9398, 0xa3fb, 0xb3da, 0xc33d, 0xd31c, 0xe37f, 0xf35e,
	0x02b1, 0x1290, 0x22f3, 0x32d2, 0x4235, 0x5214, 0x6277, 0x7256,
	0xb5ea, 0xa5cb, 0x95a8, 0x8589, 0xf56e, 0xe54f, 0xd52c, 0xc50d,
	0x34e2, 0x24c3, 0x14a0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
	0xa7db, 0xb7fa, 0x8799, 0x97b8, 0xe75f, 0xf77e, 0xc71d, 0xd73c,
	0x26d3, 0x36f2, 0x0691, 0x16b0, 0x6657, 0x7676, 0x4615, 0x5634,
	0xd94c, 0xc96d, 0xf90e, 0xe92f, 0x99c8, 0x89e9, 0xb98a, 0xa9ab,
	0x5844, 0x4865, 0x7806, 0x6827, 0x18c0, 0x08e1, 0x3882, 0x28a3,
	0xcb7d, 0xdb5c, 0xeb3f, 0xfb1e, 0x8bf9, 0x9bd8, 0xabbb, 0xbb9a,
	0x4a75, 0x5a54, 0x6a37, 0x7a16, 0x0af1, 0x1ad0, 0x2ab3, 0x3a92,
	0xfd2e, 0xed0f, 0xdd6c, 0xcd4d, 0xbdaa, 0xad8b, 0x9de8, 0x8dc9,
	0x7c26, 0x6c07, 0x5c64, 0x4c45, 0x3ca2, 0x2c83, 0x1ce0, 0x0cc1,
	0xef1f, 0xff3e, 0xcf5d, 0xdf7c, 0xaf9b, 0xbfba, 0x8fd9, 0x9ff8,
	0x6e17, 0x7e36, 0x4e55, 0x5e74, 0x2e93, 0x3eb2, 0x0ed1, 0x1ef0,
};

// Check CRC-16 CCITT Normal (CRC16A) table (returns False on error; can be used to generate table)
Bool Crc16ATableCheck()
{
	int i, j;
	u16 crc, c;

	for(i = 0; i < 256; i++)
	{
		crc = 0;
		c = (u16)(i << 8);
		for (j = 8; j > 0; j--)
		{
			if (((crc ^ c) & 0x8000) == 0)
				crc <<= 1;
			else
				crc = (u16)((crc << 1) ^ CRC16A_POLY);
			c <<= 1;
		}
		// Crc16ATable[i] = crc; // generate table
		if (Crc16ATable[i] != crc) return False;
	}
	return True;
}

// Calculate CRC-16 CCITT Normal (CRC16A), 1 byte - tabled version (requires 512 B of flash memory)
u16 Crc16AByteTab(u16 crc, u8 data)
{
	return Crc16ATable[(crc >> 8) ^ data] ^ (crc << 8);
}

// Calculate CRC-16 CCITT Normal (CRC16A), 1 byte - fast version
// http://www.embeddedrelated.com/groups/msp430/show/29689.php
u16 Crc16AByteFast(u16 crc, u8 data)
{
	crc = (crc >> 8) | (crc << 8);
	crc ^= data;
	crc ^= (crc & 0xff) >> 4;
	crc ^= crc << 12;
	crc ^= (crc & 0xff) << 5;
	return crc;
}

// Calculate CRC-16 CCITT Normal (CRC16A), 1 byte - slow version
u16 Crc16AByteSlow(u16 crc, u8 data)
{
	int i;
	crc ^= (u16)data << 8;

	for (i = 8; i > 0; i--)
	{
		if ((crc & 0x8000) == 0)
			crc <<= 1;
		else
			crc = (u16)((crc << 1) ^ CRC16A_POLY);
	}
	return crc;
}

// Calculate CRC-16 CCITT Normal (CRC16A), 1 byte - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u16 Crc16AByteDMA(u16 crc, u8 data)
{
	return (u16)DMA_CRC(DMA_CRC_CRC16, crc, DMA_TEMP_CHAN(), &data, 1);
}

// Calculate CRC-16 CCITT Normal (CRC16A), buffer - tabled version (requires 512 B of flash memory)
u16 Crc16ABufTab(u16 crc, const void* buf, int len)
{
	const u8* s = (const u8*)buf;

	for (; len > 0; len--)
	{
		crc = Crc16ATable[(crc >> 8) ^ *s++] ^ (crc << 8);
	}
	return crc;
}

// Calculate CRC-16 CCITT Normal (CRC16A), buffer - fast version
u16 Crc16ABufFast(u16 crc, const void* buf, int len)
{
	const u8* s = (const u8*)buf;

	for (; len > 0; len--)
	{
		crc = (crc >> 8) | (crc << 8);
		crc ^= *s++;
		crc ^= (crc & 0xff) >> 4;
		crc ^= crc << 12;
		crc ^= (crc & 0xff) << 5;
	}
	return crc;
}

// Calculate CRC-16 CCITT Normal (CRC16A), buffer - slow version
u16 Crc16ABufSlow(u16 crc, const void* buf, int len)
{
	int i;
	const u8* s = (const u8*)buf;

	for (; len > 0; len--)
	{
		crc ^= (u16)*s++ << 8;

		for (i = 8; i > 0; i--)
		{
			if ((crc & 0x8000) == 0)
				crc <<= 1;
			else
				crc = (u16)((crc << 1) ^ CRC16A_POLY);
		}
	}
	return crc;
}

// Calculate CRC-16 CCITT Normal (CRC16A), buffer - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u16 Crc16ABufDMA(u16 crc, const void* buf, int len)
{
	return (u16)DMA_CRC(DMA_CRC_CRC16, crc, DMA_TEMP_CHAN(), buf, len);
}

// Calculate CRC-16 CCITT Normal (CRC16A) - tabled version (requires 512 B of flash memory)
//   Calculation speed: 170 us per 1 KB
u16 Crc16ATab(const void* buf, int len)
{
	return Crc16ABufTab(CRC16A_INIT, buf, len);
}

// Calculate CRC-16 CCITT Normal (CRC16A) - fast version
//   Calculation speed: 200 us per 1 KB
u16 Crc16AFast(const void* buf, int len)
{
	return Crc16ABufFast(CRC16A_INIT, buf, len);
}

// Calculate CRC-16 CCITT Normal (CRC16A) - slow version
//   Calculation speed: 1000 us per 1 KB
u16 Crc16ASlow(const void* buf, int len)
{
	return Crc16ABufSlow(CRC16A_INIT, buf, len);
}

// Calculate CRC-16 CCITT Normal (CRC16A) - DMA version (uses DMA_TEMP_CHAN() temporary channel)
//   Calculation speed: 2 us per 1 KB
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u16 Crc16ADMA(const void* buf, int len)
{
	return Crc16ABufDMA(CRC16A_INIT, buf, len);
}

// Check CRC-16 CCITT Normal (CRC16A) fast method (return False on error)
//  Very slow (takes a few seconds) - do not use usually
Bool Crc16AFastCheck()
{
	u16 crc = 0;
	u8 data = 0;
	for (;;)
	{
		if (Crc16AByteTab(crc, data) != (Crc16AByteFast(crc, data))) return False;
		data++;
		if (data == 0)
		{
			crc++;
			if (crc == 0) break;
		}
	}
	return True;
}

// Check CRC-16 CCITT Normal (CRC16A) calculations (returns False on error)
Bool Crc16ACheck()
{
	u16 crc;
	int i;
	const u8* src;

	// Check CRC-16 table
	if (!Crc16ATableCheck()) return False;

	// Check CRC-16 fast method
	//  Very slow (takes a few seconds) - do not use usually
	//if (!Crc16AFastCheck()) return False;

	// Check CRC-16-CCITT (0xFFFF) pattern
#define CRC16A_RES1 0x29B1
#define CRC16A_RES2 0x4CD4
#define CRC16A_RES3 0x4EED
	if (Crc16ATab(CrcPat1, CRCPAT1LEN) != CRC16A_RES1) return False;
	if (Crc16ATab(CrcPat2, CRCPAT2LEN) != CRC16A_RES2) return False;
	if (Crc16ATab(CrcPat3, CRCPAT3LEN) != CRC16A_RES3) return False;

	if (Crc16AFast(CrcPat1, CRCPAT1LEN) != CRC16A_RES1) return False;
	if (Crc16AFast(CrcPat2, CRCPAT2LEN) != CRC16A_RES2) return False;
	if (Crc16AFast(CrcPat3, CRCPAT3LEN) != CRC16A_RES3) return False;

	if (Crc16ASlow(CrcPat1, CRCPAT1LEN) != CRC16A_RES1) return False;
	if (Crc16ASlow(CrcPat2, CRCPAT2LEN) != CRC16A_RES2) return False;
	if (Crc16ASlow(CrcPat3, CRCPAT3LEN) != CRC16A_RES3) return False;

	if (Crc16ADMA(CrcPat1, CRCPAT1LEN) != CRC16A_RES1) return False;
	if (Crc16ADMA(CrcPat2, CRCPAT2LEN) != CRC16A_RES2) return False;
	if (Crc16ADMA(CrcPat3, CRCPAT3LEN) != CRC16A_RES3) return False;

	// CRC-16 buffer version
#define CRC16A_SPLIT 503
	crc = Crc16ABufTab(CRC16A_INIT, CrcPat3, CRC16A_SPLIT);
	crc = Crc16ABufTab(crc, (const u8*)CrcPat3+CRC16A_SPLIT, CRCPAT3LEN-CRC16A_SPLIT);
	if (crc != CRC16A_RES3) return False;

	crc = Crc16ABufFast(CRC16A_INIT, CrcPat3, CRC16A_SPLIT);
	crc = Crc16ABufFast(crc, (const u8*)CrcPat3+CRC16A_SPLIT, CRCPAT3LEN-CRC16A_SPLIT);
	if (crc != CRC16A_RES3) return False;

	crc = Crc16ABufSlow(CRC16A_INIT, CrcPat3, CRC16A_SPLIT);
	crc = Crc16ABufSlow(crc, (const u8*)CrcPat3+CRC16A_SPLIT, CRCPAT3LEN-CRC16A_SPLIT);
	if (crc != CRC16A_RES3) return False;

	crc = Crc16ABufDMA(CRC16A_INIT, CrcPat3, CRC16A_SPLIT);
	crc = Crc16ABufDMA(crc, (const u8*)CrcPat3+CRC16A_SPLIT, CRCPAT3LEN-CRC16A_SPLIT);
	if (crc != CRC16A_RES3) return False;

	// CRC-16 byte version
	crc = CRC16A_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc16AByteTab(crc, *src++);
	if (crc != CRC16A_RES3) return False;

	crc = CRC16A_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc16AByteFast(crc, *src++);
	if (crc != CRC16A_RES3) return False;

	crc = CRC16A_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc16AByteSlow(crc, *src++);
	if (crc != CRC16A_RES3) return False;

	crc = CRC16A_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc16AByteDMA(crc, *src++);
	if (crc != CRC16A_RES3) return False;

	return True;
}

// ============================================================================
//                       CRC-16 CCITT Reversed (CRC16A)
// ============================================================================

// CRC-16 CCITT Reversed (CRC16B) table (512 B)
const u16 Crc16BTable[256] = {
	0x0000, 0x1189, 0x2312, 0x329b, 0x4624, 0x57ad, 0x6536, 0x74bf,
	0x8c48, 0x9dc1, 0xaf5a, 0xbed3, 0xca6c, 0xdbe5, 0xe97e, 0xf8f7,
	0x1081, 0x0108, 0x3393, 0x221a, 0x56a5, 0x472c, 0x75b7, 0x643e,
	0x9cc9, 0x8d40, 0xbfdb, 0xae52, 0xdaed, 0xcb64, 0xf9ff, 0xe876,
	0x2102, 0x308b, 0x0210, 0x1399, 0x6726, 0x76af, 0x4434, 0x55bd,
	0xad4a, 0xbcc3, 0x8e58, 0x9fd1, 0xeb6e, 0xfae7, 0xc87c, 0xd9f5,
	0x3183, 0x200a, 0x1291, 0x0318, 0x77a7, 0x662e, 0x54b5, 0x453c,
	0xbdcb, 0xac42, 0x9ed9, 0x8f50, 0xfbef, 0xea66, 0xd8fd, 0xc974,
	0x4204, 0x538d, 0x6116, 0x709f, 0x0420, 0x15a9, 0x2732, 0x36bb,
	0xce4c, 0xdfc5, 0xed5e, 0xfcd7, 0x8868, 0x99e1, 0xab7a, 0xbaf3,
	0x5285, 0x430c, 0x7197, 0x601e, 0x14a1, 0x0528, 0x37b3, 0x263a,
	0xdecd, 0xcf44, 0xfddf, 0xec56, 0x98e9, 0x8960, 0xbbfb, 0xaa72,
	0x6306, 0x728f, 0x4014, 0x519d, 0x2522, 0x34ab, 0x0630, 0x17b9,
	0xef4e, 0xfec7, 0xcc5c, 0xddd5, 0xa96a, 0xb8e3, 0x8a78, 0x9bf1,
	0x7387, 0x620e, 0x5095, 0x411c, 0x35a3, 0x242a, 0x16b1, 0x0738,
	0xffcf, 0xee46, 0xdcdd, 0xcd54, 0xb9eb, 0xa862, 0x9af9, 0x8b70,

	0x8408, 0x9581, 0xa71a, 0xb693, 0xc22c, 0xd3a5, 0xe13e, 0xf0b7,
	0x0840, 0x19c9, 0x2b52, 0x3adb, 0x4e64, 0x5fed, 0x6d76, 0x7cff,
	0x9489, 0x8500, 0xb79b, 0xa612, 0xd2ad, 0xc324, 0xf1bf, 0xe036,
	0x18c1, 0x0948, 0x3bd3, 0x2a5a, 0x5ee5, 0x4f6c, 0x7df7, 0x6c7e,
	0xa50a, 0xb483, 0x8618, 0x9791, 0xe32e, 0xf2a7, 0xc03c, 0xd1b5,
	0x2942, 0x38cb, 0x0a50, 0x1bd9, 0x6f66, 0x7eef, 0x4c74, 0x5dfd,
	0xb58b, 0xa402, 0x9699, 0x8710, 0xf3af, 0xe226, 0xd0bd, 0xc134,
	0x39c3, 0x284a, 0x1ad1, 0x0b58, 0x7fe7, 0x6e6e, 0x5cf5, 0x4d7c,
	0xc60c, 0xd785, 0xe51e, 0xf497, 0x8028, 0x91a1, 0xa33a, 0xb2b3,
	0x4a44, 0x5bcd, 0x6956, 0x78df, 0x0c60, 0x1de9, 0x2f72, 0x3efb,
	0xd68d, 0xc704, 0xf59f, 0xe416, 0x90a9, 0x8120, 0xb3bb, 0xa232,
	0x5ac5, 0x4b4c, 0x79d7, 0x685e, 0x1ce1, 0x0d68, 0x3ff3, 0x2e7a,
	0xe70e, 0xf687, 0xc41c, 0xd595, 0xa12a, 0xb0a3, 0x8238, 0x93b1,
	0x6b46, 0x7acf, 0x4854, 0x59dd, 0x2d62, 0x3ceb, 0x0e70, 0x1ff9,
	0xf78f, 0xe606, 0xd49d, 0xc514, 0xb1ab, 0xa022, 0x92b9, 0x8330,
	0x7bc7, 0x6a4e, 0x58d5, 0x495c, 0x3de3, 0x2c6a, 0x1ef1, 0x0f78,
};

// Check CRC-16 CCITT Reversed (CRC16B) table (returns False on error; can be used to generate table)
Bool Crc16BTableCheck()
{
	int i, j;
	u16 k;

	for(i = 0; i < 256; i++)
	{
		k = (u16)i;
		for (j = 8; j > 0; j--)
		{
			if ((k & 1) == 0)
				k >>= 1;
			else
				k = (u16)((k >> 1) ^ CRC16B_POLY);
		}
		// Crc16BTable[i] = k; // generate table
		if (Crc16BTable[i] != k) return False;
	}
	return True;
}

// Calculate CRC-16 CCITT Reversed (CRC16B), 1 byte - tabled version (requires 512 B of flash memory)
u16 Crc16BByteTab(u16 crc, u8 data)
{
	crc = ~crc;
	return ~Crc16BTable[(crc ^ data) & 0xff] ^ (crc >> 8);
}

// Calculate CRC-16 CCITT Reversed (CRC16B), 1 byte - slow version
u16 Crc16BByteSlow(u16 crc, u8 data)
{
	int i;
	crc = ~crc;
	crc ^= data;
	for (i = 8; i > 0; i--)
	{
		if ((crc & 1) == 0)
			crc >>= 1;
		else
			crc = (u16)((crc >> 1) ^ CRC16B_POLY);
	}
	return ~crc;
}

// Calculate CRC-16 CCITT Reversed (CRC16B), 1 byte - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u16 Crc16BByteDMA(u16 crc, u8 data)
{
	return (u16)(DMA_CRC(DMA_CRC_CRC16REV | DMA_CRC_REV | DMA_CRC_INV,
		Reverse16(~crc), DMA_TEMP_CHAN(), &data, 1) >> 16);
}

// Calculate CRC-16 CCITT Reversed (CRC16B), buffer - tabled version (requires 512 B of flash memory)
u16 Crc16BBufTab(u16 crc, const void* buf, int len)
{
	const u8* s = (const u8*)buf;
	crc = ~crc;

	for (; len > 0; len--)
	{
		// Reflect formula
		crc = Crc16BTable[(crc ^ *s++) & 0xff] ^ (crc >> 8);
	}
	return ~crc;
}

// Calculate CRC-16 CCITT Reversed (CRC16B), buffer - slow version
u16 Crc16BBufSlow(u16 crc, const void* buf, int len)
{
	const u8* s = (const u8*)buf;
	crc = ~crc;
	int i;

	for (; len > 0; len--)
	{
		crc ^= *s++;
		for (i = 8; i > 0; i--)
		{
			if ((crc & 1) == 0)
				crc >>= 1;
			else
				crc = (u16)((crc >> 1) ^ CRC16B_POLY);
		}
	}
	return ~crc;
}

// Calculate CRC-16 CCITT Reversed (CRC16B), buffer - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u16 Crc16BBufDMA(u16 crc, const void* buf, int len)
{
	return (u16)(DMA_CRC(DMA_CRC_CRC16REV | DMA_CRC_REV | DMA_CRC_INV,
			Reverse16(~crc), DMA_TEMP_CHAN(), buf, len) >> 16);
}

// Calculate CRC-16 CCITT Reversed (CRC16B) - tabled version (requires 512 B of flash memory)
//   Calculation speed: 160 us per 1 KB
u16 Crc16BTab(const void* buf, int len)
{
	return Crc16BBufTab(CRC16B_INIT, buf, len);
}

// Calculate CRC-16 CCITT Reversed (CRC16B) - slow version
//   Calculation speed: 880 us per 1 KB
u16 Crc16BSlow(const void* buf, int len)
{
	return Crc16BBufSlow(CRC16B_INIT, buf, len);
}

// Calculate CRC-16 CCITT Reversed (CRC16B) - DMA version (uses DMA_TEMP_CHAN() temporary channel)
//   Calculation speed: 2 us per 1 KB
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u16 Crc16BDMA(const void* buf, int len)
{
	return Crc16BBufDMA(CRC16B_INIT, buf, len);
}

// Check CRC-16 CCITT Reversed (CRC16B) calculations (returns False on error)
Bool Crc16BCheck()
{
	u16 crc;
	int i;
	const u8* src;

	// Check CRC-16 table
	if (!Crc16BTableCheck()) return False;

	// Check CRC-16-CCITT (0xFFFF) pattern
#define CRC16B_RES1 0x906E
#define CRC16B_RES2 0x7CBD
#define CRC16B_RES3 0x0C42
	if (Crc16BTab(CrcPat1, CRCPAT1LEN) != CRC16B_RES1) return False;
	if (Crc16BTab(CrcPat2, CRCPAT2LEN) != CRC16B_RES2) return False;
	if (Crc16BTab(CrcPat3, CRCPAT3LEN) != CRC16B_RES3) return False;

	if (Crc16BSlow(CrcPat1, CRCPAT1LEN) != CRC16B_RES1) return False;
	if (Crc16BSlow(CrcPat2, CRCPAT2LEN) != CRC16B_RES2) return False;
	if (Crc16BSlow(CrcPat3, CRCPAT3LEN) != CRC16B_RES3) return False;

	if (Crc16BDMA(CrcPat1, CRCPAT1LEN) != CRC16B_RES1) return False;
	if (Crc16BDMA(CrcPat2, CRCPAT2LEN) != CRC16B_RES2) return False;
	if (Crc16BDMA(CrcPat3, CRCPAT3LEN) != CRC16B_RES3) return False;

	// CRC-16 buffer version
#define CRC16B_SPLIT 503
	crc = Crc16BBufTab(CRC16B_INIT, CrcPat3, CRC16B_SPLIT);
	crc = Crc16BBufTab(crc, (const u8*)CrcPat3+CRC16B_SPLIT, CRCPAT3LEN-CRC16B_SPLIT);
	if (crc != CRC16B_RES3) return False;

	crc = Crc16BBufSlow(CRC16B_INIT, CrcPat3, CRC16B_SPLIT);
	crc = Crc16BBufSlow(crc, (const u8*)CrcPat3+CRC16B_SPLIT, CRCPAT3LEN-CRC16B_SPLIT);
	if (crc != CRC16B_RES3) return False;

	crc = Crc16BBufDMA(CRC16B_INIT, CrcPat3, CRC16B_SPLIT);
	crc = Crc16BBufDMA(crc, (const u8*)CrcPat3+CRC16B_SPLIT, CRCPAT3LEN-CRC16B_SPLIT);
	if (crc != CRC16B_RES3) return False;

	// CRC-16 byte version
	crc = CRC16B_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc16BByteTab(crc, *src++);
	if (crc != CRC16B_RES3) return False;

	crc = CRC16B_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc16BByteSlow(crc, *src++);
	if (crc != CRC16B_RES3) return False;

	crc = CRC16B_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc16BByteDMA(crc, *src++);
	if (crc != CRC16B_RES3) return False;

	return True;
}

// ============================================================================
//                 CRC-16 CCITT Normal Alternative (CRC16C)
// ============================================================================

// Calculate CRC-16 CCITT Normal Alternative (CRC16C) - tabled version (requires 512 B of flash memory)
//   Calculation speed: 170 us per 1 KB
u16 Crc16CTab(const void* buf, int len)
{
	return Crc16CBufTab(CRC16C_INIT, buf, len);
}

// Calculate CRC-16 CCITT Normal Alternative (CRC16C) - fast version
//   Calculation speed: 200 us per 1 KB
u16 Crc16CFast(const void* buf, int len)
{
	return Crc16CBufFast(CRC16C_INIT, buf, len);
}

// Calculate CRC-16 CCITT Normal Alternative (CRC16C) - slow version
//   Calculation speed: 1000 us per 1 KB
u16 Crc16CSlow(const void* buf, int len)
{
	return Crc16CBufSlow(CRC16C_INIT, buf, len);
}

// Calculate CRC-16 CCITT Normal Alternative (CRC16C) - DMA version (uses DMA_TEMP_CHAN() temporary channel)
//   Calculation speed: 2 us per 1 KB
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u16 Crc16CDMA(const void* buf, int len)
{
	return Crc16CBufDMA(CRC16C_INIT, buf, len);
}

// Check CRC-16 CCITT Normal Alternative (CRC16C) calculations (returns False on error)
Bool Crc16CCheck()
{
	u16 crc;
	int i;
	const u8* src;

	// Check CRC-16-CCITT (0x1D0F) pattern
#define CRC16C_RES1 0xE5CC
#define CRC16C_RES2 0x9144
#define CRC16C_RES3 0xE351
	if (Crc16CTab(CrcPat1, CRCPAT1LEN) != CRC16C_RES1) return False;
	if (Crc16CTab(CrcPat2, CRCPAT2LEN) != CRC16C_RES2) return False;
	if (Crc16CTab(CrcPat3, CRCPAT3LEN) != CRC16C_RES3) return False;

	if (Crc16CFast(CrcPat1, CRCPAT1LEN) != CRC16C_RES1) return False;
	if (Crc16CFast(CrcPat2, CRCPAT2LEN) != CRC16C_RES2) return False;
	if (Crc16CFast(CrcPat3, CRCPAT3LEN) != CRC16C_RES3) return False;

	if (Crc16CSlow(CrcPat1, CRCPAT1LEN) != CRC16C_RES1) return False;
	if (Crc16CSlow(CrcPat2, CRCPAT2LEN) != CRC16C_RES2) return False;
	if (Crc16CSlow(CrcPat3, CRCPAT3LEN) != CRC16C_RES3) return False;

	if (Crc16CDMA(CrcPat1, CRCPAT1LEN) != CRC16C_RES1) return False;
	if (Crc16CDMA(CrcPat2, CRCPAT2LEN) != CRC16C_RES2) return False;
	if (Crc16CDMA(CrcPat3, CRCPAT3LEN) != CRC16C_RES3) return False;

	// CRC-16 buffer version
#define CRC16C_SPLIT 503
	crc = Crc16CBufTab(CRC16C_INIT, CrcPat3, CRC16C_SPLIT);
	crc = Crc16CBufTab(crc, (const u8*)CrcPat3+CRC16C_SPLIT, CRCPAT3LEN-CRC16C_SPLIT);
	if (crc != CRC16C_RES3) return False;

	crc = Crc16CBufFast(CRC16C_INIT, CrcPat3, CRC16C_SPLIT);
	crc = Crc16CBufFast(crc, (const u8*)CrcPat3+CRC16C_SPLIT, CRCPAT3LEN-CRC16C_SPLIT);
	if (crc != CRC16C_RES3) return False;

	crc = Crc16CBufSlow(CRC16C_INIT, CrcPat3, CRC16C_SPLIT);
	crc = Crc16CBufSlow(crc, (const u8*)CrcPat3+CRC16C_SPLIT, CRCPAT3LEN-CRC16C_SPLIT);
	if (crc != CRC16C_RES3) return False;

	crc = Crc16CBufDMA(CRC16C_INIT, CrcPat3, CRC16C_SPLIT);
	crc = Crc16CBufDMA(crc, (const u8*)CrcPat3+CRC16C_SPLIT, CRCPAT3LEN-CRC16C_SPLIT);
	if (crc != CRC16C_RES3) return False;

	// CRC-16 byte version
	crc = CRC16C_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc16CByteTab(crc, *src++);
	if (crc != CRC16C_RES3) return False;

	crc = CRC16C_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc16CByteFast(crc, *src++);
	if (crc != CRC16C_RES3) return False;

	crc = CRC16C_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc16CByteSlow(crc, *src++);
	if (crc != CRC16C_RES3) return False;

	crc = CRC16C_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc16CByteDMA(crc, *src++);
	if (crc != CRC16C_RES3) return False;

	return True;
}

// ============================================================================
//                            CRC-8 Dallas
// ============================================================================

// CRC-8 table (256 B)
const u8 Crc8Table[256] = {
	0x00, 0x5e, 0xbc, 0xe2, 0x61, 0x3f, 0xdd, 0x83,
	0xc2, 0x9c, 0x7e, 0x20, 0xa3, 0xfd, 0x1f, 0x41,
	0x9d, 0xc3, 0x21, 0x7f, 0xfc, 0xa2, 0x40, 0x1e,
	0x5f, 0x01, 0xe3, 0xbd, 0x3e, 0x60, 0x82, 0xdc,
	0x23, 0x7d, 0x9f, 0xc1, 0x42, 0x1c, 0xfe, 0xa0,
	0xe1, 0xbf, 0x5d, 0x03, 0x80, 0xde, 0x3c, 0x62,
	0xbe, 0xe0, 0x02, 0x5c, 0xdf, 0x81, 0x63, 0x3d,
	0x7c, 0x22, 0xc0, 0x9e, 0x1d, 0x43, 0xa1, 0xff,
	0x46, 0x18, 0xfa, 0xa4, 0x27, 0x79, 0x9b, 0xc5,
	0x84, 0xda, 0x38, 0x66, 0xe5, 0xbb, 0x59, 0x07,
	0xdb, 0x85, 0x67, 0x39, 0xba, 0xe4, 0x06, 0x58,
	0x19, 0x47, 0xa5, 0xfb, 0x78, 0x26, 0xc4, 0x9a,
	0x65, 0x3b, 0xd9, 0x87, 0x04, 0x5a, 0xb8, 0xe6,
	0xa7, 0xf9, 0x1b, 0x45, 0xc6, 0x98, 0x7a, 0x24,
	0xf8, 0xa6, 0x44, 0x1a, 0x99, 0xc7, 0x25, 0x7b,
	0x3a, 0x64, 0x86, 0xd8, 0x5b, 0x05, 0xe7, 0xb9,
	0x8c, 0xd2, 0x30, 0x6e, 0xed, 0xb3, 0x51, 0x0f,
	0x4e, 0x10, 0xf2, 0xac, 0x2f, 0x71, 0x93, 0xcd,
	0x11, 0x4f, 0xad, 0xf3, 0x70, 0x2e, 0xcc, 0x92,
	0xd3, 0x8d, 0x6f, 0x31, 0xb2, 0xec, 0x0e, 0x50,
	0xaf, 0xf1, 0x13, 0x4d, 0xce, 0x90, 0x72, 0x2c,
	0x6d, 0x33, 0xd1, 0x8f, 0x0c, 0x52, 0xb0, 0xee,
	0x32, 0x6c, 0x8e, 0xd0, 0x53, 0x0d, 0xef, 0xb1,
	0xf0, 0xae, 0x4c, 0x12, 0x91, 0xcf, 0x2d, 0x73,
	0xca, 0x94, 0x76, 0x28, 0xab, 0xf5, 0x17, 0x49,
	0x08, 0x56, 0xb4, 0xea, 0x69, 0x37, 0xd5, 0x8b,
	0x57, 0x09, 0xeb, 0xb5, 0x36, 0x68, 0x8a, 0xd4,
	0x95, 0xcb, 0x29, 0x77, 0xf4, 0xaa, 0x48, 0x16,
	0xe9, 0xb7, 0x55, 0x0b, 0x88, 0xd6, 0x34, 0x6a,
	0x2b, 0x75, 0x97, 0xc9, 0x4a, 0x14, 0xf6, 0xa8,
	0x74, 0x2a, 0xc8, 0x96, 0x15, 0x4b, 0xa9, 0xf7,
	0xb6, 0xe8, 0x0a, 0x54, 0xd7, 0x89, 0x6b, 0x35,
};

// Check CRC-8 table (returns False on error; can be used to generate table)
Bool Crc8TableCheck()
{
	int i, j;
	u8 crc;

	for (i = 0; i < 256; i++)
	{
		crc = (u8)i;
		for (j = 8; j > 0; j--)
		{
			if ((crc & 1) == 0)
				crc >>= 1;
			else
				crc = (crc >> 1) ^ CRC8_POLY;
		}
		if (Crc8Table[i] != crc) return False;
	}
	return True;
}

// Calculate CRC-8, 1 byte - tabled version (requires 256 B of flash memory)
u8 Crc8ByteTab(u8 crc, u8 data)
{
	return Crc8Table[crc ^ data];
}	

// Calculate CRC-8, 1 byte - slow version
u8 Crc8ByteSlow(u8 crc, u8 data)
{
	int i;
	crc ^= data;
	for (i = 8; i > 0; i--)
	{
		if ((crc & 1) == 0)
			crc >>= 1;
		else
			crc = (crc >> 1) ^ CRC8_POLY;
	}
	return crc;
}

// Calculate CRC-8, buffer - tabled version (requires 256 B of flash memory)
u8 Crc8BufTab(u8 crc, const void* buf, int len)
{
	const u8* s = (const u8*)buf;
	for (; len > 0; len--)
	{
		crc = Crc8Table[crc ^ *s++];
	}
	return crc;
}

// Calculate CRC-8, buffer - slow version
u8 Crc8BufSlow(u8 crc, const void* buf, int len)
{
	const u8* s = (const u8*)buf;
	int i;
	for (; len > 0; len--)
	{
		crc ^= *s++;
		for (i = 8; i > 0; i--)
		{
			if ((crc & 1) == 0)
				crc >>= 1;
			else
				crc = (crc >> 1) ^ CRC8_POLY;
		}
	}
	return crc;
}

// Calculate CRC-8 - tabled version (requires 256 B of flash memory)
//   Calculation speed: 115 us per 1 KB
u8 Crc8Tab(const void* buf, int len)
{
	return Crc8BufTab(CRC8_INIT, buf, len);
}

// Calculate CRC-8 - slow version
//   Calculation speed: 820 us per 1 KB
u8 Crc8Slow(const void* buf, int len)
{
	return Crc8BufSlow(CRC8_INIT, buf, len);
}

// Check CRC-8 calculations (returns False on error)
Bool Crc8Check()
{
	u8 crc;
	int i;
	const u8* src;

	// Check CRC-8 table
	if (!Crc8TableCheck()) return False;

	// Check CRC-8 pattern
#define CRC8_RES1 0xA1
#define CRC8_RES2 0xF1
#define CRC8_RES3 0x1E
	if (Crc8Tab(CrcPat1, CRCPAT1LEN) != CRC8_RES1) return False;
	if (Crc8Tab(CrcPat2, CRCPAT2LEN) != CRC8_RES2) return False;
	if (Crc8Tab(CrcPat3, CRCPAT3LEN) != CRC8_RES3) return False;

	if (Crc8Slow(CrcPat1, CRCPAT1LEN) != CRC8_RES1) return False;
	if (Crc8Slow(CrcPat2, CRCPAT2LEN) != CRC8_RES2) return False;
	if (Crc8Slow(CrcPat3, CRCPAT3LEN) != CRC8_RES3) return False;

	// CRC-8 buffer version
#define CRC8_SPLIT 503
	crc = Crc8BufTab(CRC8_INIT, CrcPat3, CRC8_SPLIT);
	crc = Crc8BufTab(crc, (const u8*)CrcPat3+CRC8_SPLIT, CRCPAT3LEN-CRC8_SPLIT);
	if (crc != CRC8_RES3) return False;

	crc = Crc8BufSlow(CRC8_INIT, CrcPat3, CRC8_SPLIT);
	crc = Crc8BufSlow(crc, (const u8*)CrcPat3+CRC8_SPLIT, CRCPAT3LEN-CRC8_SPLIT);
	if (crc != CRC8_RES3) return False;
	
	// CRC-8 byte version
	crc = CRC8_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc8ByteTab(crc, *src++);
	if (crc != CRC8_RES3) return False;

	crc = CRC8_INIT;
	src = (const u8*)CrcPat3;
	for (i = 0; i < CRCPAT3LEN; i++) crc = Crc8ByteSlow(crc, *src++);
	if (crc != CRC8_RES3) return False;

	return True;
}

// ============================================================================
//                                   Parity
// ============================================================================

// Calculate parity, 1 byte - software version
u8 ParityByteSoft(u8 par, u8 data)
{
	int i;
	for (i = 8; i > 0; i--)
	{
		if ((data & 1) != 0) par ^= 1;
		data >>= 1;
	}
	return par;
}

// Calculate parity, 1 byte - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u8 ParityByteDMA(u8 par, u8 data)
{
	return (u8)DMA_CRC(DMA_CRC_XOR, par, DMA_TEMP_CHAN(), &data, 1);
}

// Calculate parity, buffer - software version
u8 ParityBufSoft(u8 par, const void* buf, int len)
{
	int i;
	u8 data = 0;
	const u8* s = (const u8*)buf;
	for (; len > 0; len--) data ^= *s++;
	for (i = 8; i > 0; i--)
	{
		if ((data & 1) != 0) par ^= 1;
		data >>= 1;
	}
	return par;
}

// Calculate parity, buffer - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u8 ParityBufDMA(u8 par, const void* buf, int len)
{
	return (u8)DMA_CRC(DMA_CRC_XOR, par, DMA_TEMP_CHAN(), buf, len);
}

// Calculate parity - software version
//   Calculation speed: 90 us per 1 KB
u8 ParitySoft(const void* buf, int len)
{
	return ParityBufSoft(0, buf, len);
}

// Calculate parity - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
//   Calculation speed: 2 us per 1 KB
u8 ParityDMA(const void* buf, int len)
{
	return ParityBufDMA(0, buf, len);
}

// ============================================================================
//            Simple checksum on 8-bit data with 32-bit result
// ============================================================================

// Calculate 8-bit checksum, 1 byte - software version
u32 Sum8ByteSoft(u32 sum, u8 data)
{
	return sum + data;
}

// Calculate 8-bit checksum, 1 byte - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u32 Sum8ByteDMA(u32 sum, u8 data)
{
	return DMA_SUM(DMA_CRC_SUM, sum, DMA_TEMP_CHAN(), &data, 1, DMA_SIZE_8);
}

// Calculate 8-bit checksum, buffer - software version
u32 Sum8BufSoft(u32 sum, const void* buf, int len)
{
	const u8* s = (const u8*)buf;
	for (; len > 0; len--) sum += *s++;
	return sum;
}

// Calculate 8-bit checksum, buffer - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u32 Sum8BufDMA(u32 sum, const void* buf, int len)
{
	return DMA_SUM(DMA_CRC_SUM, sum, DMA_TEMP_CHAN(), buf, len, DMA_SIZE_8);
}

// Calculate 8-bit checksum - software version
//   Calculation speed: 100 us per 1 KB
u32 Sum8Soft(const void* buf, int len)
{
	u32 sum = SUM8_INIT;
	const u8* s = (const u8*)buf;
	for (; len > 0; len--) sum += *s++;
	return sum;
}

// Calculate 8-bit checksum - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
//   Calculation speed: 8 us per 1 KB
u32 Sum8DMA(const void* buf, int len)
{
	return Sum8BufDMA(SUM8_INIT, buf, len);
}

// ============================================================================
//            Simple checksum on 16-bit data with 32-bit result
// ============================================================================

// Calculate 16-bit checksum, 1 word - software version
u32 Sum16WordSoft(u32 sum, u16 data)
{
	return sum + data;
}

// Calculate 16-bit checksum, 1 word - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u32 Sum16WordDMA(u32 sum, u16 data)
{
	return DMA_SUM(DMA_CRC_SUM, sum, DMA_TEMP_CHAN(), &data, 1, DMA_SIZE_16);
}

// Calculate 16-bit checksum, buffer - software version
//   data = pointer to data (must be aligned to u16 entry)
//   num = number of u16 entries
u32 Sum16BufSoft(u32 sum, const u16* buf, int num)
{
	for (; num > 0; num--) sum += *buf++;
	return sum;
}

// Calculate 16-bit checksum, buffer - DMA version (uses DMA_TEMP_CHAN() temporary channel)
//   data = pointer to data (must be aligned to u16 entry)
//   num = number of u16 entries
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u32 Sum16BufDMA(u32 sum, const u16* buf, int num)
{
	return DMA_SUM(DMA_CRC_SUM, sum, DMA_TEMP_CHAN(), buf, num, DMA_SIZE_16);
}

// Calculate 16-bit checksum - software version
//   data = pointer to data (must be aligned to u16 entry)
//   num = number of u16 entries
// Calculation speed: 48 us per 1 KB
u32 Sum16Soft(const u16* buf, int num)
{
	u32 sum = SUM16_INIT;
	for (; num > 0; num--) sum += *buf++;
	return sum;
}

// Calculate 16-bit checksum - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
//   data = pointer to data (must be aligned to u16 entry)
//   num = number of u16 entries
// Calculation speed: 4 us per 1 KB
u32 Sum16DMA(const u16* buf, int num)
{
	return Sum16BufDMA(SUM16_INIT, buf, num);
}

// ============================================================================
//            Simple checksum on 32-bit data with 32-bit result
// ============================================================================

// Calculate 32-bit checksum, 1 double word - software version
u32 Sum32DWordSoft(u32 sum, u32 data)
{
	return sum + data;
}

// Calculate 32-bit checksum, 1 double word - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u32 Sum32DWordDMA(u32 sum, u32 data)
{
	return DMA_SUM(DMA_CRC_SUM, sum, DMA_TEMP_CHAN(), &data, 1, DMA_SIZE_32);
}

// Calculate 32-bit checksum, buffer - software version
//   data = pointer to data (must be aligned to u32 entry)
//   num = number of u32 entries
u32 Sum32BufSoft(u32 sum, const u32* buf, int num)
{
	for (; num > 0; num--) sum += *buf++;
	return sum;
}

// Calculate 32-bit checksum, buffer - DMA version (uses DMA_TEMP_CHAN() temporary channel)
//   data = pointer to data (must be aligned to u32 entry)
//   num = number of u32 entries
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
u32 Sum32BufDMA(u32 sum, const u32* buf, int num)
{
	return DMA_SUM(DMA_CRC_SUM, sum, DMA_TEMP_CHAN(), buf, num, DMA_SIZE_32);
}

// Calculate 32-bit checksum - software version
//   data = pointer to data (must be aligned to u32 entry)
//   num = number of u32 entries
// Calculation speed: 22 us per 1 KB
u32 Sum32Soft(const u32* buf, int num)
{
	u32 sum = SUM32_INIT;
	for (; num > 0; num--) sum += *buf++;
	return sum;
}

// Calculate 32-bit checksum - DMA version (uses DMA_TEMP_CHAN() temporary channel)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
//   data = pointer to data (must be aligned to u32 entry)
//   num = number of u32 entries
// Calculation speed: 2 us per 1 KB
u32 Sum32DMA(const u32* buf, int num)
{
	return Sum32BufDMA(SUM32_INIT, buf, num);
}

// ============================================================================
//                                  CRC-XOR
// ============================================================================

// Calculate CRC-XOR, 1 byte
u16 CrcXorByte(u16 crc, u8 data)
{
	crc = (crc << 1) | (crc >> 15); // rotate 1 bit left with carry to lowest bit
	crc ^= data;
	return crc;
}

// Calculate CRC-XOR, buffer
u16 CrcXorBuf(u16 crc, const void* buf, int len)
{
	const u8* s = (const u8*)buf;
	for (; len > 0; len--)
	{
		crc = (crc << 1) | (crc >> 15); // rotate 1 bit left with carry to lowest bit
		crc ^= *s++;
	}
	return crc;
}

// Calculate CRC-XOR
//   Calculation speed: 160 us per 1 KB
u16 CrcXor(const void* buf, int len)
{
	return CrcXorBuf(CRCXOR_INIT, buf, len);
}

#endif // USE_CRC	// use CRC Check Sum (lib_crc.c, lib_crc.h)

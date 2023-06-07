
// ****************************************************************************
//
//                                Flash memory
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// If core 1 is running, it must be stopped by the lockout procedure while
// the flash memory is being programmed (see sdk_sync.h). Or reset core 1.

#if USE_FLASH	// use Flash memory programming (sdk_flash.c, sdk_flash.h)

#ifndef _SDK_FLASH_H
#define _SDK_FLASH_H

#ifdef __cplusplus
extern "C" {
#endif

#define FLASH_PAGE_SIZE (1u << 8)	// Flash page size 256 B (to program)
#define FLASH_SECTOR_SIZE (1u << 12)	// Flash sector size 4 KB (to erase)
#define FLASH_64KBLOCK_SIZE (1u << 16)	// Flash block size 64 KB (to fast erase)
#define FLASH_32KBLOCK_SIZE (1u << 15)	// Flash block size 32 KB (to fast erase)

// boot 2 loader
#define BOOT2_SIZE_BYTES	256	// boot 2 size in bytes (including CRC)
extern const u32 __boot2_start__[BOOT2_SIZE_BYTES/4];
#define Boot2	__boot2_start__

// check boot 2 crc code, if it is valid
Bool NOINLINE Boot2Check();

// execute flash command
//  txbuf = pointer to byte buffer which will be transmitted to the flash
//  rxbuf = pointer to byte buffer where data receive from the flash
//  count = length in bytes of txbuf and of rxbuf
//void NOFLASH(FlashCmd)(const u8* txbuf, u8* rxbuf, u32 count);

// erase flash memory
//  addr = start address to erase (offset from start of flash XIP_BASE; must be aligned to 4 KB FLASH_SECTOR_SIZE)
//  count = number of bytes to erase (must be multiple of 4 KB FLASH_SECTOR_SIZE)
// If core 1 is running, lockout it or reset it!
void NOFLASH(FlashErase)(u32 addr, u32 count);

// program flash memory
//  addr = start address to program (offset from start of flash XIP_BASE; must be aligned to 256 B FLASH_PAGE_SIZE)
//  data = pointer to source data to program (must be in RAM)
//  count = number of bytes to program (must be multiple of 256 B FLASH_PAGE_SIZE)
// If core 1 is running, lockout it or reset it!
void NOFLASH(FlashProgram)(u32 addr, const u8* data, u32 count);

// get flash unique 64-bit identifier
//   id = pointer to 64-bit array (8 bytes)
//void FlashGetID(u8* id);

#ifdef __cplusplus
}
#endif

#endif // _SDK_FLASH_H

#endif // USE_FLASH	// use Flash memory programming (sdk_flash.c, sdk_flash.h)

// Interface and part of the code taken from PicoLibSDK:
//
// PicoLibSDK - Alternative SDK library for Raspberry Pico and RP2040
// Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz, hardyplotter2@gmail.com
// 	https://github.com/Panda381/PicoLibSDK
//	https://www.breatharian.eu/hw/picolibsdk/index_en.html
//	https://github.com/pajenicko/picopad
//	https://picopad.eu/en/

#ifndef _SDK_FLASH_H
#define _SDK_FLASH_H

#ifdef __cplusplus
extern "C" {
#endif

#define FLASH_PAGE_SIZE (1u << 8)  // Flash page size 256 B (to program)
#define FLASH_SECTOR_SIZE (1u << 12)  // Flash sector size 4 KB (to erase)

#define IMAGE_HEADER_OFFSET BOOTLOADER_SIZE

#define WRITE_ADDR_MIN (IMAGE_HEADER_OFFSET + FLASH_SECTOR_SIZE)
#define ERASE_ADDR_MIN (IMAGE_HEADER_OFFSET)
#define FLASH_ADDR_MAX (PICO_FLASH_SIZE_BYTES)

extern char __flash_binary_end; // linker symbol pointing to the end of the flash binary
extern char __boot2_start__; // linker symbol pointing to the start of the bootloader
extern char __boot2_end__; // linker symbol pointing to the end of the bootloader
extern char __data_start__; // linker symbol pointing to the start of the data section in RAM
extern char __StackLimit, __bss_end__;

// erase flash memory
//  addr = start address to erase (offset from start of flash XIP_BASE; must be aligned to 4 KB FLASH_SECTOR_SIZE)
//  count = number of bytes to erase (must be multiple of 4 KB FLASH_SECTOR_SIZE)
// If core 1 is running, lockout it or reset it!
bool __no_inline_not_in_flash_func(FlashErase)(uint32_t addr, uint32_t count);

// program flash memory
//  addr = start address to program (offset from start of flash XIP_BASE; must be aligned to 256 B FLASH_PAGE_SIZE)
//  data = pointer to source data to program (must be in RAM)
//  count = number of bytes to program (must be multiple of 256 B FLASH_PAGE_SIZE)
// If core 1 is running, lockout it or reset it!
bool __no_inline_not_in_flash_func(FlashProgram)(uint32_t addr, const uint8_t *data, uint32_t count);

#ifdef __cplusplus
}
#endif

#endif // _SDK_FLASH_H
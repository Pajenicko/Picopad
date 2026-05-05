// Interface and part of the code taken from PicoLibSDK:
//
// PicoLibSDK - Alternative SDK library for Raspberry Pico and RP2040
// Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz, hardyplotter2@gmail.com
// 	https://github.com/Panda381/PicoLibSDK
//	https://www.breatharian.eu/hw/picolibsdk/index_en.html
//	https://github.com/pajenicko/picopad
//	https://picopad.eu/en/

#include "picopad.h"
#include "sdk_flash.h"

const uint32_t MAX_DATA_LEN = 1024; //FLASH_SECTOR_SIZE;

// erase flash memory
//  addr = start address to erase (offset from start of flash XIP_BASE; must be aligned to 4 KB FLASH_SECTOR_SIZE)
//  count = number of bytes to erase (must be multiple of 4 KB FLASH_SECTOR_SIZE)
// If core 1 is running, lockout it or reset it!
bool __no_inline_not_in_flash_func(FlashErase)(uint32_t addr, uint32_t count) {
	if ((addr < ERASE_ADDR_MIN) || (addr + count >= FLASH_ADDR_MAX)) {
		// Outside flash
		return false;
	}

	if ((addr & (FLASH_SECTOR_SIZE - 1)) || (count & (FLASH_SECTOR_SIZE - 1))) {
		// Must be aligned
		return false;
	}

	uint32_t uirq_status = save_and_disable_interrupts();
	flash_range_erase(addr, count);
	restore_interrupts(uirq_status);

	return true;
}

// program flash memory
//  addr = start address to program (offset from start of flash XIP_BASE; must be aligned to 256 B FLASH_PAGE_SIZE)
//  data = pointer to source data to program (must be in RAM)
//  count = number of bytes to program (must be multiple of 256 B FLASH_PAGE_SIZE)
// If core 1 is running, lockout it or reset it!
bool __no_inline_not_in_flash_func(FlashProgram)(uint32_t addr, const uint8_t *data, uint32_t count) {
	if ((addr < WRITE_ADDR_MIN) || (addr + count >= FLASH_ADDR_MAX)) {
		// Outside flash
		return false;
	}

	if ((addr & (FLASH_PAGE_SIZE - 1)) || (count & (FLASH_PAGE_SIZE - 1))) {
		// Must be aligned
		return false;
	}

	if (count > MAX_DATA_LEN) {
		return false;
	}

	uint32_t uirq_status = save_and_disable_interrupts();
	flash_range_program(addr, data, count);
	restore_interrupts(uirq_status);

	return true;
}

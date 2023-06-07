
// ****************************************************************************
//
//                                Flash memory
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_FLASH	// use Flash memory programming (sdk_flash.c, sdk_flash.h)

#include "../inc/sdk_flash.h"
#include "../inc/sdk_cpu.h"
#include "../inc/sdk_qspi.h"
#include "../inc/sdk_bootrom.h"
#include "../../_lib/inc/lib_crc.h"

#define FLASH_64KBLOCK_ERASE_CMD 0xd8	// flash erase command of 64KB block
#define FLASH_32KBLOCK_ERASE_CMD 0x52	// flash erase command of 32KB block

// check boot 2 crc code, if it is valid
Bool NOINLINE Boot2Check()
{
	int i;
	u32 crc = Crc32ASlow(Boot2, BOOT2_SIZE_BYTES-4);
	return crc == Boot2[BOOT2_SIZE_BYTES/4-1];
}

// erase flash memory
//  addr = start address to erase (offset from start of flash XIP_BASE; must be aligned to 4 KB FLASH_SECTOR_SIZE)
//  count = number of bytes to erase (must be multiple of 4 KB FLASH_SECTOR_SIZE)
// If core 1 is running, lockout it or reset it!
void NOFLASH(FlashErase)(u32 addr, u32 count)
{
	// check boot 2 loader (this function can be run from Flash memory)
	Bool ok = Boot2Check();

	// copy boot 2 loader into temporary buffer - it is located in the stack, but it will fit OK
	u32 boot2[BOOT2_SIZE_BYTES/4-1];
	memcpy(boot2, Boot2, BOOT2_SIZE_BYTES-4);

	// compiler barrier
	cb();

	// disable interrupts
	IRQ_LOCK;

	// restore QSPI to default and connect SSI to QSPI pads
	FlashInternal();

	// exit XIP mode to SSI
	FlashExitXip();

	// erase flash memory (first erase 32KB block)
	if (((addr & 0xffff) == FLASH_32KBLOCK_SIZE) || (count < FLASH_64KBLOCK_SIZE))
	{
		RomFlashErase(addr, FLASH_32KBLOCK_SIZE, FLASH_32KBLOCK_SIZE, FLASH_32KBLOCK_ERASE_CMD);
		addr += FLASH_32KBLOCK_SIZE;
		count -= FLASH_32KBLOCK_SIZE;
	}
	if (count > 0) RomFlashErase(addr, count, FLASH_64KBLOCK_SIZE, FLASH_64KBLOCK_ERASE_CMD);

	// flush flash cache (and remove CSn IO force)
	FlashFlush();

	// check if boot 2 loader is valid
	if (ok && (boot2[0] != 0) && (boot2[0] != (u32)-1))
	{
		// run boot 2 loader to restore XIP flash settings
		((void(*)(void))boot2+1)();
	}
	else
		// enter XIP mode
		FlashEnterXip();

	// enable interrupts
	IRQ_UNLOCK;
}

// program flash memory
//  addr = start address to program (offset from start of flash XIP_BASE; must be aligned to 256 B FLASH_PAGE_SIZE)
//  data = pointer to source data to program (must be in RAM)
//  count = number of bytes to program (must be multiple of 256 B FLASH_PAGE_SIZE)
// If core 1 is running, lockout it or reset it!
void NOFLASH(FlashProgram)(u32 addr, const u8* data, u32 count)
{
	// check boot 2 loader (this function can be run from Flash memory)
	Bool ok = Boot2Check();

	// copy boot 2 loader into temporary buffer - it is located in the stack, but it will fit OK
	u32 boot2[BOOT2_SIZE_BYTES/4-1];
	memcpy(boot2, Boot2, BOOT2_SIZE_BYTES-4);

	// compiler barrier
	cb();

	// disable interrupts
	IRQ_LOCK;

	// restore QSPI to default and connect SSI to QSPI pads
	FlashInternal();

	// exit XIP mode to SSI
	FlashExitXip();

	// erase flash memory
	RomFlashProgram(addr, data, count);

	// flush flash cache (and remove CSn IO force)
	FlashFlush();

	// check if boot 2 loader is valid
	if (ok && (boot2[0] != 0) && (boot2[0] != (u32)-1))
	{
		// run boot 2 loader to restore XIP flash settings
		((void(*)(void))boot2+1)();
	}
	else
		// enter XIP mode
		FlashEnterXip();

	// enable interrupts
	IRQ_UNLOCK;
}

/*
// execute flash command
//  txbuf = pointer to byte buffer which will be transmitted to the flash
//  rxbuf = pointer to byte buffer where data receive from the flash
//  count = length in bytes of txbuf and of rxbuf
void NOFLASH(FlashCmd)(const u8* txbuf, u8* rxbuf, u32 count)
{
	// check boot 2 loader (this function can be run from Flash memory)
	Bool ok = Boot2Check();

	// copy boot 2 loader into temporary buffer - it is located in the stack, but it will fit OK
	u32 boot2[BOOT2_SIZE_BYTES/4-1];
	memcpy(boot2, Boot2, BOOT2_SIZE_BYTES-4);

	// compiler barrier
	cb();

	// disable interrupts
	IRQ_LOCK;

	// restore QSPI to default and connect SSI to QSPI pads
	FlashInternal();

	// exit XIP mode to SSI
	FlashExitXip();

	// set CS to LOW (using IO overrides, like bootom does)
	QSPI_OutOverLow(QSPI_PIN_SS);

	// prepare counters
	u32 tx_count = count;
	u32 rx_count = count;

	// process data
	while ((tx_count > 0) || (rx_count > 0))
	{
		// get flags
//		u32 flags = 

	@TODO

// !!!!!!!!!!!!!!!!!!!!!
  	}


	// set CS to HIGH (using IO overrides, like bootom does)
	QSPI_OutOverHigh(QSPI_PIN_SS);




}

// get flash unique 64-bit identifier
//   id = pointer to 64-bit array (8 bytes)
void FlashGetID(u8* id)
{

	@TODO

}
*/

#endif // USE_FLASH	// use Flash memory programming (sdk_flash.c, sdk_flash.h)

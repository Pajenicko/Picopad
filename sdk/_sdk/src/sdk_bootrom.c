
// ****************************************************************************
//
//                                Boot ROM
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals
#include "../inc/sdk_bootrom.h"

/* Start of ROM
__vectors:
0x0000: .word _stacktop // MSP
0x0004: .word _start    // Reset
0x0008: .word _nmi      // NMI
0x000C: .word _dead     // HardFault

_magic:
0x0010: .byte 'M', 'u'
# compatibility version
0x0012: .byte 1		// bootrom compatibility
# ROM version
0x0013: .byte 2		// bootrom version (1..3)

_well_known:
0x0014: .hword function_table
0x0016: .hword data_table
0x0018: .hword table_lookup + 1
*/

// ROM function pointers (60 bytes)
pPopCount	popcount;
pReverse	reverse;
pClz		clz;
pCtz		ctz;
pMemSet		MemSet;
pMemSet32	MemSet32;
pMemCopy	MemCopy;
pMemCopy32	MemCopy32;
pResetUsb	ResetUsb;
pFlashInternal	FlashInternal;
pFlashExitXip	FlashExitXip;
pFlashErase	RomFlashErase;
pFlashProgram	RomFlashProgram;
pFlashFlush	FlashFlush;
pFlashEnterXip	FlashEnterXip;

// find ROM function given by the code (returns NULL if not found)
void* RomFunc(u16 code)
{
	// prepare pointer to lookup function (.hword table_lookup + 1)
	pTableLookup lookup = (pTableLookup)ROM_HWORD_PTR(0x18);

	// prepare pointer to table with functions (.hword function_table)
	u16* tab = (u16*)ROM_HWORD_PTR(0x14);

	// search function
	return lookup(tab, code);
}

// find ROM data given by the code (returns NULL if not found)
void* RomData(u16 code)
{
	// prepare pointer to lookup function (.hword table_lookup + 1)
	pTableLookup lookup = (pTableLookup)ROM_HWORD_PTR(0x18);

	// prepare pointer to table with data (.hword data_table)
	u16* tab = (u16*)ROM_HWORD_PTR(0x16);

	// search function
	return lookup(tab, code);
}

// initialize ROM functions
void RomFncInit()
{
	popcount = (pPopCount)RomFunc(ROM_FUNC_POPCOUNT32);
	reverse = (pReverse)RomFunc(ROM_FUNC_REVERSE32);
	clz = (pClz)RomFunc(ROM_FUNC_CLZ32);
	ctz = (pCtz)RomFunc(ROM_FUNC_CTZ32);
	MemSet = (pMemSet)RomFunc(ROM_FUNC_MEMSET);
	MemSet32 = (pMemSet32)RomFunc(ROM_FUNC_MEMSET4);
	MemCopy = (pMemCopy)RomFunc(ROM_FUNC_MEMCPY);
	MemCopy32 = (pMemCopy32)RomFunc(ROM_FUNC_MEMCPY44);
	ResetUsb = (pResetUsb)RomFunc(ROM_FUNC_RESET_USB_BOOT);
	FlashInternal = (pFlashInternal)RomFunc(ROM_FUNC_CONNECT_INTERNAL_FLASH);
	FlashExitXip = (pFlashExitXip)RomFunc(ROM_FUNC_FLASH_EXIT_XIP);
	RomFlashErase = (pFlashErase)RomFunc(ROM_FUNC_FLASH_RANGE_ERASE);
	RomFlashProgram = (pFlashProgram)RomFunc(ROM_FUNC_FLASH_RANGE_PROGRAM);
	FlashFlush = (pFlashFlush)RomFunc(ROM_FUNC_FLASH_FLUSH_CACHE);
	FlashEnterXip = (pFlashEnterXip)RomFunc(ROM_FUNC_FLASH_ENTER_CMD_XIP);
}


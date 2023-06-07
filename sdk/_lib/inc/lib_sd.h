
// ****************************************************************************
//                                 
//                                 SD card
//
// ****************************************************************************
/*
SD card pinout:
    / 1 2 3 4 5 6 7 8 |
   /9                 |
  |                   |
  |                   |
   -------------------

1 CD/DAT3, CS <- SD_CS (chip select)
2 CMD, DATA_IN <- SD_TX (MOSI, data from MCU to SD)
3 VSS1, GND
4 VDD, 3.3V power
5 CLK, SCK <- SD_SCK (clock from MCU to SD)
6 VSS2, GND
7 DAT0, DATA_OUT -> SD_RX (MISO, data from SD to MCU)
8 DAT1
9 DAT2
*/

#if USE_SD		// use SD card (lib_sd.c, lib_sd.h)

#ifndef _SD_H
#define _SD_H

#ifdef __cplusplus
extern "C" {
#endif

// SD card type
enum {
	SD_NONE = 0,	// unknown type
	SD_MMC = 1,	// MMC
	SD_SD1 = 2,	// SD v1
	SD_SD2 = 3, 	// SD v2
	SD_SDHC = 4, 	// SDHC, block device
};

// SD card type (SD_NONE,...)
extern u8 SDType;

// get SD card type name
const char* GetSDName();

// connect to SD card after inserting (returns False on error)
Bool SDConnect();

// disconnect SD card
void SDDisconnect();

// read one sector from SD card (returns False on error)
Bool SDReadSect(u32 sector, u8* buffer);

// write one sector to SD card (returns False on error)
Bool SDWriteSect(u32 sector, const u8* buffer);

// get media size (in number of sectors; returns 0 on error)
u32 SDMediaSize();

// check if disk is valid
INLINE Bool DiskValid() { return SDType != SD_NONE; }

// initialize SD card interface (must be re-initialized after changing system clock)
void SDInit();

// terminate SD card interface
void SDTerm();

#ifdef __cplusplus
}
#endif

#endif // _SD_H

#endif // USE_SD		// use SD card (lib_sd.c, lib_sd.h)

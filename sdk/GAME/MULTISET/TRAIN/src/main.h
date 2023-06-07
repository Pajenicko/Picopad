
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

// format: 4-bit paletted pixel graphics
// image width: 320 pixels
// image height: 176 lines
// image pitch: 160 bytes
extern const u16 TilesImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 TilesImg[28160] __attribute__ ((aligned(4)));
#define TILESIMGW	320
#define TILESNUMX	20	// number of tiles in X direction

// sounds
extern const u8 CollectSnd[3642];
extern const u8 CrashSnd[50146];
extern const u8 StepSnd[2243];
extern const u8 SuccessSnd[32784];

#endif // _MAIN_H

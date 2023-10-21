
// ****************************************************************************
//
//                                 Data and tables
//
// ****************************************************************************

#ifndef _DATA_H
#define _DATA_H

#include "include.h"

// format: 4-bit paletted pixel graphics
// image width: 144 pixels
// image height: 34 lines
// image pitch: 72 bytes
extern const u16 LogoImg_Pal[7] __attribute__ ((aligned(4)));
extern const u8 LogoImg[2448] __attribute__ ((aligned(4)));
#define LOGOW 144
#define LOGOH 34

// format: 4-bit paletted pixel graphics
// image width: 1360 pixels
// image height: 20 lines
// image pitch: 680 bytes
extern const u16 SpritesImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 SpritesImg[13600] __attribute__ ((aligned(4)));
#define SPRITEW 20
#define SPRITEH 20
#define SPRITEIMGW 1360

// format: 4-bit paletted pixel graphics
// image width: 99 pixels
// image height: 11 lines
// image pitch: 50 bytes
extern const u16 StatusImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 StatusImg[550] __attribute__ ((aligned(4)));
#define STATUSW 11
#define STATUSH 11
#define STATUSIMGW 99

// format: 4-bit paletted pixel graphics
// image width: 430 pixels
// image height: 10 lines
// image pitch: 215 bytes
extern const u16 TilesImg_Pal[5] __attribute__ ((aligned(4)));
extern const u8 TilesImg[2150] __attribute__ ((aligned(4)));
#define TILEW 10
#define TILEH 10
#define TILESIZE 10
#define TILESIMGW 430

// sound format: PCM mono 8-bit 22050Hz
extern const u8 StartSnd[94852];
extern const u8 SirenSnd[9460];
extern const u8 WakkaSnd[6391];
extern const u8 FrightenSnd[5872];
extern const u8 EatGhostSnd[12879];
extern const u8 DeathSnd[33832];
extern const u8 EatFruitSnd[9690];
extern const u8 ExtraPacSnd[41880];
extern const u8 IntermissionSnd[114754];

// game board
extern ALIGNED u8 Board[MAPSIZE];

// animation phase 0..3
extern u8 Phase;

// pacman next direction
extern u8 NextDir;

// current and max score
extern u32 Score;
extern u32 MaxScore;
extern int Level; // current level 0...
extern s8 Lives; // remaining lives
extern int FrightenCnt; // frighten counter
extern int Eaten; // next eaten points
extern int ScatterCnt; // scatter counter
extern int ChaseCnt; // chase counter
extern u8 ScatterTabNext; // next entry in scatter-chasse table
extern int DotCnt; // eaten dot counter
extern int FruitCnt; // fruit counter
extern u32 DispNextTime; // display next time

// level scatter-chasse time table: 5 levels x 4 pairs of 2 entries (scatter and chasse in number of seconds, 0=permanently)
extern const u8 ScatterTab[5*4*2];

// pellet blink counter
extern u8 Blink;

// level fruit table
extern const u8 FruitTab[FRUITTABMAX];

// bonus table
extern const u16 BonusTab[8];

// level frighten time table (number of seconds)
extern const u8 FrightenTab[FRIGHTENTABMAX];

// game board template (to edit, view tiles_num.bmp with tile indices)
extern const u8 BoardTemp[MAPSIZE];

// bonus fruit sprite
extern int FruitSpriteImg; // -1 = not visible
extern int FruitSpriteX;
extern int FruitSpriteY;

// character descriptor
extern sChar Chars[5];

// direction vector
extern const s8 DirX[4];
extern const s8 DirY[4];

// sprite characters indices: 9 characters * 4 directions * 4 animation phase
extern const u8 SpriteInx[CHAR_NUM * DIR_NUM * PHASENUM];

// decode number buffer
extern char NumBuf[15];

#endif // _DATA_H

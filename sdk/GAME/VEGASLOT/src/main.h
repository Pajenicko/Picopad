
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

#define SYMBOLW		64		// symbol width
#define SYMBOLH		48		// symbol height
#define SYMBOL_NUM	6		// number of symbol types

#define REEL_NUM	3		// number of reels
#define REEL_POS	32		// number of reel positions
#define REELW		SYMBOLW		// reel width
#define REELH		(3*SYMBOLH)	// reel height (= 144)
#define REELALLW	(REEL_NUM*REELW) // width of all reels
#define REEL1X		64		// X coordinate of first reel
#define REEL2X		(64+REELW)	// X coordinate of second reel (= 128)
#define REEL3X		(64+2*REELW)	// X coordinate of third reel (= 192)
#define REELY		48		// Y coordinate of reels

#define REELSTATE_IN	1		// reel state: turning in
#define REELSTATE_OUT	2		// reel state: turning out
#define REELSTATE_OVER	3		// reel state: turning overshoot

#define REEL_TIMEINC	80		// reel time increment of one animation step in [m]
#define REEL_SLOWSPEED	100		// slow speed
#define REEL_STARTDEL	2		// start delay in number of steps
#define REEL_ACCEL	5		// acceleration/deceleration
#define REEL_OVERSTEPS	150		// overshoot steps
#define REEL_BLURSPEED	200		// speed for blur image

#define REELDIR_FORW	1		// reel direction forward (down), normal direction
#define REELDIR_BACK	0		// reel direction back (up), special direction

#define BET_HIGH	6		// bet max value = high game

#define MAXWIN		750		// max. win value

// reel descriptor
typedef struct {

// Reel position means "position of symbol on reel on line 0" * 256

	int	state;	// reel current state REELSTATE_*
	int	dir;	// reel turning direction REELDIR_*
	int	speed;	// current speed

	int	pos;	// reel current position * 256
	int	dest;	// destination position * 256
	int	rem;	// remaining steps * 256
	int	wait;	// wait time to start in [ms]
	int	over;	// overshoot steps * 256
	int	past;	// pasting steps * 256
} sReel;

#define DIGITW		16		// digit width
#define DIGITH		24		// digit height
#define DIGITY		16		// digit Y coordinate
#define BANKX		40		// BANK X coordinate
#define BANKNUM		4		// BANK number of digits
#define WINX		120		// WIN X coordinate
#define WINNUM		3		// WIN number of digits
#define BETX		184		// BET X coordinate
#define BETNUM		1		// BET number of digits
#define CREDITX		216		// CREDIT X coordinate
#define CREDITNUM	4		// CREDIT number of digits

// Symbols:
#define CHE		0	// cherry
#define APP		1	// apple
#define PLU		2	// plum
#define PEA		3	// pear
#define GRA		4	// grape
#define BEL		5	// bell

#define WIN_LINES	5		// number of winning lines
#define SYM_MASK	0x07	// symbol mask (3 bits, value 0..5)
#define POS_MASK	0x1f	// position mask (5 bits, value 0..31)
#define POSH_MASK	0x1fff	// position mask * 256

// winning item
typedef struct {
	u16		value;			// value of win prize (1 to 750)
	u16		type;			// winning type (which symbols are on winlines)
							//   bit 0..2 (3 bits): symbol 1
							//   bit 3..5 (3 bits): number of lines with symbol 1
							//   bit 6..8 (3 bits): symbol 2
							//   bit 9..11 (3 bits): number of lines with symbol 2
							//   bit 12..14 (3 bits): symbol 3
							//   bit 15 (1 bit): number of lines with symbol 3
							//		Note: If there are 3 different symbols on the winlines,
							//				the symbol 3 can only appear on 1 line, so the
							//				number of lines of the symbol 3 is determined
							//				by 1 bit only.
	u16		num;			// number of wins
	u16		rand;			// randomness (0 to 0xffff)
} sWinItem;

// Symbols on reels
//   CHE=cherry, APP=apple, PLU=plum, PEA=pear, GRA=grape, BEL=bell
extern const u8 ReelTab[REEL_NUM*REEL_POS];

// Winning values
extern const u16 WinValTab[SYMBOL_NUM];

// List of winning tables
extern const sWinItem* const WinTabs[WIN_LINES];

// format: compressed 8-bit paletted pixel graphics
// image width: 320 pixels
// image height: 240 lines
// image pitch: 320 bytes
extern const u16 BackImg_Pal[256] __attribute__ ((aligned(4)));
extern const u8 BackImg[26241] __attribute__ ((aligned(4)));

// format: 8-bit paletted pixel graphics
// image width: 64 pixels
// image height: 288 lines
// image pitch: 64 bytes
extern const u16 SymbolsImg_Pal[256] __attribute__ ((aligned(4)));
extern const u8 SymbolsImg[18432] __attribute__ ((aligned(4)));

// format: 8-bit paletted pixel graphics
// image width: 64 pixels
// image height: 288 lines
// image pitch: 64 bytes
extern const u16 BlurImg_Pal[256] __attribute__ ((aligned(4)));
extern const u8 BlurImg[18432] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 192 pixels
// image height: 24 lines
// image pitch: 96 bytes
extern const u16 DigitsImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 DigitsImg[2304] __attribute__ ((aligned(4)));
#define DIGITIMGW	192	// width of digit image

// sound format: PCM mono 8-bit 22050Hz
extern const u8 AutoOffSnd[7333];
extern const u8 AutoOnSnd[7333];
extern const u8 CashSnd[5439];
extern const u8 OutSnd[20792];
extern const u8 ReelSnd[1939];
extern const u8 RiskLostSnd[2208];
extern const u8 RiskWinSnd[1897];
extern const u8 StartSnd[3883];
extern const u8 StopSnd[2608];
extern const u8 TossSnd[5620];
extern const u8 TransferSnd[2201];
extern const u8 WinSnd[15008];

#endif // _MAIN_H

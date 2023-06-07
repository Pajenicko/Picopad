
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

#define TILEW	24		// tile width
#define TILEH	24		// tile height
#define MAPW	10		// map width
#define MAPH	10		// map height
#define MAPSIZE	(MAPW*MAPH)	// map size (= 100 tiles)
#define BOARDW	(MAPW*TILEW)	// board width in pixels (= 240)
#define BOARDH	(MAPH*TILEH)	// board height in pixels (= 240)
#define INFOW	(WIDTH-BOARDW)	// width of info box (= 80)
#define INFOX	BOARDW		// X coordinate of info box

#define INFOBG	RGBTO16(16, 16, 16) // info background color

#define PLAYER_OFF	0	// player is OFF
#define PLAYER_HUMAN	1	// player is human
#define PLAYER_COMP	2	// player is computer

#define PLAYER_NUM	5	// number of players

typedef struct {
	u8	type;		// player type PLAYER_*
	u8	start;		// index of start position
	u8	scorey;		// score Y coordinate
	u8	cursor;		// current cursor
	u16	color;		// player color
	int	atoms;		// number of atoms (0 = player loses and was eliminated from the game)
} sPlayer;

// format: 4-bit paletted pixel graphics
// image width: 24 pixels
// image height: 504 lines
// image pitch: 12 bytes
extern const u16 AtomsImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 AtomsImg[6048] __attribute__ ((aligned(4)));

// sound format: PCM mono 8-bit 22050Hz
extern const u8 CrashSnd[2324];

#endif // _MAIN_H

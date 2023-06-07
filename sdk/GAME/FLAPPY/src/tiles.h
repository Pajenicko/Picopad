
// ****************************************************************************
//
//                                 Tiles
//
// ****************************************************************************

#ifndef _TILES_H
#define _TILES_H

// format: 4-bit paletted pixel graphics
// image width: 128 pixels
// image height: 176 lines
// image pitch: 64 bytes
extern const u16 TilesImg_Pal[4] __attribute__ ((aligned(4)));
extern const u8 TilesImg[11264] __attribute__ ((aligned(4)));
#define  TILESALLW	128	// tiles total width

// tile descriptor (all values are multiply of STEP)
typedef struct {
	u8	y;		// source Y coordinate
	u8	x;		// source X coordinate
	u8	w;		// width
	u8	h;		// height
} sTile;

// tiles indices
#define SPACETILE		0	// empty tile, space character
#define WALLTILE		1	// red wall
#define BLUEWALLTILE		2	// blue wall
#define CHICKENDOWN1		3	// chicken down 1
#define CHICKENDOWN2		4	// chicken down 2
#define CHICKENDOWN3		5	// chicken down 3
#define CHICKENDOWNFIRE1 	6	// chicken down fire 1
#define CHICKENDOWNFIRE2	7	// chicken down fire 2
#define CHICKENUP1		8	// chicken up 1
#define CHICKENUP2		9	// chicken up 2
#define CHICKENUP3		10	// chicken up 3
#define CHICKENUPFIRE1		11	// chicken up fire 1
#define CHICKENUPFIRE2		12	// chicken up fire 2
#define CHICKENLEFT1		13	// chicken left 1
#define CHICKENLEFT2		14	// chicken left 2
#define CHICKENLEFTFIRE1	15	// chicken left fire 1
#define CHICKENLEFTFIRE2	16	// chicken left fire 2
#define CHICKENRIGHT1		17	// chicken right 1
#define CHICKENRIGHT2		18	// chicken right 2
#define CHICKENRIGHTFIRE1	19	// chicken right fire 1
#define CHICKENRIGHTFIRE2	20	// chicken right fire 2
#define CHICKENCRASH		21	// chicken crash
#define CHICKENEATEN1		22	// chicken eaten 1
#define CHICKENEATEN2		23	// chicken eaten 2
#define CHICKENJUMPING1		24	// chicken jumping 1 (high)
#define CHICKENJUMPING2		25	// chicken jumping 2 (low)
#define CHICKENGOHOME		26	// chicken go home
#define MUSHROOMTILE		27	// mushroom
#define BLUEENEMYLEFT1		28	// blue enemy left 1
#define BLUEENEMYLEFT2		29	// blue enemy left 2
#define BLUEENEMYRIGHT1		30	// blue enemy right 1
#define BLUEENEMYRIGHT2		31	// blue enemy right 2
#define BLUEENEMYCRASH		32	// blue enemy crash
#define BLUEENEMYSLEEP1		33	// blue enemy sleep 1
#define BLUEENEMYSLEEP2		34	// blue enemy sleep 2
#define BLUEENEMYSLEEP3		35	// blue enemy sleep 3
#define BLUEENEMYSLEEP4		36	// blue enemy sleep 4
#define BLUEENEMYSLEEP5		37	// blue enemy sleep 5
#define BLUEENEMYSLEEP6		38	// blue enemy sleep 6
#define REDENEMYDOWN1		39	// red enemy down 1
#define REDENEMYDOWN2		40	// red enemy down 2
#define REDENEMYDOWN3		41	// red enemy down 3
#define REDENEMYUP1		42	// red enemy up 1
#define REDENEMYUP2		43	// red enemy up 2
#define REDENEMYUP3		44	// red enemy up 3
#define REDENEMYCRASH		45	// red enemy crash
#define REDENEMYLEFT1		46	// red enemy left 1
#define REDENEMYRIGHT1		47	// red enemy right 1
#define REDENEMYLEFT2		48	// red enemy left 2
#define REDENEMYRIGHT2		49	// red enemy right 2
#define REDENEMYSLEEP1		50	// red enemy sleep 1
#define REDENEMYSLEEP2		51	// red enemy sleep 2
#define REDENEMYSLEEP3		52	// red enemy sleep 3
#define REDENEMYSLEEP4		53	// red enemy sleep 4
#define REDENEMYSLEEP5		54	// red enemy sleep 5
#define REDENEMYSLEEP6		55	// red enemy sleep 6
#define NOENEMYSLEEP1		56	// no enemy sleep 1
#define NOENEMYSLEEP2		57	// no enemy sleep 2
#define NOENEMYSLEEP3		58	// no enemy sleep 3
#define NOENEMYSLEEP4		59	// no enemy sleep 4
#define ARROWUP			60	// arrow up
#define ARROWRIGHT		61	// arrow right
#define ARROWDOWN		62	// arrow down
#define ARROWLEFT		63	// arrow left
#define BLUEBALLTILE		64	// blue ball
#define REDBALLTILE		65	// red ball
#define BALLCRASH1		66	// red ball crash 1
#define BALLCRASH2		67	// red ball crash 2
#define BALLCRASH3		68	// red ball crash 3
#define BALLCRASH4		69	// red ball crash 4
#define TEXTGAME		70	// text GAME
#define TEXTOVER		71	// text OVER
#define TEXTSPACE		72	// text SPACE
#define TEXTREDSCENE		73	// red text SCENE
#define TEXTYELSCENE		74	// yellow text SCENE
#define TEXTTIME		75	// text TIME
#define TEXTSCORE		76	// text SCORE
#define DIGIT0			77	// digit 0
#define DIGIT1			78	// digit 1
#define DIGIT2			79	// digit 2
#define DIGIT3			80	// digit 3
#define DIGIT4			81	// digit 4
#define DIGIT5			82	// digit 5
#define DIGIT6			83	// digit 6
#define DIGIT7			84	// digit 7
#define DIGIT8			85	// digit 8
#define DIGIT9			86	// digit 9
#define TEXTDBSOFT		87	// text dB-SOFT
#define TEXTBYSSKO		88	// text by-SSKO

#define TILES_NUM		89	// number of tiles

// Tiles (y, x, w, h)
extern const sTile Tiles[TILES_NUM];

// display tile, including header
void DispTile(u8 tile, int x, int y);

// clear tile, including header
void ClearTile(u8 tile, int x, int y);

#endif // _TILES_H

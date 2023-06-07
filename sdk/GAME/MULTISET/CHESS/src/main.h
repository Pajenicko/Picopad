
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************
// The names of chess pieces are: pawn, knight, bishop, rook, queen and king.

#ifndef _MAIN_H
#define _MAIN_H

//#define DEBUG_STACK	// debug flag - display stack max. depth

/* Reached max. stack:
BEGINNER (2 forward moves) ... 80
ADVANCED (3 forward moves) ... 110
PRO (4 forward moves, 10 seconds) ... 180
SUPERPRO (5 forward moves, 2 minutes) ... 200
EXTRA (6 forward moves, 1 hour)
*/

// text console
#define FONTW	8	// font width
#define FONTH	16	// font height
#define TEXTX	240	// text X coordinate
#define TEXTW	10	// text width (10 characters, 80 pixels)
#define TEXTH	15	// text height (15 rows, 240 pixels)
#define TEXTS (TEXTW*TEXTH) // size of text buffer

// field tile
#define TILEW	28	// tile width
#define TILEH	28	// tile height

// board map in fields
#define MAP0W	8	// board visible width in fields, without border
#define MAP0H	8	// board visible height in fields, without border
#define MAPW	(MAP0W+2) // board internal width in fields, with border 1+1 columns (= 10)
#define MAPH	(MAP0H+4) // board internal height in fields, with border 2+2 rows (= 12)
#define MAPSIZE (MAPW*MAPH) // board internal size in fields (= 120)

// visible board
#define FRAME	8	// frame width
#define BOARDX	FRAME	// board X coordinate
#define BOARDY	FRAME	// board Y coordinate
#define BOARDW (2*FRAME + MAP0W*TILEW) // board total width (= 240)
#define BOARDH (2*FRAME + MAP0H*TILEH) // board total height (= 240)

#define FRAMECOL	RGBTO16(200, 0, 0) // border color
#define LEGENDCOL	COL_WHITE // frame text color

// piece indices
#define EMPTY	0	// empty field (or black pawn)
#define PAWN	1	// pawn (or white pawn)
#define KNIGHT	2	// knight
#define BISHOP	3	// bishop
#define ROOK	4	// rook
#define QUEEN	5	// queen
#define KING	6	// king
#define BORDER	7	// invalid field
#define PIECEMASK 7	// mask of piece value

#define MOVEMASK B4	// flag of moving piece
#define MOVING	0	// piece has been moving
#define NOMOVING MOVEMASK // piece has not been moving yet

#define COLORMASK B5	// mask of piece color
#define WHITE	0	 // white color of piece
#define BLACK	COLORMASK // black color of piece

// player
typedef struct {
	Bool	comp;		// player is computer
	u8	curpos;		// current cursor position
	u8	king;		// king position
} sPlayer;

#define WHITE_PLAYER	0	// index of white player
#define BLACK_PLAYER	1	// index of black player

// move stack entry (8 bytes)
typedef struct {
	u8	src;		// source position
	u8	dst;		// destination position
	u8	srcpiece;	// source piece (including original NOMOVING flag)
	u8	dstpiece;	// old content of destination field (with color)
	u8	flags;		// flags MOVEFLAG_*
	u8	extra;		// additional data: new piece to change from pawn, En Passant position
	s16	val;		// move value
} sMove;

#define VAL_WIN		10000	// winning value

// move flags
#define MOVEFLAG_NORMAL		0	// normal move
#define MOVEFLAG_QUEEN		1	// change pawn to queen (= piecenew)
#define MOVEFLAG_SMALL		2	// make small castle
#define MOVEFLAG_BIG		3	// make big castle
#define MOVEFLAG_EP		4	// en passant privilege

#define STACK_MAX	500	// max. size of move stack
#define DEEP_MAX	5	// max. deep in move stack

// format: 4-bit paletted pixel graphics
// image width: 196 pixels
// image height: 224 lines
// image pitch: 98 bytes
extern const u16 PiecesImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 PiecesImg[21952] __attribute__ ((aligned(4)));
#define PIECESIMGW	196	// width of image

#endif // _MAIN_H

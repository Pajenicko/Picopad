
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************
// To check chess engine: use StockFish

#include "../include.h"

// text console
char TextBuf[TEXTS+1];
int TextRows = 0;

// view to board (WHITE_PLAYER or BLACK_PLAYER)
u8 PlayerView;

// game board with border (order of fields: from field A1 to field H8)
u8 Board[MAPSIZE];

// available moves
Bool BoardEnable[MAPSIZE];

//#ifdef DEBUG_STACK	// debug flag - display stack max. depth
//int MoveStackTopMax; // number of entries
//#endif

// move stack
sMove MoveStack[STACK_MAX];
int MoveStackTop; // number of entries
const sMove* LastMove; // last move (NULL = check-mat)

// start entries and number of entries in move stack
int MoveStackStart[DEEP_MAX]; // start indices
int MoveStackNum[DEEP_MAX]; // number of moves in one deep level
int MoveStackInx[DEEP_MAX]; // current index in move stack
u8 MovePassantPiece[DEEP_MAX+1]; // position of piece to En Passant (0 = invalid)
u8 MovePassantPos[DEEP_MAX+1]; // capture position of piece to En Passant (0 = invalid)
int MoveDeep; // current deep in move stack
int DeepMax;

// player
u8 Player;	// current player (WHITE_PLAYER or BLACK_PLAYER)
//u8 Enemy;	// color of other player (WHITE_PLAYER or BLACK_PLAYER)
sPlayer Players[2]; // players

int MoveNum;	// move counter (current move 1..)
u32 BlinkTime; // cursor blinking time

// board template with border (from A1 to H8)
const u8 BoardTemp[MAPSIZE] = {
//	0		1		2		3		4		5		6		7		8		9
/*00*/	BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		// 00
/*10*/	BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		// 10
/*20*/	BORDER,		ROOK+WHITE,	KNIGHT+WHITE,	BISHOP+WHITE,	QUEEN+WHITE,	KING+WHITE,	BISHOP+WHITE,	KNIGHT+WHITE,	ROOK+WHITE,	BORDER,		// 20
/*30*/	BORDER,		PAWN+WHITE,	PAWN+WHITE,	PAWN+WHITE,	PAWN+WHITE,	PAWN+WHITE,	PAWN+WHITE,	PAWN+WHITE,	PAWN+WHITE,	BORDER,		// 30
/*40*/	BORDER,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		BORDER,		// 40
/*50*/	BORDER,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		BORDER,		// 50
/*60*/	BORDER,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		BORDER,		// 60
/*70*/	BORDER,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		EMPTY,		BORDER,		// 70
/*80*/	BORDER,		PAWN+BLACK,	PAWN+BLACK,	PAWN+BLACK,	PAWN+BLACK,	PAWN+BLACK,	PAWN+BLACK,	PAWN+BLACK,	PAWN+BLACK,	BORDER,		// 80
/*90*/	BORDER,		ROOK+BLACK,	KNIGHT+BLACK,	BISHOP+BLACK,	QUEEN+BLACK,	KING+BLACK,	BISHOP+BLACK,	KNIGHT+BLACK,	ROOK+BLACK,	BORDER,		// 90
/*100*/	BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		// 100
/*110*/	BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		BORDER,		// 110
};

// template of possible moves (one row is 10 fields width)
const s8 MovesTemp[24] = {
	9,	11,	-11,	-9,	// 0: diagonally
	10,	-10,	1,	-1,	// 4: perpendicularly
	-21,	-12,	8,	19,	// 8: knight to the left
	21,	12,	-8,	-19,	// 12: knight to the right
	10,	20,	11,	9,	// 16: white pawn
	-10,	-20,	-11,	-9,	// 20: black pawn
};

// possible moves of the pieces (offset, number of moves)
const u8 PieceMoves[14] = {
	20, 4,		// 0: black pawn
	16, 4,		// 1: white pawn
	8, 8,		// 2: knight
	0, 4,		// 3: bishop
	4, 4,		// 4: rook
	0, 8,		// 5: queen
	0, 8,		// 6: king
};

// rating of the pieces
const u8 PieceRate[7] = {
	0,		// 0: empty
	1,		// 1: pawn
	3,		// 2: knight
	3,		// 3: bishop
	5,		// 4: rook
	9,		// 5: queen
	15,		// 6: king
};

// white player's opening moves table
const sMove OpenMovesTab[4] = {
	{ 35, 55, PAWN+WHITE+NOMOVING, EMPTY, MOVEFLAG_NORMAL, 0, 0 },		// pawn from B5 to D5
	{ 34, 54, PAWN+WHITE+NOMOVING, EMPTY, MOVEFLAG_NORMAL, 0, 0 },		// pawn from B4 to D4
	{ 22, 43, KNIGHT+WHITE+NOMOVING, EMPTY, MOVEFLAG_NORMAL, 0, 0 },	// knight from A2 to C3
	{ 27, 46, KNIGHT+WHITE+NOMOVING, EMPTY, MOVEFLAG_NORMAL, 0, 0 },	// knight from A7 to C6
};

// print text row to text console
void OutText(const pText* txt)
{
	// scroll buffer
	if (TextRows >= TEXTH)
	{
		memmove(&TextBuf[0], &TextBuf[TEXTW], TEXTS - TEXTW);
		memset(&TextBuf[TEXTS - TEXTW], ' ', TEXTW);
		TextRows--;
	}

	// print text
	int len = TextLen(txt);
	if (len > TEXTW) len = TEXTW;
	memcpy(&TextBuf[TextRows*TEXTW], TextPtr(txt), len);

	// set font
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;
	DrawFontWidth = 8;

	// print text buffer
	int x, y;
	char ch;
	for (y = 0; y < TEXTH; y++)
	{
		ch = TextBuf[(y+1)*TEXTW];
		TextBuf[(y+1)*TEXTW] = 0;
		DrawTextBg(&TextBuf[y*TEXTW], WIDTH - TEXTW*FONTW, y*FONTH, COL_WHITE, COL_BLACK);
		TextBuf[(y+1)*TEXTW] = ch;
	}
	DispUpdate();
	TextRows++;
}

// get piece from board (returns BORDER on invalid coordinates)
INLINE u8 GetPiece(u8 inx) { return Board[inx]; }

// set piece to board
INLINE void SetPiece(u8 inx, u8 piece) { Board[inx] = piece; }

// display one field (respects board rotation)
//   w ..... cursor frame width (0 = off)
//   color ... cursor frame color
//   usemove ... use "move" color
//   usecatch ... use "catch" color
void DispField(u8 inx, u8 w, u16 color, Bool usemove, Bool usecatch)
{
	// check if field is valid
	u8 piece = GetPiece(inx);
	if (piece == BORDER) return;

	// split index to column and row
	u8 row = inx/MAPW;
	u8 col = inx - row*MAPW - 1;
	row -= 2;

	// field source coordinate
	int xs = (piece & PIECEMASK) * TILEW; // piece type, without color
	int ys = ((piece & COLORMASK) == WHITE) ? TILEH : 0; // piece color
	if (usemove)
		ys += 4*TILEH; // use "move" color
	else if (usecatch)
		ys += 6*TILEH; // use "catch" color
	else
		if (((row + col) & 1) != 0) ys += 2*TILEH; // field color

	// field destination coordinate
	u8 x, y;
	if (PlayerView)
	{
		x = FRAME + (MAP0W - 1 - col)*TILEW;
		y = FRAME + row*TILEH;
	}
	else
	{
		x = FRAME + col*TILEW;
		y = FRAME + (MAP0H - 1 - row)*TILEH;
	}

	// display field
	DrawImg4Pal(PiecesImg, PiecesImg_Pal, xs, ys, x, y, TILEW, TILEH, PIECESIMGW);

	// display cursor frame
	if (w > 0)
	{
		DrawRect(x, y, TILEW, w, color); // top
		DrawRect(x, y+TILEH-w, TILEW, w, color); // bottom
		DrawRect(x, y+w, w, TILEH-2*w, color); // left
		DrawRect(x+TILEW-w, y+w, w, TILEH-2*w, color); // right
	}
	else
	{
		// display enable mark
		if (BoardEnable[inx])
		{
			color = RGBTO16(0, 255, 0);
			if (((row + col) & 1) != 0) color = RGBTO16(0, 180, 0);
			w = 2;
#define DDW 2
			DrawRect(x+DDW, y+DDW, TILEW-2*DDW, w, color); // top
			DrawRect(x+DDW, y+TILEH-w-DDW, TILEW-2*DDW, w, color); // bottom
			DrawRect(x+DDW, y+w+DDW, w, TILEH-2*w-2*DDW, color); // left
			DrawRect(x+TILEW-w-DDW, y+w+DDW, w, TILEH-2*w-2*DDW, color); // right
#undef DDW
		}
	}
}

// display board frame
void DispFrame()
{
	int i, j;
	u16 col;
	char buf[2];

	// set font
	pDrawFont = FontBold8x8;
	DrawFontHeight = 8;
	DrawFontWidth = 8;

	// draw frame
	DrawRect(0, 0, BOARDW, FRAME, FRAMECOL); // top border
	DrawRect(0, HEIGHT-FRAME, BOARDW, FRAME, FRAMECOL); // bottom border
	DrawRect(0, FRAME, FRAME, HEIGHT-2*FRAME, FRAMECOL); // left border
	DrawRect(BOARDW-FRAME, FRAME, FRAME, HEIGHT-2*FRAME, FRAMECOL); // right border

	// horizontal legend
	buf[1] = 0;
	for (i = 0; i < MAP0W; i++)
	{
		buf[0] = PlayerView ? ('H' - i) : ('A' + i);
		DrawText(buf, FRAME + TILEW/2 - 4 + i*TILEW, 0, LEGENDCOL); // top legend
		DrawText(buf, FRAME + TILEW/2 - 4 + i*TILEW, HEIGHT-FRAME, LEGENDCOL); // top legend
	}

	// vertical legend
	for (i = 0; i < MAP0H; i++)
	{
		buf[0] = PlayerView ? ('1' + i) : ('8' - i);
		DrawText(buf, 0, FRAME + TILEH/2 - 4 + i*TILEH, LEGENDCOL); // left legend
		DrawText(buf, BOARDW-FRAME, FRAME + TILEH/2 - 4 + i*TILEH, LEGENDCOL); // left legend
	}
}

// display base board
void DispBoard()
{
	int i;
	for (i = 0; i < MAPSIZE; i++) DispField(i, 0, 0, False, False);
}

// start new game
void NewGame()
{
	DrawClear(COL_BLACK);

	PlayerView = False; // view direction
	MoveNum = 1; // move counter
	Player = WHITE_PLAYER; // white is playing first
	MoveStackTop = 0; // clear move stack
//#ifdef DEBUG_STACK	// debug flag - display stack max. depth
//	MoveStackTopMax = 0; // number of entries
//#endif
	MovePassantPiece[0] = 0; // last position of piece to En Passant (0 = invalid)
	MovePassantPos[0] = 0; // last capture position of piece to En Passant (0 = invalid)

	// clear text buffer
	memset(TextBuf, ' ', TEXTS);
	TextRows = 0;

	// initialize board
	u8 b;
	int i;
	for (i = 0; i < MAPSIZE; i++)
	{
		BoardEnable[i] = False;
		b = BoardTemp[i];
		if (b == KING+WHITE) Players[WHITE_PLAYER].king = i; // white king
		if (b == KING+BLACK) Players[BLACK_PLAYER].king = i; // black king
		if ((b != BORDER) && (b != EMPTY)) b |= NOMOVING; // not moving yet
		Board[i] = b;
	}

	// initialize players
	sPlayer* p = Players;
	for (i = 0; i < 2; i++)
	{
		p->curpos = p->king; // current cursor position
		p++;
	}
}

// do move (without visualization)
void DoMove(const sMove* m)
{
	// update king position
	if ((m->srcpiece & PIECEMASK) == KING) Players[Player].king = m->dst;

	// do normal move
	if (m->flags == MOVEFLAG_NORMAL)
	{
		SetPiece(m->src, EMPTY); // empty old position
		SetPiece(m->dst, m->srcpiece & ~MOVEMASK); // move piece, clear move flag
	}

	// change pawn to queen
	else if (m->flags == MOVEFLAG_QUEEN)
	{
		SetPiece(m->src, EMPTY); // empty old position
		SetPiece(m->dst, m->extra); // place new piece
	}

	// En Passant
	else if (m->flags == MOVEFLAG_EP)
	{
		SetPiece(m->src, EMPTY); // empty old position
		SetPiece(m->dst, m->srcpiece & ~MOVEMASK); // move piece, clear move flag
		SetPiece(m->extra, EMPTY); // capture enemy pawn
	}

	// make castle
	else
	{
		SetPiece(m->src, m->dstpiece & ~MOVEMASK); // put rook
		SetPiece(m->dst, m->srcpiece & ~MOVEMASK); // put king
	}
}

// undo move (without visualization)
void UndoMove(const sMove* m)
{
	if ((m->srcpiece & PIECEMASK) == KING) Players[Player].king = m->src;

	SetPiece(m->src, m->srcpiece);
	if (m->flags == MOVEFLAG_EP)
	{
		SetPiece(m->dst, EMPTY);
		SetPiece(m->extra, m->dstpiece);
	}
	else
		SetPiece(m->dst, m->dstpiece);
}

// do move with visualization
void DoMoveDisp(const sMove* m)
{
	LastMove = m;

	// save position of En Passant
	MovePassantPiece[0] = 0;
	MovePassantPos[0] = 0;
	if ((m->srcpiece & (PIECEMASK | MOVEMASK)) == (PAWN | NOMOVING))
	{
		int dif = m->dst - m->src;
		if ((dif == 20) || (dif == -20))
		{
			MovePassantPiece[0] = m->dst; // destination position of pawn
			MovePassantPos[0] = m->src + dif/2; // capture position
		}
	}

	// prepare destination color
	Bool usemove = True;
	Bool usecatch = False;
	if ((m->dstpiece != EMPTY) && (m->flags != MOVEFLAG_SMALL) && (m->flags != MOVEFLAG_BIG))
	{
		usemove = False;
		usecatch = True;
	}

	// draw destination
	DispField(m->dst, 0, 0, usemove, usecatch);

	// animate source field
	int i;
	for (i = 0; i < 4; i++)
	{
		SetPiece(m->src, m->srcpiece);
		DispField(m->src, 0, 0, True, False);
		DispUpdate();
		WaitMs(100);

		KeyScan();

		SetPiece(m->src, EMPTY);
		DispField(m->src, 0, 0, True, False);
		DispUpdate();
		WaitMs(100);

		KeyScan();
	}
	SetPiece(m->src, m->srcpiece);

	// do move
	DoMove(m);
	u8 piece = GetPiece(m->dst);

	// display source field
	DispField(m->src, 0, 0, True, False);

	// animate destination field
	for (i = 0; i < 4; i++)
	{
		SetPiece(m->dst, piece);
		DispField(m->dst, 0, 0, usemove, usecatch);
		DispUpdate();
		WaitMs(100);

		KeyScan();

		SetPiece(m->dst, EMPTY);
		DispField(m->dst, 0, 0, usemove, usecatch);
		DispUpdate();
		WaitMs(100);

		KeyScan();
	}
	SetPiece(m->dst, piece);

	DispBoard();
	DispUpdate();
}

// test whether king of current player is in check
Bool TestCheck()
{
	int dir, jump, pos, pos0, steps;
	u8 piece, king;

	// prepare king current position
	pos0 = Players[Player].king;
	king = GetPiece(pos0);

	// check all possible directions from direction table (including knight jump)
	for (dir = 0; dir < 16; dir++)
	{
		// load next jump offset (directions: 0..3 diagonally, 4..7 perpendicularly, 8..15 knight)
		jump = MovesTemp[dir];

		// prepare starting position
		pos = pos0;

		// check steps
		for (steps = 0; ;)
		{
			// increase steps
			steps++;

			// shift position
			pos += jump;

			// get board content
			piece = GetPiece(pos);

			// border
			if (piece == BORDER) break;

			// empty field - continue to next field, except knight direction
			if (piece == EMPTY)
			{
				if (dir >= 8) break;
				continue;
			}

			// check color - piece of same color covers the king
			if (((piece ^ king) & COLORMASK) == 0) break;
			piece &= PIECEMASK;

			// enemy knight (1 step, knight directions)
			if (piece == KNIGHT)
			{
				if (dir >= 8) return True; // king is in check
				break; // not in check, no other steps
			}

			// no other pieces can check in knight directions
			if (dir >= 8) break;

			// enemy king (1 step, not knight directions)
			if (piece == KING)
			{
				if (steps == 1) return True; // king is in check
				break; // not in check, no other steps
			}

			// enemy queen
			if (piece == QUEEN) return True;

			// bishop
			if ((piece == BISHOP) && (dir <= 3)) return True;

			// rook
			if ((piece == ROOK) && (dir >= 4)) return True;
			
			// pawn
			if ((piece == PAWN) && (dir <= 3) && (steps == 1))
			{
				// black pawn attacking white king
				if ((king & COLORMASK) == WHITE)
				{
					if ((jump == 11) || (jump == 9)) return True;
				}

				// white pawn attacking black king
				else
				{
					if ((jump == -11) || (jump == -9)) return True;
				}
			}

			// others are safe
			break;
		}
	}
	return False;
}

// search all possible moves in current deep level
void SearchMoves(s16 val)
{
	int level = MoveDeep;	// current deep level
	int movenum = MoveStackTop; // number of entries
	MoveStackStart[level] = movenum; // save index of start move
	sMove* move = &MoveStack[movenum]; // pointer to current move
	u8 piece, piece2, piece3, piece4, flags;
	u8 col = (Player == WHITE_PLAYER) ? WHITE : BLACK; // prepare piece color
	u8 enemycol = col ^ COLORMASK; // prepare enemy piece color
	int dir, dirnum, jump, pos, steps;
	s16 val2;
	Bool possiblecheck, check;
	u8 extra = 0;

	// loop all fields
	u8 pos0 = 21; // first field
	for (; pos0 <= 98; pos0++)
	{
		// get piece
		piece = GetPiece(pos0);

		// check piece color (must be player's own piece)
		if ((piece == BORDER) || (piece == EMPTY) || ((piece & COLORMASK) != col)) continue;

		// fast check to see if removing a piece can put the king in check
		piece2 = piece & PIECEMASK;
		if (piece2 == KING)
			possiblecheck = True;
		else
		{
			SetPiece(pos0, EMPTY);
			possiblecheck = TestCheck();
			SetPiece(pos0, piece);
		}

		// prepare piece directions
		if ((piece2 == PAWN) && (col == BLACK)) piece2 = 0; // black and white pawn differentiation (black pawn will have index 0)
		dir = PieceMoves[piece2*2];
		dirnum = PieceMoves[piece2*2+1];

		// loop all directions
		for (; dirnum > 0; dirnum--)
		{
			// get jump offset
			jump = MovesTemp[dir];
			dir++;

			// prepare start position
			pos = pos0;

			// check steps
			for (steps = 0; ;)
			{
				// increase steps
				steps++;

				// shift position
				pos += jump;

				// get board content
				piece3 = GetPiece(pos);

				// border
				if (piece3 == BORDER) break;

				// same color, break
				if ((piece3 != EMPTY) && ((piece3 & COLORMASK) == col)) break;

				// pawn
				flags = MOVEFLAG_NORMAL;
				if (piece2 <= 1)
				{
					// 2 fields: must be first move and to empty field
					if ((jump == 20) || (jump == -20))
					{
						if (((piece & MOVEMASK) == MOVING) || (piece3 != EMPTY)) break;
					}

					// 1 step in straight direction: must be to empty field
					if ((jump == 10) || (jump == -10))
					{
						if (piece3 != EMPTY) break;
					}

					// 1 step diagonally: must capture enemy
					if ((jump == -11) || (jump == -9) || (jump == 11) || (jump == 9))
					{
						if (piece3 == EMPTY)
						{
							// check En Passant Privilege
							if (pos != MovePassantPos[level]) break;
							extra = MovePassantPiece[level];
							piece3 = GetPiece(extra);
							flags = MOVEFLAG_EP;
						}
					}

					// change pawn to something else
					if (((pos >= 21) && (pos <= 28)) || ((pos >= 91) && (pos <= 98)))
					{
						// test check condition
						check = False;
						if (possiblecheck)
						{
							SetPiece(pos0, EMPTY);
							SetPiece(pos, piece);
							check = TestCheck();
							SetPiece(pos0, piece);
							SetPiece(pos, piece3);	
						}

						if (!check)
						{
							// add 4 moves
							for (piece4 = KNIGHT; piece4 <= QUEEN; piece4++)
							{
								val2 = val;
								if (piece3 != EMPTY) val2 += PieceRate[piece3 & PIECEMASK];
								val2 += PieceRate[piece4] - 1;

								if (movenum < STACK_MAX)
								{
									move->src = pos0;
									move->dst = pos;
									move->srcpiece = piece;
									move->dstpiece = piece3;
									move->flags = MOVEFLAG_QUEEN;
									move->val = val2;
									move->extra = piece4 | col;
									move++;
									movenum++;
								}
							}
						}
						break;
					}
				}

				// test check condition
				check = False;
				if (piece2 == KING)
				{
					// check king
					SetPiece(pos0, EMPTY);
					SetPiece(pos, piece);
					Players[Player].king = pos;
					check = TestCheck();
					Players[Player].king = pos0;
					SetPiece(pos0, piece);
					SetPiece(pos, piece3);	
				}
				else if (possiblecheck)
				{
					SetPiece(pos0, EMPTY);
					SetPiece(pos, piece);
					check = TestCheck();
					SetPiece(pos0, piece);
					SetPiece(pos, piece3);	
				}

				if (!check)
				{
					// empty field or enemy
					val2 = val;
					if (piece3 != EMPTY) val2 += PieceRate[piece3 & PIECEMASK];

					// add move
					if (movenum < STACK_MAX)
					{
						move->src = pos0;
						move->dst = pos;
						move->srcpiece = piece;
						move->dstpiece = piece3;
						move->flags = flags;
						move->extra = extra;
						move->val = val2;
						move++;
						movenum++;
					}
				}

				// found enemy, stop steps
				if (piece3 != EMPTY) break;

				// king, pawn and knight can go only 1 step
				if ((piece2 == KNIGHT) || (piece2 <= 1) || (piece2 == KING)) break;
			}
		}
	}

	// test castle
	pos0 = Players[Player].king; // king position
	piece = GetPiece(pos0); // get king piece
	if (((piece & MOVEMASK) == NOMOVING) && !TestCheck())
	{
		// small castle
		pos = pos0 + 3;
		piece3 = GetPiece(pos);
		if ( ((piece3 & (PIECEMASK|MOVEMASK)) == (ROOK|NOMOVING)) &&
			(GetPiece(pos0 + 1) == EMPTY) &&
			(GetPiece(pos0 + 2) == EMPTY))
		{
			Players[Player].king = pos0+1;
			check = TestCheck();
			Players[Player].king = pos0+2;
			check |= TestCheck();
			Players[Player].king = pos0+3;
			check |= TestCheck();
			Players[Player].king = pos0;

			if (!check && (movenum < STACK_MAX))
			{
				move->src = pos0;
				move->dst = pos;
				move->srcpiece = piece;
				move->dstpiece = piece3;
				move->flags = MOVEFLAG_SMALL;
				move->val = val;
				move++;
				movenum++;
			}
		}

		// big castle
		pos = pos0 - 4;
		piece3 = GetPiece(pos);
		if ( ((piece3 & (PIECEMASK|MOVEMASK)) == (ROOK|NOMOVING)) &&
			(GetPiece(pos0 - 1) == EMPTY) &&
			(GetPiece(pos0 - 2) == EMPTY) &&
			(GetPiece(pos0 - 3) == EMPTY))
		{
			Players[Player].king = pos0-1;
			check = TestCheck();
			Players[Player].king = pos0-2;
			check |= TestCheck();
			Players[Player].king = pos0-3;
			check |= TestCheck();
			Players[Player].king = pos0-4;
			check |= TestCheck();
			Players[Player].king = pos0;

			if (!check && (movenum < STACK_MAX))
			{
				move->src = pos0;
				move->dst = pos;
				move->srcpiece = piece;
				move->dstpiece = piece3;
				move->flags = MOVEFLAG_BIG;
				move->val = val;
				move++;
				movenum++;
			}
		}
	}

	// store number of moves
	MoveStackNum[level] = movenum - MoveStackTop;
	MoveStackTop = movenum;

//#ifdef DEBUG_STACK	// debug flag - display stack max. depth
//	if (MoveStackTopMax < movenum) MoveStackTopMax = movenum; // number of entries
//#endif

}

// find computer move on one level (returns best move, NULL = not found)
sMove* MoveCompLevel()
{
	int deep = MoveDeep;
	int top;
	sMove *m, *m2;

	// search moves at this level
	SearchMoves(deep);

	// number of moves
	int i = MoveStackNum[deep];
	if (i == 0) return NULL;

	// max. level (initial moves are with less depth)
	int deepmax = MoveNum;
	if (deepmax > DeepMax-1) deepmax = DeepMax-1;

	// loop moves
	if (deep < deepmax)
	{
		// shift level
		MoveDeep = deep + 1;

		KeyScan();

		// check moves
		m = &MoveStack[MoveStackStart[deep]];
		for (; i > 0; i--)
		{
			// save En Passant position
			MovePassantPiece[deep+1] = 0;
			MovePassantPos[deep+1] = 0;
			if ((m->srcpiece & (PIECEMASK | MOVEMASK)) == (PAWN | NOMOVING))
			{
				int dif = m->dst - m->src;
				if ((dif == 20) || (dif == -20))
				{
					MovePassantPiece[deep+1] = m->dst; // destination position of pawn
					MovePassantPos[deep+1] = m->src + dif/2; // capture position
				}
			}

			// do this move
			DoMove(m);

			// change player
			Player ^= 1;
			top = MoveStackTop;

			// search sub-moves
			m2 = MoveCompLevel();

			// no move, checkmat or pat
			if (m2 == NULL)
				m->val += VAL_WIN;
			else
				// add move value
				m->val -= m2->val;

			// restore state
			MoveStackTop = top;

			// change player
			Player ^= 1;

			// undo this move
			UndoMove(m);

			// next move
			m++;
		}

		// restore state
		MoveDeep = deep;
	}

	// use first move
	m = &MoveStack[MoveStackStart[deep]];
	int bestnum = 1;
	s16 bestval = m->val;
	m++;
	i = MoveStackNum[deep] - 1;
	
	// check moves
	for (; i > 0; i--)
	{
		// check value
		if (m->val == bestval)
			bestnum++;
		else if (m->val > bestval)
		{
			bestnum = 1;
			bestval = m->val;
		}

		// next move
		m++;
	}

	// randomize selection
	i = RandS16Max(bestnum - 1);

	// search best move
	m = &MoveStack[MoveStackStart[deep]];
	for (;;)
	{
		if (m->val == bestval)
		{
			i--;
			if (i < 0) break;
		}		
		m++;
	}
		
	return m;
}

// move computer
void MoveComp()
{
	// white player is opening game
	if ((MoveNum == 1) && (Player == WHITE_PLAYER))
	{
		const sMove* m  = &OpenMovesTab[RandU8Max(3)];
		DoMoveDisp(m);
		return;
	}

	// prepare all possible moves
	MoveDeep = 0;
	MoveStackTop = 0;

//#ifdef DEBUG_STACK	// debug flag - display stack max. depth
//	MoveStackTopMax = 0; // number of entries
//#endif

	// search move
	sMove* m = MoveCompLevel();
	LastMove = m;

	if (m != NULL)
	{
		DoMoveDisp(m);
	}
}

// move human player (returns True = quit game)
Bool MoveHuman()
{
	u32 t;
	char ch;
	u16 col;
	u8 piece, piece2;
	Bool ok, sel, cancel;
	u8 oldpos;
	sMove* m;
	int i, j;

	// current player
	sPlayer* p = &Players[Player];

	// select view
	PlayerView = Player;

	// display board frame
	DispFrame();

	// prepare all possible moves
	MoveDeep = 0;
	MoveStackTop = 0;
//#ifdef DEBUG_STACK	// debug flag - display stack max. depth
//	MoveStackTopMax = 0; // number of entries
//#endif
	SearchMoves(0);

	// check-mat
	if (MoveStackNum[0] == 0)
	{
		LastMove = NULL;
		return False;
	}

MOVE_AGAIN:

	// check start position
	for (i = 0; i < MAPSIZE; i++) BoardEnable[i] = False;
	m = &MoveStack[MoveStackStart[0]];
	for (i = MoveStackNum[0]; i > 0; i--)
	{
		BoardEnable[m->src] = True;
		m++;
	}

	// display board
	DispBoard();

	// start blinking cursor
	BlinkTime = Time();

	KeyFlush();

	// select piece
	while (True)
	{
		// prepare cursor color
		piece = GetPiece(p->curpos);
		col = RGBTO16(255, 0, 0); // red cursor
		ok = False;
		if (BoardEnable[p->curpos])
		{
			col = RGBTO16(0, 64, 255);
			ok = True; // can move
		}

		// display cursor
		t = Time();
		DispField(p->curpos, ((((t - BlinkTime) >> 16) & 3) == 3) ? 0 : 4, col, False, False);

		// get keyboard
		ch = KeyGet();

		// turn board
		if (PlayerView)
		{
			if ((ch == KEY_LEFT) || (ch == KEY_RIGHT)) ch ^= KEY_LEFT ^ KEY_RIGHT;
			if ((ch == KEY_UP) || (ch == KEY_DOWN)) ch ^= KEY_UP ^ KEY_DOWN;
		}

		// cursor movements
		sel = False;
		switch (ch)
		{
		case KEY_A:
			if (ok) sel = True;
			break;

		case KEY_LEFT:
			DispField(p->curpos, 0, 0, False, False);
			p->curpos--;
			if (GetPiece(p->curpos) == BORDER) p->curpos += MAP0W;
			BlinkTime = Time();
			break;

		case KEY_RIGHT:
			DispField(p->curpos, 0, 0, False, False);
			p->curpos++;
			if (GetPiece(p->curpos) == BORDER) p->curpos -= MAP0W;
			BlinkTime = Time();
			break;

		case KEY_DOWN:
			DispField(p->curpos, 0, 0, False, False);
			p->curpos -= MAPW;
			if (GetPiece(p->curpos) == BORDER) p->curpos += MAP0H*MAPW;
			BlinkTime = Time();
			break;

		case KEY_UP:
			DispField(p->curpos, 0, 0, False, False);
			p->curpos += MAPW;
			if (GetPiece(p->curpos) == BORDER) p->curpos -= MAP0H*MAPW;
			BlinkTime = Time();
			break;

		case KEY_X:
			for (i = 0; i < MAPSIZE; i++) BoardEnable[i] = False;
			DispBoard();
			DispUpdate();
#if USE_SCREENSHOT		// use screen shots
			ScreenShot();
#endif
			MoveComp();
			return False;

		case KEY_Y:
			return True; // quit game
		}
		if (sel) break;

		// redraw board
		DispUpdate();
	}

	// save start position
	oldpos = p->curpos;

	// prepare enable map
	for (i = 0; i < MAPSIZE; i++) BoardEnable[i] = False;
	BoardEnable[oldpos] = True; // return to old position
	m = &MoveStack[MoveStackStart[0]];
	for (i = MoveStackNum[0]; i > 0; i--)
	{
		if (m->src == oldpos) BoardEnable[m->dst] = True;
		m++;
	}

	// display board with enable flags
	DispBoard();

	// pick up piece from chessboard
	SetPiece(oldpos, EMPTY);
	piece2 = EMPTY;

	// start blinking cursor
	BlinkTime = Time();

	KeyFlush();

	// move piece
	while (True)
	{
		// prepare cursor color
		col = RGBTO16(255, 0, 0); // red cursor
		ok = False;
		if (BoardEnable[p->curpos])
		{
			col = RGBTO16(0, 64, 255);
			ok = True; // can move
		}

		// display cursor
		t = Time();
		if ((((t - BlinkTime) >> 17) & 1) == 1) // display original field
		{
			SetPiece(p->curpos, piece2);
			DispField(p->curpos, 0, 0, False, False);
		}
		else // display moved piece
		{
			SetPiece(p->curpos, piece);
			DispField(p->curpos, 4, col, False, False);
		}

		// get keyboard
		ch = KeyGet();

		// turn board
		if (PlayerView == BLACK_PLAYER)
		{
			if ((ch == KEY_LEFT) || (ch == KEY_RIGHT)) ch ^= KEY_LEFT ^ KEY_RIGHT;
			if ((ch == KEY_UP) || (ch == KEY_DOWN)) ch ^= KEY_UP ^ KEY_DOWN;
		}

		// cursor movements
		sel = False;
		cancel = False;
		switch (ch)
		{
		case KEY_A:
			if (ok) sel = True;
			break;

		case KEY_B:
			cancel = True;
			break;

		case KEY_LEFT:
			SetPiece(p->curpos, piece2);
			DispField(p->curpos, 0, 0, False, False);
			p->curpos--;
			if (GetPiece(p->curpos) == BORDER) p->curpos += MAP0W;
			BlinkTime = Time();
			piece2 = GetPiece(p->curpos);
			break;

		case KEY_RIGHT:
			SetPiece(p->curpos, piece2);
			DispField(p->curpos, 0, 0, False, False);
			p->curpos++;
			if (GetPiece(p->curpos) == BORDER) p->curpos -= MAP0W;
			BlinkTime = Time();
			piece2 = GetPiece(p->curpos);
			break;

		case KEY_DOWN:
			SetPiece(p->curpos, piece2);
			DispField(p->curpos, 0, 0, False, False);
			p->curpos -= MAPW;
			if (GetPiece(p->curpos) == BORDER) p->curpos += MAP0H*MAPW;
			BlinkTime = Time();
			piece2 = GetPiece(p->curpos);
			break;

		case KEY_UP:
			SetPiece(p->curpos, piece2);
			DispField(p->curpos, 0, 0, False, False);
			p->curpos += MAPW;
			if (GetPiece(p->curpos) == BORDER) p->curpos -= MAP0H*MAPW;
			BlinkTime = Time();
			piece2 = GetPiece(p->curpos);
			break;

		case KEY_X:
			for (i = 0; i < MAPSIZE; i++) BoardEnable[i] = False;
			DispBoard();
			DispUpdate();
			MoveComp();
			return False;

		case KEY_Y:
			return True; // quit game
		}
		if (sel || cancel) break;

		// redraw board
		DispUpdate();
	}

	// return piece
	SetPiece(p->curpos, piece2);
	SetPiece(oldpos, piece);

	// clear enable map
	for (i = 0; i < MAPSIZE; i++) BoardEnable[i] = False;
	DispBoard();
	DispUpdate();

	// cancel
	if (cancel)
	{
		p->curpos = oldpos;
		goto MOVE_AGAIN;
	}

	// return piece on original position
	if (p->curpos == oldpos) goto MOVE_AGAIN;

// @TODO: Add the option of choosing a piece changed from a pawn! Now the default queen is left.

	// search move
	m = &MoveStack[MoveStackStart[0]];
	for (i = MoveStackNum[0]; i > 0; i--)
	{
		if ((m->src == oldpos) && (m->dst == p->curpos) &&
			((m->flags != MOVEFLAG_QUEEN) || ((m->extra & PIECEMASK) == QUEEN)))
		{
			DoMoveDisp(m);
			break;
		}
		m++;
	}

	return False;
}

// open screen
void Open()
{
	char ch;

	// set font
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;
	DrawFontWidth = 8;

	DrawClear(COL_BLACK);
	DrawText2("CHESS", (WIDTH - 5*16)/2, 20, COL_YELLOW);

#define MENUX 30

	DrawText("Select:", MENUX, 70, COL_WHITE);

	DrawText("LEFT .... Play with white", MENUX, 105, COL_WHITE);
	DrawText("RIGHT ... Play with black", MENUX, 125, COL_WHITE);
	DrawText("DOWN .... Play 2 players", MENUX, 145, COL_WHITE);
	DrawText("UP ...... Demo", MENUX, 165, COL_WHITE);
	DrawText("A ....... Select level:", MENUX, 195, COL_WHITE);

	KeyFlush();
	for (;;)
	{
		ch = KeyGet();
		switch (ch)
		{
		case KEY_LEFT:
			Players[0].comp = False;
			Players[1].comp = True;
			return;

		case KEY_RIGHT:
			Players[0].comp = True;
			Players[1].comp = False;
			return;
	
		case KEY_DOWN:
			Players[0].comp = False;
			Players[1].comp = False;
			return;

		case KEY_UP:
			Players[0].comp = True;
			Players[1].comp = True;
			return;

		case KEY_A:
			DeepMax++;
			if (DeepMax > DEEP_MAX) DeepMax = 2;
			break;

		case KEY_Y: ResetToBootLoader();
		}

		if (DeepMax == 2)
			DrawTextBg("BEGINNER", MENUX+24*8, 195, COL_WHITE, COL_BLACK);
		else if (DeepMax == 3)
			DrawTextBg("ADVANCED", MENUX+24*8, 195, COL_WHITE, COL_BLACK);
		else if (DeepMax == 4)
			DrawTextBg("PRO     ", MENUX+24*8, 195, COL_WHITE, COL_BLACK);
		else
			DrawTextBg("SUPERPRO", MENUX+24*8, 195, COL_WHITE, COL_BLACK);

		DispUpdate();
	}
}

int main()
{
	pText txt;
	TextInit(&txt);
	int i, row, col;

	DeepMax = 4;

	while (True)
	{
		// open screen
		Open();

		// new game
		NewGame();

		// display board frame
		DispFrame();

		// display board
		DispBoard();

		while (True)
		{
			// move computer or player
			if (Players[Player].comp)
				MoveComp();
			else
				if (MoveHuman()) break;

			if (KeyGet() == KEY_Y) break;

			// checkmat (9 chars)
			if (LastMove == NULL)
			{
				TextSetStr(&txt, "CHECKMATE");
				OutText(&txt);

				WaitMs(500);
				KeyFlush();
				while (KeyGet() == NOKEY) {}
				break;
			}

			// prepare move counter (4 chars)
			TextEmpty(&txt);
			if (MoveNum < 10) TextAddSpc(&txt);
			if (MoveNum < 100) TextAddSpc(&txt);
			TextAddUInt(&txt, MoveNum, 0);
			TextAddCh(&txt, ':');
			if (Player == BLACK_PLAYER) TextSetStr(&txt, "    ");

			// special cases
			if (LastMove->flags == MOVEFLAG_SMALL)
			{
				TextAddStr(&txt, "O-O");
			}
			else if (LastMove->flags == MOVEFLAG_BIG)
			{
				TextAddStr(&txt, "O-O-O");
			}
			else
			{
				// set source field (2 chars)
				row = LastMove->src / 10;
				col = LastMove->src - row*10;
				TextAddCh(&txt, col+'a'-1);
				TextAddCh(&txt, row+'1'-2);

				// separator (1 char)
				TextAddCh(&txt, '-');		

				// set destination field (2 chars)
				row = LastMove->dst / 10;
				col = LastMove->dst - row*10;
				TextAddCh(&txt, col+'a'-1);
				TextAddCh(&txt, row+'1'-2);

				// take piece
				if (LastMove->dstpiece != EMPTY) TextAddCh(&txt, 'x');

				// En Passant
				if (LastMove->flags == MOVEFLAG_EP) TextAddStr(&txt, "e");
			}	

			// display move
			OutText(&txt);

//#ifdef DEBUG_STACK	// debug flag - display stack max. depth
//			TextSetUInt(&txt, MoveStackTopMax, 0);
//			OutText(&txt);
//#endif

			// change player
			Player ^= 1;

			// increase move counter
			if (Player == WHITE_PLAYER) MoveNum++;
		}
	}

	TextTerm(&txt);
}

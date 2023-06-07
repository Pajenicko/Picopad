
// ****************************************************************************
//
//                                 Game engine
//
// ****************************************************************************

#include "../include.h"

const int CastleX[2] = { WIDTH/2 - 70, WIDTH/2 + 70 }; // castle X middle coordinate
const int FenceX[2] = { WIDTH/2 - 20, WIDTH/2 + 20 }; // fence X middle coordinate
const int StateX[2] = { 0, WIDTH-STATEW}; // state X coordinate

// save screen content
u16 SaveCardBuf[CARDW*CARDH];
u16 SaveCardBuf2[CARDW*CARDH];
u16 SaveCloudBuf[CLOUDW*CLOUDH*PAR_NUM*2];
u16 SaveWinBuf[WINW*WINH];

// player state
sPlayer Players[2];	// player's game parameters
Bool Demo;		// demo mode
u8 Player;		// active player
int Last;		// last laid card (-1 = none)
Bool LastDiscard;	// last card was discarded
int SelCard;		// selected card (cursor)
int FreePos;		// free card position
int EndGame = -1;	// end game, player's victory (-1 = no win)

// parameter foreground color
const u16 ParFgCol[8] = { COL_YELLOW, COL_WHITE, COL_YELLOW, COL_WHITE,
			COL_YELLOW, COL_WHITE, COL_WHITE, COL_WHITE };

// card table
const sCard Card[CARDTYPES] = {

// bricks
	{	PAR_BRICKS,	1,	PAR_FENCE,	+3 },	// 0: wall
	{	PAR_BRICKS,	1,	PAR_CASTLE,	+2 },	// 1: base
	{	PAR_BRICKS,	3,	PAR_FENCE,	+6 },	// 2: defense
	{	PAR_BRICKS,	3,	PAR_NUM,	0 },	// 3: reserve (castle +8, fence -4)
	{	PAR_BRICKS,	5,	PAR_CASTLE,	+5 },	// 4: tower
	{	PAR_BRICKS,	8,	PAR_BUILDERS,	+1 },	// 5: school
	{	PAR_BRICKS,	10,	PAR_NUM,	0 },	// 6: wain (castle +8, enemy castle -4)
	{	PAR_BRICKS,	12,	PAR_FENCE,	+22 },	// 7: fence
	{	PAR_BRICKS,	18,	PAR_CASTLE,	+20 },	// 8: fort
	{	PAR_BRICKS,	39,	PAR_CASTLE,	+32 },	// 9: Babylon

// weapons
	{	PAR_WEAPONS,	1,	PAR_FENCE,	-2 },	// 10: archer
	{	PAR_WEAPONS,	2,	PAR_FENCE,	-3 },	// 11: knight
	{	PAR_WEAPONS,	2,	PAR_FENCE,	-4 },	// 12: rider
	{	PAR_WEAPONS,	4,	PAR_FENCE,	-6 },	// 13: platoon
	{	PAR_WEAPONS,	8,	PAR_SOLDIERS,	+1 },	// 14: recruit
	{	PAR_WEAPONS,	10,	PAR_FENCE,	-12 },	// 15: attack
	{	PAR_WEAPONS,	12,	PAR_NUM,	0 },	// 16: saboteur (enemy stocks -4)
	{	PAR_WEAPONS,	15,	PAR_NUM,	0 },	// 17: thief (transfer enemy stocks 5)
	{	PAR_WEAPONS,	18,	PAR_CASTLE,	-10 },	// 18: swat
	{	PAR_WEAPONS,	28,	PAR_FENCE,	-32 },	// 19: banshee

// crystals
	{	PAR_CRYSTALS,	4,	PAR_BRICKS,	+8 },	// 20: conjure bricks
	{	PAR_CRYSTALS,	4,	PAR_BRICKS,	-8 },	// 21: crush bricks
	{	PAR_CRYSTALS,	4,	PAR_WEAPONS,	+8 },	// 22: conjure weapons
	{	PAR_CRYSTALS,	4,	PAR_WEAPONS,	-8 },	// 23: crush weapons
	{	PAR_CRYSTALS,	4,	PAR_CRYSTALS,	+8 },	// 24: conjure crystals
	{	PAR_CRYSTALS,	4,	PAR_CRYSTALS,	-8 },	// 25: crush crystals
	{	PAR_CRYSTALS,	8,	PAR_WIZARDS,	+1 },	// 26: sorcerer
	{	PAR_CRYSTALS,	21,	PAR_FENCE,	-25 },	// 27: dragon
	{	PAR_CRYSTALS,	22,	PAR_CASTLE,	+22 },	// 28: pixies
	{	PAR_CRYSTALS,	25,	PAR_NUM,	0 },	// 29: curse (all +1, enemie's all -1)
};

// generate new card
int NewCard()
{
	// unlinear randomness - cards with low number will be most plentiful
	int card = (int)(powf((RandFloat()*0.99f), 1.6f) * CARDTYPES);
	
	// change organization of card order - 3 groups from weakest to strongest cards
	card = (card/3) + (card % 3)*10;
	return card;
}

// test cards permission
void Permission()
{
	// initialize players
	int i, j, card, costs, par;
	sPlayer* p = Players;
	for (i = 0; i < 2; i++)
	{
		for (j = 0; j < CARDNUM; j++)
		{
			// check card cost
			card = p->cards[j];
			if (card < 0) // invalid card
				p->disable[j] = True;
			else
			{
				costs = Card[card].costs;
				par = Card[card].type;
				p->disable[j] = costs > p->par[par];
			}
		}

		// next player
		p++;
	}
}

char NumBuf[20];

// display state of one player
void DispState1(int player)
{
	int i, n;
	sPlayer* p;
	p = &Players[player];

	// display status background (size 72 x 256)
	DrawImgPal(StateImg, StateImg_Pal, StateX[player], STATEY, STATEW, STATEH, STATEW);

	// display values
	pDrawFont = FontCond6x8;
	DrawFontHeight = 8;
	DrawFontWidth = 6;

	for (i = 0; i < PAR_NUM; i++)
	{
		// decode parameter
		n = p->par[i];
		if (n > 999) n = 999;
		n = DecNum(NumBuf, n, 0);
		n = StateX[player]+30 - n*3;

		// display parameter
		DrawText(NumBuf, n, STATEY+i*STATEDY+2, ParFgCol[i]);
	}
}

// display states of players
void DispState()
{
	DispState1(0);
	DispState1(1);
}

// display grass
void DispGrass(int player)
{
	// display grass
	DrawBlit4Pal(GrassImg, GrassImg_Pal, 0, 0, CastleX[player] - GRASSW/2,
		GRASSY, GRASSW, GRASSH, GRASSW, TRANSCOL);
}

// display castle of one player
void DispCastle(int player)
{
	// prepare castle height
	int h = Players[player].par[PAR_CASTLE]; // h is in range 0..100
	if (h > CASTLEMAX) h = CASTLEMAX;

	// display castle
	int pixh = h + CASTLEH-CASTLEMAX; // castle height
	DrawBlitPal(CastleImg + player*CASTLEW, CastleImg_Pal, CastleX[player] - CASTLEW/2,
		GRASSY + 8 - pixh, CASTLEW, pixh, CASTLEALLW, TRANSCOL);
}

// dispay fence of one player
void DispFence(int player)
{
	// prepare fence height
	int h = Players[player].par[PAR_FENCE]; // h is in range 0..100
	if (h > CASTLEMAX) h = CASTLEMAX;

	// display fence
	int pixh = h + FENCEH-CASTLEMAX;
	DrawImg4Pal(FenceImg, FenceImg_Pal, 0, 0, FenceX[player] - FENCEW/2,
		GRASSY + 8 - pixh, FENCEW, pixh, FENCEW);
}

// display titles - player selection
void DispTitle()
{
	DrawImg4Pal(BlacksRedsImg, BlacksRedsImg_Pal, 0, (Player == 0) ? BLACKSREDSH : 0,
		0, 0, BLACKSREDSW, BLACKSREDSH, BLACKSREDSWALL);

	DrawImg4Pal(BlacksRedsImg, BlacksRedsImg_Pal, BLACKSREDSW, (Player == 1) ? BLACKSREDSH : 0,
		WIDTH-BLACKSREDSW, 0, BLACKSREDSW, BLACKSREDSH, BLACKSREDSWALL);
}

// flag animation
void DispFlag()
{
	int t = (Time() >> 18) & 3;
	int player;
	int i, k;
	sPlayer* p;
	for (player = 0; player < 2; player++)
	{
		p = &Players[player];

		// get castle height
		int h = Players[player].par[PAR_CASTLE]; // h is in range 0..100
		if (h > CASTLEMAX) h = CASTLEMAX;
		int pixh = h + 20; // image height is in range 32..232

		// prepare flag coordinate
		int x = CastleX[player] - 10;
		int y = GRASSY + 8 - pixh;

		// draw background
		DrawImg4Pal(BackgroundImg, BackgroundImg_Pal, x, y,
			x, y, FLAGSW, FLAGSH-5, WIDTH);

		// draw flag
		DrawBlit4Pal(FlagsImg, FlagsImg_Pal,  (t + player*4)*FLAGSW, 0, x, y,
			FLAGSW, FLAGSH, FLAGSALLW, TRANSCOL);
	}
}

// delay with flag animation
void WaitFlag(u8 del)
{
	for (; del > 0; del--)
	{
		DispFlag();
		DispUpdate();
		KeyScan();
		WaitMs(50);
	}
}

// display one card
void DispCard(int type, int x, int y, int shadow, Bool disable, Bool back, Bool discard)
{
	// invalid card
	if (type < 0) return;

	// display card shadow
	if (shadow != 0) DrawBlit1Shadow(ShadowImg, 0, 0, x + shadow, y + shadow,
				CARDW, CARDH, CARDW, 12);
	if (back)
	{
		// display card back side
		DrawBlitPal(CardsImg + CARD_BACK*CARDW, CardsImg_Pal, x, y, CARDW, CARDH, CARDSALLW, TRANSCOL);
	}

	else
	{
		// display card
		DrawBlitPal(CardsImg + type*CARDW, CardsImg_Pal, x, y, CARDW, CARDH, CARDSALLW, TRANSCOL);

		// card is disabled
		if (disable || discard)
			DrawBlit1Shadow(ShadowImg, 0, 0, x, y, CARDW, CARDH, CARDW, 12);

		// card is discarded
		if (discard)
			DrawBlitPal(CardsImg + CARD_DISCARD*CARDW, CardsImg_Pal, x, y,
				CARDW, CARDH, CARDSALLW, TRANSCOL);
	}
}

// save screen content under card
void SaveCard(u16* buf, int x, int y)
{
	int h;
	u16* s = &FrameBuf[x + y*WIDTH];
	for (h = CARDH; h > 0; h--)
	{
		memcpy(buf, s, CARDW*2);
		buf += CARDW;
		s += WIDTH;
	}
}

// card animation
void AnimCard(int type, int x1, int y1, int x2, int y2, Bool back, Bool discard)
{
	// play sound
	PLAYSOUND(CardSnd);

#define ANIMSTEPS 16 // number of steps of animation

	int i, x, y, xs, ys, s;
	for (i = 0; i < ANIMSTEPS; i++)
	{
		// current card position
		x = (x2 - x1)/ANIMSTEPS*i + x1;
		y = (y2 - y1)/ANIMSTEPS*i + y1;

		// shadow position
		s = (int)(4 + 60*sinf(PI*i/ANIMSTEPS));
		xs = x + s;
		ys = y + s;

		// flag animation
		DispFlag();

		// save shadow screen content
		SaveCard(SaveCardBuf, xs, ys);

		// save card screen content
		SaveCard(SaveCardBuf2, x, y);

		// draw card
		DispCard(type, x, y, s, False, back, discard);

		// display update
		DispUpdate();

		// wait
//		WaitMs(20);
		KeyScan();

		// restore screen content
		DrawImg(SaveCardBuf2, x, y, CARDW, CARDH, CARDW);
		DrawImg(SaveCardBuf, xs, ys, CARDW, CARDH, CARDW);
	}

	// display update
//	DispUpdate();
}

// display cards of active player
void DispCards()
{
	int x = 0;
	sPlayer* p = &Players[Player];
	int i = 0;
	for (i = 0; i < CARDNUM; i++)
	{
		if (p->cards[i] < 0) // no card
			DrawImg4Pal(BackgroundImg, BackgroundImg_Pal, x, HEIGHT-CARDH,
				x, HEIGHT-CARDH, CARDW, CARDH, WIDTH);
		else
			DispCard(p->cards[i], x, HEIGHT-CARDH, 0, p->disable[i],
				p->comp && !Demo, False);
		x += CARDW;
	}
}

// cursor ON
void CursorOn()
{
	if (!Players[Player].comp)
	{
		DrawBlit4Pal(CursorImg, CursorImg_Pal, 0, 0, SelCard*CARDW + (CARDW-CURSORW)/2,
			HEIGHT-CARDH + (CARDH-CURSORH)/2 + 6, CURSORW, CURSORH, CURSORW, TRANSCOL);
	}
}

// cursor OFF
void CursorOff()
{
	sPlayer* p = &Players[Player];
	DispCard(p->cards[SelCard], SelCard*CARDW, HEIGHT-CARDH, 0,
		p->disable[SelCard], p->comp && !Demo, False);
}

// take new card
void TakeCard()
{
	// generate new card
	int card = NewCard();

	// card animation
	sPlayer* p = &Players[Player];
	AnimCard(card, MIDX1, 0, FreePos*CARDW, HEIGHT-CARDH, p->comp && !Demo, False);

	// display new card
	p->cards[FreePos] = card;
	p->disable[FreePos] = False;

	// test cards permission
	Permission();

	// redraw all cards
	DispCards();

	// delay
	WaitFlag(5);
}

// change values animation
void ChangeAnim()
{
	int i, player, x, y, n, par, save, h;
	u16 *s, *d;

	// display values
	pDrawFont = FontBold8x8;
	DrawFontHeight = 8;
	DrawFontWidth = 8;

	// length of animtaion
	for (i = 3; i > 0; i--)
	{
		// display values
		save = 0;
		for (player = 0; player < 2; player++)
		{
			// prepare coordinates
			x = (player == 0) ? (STATEW+2) : (WIDTH-STATEW-CLOUDW-2);
			y = STATEY - 1;
			sPlayer* p = &Players[player];

			// loop parameters
			for (par = 0; par < PAR_NUM; par++)
			{
				// parameter changed
				if (p->add[par] != 0)
				{
					// push screen
					s = &FrameBuf[x + y*WIDTH];
					d = &SaveCloudBuf[save];
					for (h = CLOUDH; h > 0; h--)
					{
						memcpy(d, s, CLOUDW*2);
						d += CLOUDW;
						s += WIDTH;
					}

					// draw cloud
					DrawBlit4Pal(CloudImg, CloudImg_Pal, 0, 0, x, y, CLOUDW, CLOUDH, CLOUDW, TRANSCOL);

					// draw value
					if (p->add[par] >= 0)
					{
						NumBuf[0] = '+';
						n = DecNum(NumBuf+1, p->add[par], 0)+1;
						DrawText(NumBuf, x+15-n*4, y+6, RGBTO16(0, 0, 220));
					}
					else
					{
						n = DecNum(NumBuf, p->add[par], 0);
						DrawText(NumBuf, x+15-n*4, y+6, RGBTO16(255, 0, 0));
					}
					save += CLOUDW*CLOUDH;
				}
				y += STATEDY;
			}
		}

		// display update
		DispUpdate();

		// delay with flag animation
		WaitFlag(5);

		// pop screen
		save = 0;
		for (player = 0; player < 2; player++)
		{
			// prepare coordinates
			x = (player == 0) ? (STATEW+2) : (WIDTH-STATEW-CLOUDW-2);
			y = STATEY - 1;
			sPlayer* p = &Players[player];

			// loop parameters
			for (par = 0; par < PAR_NUM; par++)
			{
				// parameter changed
				if (p->add[par] != 0)
				{
					// pop screen
					DrawImg(&SaveCloudBuf[save], x, y, CLOUDW, CLOUDH, CLOUDW);
					save += CLOUDW*CLOUDH;
				}
				y += STATEDY;
			}
		}

		// display update
		DispUpdate();

		// delay with flag animation
		WaitFlag(1);
	}
}

// display whole game area
void DispAll()
{
	// display background
	DrawImg4Pal(BackgroundImg, BackgroundImg_Pal, 0, 0, 0, 0, WIDTH, HEIGHT, WIDTH);

	// display titles - player selection
	DispTitle();

	// display castles and fences
	DispGrass(0);
	DispCastle(0);
	DispFence(0);

	DispGrass(1);
	DispCastle(1);
	DispFence(1);

	// display flags
	DispFlag();

	// display middle cards
	DispCard(0, MIDX1, 0, 0, False, True, False);
	DispCard(Last, MIDX2, 0, 0, False, False, LastDiscard);

	// display state
	DispState();

	// display cards
	DispCards();
}

// start new game
void NewGame(Bool comp1, Bool comp2)
{
	// computer state
	Players[0].comp = comp1;
	Players[1].comp = comp2;
	Demo = (comp1 && comp2);

	// starting player is Black
	Player = 0;

	// none last laid card
	Last = -1;
	LastDiscard = False; // last card was discarded

	// initialize players
	int i, j;
	sPlayer* p = Players;
	for (i = 0; i < 2; i++)
	{
		// set player's parameters
		p->par[PAR_BUILDERS] = 2;
		p->par[PAR_BRICKS] = 5;
		p->par[PAR_SOLDIERS] = 2;
		p->par[PAR_WEAPONS] = 5;
		p->par[PAR_WIZARDS] = 2;
		p->par[PAR_CRYSTALS] = 5;
		p->par[PAR_CASTLE] = 30;
		p->par[PAR_FENCE] = 10;

		// generate cards
		for (j = 0; j < CARDNUM; j++) p->cards[j] = NewCard();

		// next player
		p++;
	}

	// selected card (cursor)
	SelCard = 3;

	// test cards permission
	Permission();

	// display whole game area
	DispAll();

	// display cursor
	CursorOn();
}

// display win game
void WinGame(int player)
{
	EndGame = player;

	// prepare castle height
	sPlayer* p = &Players[player];

	// get castle height
	int h = Players[player].par[PAR_CASTLE]; // h is in range 0..100
	if (h > CASTLEMAX) h = CASTLEMAX;
	int pixh = h + CASTLEH-CASTLEMAX; // castle height

	// prepare trumpet coordinate
	int x = CastleX[player] - TRUMPETW/2 + 23;
	int y = GRASSY + 8 - pixh - 17;

	// play fanfare
	PLAYSOUND(FanfaresSnd);

	// delay - wait for sounds
	while (PlayingSound())
	{
		// animate flags
		DispFlag();

		// draw trumpet image
		DrawBlit4Pal(TrumpetImg, TrumpetImg_Pal, player*TRUMPETW, 0,
			x, y, TRUMPETW, TRUMPETH, TRUMPETALLW, TRANSCOL);

		// display update
		DispUpdate();

		// delay
		WaitMs(30);
	};
	DispAll();

	// play applaus
	PLAYSOUNDREP(ApplauseSnd);

	// winning animation
	y = GRASSY + 8 - 16;
	x = CastleX[player] - WINW/2;
	int anim = 0;
	KeyFlush();
	int i = Demo ? 200 : 1000000000;
	u16 *s, *d;
	for (; i > 0; i--)
	{
		// key
		if (KeyGet() != NOKEY) break;

		// save background
		s = &FrameBuf[x + y*WIDTH];
		d = SaveWinBuf;
		for (h = WINH; h > 0; h--)
		{
			memcpy(d, s, WINW*2);
			d += WINW;
			s += WIDTH;
		}

		// draw image
		DrawBlit4Pal(WinImg, WinImg_Pal, player*4*WINW + (anim>>2)*128, 0,
			x, y, WINW, WINH, WINALLW, TRANSCOL);
		anim++;
		if (anim >= 16) anim = 0;

		// animate flags
		DispFlag();

		// display update
		DispUpdate();

		// delay
		WaitMs(30);

		// restore background
		DrawImg(SaveWinBuf, x, y, WINW, WINH, WINW);
	}

	// stop sound
	StopSound();

	// start new game
	NewGame(Players[0].comp, Players[1].comp);
}

// put card (pos = card position)
void PutCard(int pos, Bool discard)
{
	int i, j;

	// card is disabled
	sPlayer* p = &Players[Player];
	if (p->disable[pos]) discard = True;

	// free card position
	FreePos = pos;

	// card type
	int card = p->cards[pos];
	const sCard* c = &Card[card];

	// subtract card value (if not discarded)
	if (!discard)
	{
		// cost card
		p->par[c->type] -= c->costs;

		// display state
		DispState1(Player);

		// test cards permission
		Permission();
	}

	// delete card
	p->cards[pos] = -1; // no card

	// redraw all cards
	DispCards();

	// card animation
	AnimCard(card, pos*CARDW, HEIGHT-CARDH, MIDX2, 0, False, discard);
	Last = card;
	LastDiscard = discard;

	// dispay last card
	DispCard(Last, MIDX2, 0, 0, False, False, LastDiscard);

	// execute card
	if (!discard)
	{
		// save old state
		int castle1 = Players[0].par[PAR_CASTLE];
		int castle2 = Players[1].par[PAR_CASTLE];
		int fence1 = Players[0].par[PAR_FENCE];
		int fence2 = Players[1].par[PAR_FENCE];
		const u8* snd = NULL;
		int sndlen = 0;

		// clear additions of both players
		for (i = 0; i < PAR_NUM; i++)
		{
			Players[0].add[i] = 0;
			Players[1].add[i] = 0;
		}

		// parameter change
		if (c->param != PAR_NUM) // not extra
		{
			// change to enemy
			if (c->value < 0) p = &Players[Player ^ 1];

			// play sound
			switch (c->param)
			{
			// increase power
			case PAR_BUILDERS:
			case PAR_SOLDIERS:
			case PAR_WIZARDS:
				snd = IncreasePowerSnd;
				sndlen = sizeof(IncreasePowerSnd);
				break;

			// castle
			case PAR_CASTLE:
				if (c->value >= 0)
				{
					// build castle
					snd = BuildCastleSnd;
					sndlen = sizeof(BuildCastleSnd);
				}
				else
				{
					// ruin castle
					snd = RuinCastleSnd;
					sndlen = sizeof(RuinCastleSnd); 
				}
				break;

			// fence
			case PAR_FENCE:
				if (c->value >= 0)
				{
					// build fence
					snd = BuildFenceSnd;
					sndlen = sizeof(BuildFenceSnd);
				}
				else
				{
					if (p->par[PAR_FENCE] < -c->value)
					{
						// ruin fence
						snd = RuinFenceSnd;
						sndlen = sizeof(RuinFenceSnd);
					}
					else
					{
						// ruin castle
						snd = RuinCastleSnd;
						sndlen = sizeof(RuinCastleSnd);
					}
				}
				break;

			// stocks
			// PAR_BRICKS
			// PAR_WEAPONS
			// PAR_CRYSTALS
			default:
				if (c->value >= 0)
				{
					// increase stock
					snd = IncreaseStocksSnd;
					sndlen = sizeof(IncreaseStocksSnd);
				}
				else
				{
					// decrease stock
					snd = DecreaseStocksSnd;
					sndlen = sizeof(DecreaseStocksSnd);
				}
				break;
			}

			// set parameter addition
			p->add[c->param] = c->value;
		}

		// extra service
		else
		{
			switch (card)
			{
			// reserve (castle +8, fence -4)
			case 3:
				p->add[PAR_CASTLE] = 8; // castle +8
				if (p->par[PAR_FENCE] >= 4) // fence -4
					p->add[PAR_FENCE] = -4;
				else
					p->add[PAR_FENCE] = - p->par[PAR_FENCE];

				// build castle
				snd = BuildCastleSnd;
				sndlen = sizeof(BuildCastleSnd);
				break;

			// wain (castle +8, enemy castle -4)
			case 6:
				p->add[PAR_CASTLE] = 8; // castle +8
				Players[Player ^ 1].add[PAR_CASTLE] = -4; // enemy castle -4

				// build castle
				snd = BuildCastleSnd;
				sndlen = sizeof(BuildCastleSnd);
				break;
				
			// saboteur (enemy stocks -4)
			case 16:
				p = &Players[Player ^ 1];
				p->add[PAR_BRICKS] = -4;
				p->add[PAR_WEAPONS] = -4;
				p->add[PAR_CRYSTALS] = -4;

				// decrease stock
				snd = DecreaseStocksSnd;
				sndlen = sizeof(DecreaseStocksSnd);
				break;

			// thief (transfer enemy stocks 5)
			case 17:
				{
					p = &Players[Player ^ 1];

					int bricks = p->par[PAR_BRICKS];
					if (bricks > 5) bricks = 5;
					p->add[PAR_BRICKS] = -bricks;

					int weapons = p->par[PAR_WEAPONS];
					if (weapons > 5) weapons = 5;
					p->add[PAR_WEAPONS] = -weapons;

					int crystals = p->par[PAR_CRYSTALS];
					if (crystals > 5) crystals = 5;
					p->add[PAR_CRYSTALS] = -crystals;

					p = &Players[Player];
					p->add[PAR_BRICKS] = bricks;
					p->add[PAR_WEAPONS] = weapons;
					p->add[PAR_CRYSTALS] = crystals;

					// increase stock
					snd = IncreaseStocksSnd;
					sndlen = sizeof(IncreaseStocksSnd);
				}
				break;

			// curse (all +1, enemie's all -1)
			case 29:
				for (i = 0; i < PAR_NUM; i++) p->add[i] = 1;

				p = &Players[Player ^ 1];
				for (i = 0; i < PAR_NUM; i++)
				{
					if (p->par[i] > 0) p->add[i] = -1;
				}

				snd = CurseSnd;
				sndlen = sizeof(CurseSnd);
				break;
			}
		}

		// display state
		DispState();

		// change values animation
		ChangeAnim();

		// delay - wait for sounds
		while (PlayingSound()) (WaitFlag(1));

		// update parameters
		for (i = 0; i < 2; i++)
		{
			p = &Players[i];
			for (j = 0; j < PAR_NUM; j++)
			{
				p->par[j] += p->add[j];

				// check underflow
				switch (j)
				{
				case PAR_FENCE:
					if (p->par[j] < 0)
					{
						p->par[PAR_CASTLE] += p->par[j];
						if (p->par[PAR_CASTLE] < 0) p->par[PAR_CASTLE] = 0;
						p->par[j] = 0;
					}
					break;

				case PAR_BUILDERS:
				case PAR_SOLDIERS:
				case PAR_WIZARDS:
					if (p->par[j] < 1) p->par[j] = 1;
					break;

				default:
					if (p->par[j] < 0) p->par[j] = 0;
					break;
				}
			}
		}

		// test cards permission
		Permission();

		// play sound
		if (snd != NULL) PlaySound(snd, sndlen);

		// redraw screen - only if castles or fences change
		if ((castle1 != Players[0].par[PAR_CASTLE]) ||
			(castle2 != Players[1].par[PAR_CASTLE]) ||
			(fence1 != Players[0].par[PAR_FENCE]) ||
			(fence2 != Players[1].par[PAR_FENCE]))
		{
			DispAll();
		}
		else
		{
			// display state
			DispState();

			// redraw all cards
			DispCards();
		}

		// delay
		WaitFlag(4);
		while (PlayingSound()) (WaitFlag(1));
	}

	// check player's 0 victory
	if ((Players[0].par[PAR_CASTLE] >= 100) ||
		(Players[1].par[PAR_CASTLE] <= 0))
	{
		WinGame(0);
		return;
	}

	// check player's 1 victory
	if ((Players[1].par[PAR_CASTLE] >= 100) ||
		(Players[0].par[PAR_CASTLE] <= 0))
	{
		WinGame(1);
		return;
	}

	// take new card
	TakeCard();

	// change active player
	Player ^= 1;

	// increase stocks
	p = &Players[Player];
	p->par[PAR_BRICKS] += p->par[PAR_BUILDERS];
	p->par[PAR_WEAPONS] += p->par[PAR_SOLDIERS];
	p->par[PAR_CRYSTALS] += p->par[PAR_WIZARDS];

	// display state
	DispState1(Player);

	// test cards permission
	Permission();

	// redraw all cards
	DispCards();

	// clear player's selection frame
	DispTitle();
}

// find best card
int FindCard()
{
	int i;
	sPlayer* p = &Players[Player];

	// find best enabled card (expensive cards are better)
	int foundinx = -1; // found card position
	int foundval = 0; // found card value
	int card, testval;
	const sCard* c;
	for (i = 0; i < CARDNUM; i++)
	{
		if (!p->disable[i])
		{
			// get card
			card = p->cards[i];
			c = &Card[card];
			testval = c->costs; // card value

			// workers have preference
			if ((c->param == PAR_BUILDERS) ||
				(c->param == PAR_SOLDIERS) ||
				(c->param == PAR_WIZARDS))
			{
				testval = 100;
			}

			// found card with higher value
			if ((testval > foundval) || ((testval == foundval) && (RandU8() < 0x60)))
			{
				foundinx = i;
				foundval = testval;
			}
		}
	}

	// enabled card not found - find card for discard 
	//    (discard expensive cards, they cannot be use for a long time)
	if (foundinx < 0)
	{
		foundinx = 0;

		for (i = 0; i < CARDNUM; i++)
		{
			if (p->disable[i])
			{
				// get card
				card = p->cards[i];
				c = &Card[card];
				testval = c->costs; // card value

				// found card with higher value
				if (testval > foundval)
				{
					foundinx = i;
					foundval = testval;
				}
			}
		}
	}

	return foundinx;
}

// auto play
void AutoPlay()
{
	// small delay
	WaitFlag(8);

	// find next card to play
	int foundinx = FindCard();

	// put card
	PutCard(foundinx, Players[Player].disable[foundinx]);
}

// game
void Game(Bool comp1, Bool comp2, Bool autodemo)
{
	char ch;

	// start new game
	EndGame = -1;
	NewGame(comp1, comp2);

	// main loop
	while (true)
	{
		// active player is computer
		if (Players[Player].comp)
		{
			// auto play
			AutoPlay();

			// display cursor
			CursorOn();

			// flush keyboard
			if (!Demo)
				KeyFlush();
			else
			{
				if (KeyGet() != NOKEY)
				{
					StopSound();
					return;
				}
			}

			// return from auto demo
			if (autodemo && (EndGame >= 0))
			{
				StopSound();
				return;
			}
		}
		else
		{
			// input from keyboard
			ch = KeyGet();

			// serve keyboard
			switch (ch)
			{
			// quit
			case KEY_Y:
				StopSound();
				return;

			// left
			case KEY_LEFT:
				CursorOff();
				SelCard--;
				if (SelCard < 0) SelCard = CARDNUM-1;
				CursorOn();
				KeyFlush();
				break;

			// right
			case KEY_RIGHT:
				CursorOff();
				SelCard++;
				if (SelCard >= CARDNUM) SelCard = 0;
				CursorOn();
				KeyFlush();
				break;

			// discard
			case KEY_UP:
			case KEY_B:
				PutCard(SelCard, True);
				CursorOn();
				KeyFlush();
				break;

			// select
			case KEY_DOWN:
			case KEY_A:
				PutCard(SelCard, Players[Player].disable[SelCard]);
				CursorOn();
				KeyFlush();
				break;

			// help
			case KEY_X:
#if USE_SCREENSHOT		// use screen shots
				ScreenShot();
#endif
				CursorOff();
				SelCard = FindCard();
				CursorOn();
				KeyFlush();
				break;

			// no key
			case NOKEY:
				// birds
				if (!PlayingSound())
				{
					PLAYSOUNDREP(BirdsSnd);
				}
				break;

			// invalid key
			default:
				KeyFlush();
				break;
			}
		}

		// flag animation
		DispFlag();

		// update display
		DispUpdate();
	}
}


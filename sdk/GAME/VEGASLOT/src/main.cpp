
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************
// Note: The reels normally rotate downwards (upwards in special mode).

#include "../include.h"

// winning lines
const s8 LinesTab[WIN_LINES*REEL_NUM] = {
	0,	0,	0,		// 1: middle line
	1,	1,	1,		// 2: top line
	-1,	-1,	-1,		// 3: bottom line
	1,	0,	-1,		// 4: top diagonal
	-1,	0,	1,		// 5: bottom diagonal
};

// game values
int BankVal;	// current bank
int WinVal;	// current win
int UserBetVal; // user selected bet
int BetVal;	// current bet, BET_HIGH = high value, 0 = no bet
int CreditVal;	// current credit
int Bonus;	// remaining bonus game
int WinLines;	// current win lines
int BetCredit;	// bet from credits (1..5)
int BetBank;	// bet from bank (0 = low, 15 = high)
Bool LastHigh; // last game was HIGH
Bool AutoStart; // auto START
Bool Tossing; // toss is in progress
Bool Risking; // risk is in progress
Bool RiskEnable; // risk Start is enabled
Bool RiskHalf; // remains second half of win in risk
int GameIn;	// game-in
int GameOut;	// game-out

// reels
sReel Reels[REEL_NUM];
Bool ReelFast; // fast turning

// display value (-1 = no digit)
void DispVal(int val, int x, int dig)
{
	x += dig*DIGITW; // X after digits
	int k;
	Bool first = True;

	if (val < 0)
	{
		first = False;
		val = 0;
	}

	for (; dig > 0; dig--)
	{
		x -= DIGITW;	// shift X coordinate

		// no digit
		if ((val == 0) && !first)
		{
			DrawImg4Pal(DigitsImg, DigitsImg_Pal, 0, 0, x, DIGITY, DIGITW, DIGITH, DIGITIMGW);
		}
		else
		{
			k = val/10;
			val -= k*10;
			DrawImg4Pal(DigitsImg, DigitsImg_Pal, (val+1)*DIGITW, 0, x, DIGITY, DIGITW, DIGITH, DIGITIMGW);
			val = k;
			first = False;
		}
	}
}

// display bank
void DispBank()
{
	DispVal((BankVal > 9999) ? 9999 : BankVal, BANKX, BANKNUM);
}

// display win
void DispWin()
{
	int k = WinVal;
	if (k > 999) k = 999;
	if (k <= 0) k = -1; // hide win
	DispVal(k, WINX, WINNUM);
}

// display bet
void DispBet()
{
	int k = BetVal;
	if (k == 0) k = -1; // no credit
	if (Bonus != 0) k = 0; // bonus game

	if (k == BET_HIGH)
		DrawImg4Pal(DigitsImg, DigitsImg_Pal, 11*DIGITW, 0, BETX, DIGITY, DIGITW, DIGITH, DIGITIMGW);
	else
		DispVal(k, BETX, BETNUM);
}

// display credit
void DispCredit()
{
	DispVal((CreditVal > 9999) ? 9999 : CreditVal, CREDITX, CREDITNUM);
}

// display one reel
void DispReel(u8 inx)
{
	// variables
	int y = REELY; // destination Y coordinate
	int x = REEL1X + inx*REELW; // destination X coordinate
	int h = REELH; // remaining height
	int h2; // current height
	sReel* r = &Reels[inx];
	int pos = r->pos/256 - 1; // position on reel
	int ys = ((r->pos & 0xff) * SYMBOLH + 100) / 256; // source Y coordinate in symbol
	const u8* tab = &ReelTab[inx*REEL_POS]; // reel table

	// draw reel
	while (h > 0)
	{
		pos &= POS_MASK; // mask current position on reel
		h2 = SYMBOLH - ys; // symbol height
		if (h2 > h) h2 = h; // limit by remaining height
		h -= h2;
		if (r->speed >= REEL_BLURSPEED)
			DrawImgPal(BlurImg + (tab[pos]*SYMBOLH + ys)*SYMBOLW, BlurImg_Pal, x, y, SYMBOLW, h2, SYMBOLW);
		else
			DrawImgPal(SymbolsImg + (tab[pos]*SYMBOLH + ys)*SYMBOLW, SymbolsImg_Pal, x, y, SYMBOLW, h2, SYMBOLW);
		ys = 0; // new source Y coordinate in symbol
		y += h2; // shift destination Y coordinate
		pos++; // increase position on reel
	}

	// top darkness
#define SHADOWDH 1
	int i;
	y = REELY;
	for (i = 1; i <= 15; i++)
	{
		DrawRectShadow(x, y, SYMBOLW, SHADOWDH, i);
		y += SHADOWDH;
	}

	// bottom darkness
	y = REELY + REELH - 1;
	for (i = 1; i <= 15; i++)
	{
		DrawRectShadow(x, y, SYMBOLW, SHADOWDH, i);
		y -= SHADOWDH;
	}

	// win lines darskness
	if (WinLines < 2) DrawRectShadow(x, REELY, SYMBOLW, SYMBOLH, 15);
	if (WinLines < 1) DrawRectShadow(x, REELY+SYMBOLH, SYMBOLW, SYMBOLH, 15);
	if (WinLines < 3) DrawRectShadow(x, REELY+2*SYMBOLH, SYMBOLW, SYMBOLH, 15);
}

// display reels
void DispReels()
{
	int i;
	for (i = 0; i < REEL_NUM; i++) DispReel(i);
}

// set win lines
void SetWinLines(int lines)
{
	WinLines = lines;
	DispReels();
}

// calculate parameters for turning reels
//   Requires "dir", "pos" and "dest" parameters to be set.
//   Sets parameters "rem", "wait", "over" and "past".
void CalcReel(Bool fast)
{
	ReelFast = fast; // fast turning
	sReel* r;

	int i;
	int inx;
	for (inx = 0; inx < REEL_NUM; inx++)
	{
		r = &Reels[inx];

		// remaining whole turns (1st reel = 1 turn, 2nd reel = 2 turns, 3rd reel = 3 turns)
		if (fast)
			r->rem = (inx+1)*REEL_POS*256;
		else
			r->rem = 0;

		// start delay
		r->wait = inx*REEL_STARTDEL;

		// calculate remaining steps to get destination position
		i = r->dest - r->pos;
		if (r->dir == REELDIR_FORW) i = -i;
		r->rem += i & POSH_MASK;

		// overshoot in case of fast turning
		r->over = 0;
		r->speed = 0;
		if (fast)
		{
			r->past = 0; // pasting steps * 256
			r->rem += REEL_OVERSTEPS; // add overshoot steps
			r->over = REEL_OVERSTEPS; // overshoot steps
		}

		// state - turning in
		r->state = REELSTATE_IN;
	}
}

// turning reels
//   Requires "dir", "pos" and "dest" parameters to be set.
void TurnReel(Bool fast)
{
	int shift;
	sReel* r;
	int inx;
	Bool moving;
	u32 t, t2;

	// calculate parameters for turning reels
	CalcReel(fast);

	// sound
	if (fast)
	{
		PlaySoundChan(1, ReelSnd, count_of(ReelSnd), True, 1, 0.3f);
		PLAYSOUND(StartSnd);
	}
	
	// until some reel is moving
	t = Time();
	do {
		moving = False;

		// process one step of reels
		for (inx = 0; inx < REEL_NUM; inx++)
		{
			r = &Reels[inx];

			// reel is wating to start
			if (r->wait > 0)
				r->wait--;
			else
			{
				// while reel is moving
				if ((r->rem > 0) || (r->over > 0))
				{
					// slow turning
					if (!fast)
					{
						shift = REEL_SLOWSPEED;
						if (shift > r->rem) shift = r->rem;
						r->rem -= shift;
					}

					// fast turining
					else
					{
						// turning in
						if (r->state == REELSTATE_IN)
						{
							// accelerated shift
							shift = r->past/REEL_ACCEL + REEL_SLOWSPEED;
							if (shift > r->rem) shift = r->rem/2;
							r->past += shift; // shift pasting steps
							r->rem -= shift; // shift remaining steps

							// change to turning out after half of steps
							if (r->rem <= r->past) r->state = REELSTATE_OUT;
						}

						// turning out
						else if (r->state == REELSTATE_OUT)
						{
							// decelerated shift
							shift = r->rem/REEL_ACCEL + REEL_SLOWSPEED;

							// change to overshoot
							if (r->rem <= shift)
							{
								shift = r->rem;
								r->state = REELSTATE_OVER;
							}
							r->rem -= shift; // shift remaining steps
						}

						// overshoot
						else
						{
							shift = REEL_SLOWSPEED;
							if (shift >= r->over) shift = r->over;
							r->over -= shift;
							shift = -shift;
						}
					}

					// move reel (normal direction DOWN: decrease position, shift < 0)
					r->speed = shift;
					if (r->dir == REELDIR_FORW) shift = -shift;
					r->pos = (r->pos + shift) & POSH_MASK;

					if ((r->rem <= 0) && (r->over <= 0) && fast) PLAYSOUND(StopSnd);
				}
			}

			// some reel is still moving
			if ((r->rem > 0) || (r->over > 0))
				moving = True;
			else
				r->pos = r->dest;
		}

		// display reels and display update
		DispReels();
		DispUpdate();

		// wait
		do t2 = Time(); while ((u32)(t2 - t) < REEL_TIMEINC*1000);
		t = t2;
		KeyScan();

	} while (moving);

	// stop turning sound
	StopSoundChan(1);
}

// set win
void SetWin(int win)
{
	WinVal = win;
	DispWin();
}

// set bet with correction
void SetBet(int bet)
{
	// minimal bet
	if (bet < 1) bet = 1;

	// prepare bet components
	int betcredit = bet;
	int betbank = 0;
	if (bet == BET_HIGH) // high game
	{
		betcredit = 5;
		betbank = 15;
	}

	// limit bet	
	if ((CreditVal < betcredit) || (BankVal < betbank))
	{
		betbank = 0;
		betcredit = CreditVal;
		if (betcredit > 5) betcredit = 5;
		bet = betcredit;
	}

	// set new bet
	BetVal = bet;
	SetWinLines(betcredit);
	BetCredit = betcredit;
	BetBank = betbank;

	// display bet
	DispBet();
}

// add bank
void AddBank(int add)
{
	if (add != 0)
	{
		BankVal += add;
		if (BankVal < 0) BankVal = 0;
		DispBank(); // display bank
		SetBet(UserBetVal); // bet correction
	}
}

// add credit
void AddCredit(int add)
{
	if (add != 0)
	{
		CreditVal += add;
		if (CreditVal < 0) CreditVal = 0;
		DispCredit(); // display bank
		SetBet(UserBetVal); // bet correction
	}
}

// subtract bet
void SubBet()
{
	// not in bonus game
	if (Bonus == 0)
	{
		// add credit
		GameIn += BetCredit;
		AddCredit(-BetCredit);

		// add bank
		GameIn += BetBank;
		AddBank(-BetBank);
	}
}

// win toss
const sWinItem* WinToss(int lines)
{
	// address of win table
	const sWinItem* item = WinTabs[lines-1];

	// random number
	int rnd = RandU16();

	// not a win
	if ((u16)rnd >= item->rand) return item;

	// find win type
	do {
		item++;
		rnd -= item->rand;
	} while (rnd >= 0);

	return item;
}

// test symbol on reel position
//  output ... packed winning symbols
//		bit 0..2 symbol on line 0, SYMBOL_NUM = no win
//		bit 3..5 symbol on line 1, SYMBOL_NUM = no win
//		bit 6..8 symbol on line 2, SYMBOL_NUM = no win
//		bit 9..11 symbol on line 3, SYMBOL_NUM = no win
//		bit 12..14 symbol on line 4, SYMBOL_NUM = no win
u16 TestSymbol(int pos1, int pos2, int pos3)
{
	int line;
	u16 acc;
	const s8* lin;
	u8 sym1, sym2, sym3;

	// go through all winning lines
	lin = LinesTab + WIN_LINES*REEL_NUM; // winning lines, end of table
	acc = 0; // symbol accumulator
	for (line = WIN_LINES-1; line >= 0; line--)
	{
		acc <<= 3;

		// get all 3 symbols
		lin--; sym3 = ReelTab[2*REEL_POS + ((pos3 + *lin) & POS_MASK)];
		lin--; sym2 = ReelTab[1*REEL_POS + ((pos2 + *lin) & POS_MASK)];
		lin--; sym1 = ReelTab[0*REEL_POS + ((pos1 + *lin) & POS_MASK)];
		
		// check win on this line
		if ((sym1 == sym2) && (sym1 == sym3))
			acc |= sym1;
		else
			acc |= SYMBOL_NUM;
	}
	return acc;
}

// calculate winning prize
//  winsym ... packed winning symbols
//		bit 0..2 symbol on line 0, SYMBOL_NUM = no win
//		bit 3..5 symbol on line 1, SYMBOL_NUM = no win
//		bit 6..8 symbol on line 2, SYMBOL_NUM = no win
//		bit 9..11 symbol on line 3, SYMBOL_NUM = no win
//		bit 12..14 symbol on line 4, SYMBOL_NUM = no win
int GetPrize(int lines, u16 winsym)
{
	int acc = 0;
	u8 sym;
	for (; lines > 0; lines--)
	{
		sym = winsym & 7;
		if (sym != SYMBOL_NUM) acc += WinValTab[sym];
		winsym >>= 3;
	}
	return acc;
}

// get winning types
//  winsym .... packed winning symbols
//		bit 0..2 symbol on line 0, SYMBOL_NUM = no win
//		bit 3..5 symbol on line 1, SYMBOL_NUM = no win
//		bit 6..8 symbol on line 2, SYMBOL_NUM = no win
//		bit 9..11 symbol on line 3, SYMBOL_NUM = no win
//		bit 12..14 symbol on line 4, SYMBOL_NUM = no win
//  output: .... packed winning types
//		bit 0..2 (3 bits): symbol 1
//		bit 3..5 (3 bits): number of lines with symbol 1
//		bit 6..8 (3 bits): symbol 2
//		bit 9..11 (3 bits): number of lines with symbol 2
//		bit 12..14 (3 bits): symbol 3
//		bit 15 (1 bit): number of lines with symbol 3
u16 GetTypes(int lines, u16 winsym)
{
	int i;
	u8 sym;
	int num[SYMBOL_NUM]; // counter of winning symbols
	for (i = 0; i < SYMBOL_NUM; i++) num[i] = 0;

	// count winning symbols
	for (; lines > 0; lines--)
	{
		sym = winsym & 7; // get symbol
		if (sym != SYMBOL_NUM) num[sym]++;
		winsym >>= 3;
	}

	// pack symbol counters
	u16 acc = 0;
	for (i = SYMBOL_NUM-1; i >= 0; i--)
	{
		if (num[i] > 0)
		{
			acc <<= 3;
			acc |= num[i]; // number of lines
			acc <<= 3;
			acc |= i; // index of symbol
		}
	}

	return acc;
}

// search winning reel position (sets "dest" of reels)
void FindReel(int lines, const sWinItem* item)
{
	int i, j;
	int pos1, pos2, pos3;
	int prize;
	u16 winsym;
	Bool ok;

	// not winning position
	if (item->value == 0)
	{
		// number of total not-wins
		i = REEL_POS*REEL_POS*REEL_POS - item->num;

		// index of random not-win variant
		i = RandU16Max(i-1);

		// search reel position
		for (pos3 = 0; pos3 < REEL_POS; pos3++)
		{
			for (pos2 = 0; pos2 < REEL_POS; pos2++)
			{
				for (pos1 = 0; pos1 < REEL_POS; pos1++)
				{
					// get win symbols on lines
					winsym = TestSymbol(pos1, pos2, pos3);

					// check winning prize
					prize = GetPrize(lines, winsym);
	
					// check not-win position
					if (prize == 0)
					{
						i--;
						if (i < 0) break;
					}
				}
				if (i < 0) break;
			}
			if (i < 0) break;
		}
	}

	// winning position
	else
	{
		// index of random win variant
		i = RandU16Max(item->num - 1);

		// search reel position
		for (pos3 = 0; pos3 < REEL_POS; pos3++)
		{
			for (pos2 = 0; pos2 < REEL_POS; pos2++)
			{
				for (pos1 = 0; pos1 < REEL_POS; pos1++)
				{
					// get win symbols on lines
					winsym = TestSymbol(pos1, pos2, pos3);

					// check winning prize
					prize = GetPrize(lines, winsym);
	
					// check win position
					if ((prize == item->value) && (GetTypes(lines, winsym) == item->type))
					{
						i--;
						if (i < 0) break;
					}
				}
				if (i < 0) break;
			}
			if (i < 0) break;
		}
	}

	// set destination position
	Reels[0].dest = pos1 * 256;
	Reels[1].dest = pos2 * 256;
	Reels[2].dest = pos3 * 256;
}

// get new reel position
void GetReelPos(int lines)
{
	const sWinItem* item;
	int prize;
	u16 winsym;

	// bonus game
	if (Bonus > 0)
	{
		// test whether it will be a win
		u16 rnd = RandU16();

		// lost in bonus game
		if ((rnd & 3) == 0)
		{
			// repeat win toss if it is a win
			do item = WinToss(lines); while (item->value > 0);				
		}

		// win in bonus game
		else
		{
			// repeat win toss if is it not a win
			do item = WinToss(lines); while (item->value == 0);
		}
	}

	// normal game
	else
	{
		// win toss
		item = WinToss(lines);

		// not a win
		if (item->value == 0)
		{
			// use bluff-win (fake win on 5 winlines)
			if ((lines != 5) && ((RandU16() & 3) == 0))
			{
				do {
					// find win on 5 lines
					do item = WinToss(5); while (item->value == 0);

					// find reel position
					FindReel(5, item);

					// get win symbols on lines
					winsym = TestSymbol(Reels[0].dest/256, Reels[1].dest/256, Reels[2].dest/256);

					// check winning prize
					prize = GetPrize(lines, winsym);

				// find not-win position, which would win on 5 winlines
				} while (prize > 0);

				return;
			}
		}
	}

	// find reel position
	FindReel(lines, item);
}

// win indication
//  win .... packed winning symbols
//		bit 0..2 symbol on line 0, SYMBOL_NUM = no win
//		bit 3..5 symbol on line 1, SYMBOL_NUM = no win
//		bit 6..8 symbol on line 2, SYMBOL_NUM = no win
//		bit 9..11 symbol on line 3, SYMBOL_NUM = no win
//		bit 12..14 symbol on line 4, SYMBOL_NUM = no win
void WinInd(int lines, int winsym, int prize)
{
	// play sound
	PLAYSOUND(WinSnd);

	int i;
	for (i = 8; i > 0; i--)
	{
		SetWin(prize);
		DispUpdate();
		WaitMs(100);

		KeyScan();

		SetWin(0);
		DispUpdate();
		WaitMs(100);

		KeyScan();
	}
}

// do cash
void DoCash()
{
	int i;

	// transfer bank to credit
	i = BankVal;
	if (i > 0)
	{
		if (i > 100) i = 100;
		AddCredit(i);
		AddBank(-i);
		PLAYSOUND(CashSnd);
	}
	else
	{
		i = CreditVal;
		if (i > 0)
		{
			if (i > 100) i = 100;
			AddCredit(-i);
			PLAYSOUND(OutSnd);
		}
	}
}

// transfer win
//   prize ... win to transfer
//   tobank .... transfer to bank (or to credit otherwise)
void WinTrans(int prize, Bool tobank, int remain)
{
	// transfer sound
	PLAYSOUND(TransferSnd);

	// prepare value for one transfer
	int trans;
	if (prize <= 20)
		trans = 2;
	else if (prize <= 50)
		trans = 5;
	else if (prize <= 100)
		trans = 10;
	else if (prize <= 200)
		trans = 20;
	else
		trans = 50;

	// transfer win
	while (prize > 0)
	{
		// limit remaining transfer size
		if (trans > prize) trans = prize;
		prize -= trans;

		// add to bank or credit
		if (tobank)
			AddBank(trans);
		else
			AddCredit(trans);

		// display remaining win
		SetWin(prize + remain);

		// delay
		DispUpdate();
		WaitMs(100);

		KeyScan();
	}
}

// do risk game
void DoRisk(int prize)
{
	int i;

	// autostart
	if (AutoStart)
	{
		// transfer all win to bank
		WinTrans(prize, True, 0);
		return;
	}

	// set risking mode
	Risking = True;

	// first half of win
	RiskHalf = False;

	// while some win remain
	while (prize > 0)
	{
		// check if risk start is enabled
		RiskEnable = (prize <= MAXWIN/2) && (prize >= 10);

		// display win blinking
		SetWin((((Time() >> 17) & 1) == 0) ? prize : 0);

		// get key
		switch (KeyGet())
		{
		// transfer to bank
		case KEY_LEFT:
			i = prize;

			// transfer only first half of win
			if (!RiskHalf && (prize > 10))
			{
				i /= 2;
				RiskHalf = True;
			}

			prize -= i;
			WinTrans(i, True, prize);
			KeyFlush();
			break;

		// transfer to credit
		case KEY_RIGHT:
			i = prize;

			// transfer only first half of win
			if (!RiskHalf && (prize > 10))
			{
				i /= 2;
				RiskHalf = True;
			}

			prize -= i;
			WinTrans(i, False, prize);
			KeyFlush();
			break;

		// risk
		case KEY_A:
			if (RiskEnable)
			{
				// risk result
				if ((RandU16() & 1) == 0)
				{
					// risk lost
					PLAYSOUND(RiskLostSnd);
					prize /= 2;
				}
				else
				{
					// risk win
					PLAYSOUND(RiskWinSnd);
					prize *= 2;
				}

				RiskHalf = False;
			}
			KeyFlush();
			break;

		// autostart
		case KEY_X:
			AutoStart = True;
			WinTrans(prize, True, 0);
			KeyFlush();
			return;
		}

		DispUpdate();
	}
	
	// display no win
	SetWin(0);

	// stop risking mode
	Risking = False;
}

// do toss
void DoToss()
{
	int i, k, n;
	Tossing = True;
	AutoStart = False;
	u32 t;
	u8 ch;

	PlaySoundChan(1, TossSnd, sizeof(TossSnd), True, 1, 0.5f);

	// while there is enough credits
	while ((BetCredit > 0) && (BetCredit <= CreditVal))
	{
		// one game
		t = Time();
		for (;;)
		{
			// display random value
			k = (RandU16() & 7) + 1; // random number 1..8
			DispVal(k, BETX, BETNUM); // display bet
			DispUpdate(); // display update
			KeyScan();
			WaitMs(100);

			// minimal game time is 1 second
			if ((u32)(Time() - t) >= 1000000)
			{
				ch = KeyGet();

				// switch off autostart
				if (AutoStart)
				{
					if (ch != NOKEY)
					{
						// switch off autostart
						PLAYSOUND(AutoOffSnd);
						AutoStart = False;
						ch = NOKEY;
						KeyFlush();
					}
					else
						ch = KEY_A;
				}

				// roll
				if (ch == KEY_A)
				{
					// subtract credit
					n = BetCredit;
					AddCredit(-n);

					// random
					k = (RandU16() & 7) + 1; // random number 1..8
					DispVal(k, BETX, BETNUM); // display bet
					DispUpdate(); // display update

					// check win
					if ((k & 1) == 1)
					{
						// odd: lost
						PlaySoundChan(0, RiskLostSnd, sizeof(RiskLostSnd), False, 1, 0.3f);
						n = 0;
					}
					else
					{
						// even: win
						PlaySoundChan(0, RiskWinSnd, sizeof(RiskWinSnd), False, 1, 1);
						n *= 2;
						AddBank(n);
					}

					// display win
					SetWin(n);
					WaitMs(200);
					SetWin(0);
					KeyFlush();
					break;
				}

				// autostart
				else if (ch == KEY_X)
				{
					PLAYSOUND(AutoOnSnd);
					AutoStart = True;
					while (PlayingSound()) {}
					KeyFlush();
				}					

				// exit
				else if (ch == KEY_LEFT)
				{
					KeyFlush();
					DispBet();
					StopSoundChan(1);
					return;
				}
			}
		}
	}

	DispBet();
	StopSoundChan(1);
}

// new game
void NewGame()
{
	int i;

	// display background
	DrawImgRle(BackImg, BackImg_Pal, 0, 0, WIDTH, HEIGHT);

	// initialize values
	BankVal = 0; // current bank
	WinVal = 0; // current win
	UserBetVal = 3; // user selected bet
	BetVal = 3; // current bet
	CreditVal = 100; // current credit
	Bonus = 0; // remaining bonus
	WinLines = 3; // win lines	
	BetCredit = 3; // bet from credits
	BetBank = 0; // bet from bank
	LastHigh = False; // last game was HIGH
	AutoStart = False; // autostart
	Tossing = False; // toss is in progress
	Risking = False; // risk is in progress
	RiskEnable = False; // risk Start is enabled
	RiskHalf = False; // remains second half of win in risk
	GameIn = 0; // game-in
	GameOut = 0; // game-out

	// current reel pixel positions, 0=symbol 0 is in base line 0
	for (i = 0; i < REEL_NUM; i++)
	{
		Reels[i].pos = 0;
		Reels[i].dir = REELDIR_FORW;
	}

	// display reels
	DispReels();

	// display values
	DispBank();
	DispWin();
	DispBet();
	DispCredit();
}

int main()
{
	int prize, lines;
	u16 winsym;
	u8 ch;

	// init new game
	NewGame();

	DispUpdate();

	while (True)
	{
		ch = KeyGet();

		if (AutoStart)
		{
			// autostart
			if ((ch == NOKEY) && (CreditVal > 0))
				ch = KEY_A;
			else
			{
				// switch off autostart
				PLAYSOUND(AutoOffSnd);
				AutoStart = False;
				ch = NOKEY;
				KeyFlush();
			}
		}

		switch (ch)
		{
		case KEY_A:
			if (!AutoStart) KeyFlush();

			// valid bet
			if (BetVal > 0)
			{
				// find next turn
				lines = WinLines;
				GetReelPos(lines);

				// flag of high game
				LastHigh = (BetBank > 0);

				// subtract bet
				SubBet();

				// direction (bonus turns back)
				int dir = (Bonus == 0) ? REELDIR_FORW : REELDIR_BACK;
				Reels[0].dir = dir;
				Reels[1].dir = dir;
				Reels[2].dir = dir;

				// turn reels, fast mode
				TurnReel(True);

				// get win symbols on lines
				winsym = TestSymbol(Reels[0].pos/256, Reels[1].pos/256, Reels[2].pos/256);

				// check winning prize
				prize = GetPrize(lines, winsym);

				// win, calculate HIGH game
				if (prize > 0)
				{
					// bonus game = 4*win
					if ((Bonus == 0) && LastHigh) prize *= 4;

					// limit win
					if (prize > MAXWIN)
					{
						Bonus += prize; // add win to bonus
						prize = MAXWIN; // limit win
						DispBet(); // display bet '0'
					}

					// win indication
					WinInd(lines, winsym, prize);

					// subtract bonus
					if (Bonus > 0)
					{
						Bonus -= prize;
						if (Bonus < 0) Bonus = 0;
						DispBet();
					}

					GameOut += prize;

					// risk
					DoRisk(prize);
				}
			}

			if (!AutoStart) KeyFlush();
			break;

		// bet
		case KEY_B:
			KeyFlush();
			if ((Bonus == 0) && (CreditVal > 0))
			{
				int bet = UserBetVal + 1;
				if (bet > BET_HIGH) bet = 1;
				int oldbet = BetVal;
				SetBet(bet);
				if (oldbet == BetVal) SetBet(1);
				UserBetVal = BetVal;
				if (UserBetVal == 0) UserBetVal = 1;
			}
			KeyFlush();
			break;

		// refill
		case KEY_UP:
			KeyFlush();
			PLAYSOUND(CashSnd);
			AddCredit(10);
			KeyFlush();
			break;

		// cash
		case KEY_DOWN:
			KeyFlush();
			DoCash();
			KeyFlush();
			break;

		// toss
		case KEY_LEFT:
			KeyFlush();
			DoToss();
			KeyFlush();
			break;

		// autostart
		case KEY_X:
#if USE_SCREENSHOT		// use screen shots
			ScreenShot();
#endif
			PLAYSOUND(AutoOnSnd);
			AutoStart = True;
			while (PlayingSound()) {}
			KeyFlush();
			break;

		case KEY_Y: ResetToBootLoader();
		}

		// display update
		DispUpdate();
	}


}

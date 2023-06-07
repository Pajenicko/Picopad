// VegaslotTab.cpp : Defines the entry point for the console application.
//

#include <stdio.h>

#define PROFIT	9400		// required profit in percentage * 100

typedef signed char s8;
typedef unsigned char u8;
typedef signed short s16;		// on 8-bit system use "signed int"
typedef unsigned short u16;		// on 8-bit system use "unsigned int"
typedef signed long int s32;		// on 64-bit system use "signed int"
typedef unsigned long int u32;		// on 64-bit system use "unsigned int"
typedef signed long long int s64;
typedef unsigned long long int u64;

// Symbols:
#define CHE		0	// cherry
#define APP		1	// apple
#define PLU		2	// plum
#define PEA		3	// pear
#define GRA		4	// grape
#define BEL		5	// bell

#define SYMBOL_NUM	6	// number of types of symbol

#define REEL_NUM	3		// number of reels
#define REEL_POS	32		// number of reel positions

#define WIN_LINES	5		// number of winning lines
#define SYM_MASK	0x07	// symbol mask (3 bits, value 0..5)
#define POS_MASK	0x1f	// position mask (5 bits, value 0..31)

const char* SymName[SYMBOL_NUM] = {
	"CHE",
	"APP",
	"PLU",
	"PEA",
	"GRA",
	"BEL",
};

// Symbols on reels
//   CHE=cherry, APP=apple, PLU=plum, PEA=pear, GRA=grape, BEL=bell
const u8 ReelTab[REEL_NUM*REEL_POS] = {
	CHE,CHE,CHE,CHE,CHE,APP,APP,PLU,PLU,PEA,PLU,APP,CHE,PLU,APP,CHE,GRA,PEA,APP,PEA,GRA,CHE,APP,GRA,PEA,GRA,APP,PLU,PLU,BEL,CHE,APP,
	CHE,CHE,CHE,APP,CHE,APP,APP,PLU,PEA,PLU,APP,PEA,PLU,APP,CHE,GRA,PEA,GRA,PEA,PLU,CHE,PLU,APP,GRA,PEA,GRA,CHE,APP,PEA,BEL,APP,CHE,
	CHE,CHE,CHE,GRA,CHE,APP,APP,APP,PLU,CHE,GRA,PLU,PEA,PLU,CHE,PEA,GRA,PEA,CHE,PEA,BEL,GRA,PLU,GRA,PEA,GRA,CHE,PEA,GRA,BEL,PLU,APP,
};

// winning lines
const s8 LinesTab[WIN_LINES*REEL_NUM] = {
	0,	0,	0,		// 1: middle line
	1,	1,	1,		// 2: top line
	-1,	-1,	-1,		// 3: bottom line
	1,	0,	-1,		// 4: top diagonal
	-1,	0,	1,		// 5: bottom diagonal
};

// winning valules
const u16 WinValTab[SYMBOL_NUM] = { 10, 20, 50, 100, 200, 750 };

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

#define WINTAB_MAX	1000	// max. number of winning items
sWinItem WinTab[WINTAB_MAX]; // win table
int WinTabNum;	// number of winning entries
int WinTabTot; // total number of wins
u16 WinTabRand; // total randomness of wins
int WinTabProf; // game profit per mille
u16 WinTabMul = 8000; // multiplier for game profit

// test symbol on reel position
//  output ... packed winning symbols
//		bit 0..2 symbol on line 0, SYMBOL_NUM = no win
//		bit 3..5 symbol on line 1, SYMBOL_NUM = no win
//		bit 6..8 symbol on line 2, SYMBOL_NUM = no win
//		bit 9..11 symbol on line 3, SYMBOL_NUM = no win
//		bit 12..14 symbol on line 4, SYMBOL_NUM = no win
int TestSymbol(int pos1, int pos2, int pos3)
{
	int acc, line;
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
//  win ... packed winning symbols
//		bit 0..2 symbol on line 0, SYMBOL_NUM = no win
//		bit 3..5 symbol on line 1, SYMBOL_NUM = no win
//		bit 6..8 symbol on line 2, SYMBOL_NUM = no win
//		bit 9..11 symbol on line 3, SYMBOL_NUM = no win
//		bit 12..14 symbol on line 4, SYMBOL_NUM = no win
int GetPrize(int lines, int win)
{
	int acc = 0;
	u8 sym;
	for (; lines > 0; lines--)
	{
		sym = win & 7;
		if (sym != SYMBOL_NUM) acc += WinValTab[sym];
		win >>= 3;
	}
	return acc;
}

// get winning types
//  win .... packed winning symbols
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
u16 GetTypes(int lines, int win)
{
	int i;
	u8 sym;
	int num[SYMBOL_NUM]; // counter of winning symbols
	for (i = 0; i < SYMBOL_NUM; i++) num[i] = 0;

	// count winning symbols
	for (; lines > 0; lines--)
	{
		sym = win & 7; // get symbol
		if (sym != SYMBOL_NUM) num[sym]++;
		win >>= 3;
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

// calculate winning table
void CalcWinTab(int lines)
{
	int pos1, pos2, pos3, prize, i, winsym;
	u16 wintype;
	sWinItem* item;

	WinTabNum = 0; // number of winning entries
	WinTabTot = 0; // total number of wins

	// go through all reel positions
	for (pos3 = 0; pos3 < REEL_POS; pos3++)
	{
		for (pos2 = 0; pos2 < REEL_POS; pos2++)
		{
			for (pos1 = 0; pos1 < REEL_POS; pos1++)
			{
				// test winning symbol
				winsym = TestSymbol(pos1, pos2, pos3);

				// get winning prize
				prize = GetPrize(lines, winsym);

				// valid win
				if (prize > 0)
				{
					// total number of wins
					WinTabTot++;

					// get winning types
					wintype = GetTypes(lines, winsym);

					// search, is this win already exists
					item = WinTab;
					for (i = 0; i < WinTabNum; i++)
					{
						if ((item->value == prize) && (item->type == wintype))
						{
							item->num++;
							break;
						}
						item++;
					}

					// new entry
					if (i == WinTabNum)
					{
						item->value = prize;
						item->type = wintype;
						item->num = 1;
						item->rand = 1;
						WinTabNum++;
					}
				}
			}
		}
	}
}

// sort winning table (slow, but that's not important)
void SortWinTab()
{
	int i;
	sWinItem* item;
	if (WinTabNum < 2) return; // few entries
	u16 k;

	bool restart;
	do {
		restart = false;

		item = WinTab;
		for (i = 0; i < WinTabNum-1; i++)
		{
			// compare items
			if ((item[0].value > item[1].value) ||
					((item[0].value == item[1].value) &&
						(item[0].type > item[1].type)))
			{
				// exchange items
				k = item[0].value; item[0].value = item[1].value; item[1].value = k;
				k = item[0].type; item[0].type = item[1].type; item[1].type = k;
				k = item[0].num; item[0].num = item[1].num; item[1].num = k;

				// need repeat sorting
				restart = true;
			}
			item++;
		}

	} while (restart);
}

// calculate randomness
void CalcWinRand(int lines)
{
	int i;

	// reset total randomness
	WinTabRand = 0;

	sWinItem* item = WinTab;
	for (i = 0; i < WinTabNum; i++)
	{
		item->rand = (u16)((u32)WinTabMul/item->value + (item->num / 4));
		WinTabRand += item->rand;
		item++;
	}
}

// calculate winning game profit
void CalcWinProf(int lines)
{
	int i;
	sWinItem* item = WinTab;

	// calculate profit of all wins
	u64 accu = 0; // accumulator
	for (i = 0; i < WinTabNum; i++)
	{
		accu += item->value * item->rand;
		item++;
	}

	// calculate game profit per mille (10000 * win_sum / (bet * 65536))
	accu *= 10000;
	accu >>= 16;
	accu /= lines;
	WinTabProf = (u16)accu;
}

int main(int argc, char* argv[])
{
	int i, j, k;
	sWinItem *item;

	// print header
	printf("#include \"../include.h\"\n\n");
	printf("// Symbols on reels\n");
	printf("//   CHE=cherry, APP=apple, PLU=plum, PEA=pear, GRA=grape, BEL=bell\n");
	printf("const u8 ReelTab[REEL_NUM*REEL_POS] = {\n");

	// print reels
	const u8* r = ReelTab;
	for (i = REEL_NUM; i > 0; i--)
	{
		printf("\t");
		for (j = REEL_POS; j > 0; j--) printf("%s,", SymName[*r++]);
		printf("\n");
	}
	printf("};\n\n");

	// print win values
	printf("// Winning values\n");
	printf("const u16 WinValTab[SYMBOL_NUM] = { ");
	for (i = 0; i < SYMBOL_NUM; i++) printf("%d, ", WinValTab[i]);
	printf("};\n\n");

	// print winning tables
	for (i = 1; i <= WIN_LINES; i++) // i = number of winning lines
	{
		// calculate winning table
		CalcWinTab(i);

		// sort winning table
		SortWinTab();

		// Calculate rough game profit
		WinTabMul = 8000;
		CalcWinRand(i);	// calculate randomness
		CalcWinProf(i);	// calculate winning game profit

		// First correction of game profit - direct proportion
		WinTabMul = PROFIT * WinTabMul / WinTabProf;

		// Second correction of game profit - loop correction
		for (j = 1000; j > 0; j--)
		{
			CalcWinRand(i);	// calculate randomness
			CalcWinProf(i);	// calculate winning game profit

			// correction
			if (WinTabProf == PROFIT) break; // check profit if it is OK
			if (WinTabProf < PROFIT)
				WinTabMul++;
			else
				WinTabMul--;
		}

		// Third correction of game profit - correction of first win
		for (j = WinTab[0].rand/2; j > 0; j--)
		{
			if (WinTabProf == PROFIT) break; // check profit if it is OK
			if (WinTabProf < PROFIT)
			{
				WinTab[0].rand++;
				WinTabRand++;
			}
			else
			{
				WinTab[0].rand--;
				WinTabRand--;
			}
			CalcWinProf(i);	// calculate winning game profit
		}

		// print header of table
		printf("// Winning table for %d lines\n", i);
		printf("const sWinItem WinTab%d[%d] = {\n", i, WinTabNum+1);

		// print zero entry: zero profit, number of rows, total number of wins, total randomness
		printf("\t{ %d,\t%d,\t%d,\t%d },\t// Profit %.2f%%\n",
				0, WinTabNum, WinTabTot, WinTabRand, WinTabProf*0.01);

		// print entries
		item = WinTab;
		for (j = 0; j < WinTabNum; j++)
		{
			printf("\t{ %d,\t%d,\t%d,\t%d },\t// ", item->value, item->type, item->num, item->rand);

			// print value of symbol 1
			k = WinValTab[item->type & 7];
			printf("%d", k);
			k = (item->type >> 3) & 7;
			if (k > 1) printf("x%d", k);

			// print value of symbol 2
			if (((item->type >> 9) & 7) > 0)
			{
				k = WinValTab[(item->type >> 6) & 7];
				printf(" %d", k);
				k = (item->type >> 9) & 7;
				if (k > 1) printf("x%d", k);

				// print value of symbol 2
				if ((item->type >> 15) > 0)
				{
					k = WinValTab[(item->type >> 12) & 7];
					printf(" %d", k);
				}
			}

			printf("\n");
			item++;
		}
		printf("};\n\n");
	}

	// table addresses
	printf("// List of winning tables\n");
	printf("const sWinItem* WinTabs[WIN_LINES] = {\n");
	for (i = 1; i <= WIN_LINES; i++) // i = number of winning lines
	{
		printf("\tWinTab%d,\n", i);
	}
	printf("};\n\n");

	return 0;
}

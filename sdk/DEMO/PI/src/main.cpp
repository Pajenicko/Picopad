
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

// text screen
char TextBuf[TEXTSIZE];

const char OkTxt[]   = "Result OK: 3.";
const char ErrTxt[]  = "> ERROR <  3.";

#define NUMBEG	13	// offset to store digits

// ENIAC - 2037 digits in year 1949, compute time 70 hours
// Machin's formula: PI = 16*arctan(1/5) - 4*arctan(1/239)
// arctan x = x - x^3/3 + x^5/5 - x^7/7 + ...

// PI with 1000000 digits: https://www.piday.org/million/
// PI with 100000 digits: http://www.geom.uiuc.edu/~huberty/math5337/groupe/digits.html

// sample to check result (1246 digits)
const char Sample[] = // 78 digits per row, 16 rows
	"3.141592653589793238462643383279502884197169399375105820974944592307816406286"
	"208998628034825342117067982148086513282306647093844609550582231725359408128481"
	"117450284102701938521105559644622948954930381964428810975665933446128475648233"
	"786783165271201909145648566923460348610454326648213393607260249141273724587006"
	"606315588174881520920962829254091715364367892590360011330530548820466521384146"
	"951941511609433057270365759591953092186117381932611793105118548074462379962749"
	"567351885752724891227938183011949129833673362440656643086021394946395224737190"
	"702179860943702770539217176293176752384674818467669405132000568127145263560827"
	"785771342757789609173637178721468440901224953430146549585371050792279689258923"
	"542019956112129021960864034418159813629774771309960518707211349999998372978049"
	"951059731732816096318595024459455346908302642522308253344685035261931188171010"
	"003137838752886587533208381420617177669147303598253490428755468731159562863882"
	"353787593751957781857780532171226806613001927876611195909216420198938095257201"
	"065485863278865936153381827968230301952035301852968995773622599413891249721775"
	"283479131515574857242454150695950829533116861727855889075098381754637464939319"
	"255060400927701671139009848824012858361603563707660104710181942955596198946767";

#define MUL 100000000	// multiplier of a cell
#define MULDIG 8	// number of digits per cell

#define DIG (TEXTSIZE-20)	// total number of digits (= 1180)
#define LEN ((DIG+MULDIG-1)/MULDIG+1+1) // length in cells (8 digits per cell)

// First cell is integer part of the number. Every cell contains 8 digits with sign.
u32 T1[LEN];	// member arctan(1/5) ... 1/(5^i)
u32 T1B[LEN];	// member arctan(1/5) ... 1/(5^i)/i
u32 T2[LEN];	// member arctan(1/239) ... 1/(239^i)
u32 T2B[LEN];	// member arctan(1/239) ... 1/(239^i)/i
u32 Acu[LEN];	// accumulator of the result

// calculate PI
void Calc()
{
	s16 i, n;
	u32 aa, c, c2, k, sum1, sum2;
	s32 a;
	u64 a2;

	// initialize numbers
	for (i = 0; i < LEN; i++)
	{
		T1[i] = 0;
		T1B[i] = 0;
		T2[i] = 0;
		T2B[i] = 0;
		Acu[i] = 0;
	}

	// init member, to get results 16/5 and -4/239 after first division
	T1[0] = 16*5;
	T2[0] = 4*239;

	// iterations
	sum1 = 1;
	sum2 = 1;
	n = 1;
	Bool odd = True; // odd member
	do
	{
		// check underflow of the member
		if (sum1)
		{
			sum1 = 0; // underflow accumulator
			c = 0; // carry
			c2 = 0;
			for (i = 0; i < LEN; i++)
			{
				// divide arctan(1/5) by number 5*5
				aa = T1[i] + c*MUL; // multyply carry by cell multiplier
				k = aa/(5*5);
				T1[i] = k;

				// get carry (remainder after division)
				c = aa - k*(5*5);

				// divide arctan(1/5) by iteration number
				a2 = k + (u64)c2*MUL; // multiply carry by cell multiplier, add result
				k = (u32)(a2 / n);
				c2 = (u32)(a2 % n); // carry
				T1B[i] = k;

				// underflow accumulator
				sum1 |= k;
			}
		}

		// check underflow of the member
		if (sum2)
		{
			sum2 = 0; // underflow accumulator
			c = 0; // carry to lower byte
			c2 = 0;
			for (i = 0; i < LEN; i++)
			{
				// divide arctan(1/239) by number 239*239
				a2 = T2[i] + (u64)c*MUL;
				k = (u32)(a2/(239*239));
				c = (u32)(a2 % (239*239));
				T2[i] = k;

				// divide arctan(1/239) by iteration number
				a2 = k + (u64)c2*MUL;
				k = (u32)(a2/n);
				c2 = (u32)(a2 % n); // carry
				T2B[i] = k;

				// underflow accumulator
				sum2 |= k;
			}
		}

		// sum of the serie
		c = 0;
		for (i = LEN-1; i >= 0; i--)
		{
			if (odd)
				k = T1B[i] - T2B[i];
			else
				k = T2B[i] - T1B[i];

			a = (s32)(k + Acu[i] + c);

			if (a >= 0)
			{
				c = a/MUL;
				a = a - c*MUL;
			}
			else
			{
				c = -1;
				a += MUL;
			}
			Acu[i] = a;
		}

		n += 2;
		odd = !odd;

	// while members are not 0
	} while (sum1 | sum2);
}

char NumBuf[15];

int main()
{
	int i;

	// main loop
	while (True)
	{
		// calculate
		Calc();

		// display the number
		u32* s = &Acu[1];
		u32 n;
		Bool ok = True;
		char ch, ch2;
		int k = 2;
		int ii = LEN-2;
		if (ii > (TEXTSIZE-NUMBEG)/8) ii = (TEXTSIZE-NUMBEG)/8;
		char* b = &TextBuf[NUMBEG];
		for (i = 1; i <= ii; i++)
		{
			n = *s++;

			ch = n/10000000 + '0';
			*b++ = ch;
			if (Sample[k++] != ch) ok = False;

			ch = (n/1000000) % 10 + '0';
			*b++ = ch;
			if (Sample[k++] != ch) ok = False;

			ch = (n/100000) % 10 + '0';
			*b++ = ch;
			if (Sample[k++] != ch) ok = False;

			ch = (n/10000) % 10 + '0';
			*b++ = ch;
			if (Sample[k++] != ch) ok = False;

			ch = (n/1000) % 10 + '0';
			*b++ = ch;
			if (Sample[k++] != ch) ok = False;

			ch = (n/100) % 10 + '0';
			*b++ = ch;
			if (Sample[k++] != ch) ok = False;

			ch = (n/10) % 10 + '0';
			*b++ = ch;
			if (Sample[k++] != ch) ok = False;

			ch = n % 10 + '0';
			*b++ = ch;
			if (Sample[k++] != ch) ok = False;
		}

		// display result
		memcpy(TextBuf, ok ? OkTxt : ErrTxt, sizeof(OkTxt)-1);
		DrawTextBuf(TextBuf, COL_WHITE, COL_BLACK);
		DispUpdate();

		switch (KeyGet())
		{
		// reset to boot loader
		case KEY_Y: ResetToBootLoader();

#if USE_SCREENSHOT		// use screen shots
		case KEY_X:
			ScreenShot();
			break;
#endif
		}
	}
}


// ****************************************************************************
//
//                          64-bit Big fixed point number
//
// ****************************************************************************
// Big fixed point number is signed 64-bit number. Highest 7 bits are integer part,
// lower 57 bits are fractional part.

#ifndef _BIG_H
#define _BIG_H

// big integer type
typedef s64 big;

// convert double number to big fixed-point number
INLINE big DblToBig(double num)
{
	return (big)(num * (1LL << 57));
}

// add two big fixed point numbers
INLINE big BigAdd(big a, big b)
{
	return a + b;
}

// subtract two big fixed point numbers
INLINE big BigSub(big a, big b)
{
	return a - b;
}

// check if number is greater
INLINE Bool BigGr(big a, big b)
{
	return a > b;
}

// multiply big fixed point number by 2
INLINE big BigMul2(big a)
{
	return a << 1;
}

// multiply two unsigned big fixed point integers
big BigUMul(big a, big b);

// multiply two signed big fixed point integers
INLINE big BigMul(big a, big b)
{
	Bool neg = False;

	if (a < 0)
	{
		neg = True;
		a = -a;
	}

	if (b < 0)
	{
		neg = !neg;
		b = -b;
	}

	big res = BigUMul(a, b);
	if (neg) res = -res;
	return res;
}

// square power of unsigned big fixed point integer
INLINE big BigUSqr(big a) { return BigUMul(a, a); }

// square power of signed big fixed point integer
INLINE big BigSqr(big a)
{
	if (a < 0) a = -a;
	return BigUMul(a, a);
}

#endif // _BIG_H

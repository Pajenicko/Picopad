
// ****************************************************************************
//                                 
//                Real numbers (floating-point) - encode from text
//
// ****************************************************************************

#define GETCH() {				\
	ch = *txt;					\
	if (ch != 0) txt++;			\
	if ((ch & B7) != 0) {		\
		dp = True;				\
		ch &= ~B7; }			\
	}

// ---------------------------------------------------------------------------
//       Encode number from ASCIIZ text (decimal point: '.', ',' or B7)
// ---------------------------------------------------------------------------
// Global flags:
//  Base ... current numeric radix base BASE_*

void REALNAME(FromText)(REAL* num, char* txt)
{
	REAL mul, tmp;
	Bool dp, sign;
	char ch;
	BASES exp, exp2;
	int inx, inc;

	// clear number
	REALNAME(Set0)(num);

	// prepare decimal multiplier
	REALNAME(Set1)(&mul);

	// skip spaces and load 1st character
	dp = False;
	do {
		if (dp)
		{
			dp = False;
			ch = '.';
		}
		else
			GETCH();
	} while ((ch == ' ') || (ch == '+'));

	// load sign of the mantissa
	sign = False;
	if (ch == '-')
	{
		sign = True;
		if (dp)
		{
			dp = False;
			ch = '.';
		}
		else
			GETCH();
	}

	// add integer digits to the mantissa
	for (;;)
	{
		// decimal point
		if ((ch == '.') || (ch == ','))
		{
			GETCH();
			break;
		}

		// end of mantissa and multiply accumulator
		if (Base == BASE_DEC)
		{
			if ((ch < '0') || (ch > '9')) break;
			ch -= '0';
			REALNAME(MulUInt)(num, num, 10);
		}
		else if (Base == BASE_HEX)
		{
			if ((ch < '0') || 
				((ch > '9') && (ch < 'A')) ||
				((ch > 'F') && (ch < 'a')) ||
				(ch > 'f')) break;
			ch -= '0';
			if (ch > 9) ch -= 'A' - '9' - 1;
			if (ch > 15) ch -= 'a' - 'A';
			REALNAME(Pow2)(num, 4);
		}
		else if (Base == BASE_OCT)
		{
			if ((ch < '0') || (ch > '7')) break;
			ch -= '0';
			REALNAME(Pow2)(num, 3);
		}
		else // if (Base == BASE_BIN)
		{
			if ((ch < '0') || (ch > '1')) break;
			ch -= '0';
			REALNAME(Mul2)(num);
		}

		// add new digit to the accumulator
		REALNAME(SetU8)(&tmp, ch);
		REALNAME(Add)(num, num, &tmp);

		// load next character
		if (dp)
			ch = '.';
		else
			GETCH();
	}

	// add decimal digits to the mantissa
	for (;;)
	{
		// end of mantissa and shift multiplier
		if (Base == BASE_DEC)
		{
			if ((ch < '0') || (ch > '9')) break;
			ch -= '0';
			REALNAME(DivU16)(&mul, &mul, 10);
		}
		else if (Base == BASE_HEX)
		{
			if ((ch < '0') || 
				((ch > '9') && (ch < 'A')) ||
				((ch > 'F') && (ch < 'a')) ||
				(ch > 'f')) break;
			ch -= '0';
			if (ch > 9) ch -= 'A' - '9' - 1;
			if (ch > 15) ch -= 'a' - 'A';
			REALNAME(Pow2)(&mul, -4);
		}
		else if (Base == BASE_OCT)
		{
			if ((ch < '0') || (ch > '7')) break;
			ch -= '0';
			REALNAME(Pow2)(&mul, -3);
		}
		else // if (Base == BASE_BIN)
		{
			if ((ch < '0') || (ch > '1')) break;
			ch -= '0';
			REALNAME(Div2)(&mul);
		}

		// multiply digit by multiplier and add to the accumulator
		REALNAME(MulUInt)(&tmp, &mul, ch);
		REALNAME(Add)(num, num, &tmp);

		// load next character
		GETCH();
	}

	// set sign of the mantissa
	if (sign) REALNAME(Neg)(num);

	// sign of exponent
	sign = False;
	while ((ch == 'e') || (ch == 'E') || (ch == '+')) GETCH();
	if (ch == '-')
	{
		sign = True;
		GETCH();
	}
	
	// load digits of exponent
	exp = 0;
	for (;;)
	{
		if ((ch < '0') || (ch > '9')) break;
		ch -= '0';
		exp2 = exp*10;
		if (exp2 < exp) exp2 = EXP_MAX;
		exp = exp2 + ch;
		if (exp < exp2) exp = EXP_MAX;
		GETCH();
	}

	// multiply mantissa by exponent
	if (Base == BASE_DEC) // decimal base
	{
		inx = REAL_DECEXP; // index of '1' (middle of the table)
		inc = (sign) ? -1 : 1; // increment of the index
		while (exp != 0)
		{
			inx += inc; // shift index
			if ((exp & 1) != 0)
			{
				REALNAME(Mul)(num, num, &REALNAME(ConstExp)[inx]);
			}
			exp >>= 1;
		}
	}
	else
	{
		exp2 = exp;
		if (Base == BASE_HEX) // hexadecimal base
			exp *= 4;
		else if (Base == BASE_OCT) // octal base
			exp *= 3;
		if (exp < exp2) exp = EXP_MAX;

		// add exponent
		if (sign) exp = -exp;
		exp += REALNAME(GetExpS)(num);

		if (exp <= -(BASES)EXP_BIAS)
		{
			REALNAME(Set0)(num);
		}
		else if (exp >= (BASES)(EXP_MAX - EXP_BIAS))
		{
			REALNAME(SetInf)(num);
		}
		else
			REALNAME(SetExpS)(num, exp);
	}
}

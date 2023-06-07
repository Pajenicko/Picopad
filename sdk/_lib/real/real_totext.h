
// ****************************************************************************
//                                 
//                Real numbers (floating-point) - decode to text
//
// ****************************************************************************

// ---------------------------------------------------------------------------
// split number to mantissa and exponent, returns decimal exponent and mantissa (in range 1 .. 9.9999)
// ---------------------------------------------------------------------------
// Global flags:
//  Base ... current numeric radix base BASE_*

BASES REALNAME(SplitNum)(REAL* num)
{
	REAL m;
	BASES exps0, exps, exp2;
	int inx, inc;

// === Prepare exponent

	// load exponent
	exps0 = REALNAME(GetExpS)(num);
	REALNAME(SetSInt)(&m, exps0);
	
	// correction: negative exponent - 1, positive exponent + 2
	if (exps0 < 0)
		REALNAME(Dec)(&m);		 // m = exp2 - 1
	else
		REALNAME(Add)(&m, &m, &REALNAME(Const2));	// m = exp2 + 2

	// convert binary exponent to decimal (divide by log2 of radix base = multiply by log_base(2))
	if (Base == BASE_DEC) // decimal base
		REALNAME(Mul)(&m, &m, &REALNAME(ConstLog2)); // multiply by log10(2)
	else if (Base == BASE_HEX) // hexadecimal base
		REALNAME(Pow2)(&m, -2);	// divide by 4 (=divide by log2(16) = 4)
	else if (Base == BASE_OCT) // octal radix base
		REALNAME(Div)(&m, &m, &REALNAME(Const3)); // divide by 3 (=divide by log2(8) = 3)

	// load new (decimal) exponent
	exps = REALNAME(GetSInt)(&m);

// === Normalize mantissa: divide mantissa by exponent base

	// HEX radix: divide mantissa by exponent * 4 (base log2(16) = 4)
	if (Base == BASE_HEX)
	{
		// subtract exponent * 4
		REALNAME(SetExpS)(num, exps0 - exps*4);

		// mantissa must be >= 1
		while (REALNAME(GetExp)(num) < EXP_1)
		{
			REALNAME(Pow2)(num, 4); // multiply * 16
			exps--;
		}

		// mantissa must be < 16
		while (REALNAME(GetExp)(num) >= EXP_1 + 4)
		{
			REALNAME(Pow2)(num, -4); // divide / 16
			exps++;
		}
		return exps;
	}

	// OCT radix: divide mantissa by exponent * 3 (base log2(8) = 3)
	if (Base == BASE_OCT)
	{
		// subtract exponent * 3
		REALNAME(SetExpS)(num, exps0 - exps*3);

		// mantissa must be >= 1
		while (REALNAME(GetExp)(num) < EXP_1)
		{
			REALNAME(Pow2)(num, 3); // multiply * 8
			exps--;
		}

		// mantissa must be < 8
		while (REALNAME(GetExp)(num) >= EXP_1 + 3)
		{
			REALNAME(Pow2)(num, -3); // divide / 8
			exps++;
		}
		return exps;
	}

	// BIN radix: divide mantissa by exponent (base log2(2) = 1)
	if (Base == BASE_BIN)
	{
		// subtract exponent
		REALNAME(SetExpS)(num, exps0 - exps);

		// mantissa must be >= 1
		while (REALNAME(GetExp)(num) < EXP_1)
		{
			REALNAME(Mul2)(num); // multiply * 2
			exps--;
		}

		// mantissa must be < 2
		while (REALNAME(GetExp)(num) >= EXP_1 + 1)
		{
			REALNAME(Div2)(num); // divide / 2
			exps++;
		}
		return exps;
	}

	// DEC radix: divide mantissa by decimal exponent
	inx = REAL_DECEXP; // index of '1' (middle of the table)
	inc = (exps < 0) ? 1 : -1; // increment of the index
	exp2 = (exps < 0) ? -exps : exps; // absolute value of exponent

	// divide mantissa
	while (exp2 != 0)
	{
		inx += inc; // shift index
		if ((exp2 & 1) != 0) REALNAME(Mul)(num, num, &REALNAME(ConstExp)[inx]);
		exp2 >>= 1;
	}

	// mantissa is now in range 0.25..5 (or 0), correction to get into range 1..9.9999
	if (REALNAME(GetExp)(num) < EXP_1)
	{
		REALNAME(MulUInt)(num, num, 10); // multiply * 10
		exps--;
	}

	return exps;
}

// ---------------------------------------------------------------------------
//                     Decode number to text buffer
// ---------------------------------------------------------------------------
//  buf ... pointer to destination buffer (NULL=only count number of characters)
//  size ... max. length of destination buffer, without terminating 0 (reserve 1 more byte in the buffer)
// Output:
//  Returns length of text, without terminating 0 (but it writes terminating 0)
//  Returns length of exponent in ExpLen.
// 	Returns length of mantissa in EditLen.
//  Returns decimal point flag in PointOn.
// Global flags:
//  Base ... current numeric radix base BASE_*
//  ExpMode ... current exponent mode EXP_>
//  Fix ... current fixed decimal places (0..digits, or FIX_OFF=off)
//  CharPlus ... character of positive number ('+', ' ' or 0=do not use)
//  CharExp ... character of exponent ('e', 'E' or 0=do not use)
//  ExpPlus ... character of positive exponent ('+', ' ' or 0=do not use)
//  CharDec ... character used as decimal separator (',', '.' or B7=add flag to previous digit)
//  RightAlign ... right align text in buffer
//  MaxDig ... max. number of valid digits (0 = default, negative = cut digits from end)

int REALNAME(ToText)(const REAL* num, char* buf, int size)
{
	REAL m, tmp, tmp2;
	Bool over, neg, restart, enddp;
	BASES exp, exp2, exp3;
	int intnum, totnum, totnum2, totnum3, expnum, zeronum, decnum, n, i, size2, mantlen, endzero;
	char *dstmant, *dstexp, ch;

	// copy number into temporary buffer
	REALNAME(Copy)(&m, num);

	// prepare overflow flag
	over = REALNAME(IsInf)(&m);

	// save sign flag, do absolute value of the number
	neg = REALNAME(IsNeg)(&m);
	REALNAME(Abs)(&m);

	// on overflow, substitute by max. number
	if (over) REALNAME(SetMax)(&m);

	// split number to mantissa and exponent, returns decimal exponent and mantissa
	exp = 0;
	if (!REALNAME(IsZero)(&m)) exp = REALNAME(SplitNum)(&m);

// --- here we have positive mantissa (m) in range 1..9.9999 (or 0) and signed exponent (exp)

	// prepare engineering mode (cannot repeat during restart)
	intnum = 1; // number of digits of integer part (may be > totnum)
	if (ExpMode == EXP_ENG) // engineer mode?
	{
		REALNAME(SetSInt)(&tmp, exp);	// load exponent into tmp
		if ((Base == BASE_DEC) || (Base == BASE_OCT)) // dec and oct radix have modulus of exponent = 3
			REALNAME(SetUInt)(&tmp2, 3); // load grouping = 3
		else  // hex and bin radix have modulus of exponent = 4
			REALNAME(SetUInt)(&tmp2, 4); // load grouping = 4
		REALNAME(ModFloor)(&tmp, &tmp, &tmp2); // operation modulo, rounding floor
		intnum = (int)REALNAME(GetUInt)(&tmp); // load integer digits-1
		exp -= intnum; // shift exponent to be multiply of 3
		intnum++; // number of digits of integer part
	}

// --- Prepare number of digits, decode exponent ----
// size ... size of buffer
// intnum ... number of digits of integer part (may be > totnum)
// totnum ... total number of valid digits of mantissa, will be used to decode digits (remaining digits will be '0')
// totnum2 ... number of free digits in buffer = buffer size without sign and decimal point
// totnum3 ... save totnum2 for later
// expnum ... number of exponent digits (including sign)
// zeronum ... number of additional zeroes between decimal point and valid digits
// decnum ... number of decimal digits, valid digits after decimal point and zeroes

	// clear restart flag (restart conversion if rounding increases exponent and increases mantissa 9.9999 -> 10.0000)
	restart = False;

	// here we go in case of restart, if mantissa becomes >= 10 during rounding
Restart:

	// prepare flags
	totnum = size; // total number of valid digits of mantissa ... will be used to decode digits
	if ((CharPlus != 0) || neg) totnum--; // reserve 1 position for sign
	if (CharDec != B7) totnum--; // reserve 1 position for decimal point
	if (totnum < 0) totnum = 0; // buffer is too small?
	totnum2 = totnum; // buffer size without sign and decimal point ... will be used as number of free digits in buffer
	totnum3 = totnum; // ... save free space in buffer without exponent
	if (MaxDig > 0)
	{
		if (totnum > MaxDig) totnum = MaxDig; // limit to valid number of digits
	}
	else
	{
		// limit to max. precision of mantissa
		switch (Base)
		{
		case BASE_BIN:
			if (totnum > MANT_DIG_BIN + MaxDig) totnum = MANT_DIG_BIN + MaxDig;
			break;

		case BASE_OCT:
			if (totnum > MANT_DIG_OCT + MaxDig) totnum = MANT_DIG_OCT + MaxDig;
			break;

		case BASE_HEX:
			if (totnum > MANT_DIG_HEX + MaxDig) totnum = MANT_DIG_HEX + MaxDig;
			break;

		default: // case BASE_DEC:
			if (totnum > MANT_DIG_DEC + MaxDig) totnum = MANT_DIG_DEC + MaxDig;
			break;
		}
	}
	if (totnum < 1) totnum = 1;
	expnum = 0; // number of exponent characters (including sign)
	zeronum = 0; // number of additional zeroes on start of number (between decimal point and valid digits)

	// prepare destination pointer to end of buffer
	dstmant = buf;
	dstexp = buf;
	if (dstexp != NULL)
	{
		dstexp += size; // shift to end of buffer
		*dstexp = 0;
	}

	// check if use exponent mode
	exp2 = (exp < 0) ? -exp : exp; // prepare absolute value of exponent
	exp3;
	if ((ExpMode == EXP_EE) || (ExpMode == EXP_ENG) || // user requires exponent mode explicitly
		(exp >= totnum2) ||			// number is too big to fit to display (we may add some zeroes after valid digits)
		((ExpMode == EXP_AUTO) && (exp >= totnum)) || // at auto mode, no ending zeroes to integer part
		((exp < -3) && (ExpMode == EXP_AUTO))) // number is too low and auto mode is on
	{
		// decode exponent to end of buffer (totnum2 contains number of free digits in buffer, size contains free space in buffer)
		do {
			// no space left
			if (totnum2 <= 0) break; // counter of free digits in buffer

			// decode next digit
			exp3 = exp2 / 10;
			if (dstexp != NULL)
			{
				dstexp--; // shift pointer
				if (over)
					*dstexp = '9';		// on overflow substitute by digit '9'
				else
					*dstexp = (char)(exp2 - exp3*10 + '0'); // save digit
			}
			exp2 = exp3; // new exponent
			expnum++; // increase length of exponent
			totnum2--; // decrease number of free digits
		} while (exp2 != 0);

		// store sign of exponent
		if ((totnum2 > 0) && ((exp < 0) || (ExpPlus != 0)))
		{
			if (dstexp != NULL)
			{
				dstexp--; // shift pointer
				if (exp < 0)
					*dstexp = '-';
				else
					*dstexp = ExpPlus;
			}
			expnum++; // increase length of exponent
			totnum2--; // decrease number of free digits
		}

		// store exponent separator
		// - at HEX mode, do not store 'e' nor 'E' characters
		if ((totnum2 > 0) && (CharExp != 0) &&
			((Base != BASE_HEX) || ((CharExp != 'e') && (CharExp != 'E'))))
		{
			if (dstexp != NULL)
			{
				dstexp--; // shift pointer
				*dstexp = CharExp;
			}
			expnum++; // increase length of exponent
			totnum2--; // decrease number of free digits
		}

		// limit number of mantissa digits by number of free digits
		if (totnum > totnum2) totnum = totnum2;

		// number of decimal digits
		decnum = totnum - intnum;
		if (Fix != FIX_OFF)
		{
			// limit decimal digits
			if (Fix < decnum) decnum = Fix;
		}
		if (decnum < 0) decnum = 0; // in case totnum < intnum (we will add zeroes in front of decimal point)
	}

// --- prepare normal mode

	else
	{
		// integer digits = exponent + 1
		intnum = (int)(exp + 1);
		if ((s32)exp < (s32)-totnum2) intnum = -totnum2; // exponent is too low (limit by free digits)

		// no integer digits, prepare zero digits
		if (intnum <= 0)
		{
			zeronum = -intnum; // number of zero digits
			intnum = 0; // no integer digits (will be expanded to '0.')
			if (zeronum > totnum2-1) zeronum = totnum2-1; // limit number of zeroes
		}

		// decimal digits
		if (intnum > 0) // 1.2345
			decnum = totnum - intnum; // number of decimal digits, limited by total number of digits
		else
		{
			// 0.01234
			decnum = totnum2 - intnum - zeronum; // number of decimal digits, limited by free digits
			if (decnum > totnum) decnum = totnum; // limit decimal digits by total digits
		}

		if (decnum < 0) // invalid number of decimal digits, limit it
		{
			zeronum += decnum; // limit number of zero digits
			decnum = 0; // no decimal digits
		}

		// limit by Fix
		if (Fix != FIX_OFF)
		{
			if (Fix < zeronum) zeronum = Fix; // limit number of zero digits
			if (Fix < zeronum + decnum) decnum = Fix - zeronum; // limit number of decimal digits
		}
	}

	// save number of digits of exponent
	ExpLen = expnum;

	// limit digits by buffer size
	n = totnum3 - expnum; // buffer size without sign, decimal point and exponent
	if (n < intnum) intnum = n; // limit integers
	n -= intnum;
	if (n < zeronum) zeronum = n; // limit zero digits
	n -= zeronum;
	if (n < decnum) decnum = n; // limit decimal digits

// --- Rounding

	// total number of digits of mantissa to decode (may be > totnum number of valid digits)
	totnum2 = intnum + decnum;
	if (totnum2 < totnum) totnum = totnum2; // limit number of valid digits (it was limited by buffer size)

	// rounding - only if some valid digits remains, and if not restarting, and if not zero
	if ((totnum > 0) && !restart && !REALNAME(IsZero)(&m))
	{
		// decimal base
		if (Base == BASE_DEC)
		{
			// add rounding correction to the mantissa
			REALNAME(Copy)(&tmp, &REALNAME(Const05)); // constant 0.5
			i = totnum - 1; // required exponent
			n = REAL_DECEXP - 1; // exponent of 1
			while (i != 0)
			{
				if ((i & 1) != 0) // exponent should be set
				{
					REALNAME(Mul)(&tmp, &tmp, &REALNAME(ConstExp)[n]); // multiply 0.5 by decimals
				}
				n--; // shift exponent index
				i >>= 1;
			}
			REALNAME(Add)(&m, &m, &tmp); // add rounding correction

			// raise mantissa 9.9999 -> 10.0000, normalize and restart
			if (REALNAME(Comp)(&m, &REALNAME(Const10)) >= 0)
			{
				REALNAME(DivU16)(&m, &m, 10);
				exp++; // increment exponent
				restart = True; // set restart flag

				if (ExpMode == EXP_ENG) // engineering mode correction
				{
					intnum++; // increase number of integer digits
					exp--;	// decrease exponent

					if (intnum > 3) // correct modulo 3
					{
						intnum -= 3;
						exp += 3;
					}
				}
				goto Restart; // go to restart
			}
		}

		// HEX base
		else if (Base == BASE_HEX)
		{
			// add rounding correction to the mantissa
			REALNAME(Set1)(&tmp);
			REALNAME(SetExp)(&tmp, EXP_1 - 1 + 4 - totnum*4);
			REALNAME(Add)(&m, &m, &tmp);

			// raise mantissa F.FFFF -> 10.0000, normalize and restart
			if (REALNAME(GetExp)(&m) >= EXP_1 + 4)
			{
				REALNAME(Pow2)(&m, -4); // divide mantissa by 16
				exp++; // increment exponent
				restart = True; // set restart flag

				if (ExpMode == EXP_ENG) // engineering mode correction
				{
					intnum++; // increase number of integer digits
					exp--;	// decrease exponent

					if (intnum > 4) // correct modulo 4
					{
						intnum -= 4;
						exp += 4;
					}
				}
				goto Restart; // goto restart
			}
		}

		// OCT base
		else if (Base == BASE_OCT)
		{
			// add rounding correction to the mantissa
			REALNAME(Set1)(&tmp);
			REALNAME(SetExp)(&tmp, EXP_1 - 1 + 3 - totnum*3);
			REALNAME(Add)(&m, &m, &tmp);

			// raise mantissa 7.7777 -> 10.0000, normalize and restart
			if (REALNAME(GetExp)(&m) >= EXP_1 + 3)
			{
				REALNAME(Pow2)(&m, -3); // divide mantissa by 8
				exp++; // increment exponent
				restart = True; // set restart flag

				if (ExpMode == EXP_ENG) // engineering mode correction
				{
					intnum++; // increase number of integer digits
					exp--;	// decrease exponent

					if (intnum > 3) // correct modulo 4
					{
						intnum -= 3;
						exp += 3;
					}
				}
				goto Restart; // goto restart
			}
		}

		// BIN base
		else // if (Base == BASE_BIN)
		{
			// add rounding correction to the mantissa
			REALNAME(Set1)(&tmp);
			REALNAME(SetExp)(&tmp, EXP_1 - 1 + 1 - totnum);
			REALNAME(Add)(&m, &m, &tmp);

			// raise mantissa 1.1111 -> 10.0000, normalize and restart
			if (REALNAME(GetExp)(&m) >= EXP_1 + 1)
			{
				REALNAME(Div2)(&m); // divide mantissa by 2
				exp++; // increment exponent
				restart = True; // set restart flag

				if (ExpMode == EXP_ENG) // engineering mode correction
				{
					intnum++; // increase number of integer digits
					exp--;	// decrease exponent

					if (intnum > 4) // correct modulo 4
					{
						intnum -= 4;
						exp += 4;
					}
				}
				goto Restart; // goto restart
			}
		}
	}

// --- decode mantissa digits
// size ... size of buffer
// size2 ... remaining space in buffer
// intnum ... number of digits of integer part (may be > totnum)
// totnum ... total number of valid digits of mantissa, will be used to decode digits (remaining digits will be '0')
// totnum2 ... number of digits to decode (without zero digits)
// expnum ... number of exponent digits (including sign)
// zeronum ... number of additional zeroes between decimal point and valid digits
// decnum ... number of decimal digits, valid digits after decimal point and zeroes
// mantlen ... length of mantissa with sign and decimal point
// endzero ... end zero digits
// enddp ... ending with decimal point

	// decode sign
	size2 = size - expnum; // remaining space in buffer
	mantlen = 0; // length of mantissas
	endzero = 0; // end zero digits
	enddp = False; // not ending with decimal point

	if (neg)
		ch = '-';
	else
		ch = CharPlus;

	if ((ch != 0) && (size2 > 0))
	{
		mantlen++;
		size2--;
		if (dstmant != NULL) *dstmant++ = ch;
	}

	// start '0.' if integer digits = 0
	PointOn = True; // decimal point was entered
	if ((intnum == 0) && (size2 > 0))
	{
		mantlen++;
		size2--;
		if (dstmant != NULL) *dstmant++ = '0'; // start decimal point

		if (CharDec == B7)
		{
			if (dstmant != NULL) dstmant[-1] |= B7; // start decimal point
		}
		else
		{
			mantlen++;
			size2--;
			if (dstmant != NULL) *dstmant++ = CharDec; // start decimal point
		}
		enddp = True; // ending with decimal point
	}

	// store initial zeroes
	for (; zeronum > 0; zeronum--)
	{
		if (size2 > 0)
		{
			mantlen++;
			size2--;
			if (dstmant != NULL) *dstmant++ = '0';
			endzero++; // end zero digits
		}
	}

	// decode digits of mantissa
	for (; totnum2 > 0; totnum2--)
	{
		// get integer part of the number
		n = REALNAME(GetU8)(&m);
		REALNAME(SetU8)(&tmp, (u8)n);

		// not valid digit
		if (totnum <= 0)
			n = 0;
		else
			totnum--;

		// HEX character
		if (n > 9) n += 'A' - '9' - 1;

		// store digit
		if (over) // overflow
			ch = '9';
		else
			ch = (char)(n + '0');

		if (size2 > 0)
		{
			mantlen++;
			size2--;
			if (dstmant != NULL) *dstmant++ = ch;

			if (ch == '0')
				endzero++; // end zero digits
			else
			{
				endzero = 0;
				enddp = False; // not ending with decimal point
			}
		}

		// subtract integer part from mantissa
		REALNAME(Sub)(&m, &m, &tmp);

		// multiply mantissa by radix base
		if (Base == BASE_DEC) // DEC base
			REALNAME(MulUInt)(&m, &m, 10); // multiply * 10
		else if (Base == BASE_HEX) // HEX base
			REALNAME(Pow2)(&m, 4); // multiply * 16
		else if (Base == BASE_OCT) // OCT base
			REALNAME(Pow2)(&m, 3); // multiply * 8
		else // if (Base == BASE_BIN) // BIN base
			REALNAME(Mul2)(&m); // multiply * 2

		// store decimal point
		intnum--;
		if ((intnum == 0) && (size2 > 0))
		{
			if (CharDec == B7)
			{
				if (dstmant != NULL) dstmant[-1] |= B7; // start decimal point
			}
			else
			{
				mantlen++;
				size2--;
				if (dstmant != NULL) *dstmant++ = CharDec;
			}
			enddp = True; // ending with decimal point
			endzero = 0;
		}
	}

// --- delete ending zeroes

	// delete ending zeroes (only if not fixed mode)
	if (Fix == FIX_OFF)
	{
		if (dstmant != NULL) dstmant -= endzero;
		mantlen -= endzero;
		size2 += endzero;

		// delete single decimal point
		if (enddp)
		{
			if (CharDec == B7)
			{
				if (dstmant != NULL) dstmant[-1] &= ~B7; // start decimal point
			}
			else
			{
				if (dstmant != NULL) dstmant--;
				mantlen--;
				size2++;
			}
			PointOn = False; // clear flag of decimal point
		}
	}
	EditLen = mantlen; // save length of mantissa

// --- shift mantissa right or exponent left

	if (buf != NULL)
	{
		// align left - shift mantissa left (dstmant <- dstexp)
		if (!RightAlign)
		{
			for (; expnum > 0; expnum--) *dstmant++ = *dstexp++;
			*dstmant = 0;
		}

		// align right - shift mantissa right (dstmant -> dstexp)
		else
		{
			for (; mantlen > 0; mantlen--)
			{
				dstmant--;
				dstexp--;
				*dstexp = *dstmant;
			}

			// clear rest of buffer
			while (dstexp != buf)
			{
				dstexp--;
				*dstexp = ' ';
			}
		}
	}

	return EditLen + ExpLen;
}


// ****************************************************************************
//
//                               Formated print
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_PRINT		// use Formated print (lib_print.c, lib_print.h)

#include "../inc/lib_print.h"
#include "../inc/lib_text.h"

// round coefficients ... already defined in textnum.c
//const double SetDoubleCoeff[19] = { 5e0, 5e-1, 5e-2, 5e-3, 5e-4, 5e-5, 5e-6, 5e-7,
//	5e-8, 5e-9, 5e-10, 5e-11, 5e-12, 5e-13, 5e-14, 5e-15, 5e-16 };

// check special double numbers ... already defined in text.h
//#define CheckInfD(num) ( ((u16*)&(num))[3] == 0x7ff0) // 1#INF
//#define CheckSInfD(num) ( ((u16*)&(num))[3] == 0xfff0) // -1#INF
//#define CheckNanD(num) ( ((u16*)&(num))[3] == 0x7ff8) // 1#NAN
//#define CheckSNanD(num) ( ((u16*)&(num))[3] == 0xfff8) // -1#NAN

// read character from input stream
#define IN() { ch = 0; rstr->read(rstr, &ch, 1); }

// write character to output stream
#define OUT(c) { cc = (char)(c); wstr->write(wstr, &cc, 1); len++; }

// extract signed int argument
#define SARG()	( (flags & PRF_LONGLONG) ? va_arg(args, s64) : va_arg(args, s32) )

// extract unsigned int argument
#define UARG()	( (flags & PRF_LONGLONG) ? va_arg(args, u64) : va_arg(args, u32) )

// Print flags:
#define PRF_ALT			0x0001		// '#' alternate form
#define PRF_UPPER		0x0002		// 'EFGPX' use upper-case letters
#define PRF_LADJUST		0x0004		// '-' left adjustment
#define PRF_LONGLONG		0x0008		// 'll' long long int (s64)
#define PRF_ZEROPAD		0x0010		// '0' zero pad (as opposed to blank pad)
#define PRF_FLOAT		0x0020		// float, double
#define PRF_GROUP		0x0040		// ' use grouping

// Print numeric base (radix):
enum {
	PRINTBASE_BIN,			// 2
	PRINTBASE_OCT,			// 8
	PRINTBASE_DEC,			// 10
	PRINTBASE_HEX,			// 16
};

#define PR_BUFSIZE		82			// temporary buffer size (bin format: sign + 64 digits + 15 group separators + 0)

// HEX digits
const char HexDigU[] = "0123456789ABCDEF";
const char HexDigL[] = "0123456789abcdef";

// Metric unit prefix (range 10^-30 .. 10^+30)
#define UNITPREFIX_ONE	10	// index of 'one' prefix
#define UNITPREFIX_NUM	21	// number of unit prefixes
const char UnitPrefix[UNITPREFIX_NUM] = {
	'q',	// 0: quecto, 10^-30
	'r',	// 1: ronto, 10^-27
	'y',	// 2: yocto, 10^-24
	'z',	// 3: zepto, 10^-21
	'a',	// 4: atto, 10^-18
	'f',	// 5: femto, 10^-15
	'p',	// 6: pico, 10^-12
	'n',	// 7: nano, 10^-9
	'u',	// 8: micro, 10^-6
	'm',	// 9: milli, 10^-3
	0,	// 10: one, 10^0
	'k',	// 11: kilo, 10^+3
	'M',	// 12: mega, 10^+6
	'G',	// 13: giga, 10^+9
	'T',	// 14: tera, 10^+12
	'P',	// 15: peta, 10^+15
	'E',	// 16: exa, 10^+18
	'Z',	// 17: zetta, 10^+21
	'Y',	// 18: yotta, 10^+24
	'R',	// 19: ronna, 10^+27
	'Q',	// 20: quetta, 10^+30
};

// stream printing (returns number of characters, without terminating 0)
//  wstr ... write stream (destination buffer)
//  rstr ... read stream (formating string)
//  args ... arguments
u32 StreamPrintArg(sStream* wstr, sStream* rstr, va_list args)
{
	int n;			// temporary number, loading numeric argument
	Bool stop;		// stop parsing
	u32 len = 0;		// length of output stream
	char* d;		// destinations
	Bool zero;		// flag - number is zero
	char b;			// decoded character

	// characters
	char ch;		// input character
	char cc;		// temporary output character
	char retch;		// returned input character (0=none)

	// temporary buffer
	int size;		// size of number in temporary buffer
	char buf[PR_BUFSIZE];	// temporary print buffer with converted field
	int realsize;		// real size of printed field (including sign)
	char* chp;		// character pointer to converted field

	// format
	int flags;		// flags PRF_* (or 0 default)
	int width;		// width from format (or 0 default)
	int prec;		// precision from format (or -1 default)
	char sign;		// sign prefix (' ', '+', '-', 0)
	int dprec;		// decimal precision (required precision .prec from format string and decimal number, 0 default)

	// decode integer number
	s64 ns64;		// loaded s64 argument
	u64 nu64, nu64b;	// loaded u64 argument
	int base;		// current numeric base
	int ndig;		// number of digits in one group

	// decode floating point number
	double dbl;		// loaded floating argument
	int expI;		// exponent
	double mantD;		// mantissa
	double dbl2;		// argument loaded as double

	Bool noround;		// flag - do not round floating point
	Bool useexp;		// flag - use exponent mode
	int digits;		// total number of digits, without starting zeroes
	int intdig;		// number of integer digits, including first starting zero
	int zeros;		// number of starting zeroes (including integer part)
	int zeros2;		// number of trailing zeroes
	int alldig;		// number of all digits
	Bool b1kb;		// byte capacity is in range 1000..1023 (need to display 4 digits)

	// open streams
	if (rstr->open != NULL) rstr->open(rstr);
	if (wstr->open != NULL) wstr->open(wstr);

	// main loop
	for (;;)
	{
		// transfer normal characters (up tu '%' character or end of text)
		for (;;)
		{
			// get next character 'ch'
			IN();

			// end of text or '%' parameter
			if ((ch == 0) || (ch == '%')) break;

			// write normal character
			OUT(ch);
		};

		// end of text
		if (ch == 0) break;

		// here is '%', continue to load parameter
		flags = 0;		// flags PRF_* (or 0 default)
		width = 0;		// width from format (or 0 default)
		prec = -1;		// precision from format (or -1 default)
		sign = 0;		// sign prefix (' ', '+', '-', 0)
		dprec = 0;		// decimal precision (required precision .prec from format string and decimal number, 0 default)
		retch = 0;		// returned input character (0=none)
		stop = False;		// stop parsing one parameter

		// parse one parameter
		while (!stop)
		{
			// get next character 'ch'
			ch = retch;
			retch = 0;
			if (ch == 0) IN();

			switch (ch)
			{
			// stop parsing
			case 0:
				stop = True;
				break;

			// ' : grouping separator
			case '\'':
				flags |= PRF_GROUP;
				break;

			// space: if the result of a signed conversion does not start with a sign character,
			//	or is empty, space is prepended to the result. It is ignored if '+' flag is present.
			case ' ':
				// if the space and '+' flags both appear, the space flag will be ignored -- ANSI X3J11
				if (!sign) sign = ' ';
				break;

			// '#': alternative form of the conversion
			case '#':
				flags |= PRF_ALT;
				break;

			// '*': width is specified by an additional argument of type 'int',
			//	which appears before the argument to be converted.
			//	A negative field width argument is taken as a
			//	'-' flag followed by a positive field width.
			case '*':
				width = va_arg(args, int); // load custom width argument
				if (width >= 0) break; // width is not negative
				width = -width; // width is negative
			// continue to '-' flag

			// '-': left-justified
			case '-':
				flags |= PRF_LADJUST;
				break;

			// '+': the sign of signed conversions is always prepended
			case '+':
				sign = '+';
				break;

			// '.': followed by integer number or '*', or neither that specifies precision of the conversion. 
			//	In the case when '.*' is used, the precision is specified by an additional argument
			//	of type 'int', which appears before the argument to be converted, but after
			//	the argument supplying minimum field width if one is supplied with '*'.
			case '.':
				IN();	// get next character
				if (ch == '*')
					// load precision from argumnents
					n = va_arg(args, int); // load custom precision argument
				else
				{
					// load precision from flags
					n = 0; // accumulator
					while ((ch >= '0') && (ch <= '9')) // while next character is valid digit
					{
						n = n*10 + (ch - '0'); // add digit to accumulator
						IN(); // get next character
					}
					retch = ch; // return last character
				}
				prec = (n < 0) ? -n : n; // absolute value of precision
				break;

			// '0': leading zeros are used to pad the field instead of space characters.
			//	For integer numbers it is ignored if the precision is explicitly specified. 
			//	It is ignored if '-' flag is present.
			//	Note that 0 is taken as a flag, not as the beginning of a field width. -- ANSI X3J11
			case '0':
				flags |= PRF_ZEROPAD;
				break;

			// digit: minimum field width. The result is padded with spaces (left or right).
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
			case '8':
			case '9':
				// load width
				n = 0; // accumulator
				do {
					n = n*10 + (ch - '0'); // add digit to accumulator
					IN(); // get next character
				} while ((ch >= '0') && (ch <= '9')); // while next character is valid digit
				retch = ch; // return last character
				width = n; // set width
				break;

			// 'l': 'long long int' length modifier
			case 'l':
				IN();	// load next character
				if (ch == 'l') // 'll' flags
					flags |= PRF_LONGLONG;
				else
					retch = ch; // return next character
				break;

			// 'c': write single character
			case 'c':
				buf[0] = (char)SARG(); // load character to print
				chp = buf;		// pointer to the buffer
				size = 1;		// size = 1 character
				sign = 0;		// no sign
				stop = True;		// stop parsing
				break;

			// 'd', 'i': write signed int
			case 'd':
			case 'i':
				ns64 = SARG(); // load argument
				if (ns64 < 0) // negative argument?
				{
					nu64 = -ns64; // absolute value of argument
					sign = '-'; // print negative sign
				}
				else
					nu64 = ns64; // use positive number
				base = PRINTBASE_DEC; // decimal base
				goto sign_num;

#if USE_DOUBLE	// use double support

			// float, double
			case 'B': // byte capacity
			case 'E': // exponent with E
			case 'F': // floating point NAN
			case 'G': // mixed
			case 'T': // technical
			case 'e': // exponent with e
			case 'f': // floating point nan
			case 'g': // mixed
			case 't': // technical
				flags |= PRF_FLOAT; // float number

				// load argument
				dbl2 = va_arg(args, double);
				dbl = (double)dbl2;

				// prepare sign
				if (dbl < 0)
				{
					sign = '-';
					dbl = -dbl;
				}

				// infinity INF
				if (CheckInf(dbl) || CheckSInf(dbl))
				{
					if (ch <= 'Z') // 'A', 'E', 'F', 'G'
						chp = "INF"; // upper case
					else
						chp = "inf"; // lower case
					size = 3; // length = 3 characters
					flags &= ~PRF_ZEROPAD; // do not add zeroes
					stop = True; // stop parsing
					break;
				}

				// invalid NAN
				if (CheckNan(dbl) || CheckSNan(dbl))
				{
					if (ch <= 'Z') // 'A', 'E', 'F', 'G'
						chp = "NAN"; // upper case
					else
						chp = "nan"; // lower case
					size = 3; // length = 3 characters
					flags &= ~PRF_ZEROPAD; // do not add zeroes
					stop = True; // stop parsing
					break;
				}

				// default precision
				if (prec < 0) prec = 6; // default precision
				
				// formats 'BGgTt' cannot have zero significant digits
				if (((ch == 'B') || (ch == 'g') || (ch == 'G') || (ch == 't') ||
					(ch == 'T')) && (prec == 0)) prec = 1; // minimal precision = 1

				// binary correction of byte capacity
				expI = 0; // exponent
				mantD = dbl; // mantissa
				b1kb = False; // byte capacity is in range 1000..1023 (need to display 4 digits)
				if (ch == 'B')
				{
					while (mantD >= 1024)
					{
						mantD /= 1024;
						expI += 3;
					}

					b1kb = (mantD >= 1000); // range 1000..1023
				}

				// split number to exponent and mantissa
				if (mantD >= 1)
				{
					if (mantD >= 1e256) { mantD *= 1e-256; expI += 256; };
					if (mantD >= 1e128) { mantD *= 1e-128; expI += 128; };
					if (mantD >= 1e64)  { mantD *= 1e-64;  expI += 64;  };
					if (mantD >= 1e32)  { mantD *= 1e-32;  expI += 32;  };
					if (mantD >= 1e16)  { mantD *= 1e-16;  expI += 16;  };
					if (mantD >= 1e8)   { mantD *= 1e-8;   expI += 8;   };
					if (mantD >= 1e4)   { mantD *= 1e-4;   expI += 4;   };
					if (mantD >= 1e2)   { mantD *= 1e-2;   expI += 2;   };
					if (mantD >= 1e1)   { mantD *= 1e-1;   expI += 1;   };
				}
				else
				{
					if (mantD < 1e-256) { mantD *= 1e257;  expI -= 257; };
					if (mantD < 1e-128) { mantD *= 1e129;  expI -= 129; };
					if (mantD < 1e-64)  { mantD *= 1e65;   expI -= 65;  };
					if (mantD < 1e-32)  { mantD *= 1e33;   expI -= 33;  };
					if (mantD < 1e-16)  { mantD *= 1e17;   expI -= 17;  };
					if (mantD < 1e-8)   { mantD *= 1e9;    expI -= 9;   };
					if (mantD < 1e-4)   { mantD *= 1e5;    expI -= 5;   };
					if (mantD < 1e-2)   { mantD *= 1e3;    expI -= 3;   };
					if (mantD < 1e-1)   { mantD *= 1e2;    expI -= 2;   };
					if (mantD < 1e0)    { mantD *= 1e1;    expI -= 1;   };
				}

				// here is mantissa in range 1.0000 .. 9.9999

				noround = False;	// rounding is enabled on first run
PrintRestart:
				// check if use exponent mode
				useexp = (ch == 'E') || (ch == 'e') || (ch == 't') || // Eet exponent mode always
					(((ch == 'F') || (ch == 'f')) && ((expI <= -prec))) || // Ff exponent if exp < -precision
					(((ch == 'G') || (ch == 'g')) && ((expI < -3) || (expI > prec))); // Gg exponent if too big or too small

				if (useexp && ((ch == 'G') || (ch == 'g'))) prec--; // without first digit

				// number of digits in exponent mode
				//  1.2345e+12
				digits = prec + 1; // total number of digits, without starting zeroes
				intdig = 1; // number of integer digits, including first starting zero
				zeros = 0; // number of starting zeroes (including integer part)
				zeros2 = 0; // number of trailing zeroes

				// number of digits in F mode ('fixed mode')
				if (!useexp && ((ch == 'F') || (ch == 'f'))) // number of digits in 'f' format
				{
					// 1234.56 (prec=2) = 1.23456e+3, digits = 2 + 1 + 3 = 6
					// 0.012345 (prec=6) = 1.2345e-2, digits = 6 + 1 - 2 = 5
					digits = prec + 1 + expI;	

					if (expI >= 0)
					{
						// 1234.56, expI = +3, intdig = 4
						intdig = expI + 1;
					}
					else
					{
						// 0.012345, expI = -2, zeros = 2
						intdig = 1;
						zeros = - expI;
					}
				}

				// number of digits in G mode ('general mode')
				if (!useexp && ((ch == 'G') || (ch == 'g')))
				{
					digits = prec; // total digits

					if (expI >= 0)
					{
						// 1234.56
						intdig = expI + 1; // digits before decimal point

						// 12300 (prec=3), expI=4, digits=3, intdig=5, zeros2 = 5 - 3 = 2
						if (intdig > digits) zeros2 = intdig - digits;
					}
					else
					{
						// 0.012345, expI = -2, zeros = 2
						intdig = 1;
						zeros = - expI;
					}
				}

				// number of digits in T mode ('technical mode') or B bytes
				if ((ch == 'B') || (ch == 'T') || (ch == 't'))
				{
					digits = prec; // total digits
					n = (b1kb) ? 3 : (expI + 333) % 3; // unaligned exponent (or need 4 digits)
					expI -= n; // align exponent to multiply of 3
					intdig = n + 1; // digits before decimal point
					if (intdig > digits) zeros2 = intdig - digits; // add missing trailing zeroes

					if ((expI < -30) || (expI > 32)) // out of range, change to 't' mode
					{
						ch = 't';
						useexp = True;
					}
				}

				// round last digit
				if (!noround && (digits < 19))
				{
					mantD += SetDoubleCoeff[digits]; // add rounding coefficient
					noround = True; // disable rounding

					if (mantD >= 10) // mantissa overflow
					{
						mantD *= 0.1;
						expI++;
						if ((ch == 'B') || (ch == 'T') || (ch == 't')) expI += n; // restore exponent in T mode
						goto PrintRestart; // restart and run second loop

					}
				}

				// decode mantissa (starting zeroes + valid digits + trailing zeroes)
				d = buf;	// destination buffer
				while (digits + zeros + zeros2 > 0) // length of mantissa
				{
					// get next digit
					if (zeros > 0)
					{
						// starting zero
						b = '0';
						zeros--;
					}
					else
					{
						// valid digit
						if (digits > 0)
						{
							b = (char)mantD;
							mantD -= b;
							mantD *= 10;
							b += '0';
							digits--;
						}
						else
						{
							// trailing zero
							if (zeros2 > 0)
							{
								b = '0';
								zeros2--;
							}
						}
					}

					// store digit
					*d++ = b;

					// decimal point
					intdig--;
					if (intdig == 0) *d++ = '.';

					// grouping
					if (((flags & PRF_GROUP) != 0) && (intdig > 0) && ((intdig % 3) == 0)) *d++ = '\'';
				}

				// reduce trailing zeroes - in 'G' mode or alternate 't', 'F' or 'E' mode
				if ((((ch == 'G') || (ch == 'g')) && ((flags & PRF_ALT) == 0)) || (ch == 'B') ||
					((ch == 't') && (flags & PRF_ALT)) ||
					(((ch == 'F') || (ch == 'f') || (ch == 'E') || (ch == 'e')) && (flags & PRF_ALT)))
				{
					while ((d > buf) && (d[-1] == '0')) d--;
					if ((d > buf) && (d[-1] == '.')) d--;
				}

				// reduce decimal point in 'Tt' mode
				if ((ch == 'T') || (ch == 't'))
				{
					if ((d > buf) && (d[-1] == '.')) d--;

					// do not decode zero exponent in 't' mode with reduction
					if ((ch == 'T') || ((expI == 0) && (flags & PRF_ALT))) useexp = False;
				}

				// decode unit prefix in 'BT' mode
				if ((ch == 'T') || (ch == 'B'))
				{
					if (flags & PRF_ALT) *d++ = ' '; // insert space
					b = UnitPrefix[(expI+30)/3]; // load unit prefix
					if ((b == 'k') && (ch == 'B')) b = 'K'; // use KB instead of kB
					if (b != 0) *d++ = b; // store unit prefix

					if (ch == 'B') *d++ = 'B'; // store "bytes"
				}

				// decode exponent mode
				if (useexp)
				{
					// decode exponent
					*d++ = (ch <= 'Z') ? 'E' : 'e';

					*d++ = (expI < 0) ? '-' : '+';
					if (expI < 0) expI = -expI;

					if (expI >= 100)
					{
						*d++ = (expI / 100) + '0';
						expI = expI % 100;
					}

					if (expI >= 10)
					{
						*d++ = (expI / 10) + '0';
						expI = expI % 10;
					}

					*d++ = expI + '0';
				}

				// terminating 0
				*d = 0;

				size = (int)(d - buf); // size of the number
				chp = buf; // start of the number

				stop = True; // stop parsing
				break;

#endif // USE_DOUBLE

			// 'o': write int, octal
			case 'o':
				nu64 = UARG();		// load argument
				base = PRINTBASE_OCT;	// octal base
				goto nosign_num;

			// 'b': write int, binary
			case 'b':
				nu64 = UARG();		// load argument
				base = PRINTBASE_BIN;	// binary base
				goto nosign_num;

			// 'P': write pointer upper
			case 'P':
				flags |= PRF_UPPER;
				// continue to 'p'

			// 'p': write pointer
			//	The argument shall be a pointer to void.  The value of the pointer
			//	is converted to a sequence of printable characters, in an
			//	implementation-defined manner. -- ANSI X3J11
			case 'p':
				nu64 = (u32)va_arg(args, void*); // get argument
				if (nu64 == 0)
				{
					chp = NULL;
					goto null_ptr; // display "(null)" value
				}
				base = PRINTBASE_HEX; // HEX base
				flags ^= PRF_ALT; // invert request of prefix '0x'
				ch = 'x';
				prec = sizeof(u32)*2; // precision = 8 digits
				goto nosign_num;

			// 's': write character string
			case 's':
				// get pointer to string
				chp = va_arg(args, char*);
null_ptr:
				if (chp == NULL) chp = "(null)"; // string is NULL

				// if precision is specified, we cannot use strlen
				if (prec >= 0)
				{
					for (size = 0; size < prec; size++) if (chp[size] == 0) break;
				}
				else
					size = (int)StrLen(chp); // get length of the text
				sign = 0;
				stop = True;
				break;

			// 'u': write unsigned int
			case 'u':
				nu64 = UARG();		// get argument
				base = PRINTBASE_DEC;	// decadic base
				goto nosign_num;

			// 'X': write unsigned int, upper-case HEX
			case 'X':
				flags |= PRF_UPPER;
				// continue to 'x'

			// 'x': write unsigned int, lower-case HEX
			case 'x':
				nu64 = UARG();		// get argument
				base = PRINTBASE_HEX;	// HEX base

// unsigned conversion
nosign_num:
				sign = 0;	// no sign character

// signed conversion
sign_num:

				// if precision is specified, the '0' flag will be ignored
				dprec = prec; // save decimal precision = min. number of digits of integer number
				if (prec >= 0) flags &= ~PRF_ZEROPAD;

				// prepare destination pointer to decode number
				chp = buf + PR_BUFSIZE; // end of buffer

				// if precision is 0 and number is zero, result will be no character
				if ((nu64 != 0) || (prec != 0))
				{
					ndig = 0;
					alldig = 0;
					zero = (nu64 == 0);

					switch (base)
					{
					// binary base
					case PRINTBASE_BIN:
						do {
							*--chp = (char)((nu64 & 1) + '0');
							nu64 >>= 1;
							alldig++;

							// grouping
							ndig++;
							if ((flags & PRF_GROUP) && (ndig == 4) && ((nu64 > 0) || (alldig < prec)))
							{
								*--chp = '\'';
								ndig = 0;
							}
						} while ((nu64 != 0) || (alldig < prec));

						// binary leading '0b'
						if ((flags & PRF_ALT) && !zero)
						{
							*--chp = 'b';
							*--chp = '0';
						}
						break;

					// octal base
					case PRINTBASE_OCT:
						do {
							*--chp = (char)((nu64 & 7) + '0');
							nu64 >>= 3;
							alldig++;

							// grouping
							ndig++;
							if ((flags & PRF_GROUP) && (ndig == 3) && ((nu64 > 0) || (alldig < prec)))
							{
								*--chp = '\'';
								ndig = 0;
							}
						} while ((nu64 != 0) || (alldig < prec));

						// octal leading '0'
						if ((flags & PRF_ALT) && !zero) *--chp = '0';
						break;

					// decimal base
					case PRINTBASE_DEC:
						do {
							nu64b = nu64 / 10;
							nu64 = nu64 - nu64b*10;							
							*--chp = (char)nu64 + '0';
							nu64 = nu64b;
							alldig++;

							// grouping
							ndig++;
							if ((flags & PRF_GROUP) && (ndig == 3) && ((nu64 > 0) || (alldig < prec)))
							{
								*--chp = '\'';
								ndig = 0;
							}
						} while ((nu64 != 0) || (alldig < prec));
						break;

					case PRINTBASE_HEX:
						if (flags & PRF_UPPER)
						{
							// upper-case
							do {
								*--chp = HexDigU[nu64 & 0x0f];
								nu64 >>= 4;
								alldig++;

								// grouping
								ndig++;
								if ((flags & PRF_GROUP) && (ndig == 4) && ((nu64 > 0) || (alldig < prec)))
								{
									*--chp = '\'';
									ndig = 0;
								}
							} while ((nu64 != 0) || (alldig < prec));

							// hex leading '0x'
							if ((flags & PRF_ALT) && !zero)
							{
								*--chp = 'x';
								*--chp = '0';
							}
						}
						else
						{
							// lower-case
							do {
								*--chp = HexDigL[nu64 & 0x0f];
								nu64 >>= 4;
								alldig++;

								// grouping
								ndig++;
								if ((flags & PRF_GROUP) && (ndig == 4) && ((nu64 > 0) || (alldig < prec)))
								{
									*--chp = '\'';
									ndig = 0;
								}
							} while ((nu64 != 0) || (alldig < prec));

							// hex leading '0x'
							if ((flags & PRF_ALT) && !zero)
							{
								*--chp = 'x';
								*--chp = '0';
							}
						}
						break;
					}
				}
				// get length of string, chp is start of string
				size = (int)((buf + PR_BUFSIZE) - chp);
				stop = True;
				break;

			// unknown character - print it as is
			default:
				buf[0] = ch;	// character to print
				chp = buf;		// pointer to the buffer
				size = 1;		// size = 1 character
				sign = 0;		// no sign
				stop = True;
				break;	
			}
		}

		// end of text
		if (ch == 0) break;

		// prepar real size of printed field (minimal size, add sign)
		realsize = (dprec > size) ? dprec : size;
		if (sign) realsize++;

		// right-adjusting with spaces
		if ((flags & (PRF_LADJUST|PRF_ZEROPAD)) == 0) // neither left alignment nor zero padding
		{
			n = width - realsize; // remaining to minimum width
			while (n-- > 0) OUT(' '); // print leading spaces
		}

		// print sign
		if (sign != 0) OUT(sign);

		// right-adjusting with zeroes
		if ((flags & (PRF_LADJUST|PRF_ZEROPAD)) == PRF_ZEROPAD) // not left justified, but padded with zeros
		{
			n = width - realsize; // remaining to minimum width
			while (n-- > 0) OUT('0'); // print leading zeroes
		}
		
		// leading zeroes from decimal precision (if required minimal with of integer is less than its real size)
		n = dprec - size; // missing zeroes
		while (n-- > 0) OUT('0'); // add zeroes to start of integer number (specified by .precision)

		// output converted number from temporary buffer
		while (size-- > 0) OUT(*chp++);

		// left adjusting padding with spaces
		if ((flags & PRF_LADJUST) != 0) // left alignment not required
		{
			n = width - realsize; // remaining to minimum width
			while (n-- > 0) OUT(' '); // print trailing spaces
		}
	}

	// write terminating NUL character
	OUT(0);

	// close streams
	if (wstr->close != NULL) wstr->close(wstr);
	if (rstr->close != NULL) rstr->close(rstr);

	// return number of characters (without terminating NUL)
	return len - 1;
}

// formated print string into memory buffer, with argument list
u32 MemPrintArg(char* buf, u32 max, const char* fmt, va_list args)
{
	// write and read stream
	sStream wstr, rstr;

	// initialize stream to read from
	StreamReadBufInit(&rstr, fmt, StrLen(fmt));

	// initialize stream to write to
	StreamWriteBufInit(&wstr, buf, max);
	
	// print string
	return StreamPrintArg(&wstr, &rstr, args);
}

// formated print string into memory buffer, with variadic arguments
NOINLINE u32 MemPrint(char* buf, u32 max, const char* fmt, ...)
{
	u32 n;
	va_list args;
	va_start(args, fmt);
	n = MemPrintArg(buf, max, fmt, args);
	va_end(args);
	return n;
}

// formated print string into NUL to get result length, with argument list
u32 NulPrintArg(const char* fmt, va_list args)
{
	// write and read stream
	sStream wstr, rstr;

	// initialize stream to read from
	StreamReadBufInit(&rstr, fmt, StrLen(fmt));

	// initialize NUL stream to write to
	Stream0Init(&wstr);
	
	// print string
	return StreamPrintArg(&wstr, &rstr, args);
}

// formated print string into NUL to get result length, with variadic arguments
NOINLINE u32 NulPrint(const char* fmt, ...)
{
	u32 n;
	va_list args;
	va_start(args, fmt);
	n = NulPrintArg(fmt, args);
	va_end(args);
	return n;
}

#endif // USE_PRINT		// use Formated print (lib_print.c, lib_print.h)

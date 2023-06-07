
// ****************************************************************************
//                                 
//                      Real numbers - common header
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// Note: It is advised not to use Chebyshev approximations or Cordic method for
// long numbers on Raspberry Pico - they require loading large tables from Flash
// and that is a very time consuming operation, so those functions can be slow.

#include "real_def.h"		// define

#include REAL_CONST			// constants

// Declaration of empty tables for case they are not contained in files of constants.

// Decimal exponents (index REAL_DECEXP = number '1') - used by ToText() and FromText()
const REAL REALNAME(ConstExp)[REAL_DECEXP*2+1];

// Factorial coefficients - used to calculate linear factorial by FactLin()
#ifdef FACT_COEFF
const REALEXT REALNAME(ConstFact)[FACT_COEFF]; // FACT_COEFF = REAL_BYTES
#endif

#ifdef CHEB_LN
const REALEXT REALNAME(ConstChebLn)[CHEB_LN]; // Chebyshev coefficients of Ln()
#endif

#ifdef CHEB_EXP
const REALEXT REALNAME(ConstChebExp)[CHEB_EXP]; // Chebyshev coefficients of Exp()
#endif

#ifdef CHEB_SIN
const REALEXT REALNAME(ConstChebSin)[CHEB_SIN]; // Chebyshev coefficients of Sin()
#endif

#ifdef CHEB_ASIN
const REALEXT REALNAME(ConstChebASin)[CHEB_ASIN]; // Chebyshev coefficients of ASin()
#endif

#ifdef CHEB_ATAN
const REALEXT REALNAME(ConstChebATan)[CHEB_ATAN]; // Chebyshev coefficients of ATan()
#endif

#ifdef CHEB_SQRT
const REALEXT REALNAME(ConstChebSqrt)[CHEB_SQRT]; // Chebyshev coefficients of Sqrt()
#endif

#ifdef CORD_ATAN
const REAL REALNAME(ConstAtanInit);	// init value of atan table (=1/expansion factor)
const REAL REALNAME(ConstAtan)[CORD_ATAN]; // Cordic atan table (denormalised mantises)
										// Note: Second half of table is equal to angle.
#endif

// ===========================================================================
//                          Get setup
// ===========================================================================

// ---------------------------------------------------------------------------
// get number of Chebyshev coefficients (fnc = function CHEBCB_*, 0 = not supported)
// ---------------------------------------------------------------------------

int REALNAME(ChebFncNum)(int fnc)
{
	switch (fnc)
	{
#ifdef CHEB_LN
	case CHEBCB_LN: return CHEB_LN;
#endif

#ifdef CHEB_EXP
	case CHEBCB_EXP: return CHEB_EXP;
#endif

#ifdef CHEB_SIN
	case CHEBCB_SIN: return CHEB_SIN;
#endif

#ifdef CHEB_ASIN
	case CHEBCB_ASIN: return CHEB_ASIN;
#endif

#ifdef CHEB_ATAN
	case CHEBCB_ATAN: return CHEB_ATAN;
#endif

#ifdef CHEB_SQRT
	case CHEBCB_SQRT: return CHEB_SQRT;
#endif

	default: return 0;
	}
}

// ---------------------------------------------------------------------------
//       get pointer to Chebyshev coefficients (NULL = not supported)
// ---------------------------------------------------------------------------

const REALEXT* REALNAME(ChebCoefTab)(int fnc)
{
	switch (fnc)
	{
#ifdef CHEB_LN
	case CHEBCB_LN: return REALNAME(ConstChebLn);
#endif

#ifdef CHEB_EXP
	case CHEBCB_EXP: return REALNAME(ConstChebExp);
#endif

#ifdef CHEB_SIN
	case CHEBCB_SIN: return REALNAME(ConstChebSin);
#endif

#ifdef CHEB_ASIN
	case CHEBCB_ASIN: return REALNAME(ConstChebASin);
#endif

#ifdef CHEB_ATAN
	case CHEBCB_ATAN: return REALNAME(ConstChebATan);
#endif

#ifdef CHEB_SQRT
	case CHEBCB_SQRT: return REALNAME(ConstChebSqrt);
#endif

	default: return NULL;
	}
	return NULL;
}

// ===========================================================================
//                       Low-level operations
// ===========================================================================

// ---------------------------------------------------------------------------
//                  long multiply rH:rL <- a*b
// ---------------------------------------------------------------------------

#if !ASM64
#if BASE_BITS > 32
void REALNAME(MulHL)(BASE* rH, BASE* rL, BASE a, BASE b)
{
/*
#if BASE_BITS == 8 // u8

	u16 k = (u16)a*b;
	*rL = (u8)k;
	*rH = (u8)(k >> 8);

#elif BASE_BITS == 16 // u16

	u32 k = (u32)a*b;
	*rL = (u16)k;
	*rH = (u16)(k >> 16);

#elif BASE_BITS == 32 // u32

	u64 k = (u64)a*b;
	*rL = (u32)k;
	*rH = (u32)(k >> 32);

#else // u64
*/
	//       aHaL
	//     x bHbL
	// ----------
	//       aLbL ...   k0
	//     aLbH   ...  k1
	//     aHbL   ...  k2
	//   aHbH     ... k3

	// prepare elements
	u32 aL = (u32)a;
	u32 aH = (u32)(a >> 32);
	u32 bL = (u32)b;
	u32 bH = (u32)(b >> 32);

	// multiply elements (max. FFFF * FFFF = FFFE0001)
	u64 k0 = (u64)aL*bL;
	u64 k1 = (u64)aL*bH;
	u64 k2 = (u64)aH*bL;
	u64 k3 = (u64)aH*bH;

	// add komponents
	k1 += (k0 >> 32); // max. FFFE0001 + FFFE = FFFEFFFF, no carry yet
	k1 += k2; // max. FFFEFFFF + FFFE0001 = 1FFFD0000, it can carry
	if (k1 < k2) k3 += (u64)1 << 32; // add carry, FFFE0001 + 10000 = FFFF0001, no carry

	// result, max. FFFFFFFF * FFFFFFFF = FFFFFFFE:00000001
	*rL = (k1 << 32) + (u32)k0; // result low, FFFF0000 + FFFF = FFFFFFFF, no carry
	*rH = k3 + (k1 >> 32); // result high, FFFF0001 + FFFD = FFFFFFFE, no carry 

//#endif
}
#endif
#endif // ASM64

// ---------------------------------------------------------------------------
// unpack number from normal format to extended format, returns packed extended exponent with sign in highest bit
// ---------------------------------------------------------------------------
// - source and destination can be the same

EXP REALNAME(Unpack)(const REAL* num, REAL* dst)
{
	int i;
	BASE a, carry, *d;
	const BASE *s;
	EXP exp;
	u8 sign;

	// load exponent and sign
	exp = (EXP)REALNAME(GetExp)(num);
	sign = REALNAME(GetSign)(num);

	// zero
	if (exp == (EXP)EXP_0)
	{
		REALNAME(Set0Ext)(dst);
		return EXPEXT_0 | ((EXP)sign << EXPEXT_BITS);
	}

	// infinity
	if (exp == (EXP)EXP_INF)
	{
		REALNAME(SetInfExt)(dst);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// pack extended exponent
	exp = (exp + EXPEXT_BIAS - EXP_BIAS) | ((EXP)sign << EXPEXT_BITS);

	// shift mantissa, without last segment
	s = num->n;
	d = dst->n;
	carry = 0;
	for (i = BASE_NUM-1; i > 0; i--)
	{
		a = *s++;
		*d++ = (a << EXP_BITS) | carry;
		carry = a >> (BASE_BITS - EXP_BITS);
	}

	// shift last segment of mantissa, add implied bit '1'
	a = *s;
	*d = (a << EXP_BITS) | carry | BASE_LAST;

	return exp;
}

void REALNAME(UnpackExt)(const REAL* num, REALEXT* dst)
{
	dst->exp = REALNAME(Unpack)(num, (REAL*)dst);
}

// ---------------------------------------------------------------------------
// pack number from extended format to normal format (round and check range)
// ---------------------------------------------------------------------------
// - source and destination can be the same
// - exponent can be in packed form, with sign in highest bit

void REALNAME(Pack)(REAL* num, const REAL* src, EXP exp)
{
	int i;
	BASE a, *d, carry;
	const BASE *s;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// shift mantissa
	s = &src->n[BASE_NUM];
	d = &num->n[BASE_NUM];
	carry = 0;
	for (i = BASE_NUM; i > 0; i--)
	{
		s--;
		d--;
		a = *s;
		*d = (a >> EXP_BITS) | carry;
		carry = a << (BASE_BITS - EXP_BITS);
	}

	// round
	if ((carry & BASE_LAST) != 0)
	{
		// increment mantissa
		REALNAME(MantInc)(num);

		// check carry
		if ((num->n[BASE_NUM-1] >> (BASE_BITS - EXP_BITS - 1)) > 1)
		{
			REALNAME(MantR1)(num, 0);
			exp++;
		}

		// sticky bits are = 0.5, round to even mantissa
		if ((carry << 1) == 0) num->n[0] &= (BASE)~1;
	}

	// check unverflow
	if (exp <= EXPEXT_BIAS - EXP_BIAS + EXP_0)
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// check overflow
	if (exp >= EXPEXT_BIAS - EXP_BIAS + EXP_MAX)
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// set exponent and sign
	num->n[BASE_NUM-1] = (num->n[BASE_NUM-1] & MANT_LAST_MASK) |
		((BASE)(exp - EXPEXT_BIAS + EXP_BIAS) << EXP_SHIFT) | ((BASE)sign << (BASE_BITS-1));
}

void REALNAME(PackExt)(REAL* num, const REALEXT* src)
{
	REALNAME(Pack)(num, (const REAL*)src, src->exp);
}

// ---------------------------------------------------------------------------
//                    clear exponent and sign (isolate mantissa)
// ---------------------------------------------------------------------------

void REALNAME(ClrExp)(REAL* num)
{
	BASE n = num->n[BASE_NUM-1]; // get last segment
	n <<= EXP_BITS+1; // clear exponent bits and sign
	n >>= EXP_BITS+1; // return position
	num->n[BASE_NUM-1] = n; // store new last segment
}

// ---------------------------------------------------------------------------
//   denormalize mantissa - clear exponent and sign, restore hidden bit '1'
// ---------------------------------------------------------------------------

void REALNAME(Denorm)(REAL* num)
{
	BASE n = num->n[BASE_NUM-1]; // get last segment
	n &= MANT_LAST_MASK; // mask mantissa
	n |= (BASE)1 << MANT_LAST_BITS; // restore hidden bit '1'
	num->n[BASE_NUM-1] = n; // store new last segment
}

// ---------------------------------------------------------------------------
//       shift mantissa left to higher bits (returns carry bit 0 or 1)
// ---------------------------------------------------------------------------

BASE REALNAME(MantL1)(REAL* num, BASE carry)
{
// mantissa is multiply of 256 bits (4x u64, 32 bytes)
#if ASM64 && ((REAL_BITS & 0xff) == 0) && (REAL_BITS >= 512)
	return ShiftL1Big_x64(REAL_BITS/256, (u64*)num->n, carry);
#else
	BASE b, carry2;
	BASE* s = num->n;		// first (lowest) segment
	int i;
	for (i = BASE_NUM; i > 0; i--)
	{
		b = *s;			// load mantissa segment
		carry2 = carry;		// save input carry
		carry = (b >> (BASE_BITS-1)); // get new carry
		b = (b << 1) | carry2;	// shift and add input carry		
		*s++ = b;		// save new segment
	}
	return carry;
#endif
}

// ---------------------------------------------------------------------------
//     shift mantissa right to lower bits (returns carry bit 0 or 1)
// ---------------------------------------------------------------------------

BASE REALNAME(MantR1)(REAL* num, BASE carry)
{
// mantissa is multiply of 256 bits (4x u64, 32 bytes)
#if ASM64 && ((REAL_BITS & 0xff) == 0) && (REAL_BITS >= 512)
	return ShiftR1Big_x64(REAL_BITS/256, (u64*)&num->n[BASE_NUM], carry);
#else
	BASE b, carry2;
	BASE* s = num->n + BASE_NUM-1;	// last (highest) segment
	int i;
	for (i = BASE_NUM; i > 0; i--)
	{
		b = *s;			// load mantissa segment
		carry2 = carry;		// save input carry
		carry = (u8)(b & 1);	// get new carry
		b >>= 1;		// shift
		b |= carry2 << (BASE_BITS-1); // add input carry
		*s-- = b;		// set new segment
	}
	return carry;
#endif
}

// ---------------------------------------------------------------------------
// shift mantissa left to higher bits by more shifts (returns carry bit 0 or 1)
// ---------------------------------------------------------------------------

u8 REALNAME(MantL)(REAL* num, int shift)
{
	int shiftn, shiftb, shiftb2, i;
	BASE *d, *s, segH, segL;
	u8 newcarry;

	// limit number of shifts
	if (shift <= 0) return 0;
	if (shift > REAL_BITS) shift = REAL_BITS;

	// split number of shifts
	shiftn = shift / BASE_BITS;	// number of shifts by whole segments
	shiftb = shift & (BASE_BITS-1); // number of shifts by remaining bits

	// prepare pointers
	d = &num->n[BASE_NUM - 1]; // destination last segment
	s = &num->n[BASE_NUM - 1 - shiftn]; // previous segment

	// shift by whole segments
	if (shiftb == 0)
	{
		// save new carry
		newcarry = (u8)(s[1] & 1);

		// shift
		for (i = BASE_NUM - shiftn; i > 0; i--) *d-- = *s--;

		// clear remaining segments
		for (i = shiftn; i > 0; i--) *d-- = 0;

		// return carry
		return newcarry;
	}

	// save new carry
	shiftb2 = BASE_BITS - shiftb;
	segH = *s;
	newcarry = (u8)((segH >> shiftb2) & 1);

	// shift
	for (i = BASE_NUM - shiftn - 1; i > 0; i--)
	{
		s--;
		segL = *s;
		*d-- = (segH << shiftb) | (segL >> shiftb2);
		segH = segL;
	}

	// clear next segment with carry
	segH <<= shiftb;
	*d-- = segH;

	// clear remaining segments
	for (i = shiftn; i > 0; i--) *d-- = 0;

	// return carry
	return newcarry;
}

// ---------------------------------------------------------------------------
//   shift mantissa right to lower bits (returns lowest carry bit 0 or 1)
// ---------------------------------------------------------------------------
// Input carry will be extended to 0 or -1 signed bits.

u8 REALNAME(MantR)(REAL* num, Bool carry, int shift)
{
	int shiftn, shiftb, shiftb2, i;
	BASE *d, *s, b, segL, segH;
	u8 newcarry;

	// limit number of shifts
	if (shift <= 0) return 0;
	if (shift > REAL_BITS) shift = REAL_BITS;

	// split number of shifts
	shiftn = shift / BASE_BITS;	// number of shifts by whole segments
	shiftb = shift & (BASE_BITS - 1); // number of shifts by remaining bits

	// prepare pointers
	d = &num->n[0]; // destination first segment
	s = &num->n[shiftn]; // next segment

	// shift by whole segments
	b = carry ? BASE_MAX : 0;
	if (shiftb == 0)
	{
		// save new carry
		newcarry = (u8)((s[-1] >> (BASE_BITS - 1)) & 1);

		// shift
		for (i = BASE_NUM - shiftn; i > 0; i--) *d++ = *s++;

		// clear remaining segments
		for (i = shiftn; i > 0; i--) *d++ = b;

		// return carry
		return newcarry;
	}

	// save new carry
	segL = *s;
	newcarry = (u8)((segL >> (shiftb-1)) & 1);

	// shift
	shiftb2 = BASE_BITS - shiftb;
	for (i = BASE_NUM - shiftn - 1; i > 0; i--)
	{
		s++;
		segH = *s;
		*d++ = (segH << shiftb2) | (segL >> shiftb);
		segL = segH;
	}

	// clear next segment with carry
	segL >>= shiftb;
	segL |= (b << shiftb2);
	*d++ = segL;

	// clear remaining segments
	for (i = shiftn; i > 0; i--) *d++ = b;

	// return carry
	return newcarry;
}

// ---------------------------------------------------------------------------
//         count leading zero bits of the mantissa (0..REAL_BITS)
// ---------------------------------------------------------------------------

int REALNAME(MantClz)(const REAL* num)
{
	int i, n;
	const BASE *s;

	// get number of whole zero segments
	s = num->n + BASE_NUM-1;
	n = 0;	// shift counter
	for (i = BASE_NUM; i > 0; i--)
	{
		if (*s != 0) break;
		n += BASE_BITS;
		s--;
	}

	// get number of zero bits in last segment
	if (i > 0)
	{
#if BASE_BITS == 16
		n += clz((u32)(u16)*s)-16;
#else // BASE_BITS == 32
		n += clz(*s);
#endif
	}

	return n;
}

// ---------------------------------------------------------------------------
// normalize mantissa (shift left up to bit "1" on exponent position, returns
// number of shifts -EXP_BITS..0..MANT_BITS, or MANT_BITS+1 = mantissa is zero)
// ---------------------------------------------------------------------------

int REALNAME(MantNorm)(REAL* num)
{
	// count leading zero bits of the mantissa
	int n = REALNAME(MantClz)(num) - EXP_BITS;

	// number is already normalized
	if (n == 0) return 0;

	// need to shift right
	if (n < 0)
		REALNAME(MantR)(num, 0, -n);
	else
		// shift mantissa left
		if (n <= MANT_BITS) REALNAME(MantL)(num, n);

	return n;
}

// ---------------------------------------------------------------------------
// normalize extended mantissa (shift left up to bit "1" on highest position,
// returns number of shifts 0..REAL_BITS-1, or REAL_BITS = mantissa is zero)
// ---------------------------------------------------------------------------

int REALNAME(MantNormExt)(REAL* num)
{
	// count leading zero bits of the mantissa
	int n = REALNAME(MantClz)(num);

	// number is already normalized
	if (n == 0) return 0;

	// shift mantissa left
	if (n < REAL_BITS) REALNAME(MantL)(num, n);

	return n;
}

// ---------------------------------------------------------------------------
//     compare mantissas (returns -1 if num1<num2, 0 if num1==num2, +1 if num1>num2)
// ---------------------------------------------------------------------------

s8 REALNAME(MantComp)(const REAL* num1, const REAL* num2)
{
	BASE a, b;
	int i;
	const BASE* d = &num1->n[BASE_NUM-1]; // last destination segment
	const BASE* s = &num2->n[BASE_NUM-1]; // last source segment
	for (i = BASE_NUM; i > 0; i--)
	{
		a = *d--;
		b = *s--;
		if (a != b)
		{
			if (a > b) return 1;
			return -1;
		}
	}
	return 0;
}

// ---------------------------------------------------------------------------
//        add another mantissa to this mantissa (returns carry 0 or 1)
// ---------------------------------------------------------------------------

BASE REALNAME(MantAdd)(REAL* num, const REAL* src, BASE carry)
{
// mantissa is multiply of 256 bits (4x u64, 32 bytes)
#if ASM64 && ((REAL_BITS & 0xff) == 0)
	return AddBig_x64(REAL_BITS/256, (u64*)num->n, (const u64*)src->n, carry);
#else
	BASE *d, a, b;
	int i;
	const BASE* s = src->n;	// first (lowest) source segment
	d = num->n;			// first (lowest) destination segment
	for (i = BASE_NUM; i > 0; i--)
	{
		a = *d + carry;		// add carry to destinaton segment
		carry = (a < carry) ? 1 : 0; // new carry
		b = *s;			// source segment
		a += b;			// add source segment to destination segment
		carry += (a < b) ? 1 : 0; // new carry (carry will not be = 2)
		*d = a;			// save result segment
		d++;
		s++;
	}
	return carry;
#endif
}

// num = src1 + src2
BASE REALNAME(MantAddFrom)(REAL* num, const REAL* src1, const REAL* src2, BASE carry)
{
	BASE *d, a, b;
	int i;
	const BASE* s1 = src1->n;	// first (lowest) source1 segment
	const BASE* s2 = src2->n;	// first (lowest) source2 segment
	d = num->n;				// first (lowest) destination segment
	for (i = BASE_NUM; i > 0; i--)
	{
		a = *s1 + carry;		// add carry to source1 segment
		carry = (a < carry) ? 1 : 0; // new carry
		b = *s2;			// source2 segment
		a += b;			// add source2 segment to source1 segment
		carry += (a < b) ? 1 : 0; // new carry (carry will not be = 2)
		*d = a;			// save result segment
		d++;
		s1++;
		s2++;
	}
	return carry;
}

// ---------------------------------------------------------------------------
//     subtract another mantissa from this mantissa (returns carry 0 or 1)
// ---------------------------------------------------------------------------

BASE REALNAME(MantSub)(REAL* num, const REAL* src, BASE carry)
{
// mantissa is multiply of 256 bits (4x u64, 32 bytes)
#if ASM64 && ((REAL_BITS & 0xff) == 0)
	return SubBig_x64(REAL_BITS/256, (u64*)num->n, (const u64*)src->n, carry);
#else
	BASE *d, a, b;
	int i;
	const BASE* s = src->n;		// first (lowest) source segment
	d = num->n;			// first (lowest) destination segment
	for (i = BASE_NUM; i > 0; i--)
	{
		b = *s + carry;		// add carry to source segment
		carry = (b < carry) ? 1 : 0; // new carry
		a = *d;			// destination segment
		carry += (a < b) ? 1 : 0; // check new carry after subtraction
		*d = a - b;		// subtract segments and store result
		d++;
		s++;
	}
	return carry;
#endif
}

// num = src1 - src2
BASE REALNAME(MantSubFrom)(REAL* num, const REAL* src1, const REAL* src2, BASE carry)
{
	BASE *d, a, b;
	int i;
	const BASE* s1 = src1->n;	// first (lowest) source1 segment
	const BASE* s2 = src2->n;	// first (lowest) source2 segment
	d = num->n;				// first (lowest) destination segment
	for (i = BASE_NUM; i > 0; i--)
	{
		b = *s2 + carry;	// add carry to source2 segment
		carry = (b < carry) ? 1 : 0; // new carry
		a = *s1;			// source1 segment
		carry += (a < b) ? 1 : 0; // check new carry after subtraction
		*d = a - b;		// subtract segments and store result
		d++;
		s1++;
		s2++;
	}
	return carry;
}

// ---------------------------------------------------------------------------
// inverted subtract this mantissa from another mantissa (returns carry 0 or 1)
// ---------------------------------------------------------------------------

BASE REALNAME(MantInvSub)(REAL* num, const REAL* src, BASE carry)
{
// mantissa is multiply of 256 bits (4x u64, 32 bytes)
#if ASM64 && ((REAL_BITS & 0xff) == 0)
	return InvSubBig_x64(REAL_BITS/256, (u64*)num->n, (const u64*)src->n, carry);
#else
	BASE *d, a, b;
	int i;
	const BASE* s = src->n;		// first (lowest) source segment
	d = num->n;			// first (lowest) destination segment
	for (i = BASE_NUM; i > 0; i--)
	{
		b = *d + carry;		// add carry to destination segment
		carry = (b < carry) ? 1 : 0; // new carry
		a = *s;			// source segment
		carry += (a < b) ? 1 : 0; // check new carry after subtraction
		*d = a - b;		// subtract segments and store result
		d++;
		s++;
	}
	return carry;
#endif
}

// ---------------------------------------------------------------------------
//                OR another mantissa to this mantissa
// ---------------------------------------------------------------------------

void REALNAME(MantOr)(REAL* num, const REAL* src)
{
	BASE *d;
	int i;
	const BASE* s = src->n;		// first (lowest) source segment
	d = num->n;			// first (lowest) destination segment
	for (i = BASE_NUM; i > 0; i--)
	{
		*d = *d | *s;
		d++;
		s++;
	}
}

// ---------------------------------------------------------------------------
//             AND another mantissa to this mantissa
// ---------------------------------------------------------------------------

void REALNAME(MantAnd)(REAL* num, const REAL* src)
{
	BASE *d;
	int i;
	const BASE* s = src->n;		// first (lowest) source segment
	d = num->n;			// first (lowest) destination segment
	for (i = BASE_NUM; i > 0; i--)
	{
		*d = *d & *s;
		d++;
		s++;
	}
}

// ---------------------------------------------------------------------------
//             XOR another mantissa to this mantissa
// ---------------------------------------------------------------------------

void REALNAME(MantXor)(REAL* num, const REAL* src)
{
	BASE *d;
	int i;
	const BASE* s = src->n;		// first (lowest) source segment
	d = num->n;			// first (lowest) destination segment
	for (i = BASE_NUM; i > 0; i--)
	{
		*d = *d ^ *s;
		d++;
		s++;
	}
}

// ---------------------------------------------------------------------------
//             increment mantissa (returns carry=1 if result is = 0)
// ---------------------------------------------------------------------------

u8 REALNAME(MantInc)(REAL* num)
{
	BASE b;
	int i;
	BASE* s = num->n;		// first (lowest) segment
	for (i = BASE_NUM; i > 0; i--)
	{
		b = *s + 1;		// increment segment
		*s = b;			// store new segment
		if (b != 0) return 0;	// result segment is not 0
		s++;
	}
	return 1; // carry is set, result is 0
}

// ---------------------------------------------------------------------------
//             decrement mantissa (returns carry=1 if result is = -1)
// ---------------------------------------------------------------------------

u8 REALNAME(MantDec)(REAL* num)
{
	BASE b;
	int i;
	BASE* s = num->n;		// first (lowest) segment
	for (i = BASE_NUM; i > 0; i--)
	{
		b = *s;			// load segment
		if (b != 0)		// segment is not 0
		{
			*s = b - 1;	// decrement segment
			return 0;	// result segment is not = -1
		}
		*s = b - 1;			// decrement segment (= -1)
		s++;
	}
	return 1; // carry is set, result is -1
}

// ---------------------------------------------------------------------------
//                     invert mantissa
// ---------------------------------------------------------------------------

void REALNAME(MantNot)(REAL* num)
{
	int i;
	BASE* s = num->n;		// first (lowest) segment
	for (i = BASE_NUM; i > 0; i--)
	{
		*s = ~*s;
		s++;
	}
}

// ---------------------------------------------------------------------------
//              negate mantissa (returns carry=1 if result is = 0)
// ---------------------------------------------------------------------------

u8 REALNAME(MantNeg)(REAL* num)
{
// mantissa is multiply of 256 bits (4x u64, 32 bytes)
#if ASM64 && ((REAL_BITS & 0xff) == 0)
	return NegBig_x64(REAL_BITS/256, (u64*)num->n);
#else
	// invert and then increment
	REALNAME(MantNot)(num);
	return REALNAME(MantInc)(num);
#endif
}

// ---------------------------------------------------------------------------
// add member to accumulator and check epsilon of loop (True=continue loop, num=accumulator)
// ---------------------------------------------------------------------------
//  Function uses 2 temporary numbers in the stack.

Bool REALNAME(AddLoop)(REAL* num, const REAL* member)
{
	// accumulator is overflow, member is zero or member is overflow - stop iteration
	if (REALNAME(IsInf)(num) || REALNAME(IsZero)(member) || REALNAME(IsInf)(member)) return False; 

	// compare exponents
	if ((BASES)(REALNAME(GetExp)(num) - REALNAME(GetExp)(member)) > (BASES)REAL_BITSLOOP) return False;

	// add member
	REALNAME(Add)(num, num, member);

	// continue loop
	return True;
}

//  Function uses 1 temporary number in the stack.
Bool REALNAME(AddLoopExt)(REAL* num, EXP* num_exp, const REAL* member, EXP mem_exp)
{
	EXP ex1, ex2;

	// accumulator is overflow - stop iteration
	ex1 = *num_exp & EXPEXT_MASK;
	if (ex1 == EXPEXT_INF) return False; 

	// member is zero or member is overflow - stop iteration
	ex2 = mem_exp & EXPEXT_MASK;	
	if ((ex2 == EXPEXT_0) || (ex2 == EXPEXT_INF)) return False; 

	// compare exponents
	if ((EXPS)(ex1 - ex2) > (EXPS)REAL_BITSLOOPEXT) return False;

	// add member
	*num_exp = REALNAME(AddExt)(num, num, *num_exp, member, mem_exp);

	// continue loop
	return True;
}

// ---------------------------------------------------------------------------
//                copy number from another number
// ---------------------------------------------------------------------------

void REALNAME(Copy)(REAL* num, const REAL* src)
{
	BASE* d;

// mantissa is multiply of 256 bits (4x u64, 32 bytes)
#if ASM64 && ((REAL_BITS & 0xff) == 0)
	const BASE* s = src->n;
	d = num->n;
	if (s != d) CopyBig_x64(REAL_BITS/256, (u64*)d, (const u64*)s);
#else
	int i;
	const BASE* s = src->n;
	d = num->n;
	if (s != d) for (i = BASE_NUM; i > 0; i--) *d++ = *s++;
#endif
}

// ---------------------------------------------------------------------------
//                       exchange numbers
// ---------------------------------------------------------------------------

void REALNAME(Exch)(REAL* num, REAL* num2)
{
	BASE k;
	int i;
	BASE* d = num->n;
	BASE* s = num2->n;
	for (i = BASE_NUM; i > 0; i--)
	{
		k = *s;
		*s = *d;
		*d = k;
		s++;
		d++;
	}
}

// ===========================================================================
//                    Flags and state manipulation
// ===========================================================================

// ---------------------------------------------------------------------------
//                  get exponent unsigned (with bias)
// ---------------------------------------------------------------------------

BASE REALNAME(GetExp)(const REAL* num)
{
	BASE n = num->n[BASE_NUM-1]; // get last segment
	n <<= 1;					// discard sign bit
	n >>= 1 + EXP_SHIFT;		// shift exponent to position 0
	return n;
}

// ---------------------------------------------------------------------------
//                  get exponent signed (without bias)
// ---------------------------------------------------------------------------

BASES REALNAME(GetExpS)(const REAL* num)
{
	BASE n = num->n[BASE_NUM-1]; // get last segment
	n <<= 1;					// discard sign bit
	n >>= 1 + EXP_SHIFT;		// shift exponent to position 0
	return (BASES)(n - EXP_BIAS);
}

// ---------------------------------------------------------------------------
//                          get sign (0 or 1)
// ---------------------------------------------------------------------------

u8 REALNAME(GetSign)(const REAL* num)
{
	BASE n = num->n[BASE_NUM-1];	// get last segment
	return (u8)(n >> (BASE_BITS-1));
}

// ---------------------------------------------------------------------------
//        check if number is zero (can be positive or negative zero)
// ---------------------------------------------------------------------------

Bool REALNAME(IsZero)(const REAL* num)
{
	BASE n = num->n[BASE_NUM-1]; // get last segment
	n <<= 1;					// discard sign bit
	n >>= 1 + EXP_SHIFT;		// shift exponent to position 0
	return (n == EXP_0);		// check zero exponent
}

// ---------------------------------------------------------------------------
//     check if number is infinity (can be positive or negative infinity)
// ---------------------------------------------------------------------------

Bool REALNAME(IsInf)(const REAL* num)
{
	BASE n = num->n[BASE_NUM-1]; // get last segment
	n <<= 1;					// discard sign bit
	n >>= 1 + EXP_SHIFT;		// shift exponent to position 0
	return (n == EXP_INF);		// check infinity exponent
}

// ---------------------------------------------------------------------------
//       check if number is negative (can be zero or infinity, too)
// ---------------------------------------------------------------------------

Bool REALNAME(IsNeg)(const REAL* num)
{
	BASE n = num->n[BASE_NUM-1];	// get last segment
	return (n >> (BASE_BITS-1)) != 0; // check negativy flag
}

// ---------------------------------------------------------------------------
//                  set exponent unsigned (with bias)
// ---------------------------------------------------------------------------

void REALNAME(SetExp)(REAL* num, BASE exp)
{
	BASE n = num->n[BASE_NUM-1];	// get last segment
	n &= ~(EXP_MASK << EXP_SHIFT);	// clear old exponent
	n |= (exp << EXP_SHIFT);	// add new exponent
	num->n[BASE_NUM-1] = n;		// store new last segment
}

// ---------------------------------------------------------------------------
//                 set exponent signed (without bias)
// ---------------------------------------------------------------------------

void REALNAME(SetExpS)(REAL* num, BASES exp)
{
	BASE n = num->n[BASE_NUM-1];	// get last segment
	BASE exp2 = (BASE)(exp + EXP_BIAS); // prepare unsigned exponent
	n &= ~(EXP_MASK << EXP_SHIFT);	// clear old exponent
	n |= (exp2 << EXP_SHIFT);	// add new exponent
	num->n[BASE_NUM-1] = n;		// store new last segment
}

// ---------------------------------------------------------------------------
//                           set sign (0 or <>0)
// ---------------------------------------------------------------------------

void REALNAME(SetSign)(REAL* num, u8 sign)
{
	BASE n = num->n[BASE_NUM-1];	// get last segment
	n <<= 1;					// discard sign bit
	n >>= 1;					// restore
	if (sign != 0) n |= BASE_LAST;	// set sign bit
	num->n[BASE_NUM-1] = n;		// store new last segment
}

// ---------------------------------------------------------------------------
//                   copy sign from other number
// ---------------------------------------------------------------------------

void REALNAME(CopySign)(REAL* num, const REAL* src)
{
	REALNAME(SetSign)(num, REALNAME(GetSign)(src));
}

// ===========================================================================
//                              Set/get number
// ===========================================================================

// ---------------------------------------------------------------------------
//                             set value 0
// ---------------------------------------------------------------------------

void REALNAME(Set0)(REAL* num)
{
	int i;
	BASE* d = num->n;
	for (i = BASE_NUM; i > 0; i--) *d++ = 0;
}

// ---------------------------------------------------------------------------
//                            set value 1
// ---------------------------------------------------------------------------

void REALNAME(Set1)(REAL* num)
{
	int i;
	BASE* d = num->n;
	for (i = BASE_NUM-1; i > 0; i--) *d++ = 0;
	*d = EXP_1 << EXP_SHIFT;
}

void REALNAME(Set1Ext)(REAL* num)
{
	int i;
	BASE* d = num->n;
	for (i = BASE_NUM-1; i > 0; i--) *d++ = 0;
	*d = BASE_LAST;
}

// ---------------------------------------------------------------------------
//                           set value -1
// ---------------------------------------------------------------------------

void REALNAME(SetM1)(REAL* num)
{
	int i;
	BASE* d = num->n;
	for (i = BASE_NUM-1; i > 0; i--) *d++ = 0;
	*d = (EXP_1 << EXP_SHIFT) | BASE_LAST;
}

// ---------------------------------------------------------------------------
//                            set value 2
// ---------------------------------------------------------------------------

void REALNAME(Set2)(REAL* num)
{
	int i;
	BASE* d = num->n;
	for (i = BASE_NUM-1; i > 0; i--) *d++ = 0;
	*d = (EXP_1+1) << EXP_SHIFT;
}

// ---------------------------------------------------------------------------
//                            set value 0.5
// ---------------------------------------------------------------------------

void REALNAME(Set05)(REAL* num)
{
	int i;
	BASE* d = num->n;
	for (i = BASE_NUM-1; i > 0; i--) *d++ = 0;
	*d = (EXP_1-1) << EXP_SHIFT;
}

// ---------------------------------------------------------------------------
//                            set value -0.5
// ---------------------------------------------------------------------------

void REALNAME(SetM05)(REAL* num)
{
	int i;
	BASE* d = num->n;
	for (i = BASE_NUM-1; i > 0; i--) *d++ = 0;
	*d = ((EXP_1-1) << EXP_SHIFT) | BASE_LAST;
}

// ---------------------------------------------------------------------------
//                       set +infinity value
// ---------------------------------------------------------------------------

void REALNAME(SetInf)(REAL* num)
{
	int i;
	BASE* d = num->n;
	for (i = BASE_NUM-1; i > 0; i--) *d++ = 0;
	*d = (EXP_INF << EXP_SHIFT);
}

// ---------------------------------------------------------------------------
//                      set maximal valid number
// ---------------------------------------------------------------------------

void REALNAME(SetMax)(REAL* num)
{
	int i;
	BASE* d = num->n;
	for (i = BASE_NUM; i > 0; i--) *d++ = (BASE)-1;
	REALNAME(SetExp)(num, EXP_MAX-1);
	REALNAME(Abs)(num);	// clear sign bit
}

void REALNAME(SetMaxExt)(REAL* num)
{
	int i;
	BASE* d = num->n;
	for (i = BASE_NUM; i > 0; i--) *d++ = (BASE)-1;
}

// ---------------------------------------------------------------------------
//                    set minimal valid number
// ---------------------------------------------------------------------------

void REALNAME(SetMin)(REAL* num)
{
	int i;
	BASE* d = num->n;
	for (i = BASE_NUM-1; i > 0; i--) *d++ = 0;
	*d = (BASE)(EXP_0+1) << EXP_SHIFT;
}

// ---------------------------------------------------------------------------
//                   set unsigned integer value
// ---------------------------------------------------------------------------

void REALNAME(SetUInt)(REAL* num, BASE n)
{
	int c;
	BASE exp;

	// clear number
	REALNAME(Set0)(num);

	// number is zero
	if (n == 0) return;

	// number is 1 (in this case number of shifts '<<' could overflow to 0)
	if (n == 1)
	{
		num->n[BASE_NUM-1] = EXP_1 << EXP_SHIFT; // REALNAME(Set1)(num);
		return;
	}

	// normalize number - shift to maximal position
#if BASE_BITS == 16
	c = clz(n)+1-16; // get number of leading zeros + 1
#else // BASE_BITS == 32
	c = clz(n)+1; // get number of leading zeros + 1
#endif
	exp = EXP_1 + BASE_BITS - c; // exponent value
	n = (BASE)(n << c); // normalize number, destroy highest hidden bit

	// check exponent range
	if (exp >= EXP_MAX)
	{
		num->n[BASE_NUM-1] = EXP_INF << EXP_SHIFT; // REALNAME(SetInf)(num);
		return;
	}

	// save number
#if EXP_SHIFT == 0
	num->n[BASE_NUM-1] = exp;
#else
	num->n[BASE_NUM-1] = (BASE)((exp << EXP_SHIFT) | (n >> (EXP_BITS+1)));
#endif

#if BASE_NUM > 1
	num->n[BASE_NUM-2] = (BASE)(n << MANT_LAST_BITS);
#endif
}

EXP REALNAME(SetUIntExt)(REAL* num, BASE n)
{
	int c;
	EXP exp;

	// clear number
	REALNAME(Set0Ext)(num);

	// number is zero
	if (n == 0) return EXPEXT_0;

	// number is 1 (in this case number of shifts '<<' could overflow to 0)
	if (n == 1)
	{
		num->n[BASE_NUM-1] = BASE_LAST;	// REALNAME(Set1Ext)(num);
		return EXPEXT_1;
	}

	// normalize number - shift to maximal position
#if BASE_BITS == 16
	c = clz(n)-16; // get number of leading zeros
#else // BASE_BITS == 32
	c = clz(n); // get number of leading zeros
#endif
	exp = EXPEXT_1 + BASE_BITS - 1 - c; // exponent value
	n = (BASE)(n << c); // normalize number (leaves implied bit '1')

	// check exponent range
	if (exp >= EXPEXT_MAX)
	{
		num->n[BASE_NUM-1] = BASE_LAST;	// REALNAME(SetInfExt)(num);
		return EXPEXT_INF;
	}

	// save mantissa
	num->n[BASE_NUM-1] = n;

	return exp;
}

// ---------------------------------------------------------------------------
//                          set u8 integer value
// ---------------------------------------------------------------------------

void REALNAME(SetU8)(REAL* num, u8 n)
{
	// size of segment is always >= u8
	REALNAME(SetUInt)(num, n);
}

EXP REALNAME(SetU8Ext)(REAL* num, u8 n)
{
	// size of segment is always >= u8
	return REALNAME(SetUIntExt)(num, n);
}

// ---------------------------------------------------------------------------
//                          set u16 integer value
// ---------------------------------------------------------------------------

void REALNAME(SetU16)(REAL* num, u16 n)
{
	// size of segment is >= u16
	REALNAME(SetUInt)(num, n);
}

EXP REALNAME(SetU16Ext)(REAL* num, u16 n)
{
	// size of segment is >= u16
	return REALNAME(SetUIntExt)(num, n);
}

// ---------------------------------------------------------------------------
//                          set u32 integer value
// ---------------------------------------------------------------------------

void REALNAME(SetU32)(REAL* num, u32 n)
{
#if BASE_BITS >= 32

	// size of segment is >= u32
	REALNAME(SetUInt)(num, n);

#else // BASE_BITS >= 32

// - here is size of segment = 16 bits

	int c;
	u32 exp;

	// clear number
	REALNAME(Set0)(num);

	// number is zero
	if (n == 0) return;

	// number is 1 (in this case number of shifts '<<' could overflow to 0)
	if (n == 1)
	{
		num->n[BASE_NUM-1] = EXP_1 << EXP_SHIFT; // REALNAME(Set1)(num);
		return;
	}

	// normalize number to highest bits
	c = clz(n)+1; // get number of leading zeros + 1
	exp = EXP_1 + 32 - c; // exponent value
	n = (u32)(n << c); // normalize number, destroy highest hidden bit

	// check exponent range
	if (exp >= EXP_MAX)
	{
		num->n[BASE_NUM-1] = EXP_INF << EXP_SHIFT; // REALNAME(SetInf)(num);
		return;
	}

	// save mantissa
#if EXP_SHIFT == 0
	num->n[BASE_NUM-1] = (u16)exp;
#else
	num->n[BASE_NUM-1] = (u16)((exp << EXP_SHIFT) | (n >> (EXP_BITS+1+16)));
#endif

#if BASE_NUM > 1
	num->n[BASE_NUM-2] = (u16)(n >> (EXP_BITS+1));
#if BASE_NUM > 2
	num->n[BASE_NUM-3] = (u16)(n << MANT_LAST_BITS);
#endif
#endif

#endif // BASE_BITS >= 32
}

EXP REALNAME(SetU32Ext)(REAL* num, u32 n)
{
#if BASE_BITS >= 32

	// size of segment is >= u32
	return REALNAME(SetUIntExt)(num, n);

#else // BASE_BITS >= 32

// - here is size of segment = 16 bits

	int c;
	EXP exp;

	// clear number
	REALNAME(Set0Ext)(num);

	// number is zero
	if (n == 0) return EXPEXT_0;

	// number is 1 (in this case number of shifts '<<' could overflow to 0)
	if (n == 1)
	{
		num->n[BASE_NUM-1] = BASE_LAST;	// REALNAME(Set1Ext)(num);
		return EXPEXT_1;
	}

	// normalize number to highest bits
	c = clz(n); // get number of leading zeros
	exp = EXPEXT_1 + 32 - 1 - c; // exponent value
	n = (u32)(n << c); // normalize number (leaves implied bit '1')

	// check exponent range
	if (exp >= EXPEXT_MAX)
	{
		num->n[BASE_NUM-1] = BASE_LAST; // REALNAME(SetInfExt)(num);
		return EXPEXT_INF;
	}

	// save mantissa
	num->n[BASE_NUM-1] = (u16)(n >> 16);

#if BASE_NUM > 1
	num->n[BASE_NUM-2] = (u16)n;
#endif

	return exp;

#endif // BASE_BITS >= 32
}

// ---------------------------------------------------------------------------
//                          set u64 integer value
// ---------------------------------------------------------------------------

void REALNAME(SetU64)(REAL* num, u64 n)
{
	int c;
	u32 exp;

	// clear number
	REALNAME(Set0)(num);

	// number is zero
	if (n == 0) return;

	// number is 1 (in this case number of shifts '<<' could overflow to 0)
	if (n == 1)
	{
		num->n[BASE_NUM-1] = EXP_1 << EXP_SHIFT; // REALNAME(Set1)(num);
		return;
	}

	// normalize number to highest bits
	c = clz64(n)+1; // get number of leading zeros + 1
	exp = EXP_1 + 64 - c; // exponent value
	n = (u64)(n << c); // normalize number, destroy highest hidden bit

	// check exponent range
	if (exp >= EXP_MAX)
	{
		num->n[BASE_NUM-1] = EXP_INF << EXP_SHIFT; // REALNAME(SetInf)(num);
		return;
	}

	// save mantissa
#if BASE_BITS == 16

// - here is size of segment = 16 bits

#if EXP_SHIFT == 0
	num->n[BASE_NUM-1] = (u16)exp;
#else
	num->n[BASE_NUM-1] = (u16)((exp << EXP_SHIFT) | (n >> (EXP_BITS+1+3*16)));
#endif

#if BASE_NUM > 1
	num->n[BASE_NUM-2] = (u16)(n >> (EXP_BITS+1+2*16));
#if BASE_NUM > 2
	num->n[BASE_NUM-3] = (u16)(n >> (EXP_BITS+1+1*16));
#if BASE_NUM > 3
	num->n[BASE_NUM-4] = (u16)(n >> (EXP_BITS+1));
#if BASE_NUM > 4
	num->n[BASE_NUM-5] = (u16)(n << MANT_LAST_BITS);
#endif
#endif
#endif
#endif

#else // BASE_BITS == 32

// - here is size of segment = 32 bits

#if EXP_SHIFT == 0
	num->n[BASE_NUM-1] = (u32)exp;
#else
	num->n[BASE_NUM-1] = (u32)((exp << EXP_SHIFT) | (n >> (EXP_BITS+1+32)));
#endif

#if BASE_NUM > 1
	num->n[BASE_NUM-2] = (u32)(n >> (EXP_BITS+1));
#if BASE_NUM > 2
	num->n[BASE_NUM-3] = (u32)(n << MANT_LAST_BITS);
#endif
#endif

#endif // BASE_BITS == 32
}

EXP REALNAME(SetU64Ext)(REAL* num, u64 n)
{
	int c;
	EXP exp;

	// clear number
	REALNAME(Set0Ext)(num);

	// number is zero
	if (n == 0) return EXPEXT_0;

	// number is 1 (in this case number of shifts '<<' could overflow to 0)
	if (n == 1)
	{
		num->n[BASE_NUM-1] = BASE_LAST; // REALNAME(Set1Ext)(num);
		return EXPEXT_1;
	}

	// normalize number to highest bits
	c = clz64(n); // get number of leading zeros
	exp = EXPEXT_1 + 64 - 1 - c; // exponent value
	n = (u64)(n << c); // normalize number (leaves implied bit '1')

	// check exponent range
	if (exp >= EXPEXT_MAX)
	{
		num->n[BASE_NUM-1] = BASE_LAST; // REALNAME(SetInfExt)(num);
		return EXPEXT_INF;
	}

	// save mantissa
#if BASE_BITS == 16

// - here is size of segment = 16 bits

	num->n[BASE_NUM-1] = (u16)(n >> 3*16);

#if BASE_NUM > 1
	num->n[BASE_NUM-2] = (u16)(n >> 2*16);
#if BASE_NUM > 2
	num->n[BASE_NUM-3] = (u16)(n >> 1*16);
#if BASE_NUM > 3
	num->n[BASE_NUM-4] = (u16)n;
#endif
#endif
#endif

#else // BASE_BITS == 32

// - here is size of segment = 32 bits

	num->n[BASE_NUM-1] = (u32)(n >> 32);

#if BASE_NUM > 1
	num->n[BASE_NUM-2] = (u32)n;
#endif

#endif // BASE_BITS == 32

	return exp;
}

// ---------------------------------------------------------------------------
//                  set signed integer value
// ---------------------------------------------------------------------------

void REALNAME(SetSInt)(REAL* num, BASES n)
{
	if (n < 0)
	{
		REALNAME(SetUInt)(num, (BASE)-n);
		REALNAME(Neg)(num);
	}
	else
		REALNAME(SetUInt)(num, (BASE)n);
}

// - extended variant returns packed extended exponent with sign
EXP REALNAME(SetSIntExt)(REAL* num, BASES n)
{
	if (n < 0)
		return REALNAME(SetUIntExt)(num, (BASE)-n) | EXPEXT_SIGN;
	else
		return REALNAME(SetUIntExt)(num, (BASE)n);
}

// ---------------------------------------------------------------------------
//                          set s8 integer value
// ---------------------------------------------------------------------------

void REALNAME(SetS8)(REAL* num, s8 n)
{
	// size of segment is >= u8
	REALNAME(SetSInt)(num, n);
}

// - extended variant returns packed extended exponent with sign
EXP REALNAME(SetS8Ext)(REAL* num, s8 n)
{
	// size of segment is >= u8
	return REALNAME(SetSIntExt)(num, n);
}

// ---------------------------------------------------------------------------
//                          set s16 integer value
// ---------------------------------------------------------------------------

void REALNAME(SetS16)(REAL* num, s16 n)
{
	// size of segment is >= u16
	REALNAME(SetSInt)(num, n);
}

// - extended variant returns packed extended exponent with sign
EXP REALNAME(SetS16Ext)(REAL* num, s16 n)
{
	// size of segment is >= u16
	return REALNAME(SetSIntExt)(num, n);
}

// ---------------------------------------------------------------------------
//                          set s32 integer value
// ---------------------------------------------------------------------------

void REALNAME(SetS32)(REAL* num, s32 n)
{
#if BASE_BITS >= 32

	// size of segment is >= u32
	REALNAME(SetSInt)(num, n);

#else

	// size of segment is u16
	if (n < 0)
	{
		REALNAME(SetU32)(num, (u32)-n);
		REALNAME(Neg)(num);
	}
	else
		REALNAME(SetU32)(num, (u32)n);

#endif
}

// - extended variant returns packed extended exponent with sign
EXP REALNAME(SetS32Ext)(REAL* num, s32 n)
{
#if BASE_BITS >= 32

	// size of segment is >= u32
	return REALNAME(SetSIntExt)(num, n);

#else

	// size of segment is u16
	if (n < 0)
		return REALNAME(SetU32Ext)(num, (u32)-n) | EXPEXT_SIGN;
	else
		return REALNAME(SetU32Ext)(num, (u32)n);

#endif
}

// ---------------------------------------------------------------------------
//                          set s64 integer value
// ---------------------------------------------------------------------------

void REALNAME(SetS64)(REAL* num, s64 n)
{
	// size of segment is u16 or u32
	if (n < 0)
	{
		REALNAME(SetU64)(num, (u64)-n);
		REALNAME(Neg)(num);
	}
	else
		REALNAME(SetU64)(num, (u64)n);
}

// - extended variant returns packed extended exponent with sign
EXP REALNAME(SetS64Ext)(REAL* num, s64 n)
{
	// size of segment is u16 or u32
	if (n < 0)
		return REALNAME(SetU64Ext)(num, (u64)-n) | EXPEXT_SIGN;
	else
		return REALNAME(SetU64Ext)(num, (u64)n);
}

// ---------------------------------------------------------------------------
//           get unsigned integer value (rounded towards zero)
// ---------------------------------------------------------------------------

BASE REALNAME(GetUInt_)(const REAL* num, Bool abs)
{
	u8 sign;
	int i;
	BASE exp, k;

	// get sign and exponent
	sign = abs ? False : REALNAME(GetSign)(num);
	exp = REALNAME(GetExp)(num);

	// number is < 1 (negative or small positive), return zero
	if ((sign != 0) || (exp < EXP_1)) return 0;

	// absolute exponent
	exp -= EXP_BIAS;

	// check overflow
	if (exp >= BASE_BITS) return BASE_MAX;

	// load mantissa
#if EXP_SHIFT != 0
	k = num->n[BASE_NUM-1] << (EXP_BITS+1);

#if BASE_NUM > 1
	k |= num->n[BASE_NUM-2] >> MANT_LAST_BITS;
#endif

#else
	k = num->n[BASE_NUM-2];
#endif

	// restore hidden bit
	k = (k >> 1) | BASE_LAST;

	// shift to valid position
	//  here is exp = 0..BASE_BITS-1
	i = (int)(BASE_BITS - 1 - exp);
	//  here is i = 0..BASE_BITS-1
	if (i > 0) k >>= i;

	return k;
}

// - exponent can be in packed form, with sign in highest bit
BASE REALNAME(GetUIntExt)(const REAL* num, EXP exp)
{
	int i;
	BASE k;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// number is < 1 (negative or small positive), return zero
	if ((sign != 0) || (exp < EXPEXT_1)) return 0;

	// absolute exponent
	exp -= EXPEXT_BIAS;

	// check overflow
	if (exp >= BASE_BITS) return BASE_MAX;

	// load mantissa (including implied bit '1')
	k = num->n[BASE_NUM-1];

	// shift to valid position
	//  here is exp = 0..BASE_BITS-1
	i = (int)(BASE_BITS - 1 - exp);
	//  here is i = 0..BASE_BITS-1
	if (i > 0) k >>= i;

	return k;
}

// ---------------------------------------------------------------------------
//             get u8 integer value (rounded towards zero)
// ---------------------------------------------------------------------------

u8 REALNAME(GetU8_)(const REAL* num, Bool abs)
{
	// size of segment is >= u8
	BASE n = REALNAME(GetUInt_)(num, abs);
	if (n > 0xff) n = 0xff;
	return (u8)n;
}

// - exponent can be in packed form, with sign in highest bit
u8 REALNAME(GetU8Ext)(const REAL* num, EXP exp)
{
	// size of segment is >= u8
	BASE n = REALNAME(GetUIntExt)(num, exp);
	if (n > 0xff) n = 0xff;
	return (u8)n;
}

// ---------------------------------------------------------------------------
//             get u16 integer value (rounded towards zero)
// ---------------------------------------------------------------------------

u16 REALNAME(GetU16_)(const REAL* num, Bool abs)
{
	// size of segment is >= u16
	BASE n = REALNAME(GetUInt_)(num, abs);

#if BASE_BITS > 16
	if (n > 0xffff) n = 0xffff;
#endif

	return (u16)n;
}

// - exponent can be in packed form, with sign in highest bit
u16 REALNAME(GetU16Ext)(const REAL* num, EXP exp)
{
	// size of segment is >= u16
	BASE n = REALNAME(GetUIntExt)(num, exp);

#if BASE_BITS > 16
	if (n > 0xffff) n = 0xffff;
#endif

	return (u16)n;
}

// ---------------------------------------------------------------------------
//             get u32 integer value (rounded towards zero)
// ---------------------------------------------------------------------------

u32 REALNAME(GetU32_)(const REAL* num, Bool abs)
{
#if BASE_BITS >= 32

	// size of segment is >= u32
	BASE n = REALNAME(GetUInt_)(num, abs);

#if BASE_BITS > 32
	if (n > 0xffffffffUL) n = 0xffffffffUL;
#endif

	return (u32)n;

#else // BASE_BITS < 32

// size of segment is u16

	u8 sign;
	int i;
	BASE exp;
	u32 k;

	// get sign and exponent
	sign = abs ? False : REALNAME(GetSign)(num);
	exp = REALNAME(GetExp)(num);

	// number is < 1 (negative or small positive), return zero
	if ((sign != 0) || (exp < EXP_1)) return 0;

	// absolute exponent
	exp -= EXP_BIAS;

	// check overflow
	if (exp >= 32) return 0xffffffffUL;

	// load mantissa
#if EXP_SHIFT != 0
	k = (u32)num->n[BASE_NUM-1] << (EXP_BITS+1+16);
#else
	k = 0;
#endif

#if BASE_NUM > 1
	k |= (u32)num->n[BASE_NUM-2] << (EXP_BITS+1);
#if BASE_NUM > 2
	k |= num->n[BASE_NUM-3] >> MANT_LAST_BITS;
#endif
#endif

	// restore hidden bit
	k = (k >> 1) | 0x80000000UL;

	// shift to valid position
	i = (int)(32 - 1 - exp);
	if (i > 0) k >>= i;

	return k;

#endif // BASE_BITS >= 32
}

// - exponent can be in packed form, with sign in highest bit
u32 REALNAME(GetU32Ext)(const REAL* num, EXP exp)
{
#if BASE_BITS >= 32

	// size of segment is >= u32
	BASE n = REALNAME(GetUIntExt)(num, exp);

#if BASE_BITS > 32
	if (n > 0xffffffffUL) n = 0xffffffffUL;
#endif

	return (u32)n;

#else // BASE_BITS < 32

// size of segment is u16

	int i;
	u32 k;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// number is < 1 (negative or small positive), return zero
	if ((sign != 0) || (exp < EXPEXT_1)) return 0;

	// absolute exponent
	exp -= EXPEXT_BIAS;

	// check overflow
	if (exp >= 32) return 0xffffffffUL;

	// load mantissa (including implied bit '1')
	k = (u32)num->n[BASE_NUM-1] << 16;

#if BASE_NUM > 1
	k |= (u32)num->n[BASE_NUM-2];
#endif

	// shift to valid position
	//  here is exp = 0..31
	i = (int)(32 - 1 - exp);
	//  here is i = 0..31
	if (i > 0) k >>= i;

	return k;

#endif // BASE_BITS >= 32
}

// ---------------------------------------------------------------------------
//             get u64 integer value (rounded towards zero)
// ---------------------------------------------------------------------------

u64 REALNAME(GetU64_)(const REAL* num, Bool abs)
{
	u8 sign;
	int i;
	BASE exp;
	u64 k;

	// get sign and exponent
	sign = abs ? False : REALNAME(GetSign)(num);
	exp = REALNAME(GetExp)(num);

	// number is < 1 (negative or small positive), return zero
	if ((sign != 0) || (exp < EXP_1)) return 0;

	// absolute exponent
	exp -= EXP_BIAS;

	// check overflow
	if (exp >= 64) return 0xffffffffffffffffULL;

#if BASE_BITS >= 32

// size of segment is u32

	// load mantissa
#if EXP_SHIFT != 0
	k = (u64)num->n[BASE_NUM-1] << (EXP_BITS+1+32);
#else
	k = 0;
#endif

#if BASE_NUM > 1
	k |= (u64)num->n[BASE_NUM-2] << (EXP_BITS+1);
#if BASE_NUM > 2
	k |= num->n[BASE_NUM-3] >> MANT_LAST_BITS;
#endif
#endif

#else // BASE_BITS >= 16

// size of segment is u16

	// load mantissa
#if EXP_SHIFT != 0
	k = (u64)num->n[BASE_NUM-1] << (EXP_BITS+1+3*16);
#else
	k = 0;
#endif

#if BASE_NUM > 1
	k |= (u64)num->n[BASE_NUM-2] << (EXP_BITS+1+2*16);
#if BASE_NUM > 2
	k |= (u64)num->n[BASE_NUM-3] << (EXP_BITS+1+1*16);
#if BASE_NUM > 3
	k |= (u64)num->n[BASE_NUM-4] << (EXP_BITS+1);
#if BASE_NUM > 4
	k |= (u64)num->n[BASE_NUM-5] >> MANT_LAST_BITS;
#endif
#endif
#endif
#endif

#endif // BASE_BITS >= 16

	// restore hidden bit
	k = (k >> 1) | 0x8000000000000000ULL;

	// shift to valid position
	i = (int)(64 - 1 - exp);
	if (i > 0) k >>= i;

	return k;
}

// - exponent can be in packed form, with sign in highest bit
u64 REALNAME(GetU64Ext)(const REAL* num, EXP exp)
{
	int i;
	u64 k;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// number is < 1 (negative or small positive), return zero
	if ((sign != 0) || (exp < EXPEXT_1)) return 0;

	// absolute exponent
	exp -= EXPEXT_BIAS;

	// check overflow
	if (exp >= 64) return 0xffffffffffffffffULL;

#if BASE_BITS >= 32

// size of segment is u32

	// load mantissa
	k = (u64)num->n[BASE_NUM-1] << 32;

#if BASE_NUM > 1
	k |= (u64)num->n[BASE_NUM-2];
#endif

#else // BASE_BITS >= 16

// size of segment is u16

	// load mantissa (including implied bit '1')
	k = (u64)num->n[BASE_NUM-1] << 3*16;

#if BASE_NUM > 1
	k |= (u64)num->n[BASE_NUM-2] << 2*16;
#if BASE_NUM > 2
	k |= (u64)num->n[BASE_NUM-3] << 1*16;
#if BASE_NUM > 3
	k |= (u64)num->n[BASE_NUM-4];
#endif
#endif
#endif

#endif // BASE_BITS >= 16

	// shift to valid position
	//  here is exp = 0..63
	i = (int)(64 - 1 - exp);
	//  here is i = 0..63
	if (i > 0) k >>= i;

	return k;
}

// ---------------------------------------------------------------------------
//            get signed integer value (rounded towards zero)
// ---------------------------------------------------------------------------

BASES REALNAME(GetSInt)(const REAL* num)
{
	// get number (absolute value)
	BASE res = REALNAME(GetUIntAbs)(num);

	// negative number
	if (REALNAME(IsNeg)(num))
	{
		if (res > BASE_LAST) res = BASE_LAST;
		return -(BASES)res;
	}

	// positive number
	if (res > BASE_MASK) res = BASE_MASK;
	return (BASES)res;
}

// - exponent can be in packed form, with sign in highest bit
BASES REALNAME(GetSIntExt)(const REAL* num, EXP exp)
{
	u8 sign;
	BASE res;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// get number (absolute value)
	res = REALNAME(GetUIntExt)(num, exp);

	// negative number
	if (sign != 0)
	{
		if (res > BASE_LAST) res = BASE_LAST;
		return -(BASES)res;
	}

	// positive number
	if (res > BASE_MASK) res = BASE_MASK;
	return (BASES)res;
}

// ---------------------------------------------------------------------------
//            get s8 integer value (rounded towards zero)
// ---------------------------------------------------------------------------

s8 REALNAME(GetS8)(const REAL* num)
{
	// size of segment is >= u8
	BASES n = REALNAME(GetSInt)(num);
	if (n > 0x7f) n = 0x7f;
	if (n < (s8)0x80) n = (s8)0x80;
	return (s8)n;
}

// - exponent can be in packed form, with sign in highest bit
s8 REALNAME(GetS8Ext)(const REAL* num, EXP exp)
{
	// size of segment is >= u8
	BASES n = REALNAME(GetSIntExt)(num, exp);
	if (n > 0x7f) n = 0x7f;
	if (n < (s8)0x80) n = (s8)0x80;
	return (s8)n;
}

// ---------------------------------------------------------------------------
//            get s16 integer value (rounded towards zero)
// ---------------------------------------------------------------------------

s16 REALNAME(GetS16)(const REAL* num)
{
	// size of segment is >= u16
	BASES n = REALNAME(GetSInt)(num);

#if BASE_BITS > 16
	if (n > 0x7fff) n = 0x7fff;
	if (n < (s16)0x8000) n = (s16)0x8000;
#endif

	return (s16)n;
}

// - exponent can be in packed form, with sign in highest bit
s16 REALNAME(GetS16Ext)(const REAL* num, EXP exp)
{
	// size of segment is >= u16
	BASES n = REALNAME(GetSIntExt)(num, exp);

#if BASE_BITS > 16
	if (n > 0x7fff) n = 0x7fff;
	if (n < (s16)0x8000) n = (s16)0x8000;
#endif

	return (s16)n;
}

// ---------------------------------------------------------------------------
//            get s32 integer value (rounded towards zero)
// ---------------------------------------------------------------------------

s32 REALNAME(GetS32)(const REAL* num)
{
#if BASE_BITS >= 32

	// size of segment is >= u32
	BASES n = REALNAME(GetSInt)(num);

#if BASE_BITS > 32
	if (n > 0x7fffffffL) n = 0x7fffffffL;
	if (n < (s32)0x80000000L) n = (s32)0x80000000L;
#endif

	return (s32)n;

#else // BASE_BITS >= 32

// size of segment is u16

	// get number (absolute value)
	u32 res = REALNAME(GetU32Abs)(num);

	// negative number
	if (REALNAME(IsNeg)(num))
	{
		if (res > 0x80000000UL) res = 0x80000000UL;
		return -(s32)res;
	}

	// positive number
	if (res > 0x7fffffffUL) res = 0x7fffffffUL;
	return (s32)res;

#endif // BASE_BITS >= 32
}

// - exponent can be in packed form, with sign in highest bit
s32 REALNAME(GetS32Ext)(const REAL* num, EXP exp)
{
#if BASE_BITS >= 32

	// size of segment is >= u32
	BASES n = REALNAME(GetSIntExt)(num, exp);

#if BASE_BITS > 32
	if (n > 0x7fffffffL) n = 0x7fffffffL;
	if (n < (s32)0x80000000L) n = (s32)0x80000000L;
#endif

	return (s32)n;

#else // BASE_BITS >= 32

// size of segment is u16

	u8 sign;
	u32 res;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// get number (absolute value)
	res = REALNAME(GetU32Ext)(num, exp);

	// negative number
	if (sign != 0)
	{
		if (res > 0x80000000UL) res = 0x80000000UL;
		return -(s32)res;
	}

	// positive number
	if (res > 0x7fffffffUL) res = 0x7fffffffUL;
	return (s32)res;

#endif // BASE_BITS >= 32
}

// ---------------------------------------------------------------------------
//            get s64 integer value (rounded towards zero)
// ---------------------------------------------------------------------------

s64 REALNAME(GetS64)(const REAL* num)
{
	// get number (absolute value)
	u64 res = REALNAME(GetU64Abs)(num);

	// negative number
	if (REALNAME(IsNeg)(num))
	{
		if (res > 0x8000000000000000ULL) res = 0x8000000000000000ULL;
		return -(s64)res;
	}

	// positive number
	if (res > 0x7fffffffffffffffULL) res = 0x7fffffffffffffffULL;
	return (s64)res;
}

// - exponent can be in packed form, with sign in highest bit
s64 REALNAME(GetS64Ext)(const REAL* num, EXP exp)
{
	u8 sign;
	u64 res;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// get number (absolute value)
	res = REALNAME(GetU64Ext)(num, exp);

	// negative number
	if (sign != 0)
	{
		if (res > 0x8000000000000000ULL) res = 0x8000000000000000ULL;
		return -(s64)res;
	}

	// positive number
	if (res > 0x7fffffffffffffffULL) res = 0x7fffffffffffffffULL;
	return (s64)res;
}

// ---------------------------------------------------------------------------
//                import from REAL number of another type
// ---------------------------------------------------------------------------
//  num = pointer to this number
//  src = pointer to source REAL number
//	realbytes = size of REAL number in number of bytes
//  expbits = size of exponent in number of bits

void REALNAME(Import)(REAL* num, const void* src, int realbytes, int expbits)
{
	int srcbits, dstskip, srcskip;
	u8 round, *d, sign;
	int i;
	const u8* s;
	s32 exp;

	// import from the same number type
	if ((realbytes == REAL_BYTES) && (expbits == EXP_BITS))
	{
		REALNAME(Copy)(num, (const REAL*)src);
		return;
	}

	// prepare number of bits of mantissa to copy
	srcbits = realbytes*8 - expbits - 1;
	dstskip = 0;
	srcskip = 0;

	// source mantissa is equal to the destination
	if (MANT_BITS == srcbits)
	{
		memcpy(num->n, src, (MANT_BITS+7)/8);
		round = 0;
	}
	else

	// source mantissa is shorter than destination
	if (MANT_BITS > srcbits)
	{
		REALNAME(Set0)(num);
		dstskip = MANT_BITS - srcbits;
		s = (const u8*)src;
		d = &((u8*)num->n)[dstskip/8];
		memcpy(d, s, (srcbits+7)/8);
		i = dstskip & 7;
		if (i != 0) REALNAME(MantL)(num, i);
		round = 0;
	}
	else

	// source mantissa is longer than destination
	{
		srcskip = srcbits - MANT_BITS;
		s = &((const u8*)src)[srcskip/8];
		if ((srcskip & 7) == 0) // srcskip is never = 0
			round = (s[-1] >> 7) & 1;
		else
			round = (*s >> ((srcskip-1) & 7)) & 1;
		d = (u8*)num->n;
		i = (MANT_BITS+7)/8;
		if ((i < realbytes) && (i < REAL_BYTES)) i++;
		memcpy(d, s, i);
		i = srcskip & 7;
		if (i != 0) REALNAME(MantR)(num, 0, i);
	}

	// mask top bits of mantissa
	REALNAME(ClrExp)(num); // clear exponent and sign

	// round
	if (round != 0)
	{
		REALNAME(MantInc)(num); // increment mantissa
		round = (u8)REALNAME(GetExp)(num); // round = carry to exponent
		if (round != 0)
		{
			REALNAME(ClrExp)(num); // clear carry
			REALNAME(MantR1)(num, 0);
		}
	}

	// get sign
	s = &((const u8*)src)[realbytes-1]; // last byte of source number
	sign = *s >> 7;

	// load first byte of exponent
	exp = (*s-- & 0x7f); // load highest bits of exponent
	i = expbits - 7; // number of bits of exponent
	if (i < 0) exp >>= -i; // mask exponent if it is whole in last u8

	// load rest of exponent
	while (i > 0)
	{
		// load next whole byte
		if (i >= 8)
		{
			exp <<= 8;
			exp |= *s--;
			i -= 8;
		}

		// load last byte
		else
		{
			exp <<= i;
			exp |= (*s >> (8 - i));
			i = 0;
		}
	}

	// source number is zero
	if (exp == 0)
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// overflow
	if (exp == ((1 << expbits)-1))
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// convert exponent bias
	exp -= (1 << (expbits-1)) - 1;
	exp += EXP_BIAS + round;

	// underflow
	if (exp <= 0)
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// overflow
	if (exp >= EXP_MAX)
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// set exponent
	REALNAME(SetExp)(num, (BASE)exp);
	REALNAME(SetSign)(num, sign);
}

//  Extended version returns exponent in packed form with sign in highest bit.
EXP REALNAME(ImportExt)(REAL* num, const void* src, int realbytes, int expbits)
{
#ifdef REALREF // reference number supported

	REALREF ref;
	REALREFNAME(Import)(&ref, src, realbytes, expbits);
	return REALNAME(ImportRefExt)(num, &ref);

#else // REALREF // reference number supported

	REALNAME(Import)(num, src, realbytes, expbits);
	return REALNAME(Unpack)(num, num);

#endif // REALREF // reference number supported
}

// ---------------------------------------------------------------------------
//                            import from float
// ---------------------------------------------------------------------------

void REALNAME(FromFloat)(REAL* num, float n)
{
#if (REAL_BITS == 32) && (EXP_BITS == 8)

	*(float*)num = n;

#else

#define EXPBITS 8
#define SRCBITS 23
#define DSTSKIP (MANT_BITS - SRCBITS) // skip destination bits
#define SRCSKIP (SRCBITS - MANT_BITS) // skip bits of source mantissa

	u8 *d, sign;
	const u8* s;
	u32 round;
	s32 exp;

	// source mantissa is equal to the destination
#if MANT_BITS == SRCBITS
	*(float*)num = n;
	round = 0;

	// source mantissa is shorter than destination
#elif MANT_BITS > SRCBITS
	int i;
	REALNAME(Set0)(num);
	s = (const u8*)&n;
	d = &((u8*)num->n)[DSTSKIP/8];
//	memcpy(d, s, (SRCBITS+7)/8);
	for (i = (SRCBITS+7)/8; i > 0; i--) *d++ = *s++;
	round = 0;

#if (DSTSKIP & 7) != 0
	REALNAME(MantL)(num, DSTSKIP & 7);
#endif

	// source mantissa is longer than destination
#else
	int i;
	s = &((const u8*)&n)[SRCSKIP/8];

#if (SRCSKIP & 7) == 0 // srcskip is never = 0
	round = (s[-1] >> 7) & 1;
#else
	round = (*s >> ((SRCSKIP-1) & 7)) & 1;
#endif

	d = (u8*)num->n;
	i = (MANT_BITS+7)/8;
	if ((i < 4) && (i < REAL_BYTES)) i++;
	for (; i > 0; i--) *d++ = *s++;
//	memcpy(d, s, i);

#if (SRCSKIP & 7) != 0
	REALNAME(MantR)(num, 0, SRCSKIP & 7);
#endif

#endif

	// mask top bits of mantissa
	REALNAME(ClrExp)(num); // clear exponent and sign

	// round
	if (round != 0)
	{
		REALNAME(MantInc)(num); // increment mantissa
		round = REALNAME(GetExp)(num); // round = carry to exponent
		if (round != 0)
		{
			REALNAME(ClrExp)(num); // clear carry
			REALNAME(MantR1)(num, 0);
		}
	}

	// get sign
	sign = (u8)(*(u32*)&n >> 31);

	// get exponent
	exp = (*(u32*)&n >> 23) & 0xff;

	// source number is zero
	if (exp == 0)
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// overflow
	if (exp == 0xff)
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// convert exponent bias
	exp -= 127;
	exp += EXP_BIAS + round;

	// underflow
	if (exp <= 0)
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// overflow
	if (exp >= EXP_MAX)
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// set exponent
	REALNAME(SetExp)(num, (BASE)exp);
	REALNAME(SetSign)(num, sign);

#undef EXPBITS
#undef SRCBITS
#undef DSTSKIP
#undef SRCSKIP

#endif
}

// ---------------------------------------------------------------------------
//                            import from double
// ---------------------------------------------------------------------------

void REALNAME(FromDouble)(REAL* num, double n)
{
#if (REAL_BITS == 64) && (EXP_BITS == 11)

	*(double*)num = n;

#else

#define EXPBITS 11
#define SRCBITS 52
#define DSTSKIP (MANT_BITS - SRCBITS) // skip destination bits
#define SRCSKIP (SRCBITS - MANT_BITS) // skip bits of source mantissa

	u8 *d, sign;
	const u8* s;
	u32 round;
	s32 exp;

	// source mantissa is equal to the destination
#if MANT_BITS == SRCBITS
	*(double*)num = n;
	round = 0;

	// source mantissa is shorter than destination
#elif MANT_BITS > SRCBITS
	int i;
	REALNAME(Set0)(num);
	s = (const u8*)&n;
	d = &((u8*)num->n)[DSTSKIP/8];
//	memcpy(d, s, (SRCBITS+7)/8);
	for (i = (SRCBITS+7)/8; i > 0; i--) *d++ = *s++;
	round = 0;

#if (DSTSKIP & 7) != 0
	REALNAME(MantL)(num, DSTSKIP & 7);
#endif

	// source mantissa is longer than destination
#else
	int i;
	s = &((const u8*)&n)[SRCSKIP/8];

#if (SRCSKIP & 7) == 0 // srcskip is never = 0
	round = (s[-1] >> 7) & 1;
#else
	round = (*s >> ((SRCSKIP-1) & 7)) & 1;
#endif

	d = (u8*)num->n;
	i = (MANT_BITS+7)/8;
	if ((i < 8) && (i < REAL_BYTES)) i++;
	for (; i > 0; i--) *d++ = *s++;
//	memcpy(d, s, i);

#if (SRCSKIP & 7) != 0
	REALNAME(MantR)(num, 0, SRCSKIP & 7);
#endif

#endif

	// mask top bits of mantissa
	REALNAME(ClrExp)(num); // clear exponent and sign

	// round
	if (round != 0)
	{
		REALNAME(MantInc)(num); // increment mantissa
		round = REALNAME(GetExp)(num); // round = carry to exponent
		if (round != 0)
		{
			REALNAME(ClrExp)(num); // clear carry
			REALNAME(MantR1)(num, 0);
		}
	}

	// get sign
	sign = (u8)(*(u64*)&n >> 63);

	// get exponent
	exp = (s32)((u32)(*(u64*)&n >> 52) & 0x7ff);

	// source number is zero
	if (exp == 0)
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// overflow
	if (exp == 0x7ff)
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// convert exponent bias
	exp -= 1023;
	exp += EXP_BIAS + round;

	// underflow
	if (exp <= 0)
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// overflow
	if (exp >= EXP_MAX)
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// set exponent
	REALNAME(SetExp)(num, (BASE)exp);
	REALNAME(SetSign)(num, sign);

#undef EXPBITS
#undef SRCBITS
#undef DSTSKIP
#undef SRCSKIP

#endif
}
	
// ---------------------------------------------------------------------------
//                            export to float
// ---------------------------------------------------------------------------

float REALNAME(ToFloat)(const REAL* num)
{
#if (REAL_BITS == 32) && (EXP_BITS == 8)

	return *(float*)num;

#else

#define DSTBITS 23 // number of bits of destination mantissa
#define DSTSKIP (DSTBITS - MANT_BITS) // skip destination bits
#define SRCSKIP (MANT_BITS - DSTBITS) // skip bits of source mantissa

	const u8* s;
	s32 exp;
	u32 nn, sign, round;

	// source mantissa is equal to the destination
#if DSTBITS == MANT_BITS
	nn = *(const u32*)num->n;
	round = 0; // no rounding

	// source mantissa is shorter than destination
#elif DSTBITS > MANT_BITS
	int i;
	u8* d;
	nn = 0;
	s = (const u8*)num->n;
	d = &((u8*)&nn)[DSTSKIP/8];
	for (i = (MANT_BITS+7)/8; i > 0; i--) *d++ = *s++;
//	memcpy(d, s, (MANT_BITS+7)/8);
	round = 0; // no rounding

#if (DSTSKIP & 7) != 0
	nn <<= (DSTSKIP & 7);
#endif

	// source mantissa is longer than destination
#else
	s = &((const u8*)num->n)[SRCSKIP/8];

#if (SRCSKIP & 7) == 0 // srcskip is never = 0
	round = (s[-1] >> 7) & 1;
#else
	round = (*s >> ((SRCSKIP-1) & 7)) & 1;
#endif

	memcpy(&nn, s, 4);

#if (SRCSKIP & 7) != 0
	nn >>= SRCSKIP & 7;
#endif

#endif

	// mask top bits of mantissa
	nn &= 0x007fffff; // clear exponent and sign

	// round
	if (round != 0)
	{
		round = 0;
		nn++; // increment mantissa
		if (nn > 0x007fffff) // round = carry to exponent
		{
			nn &= 0x007fffff; // clear carry
			nn >>= 1;
			round = 1;
		}
	}

	// get sign
	sign = REALNAME(GetSign)(num);

	// get exponent
	exp = REALNAME(GetExp)(num);

	// source number is zero
	if (exp == 0)
	{
		nn = (u32)sign << 31;
		return *(float*)&nn;
	}

	// overflow
	if (exp == EXP_INF)
	{
		nn = ((u32)sign << 31) | (0xffUL << 23);
		return *(float*)&nn;
	}

	// convert exponent bias
	exp -= EXP_BIAS;
	exp += 127 + round;

	// underflow
	if (exp <= 0)
	{
		nn = (u32)sign << 31;
		return *(float*)&nn;
	}

	// overflow
	if (exp >= 255)
	{
		nn = ((u32)sign << 31) | (0xff << 23);
		return *(float*)&nn;
	}

	// set exponent
	nn |= (exp << 23) | ((u32)sign << 31);
	return *(float*)&nn;

#undef DSTBITS
#undef DSTSKIP
#undef SRCSKIP

#endif
}

//  Extended version uses exponent in packed form with sign in highest bit.
float REALNAME(ToFloatExt)(const REAL* num, EXP exp)
{
#ifdef REALREF
	REALREF r;
	REALNAME(ExportRefExt)(num, exp, &r);
	return REALREFNAME(ToFloat)(&r);
#else // REALREF
	REAL r;
	REALNAME(Pack)(&r, num, exp);
	return REALNAME(ToFloat)(&r);
#endif // REALREF
}

// ---------------------------------------------------------------------------
//                            export to double
// ---------------------------------------------------------------------------

double REALNAME(ToDouble)(const REAL* num)
{
#if (REAL_BITS == 64) && (EXP_BITS == 11)

	return *(double*)num;

#else

#define DSTBITS 52 // number of bits of destination mantissa
#define DSTSKIP (DSTBITS - MANT_BITS) // skip destination bits
#define SRCSKIP (MANT_BITS - DSTBITS) // skip bits of source mantissa

	const u8* s;
	s32 exp;
	u32 sign, round;
	u64 nn;

	// source mantissa is equal to the destination
#if DSTBITS == MANT_BITS
	nn = *(const u64*)num->n;
	round = 0; // no rounding

	// source mantissa is shorter than destination
#elif DSTBITS > MANT_BITS
	int i;
	u8 *d;
	nn = 0;
	s = (const u8*)num->n;
	d = &((u8*)&nn)[DSTSKIP/8];
	for (i = (MANT_BITS+7)/8; i > 0; i--) *d++ = *s++;
//	memcpy(d, s, (MANT_BITS+7)/8);
	round = 0; // no rounding

#if (DSTSKIP & 7) != 0
	nn <<= (DSTSKIP & 7);
#endif

	// source mantissa is longer than destination
#else
	s = &((const u8*)num->n)[SRCSKIP/8];

#if (SRCSKIP & 7) == 0 // srcskip is never = 0
	round = (s[-1] >> 7) & 1;
#else
	round = (*s >> ((SRCSKIP-1) & 7)) & 1;
#endif

	memcpy(&nn, s, 8);

#if (SRCSKIP & 7) != 0
	nn >>= SRCSKIP & 7;
#endif

#endif

	// mask top bits of mantissa
	nn &= 0x000fffffffffffffULL; // clear exponent and sign

	// round
	if (round != 0)
	{
		round = 0;
		nn++; // increment mantissa
		if (nn > 0x000fffffffffffffULL) // round = carry to exponent
		{
			nn &= 0x000fffffffffffffULL; // clear carry
			nn >>= 1;
			round = 1;
		}
	}

	// get sign
	sign = REALNAME(GetSign)(num);

	// get exponent
	exp = REALNAME(GetExp)(num);

	// source number is zero
	if (exp == 0)
	{
		nn = (u64)sign << 63;
		return *(double*)&nn;
	}

	// overflow
	if (exp == EXP_INF)
	{
		nn = ((u64)sign << 63) | (0x7ffULL << 52);
		return *(double*)&nn;
	}

	// convert exponent bias
	exp -= EXP_BIAS;
	exp += 1023 + round;

	// underflow
	if (exp <= 0)
	{
		nn = (u64)sign << 63;
		return *(double*)&nn;
	}

	// overflow
	if (exp >= 0x7ffULL)
	{
		nn = ((u64)sign << 63) | (0x7ffULL << 52);
		return *(double*)&nn;
	}

	// set exponent
	nn = (u64)nn | ((u64)exp << 52) | ((u64)sign << 63);
	return *(double*)&nn;

#undef DSTBITS
#undef DSTSKIP
#undef SRCSKIP

#endif
}

//  Extended version uses exponent in packed form with sign in highest bit.
double REALNAME(ToDoubleExt)(const REAL* num, EXP exp)
{
#ifdef REALREF
	REALREF r;
	REALNAME(ExportRefExt)(num, exp, &r);
	return REALREFNAME(ToDouble)(&r);
#else // REALREF
	REAL r;
	REALNAME(Pack)(&r, num, exp);
	return REALNAME(ToDouble)(&r);
#endif // REALREF
}

// ---------------------------------------------------------------------------
//                  import number from reference real number
// ---------------------------------------------------------------------------

#ifdef REALREF
void REALNAME(ImportRef)(REAL* dst, const void* src)
{
	REALNAME(Import)(dst, (const REALREF*)src, REALREFNAME(RealBytes)(), REALREFNAME(ExpBits)());
}

// import extended number from extended reference real number
// - returns packed extended exponent with sign
EXP REALNAME(ImportRefExt2)(REAL* dst, const void* src, EXP exp)
{
	const REALREF* ref;
	const u8* s;
	u8 sign;

	ref = (const REALREF*)src;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// copy mantissa
	s = &((const u8*)ref)[sizeof(REALREF) - REAL_BYTES];
	memcpy(dst, s, REAL_BYTES);

	// round mantissa
	if ((exp > EXPEXT_0) && (exp < EXPEXT_INF) && ((s[-1] & 0x80) != 0))
	{
		// carry
		if (REALNAME(MantInc)(dst) != 0)
		{
			REALNAME(MantR1)(dst, 1);
			exp++;

			// overflow
			if (exp >= EXPEXT_INF)
			{
				REALNAME(SetInfExt)(dst);
				exp = EXPEXT_INF;
			}
		}
	}

	return exp | ((EXP)sign << EXPEXT_BITS);
}

// import extended number from normal reference real number
// - returns packed extended exponent with sign
EXP REALNAME(ImportRefExt)(REAL* dst, const void* src)
{
	REALREF ref;
	EXP exp;

	// unpack reference number
	exp = REALREFNAME(Unpack)((const REALREF*)src, &ref);

	// import number
	return REALNAME(ImportRefExt2)(dst, &ref, exp);
}

#endif // REALREF

// ---------------------------------------------------------------------------
//                 export number to reference real number
// ---------------------------------------------------------------------------

#ifdef REALREF
void REALNAME(ExportRef)(const REAL* src, void* dst)
{
	REALREFNAME(Import)((REALREF*)dst, src, REAL_BYTES, EXP_BITS);
}

// export extended number to normal reference real number
// - exponent can be in packed form, with sign in highest bit
void REALNAME(ExportRefExt)(const REAL* src, EXP exp, void* dst)
{
	// prepare number of lower bytes
	int i = sizeof(REALREF) - REAL_BYTES;

	// copy number to destination (reference number is always longer)
	memset(dst, 0, i); // clear lower bytes
	memcpy((u8*)dst + i, src, REAL_BYTES);

	// pack reference number
	REALREFNAME(Pack)((REALREF*)dst, (REALREF*)dst, exp);
}
#endif // REALREF

// ---------------------------------------------------------------------------
//                        export number to bigint
// ---------------------------------------------------------------------------

void REALNAME(ExportBigInt)(const REAL* num, bigint* dst)
{
	BASE* d;
	BASES shift;

	// zero or overflow
	if (REALNAME(IsZero)(num) || REALNAME(IsInf)(num) || (REALNAME(GetExp)(num) < EXP_1))
	{
		BigIntSet0(dst);
		return;
	}

	// allocate bigint buffer
	if (!BigIntSetSize(dst, (REAL_BYTES+BIGINT_BASE_BYTES-1)/BIGINT_BASE_BYTES)) return;

	// copy number
	memcpy(dst->data, num->n, REAL_BYTES);

	// mask last segment and restore last bit '1'
	d = (BASE*)dst->data;
	d[BASE_NUM-1] = (d[BASE_NUM-1] & MANT_LAST_MASK) | (MANT_LAST_MASK+1);

	// set sign
	dst->sign = REALNAME(IsNeg)(num);
	
	// shift bigint
	shift = REALNAME(GetExpS)(num) - MANT_BITS;
	if (shift > 0)
		BigIntLeft(dst, shift);
	else if (shift < 0)
		BigIntRight(dst, -shift);

	// reduce
	BigIntReduce(dst);
}

// ---------------------------------------------------------------------------
//                            import from bigint
// ---------------------------------------------------------------------------

void REALNAME(ImportBigInt)(REAL* num, const bigint* src)
{
	int bitlen, bytelen, srcoff, shift;
	BASES exps;

	// clear number
	REALNAME(Set0)(num);

	// zero
	if (BigIntIsZero(src)) return;

	// copy mantissa
	bitlen = BigIntBitLen(src); // length in bits
	bytelen = (bitlen + 7)/8; // length in bytes
	srcoff = 0;			// source offset
	if (bytelen > REAL_BYTES)
	{
		srcoff = bytelen - REAL_BYTES;
		bytelen = REAL_BYTES;
	}
	memcpy((u8*)&num->n[BASE_NUM] - bytelen, (u8*)src->data + srcoff, bytelen);

	// prepare exponent
	exps = bitlen - 1;

	// normalize mantissa
	bitlen = 8 - (((bitlen - 1) & 7) + 1); // free bits in last segment
	shift = EXP_BITS - bitlen;
	if (shift > 0)
		shift = REALNAME(MantR)(num, 0, shift);
	else if (shift < 0)
		REALNAME(MantL)(num, -shift);

	// rounding
	if (shift != 0)
	{
		REALNAME(MantInc)(num);
		if (REALNAME(GetExp)(num) > 1)
		{
			REALNAME(MantR1)(num, 0);
			exps++;
		}
	}

	// underflow
	if (exps <= -(BASES)EXP_BIAS)
	{
		REALNAME(Set0)(num);
		return;
	}

	// overflow
	if (exps >= (BASES)(EXP_MAX - EXP_BIAS))
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, src->sign);
		return;
	}

	// set exponent
	REALNAME(SetExpS)(num, exps);

	// set sign
	REALNAME(SetSign)(num, src->sign);
}

EXP REALNAME(ImportBigIntExt)(REAL* num, const bigint* src)
{
#ifdef REALREF
	REALREF tmp;
	REALREFNAME(ImportBigInt)(&tmp, src);
	return REALNAME(ImportRefExt)(num, &tmp);
#else // REALREF
	REALNAME(ImportBigInt)(num, src);
	return REALNAME(Unpack)(num, num);
#endif // REALREF
}

void REALNAME(ImportBigIntC)(REAL* num, const cbigint* src)
{
	bigint k;
	BigIntInit(&k);
	BigIntCopyC(&k, src);
	REALNAME(ImportBigInt)(num, &k);
	BigIntTerm(&k);
}

EXP REALNAME(ImportBigIntCExt)(REAL* num, const cbigint* src)
{
	EXP exp;
	bigint k;
	BigIntInit(&k);
	BigIntCopyC(&k, src);
	exp = REALNAME(ImportBigIntExt)(num, &k);
	BigIntTerm(&k);
	return exp;
}

// ---------------------------------------------------------------------------
//        generate test random number (noneg = no negative number)
// ---------------------------------------------------------------------------

// generate test random number (noneg = no negative number)
void REALNAME(TestRandom)(REAL* num, Bool noneg, BASE expmin, BASE expmax)
{
	BASE *d, exp;
	int i;

	// generate random exponent
#if BASE_BITS > 32
	exp = (BASE)RandU64MinMax(expmin, expmax);
#else
	exp = (BASE)RandU32MinMax(expmin, expmax);
#endif

	// zero
	if (exp == 0)
	{
		REALNAME(Set0)(num);
		if (!noneg && ((RandU8() & 1) != 0)) REALNAME(Neg)(num);
		return;
	}

	// infinity
	if (exp == EXP_INF)
	{
		REALNAME(SetInf)(num);
		if (!noneg && ((RandU8() & 1) != 0)) REALNAME(Neg)(num);
		return;
	}

	// fill mantissa with random pattern
	d = num->n;
	for (i = BASE_NUM; i > 0; i--)
	{
#if BASE_BITS == 8		// u8
		*d++ = RandU8();
#elif BASE_BITS == 16	// u16
		*d++ = RandU16();
#elif BASE_BITS == 32	// u32
		*d++ = RandU32();
#else					// u64
		*d++ = RandU64();
#endif
	}

	// no negative
	if (noneg) REALNAME(Abs)(num); // disable negative number

	// reset some bits
	i = RandU32Max(MANT_BITS);
	d = num->n;
	for (; i >= BASE_BITS; i -= BASE_BITS) *d++ = 0;
	if (i > 0) *d = *d & (BASE_MAX << i);

	// set exponent
	REALNAME(SetExp)(num, exp);
}

// Extended version returns exponent in packed form with sign in highest bit.
EXP REALNAME(TestRandomExt)(REAL* num, Bool noneg, EXP expmin, EXP expmax)
{
	BASE *d;
	int i;
	EXP exp;
	EXP sign;

	// generate random exponent
#if EXPEXT_BITS > 31
	exp = (EXP)RandU64MinMax(expmin, expmax);
#else
	exp = (EXP)RandU32MinMax(expmin, expmax);
#endif

	// sign
	sign = 0;
	if (!noneg) sign = (EXP)(RandU8() & 1) << EXPEXT_BITS;

	// zero
	if (exp == EXPEXT_0)
	{
		REALNAME(Set0Ext)(num);
		return exp | sign;
	}

	// infinity
	if (exp == EXPEXT_INF)
	{
		REALNAME(SetInfExt)(num);
		return exp | sign;
	}

	// fill mantissa with random pattern
	d = num->n;
	for (i = BASE_NUM; i > 0; i--)
	{
#if BASE_BITS == 8		// u8
		*d++ = RandU8();
#elif BASE_BITS == 16	// u16
		*d++ = RandU16();
#elif BASE_BITS == 32	// u32
		*d++ = RandU32();
#else					// u64
		*d++ = RandU64();
#endif
	}

	// set hidden bit '1'
	d--;
	*d |= BASE_LAST;

	// reset some bits (except hidden bit '1')
	i = (int)RandU32Max(REAL_BITS-1);
	d = num->n;
	for (; i >= BASE_BITS; i -= BASE_BITS) *d++ = 0;
	if (i > 0) *d = *d & (BASE_MAX << i);

	return exp | sign;
}

// ===========================================================================
//                       Arithmetics operations
// ===========================================================================
// Destination and source can be the same register.

// ---------------------------------------------------------------------------
//                        add/sub 2 numbers
// ---------------------------------------------------------------------------
//  Function uses 2 temporary numbers in the stack.

void REALNAME(AddSub)(REAL* num, const REAL* num1, const REAL* num2, Bool sub)
{
	REAL tmp1, tmp2; // requires 2 temporary numbers in the stack
	BASE exp1, exp2;
	u8 sign1, sign2, carry, roundcarry;
	int i;

	// load exponents
	exp1 = REALNAME(GetExp)(num1);
	exp2 = REALNAME(GetExp)(num2);

	// 1st operand is zero, copy 2nd operand to result
	if (exp1 == EXP_0)
	{
		REALNAME(Copy)(num, num2);
		if (sub) REALNAME(Neg)(num);
		return;
	}

	// 2nd operand is zero, copy 1st operand to result
	if (exp2 == EXP_0)
	{
		REALNAME(Copy)(num, num1);
		return;
	}

	// load signs
	sign1 = REALNAME(GetSign)(num1);
	sign2 = REALNAME(GetSign)(num2);
	if (sub) sign2 ^= 1;

	// some operand is infinity, result will be infinity or 0
	if ((exp1 == EXP_INF) || (exp2 == EXP_INF))
	{
		REALNAME(SetInf)(num);
		if ((exp1 == exp2) && (sign1 != sign2)) REALNAME(Set0)(num);
		return;
	}

	// load operands with sorting order, 1st operand must have exponent >= 2nd one
	if (exp1 >= exp2)
	{
		REALNAME(Copy)(&tmp1, num1);
		REALNAME(Copy)(&tmp2, num2);
	}
	else
	{
		REALNAME(Copy)(&tmp1, num2);
		REALNAME(Copy)(&tmp2, num1);
		exp1 ^= exp2; exp2 ^= exp1; exp1 ^= exp2; // exchange exponents
		sign1 ^= sign2; sign2 ^= sign1; sign1 ^= sign2; // exchange signs
	}

	// difference of exponents
	exp2 = exp1 - exp2;

	// difference is too high - only 1st number left
	if (exp2 > MANT_BITS)
	{
		REALNAME(Copy)(num, &tmp1);
		REALNAME(SetSign)(num, sign1);
		return;
	}

	// denormalize mantissas (clear exponent and set hidden bit '1')
	REALNAME(Denorm)(&tmp1);
	REALNAME(Denorm)(&tmp2);

	// negate mantissas
	if (sign1) REALNAME(MantNeg)(&tmp1);
	if (sign2) REALNAME(MantNeg)(&tmp2);

	// shift 2nd number right to normalize numbers to the same exponent
	roundcarry = REALNAME(MantR)(&tmp2, sign2, (int)exp2);

	// add numbers (including last carry from the shift = rounding)
	REALNAME(MantAdd)(&tmp1, &tmp2, roundcarry);

	// get sign of result, absolute value of result
	sign1 = REALNAME(GetSign)(&tmp1);
	if (sign1) REALNAME(MantNeg)(&tmp1);

	// overflow mantissa
	if (REALNAME(GetExp)(&tmp1) > 1)
	{
		carry = (u8)REALNAME(MantR1)(&tmp1, 0); // shift result right
		exp1++; // exponent correction
		if (exp1 >= EXP_MAX) // overflow
		{
			REALNAME(SetInf)(num);
			REALNAME(SetSign)(num, sign1);
			return;
		}
		if ((carry != 0) && (roundcarry == 0)) REALNAME(MantInc)(&tmp1); // rounding (result cannot overflow at this place)
		// - do not do both at the same time: shift carry + round carry
	}

	// normalize mantissa
	i = REALNAME(MantNorm)(&tmp1);

	// mantissa is zero
	if ((i > MANT_BITS) || (exp1 < (BASE)i))
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign1);
		return;
	}

	// set exponent and sign
	exp1 -= i;
	REALNAME(SetExp)(&tmp1, exp1);
	REALNAME(SetSign)(&tmp1, sign1);

	// save result
	REALNAME(Copy)(num, &tmp1);
}

//  Function uses 1 temporary number in the stack.
//  Exponents are in packed form with sign in highest bit
EXP REALNAME(AddExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2)
{
	REAL tmp;
	const REAL* t1;
	const REAL* t2;
	u8 carry, roundcarry, sign1, sign2;
	int i;
	EXP ex1, ex2;
	EXPS exps;

	// 1st operand is zero, copy 2nd operand to result
	ex1 = exp1 & EXPEXT_MASK;
	if (ex1 == EXPEXT_0)
	{
		REALNAME(Copy)(num, num2);
		return exp2;
	}

	// 2nd operand is zero, copy 1st operand to result
	ex2 = exp2 & EXPEXT_MASK;
	if (ex2 == EXPEXT_0)
	{
		REALNAME(Copy)(num, num1);
		return exp1;
	}

	// unpack signs
	sign1 = (u8)(exp1 >> EXPEXT_BITS);
	sign2 = (u8)(exp2 >> EXPEXT_BITS);

	// some operand is infinity, result will be infinity or 0
	if ((ex1 == EXPEXT_INF) || (ex2 == EXPEXT_INF))
	{
		if ((ex1 == ex2) && (sign1 != sign2))
		{
			REALNAME(Set0Ext)(num);
			return EXPEXT_0;
		}
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)((ex1 == EXPEXT_INF) ? sign1 : sign2) << EXPEXT_BITS);
	}

	// difference of exponents
	exps = ex1 - ex2;

	// load operands with sorting order, 1st operand must have exponent >= 2nd one (2nd operand will be shifted)
	if (exps >= 0) // ex1 >= ex2
	{
		t1 = num1;

		// exponents are identical
		if (exps == 0) // ex1 == ex2
		{
			t2 = num2;
			roundcarry = 0;
		}
		else
		{
			// difference is too high - only 1st number left
			if (exps >= REAL_BITS)
			{
				REALNAME(Copy)(num, num1);
				return exp1;
			}

			// copy num2 into temporary register (it need to be shifted)
			REALNAME(Copy)(&tmp, num2);
			t2 = &tmp;
		}
	}
	else // ex2 > ex1
	{
		// exps = ex2 - ex1
		exps = -exps;

		// difference is too high - only 2nd number left
		if (exps >= REAL_BITS)
		{
			REALNAME(Copy)(num, num2);
			return exp2;
		}

		// copy num1 into temporary register (it need to be shifted)
		REALNAME(Copy)(&tmp, num1);
		t1 = num2;
		t2 = &tmp;
		ex1 = ex2; // exponent of num2 will be the result exponent
		sign1 ^= sign2; sign2 ^= sign1; sign1 ^= sign2; // exchange signs
	}

	// shift 2nd number right to normalize numbers to the same exponent
	if (exps > 0) roundcarry = REALNAME(MantR)(&tmp, False, (int)exps);

	// add numbers (including last carry from the shift = rounding)
	if (sign1 == sign2)
	{
		// both numbers are equally positive or negative
		carry = (u8)REALNAME(MantAddFrom)(num, t1, t2, (BASE)roundcarry);

		// overflow (note: sign will stay unchanged)
		if (carry)
		{
			// shift mantissa right (returns rounding carry bit from lowest bit)
			carry = (u8)REALNAME(MantR1)(num, 1);
			ex1++;

			// check overflow
			if (ex1 >= EXPEXT_MAX)
			{
				REALNAME(SetInfExt)(num);
				return EXPEXT_INF | ((EXP)sign1 << EXPEXT_BITS);
			}

			// round mantissa
			if ((carry != 0) && (roundcarry == 0)) REALNAME(MantInc)(num); // rounding (result cannot overflow at this place)
			// - do not do both at the same time: shift carry + round carry
		}
	}
	else
	{
		if (sign1 == 0)
			// 2nd number is negative, num = t1 - t2 - carry
			sign1 = (u8)REALNAME(MantSubFrom)(num, t1, t2, roundcarry);
		else
		{
			// 1st number is negative, num = t2 - t1 (without rounding carry)
			sign1 = (u8)REALNAME(MantSubFrom)(num, t2, t1, 0);

			// add rounding carry (can restore sign to positive if result is = 0)
			if (roundcarry) sign1 ^= REALNAME(MantInc)(num);
		}

		// absolute value of result if mantissa is negative
		if (sign1 != 0) REALNAME(MantNeg)(num);

		// normalize mantissa
		i = REALNAME(MantNormExt)(num);

		// mantissa is zero or exponent underflow
		if ((i >= REAL_BITS) || (ex1 < (EXP)i))
		{
			REALNAME(Set0Ext)(num);
			return EXPEXT_0 | ((EXP)sign1 << EXPEXT_BITS);
		}

		// shift exponent
		ex1 -= i;
	}

	// return exponent and sign
	return ex1 | ((EXP)sign1 << EXPEXT_BITS);
}

// ---------------------------------------------------------------------------
//       bitwise operation (oper = BITOPER_AND, BITOPER_OR, BITOPER_XOR)
// ---------------------------------------------------------------------------
//  Function uses 2 temporary numbers in the stack.

void REALNAME(Bit)(REAL* num, const REAL* num1, const REAL* num2, u8 oper)
{
	REAL tmp1, tmp2; // requires 2 temporary numbers in the stack
	BASE exp1, exp2;
	u8 sign1, sign2;
	int i;

	// load exponents
	exp1 = REALNAME(GetExp)(num1);
	exp2 = REALNAME(GetExp)(num2);

	// some operand is infinity, result will be infinity
	if ((exp1 == EXP_INF) || (exp2 == EXP_INF))
	{
		REALNAME(SetInf)(num);
		return;
	}

	// 1st operand is zero
	if (exp1 == 0)
	{
		if (oper == BITOPER_AND)
			REALNAME(Set0)(num);
		else
			REALNAME(Copy)(num, num2);
		return;
	}

	// 2nd operand is zero
	if (exp2 == 0)
	{
		if (oper == BITOPER_AND)
			REALNAME(Set0)(num);
		else
			REALNAME(Copy)(num, num1);
		return;
	}

	// load signs
	sign1 = REALNAME(GetSign)(num1);
	sign2 = REALNAME(GetSign)(num2);

	// load operands with sorting order, 1st operand must have exponent >= 2nd one
	if (exp1 >= exp2)
	{
		REALNAME(Copy)(&tmp1, num1);
		REALNAME(Copy)(&tmp2, num2);
	}
	else
	{
		REALNAME(Copy)(&tmp1, num2);
		REALNAME(Copy)(&tmp2, num1);
		exp1 ^= exp2; exp2 ^= exp1; exp1 ^= exp2; // exchange exponents
		sign1 ^= sign2; sign2 ^= sign1; sign1 ^= sign2; // exchange signs
	}

	// difference of exponents
	exp2 = exp1 - exp2;

	// difference is too high - limit it
	if (exp2 > MANT_BITS) exp2 = MANT_BITS + 1;

	// denormalize mantissas (clear exponent and set hidden bit '1')
	REALNAME(Denorm)(&tmp1);
	REALNAME(Denorm)(&tmp2);

	// negate mantissas
	if (sign1) REALNAME(MantNeg)(&tmp1);
	if (sign2) REALNAME(MantNeg)(&tmp2);

	// shift 2nd number right to normalize numbers to the same exponent
	REALNAME(MantR)(&tmp2, sign2, (int)exp2);

	// bit operation
	if (oper == BITOPER_AND) // &
		REALNAME(MantAnd)(&tmp1, &tmp2);
	else if (oper == BITOPER_OR) // |
		REALNAME(MantOr)(&tmp1, &tmp2);
	else // if (oper == BITOPER_XOR) // ^
		REALNAME(MantXor)(&tmp1, &tmp2);

	// get sign of result, absolute value of result
	sign1 = REALNAME(GetSign)(&tmp1);
	if (sign1) REALNAME(MantNeg)(&tmp1);

	// normalize mantissa
	i = REALNAME(MantNorm)(&tmp1);

	// mantissa is zero
	if ((i > MANT_BITS) || (exp1 < (BASE)i))
	{
		REALNAME(Set0)(num);
		return;
	}

	// set exponent and sign
	exp1 -= i;
	REALNAME(SetExp)(&tmp1, exp1);
	if (sign1 != 0) REALNAME(Neg)(&tmp1);

	// save result
	REALNAME(Copy)(num, &tmp1);
}

// ---------------------------------------------------------------------------
//                       multiply 2 numbers
// ---------------------------------------------------------------------------
//  Function uses 2 temporary numbers in the stack.

void REALNAME(Mul)(REAL* num, const REAL* num1, const REAL* num2)
{
	REAL tmp1, tmp2; // requires 2 temporary numbers in the stack
	BASE a, carry, *d, *s, exp1, exp2;
#if !ASM64 || ((REAL_BITS & 0xff) != 0)
	BASE rH, rL, b;
	BASEDBL k;
#endif
	s32 exps;
	u8 sign1, sign2, sign;
	int i, j;
	Bool round;

	// load exponents
	exp1 = REALNAME(GetExp)(num1);
	exp2 = REALNAME(GetExp)(num2);

	// load signs
	sign1 = REALNAME(GetSign)(num1);
	sign2 = REALNAME(GetSign)(num2);
	sign = sign1 ^ sign2;

	// some operand is infinity, result will be infinity
	if ((exp1 == EXP_INF) || (exp2 == EXP_INF))
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// some operand is zero, result will be zero
	if ((exp1 == EXP_0) || (exp2 == EXP_0))
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// load operands
	REALNAME(Copy)(&tmp1, num1);
	REALNAME(Copy)(&tmp2, num2);

	// denormalize mantissas (clear exponent and set hidden bit '1')
	REALNAME(Denorm)(&tmp1);
	REALNAME(Denorm)(&tmp2);

	// shift mantissas left (hidden bit '1' appears at the sign position)
	REALNAME(MantL)(&tmp1, EXP_BITS);
	REALNAME(MantL)(&tmp2, EXP_BITS);

	// clear result register (accumulator)
	REALNAME(Set0)(num);

	// multiply mantissas
	for (i = 0; i < BASE_NUM; i++)
	{
		// get next num1 segment
		a = tmp1.n[i];

		// multiply num2 by segment from num1 and add it to accumulator
		if (a != 0)
		{
			d = &num->n[0]; // result accumulator
			s = &tmp2.n[0]; // pointer to num2

			// mantissa is multiply of 256 bits (4x u64, 32 bytes)
#if ASM64 && ((REAL_BITS & 0xff) == 0)
			carry = (BASE)MulAddBig_x64(REAL_BITS/256, a, (u64*)d, (const u64*)s);

			d = &num->n[BASE_NUM-1];
			for (j = BASE_NUM; j > 0; j--)
			{
				a = *d;
				*d = carry;
				carry = a;
				d--;
			}

#else

			// multiply first segment
#if BASE_BITS == 16 // u16
			k = (u32)a * *s;
			rL = (u16)k;
			rH = (u16)(k >> 16);
#else // BASE_BITS == 32 // u32
			k = UMul(a, *s);
			rL = (u32)k;
			rH = (u32)(k >> 32);
#endif
			b = *d;
			rL += b;
			if (rL < b) rH++;

			carry = rH;
			s++;

			// multiply inner segments
			for (j = BASE_NUM-1; j > 0; j--)
			{
				// num1 * num2 -> rH:rL
#if BASE_BITS == 16 // u16
				k = (u32)a * *s;
				rL = (u16)k;
				rH = (u16)(k >> 16);
#else // BASE_BITS == 32 // u32
				k = UMul(a, *s);		// num1 * num2
				rL = (u32)k;			// result low -> rL
				rH = (u32)(k >> 32);	// result high -> rH
#endif
				// add carry from lower segment
				rL += carry;			// add carry from lower segment
				if (rL < carry) rH++;	// overflow? ... carry to higher segment

				// add result to destination accumulator num
				b = d[1];				// current destination segment
				rL += b;				// add destination segment to result
				*d = rL;				// save new low result
				if (rL < b) rH++;		// carry to high

				// carry to higher segment
				carry = rH;				// new carry to higher segment
				d++;
				s++;
			}

			// save last segment
			*d = rH;

#endif // ASM64

		}
		else
		{
			d = &num->n[BASE_NUM-2];
			carry = d[1];
			d[1] = 0;

			// shift accumulator 1 segment right (to lower bits)
			for (j = BASE_NUM-1; j > 0; j--)
			{
				a = *d;
				*d = carry;
				carry = a;
				d--;
			}
		}
	}

	// sum exponents
	exps = exp1 + exp2 + 1 - EXP_BIAS;

	// normalize mantissa
	if (REALNAME(IsNeg)(num)) // is hidden bit '1' on highest bit 31?
	{
		// shift back to normal position (hidden bit '1' will stay in exponent position)
		round = REALNAME(MantR)(num, 0, EXP_BITS);
	}
	else // hidden bit '1' is on the prepending bit 30
	{
		// move back 1 position less
		exps--;
		round = REALNAME(MantR)(num, 0, EXP_BITS-1);
	}

	// round result
	if (round)
	{
		// increment mantissa
		REALNAME(MantInc)(num);

		// check overflow - if so, hidden bit '1' (on exponent position) will change to '2'
		if (REALNAME(GetExp)(num) > 1) // get hidden bit - is it '2' ?
		{
			// shift mantissa 1 bit right
			REALNAME(MantR1)(num, 0);
			exps++;
		}
	}

	// result is too small
	if (exps <= EXP_0)
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// result is too high
	if (exps >= EXP_MAX)
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// set exponent
	REALNAME(SetExp)(num, (BASE)exps);

	// set result sign
	REALNAME(SetSign)(num, sign);
}

// Extended mul
//  Function uses 1 temporary number in the stack.
//  Exponents are in packed form with sign in highest bit
EXP REALNAME(MulExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2)
{
	REAL tmp;
	REAL *d0;
	BASE a, carry, sticky, *d;
	const BASE* s;
#if !ASM64 || ((REAL_BITS & 0xff) != 0)
	BASE rH, rL, b;
	BASEDBL k;
#endif
	EXPS exps;
	u8 sign1, sign2, sign;
	int i, j;
	Bool usetmp;

	// unpack exponents
	sign1 = (u8)(exp1 >> EXPEXT_BITS);
	exp1 &= EXPEXT_MASK;
	sign2 = (u8)(exp2 >> EXPEXT_BITS);
	exp2 &= EXPEXT_MASK;
	sign = sign1 ^ sign2;

	// some operand is infinity, result will be infinity
	if ((exp1 >= EXPEXT_INF) || (exp2 >= EXPEXT_INF))
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// some operand is zero, result will be zero
	if ((exp1 == EXPEXT_0) || (exp2 == EXPEXT_0))
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0 | ((EXP)sign << EXPEXT_BITS);
	}

	// prepare destination pointer
	d0 = num;
	usetmp = (num == num1) || (num == num2);
	if (usetmp) d0 = &tmp;

	// clear result register (accumulator)
	REALNAME(Set0Ext)(d0);

	// multiply mantissas
	for (i = 0; i < BASE_NUM; i++)
	{
		// get next num1 segment
		a = num1->n[i];

		// multiply num2 by segment from num1 and add it to accumulator
		if (a != 0)
		{
			d = d0->n; // result accumulator
			s = num2->n; // pointer to num2

			// mantissa is multiply of 256 bits (4x u64, 32 bytes)
#if ASM64 && ((REAL_BITS & 0xff) == 0)
			carry = (BASE)MulAddBig_x64(REAL_BITS/256, a, (u64*)d, (const u64*)s);

			d = &d0->n[BASE_NUM-1];
			for (j = BASE_NUM; j > 0; j--)
			{
				a = *d;
				*d = carry;
				carry = a;
				d--;
			}
			sticky = carry;
#else

			// multiply first segment
#if BASE_BITS == 16 // u16
			k = (u32)a * *s;
			rL = (u16)k;
			rH = (u16)(k >> 16);
#else // BASE_BITS == 32 // u32
			k = UMul(a, *s);
			rL = (u32)k;
			rH = (u32)(k >> 32);
#endif
			b = *d;
			rL += b;
			if (rL < b) rH++;

			sticky = rL;
			carry = rH;
			s++;

			// multiply inner segments
			for (j = BASE_NUM-1; j > 0; j--)
			{
				// num1 * num2 -> rH:rL
#if BASE_BITS == 16 // u16
				k = (u32)a * *s;
				rL = (u16)k;
				rH = (u16)(k >> 16);
#else // BASE_BITS == 32 // u32
				k = UMul(a, *s);		// num1 * num2
				rL = (u32)k;			// result low -> rL
				rH = (u32)(k >> 32);	// result high -> rH
#endif
				// add carry from lower segment
				rL += carry;			// add carry from lower segment
				if (rL < carry) rH++;	// overflow? ... carry to higher segment

				// add result to destination accumulator num
				b = d[1];				// current destination segment
				rL += b;				// add destination segment to result
				*d = rL;				// save new low result
				if (rL < b) rH++;		// carry to high

				// carry to higher segment
				carry = rH;				// new carry to higher segment
				d++;
				s++;
			}

			// save last segment
			*d = rH;

#endif // ASM64

		}
		else
		{
			d = &d0->n[BASE_NUM-2];
			carry = d[1];
			d[1] = 0;

			// shift accumulator 1 segment right (to lower bits)
			for (j = BASE_NUM-1; j > 0; j--)
			{
				a = *d;
				*d = carry;
				carry = a;
				d--;
			}
			sticky = carry;
		}
	}

	// sum exponents
	exps = exp1 + exp2 + 1 - EXPEXT_BIAS;

	// normalize mantissa
	//  minimal value: 0x8000... * 0x8000... -> 0x4000...
	//  maximal value: 0xFFFF... * 0xFFFF... -> 0xFFFF...
	if ((BASES)d0->n[BASE_NUM-1] >= 0) // if highest is not set, number is not normalized
	{
		REALNAME(MantL1)(d0, sticky >> (BASE_BITS-1));
		exps--;
		sticky <<= 1;
	}

	// round result from sticky bits
	if ((BASES)sticky < 0)
	{
		// increment mantissa
		if (REALNAME(MantInc)(d0))
		{
			// overflow, shift mantissa 1 bit right
			REALNAME(MantR1)(d0, 1);
			exps++;
		}
		else
		{
			// round to even mantissa
			if ((sticky << 1) == 0) d0->n[0] &= (BASE)~1;
		}
	}

	// result is too small
	if (exps <= EXPEXT_0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0 | ((EXP)sign << EXPEXT_BITS);
	}

	// result is too high
	if (exps >= EXPEXT_MAX)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// copy result
	if (usetmp) REALNAME(Copy)(num, d0);

	return (EXP)exps | ((EXP)sign << EXPEXT_BITS);
}

// ---------------------------------------------------------------------------
//              multiply by unsigned integer number u16 or u32
// ---------------------------------------------------------------------------

void REALNAME(MulUInt)(REAL* num, const REAL* src, BASE n)
{
	u8 sign;//, round;
	BASE exp, a, carry, *d;
	BASEDBL b;
	s32 exps;
	int i, bits, shift;
	const BASE* s;

	// load exponent
	exp = REALNAME(GetExp)(src);

	// get sign
	sign = REALNAME(GetSign)(src);

	// this number is overflow or zero, or number is 1
	if ((exp == EXP_INF) || (exp == EXP_0) || (n == 1))
	{
		REALNAME(Copy)(num, src);
		return;
	}

	// number is zero
	if (n == 0)
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// multiply lower segments
	carry = 0;
	s = src->n;
	d = num->n;
	for (i = BASE_NUM - 1; i > 0; i--)
	{
#if BASE_BITS == 16 // u16
		b = (u32)n * *s + carry;
#else // BASE_BITS == 32 // u32
		b = UMul(n, *s) + carry;
#endif
		*d = (BASE)b;
		carry = (BASE)(b >> BASE_BITS);
		s++;
		d++;
	}

	// prepare last segment
	a = *s; // load last segment
	a <<= EXP_BITS+1; // clear exponent bits and sign
	a >>= EXP_BITS+1; // return position
	a |= (BASE)1 << MANT_LAST_BITS; // restore hidden bit '1'

	// multiply last segment
#if BASE_BITS == 16 // u16
	b = (u32)n * a + carry;
#else // BASE_BITS == 32 // u32
	b = UMul(n, a) + carry;
#endif
	a = (BASE)b;
	*d = a;
	carry = (BASE)(b >> BASE_BITS);

	// prepare number of bits in last segment with carry
	if (carry != 0)
		bits = 32 - clz(carry) + BASE_BITS;
	else
		bits = 32 - clz(a);

	// shift carry to mantissa
	shift = bits - (MANT_LAST_BITS+1);
	/*round =*/ REALNAME(MantR)(num, 0, shift);
	carry <<= BASE_BITS - shift;
	*d |= carry;

/*
	// ... do not round - conversion to text would not work properly
	if (round)
	{
		// increment mantissa
		if (REALNAME(MantInc)(num))
		{
			// overflow, shift mantissa 1 bit right
			REALNAME(MantR1)(num, 1);
			exp++;
		}
	}
*/

	// prepare exponent
	exps = exp + shift;
	if (exps >= EXP_MAX)
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// set exponent
	REALNAME(SetExp)(num, (BASE)exps);

	// set result sign
	REALNAME(SetSign)(num, sign);
}

// Extended multiply by integer
//  Exponents are in packed form with sign in highest bit
EXP REALNAME(MulUIntExt)(REAL* num, const REAL* src, EXP exp, BASE n)
{
	u8 sign; //, round;
	BASE carry, *d;
	BASEDBL b;
	EXPS exps;
	int i, bits;
	const BASE* s;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exps = (EXPS)(exp & EXPEXT_MASK);

	// this number is overflow or zero, or number is 1
	if ((exps == (EXPS)EXPEXT_INF) || (exps == (EXPS)EXPEXT_0) || (n == 1))
	{
		REALNAME(Copy)(num, src);
		return exp;
	}

	// number is zero
	if (n == 0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0 | ((EXP)sign << EXPEXT_BITS);
	}

	// multiply segments
	carry = 0;
	s = src->n;
	d = num->n;
	for (i = BASE_NUM; i > 0; i--)
	{
#if BASE_BITS == 16 // u16
		b = (u32)n * *s + carry;
#else // BASE_BITS == 32 // u32
		b = UMul(n, *s) + carry;
#endif
		*d = (BASE)b;
		carry = (BASE)(b >> BASE_BITS);
		s++;
		d++;
	}

	// prepare number of bits to shift
	bits = 32 - clz(carry);

	// shift carry to mantissa
	/*round =*/ REALNAME(MantR)(num, 0, bits);
	d[-1] |= (carry << (BASE_BITS - bits));

/*
	// ... do not round - conversion to text would not work properly
	if (round)
	{
		// increment mantissa
		if (REALNAME(MantInc)(num))
		{
			// overflow, shift mantissa 1 bit right
			REALNAME(MantR1)(num, 1);
			exps++;
		}
	}
*/

	// prepare exponent
	exps = exps + bits;
	if (exps >= EXPEXT_MAX)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	return (EXP)exps | ((EXP)sign << EXPEXT_BITS);
}

// ---------------------------------------------------------------------------
//                 multiply by signed integer number
// ---------------------------------------------------------------------------

void REALNAME(MulSInt)(REAL* num, const REAL* src, BASES n)
{
	if (n < 0)
	{
		REALNAME(MulUInt)(num, src, -n);
		REALNAME(Neg)(num);
	}
	else
		REALNAME(MulUInt)(num, src, n);
}

//  Exponents are in packed form with sign in highest bit
EXP REALNAME(MulSIntExt)(REAL* num, const REAL* src, EXP exp, BASES n)
{
	if (n < 0) return REALNAME(MulUIntExt)(num, src, exp, -n) ^ EXPEXT_SIGN;
	return REALNAME(MulUIntExt)(num, src, exp, n);
}

// ---------------------------------------------------------------------------
//                           divide 2 numbers
// ---------------------------------------------------------------------------
//  Function uses 2 temporary numbers in the stack.

void REALNAME(Div)(REAL* num, const REAL* num1, const REAL* num2)
{
	REAL tmp1, tmp2; // requires 2 temporary numbers in the stack
	u8 sign1, sign2, sign;
	s8 carry;
	int i;
	BASE exp1, exp2;
	s32 exps;

	// load exponents
	exp1 = REALNAME(GetExp)(num1);
	exp2 = REALNAME(GetExp)(num2);

	// load signs
	sign1 = REALNAME(GetSign)(num1);
	sign2 = REALNAME(GetSign)(num2);
	sign = sign1 ^ sign2;

	// 1st operand is infinity or 2nd one is zero, result will be infinity
	if ((exp1 == EXP_INF) || (exp2 == EXP_0))
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// 1st operand is zero or 2nd one is infinity, result will be zero
	if ((exp1 == EXP_0) || (exp2 == EXP_INF))
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// load operands
	REALNAME(Copy)(&tmp1, num1);
	REALNAME(Copy)(&tmp2, num2);

	// denormalize mantissas (clear exponent and set hidden bit '1')
	REALNAME(Denorm)(&tmp1);
	REALNAME(Denorm)(&tmp2);

	// clear result register (accumulator)
	REALNAME(Set0)(num);

	// divide mantissas
	for (i = MANT_BITS+1; i > 0; i--)
	{
		carry = 0;
		if (REALNAME(MantComp)(&tmp1, &tmp2) >= 0)
		{
			REALNAME(MantSub)(&tmp1, &tmp2, 0);
			carry = 1;
		}

		// add result bit to accumulator
		REALNAME(MantL1)(num, carry);

		// shift dividend left
		REALNAME(MantL1)(&tmp1, 0);
	}

	// result exponents
	exps = exp1 - exp2 + EXP_BIAS;

	// normalize mantissa if result is too small
	if (REALNAME(GetExp)(num) == 0)
	{
		carry = 0;
		if (REALNAME(MantComp)(&tmp1, &tmp2) >= 0)
		{
			REALNAME(MantSub)(&tmp1, &tmp2, 0);
			carry = 1;
		}

		// shift mantissa left
		REALNAME(MantL1)(num, carry);
		exps--;

		// shift dividend left
		REALNAME(MantL1)(&tmp1, 0);
	}

	carry = (REALNAME(MantComp)(&tmp1, &tmp2) >= 0) ? 1 : 0;

	// round mantissa
	if (carry)
	{
		REALNAME(MantInc)(num);
		if (REALNAME(GetExp)(num) > 1) // carry
		{
			REALNAME(MantR1)(num, 0);
			exps++;
		}
	}

	// result is too small
	if (exps <= 0)
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// result is too high
	if (exps >= EXP_MAX)
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// set exponent
	REALNAME(SetExp)(num, (BASE)exps);

	// set result sign
	REALNAME(SetSign)(num, sign);
}

// Extended divide
//  Function uses 2 temporary numbers in the stack.
//  Exponents are in packed form with sign in highest bit
EXP REALNAME(DivExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2)
{
	REAL tmp1, tmp, *d0;
	u8 sign1, sign2, sign;
	int i;
	EXPS exps;
	Bool usetmp;
	BASE mask, *d;

	// unpack exponents
	sign1 = (u8)(exp1 >> EXPEXT_BITS);
	exp1 &= EXPEXT_MASK;
	sign2 = (u8)(exp2 >> EXPEXT_BITS);
	exp2 &= EXPEXT_MASK;
	sign = sign1 ^ sign2;

	// 1st operand is infinity or 2nd one is zero, result will be infinity
	if ((exp1 == EXPEXT_INF) || (exp2 == EXPEXT_0))
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// 1st operand is zero or 2nd one is infinity, result will be zero
	if ((exp1 == EXPEXT_0) || (exp2 == EXPEXT_INF))
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0 | ((EXP)sign << EXPEXT_BITS);
	}

	// prepare result exponent
	exps = exp1 - exp2 + EXPEXT_BIAS - 1;

	// load 1st operand
	REALNAME(Copy)(&tmp1, num1);

	// prepare destination
	d0 = num;
	usetmp = (num == num2);
	if (usetmp) d0 = &tmp;

	// clear result register (accumulator)
	REALNAME(Set0Ext)(d0);

	// prepare destination - pointer to highest bit
	mask = BASE_LAST;
	d = &d0->n[BASE_NUM-1];

	// get first bit
	if (REALNAME(MantComp)(&tmp1, num2) >= 0)
	{
		// first bit is set
		REALNAME(MantSub)(&tmp1, num2, 0);
		exps++;
		*d = mask;

		// shift pointer
		mask >>= 1;
	}

	// get rest of bits
	for (i = BASE_NUM; i > 0; i--)
	{
		do {
			// shift dividend left
			if ((REALNAME(MantL1)(&tmp1, 0) != 0) ||
				(REALNAME(MantComp)(&tmp1, num2) >= 0))
			{
				// subtract divisor and set result bit to accumulator
				REALNAME(MantSub)(&tmp1, num2, 0);
				*d |= mask;
			}

			// shift pointer
			mask >>= 1;
		} while (mask != 0);

		// shift pointer
		d--;
		mask = BASE_LAST;
	}

	// get next bit and round mantissa
	if ((REALNAME(MantL1)(&tmp1, 0) != 0) ||
		(REALNAME(MantComp)(&tmp1, num2) >= 0))
	{
		if (REALNAME(MantInc)(d0) != 0) // carry
		{
			REALNAME(MantR1)(d0, 1);
			exps++;
		}
	}

	// result is too small
	if (exps <= EXPEXT_0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0 | ((EXP)sign << EXPEXT_BITS);
	}

	// result is too high
	if (exps >= EXPEXT_MAX)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// copy result
	if (usetmp) REALNAME(Copy)(num, d0);

	return (EXP)exps | ((EXP)sign << EXPEXT_BITS);
}

// ---------------------------------------------------------------------------
//                       divide by u16 integer number
// ---------------------------------------------------------------------------

void REALNAME(DivU16)(REAL* num, const REAL* src, u16 n)
{
	u8 sign;
	BASE exp;
	int i, bits;
	u16 a, *s, *d;
	u32 carry;

	// load exponent
	exp = REALNAME(GetExp)(src);

	// load sign
	sign = REALNAME(GetSign)(src);

	// this number is infinity or zero, or number is 1
	if ((exp == EXP_INF) || (exp == EXP_0) || (n == 1))
	{
		REALNAME(Copy)(num, src);
		return;
	}

	// number is zero
	if (n == 0)
	{
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// prepare pointers
	d = (u16*)&num->n[BASE_NUM]; // destination pointer
	s = (u16*)&src->n[BASE_NUM]; // source pointer
	bits = EXP_BITS+1; // top bits to skip

	// divide
	carry = 0;
	for (i = BASE_NUM*BASE_BITS/16; i > 0; i--)
	{
		// load next segment
		d--;
		s--;
		a = *s;

		// clear bits with exponent (and set hidden bit '1')
		if (bits >= 16)
		{
			a = 0;
			bits -= 16;
			if (bits == 0) a = 1;
		}
		else if (bits > 0)
		{
			a &= ~(0xffff << (16 - bits));
			a |= 1 << (16 - bits);
			bits = 0;
		}

		// divide segment
		*d = (u16)(DivModU32(a + (carry << 16), (u32)n, &carry));
	}

	// get carry segment (= u16 segment below lowest segment)
	carry = ((u32)carry << 16)/(u32)n;

	// normalize mantissa
	bits = REALNAME(MantNorm)(num);

	// mantissa is zero (exponent 0 is allowed for now - it can be incremented when rounding)
	if ((bits > MANT_BITS) || (exp < (BASE)bits))
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// shift exponent
	exp -= bits;

	// add carry
	if ((bits > 0) && (bits <= 16))
	{
		*d |= (u16)(carry >> (16 - bits));

		// rounding
		if ((bits < 16) && ((carry & (1 << (15 - bits))) != 0))
		{
			REALNAME(MantInc)(num);
			if (REALNAME(GetExp)(num) > 1)
			{
				REALNAME(MantR1)(num, 0);
				exp++; // cannot overflow
			}
		}
	}

	// underflow
	if (exp == 0)
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// set exponent and sign
	REALNAME(SetExp)(num, exp);
	REALNAME(SetSign)(num, sign);
}

// Extended divide by integer
//  Exponents are in packed form with sign in highest bit
EXP REALNAME(DivU16Ext)(REAL* num, const REAL* src, EXP exp, u16 n)
{
	u8 sign;
	EXPS exps;
	int i, bits;
	u16 a, *d;
	const u16* s;
	u32 carry;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exps = (EXPS)(exp & EXPEXT_MASK);

	// this number is infinity or zero, or number is 1
	if ((exps == (EXPS)EXPEXT_INF) || (exps == (EXPS)EXPEXT_0) || (n == 1))
	{
		REALNAME(Copy)(num, src);
		return exp;
	}

	// number is zero
	if (n == 0)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// prepare pointers
	d = (u16*)&num->n[BASE_NUM]; // destination pointer
	s = (const u16*)&src->n[BASE_NUM]; // source pointer

	// divide
	carry = 0;
	for (i = REAL_BITS/16; i > 0; i--)
	{
		// load next segment
		d--;
		s--;
		a = *s;

		// divide segment
		*d = (u16)(DivModU32(a + (carry << 16), (u32)n, &carry));
	}

	// get carry segment (= u16 segment below lowest segment)
	carry = ((u32)carry << 16)/(u32)n;

	// normalize mantissa
	bits = REALNAME(MantNormExt)(num);

	// mantissa is zero (exponent 0 is allowed for now - it can be incremented when rounding)
	if ((bits >= REAL_BITS) || (exps < (EXPS)bits))
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0 | ((EXP)sign << EXPEXT_BITS);
	}

	// shift exponent
	exps -= bits;

	// add carry
	if ((bits > 0) && (bits <= 16))
	{
		*d |= (u16)(carry >> (16 - bits));

		// rounding
		if ((bits < 16) && ((carry & (1 << (15 - bits))) != 0))
		{
			if (REALNAME(MantInc)(num))
			{
				REALNAME(MantR1)(num, 1);
				exps++; // cannot overflow
			}
		}
	}

	// underflow
	if (exps == EXPEXT_0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0 | ((EXP)sign << EXPEXT_BITS);
	}

	return (EXP)exps | ((EXP)sign << EXPEXT_BITS);
}

// ---------------------------------------------------------------------------
//                 divide by s16 integer number
// ---------------------------------------------------------------------------

void REALNAME(DivS16)(REAL* num, const REAL* src, s16 n)
{
	if (n < 0)
	{
		REALNAME(DivU16)(num, src, -n);
		REALNAME(Neg)(num);
	}
	else
		REALNAME(DivU16)(num, src, n);
}

//  Exponents are in packed form with sign in highest bit
EXP REALNAME(DivS16Ext)(REAL* num, const REAL* src, EXP exp, s16 n)
{
	if (n < 0) return REALNAME(DivU16Ext)(num, src, exp, -n) ^ EXPEXT_SIGN;
	return REALNAME(DivU16Ext)(num, src, exp, n);
}

// ---------------------------------------------------------------------------
//        multiply by integer power of 2 (bit shift left or right)
// ---------------------------------------------------------------------------

void REALNAME(Pow2)(REAL* num, int pow2)
{
	BASE exp;
	BASES exps;
	u8 sign;

	// get exponent
	exp = REALNAME(GetExp)(num);

	// zero or infinity
	if ((exp == 0) || (exp == EXP_INF) || (pow2 == 0)) return;

	// shift exponent
	exps = (BASES)(exp + pow2);

	// underflow
	if (exps <= 0)
	{
		sign = REALNAME(GetSign)(num);
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// overflow
	if (exps >= (BASES)EXP_MAX)
	{
		sign = REALNAME(GetSign)(num);
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// set exponent
	REALNAME(SetExp)(num, (BASE)exps);	
}

//  Extended version uses exponent in packed form with sign in highest bit.
EXP REALNAME(Pow2Ext)(REAL* num, EXP exp, int pow2)
{
	EXPS exps;
	EXP ex;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	ex = exp & EXPEXT_MASK;

	// zero or infinity, no change
	if ((ex == EXPEXT_0) || (ex == EXPEXT_INF) || (pow2 == 0)) return exp;

	// shift exponent
	exps = (EXPS)(ex + pow2);

	// underflow
	if (exps <= (EXPS)EXPEXT_0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0 | ((EXP)sign << EXPEXT_BITS);;
	}

	// overflow
	if (exps >= (EXPS)EXPEXT_MAX)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	return (EXP)exps | ((EXP)sign << EXPEXT_BITS);;
}

// ---------------------------------------------------------------------------
//                    power of 2 numbers (y = base^exp)
// ---------------------------------------------------------------------------
//  Function uses 7 temporary numbers in the stack.

void REALNAME(Pow)(REAL* num, const REAL* base, const REAL* exp)
{
	REAL e;
	Bool sign;

	// get exponent
	REALNAME(Copy)(&e, exp); // get exponent

	// prepare result sign
	sign = REALNAME(IsNeg)(base); // base is negative
	if (sign)
	{
		// if exponent is not integer - error (base cannot be negative)
		if (!REALNAME(IsInt)(exp))
		{
			REALNAME(SetInf)(num);
			return;
		}

		// exponent is integer, check if exponent is odd
		REALNAME(Div2)(&e); // divide exponent number by 2
		if (REALNAME(IsInt)(&e)) sign = False; // exponent is even, result will be positive
		REALNAME(Copy)(&e, exp); // get exponent again
	}

	// get base
	REALNAME(Copy)(num, base); // get base
	REALNAME(Abs)(num); // absolute value of base

	// exponent is 0, result will be 1
	if (REALNAME(IsZero)(exp))
	{
		REALNAME(Set1)(num);
		return;
	}

	// exponent is 1, base not changed
	if (REALNAME(CompEps)(exp, &REALNAME(Const1), 4))
	{
		REALNAME(SetSign)(num, sign);
		return;
	}

	// exponent is -1, reciprocal value
	if (REALNAME(CompEps)(exp, &REALNAME(ConstM1), 4))
	{
		REALNAME(Rec)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// base is 1, result will be +-1
	if (REALNAME(CompEps)(num, &REALNAME(Const1), 4))
	{
		REALNAME(Set1)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// exponent is infinity
	if (REALNAME(IsInf)(exp))
	{
		// exponent is negative infinity, result will be 0
		if (REALNAME(IsNeg)(exp))
		{
			REALNAME(Set0)(num);
			return;
		}

		// exponent is positive infinity, result will be infinity
		REALNAME(SetInf)(num);
		return;
	}

	// base is 0
	if (REALNAME(IsZero)(base))
	{
		// exponent is < 0, overflow error, divide by zero
		if (REALNAME(IsNeg)(exp))
		{
			REALNAME(SetInf)(num);
			return;
		}

		// exponent is > 0, result will be 0
		REALNAME(Set0)(num);
		return;
	}

	// base is infinity
	if (REALNAME(IsInf)(base))
	{
		// exponent is < 0, result will be 0
		if (REALNAME(IsNeg)(exp))
		{
			REALNAME(Set0)(num);
			return;
		}

		// exponent is > 0
		REALNAME(SetInf)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// get logarithm of the base
	REALNAME(Ln)(num); // logarithm of base

	// multiply by exponent
	REALNAME(Mul)(num, num, &e);

	// back to exponent
	REALNAME(Exp)(num);

	// set sign
	REALNAME(SetSign)(num, sign);
}

// ---------------------------------------------------------------------------
//                   root of 2 numbers (y = base^(1/exp))
// ---------------------------------------------------------------------------
//  Function uses 8 temporary numbers in the stack.

void REALNAME(Root)(REAL* num, const REAL* base, const REAL* exp)
{
	REAL m;
	REALNAME(RecFrom)(&m, exp);
	REALNAME(Pow)(num, base, &m);
}

// ---------------------------------------------------------------------------
// modulus with floor rounding; result has same sign as divisor num2 (range 0..num2)
// ---------------------------------------------------------------------------
//  Function uses 4 temporary numbers in the stack.

void REALNAME(ModFloor)(REAL* num, const REAL* num1, const REAL* num2)
{
	// divide a/b
	REAL m;
	REALNAME(Div)(&m, num1, num2);

	// get remainder of rounding down (result 0..+1)
	REALNAME(FloorFrac)(&m);

	// multiply remainder * divisor
	REALNAME(Mul)(num, &m, num2);
}

//  Function uses 3 temporary numbers in the stack.
EXP REALNAME(ModFloorExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2)
{
	EXP exp;
	REAL m;

	// divide a/b
	exp = REALNAME(DivExt)(&m, num1, exp1, num2, exp2);

	// get remainder of rounding down (result 0..+1)
	exp = REALNAME(FloorFracExt)(&m, exp);

	// multiply remainder * divisor
	return REALNAME(MulExt)(num, &m, exp, num2, exp2);
}

// ---------------------------------------------------------------------------
//    modulus with trunc rounding; result has same sign as dividend num1 (range 0..num2 or 0..-num2)
// ---------------------------------------------------------------------------
//  Function uses 4 temporary numbers in the stack.

void REALNAME(ModTrunc)(REAL* num, const REAL* num1, const REAL* num2)
{
	// divide a/b (sign = num1 XOR num2)
	REAL m;
	REALNAME(Div)(&m, num1, num2);

	// get remainder of rounding towards zero (result -1..0 for m<0, 0..+1 for m>=0)
	REALNAME(TruncFrac)(&m);

	// multiply remainder * divisor (sign = num1 XOR num2 XOR num2 = num1)
	REALNAME(Mul)(num, &m, num2);
}

//  Function uses 3 temporary numbers in the stack.
EXP REALNAME(ModTruncExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2)
{
	EXP exp;
	REAL m;

	// divide a/b (sign = num1 XOR num2)
	exp = REALNAME(DivExt)(&m, num1, exp1, num2, exp2);

	// get remainder of rounding towards zero (result -1..0 for m<0, 0..+1 for m>=0)
	exp = REALNAME(TruncFracExt)(&m, exp);

	// multiply remainder * divisor (sign = num1 XOR num2 XOR num2 = num1)
	return REALNAME(MulExt)(num, &m, exp, num2, exp2);
}

// ---------------------------------------------------------------------------
//      modulus with nearest rounding; result is in range -num2/2..+num2/2
// ---------------------------------------------------------------------------
//  Function uses 4 temporary numbers in the stack.

void REALNAME(ModRound)(REAL* num, const REAL* num1, const REAL* num2)
{
	// divide a/b
	REAL m;
	REALNAME(Div)(&m, num1, num2);

	// get remainder of rounding to nearest (result -0.5..+0.5)
	REALNAME(RoundFrac)(&m);

	// multiply remainder * divisor
	REALNAME(Mul)(num, &m, num2);
}

//  Function uses 3 temporary numbers in the stack.
EXP REALNAME(ModRoundExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2)
{
	EXP exp;
	REAL m;

	// divide a/b
	exp = REALNAME(DivExt)(&m, num1, exp1, num2, exp2);

	// get remainder of rounding to nearest (result -0.5..+0.5)
	exp = REALNAME(RoundFracExt)(&m, exp);

	// multiply remainder * divisor
	return REALNAME(MulExt)(num, &m, exp, num2, exp2);
}

// ---------------------------------------------------------------------------
//   compare 2 numbers (returns -1 if num1<num2, 0 if num1=num2, +1 if num1>num2)
// ---------------------------------------------------------------------------

s8 REALNAME(Comp)(const REAL* num1, const REAL* num2)
{
	u8 sign1, sign2, res;

	// load signs
	sign1 = REALNAME(GetSign)(num1);
	sign2 = REALNAME(GetSign)(num2);

	// absolute value of -0.0
	if (REALNAME(GetExp)(num1) == 0) sign1 = 0;
	if (REALNAME(GetExp)(num2) == 0) sign2 = 0;

	// compare signs
	if (sign1 != sign2) // signs not equal
	{
		if (sign1 > sign2) return -1; // num1 is negative < num2 is positive
		return 1;
	}

	// signs are equal, compare exponents and mantissas
	res = REALNAME(MantComp)(num1, num2);
	if (sign1 == 0) return res;
	return -res;
}

// Exponents are in packed form with sign in highest bit
s8 REALNAME(CompExt)(const REAL* num1, EXP exp1, const REAL* num2, EXP exp2)
{
	u8 sign1, sign2;
	s8 res;
	EXP ex1, ex2;

	// unpack exponents
	sign1 = (u8)(exp1 >> EXPEXT_BITS);
	ex1 = exp1 & EXPEXT_MASK;
	sign2 = (u8)(exp2 >> EXPEXT_BITS);
	ex2 = exp2 & EXPEXT_MASK;

	// absolute value of -0.0
	if (ex1 == EXPEXT_0) sign1 = 0;
	if (ex2 == EXPEXT_0) sign2 = 0;

	// compare signs
	if (sign1 != sign2) // signs not equal
	{
		if (sign1 > sign2) return -1; // num1 is negative < num2 is positive
		return 1;
	}

	// signs are equal, compare exponents
	if (ex1 != ex2)
		res = (ex1 > ex2) ? 1 : -1;
	else
		// signs and exponents are equal, compare mantissas
		res = REALNAME(MantComp)(num1, num2);

	// result
	if (sign1 == 0) return res;
	return -res;
}

// ---------------------------------------------------------------------------
// compare 2 numbers to equality with ignoring small difference (in number of bits)
// ---------------------------------------------------------------------------
//  Function uses 3 temporary numbers in the stack.

Bool REALNAME(CompEps)(const REAL* num1, const REAL* num2, int eps)
{
	u8 sign1, sign2;
	BASE exp1, exp2;
	REAL m;

	// load signs
	sign1 = REALNAME(GetSign)(num1);
	sign2 = REALNAME(GetSign)(num2);

	// load exponents
	exp1 = REALNAME(GetExp)(num1);
	exp2 = REALNAME(GetExp)(num2);

	// absolute value of -0.0
	if (exp1 == 0) sign1 = 0;
	if (exp2 == 0) sign2 = 0;

	// different signs
	if (sign1 != sign2) return False;

	// boths numbers are zero or infinity (= equal)
	if (((exp1 == 0) && (exp2 == 0)) || ((exp1 == EXP_INF) && (exp2 == EXP_INF))) return True;

	// only one number is overflow or zero (= not equal)
	if ((exp1 == EXP_INF) || (exp2 == EXP_INF) || (exp1 == 0) || (exp2 == 0)) return False;

	// numbers are binary equal
	if (memcmp(num1, num2, sizeof(REAL)) == 0) return True;
	if (eps <= 0) return False;

	// difference of numbers
	REALNAME(Sub)(&m, num1, num2);
	REALNAME(Abs)(&m);

	// numbers are equal
	if (REALNAME(IsZero)(&m)) return True;

	// prepare highest exponent -> exp1
	if (exp2 > exp1) exp1 = exp2;
	exp2 = REALNAME(GetExp)(&m);
	if (exp2 > exp1) exp1 = exp2;

	// check difference of exponents
	exp1 -= exp2;
	return (exp1 >= (BASE)(MANT_BITS - eps));
}

//  - exponents are in packed form with sign in highest bit
Bool REALNAME(CompEpsExt)(const REAL* num1, EXP exp1, const REAL* num2, EXP exp2, int eps)
{
	u8 sign1, sign2;
	EXP ex, ex1, ex2;
	REAL m;

	// unpack exponents
	sign1 = (u8)(exp1 >> EXPEXT_BITS);
	ex1 = exp1 & EXPEXT_MASK;
	sign2 = (u8)(exp2 >> EXPEXT_BITS);
	ex2 = exp2 & EXPEXT_MASK;

	// absolute value of -0.0
	if (ex1 == EXPEXT_0) sign1 = 0;
	if (ex2 == EXPEXT_0) sign2 = 0;

	// different signs
	if (sign1 != sign2) return False;

	// boths numbers are zero or infinity (= equal)
	if (((ex1 == EXPEXT_0) && (ex2 == EXPEXT_0)) || ((ex1 == EXPEXT_INF) && (ex2 == EXPEXT_INF))) return True;

	// only one number is overflow or zero (= not equal)
	if ((ex1 == EXPEXT_INF) || (ex2 == EXPEXT_INF) || (ex1 == EXPEXT_0) || (ex2 == EXPEXT_0)) return False;

	// numbers are binary equal
	if ((ex1 == ex2) && (memcmp(num1, num2, sizeof(REAL)) == 0)) return True;
	if (eps <= 0) return False;

	// difference of numbers (absolute value)
	ex = REALNAME(SubExt)(&m, num1, exp1, num2, exp2) & EXPEXT_MASK;;

	// numbers are equal
	if (ex == EXPEXT_0) return True;

	// prepare highest exponent -> ex1
	if (ex2 > ex1) ex1 = ex2;
	if (ex > ex1) ex1 = ex;

	// check difference of exponents
	ex1 -= ex;
	return (ex1 >= (EXP)(REAL_BITS - eps));
}

// ---------------------------------------------------------------------------
// check difference of numbers (returns number of different bits 0..MANT_BITS)
// ---------------------------------------------------------------------------
//  Function uses 3 temporary numbers in the stack.

int REALNAME(CheckDif)(const REAL* num1, const REAL* num2)
{
	u8 sign1, sign2;
	BASE exp1, exp2;
	REAL m;

	// load signs
	sign1 = REALNAME(GetSign)(num1);
	sign2 = REALNAME(GetSign)(num2);

	// load exponents
	exp1 = REALNAME(GetExp)(num1);
	exp2 = REALNAME(GetExp)(num2);

	// absolute value of -0.0
	if (exp1 == 0) sign1 = 0;
	if (exp2 == 0) sign2 = 0;

	// different signs
	if (sign1 != sign2) return MANT_BITS;

	// boths numbers are zero or infinity (= equal)
	if (((exp1 == 0) && (exp2 == 0)) || ((exp1 == EXP_INF) && (exp2 == EXP_INF))) return 0;

	// only one number is overflow or zero (= not equal)
	if ((exp1 == EXP_INF) || (exp2 == EXP_INF) || (exp1 == 0) || (exp2 == 0)) return MANT_BITS;

	// numbers are binary equal
	if (memcmp(num1, num2, sizeof(REAL)) == 0) return 0;

	// difference of numbers
	REALNAME(Sub)(&m, num1, num2);
	REALNAME(Abs)(&m);

	// numbers are equal
	if (REALNAME(IsZero)(&m)) return 0;

	// prepare highest exponent
	if (exp2 > exp1) exp1 = exp2;
	exp2 = REALNAME(GetExp)(&m);
	if (exp2 > exp1) exp1 = exp2;

	// check difference of exponents
	exp1 -= exp2;
	if (exp1 > MANT_BITS) exp1 = MANT_BITS;
	return (int)(MANT_BITS + 1 - exp1);
}

//  - exponents are in packed form with sign in highest bit
int REALNAME(CheckDifExt)(const REAL* num1, EXP exp1, const REAL* num2, EXP exp2)
{
	u8 sign1, sign2;
	EXP exp;
	REAL m;

	// unpack exponents
	sign1 = (u8)(exp1 >> EXPEXT_BITS);
	exp1 &= EXPEXT_MASK;
	sign2 = (u8)(exp2 >> EXPEXT_BITS);
	exp2 &= EXPEXT_MASK;

	// absolute value of -0.0
	if (exp1 == EXPEXT_0) sign1 = 0;
	if (exp2 == EXPEXT_0) sign2 = 0;

	// different signs
	if (sign1 != sign2) return REAL_BITS;

	// boths numbers are zero or infinity (= equal)
	if (((exp1 == EXPEXT_0) && (exp2 == EXPEXT_0)) || ((exp1 >= EXPEXT_INF) && (exp2 >= EXPEXT_INF))) return 0;

	// only one number is overflow or zero (= not equal)
	if ((exp1 >= EXPEXT_INF) || (exp2 >= EXPEXT_INF) || (exp1 == EXPEXT_0) || (exp2 == EXPEXT_0)) return REAL_BITS;

	// numbers are binary equal
	if ((exp1 == exp2) && (memcmp(num1, num2, sizeof(REAL)) == 0)) return 0;

	// difference of numbers
	exp = REALNAME(AddExt)(&m, num1, exp1 | ((EXP)sign1 << EXPEXT_BITS), num2, exp2 | ((EXP)(sign2 ^ 1) << EXPEXT_BITS));
	exp &= EXPEXT_MASK; // absolute value

	// numbers are equal
	if (exp == EXPEXT_0) return 0;

	// prepare highest exponent -> exp1
	if (exp2 > exp1) exp1 = exp2;
	if (exp > exp1) exp1 = exp;

	// check difference of exponents
	exp1 -= exp;
	if (exp1 > REAL_BITS-1) exp1 = REAL_BITS-1;
	return (int)(REAL_BITS - exp1);
}

// ---------------------------------------------------------------------------
//          find greatest common divisor (GCD) of two integer numbers
// ---------------------------------------------------------------------------
// Function uss 5 temporary numbers in the stack.

void REALNAME(GCD)(REAL* num, const REAL* num1, const REAL* num2)
{
	REAL m;

	// round both numbers
	REALNAME(RoundFrom)(&m, num2);
	REALNAME(RoundFrom)(num, num1);

	// some number is 0, result will be 1
	if (REALNAME(IsZero)(num) || REALNAME(IsZero)(&m) || REALNAME(IsInf)(num) || REALNAME(IsInf)(&m))
	{
		REALNAME(Set1)(num);
		return;
	}

	// loop
	for (;;)
	{
		// num2 modulo num1
		REALNAME(ModTrunc)(&m, &m, num);
		REALNAME(Round)(&m);

		// if modulo is 0, result will be num1
		if (REALNAME(IsZero)(&m)) break;

		// num1 modulo num2
		REALNAME(ModTrunc)(num, num, &m);
		REALNAME(Round)(num);

		// if modulo is 0, result will ne num2
		if (REALNAME(IsZero)(num))
		{
			REALNAME(Copy)(num, &m);
			break;;
		}
	}

	// absolute value
	REALNAME(Abs)(num);
}

// ===========================================================================
//                           Functions
// ===========================================================================

// ---------------------------------------------------------------------------
//                  negate (can change sign of zero, too)
// ---------------------------------------------------------------------------

void REALNAME(Neg)(REAL* num)
{
	BASE n = num->n[BASE_NUM-1];	// get last segment
	n ^= BASE_LAST;			// flip sign bit
	num->n[BASE_NUM-1] = n;		// store new last segment
}

// ---------------------------------------------------------------------------
//                             absolute value
// ---------------------------------------------------------------------------

void REALNAME(Abs)(REAL* num)
{
	BASE n = num->n[BASE_NUM-1];	// get last segment
	n <<= 1;			// discard sign bit
	n >>= 1;			// restore
	num->n[BASE_NUM-1] = n;		// store new last segment
}

// ---------------------------------------------------------------------------
// set signum (sets to 0 if number is zero, 1 if positive or -1 if negative)
// ---------------------------------------------------------------------------

void REALNAME(SignumFrom)(REAL* num, const REAL* src)
{
	if (REALNAME(IsZero)(src))		// if zero
			REALNAME(Set0)(num);	// set 0
	else
		if (REALNAME(IsNeg)(src))	// if negative
			REALNAME(SetM1)(num);	// set -1
		else
			REALNAME(Set1)(num);	// set 1
}

// ---------------------------------------------------------------------------
//   compare number to zero (returns -1 if num<0, 0 if num=0, +1 if num>0)
// ---------------------------------------------------------------------------
// - Alternative function is signum Signum(), which sets result to the number.

s8 REALNAME(Comp0)(const REAL* num)
{
	if (REALNAME(IsZero)(num)) return 0; // zero or underflow
	if (REALNAME(IsNeg)(num)) return -1; // negative number
	return 1;					// positive
}

// ---------------------------------------------------------------------------
//                multiply by 2 (increment exponent)
// ---------------------------------------------------------------------------

void REALNAME(Mul2)(REAL* num)
{
	// zero or infinity
	BASE exp = REALNAME(GetExp)(num);
	if ((exp == EXP_0) || (exp == EXP_INF)) return;

	// increment exponent
	REALNAME(SetExp)(num, exp+1);
}

//  Extended version uses exponent in packed form with sign in highest bit.
EXP REALNAME(Mul2Ext)(REAL* num, EXP exp)
{
	EXPS exps;
	EXP ex;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	ex = exp & EXPEXT_MASK;

	// zero or infinity, no change
	if ((ex == EXPEXT_0) || (ex == EXPEXT_INF)) return exp;

	// shift exponent
	exps = (EXPS)(ex + 1);

	// overflow
	if (exps >= (EXPS)EXPEXT_MAX)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	return (EXP)exps | ((EXP)sign << EXPEXT_BITS);;
}

// ---------------------------------------------------------------------------
//                  divide by 2 (decrement exponent)
// ---------------------------------------------------------------------------

void REALNAME(Div2)(REAL* num)
{
	// zero or infinity
	BASE exp = REALNAME(GetExp)(num);
	if ((exp == EXP_0) || (exp == EXP_INF)) return;

	// decrement exponent
	REALNAME(SetExp)(num, exp-1);
}

//  Extended version uses exponent in packed form with sign in highest bit.
EXP REALNAME(Div2Ext)(REAL* num, EXP exp)
{
	EXPS exps;
	EXP ex;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	ex = exp & EXPEXT_MASK;

	// zero or infinity, no change
	if ((ex == EXPEXT_0) || (ex == EXPEXT_INF)) return exp;

	// shift exponent
	exps = (EXPS)(ex - 1);

	// underflow
	if (exps <= (EXPS)EXPEXT_0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0 | ((EXP)sign << EXPEXT_BITS);;
	}

	return (EXP)exps | ((EXP)sign << EXPEXT_BITS);;
}

// ---------------------------------------------------------------------------
//                       bitwise NOT
// ---------------------------------------------------------------------------

void REALNAME(Not)(REAL* num)
{
	REALNAME(Neg)(num);
	REALNAME(Dec)(num);
}

// ---------------------------------------------------------------------------
//                 increment number (increase by 1)
// ---------------------------------------------------------------------------
//  Function uses 2 temporary numbers in the stack.

void REALNAME(IncFrom)(REAL* num, const REAL* src)
{
	REALNAME(Add)(num, src, &REALNAME(Const1));
}

EXP REALNAME(IncFromExt)(REAL* num, const REAL* src, EXP exp)
{
	return REALNAME(AddExt)(num, src, exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1);
}

// ---------------------------------------------------------------------------
//                 decrement number (decrease by 1)
// ---------------------------------------------------------------------------
//  Function uses 2 temporary numbers in the stack.

void REALNAME(DecFrom)(REAL* num, const REAL* src)
{
	REALNAME(Add)(num, src, &REALNAME(ConstM1));
}

EXP REALNAME(DecFromExt)(REAL* num, const REAL* src, EXP exp)
{
	return REALNAME(AddExt)(num, src, exp, (const REAL*)&REALNAME(ConstM1Ext), EXPEXT_1 | EXPEXT_SIGN);
}

// ---------------------------------------------------------------------------
//             Truncate, round towards zero (= "integer" function)
// ---------------------------------------------------------------------------

void REALNAME(Trunc)(REAL* num)
{
	int i;
	BASE *s, exp;
	u8 sign;

	// get exponent and sign
	exp = REALNAME(GetExp)(num);
	sign = REALNAME(GetSign)(num);

	// special case: infinity
	if (exp == EXP_INF) return;

	// small number 0..0.999 can be made zero
	if (exp < EXP_1)
	{
		REALNAME(Set0)(num);
		REALNAME(SetSign)(num, sign);
		return;
	}

	// get absolute exponent
	exp -= EXP_BIAS;

	// big number is already integer
	if (exp > MANT_BITS-1) return;

// Here is exp = 0..MANT_BITS-1

	// prepare number of bits to clear (as result i = 1 .. MANT_BITS)
	i = (int)(MANT_BITS - exp);

	// reset whole segments
	s = num->n;		// first (lowest) segment
	for (; i >= BASE_BITS; i -= BASE_BITS) *s++ = 0;

	// reset remaining bits
	if (i > 0) *s = *s & (BASE_MAX << i);
}

//  Extended version uses exponent in packed form with sign in highest bit.
EXP REALNAME(TruncExt)(REAL* num, EXP exp)
{
	int i;
	BASE *s;
	EXP ex;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	ex = exp & EXPEXT_MASK;

	// special case: infinity
	if (ex >= EXPEXT_INF) return exp;

	// small number 0..0.999 can be made zero
	if (ex < EXPEXT_1)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0 | ((EXP)sign << EXPEXT_BITS);
	}

	// get absolute exponent
	ex -= EXPEXT_BIAS;

	// big number is already integer
	if (ex > REAL_BITS-2) return exp;

// Here is exp = 0..REAL_BITS-2

	// prepare number of bits to clear (as result i = 1 .. REAL_BITS-1)
	i = (int)(REAL_BITS - 1 - ex);

	// reset whole segments
	s = num->n;		// first (lowest) segment
	for (; i >= BASE_BITS; i -= BASE_BITS) *s++ = 0;

	// reset remaining bits
	if (i > 0) *s = *s & (BASE_MAX << i);

	return exp;
}

// ---------------------------------------------------------------------------
// truncation fraction "num - trunc(num)"; result is -1..0 for num<0 or 0..+1 for num>=0
// ---------------------------------------------------------------------------
//  Function uses 3 temporary numbers in the stack.

void REALNAME(TruncFrac)(REAL* num)
{
	// truncation towards zero trunc(x)
	REAL m;
	REALNAME(Copy)(&m, num);
	REALNAME(Trunc)(&m);

	// difference x - trunc(x)
	REALNAME(Sub)(num, num, &m);
}

EXP REALNAME(TruncFracExt)(REAL* num, EXP exp)
{
	EXP exp2;

	// truncation towards zero trunc(x)
	REAL m;
	REALNAME(Copy)(&m, num);
	exp2 = REALNAME(TruncExt)(&m, exp);

	// difference x - trunc(x)
	return REALNAME(SubExt)(num, num, exp, &m, exp2);
}

// ---------------------------------------------------------------------------
//                Round number to nearest integer
// ---------------------------------------------------------------------------
//  Function uses 2 temporary numbers in the stack.
//  Half is rounded to higher numbers (+1.5 -> 2.0, -1.5 -> -2.0).

void REALNAME(RoundFrom)(REAL* num, const REAL* src)
{
	// negative numbers (not zero)
	if (REALNAME(IsNeg)(src) && !REALNAME(IsZero)(src))
	{
		// subtract 0.5
		REALNAME(Add)(num, src, &REALNAME(ConstM05));
	}
	else
	{
		// add 0.5
		REALNAME(Add)(num, src, &REALNAME(Const05));
	}

	// truncate towards zero
	REALNAME(Trunc)(num);
}

EXP REALNAME(RoundFromExt)(REAL* num, const REAL* src, EXP exp)
{
	u8 sign;
	EXP exp2;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp2 = exp & EXPEXT_MASK;

	// negative numbers (not zero)
	if ((sign != 0) && (exp2 != EXPEXT_0))
	{
		// subtract 0.5
		exp = REALNAME(AddExt)(num, src, exp, (const REAL*)&REALNAME(ConstM05Ext), (EXPEXT_1 - 1) | EXPEXT_SIGN);
	}
	else
	{
		// add 0.5
		exp = REALNAME(AddExt)(num, src, exp, (const REAL*)&REALNAME(Const05Ext), EXPEXT_1 - 1);
	}

	// truncate towards zero
	return REALNAME(TruncExt)(num, exp);
}

// ---------------------------------------------------------------------------
//            Rounding fraction "num - round(num)" = -0.5..+0.5
// ---------------------------------------------------------------------------
//  Function uses 3 temporary numbers in the stack.

void REALNAME(RoundFracFrom)(REAL* num, const REAL* src)
{
	// round nearest round(x)
	REAL m;
	REALNAME(RoundFrom)(&m, src);

	// difference x - round(x)
	REALNAME(Sub)(num, src, &m);
}

//  Extended version uses exponent in packed form with sign in highest bit.
EXP REALNAME(RoundFracFromExt)(REAL* num, const REAL* src, EXP exp)
{
	EXP exp2;

	// round nearest round(x)
	REAL m;
	exp2 = REALNAME(RoundFromExt)(&m, src, exp);

	// difference x - round(x)
	return REALNAME(SubExt)(num, src, exp, &m, exp2);
}

// ---------------------------------------------------------------------------
//                             rounding down
// ---------------------------------------------------------------------------
//  Function uses 2 temporary numbers in the stack.

void REALNAME(Floor)(REAL* num)
{
	Bool neg;

	// already integer
	if (REALNAME(IsInt)(num)) return;

	// check negative number
	neg = REALNAME(IsNeg)(num);

	// truncate towards zero
	REALNAME(Trunc)(num);

	// decrement negative fractional number
	if (neg) REALNAME(Dec)(num);
}

EXP REALNAME(FloorExt)(REAL* num, EXP exp)
{
	Bool neg;

	// already integer
	if (REALNAME(IsIntExt)(num, exp)) return exp;

	// check negative number
	neg = (exp & EXPEXT_SIGN) != 0;

	// truncate towards zero
	exp = REALNAME(TruncExt)(num, exp);

	// decrement negative fractional number
	if (neg) exp = REALNAME(DecExt)(num, exp);

	return exp;
}

// ---------------------------------------------------------------------------
//              rounding down fraction "num - floor(num)" = 0..+1
// ---------------------------------------------------------------------------
//  Function uses 3 temporary numbers in the stack.

void REALNAME(FloorFrac)(REAL* num)
{
	// rounding down floor(x)
	REAL m;
	REALNAME(Copy)(&m, num);
	REALNAME(Floor)(&m);

	// difference x - floor(x)
	REALNAME(Sub)(num, num, &m);
}

//  Function uses 2 temporary numbers in the stack.
EXP REALNAME(FloorFracExt)(REAL* num, EXP exp)
{
	EXP exp2;

	// rounding down floor(x)
	REAL m;
	REALNAME(Copy)(&m, num);
	exp2 = REALNAME(FloorExt)(&m, exp);

	// difference x - floor(x)
	return REALNAME(SubExt)(num, num, exp, &m, exp2);
}

// ---------------------------------------------------------------------------
//                         rounding up
// ---------------------------------------------------------------------------
//  Function uses 2 temporary numbers in the stack.

void REALNAME(Ceil)(REAL* num)
{
	Bool neg;

	// already integer
	if (REALNAME(IsInt)(num)) return;

	// check negative number
	neg = REALNAME(IsNeg)(num);

	// truncate towards zero
	REALNAME(Trunc)(num);

	// increment positive fractional number
	if (!neg) REALNAME(Inc)(num);
}

EXP REALNAME(CeilExt)(REAL* num, EXP exp)
{
	Bool neg;

	// already integer
	if (REALNAME(IsIntExt)(num, exp)) return exp;

	// check negative number
	neg = (exp & EXPEXT_SIGN) != 0;

	// truncate towards zero
	exp = REALNAME(TruncExt)(num, exp);

	// increment positive fractional number
	if (!neg) exp = REALNAME(IncExt)(num, exp);

	return exp;
}

// ---------------------------------------------------------------------------
//            rounding up fraction "num - ceil(num)" = -1..0
// ---------------------------------------------------------------------------
//  Function uses 3 temporary numbers in the stack.

void REALNAME(CeilFrac)(REAL* num)
{
	// rounding up ceil(x)
	REAL m;
	REALNAME(Copy)(&m, num);
	REALNAME(Ceil)(&m);

	// difference x - ceil(x)
	REALNAME(Sub)(num, num, &m);
}

//  Function uses 2 temporary numbers in the stack.
EXP REALNAME(CeilFracExt)(REAL* num, EXP exp)
{
	EXP exp2;

	// rounding up ceil(x)
	REAL m;
	REALNAME(Copy)(&m, num);
	exp2 = REALNAME(CeilExt)(&m, exp);

	// difference x - ceil(x)
	return REALNAME(SubExt)(num, num, exp, &m, exp2);
}

// ---------------------------------------------------------------------------
//                   check if number is integer
// ---------------------------------------------------------------------------

Bool REALNAME(IsInt)(const REAL* num)
{
	int i;
	const BASE *s;
	BASE exp;

	// get exponent
	exp = REALNAME(GetExp)(num);

	// big number or zero is always integer
	if ((exp > EXP_BIAS + MANT_BITS-1) || (exp == EXP_0)) return True;

	// small number is not integer
	if (exp < EXP_1) return False;
	exp -= EXP_BIAS;

// Here is exp = 0..MANT_BITS-1

	// prepare number of bits to check (as result i = 1 .. MANT_BITS)
	i = (int)(MANT_BITS - exp);

	// check whole segments
	s = num->n;			// first (lowest) segment
	for (; i >= BASE_BITS; i -= BASE_BITS)
	{
		if (*s != 0) return False;
		s++;
	}

	// check remaining bits
	if (i > 0) return (*s & ~(BASE)(BASE_MAX << i)) == 0;

	return True;
}

Bool REALNAME(IsIntExt)(const REAL* num, EXP exp)
{
	int i;
	const BASE *s;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// big number or zero is always integer
	if ((exp > EXPEXT_BIAS + REAL_BITS-2) || (exp == EXPEXT_0)) return True;

	// small number is not integer
	if (exp < EXPEXT_1) return False;
	exp -= EXPEXT_BIAS;

// Here is exp = 0..REAL_BITS-2

	// prepare number of bits to check (as result i = 1 .. REAL_BITS-1)
	i = (int)(REAL_BITS - 1 - exp);

	// check whole segments
	s = num->n;			// first (lowest) segment
	for (; i >= BASE_BITS; i -= BASE_BITS)
	{
		if (*s != 0) return False;
		s++;
	}

	// check remaining bits
	if (i > 0) return (*s & ~(BASE)(BASE_MAX << i)) == 0;

	return True;
}

// ---------------------------------------------------------------------------
//                  check if number is odd integer
// ---------------------------------------------------------------------------

Bool REALNAME(IsOddInt)(const REAL* num)
{
	int i;
	const BASE *s;
	BASE exp;

	// get exponent
	exp = REALNAME(GetExp)(num);

	// large number is not odd integer
	if (exp > EXP_BIAS + MANT_BITS) return False;

	// small number and 0 is not odd integer
	if (exp < EXP_1) return False;
	exp -= EXP_BIAS;

// Here is exp = 0..MANT_BITS

	// prepare number of bits to check (as result i = 0 .. MANT_BITS)
	i = (int)(MANT_BITS - exp);

	// check whole segments
	s = num->n;			// first (lowest) segment
	for (; i >= BASE_BITS; i -= BASE_BITS)
	{
		if (*s != 0) return False; // not integer
		s++;
	}

	// check remaining bits
	if (i > 0)
	{
		if ((*s & ~(BASE)(BASE_MAX << i)) != 0) return False; // not integer
	}

	// value 1 is odd
	if (exp == 0) return True;

	// check odd number
	return (*s & (1 << i)) != 0;
}

Bool REALNAME(IsOddIntExt)(const REAL* num, EXP exp)
{
	int i;
	const BASE *s;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// large number is not odd integer
	if (exp > EXPEXT_BIAS + REAL_BITS-1) return False;

	// small number and 0 is not odd integer
	if (exp < EXPEXT_1) return False;
	exp -= EXPEXT_BIAS;

// Here is exp = 0..REAL_BITS-1

	// prepare number of bits to check (as result i = 1 .. REAL_BITS)
	i = (int)(REAL_BITS - exp);

	// check whole segments
	s = num->n;			// first (lowest) segment
	for (; i >= BASE_BITS; i -= BASE_BITS)
	{
		if (*s != 0) return False; // not integer
		s++;
	}

	// check remaining bits
	if (i > 0)
	{
		if ((*s & ~(BASE)(BASE_MAX << i)) != 0) return False; // not integer
	}

	// value 1 is odd
	if (exp == 0) return True;

	// check odd number
	return (*s & (1 << i)) != 0;
}

// ---------------------------------------------------------------------------
//                  check if number is power of 2
// ---------------------------------------------------------------------------

Bool REALNAME(IsPow2)(const REAL* num)
{
	int i;
	const BASE *s;
	BASE exp;

	// get exponent
	exp = REALNAME(GetExp)(num);

	// zero and infinity are not power of 2
	if ((exp == 0) || (exp == EXP_INF)) return False;

	// check if mantissa is all zero
	s = num->n;
	for (i = BASE_NUM-1; i > 0; i--)
	{
		if (*s++ != 0) return False;
	}

	// check last segment
	return (*s & MANT_LAST_MASK) == 0;
}

Bool REALNAME(IsPow2Ext)(const REAL* num, EXP exp)
{
	int i;
	const BASE *s;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// zero and infinity are not power of 2
	if ((exp == EXPEXT_0) || (exp >= EXPEXT_INF)) return False;

	// check if mantissa is all zero
	s = num->n;
	for (i = BASE_NUM-1; i > 0; i--)
	{
		if (*s++ != 0) return False;
	}

	// check last segment
	return (*s & BASE_MASK) == 0;
}

// ---------------------------------------------------------------------------
//                       ln(2) constant
// ---------------------------------------------------------------------------
// - uses similar method as Ln_Taylor, but does not require pre-calculated ln(2)

//  Function uses 5 temporary numbers in the stack.
void REALNAME(Ln2_old)(REAL* num)
{
	REAL x2, res, tmp;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// prepare member D and result accumulator (x = 2, D = (2-1)/(2+1) = 1/3)
	REALNAME(SetUInt)(num, 3); // num=3
	REALNAME(Rec)(num);  // num=1/3
	REALNAME(Copy)(&res, num); // res=num=D

	// square D^2
	REALNAME(SqrFrom)(&x2, num);

	// factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by D^2
		REALNAME(Mul)(num, num, &x2);

		// increase factorial coefficient by 2
		faci += 2;

		// divide member by factorial coefficient
		REALNAME(DivU16)(&tmp, num, faci);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoop)(&res, &tmp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// multiply by 2
	REALNAME(Mul2)(&res);

	// copy result
	REALNAME(Copy)(num, &res);
}

//  Function uses 4 temporary numbers in the stack.
EXP REALNAME(Ln2Ext)(REAL* num)
{
	REAL x2, res, tmp;
	EXP x2_exp, res_exp, tmp_exp, num_exp;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// prepare member D and result accumulator (x = 2, D = (2-1)/(2+1) = 1/3)
	num_exp = REALNAME(DivU16Ext)(num, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1, 3); // num=1/3
	REALNAME(Copy)(&res, num); // res=num=D
	res_exp = num_exp;

	// square D^2
	x2_exp = REALNAME(SqrFromExt)(&x2, num, num_exp);

	// factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by D^2
		num_exp = REALNAME(MulExt)(num, num, num_exp, &x2, x2_exp);

		// increase factorial coefficient by 2
		faci += 2;

		// divide member by factorial coefficient
		tmp_exp = REALNAME(DivU16Ext)(&tmp, num, num_exp, faci);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoopExt)(&res, &res_exp, &tmp, tmp_exp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// multiply by 2
	res_exp = REALNAME(Mul2Ext)(&res, res_exp);

	// copy result
	REALNAME(Copy)(num, &res);
	return res_exp;
}

//  Function uses 4 temporary numbers in the stack.
void REALNAME(Ln2)(REAL* num)
{
	EXP exp = REALNAME(Ln2Ext)(num);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//             natural logarithm - Mercator serie
// ---------------------------------------------------------------------------
//  Mercator serie D = x-1, ln(x) = D - D^2/2 + D^3/3 - ... ... for 0 < x <= 2
//  Function uses 5 temporary numbers in the stack.

void REALNAME(Ln_MercatorFrom_old)(REAL* num, const REAL* src)
{
	REAL mem, d, tmp;
	s8 cmp;
	BASES exps;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// overflow or number is <= 0 (invalid result)
	if (REALNAME(IsInf)(src) || (REALNAME(Comp0)(src) <= 0))
	{
		REALNAME(SetInf)(num);
		return;
	}

	// result is 0 if x=1
	cmp = REALNAME(Comp)(src, &REALNAME(Const1));
	if (cmp == 0)
	{
		REALNAME(Set0)(num);
		return;
	}

	// load exponent
	exps = REALNAME(GetExpS)(src) + 1;

	// set exponent to 0.5-base, get range 0.5..1
	REALNAME(Copy)(num, src);
	REALNAME(SetExp)(num, EXP_1 - 1);

	// serie is slow in interval 0.5 .. 0.75, in that case use interval 1 .. 1.5
	if (REALNAME(Comp)(num, &REALNAME(Const075)) < 0) // check if value is in interval 0.5 .. 0.75
	{
		// use interval 1 .. 1.5
		exps--;
		REALNAME(SetExp)(num, EXP_1);
	}	

	// prepare member D and result accumulator
	REALNAME(DecFrom)(&d, num); // D = x - 1
	REALNAME(Copy)(num, &d); // result accumulator = D
	REALNAME(Copy)(&mem, &d); // member = D
	REALNAME(Neg)(&d);		// -D

	// factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by -D
		REALNAME(Mul)(&mem, &mem, &d);

		// increment factorial coefficient
		faci++;

		// divide member by factorial coefficient
		REALNAME(DivU16)(&tmp, &mem, faci);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoop)(num, &tmp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// add exponent to the result
	REALNAME(SetSInt)(&tmp, exps);
	REALNAME(Mul)(&tmp, &tmp, &REALNAME(ConstLn2));
	REALNAME(Add)(num, num, &tmp);
}

//  Function uses 4 temporary numbers in the stack.
EXP REALNAME(Ln_MercatorFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	REAL mem, d, tmp;
	EXP mem_exp, d_exp, tmp_exp, num_exp;
	s8 cmp;
	u8 sign;
	EXPS exps;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	src_exp &= EXPEXT_MASK;

	// overflow or number is <= 0 (invalid result)
	if ((src_exp >= EXPEXT_MAX) || (src_exp == EXPEXT_0) || sign)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF;
	}

	// result is 0 if x=1
	cmp = REALNAME(CompExt)(src, src_exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1);
	if (cmp == 0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0;
	}

	// load exponent
	exps = src_exp - EXPEXT_BIAS + 1;

	// set exponent to 0.5-base, get range 0.5..1
	REALNAME(Copy)(num, src);
	num_exp = EXPEXT_1 - 1;

	// serie is slow in interval 0.5 .. 0.75, in that case use interval 1 .. 1.5
	if (REALNAME(CompExt)(num, num_exp, (const REAL*)&REALNAME(Const075Ext), EXPEXT_1 - 1) < 0) // check if value is in interval 0.5 .. 0.75
	{
		// use interval 1 .. 1.5
		exps--;
		num_exp = EXPEXT_1;
	}	

	// prepare member D and result accumulator
	d_exp = REALNAME(DecFromExt)(&d, num, num_exp); // D = x - 1
	REALNAME(Copy)(num, &d); // result accumulator = D
	num_exp = d_exp;
	REALNAME(Copy)(&mem, &d); // member = D
	mem_exp = d_exp;
	d_exp ^= EXPEXT_SIGN; 	// -D

	// factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by -D
		mem_exp = REALNAME(MulExt)(&mem, &mem, mem_exp, &d, d_exp);

		// increment factorial coefficient
		faci++;

		// divide member by factorial coefficient
		tmp_exp = REALNAME(DivU16Ext)(&tmp, &mem, mem_exp, faci);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoopExt)(num, &num_exp, &tmp, tmp_exp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// add exponent to the result
	tmp_exp = REALNAME(SetS32Ext)(&tmp, exps);
	tmp_exp = REALNAME(MulExt)(&tmp, &tmp, tmp_exp, (const REAL*)&REALNAME(ConstLn2Ext), EXPEXT_1 - 1);
	return REALNAME(AddExt)(num, num, num_exp, &tmp, tmp_exp);
}

//  Function uses 4 temporary numbers in the stack.
void REALNAME(Ln_MercatorFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Ln_MercatorFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                  natural logarithm - Taylor serie (base reference)
// ---------------------------------------------------------------------------
//  Taylor serie D = (x-1)/(x+1),  xi+1 = xi*D^2*(i*2-1)/(i*2+1) ... x0 = 2*D
//  ln(x) = 2*D*(1 + D^2/3 + D^4/5 + D^6/7 ...) .... for x>0
//  Function uses 5 temporary numbers in the stack.

void REALNAME(Ln_TaylorFrom_old)(REAL* num, const REAL* src)
{
	REAL x2, res, tmp;
	s8 cmp;
	BASES exps;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// overflow or number is <= 0 (invalid result)
	if (REALNAME(IsInf)(src) || (REALNAME(Comp0)(src) <= 0))
	{
		REALNAME(SetInf)(num);
		return;
	}

	// result is 0 if x=1
	cmp = REALNAME(Comp)(src, &REALNAME(Const1));
	if (cmp == 0)
	{
		REALNAME(Set0)(num);
		return;
	}

	// load exponent
	exps = REALNAME(GetExpS)(src) + 1;

	// set exponent to 0.5-base, get range 0.5..0.999999
	REALNAME(Copy)(num, src);
	REALNAME(SetExp)(num, EXP_1 - 1);

	// serie is slow in interval 0.5 .. 0.75, in that case use interval 1 .. 1.5
	if (REALNAME(Comp)(num, &REALNAME(Const075)) < 0) // check if value is in interval 0.5 .. 0.75
	{
		// use interval 1 .. 1.5
		exps--;
		REALNAME(SetExp)(num, EXP_1);
	}	

	// prepare member D and result accumulator
	REALNAME(IncFrom)(&res, num); // res = x + 1
	REALNAME(Dec)(num); // num = x - 1
	REALNAME(Div)(num, num, &res); // num = (x - 1) / (x + 1) = D
	REALNAME(Copy)(&res, num);

	// square D^2
	REALNAME(SqrFrom)(&x2, num);

	// factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by D^2
		REALNAME(Mul)(num, num, &x2);

		// increase factorial coefficient by 2
		faci += 2;

		// divide member by factorial coefficient
		REALNAME(DivU16)(&tmp, num, faci);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoop)(&res, &tmp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// multiply by 2
	REALNAME(Mul2)(&res);

	// add exponent to the result
	REALNAME(SetSInt)(&tmp, exps);
	REALNAME(Mul)(&tmp, &tmp, &REALNAME(ConstLn2));
	REALNAME(Add)(num, &res, &tmp);
}

//  Function uses 4 temporary numbers in the stack.
EXP REALNAME(Ln_TaylorFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	REAL x2, res, tmp;
	EXP x2_exp, res_exp, tmp_exp, num_exp;
	s8 cmp;
	u8 sign;
	EXPS exps;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	src_exp &= EXPEXT_MASK;

	// overflow or number is <= 0 (invalid result)
	if ((src_exp >= EXPEXT_MAX) || (src_exp == EXPEXT_0) || sign)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF;
	}

	// result is 0 if x=1
	cmp = REALNAME(CompExt)(src, src_exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1);
	if (cmp == 0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0;
	}

	// load exponent
	exps = src_exp - EXPEXT_BIAS + 1;

	// set exponent to 0.5-base, get range 0.5..0.999999
	REALNAME(Copy)(num, src);
	num_exp = EXPEXT_1 - 1;

	// serie is slow in interval 0.5 .. 0.75, in that case use interval 1 .. 1.5
	if (REALNAME(CompExt)(num, num_exp, (const REAL*)&REALNAME(Const075Ext), EXPEXT_1 - 1) < 0) // check if value is in interval 0.5 .. 0.75
	{
		// use interval 1 .. 1.5
		exps--;
		num_exp = EXPEXT_1;
	}	

	// prepare member D and result accumulator
	res_exp = REALNAME(IncFromExt)(&res, num, num_exp); // res = x + 1
	num_exp = REALNAME(DecExt)(num, num_exp); // num = x - 1
	num_exp = REALNAME(DivExt)(num, num, num_exp, &res, res_exp); // num = (x - 1) / (x + 1) = D
	REALNAME(Copy)(&res, num);
	res_exp = num_exp;

	// square D^2
	x2_exp = REALNAME(SqrFromExt)(&x2, num, num_exp);

	// factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by D^2
		num_exp = REALNAME(MulExt)(num, num, num_exp, &x2, x2_exp);

		// increase factorial coefficient by 2
		faci += 2;

		// divide member by factorial coefficient
		tmp_exp = REALNAME(DivU16Ext)(&tmp, num, num_exp, faci);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoopExt)(&res, &res_exp, &tmp, tmp_exp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// multiply by 2
	res_exp = REALNAME(Mul2Ext)(&res, res_exp);

	// add exponent to the result
	tmp_exp = REALNAME(SetS32Ext)(&tmp, exps);
	tmp_exp = REALNAME(MulExt)(&tmp, &tmp, tmp_exp, (const REAL*)&REALNAME(ConstLn2Ext), EXPEXT_1 - 1);
	return REALNAME(AddExt)(num, &res, res_exp, &tmp, tmp_exp);
}

//  Function uses 4 temporary numbers in the stack.
void REALNAME(Ln_TaylorFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Ln_TaylorFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                 natural logarithm - Chebyshev approximation
// ---------------------------------------------------------------------------

#ifdef CHEB_LN
EXP REALNAME(Ln_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	REAL fac;
	s8 cmp;
	u8 sign;
	EXPS exps;
	EXP exp, fac_exp;

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	exp = src_exp & EXPEXT_MASK;

	// overflow or number is <= 0 (invalid result)
	if ((exp >= EXPEXT_MAX) || (exp == EXPEXT_0) || sign)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF;
	}

	// result is 0 if x=1
	cmp = REALNAME(CompExt)(src, exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1);
	if (cmp == 0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0;
	}

	// load exponent
	exps = exp - EXPEXT_BIAS;

	// set exponent to 1-base, get range 1..1.999999
	REALNAME(Copy)(num, src);
	exp = EXPEXT_1;

	// convert to range -1..+1
	exp = REALNAME(DecExt)(num, exp); // 1..+2 -> 0..+1
	exp = REALNAME(Mul2Ext)(num, exp); // 0..+1 -> 0..+2
	exp = REALNAME(DecExt)(num, exp); // 0..+2 -> -1..+1

	// calculate function
	exp = REALNAME(ChebyshevExt)(num, exp, CHEB_LN, REALNAME(ConstChebLn));

	// add exponent to the result
	fac_exp = REALNAME(SetS32Ext)(&fac, exps);
	fac_exp = REALNAME(MulExt)(&fac, &fac, fac_exp, (const REAL*)&REALNAME(ConstLn2Ext), EXPEXT_1 - 1);
	return REALNAME(AddExt)(num, num, exp, &fac, fac_exp);
}

void REALNAME(Ln_ChebyshevFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Ln_ChebyshevFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}
#endif // CHEB_LN > 0

// ---------------------------------------------------------------------------
//               natural exponent - Taylor serie
// ---------------------------------------------------------------------------
//  Taylor serie xi+1 = xi * x / (i+1) ... x0 = 1
//  exp(x) = 1 + x/1! + x^2/2! + x^3/3! + x^4/4! + x^5/5! + ...
//  Function uses 4 temporary numbers in the stack.

void REALNAME(Exp_TaylorFrom_old)(REAL* num, const REAL* src)
{
	REAL x, res;
	BASES exps;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// number is zero, return 1
	if (REALNAME(IsZero)(src))
	{
		REALNAME(Set1)(num);
		return;
	}

	// overflow
	if (REALNAME(IsInf)(src) || (REALNAME(Comp)(src, &REALNAME(ConstExpMax)) > 0))
	{
		REALNAME(SetInf)(num);
		return;
	}

	// underflow
	if (REALNAME(Comp)(src, &REALNAME(ConstExpMin)) < 0)
	{
		REALNAME(Set0)(num);
		return;
	}

	// get integer part of exponent (integer /ln(2) integer *ln(2) subtract ... multiply)
	REALNAME(Mul)(&x, src, &REALNAME(ConstRLn2)); // convert to 2-base x = num / ln(2)
	REALNAME(Trunc)(&x);		// truncate (round towards zero)
	exps = REALNAME(GetSInt)(&x); // get exponent
	REALNAME(Mul)(&x, &x, &REALNAME(ConstLn2)); // convert back to e-base big = int(num / ln(2)) * ln(2)
	REALNAME(Sub)(num, src, &x);		// subtract integer exponent

	// prepare member
	REALNAME(Set1)(&x);

	// factorial coefficient -> 0
	faci = 0;

	// result accumulator
	REALNAME(Set1)(&res);

	// iterations
	do {
		// multiply member by x
		REALNAME(Mul)(&x, &x, num);

		// increase factorial coefficient
		faci++;

		// divide member by factorial coefficient
		REALNAME(DivU16)(&x, &x, faci);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

	// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoop)(&res, &x));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// check underflow
	exps += REALNAME(GetExpS)(&res);
	if (exps <= -(BASES)EXP_BIAS)
	{
		REALNAME(Set0)(num);
		return;
	}

	// check overflow
	if (exps >= (BASES)(EXP_MAX - EXP_BIAS))
	{
		REALNAME(SetInf)(num);
		return;
	}

	// set exponent and copy result
	REALNAME(SetExpS)(&res, exps);
	REALNAME(Copy)(num, &res);
}

//  Function uses 3 temporary numbers in the stack.
EXP REALNAME(Exp_TaylorFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	REAL x, res;
	EXP x_exp, res_exp, num_exp;
	u8 sign;
	EXPS exps;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	num_exp = src_exp & EXPEXT_MASK;

	// number is zero, return 1
	if (num_exp == EXPEXT_0)
	{
		REALNAME(Set1Ext)(num);
		return EXPEXT_1;
	}

	// overflow
	if ((num_exp >= EXPEXT_MAX) || (REALNAME(CompExt)(src, src_exp,
			(const REAL*)&REALNAME(ConstExpMaxExt), REALNAME(ConstExpMaxExt).exp) > 0))
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF;
	}

	// underflow
	if (REALNAME(CompExt)(src, src_exp,
			(const REAL*)&REALNAME(ConstExpMinExt), REALNAME(ConstExpMinExt).exp) < 0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0;
	}

	// get integer part of exponent (integer /ln(2) integer *ln(2) subtract ... multiply)
	x_exp = REALNAME(MulExt)(&x, src, src_exp, (const REAL*)&REALNAME(ConstRLn2Ext), EXPEXT_1); // convert to 2-base x = num / ln(2)
	x_exp = REALNAME(TruncExt)(&x, x_exp);		// truncate (round towards zero)
	exps = REALNAME(GetS32Ext)(&x, x_exp); // get exponent
	x_exp = REALNAME(MulExt)(&x, &x, x_exp, (const REAL*)&REALNAME(ConstLn2Ext), EXPEXT_1 - 1); // convert back to e-base big = int(num / ln(2)) * ln(2)
	num_exp = REALNAME(SubExt)(num, src, src_exp, &x, x_exp);		// subtract integer exponent

	// prepare member
	REALNAME(Set1Ext)(&x);
	x_exp = EXPEXT_1;

	// factorial coefficient -> 0
	faci = 0;

	// result accumulator
	REALNAME(Set1Ext)(&res);
	res_exp = EXPEXT_1;

	// iterations
	do {
		// multiply member by x
		x_exp = REALNAME(MulExt)(&x, &x, x_exp, num, num_exp);

		// increase factorial coefficient
		faci++;

		// divide member by factorial coefficient
		x_exp = REALNAME(DivU16Ext)(&x, &x, x_exp, faci);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

	// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoopExt)(&res, &res_exp, &x, x_exp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// check underflow
	exps += res_exp;
	if (exps <= (EXPS)EXPEXT_0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0;
	}

	// check overflow
	if (exps >= (EXPS)EXPEXT_MAX)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF;
	}

	// copy result
	REALNAME(Copy)(num, &res);

	return exps;
}

//  Function uses 3 temporary numbers in the stack.
void REALNAME(Exp_TaylorFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Exp_TaylorFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                 natural exponent - Chebyshev approximation
// ---------------------------------------------------------------------------
//  Returns number of iteration loops.

#ifdef CHEB_EXP
EXP REALNAME(Exp_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	REAL big;
	EXP num_exp, big_exp;
	EXPS exps;
	u8 sign;

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	num_exp = src_exp & EXPEXT_MASK;

	// number is zero, return 1
	if (num_exp == EXPEXT_0)
	{
		REALNAME(Set1Ext)(num);
		return EXPEXT_1;
	}

	// overflow
	if ((num_exp >= EXPEXT_MAX) || (REALNAME(CompExt)(src, src_exp,
			(const REAL*)&REALNAME(ConstExpMaxExt), REALNAME(ConstExpMaxExt).exp) > 0))
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF;
	}

	// underflow
	if (REALNAME(CompExt)(src, src_exp,
			(const REAL*)&REALNAME(ConstExpMinExt), REALNAME(ConstExpMinExt).exp) < 0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0;
	}

	// get integer part of exponent (integer /ln(2) integer *ln(2) subtract ... multiply)
	big_exp = REALNAME(MulExt)(&big, src, src_exp, (const REAL*)&REALNAME(ConstRLn2Ext), EXPEXT_1); // convert to 2-base big = num / ln(2)
	big_exp = REALNAME(TruncExt)(&big, big_exp);		// truncate (round towards zero)
	exps = REALNAME(GetS32Ext)(&big, big_exp);		// get exponent
	big_exp = REALNAME(MulExt)(&big, &big, big_exp, (const REAL*)&REALNAME(ConstLn2Ext), EXPEXT_1 - 1); // convert back to e-base big = int(num / ln(2)) * ln(2)
	num_exp = REALNAME(SubExt)(num, src, src_exp, &big, big_exp);		// subtract integer exponent
	// mantissa "this" = -0.6931 .. 0.6931 (-ln(2) .. +ln(2))

	// convert to range -1..+1
	num_exp = REALNAME(MulExt)(num, num, num_exp, (const REAL*)&REALNAME(ConstRLn2Ext), EXPEXT_1); // -ln(2)..+ln(2) -> -1..+1

	// calculate function
	num_exp = REALNAME(ChebyshevExt)(num, num_exp, CHEB_EXP, REALNAME(ConstChebExp));

	// check underflow
	exps += num_exp;
	if (exps <= (EXPS)EXPEXT_0)
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0;
	}

	// check overflow
	if (exps >= (EXPS)EXPEXT_MAX)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF;
	}

	return exps;
}

void REALNAME(Exp_ChebyshevFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Exp_ChebyshevFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

#endif // CHEB_EXP > 0

// ---------------------------------------------------------------------------
//                        decimal logarithm
// ---------------------------------------------------------------------------
//  Function uses 5 temporary numbers in the stack.

void REALNAME(Log10From)(REAL* num, const REAL* src)
{
	REALNAME(LnFrom)(num, src);
	REALNAME(Mul)(num, num, &REALNAME(ConstRLn10));
}

// ---------------------------------------------------------------------------
//                      decimal exponent
// ---------------------------------------------------------------------------
//  Function uses 5 temporary numbers in the stack.

void REALNAME(Exp10From)(REAL* num, const REAL* src)
{
	REALNAME(Mul)(num, src, &REALNAME(ConstLn10));
	REALNAME(ExpFrom)(num, src);
}

// ---------------------------------------------------------------------------
//                       binary logarithm
// ---------------------------------------------------------------------------
//  Function uses 5 temporary numbers in the stack.

void REALNAME(Log2From)(REAL* num, const REAL* src)
{
	REALNAME(LnFrom)(num, src);
	REALNAME(Mul)(num, num, &REALNAME(ConstRLn2));
}

// ---------------------------------------------------------------------------
//                         binary exponent
// ---------------------------------------------------------------------------
//  Function uses 5 temporary numbers in the stack.

void REALNAME(Exp2From)(REAL* num, const REAL* src)
{
	REALNAME(Mul)(num, src, &REALNAME(ConstLn2));
	REALNAME(ExpFrom)(num, src);
}

// ---------------------------------------------------------------------------
//                  sqrt (square root) - with logarithm
// ---------------------------------------------------------------------------
//  Function uses 5 temporary numbers in the stack.

void REALNAME(Sqrt_LnFrom_old)(REAL* num, const REAL* src)
{
	BASES exps0, exps;

	// number is 0, result is 0
	if (REALNAME(IsZero)(src))
	{
		REALNAME(Set0)(num);
		return;
	}

	// number is overflow or negative
	if (REALNAME(IsInf)(src) || REALNAME(IsNeg)(src))
	{
		REALNAME(SetInf)(num);
		return;
	}

	// copy number
	REALNAME(Copy)(num, src);

// Note: The split to mantissa and exponent is necessary to prevent loss of precision.

	// prepare exponent / 2
	exps0 = REALNAME(GetExpS)(num);
	exps = exps0 >> 1; // divide / 2, round down
	exps++;
	REALNAME(SetExpS)(num, exps0 - 2*exps); // mantissa will be 0.25..0.9999

	// get logarithm of the number
	REALNAME(Ln_Taylor_old)(num);

	// divide logarithm / 2
	REALNAME(Div2)(num);

	// convert number back to exponent
	REALNAME(Exp_Taylor_old)(num);

	// multiply by exponent / 2
	REALNAME(SetExpS)(num, REALNAME(GetExpS)(num) + exps);
}

//  Function uses 4 temporary numbers in the stack.
EXP REALNAME(Sqrt_LnFromExt)(REAL* num, const REAL* src, EXP exp)
{
	EXPS exps0, exps;
	EXP ex;
	u8 sign;

	// unpack source exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	ex = exp & EXPEXT_MASK;

	// number is 0, result is 0
	if (ex == EXPEXT_0)
	{
		REALNAME(Set0Ext)(num);
		return exp;
	}

	// number is overflow or negative
	if (sign || (ex >= EXPEXT_INF))
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// copy number
	REALNAME(Copy)(num, src);

// Note: The split to mantissa and exponent is necessary to prevent loss of precision.

	// prepare exponent / 2
	exps0 = ex - EXPEXT_BIAS;
	exps = exps0 >> 1; // divide / 2, round down
	exps++;
	ex = exps0 - 2*exps + EXPEXT_BIAS; // mantissa will be 0.25..0.9999

	// get logarithm of the number
	ex = REALNAME(LnExt)(num, ex);

	// divide logarithm / 2
	ex = REALNAME(Div2Ext)(num, ex);

	// convert number back to exponent
	ex = REALNAME(ExpExt)(num, ex);

	// multiply by exponent / 2 (no need to worry about overflow or underflow)
	return ex + exps;
}

//  Function uses 4 temporary numbers in the stack.
void REALNAME(Sqrt_LnFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Sqrt_LnFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                       sqrt (square root) - with Newton
// ---------------------------------------------------------------------------
//  Function uses 5 temporary numbers in the stack.

void REALNAME(Sqrt_NewtonFrom_old)(REAL* num, const REAL* src)
{
	BASES exps;
	REAL m, k;
	int n;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// number is 0, result is 0
	if (REALNAME(IsZero)(src))
	{
		REALNAME(Set0)(num);
		return;
	}

	// number is overflow or negative
	if (REALNAME(IsInf)(src) || REALNAME(IsNeg)(src))
	{
		REALNAME(SetInf)(num);
		return;
	}

	// copy number
	REALNAME(Copy)(num, src);

	// prepare result with exponent / 2
	exps = REALNAME(GetExpS)(num);
	exps >>= 1;

	// preparing the estimate
	REALNAME(Set1)(&m);
	REALNAME(SetExpS)(&m, exps);

	// loop
	n = 2; // additional loops
	do {
		// divide
		REALNAME(Div)(&k, num, &m);

		// add
		REALNAME(Add)(&m, &m, &k);

		// average value
		REALNAME(Div2)(&m);

		// compare and add extra loops if almost equal
		if (REALNAME(CompEps)(&m, &k, 4)) n--;

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

	} while (n >= 0);

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// copy result
	REALNAME(Copy)(num, &m);
}

//  Function uses 4 temporary numbers in the stack.
EXP REALNAME(Sqrt_NewtonFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	EXPS exps;
	REAL m, k;
	u8 sign;
	EXP m_exp, k_exp, num_exp;
	int n;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	num_exp = src_exp & EXPEXT_MASK;

	// number is 0, result is 0
	if (num_exp == EXPEXT_0)
	{
		REALNAME(Set0Ext)(num);
		return src_exp;
	}

	// number is overflow or negative
	if (sign || (num_exp >= EXPEXT_INF))
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// copy number
	REALNAME(Copy)(num, src);

	// prepare result with exponent / 2
	exps = num_exp - EXPEXT_BIAS;
	exps >>= 1;

	// preparing the estimate
	REALNAME(Set1Ext)(&m);
	m_exp = exps + EXPEXT_BIAS;

	// loop
	n = 2; // additional loops
	do {
		// divide
		k_exp = REALNAME(DivExt)(&k, num, num_exp, &m, m_exp);

		// add
		m_exp = REALNAME(AddExt)(&m, &m, m_exp, &k, k_exp);

		// average value
		m_exp = REALNAME(Div2Ext)(&m, m_exp);

		// compare and add extra loops if almost equal
		if (REALNAME(CompEpsExt)(&m, m_exp, &k, k_exp, 4)) n--;

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

	} while (n >= 0);

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// copy result
	REALNAME(Copy)(num, &m);

	return m_exp;
}

//  Function uses 4 temporary numbers in the stack.
void REALNAME(Sqrt_NewtonFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Sqrt_NewtonFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                       sqrt (square root) - with Taylor serie
// ---------------------------------------------------------------------------
// Uses Taylor serie: D = x-1, sqrt(x) = 1 + D/2 - D^2/8 + D^3/16 - 5*D^4/128 + 7*D^5/256 - ...
//     sqrt(x) = 1 + 1/2*D - 1/(2*4)*D^2 + (1*3)/(2*4*6)*D^3 - (1*3*5)/(2*4*6*8)*D^4 +
//  x must be 0..2
//  Function uses 5 temporary numbers in the stack.

void REALNAME(Sqrt_TaylorFrom_old)(REAL* num, const REAL* src)
{
	BASES exps0, exps;
	REAL x, res;
	u16 faci;
	Bool sqrt2;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// number is 0, result is 0
	if (REALNAME(IsZero)(src))
	{
		REALNAME(Set0)(num);
		return;
	}

	// number is overflow or negative
	if (REALNAME(IsInf)(src) || REALNAME(IsNeg)(src))
	{
		REALNAME(SetInf)(num);
		return;
	}

	// copy number
	REALNAME(Copy)(num, src);

	// prepare exponent / 2
	exps0 = REALNAME(GetExpS)(num); // exponent 0 -> value 1.0 .. 1.9999 (1 -> 2..3.999, 2 -> 4..7.999)
	exps = exps0 >> 1; // divide / 2, round down, to shift to interval 1 .. 3.9999
	exps++; // to shift to interval  (0.25 .. 0.9999)
	exps0 -= exps*2; // shift to interval 0.25..0.9999
	sqrt2 = False;
	if (exps0 == -2) // interval 0.25 .. 0.4999 is slow
	{
		exps0++;	// shift to interval 0.5..0.9999
		sqrt2 = True; // must divide result /sqrt2
	}
	REALNAME(SetExpS)(num, exps0); // mantissa (=x) will be 0.5..0.9999

	// prepare D = x - 1 (D must be in range -1..+1)
	REALNAME(Dec)(num);

	// prepare member x = 1/2*D
	REALNAME(Copy)(&x, num);
	REALNAME(Div2)(&x);

	// prepare result res = 1 + 1/2*D
	REALNAME(Set1)(&res);
	REALNAME(Add)(&res, &res, &x);

	// negate D
	REALNAME(Neg)(num);

	// factorial coefficient -> 2
	faci = 2;

	// iterations
	do {
		// multiply member by D
		REALNAME(Mul)(&x, &x, num);

		// multiply member by factorial coefficient
		REALNAME(MulUInt)(&x, &x, faci-1);

		// increase factorial coefficient
		faci += 2;

		// divide member by factorial coefficient
		REALNAME(DivU16)(&x, &x, faci);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoop)(&res, &x));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// multiply by exponent / 2
	REALNAME(SetExpS)(&res, REALNAME(GetExpS)(&res) + exps);

	// divide by sqrt2
	if (sqrt2) REALNAME(Mul)(&res, &res, &REALNAME(ConstRSqrt2));

	// copy result
	REALNAME(Copy)(num, &res);
}

//  Function uses 4 temporary numbers in the stack.
EXP REALNAME(Sqrt_TaylorFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	EXPS exps0, exps;
	REAL x, res;
	EXP x_exp, res_exp, num_exp;
	u8 sign;
	u16 faci;
	Bool sqrt2;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	num_exp = src_exp & EXPEXT_MASK;

	// number is 0, result is 0
	if (num_exp == EXPEXT_0)
	{
		REALNAME(Set0Ext)(num);
		return src_exp;
	}

	// number is overflow or negative
	if (sign || (num_exp >= EXPEXT_INF))
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// copy number
	REALNAME(Copy)(num, src);

	// prepare exponent / 2
	exps0 = num_exp - EXPEXT_BIAS; // exponent 0 -> value 1.0 .. 1.9999 (1 -> 2..3.999, 2 -> 4..7.999)
	exps = exps0 >> 1; // divide / 2, round down, to shift to interval 1 .. 3.9999
	exps++; // to shift to interval  (0.25 .. 0.9999)
	exps0 -= exps*2; // shift to interval 0.25..0.9999
	sqrt2 = False;
	if (exps0 == -2) // interval 0.25 .. 0.4999 is slow
	{
		exps0++;	// shift to interval 0.5..0.9999
		sqrt2 = True; // must divide result /sqrt2
	}
	num_exp = exps0 + EXPEXT_BIAS; // mantissa (=x) will be 0.5..0.9999

	// prepare D = x - 1 (D must be in range -1..+1)
	num_exp = REALNAME(DecExt)(num, num_exp);

	// prepare member x = 1/2*D
	REALNAME(Copy)(&x, num);
	x_exp = REALNAME(Div2Ext)(&x, num_exp);

	// prepare result res = 1 + 1/2*D
	REALNAME(Set1Ext)(&res);
	res_exp = REALNAME(AddExt)(&res, &res, EXPEXT_1, &x, x_exp);

	// negate D
	num_exp ^= EXPEXT_SIGN;

	// factorial coefficient -> 2
	faci = 2;

	// iterations
	do {
		// multiply member by D
		x_exp = REALNAME(MulExt)(&x, &x, x_exp, num, num_exp);

		// multiply member by factorial coefficient
		x_exp = REALNAME(MulUIntExt)(&x, &x, x_exp, faci-1);

		// increase factorial coefficient
		faci += 2;

		// divide member by factorial coefficient
		x_exp = REALNAME(DivU16Ext)(&x, &x, x_exp, faci);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoopExt)(&res, &res_exp, &x, x_exp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// multiply by exponent / 2
	res_exp += exps;

	// divide by sqrt2
	if (sqrt2) res_exp = REALNAME(MulExt)(&res, &res, res_exp, (const REAL*)&REALNAME(ConstRSqrt2Ext), EXPEXT_1 - 1);

	// copy result
	REALNAME(Copy)(num, &res);

	return res_exp;
}

//  Function uses 4 temporary numbers in the stack.
void REALNAME(Sqrt_TaylorFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Sqrt_TaylorFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                     sqrt (square root) - with Chebyshev
// ---------------------------------------------------------------------------
//  Returns number of iteration loops.

#ifdef CHEB_SQRT
EXP REALNAME(Sqrt_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	EXPS exps0, exps;
	EXP num_exp;
	u8 sign;

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	num_exp = src_exp & EXPEXT_MASK;

	// number is 0, result is 0
	if (num_exp == EXPEXT_0)
	{
		REALNAME(Set0Ext)(num);
		return src_exp;
	}

	// number is overflow or negative
	if (sign || (num_exp >= EXPEXT_INF))
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// copy number
	REALNAME(Copy)(num, src);

	// prepare exponent / 2
	exps0 = num_exp - EXPEXT_BIAS;
	exps = exps0 >> 1; // divide / 2, round down
	num_exp = exps0 - 2*exps + EXPEXT_BIAS; // mantissa will be 1..3.9999

	// convert to range -1..+1
	num_exp = REALNAME(DecExt)(num, num_exp); // 1..4 -> 0..3
	num_exp = REALNAME(MulExt)(num, num, num_exp, (const REAL*)&REALNAME(Const83Ext), EXPEXT_1 + 1); // *8/3, 0..3 -> 0..8
	num_exp = REALNAME(Pow2Ext)(num, num_exp, -2); // 0..8 -> 0..2
	num_exp = REALNAME(DecExt)(num, num_exp); // 0..+2 -> -1..+1

	// calculate function
	num_exp = REALNAME(ChebyshevExt)(num, num_exp, CHEB_SQRT, REALNAME(ConstChebSqrt));

	// multiply by exponent
	num_exp += exps;

	return num_exp;
}

void REALNAME(Sqrt_ChebyshevFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Sqrt_ChebyshevFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}
#endif // CHEB_SQRT > 0

// ---------------------------------------------------------------------------
//          convert angle from current angle unit to radians
// ---------------------------------------------------------------------------

void REALNAME(ToRad)(REAL* num)
{
	if (Unit == UNIT_RAD) return;
	if (Unit == UNIT_DEG)
		REALNAME(Mul)(num, num, &REALNAME(ConstPi180));
	else
		REALNAME(Mul)(num, num, &REALNAME(ConstPi200));
}

EXP REALNAME(ToRadExt)(REAL* num, EXP exp)
{
	if (Unit == UNIT_RAD) return exp;
	if (Unit == UNIT_DEG)
		return REALNAME(MulExt)(num, num, exp, (const REAL*)&REALNAME(ConstPi180Ext), EXPEXT_1 - 6);
	else
		return REALNAME(MulExt)(num, num, exp, (const REAL*)&REALNAME(ConstPi200Ext), EXPEXT_1 - 6);
}

// ---------------------------------------------------------------------------
//           convert angle from radians to current angle unit
// ---------------------------------------------------------------------------

void REALNAME(FromRad)(REAL* num)
{
	if (Unit == UNIT_RAD) return;
	if (Unit == UNIT_DEG)
		REALNAME(Mul)(num, num, &REALNAME(Const180Pi));
	else
		REALNAME(Mul)(num, num, &REALNAME(Const200Pi));
}

EXP REALNAME(FromRadExt)(REAL* num, EXP exp)
{
	if (Unit == UNIT_RAD) return exp;
	if (Unit == UNIT_DEG)
		return REALNAME(MulExt)(num, num, exp, (const REAL*)&REALNAME(Const180PiExt), EXPEXT_1 + 5);
	else
		return REALNAME(MulExt)(num, num, exp, (const REAL*)&REALNAME(Const200PiExt), EXPEXT_1 + 5);
}

// ---------------------------------------------------------------------------
//      normalize angle in radians - unsigned, to range 0..PI*2 (0..360°)
// ---------------------------------------------------------------------------
//  Function uses 4 temporary numbers in the stack.

void REALNAME(NormRadU)(REAL* num)
{
	// big number (> 10*(PI*2)), use modulo
	if (REALNAME(GetExpS)(num) >= 6) 
		REALNAME(ModFloor)(num, num, &REALNAME(ConstPi2));
	else
	{
		// limit if < 0
		//   The correction <0 is preferred first, because the small number + 2*PI can be equal to 2*PI.
		while (REALNAME(IsNeg)(num))
				REALNAME(Add)(num, num, &REALNAME(ConstPi2));

		// limit if >= PI*2
		while (REALNAME(Comp)(num, &REALNAME(ConstPi2)) >= 0)
				REALNAME(Add)(num, num, &REALNAME(ConstMPi2));
	}
}

//  Function uses 3 temporary numbers in the stack.
EXP REALNAME(NormRadUExt)(REAL* num, EXP exp)
{
	// big number (> 10*(PI*2)), use modulo
	if ((exp & EXPEXT_MASK) >= EXPEXT_BIAS + 6) 
		return REALNAME(ModFloorExt)(num, num, exp, (const REAL*)&REALNAME(ConstPi2Ext), EXPEXT_1 + 2);
	else
	{
		// limit if < 0
		//   The correction <0 is preferred first, because the small number + 2*PI can be equal to 2*PI.
		while ((exp & EXPEXT_SIGN) != 0)
				exp = REALNAME(AddExt)(num, num, exp, (const REAL*)&REALNAME(ConstPi2Ext), EXPEXT_1 + 2);

		// limit if >= PI*2
		while (REALNAME(CompExt)(num, exp, (const REAL*)&REALNAME(ConstPi2Ext), EXPEXT_1 + 2) >= 0)
				exp = REALNAME(AddExt)(num, num, exp, (const REAL*)&REALNAME(ConstMPi2Ext), (EXPEXT_1 + 2) | EXPEXT_SIGN);
	}
	return exp;
}

// ---------------------------------------------------------------------------
//  normalize angle in radians - signed, to range -PI..+PI (-180°..+180°)
// ---------------------------------------------------------------------------
//  Function uses 4 temporary numbers in the stack.

void REALNAME(NormRadS)(REAL* num)
{
	// big number (> 10*(PI*2)), use modulo
	if (REALNAME(GetExpS)(num) >= 6) 
		REALNAME(ModRound)(num, num, &REALNAME(ConstPi2));
	else
	{
		// limit if < -PI
		while (REALNAME(Comp)(num, &REALNAME(ConstMPi)) < 0)
				REALNAME(Add)(num, num, &REALNAME(ConstPi2));

		// limit if >= PI
		while (REALNAME(Comp)(num, &REALNAME(ConstPi)) >= 0)
				REALNAME(Add)(num, num, &REALNAME(ConstMPi2));
	}
}

//  Function uses 3 temporary numbers in the stack.
EXP REALNAME(NormRadSExt)(REAL* num, EXP exp)
{
	// big number (> 10*(PI*2)), use modulo
	if ((exp & EXPEXT_MASK) >= EXPEXT_BIAS + 6) 
		return REALNAME(ModRoundExt)(num, num, exp, (const REAL*)&REALNAME(ConstPi2Ext), EXPEXT_1 + 2);
	else
	{
		// limit if < -PI
		while (REALNAME(CompExt)(num, exp, (const REAL*)&REALNAME(ConstMPiExt), (EXPEXT_1 + 1) | EXPEXT_SIGN) < 0)
				exp = REALNAME(AddExt)(num, num, exp, (const REAL*)&REALNAME(ConstPi2Ext), EXPEXT_1 + 2);

		// limit if >= PI
		while (REALNAME(CompExt)(num, exp, (const REAL*)&REALNAME(ConstPiExt), EXPEXT_1 + 1) >= 0)
				exp = REALNAME(AddExt)(num, num, exp, (const REAL*)&REALNAME(ConstMPi2Ext), (EXPEXT_1 + 2) | EXPEXT_SIGN);
	}
	return exp;
}

// ---------------------------------------------------------------------------
//                       sine - Taylor serie
// ---------------------------------------------------------------------------
//  Taylor serie xi+1 = xi * -x^2/((2*i)*(2*i+1)) ... x0 = x
//  sin(x) = x/1! - x^3/3! + x^5/5! - x^7/7! + x^9/9! - ...
//  Function uses 6 temporary numbers in the stack.

void REALNAME(Sin_TaylorFrom_old)(REAL* num, const REAL* src)
{
	Bool neg;
	REAL x2, res;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// copy source
	REALNAME(Copy)(num, src);

	// normalize angle into range 0..PI*2
	//  Function uses 4 temporary numbers in the stack.
	REALNAME(NormRadU)(num);

	// normalize angle into range 0..PI
	neg = False;
	if (REALNAME(Comp)(num, &REALNAME(ConstPi)) >= 0) // if angle >= PI
	{
		REALNAME(Sub)(num, &REALNAME(ConstPi2), num); // correction angle = PI*2 - angle
		neg = True; // negate result
	}

	// number is zero or PI, result will be zero
	if (REALNAME(IsZero)(num) ||
		REALNAME(CompEps)(num, &REALNAME(ConstPi), 4))
	{
		REALNAME(Set0)(num);
		return;
	}

	// square -x^2
	REALNAME(SqrFrom)(&x2, num);
	REALNAME(Neg)(&x2);

	// prepare result accumulator -> x
	REALNAME(Copy)(&res, num);

	// factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by -x^2
		REALNAME(Mul)(num, num, &x2);

		// increment factorial coefficient
		faci++;

		// divide member by factorial coefficient
		if (faci > 255)
		{
			REALNAME(DivU16)(num, num, faci);
			REALNAME(DivU16)(num, num, faci+1);
		}
		else
			REALNAME(DivU16)(num, num, faci*(faci+1));

		// increment factorial coefficient
		faci++;

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoop)(&res, num));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// limit range to -1..+1 (result may be a little out of range)
	if (REALNAME(Comp)(&res, &REALNAME(Const1)) > 0) REALNAME(Set1)(&res);

	// negate result
	if (neg) REALNAME(Neg)(&res);

	// copy result
	REALNAME(Copy)(num, &res);
}

//  Function uses 5 temporary numbers in the stack.
EXP REALNAME(Sin_TaylorFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	REAL x2, res;
	EXP x2_exp, res_exp, num_exp;
	u8 sign;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// copy source
	REALNAME(Copy)(num, src);

	// overflow
	if ((src_exp & EXPEXT_MASK) >= EXPEXT_INF) return src_exp;

	// normalize angle into range -PI..+PI
	//  Function uses 3 temporary numbers in the stack.
	num_exp = REALNAME(NormRadSExt)(num, src_exp);

	// unpack source exponent, normalize into range 0..+PI
	sign = (u8)(num_exp >> EXPEXT_BITS); // sign = flag to negate result
	num_exp &= EXPEXT_MASK; // absolute value

	// normalize angle into range 0..PI/2
	if (REALNAME(CompExt)(num, num_exp, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1) >= 0) // if angle >= PI/2
	{
		num_exp = REALNAME(SubExt)(num, (const REAL*)&REALNAME(ConstPiExt), EXPEXT_1 + 1, num, num_exp); // correction angle = PI - angle
	}

	// case of small angles (< 2^(-bits/2), including zero): sin(angle) = angle
	if ((num_exp & EXPEXT_MASK) < EXPEXT_1 - REAL_BITS/2)
		return num_exp ^ ((EXP)sign << EXPEXT_BITS);

	// square -x^2
	x2_exp = REALNAME(SqrFromExt)(&x2, num, num_exp) ^ EXPEXT_SIGN;

	// prepare result accumulator -> x
	REALNAME(Copy)(&res, num);
	res_exp = num_exp;

	// factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by -x^2
		num_exp = REALNAME(MulExt)(num, num, num_exp, &x2, x2_exp);

		// increment factorial coefficient
		faci++;

		// divide member by factorial coefficient
		if (faci > 255)
		{
			num_exp = REALNAME(DivU16Ext)(num, num, num_exp, faci);
			num_exp = REALNAME(DivU16Ext)(num, num, num_exp, faci+1);
		}
		else
			num_exp = REALNAME(DivU16Ext)(num, num, num_exp, faci*(faci+1));

		// increment factorial coefficient
		faci++;

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoopExt)(&res, &res_exp, num, num_exp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// limit range to -1..+1 (result may be a little out of range)
	if (REALNAME(CompExt)(&res, res_exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1) > 0)
	{
		REALNAME(Set1Ext)(&res);
		res_exp = EXPEXT_1;
	}

	// copy result
	REALNAME(Copy)(num, &res);

	return res_exp ^ ((EXP)sign << EXPEXT_BITS);
}

//  Function uses 5 temporary numbers in the stack.
void REALNAME(Sin_TaylorFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Sin_TaylorFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                       sine/cosine - Taylor serie
// ---------------------------------------------------------------------------
//  Taylor serie sin(x): xi+1 = xi * -x^2/((2*i)*(2*i+1)) ... x0 = x
//  Taylor serie cos(x): xi+1 = xi * -x^2/((2*i-1)*(2*i)) ... x0 = 1
//  sin(x) = x/1! - x^3/3! + x^5/5! - x^7/7! + x^9/9! - ...
//         = x*(1/1! - x^2/3! + x^4/5! - x^6/7! + x^8/9! - ...)
//  cos(x) = 1/1! - x^2/2! + x^4/4! - x^6/6! + x^8/8! - ...
//  Function uses 7 temporary numbers in the stack.
//  If sin_num and cos_num point to the same number, result is undefined.
//  Returns exponent of the sine.

EXP REALNAME(SinCos_TaylorFromExt)(REAL* sin_num, REAL* cos_num, EXP* cos_exp, const REAL* src, EXP src_exp)
{
	REAL x2, mem, x0;
	EXP x2_exp, mem_exp, x0_exp, sinnum_exp, cosnum_exp;
	u8 sin_sign, cos_sign;
	u16 faci;
	Bool sinok, cosok;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// overflow
	if ((src_exp & EXPEXT_MASK) >= EXPEXT_INF)
	{
		REALNAME(Copy)(sin_num, src);
		REALNAME(Copy)(cos_num, src);
		*cos_exp = src_exp;
		return src_exp;
	}

	// copy source to x0
	REALNAME(Copy)(&x0, src);

	// normalize angle into range -PI..+PI
	//  Function uses 3 temporary numbers in the stack.
	x0_exp = REALNAME(NormRadSExt)(&x0, src_exp);

	// unpack source exponent, normalize into range 0..+PI
	sin_sign = (u8)(x0_exp >> EXPEXT_BITS); // sign = flag to negate result
	x0_exp &= EXPEXT_MASK; // absolute value

	// normalize angle into range 0..PI/2
	cos_sign = 0;
	if (REALNAME(CompExt)(&x0, x0_exp, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1) >= 0) // if angle >= PI/2
	{
		cos_sign = 1;
		x0_exp = REALNAME(SubExt)(&x0, (const REAL*)&REALNAME(ConstPiExt), EXPEXT_1 + 1, &x0, x0_exp); // correction angle = PI - angle
	}

	// case of small angles (< 2^(-bits/2), including zero): sin(angle) = angle, cos(angle) = 1
	if ((x0_exp & EXPEXT_MASK) < EXPEXT_1 - REAL_BITS/2)
	{
		REALNAME(Copy)(sin_num, &x0);
		REALNAME(Set1Ext)(cos_num);
		*cos_exp = EXPEXT_1 | ((EXP)cos_sign << EXPEXT_BITS);
		return x0_exp ^ ((EXP)sin_sign << EXPEXT_BITS);
	}

	// square -x^2
	x2_exp = REALNAME(SqrFromExt)(&x2, &x0, x0_exp) ^ EXPEXT_SIGN;

	// prepare member, set to -x^2
	REALNAME(Copy)(&mem, &x2);

	// divide member / 2 (= -x^2/2!) and add it to cosine accumulator (which is == 1)
	mem_exp = REALNAME(Div2Ext)(&mem, x2_exp);
	cosnum_exp = REALNAME(IncFromExt)(cos_num, &mem, mem_exp);

	// divide member / 3 (= -x^2/3!) and add it to sine accumulator (which is == 1)
	mem_exp = REALNAME(DivU16Ext)(&mem, &mem, mem_exp, 3);
	sinnum_exp = REALNAME(IncFromExt)(sin_num, &mem, mem_exp);

	// factorial coefficient -> 3
	faci = 3;

	// iterations
	sinok = True;
	cosok = True;
	do {
		// multiply member by -x^2
		mem_exp = REALNAME(MulExt)(&mem, &mem, mem_exp, &x2, x2_exp);

		// increment factorial coefficient
		faci++;

		// divide member by factorial coefficient
		mem_exp = REALNAME(DivU16Ext)(&mem, &mem, mem_exp, faci);

		// add member to cosine accumulator
		if (cosok) cosok = REALNAME(AddLoopExt)(cos_num, &cosnum_exp, &mem, mem_exp);

		// increment factorial coefficient
		faci++;

		// divide member by factorial coefficient
		mem_exp = REALNAME(DivU16Ext)(&mem, &mem, mem_exp, faci);

		// add member to sine accumulator
		if (sinok) sinok = REALNAME(AddLoopExt)(sin_num, &sinnum_exp, &mem, mem_exp);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// continue loop
	} while (cosok || sinok);

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// multiply sine by x0
	sinnum_exp = REALNAME(MulExt)(sin_num, sin_num, sinnum_exp, &x0, x0_exp);

	// limit range to -1..+1 (result may be a little out of range)
	if (REALNAME(CompExt)(sin_num, sinnum_exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1) > 0)
	{
		REALNAME(Set1Ext)(sin_num);
		sinnum_exp = EXPEXT_1;
	}

	if (REALNAME(CompExt)(cos_num, cosnum_exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1) > 0)
	{
		REALNAME(Set1Ext)(cos_num);
		cosnum_exp = EXPEXT_1;
	}

	// signum
	*cos_exp = cosnum_exp ^ ((EXP)cos_sign << EXPEXT_BITS);
	return sinnum_exp ^ ((EXP)sin_sign << EXPEXT_BITS);
}

void REALNAME(SinCos_TaylorFrom)(REAL* sin_num, REAL* cos_num, const REAL* src)
{
	EXP exp, exp2;
	exp = REALNAME(Unpack)(src, sin_num);
	exp = REALNAME(SinCos_TaylorFromExt)(sin_num, cos_num, &exp2, sin_num, exp);
	REALNAME(Pack)(sin_num, sin_num, exp);
	REALNAME(Pack)(cos_num, cos_num, exp2);
}

// ---------------------------------------------------------------------------
//                      sine - Chebyshev approximation
// ---------------------------------------------------------------------------

#ifdef CHEB_SIN
EXP REALNAME(Sin_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	u8 sign;
	EXP num_exp;

	// small angles are inaccurate, use Taylor instead
#if REAL_BITS <= 16 // real16 (exp: 5 bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 4) // 3.5 deg
#elif REAL_BITS <= 24 // real24 (exp: 6 bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 5) // 2 deg
#elif REAL_BITS <= 32 // real32 (exp: 8 bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 6) // 1 deg
#elif REAL_BITS <= 40 // real40 (exp: 9 bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 7) // 0.5 deg
#else // >= real48 (exp: 10 and more bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 8) // 0.2 deg
#endif
		return REALNAME(Sin_TaylorFromExt)(num, src, src_exp);

	// copy source
	REALNAME(Copy)(num, src);

	// normalize angle into range -PI..+PI
	//  Function uses 3 temporary numbers in the stack.
	num_exp = REALNAME(NormRadSExt)(num, src_exp);

	// unpack source exponent, normalize into range 0..+PI
	sign = (u8)(num_exp >> EXPEXT_BITS); // sign = flag to negate result
	num_exp &= EXPEXT_MASK; // absolute value

	// normalize angle into range 0..PI/2
	if (REALNAME(CompExt)(num, num_exp, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1) >= 0) // if angle >= PI/2
	{
		num_exp = REALNAME(SubExt)(num, (const REAL*)&REALNAME(ConstPiExt), EXPEXT_1 + 1, num, num_exp); // correction angle = PI - angle
	}

	// case of small angles (< 2^(-bits/2), including zero): sin(angle) = angle
	if ((num_exp & EXPEXT_MASK) < EXPEXT_1 - REAL_BITS/2)
		return num_exp ^ ((EXP)sign << EXPEXT_BITS);

	// convert 0..PI/2 to range -1..+1
	num_exp = REALNAME(MulExt)(num, num, num_exp, (const REAL*)&REALNAME(ConstRPi2Ext), EXPEXT_1 - 3); // 0..PI/2 -> 0..1/4
	num_exp = REALNAME(Pow2Ext)(num, num_exp, 3); // 0..1/4 -> 0..2
	num_exp = REALNAME(DecExt)(num, num_exp); // 0..2 -> -1..+1

	// calculate function
	num_exp = REALNAME(ChebyshevExt)(num, num_exp, CHEB_SIN, REALNAME(ConstChebSin));

	// limit range to -1..+1 (result may be a little out of range)
	if (REALNAME(CompExt)(num, num_exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1) > 0)
	{
		REALNAME(Set1Ext)(num);
		num_exp = EXPEXT_1;
	}

	return num_exp ^ ((EXP)sign << EXPEXT_BITS);
}

void REALNAME(Sin_ChebyshevFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Sin_ChebyshevFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

#endif // CHEB_SIN > 0

// ---------------------------------------------------------------------------
//                             sine/cosine - Cordic
// ---------------------------------------------------------------------------

#ifdef CORD_ATAN
EXP REALNAME(SinCos_CordicFromExt)(REAL* sin_num, REAL* cos_num, EXP* cos_exp, const REAL* src, EXP src_exp)
{
	EXP exp;
	REAL sin_delta, cos_delta, angle, angle_delta;
	u8 sin_sign, cos_sign;
	int sigma, sin_sigma, cos_sigma, i, sin_sigma2, cos_sigma2;
	const REAL* tab;

	// small angles are inaccurate, use Taylor instead
#if REAL_BITS <= 16 // real16 (exp: 5 bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 4) // 3.5 deg
#elif REAL_BITS <= 24 // real24 (exp: 6 bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 5) // 2 deg
#elif REAL_BITS <= 32 // real32 (exp: 8 bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 6) // 1 deg
#elif REAL_BITS <= 40 // real40 (exp: 9 bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 7) // 0.5 deg
#else // >= real48 (exp: 10 and more bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 8) // 0.2 deg
#endif
		return REALNAME(SinCos_TaylorFromExt)(sin_num, cos_num, cos_exp, src, src_exp);

	// overflow
	if ((src_exp & EXPEXT_MASK) >= EXPEXT_INF)
	{
		REALNAME(Copy)(sin_num, src);
		REALNAME(Copy)(cos_num, src);
		*cos_exp = src_exp;
		return src_exp;
	}

	// copy source
	REALNAME(Copy)(&angle, src);

	// normalize angle into range -PI..+PI
	//  Function uses 3 temporary numbers in the stack.
	exp = REALNAME(NormRadSExt)(&angle, src_exp);

	// unpack source exponent, normalize into range 0..+PI
	sin_sign = (u8)(exp >> EXPEXT_BITS); // sign = flag to negate result
	exp &= EXPEXT_MASK; // absolute value

	// normalize angle into range 0..PI/2
	cos_sign = 0;
	if (REALNAME(CompExt)(&angle, exp, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1) >= 0) // if angle >= PI/2
	{
		cos_sign = 1;
		exp = REALNAME(SubExt)(&angle, (const REAL*)&REALNAME(ConstPiExt), EXPEXT_1 + 1, &angle, exp); // correction angle = PI - angle
	}

	// case of small angles (< 2^(-bits/2), including zero): sin(angle) = angle, cos(angle) = 1
	if ((exp & EXPEXT_MASK) < EXPEXT_1 - REAL_BITS/2)
	{
		REALNAME(Set1Ext)(cos_num);
		*cos_exp = EXPEXT_1 | ((EXP)cos_sign << EXPEXT_BITS);
		REALNAME(Copy)(sin_num, &angle);
		return exp ^ ((EXP)sin_sign << EXPEXT_BITS);
	}

	// denormalize angle to 1-base
	if (exp != EXPEXT_1) REALNAME(MantR)(&angle, 0, EXPEXT_1 - exp);

	// initialize vector projections
	REALNAME(Set0Ext)(sin_num); // set Y (=sin) to 0
	REALNAME(Copy)(cos_num, &REALNAME(ConstAtanInit)); // set X (=cos) to initial value
	sigma = 0;
	sin_sigma = 0;
	cos_sigma = 0;

	// iterations - tabled part
	tab = &REALNAME(ConstAtan)[0];
	for (i = 0; i < CORD_ATAN; i++)
	{
		// prepare deltas
		REALNAME(Copy)(&sin_delta, sin_num);
		sin_sigma2 = (sin_sigma < 0) ? -1 : 0;
		REALNAME(MantR)(&sin_delta, sin_sigma2, i);
		REALNAME(Copy)(&cos_delta, cos_num);
		cos_sigma2 = (cos_sigma < 0) ? -1 : 0;
		REALNAME(MantR)(&cos_delta, cos_sigma2, i);

		// angle is negative
		if (sigma < 0)
		{
			// add X (=cos), sub Y (=sin)
			cos_sigma += REALNAME(MantAdd)(cos_num, &sin_delta, 0) + sin_sigma2;
			sin_sigma -= REALNAME(MantSub)(sin_num, &cos_delta, 0) + cos_sigma2;

			// add table to angle
			sigma += REALNAME(MantAdd)(&angle, tab, 0);
		}

		// angle is positive or zero
		else
		{
			// sub X (=cos), add Y (=sin)
			cos_sigma -= REALNAME(MantSub)(cos_num, &sin_delta, 0) + sin_sigma2;
			sin_sigma += REALNAME(MantAdd)(sin_num, &cos_delta, 0) + cos_sigma2;

			// subtract table from angle
			sigma -= REALNAME(MantSub)(&angle, tab, 0);
		}

		// shift table pointer
		tab++;
	}

	// load last table delta
	REALNAME(Copy)(&angle_delta, &tab[-1]);

	// iterations - hidden table
	for (; i < REAL_BITS; i++)
	{
		// shift delta value
		REALNAME(MantR1)(&angle_delta, 0);

		// prepare deltas
		REALNAME(Copy)(&sin_delta, sin_num);
		sin_sigma2 = (sin_sigma < 0) ? -1 : 0;
		REALNAME(MantR)(&sin_delta, sin_sigma2, i);
		REALNAME(Copy)(&cos_delta, cos_num);
		cos_sigma2 = (cos_sigma < 0) ? -1 : 0;
		REALNAME(MantR)(&cos_delta, cos_sigma2, i);

		// angle is negative
		if (sigma < 0)
		{
			// add X (=cos), sub Y (=sin)
			cos_sigma += REALNAME(MantAdd)(cos_num, &sin_delta, 0) + sin_sigma2;
			sin_sigma -= REALNAME(MantSub)(sin_num, &cos_delta, 0) + cos_sigma2;

			// add table to angle
			sigma += REALNAME(MantAdd)(&angle, &angle_delta, 0);
		}

		// angle is positive or zero
		else
		{
			// sub X (=cos), add Y (=sin)
			cos_sigma -= REALNAME(MantSub)(cos_num, &sin_delta, 0) + sin_sigma2;
			sin_sigma += REALNAME(MantAdd)(sin_num, &cos_delta, 0) + cos_sigma2;

			// subtract table from angle
			sigma -= REALNAME(MantSub)(&angle, &angle_delta, 0);
		}
	}

	// number of iterations
#if DEB_LOOPNUM
	Deb_LoopNum += REAL_BITS;	// number of iteration loops
#endif

	// underflow correction
	if (sin_sigma < 0) REALNAME(Set0Ext)(sin_num);
	if (cos_sigma < 0) REALNAME(Set0Ext)(cos_num);

	// normalize cosine result
	i = REALNAME(MantNormExt)(cos_num);
	if (i >= REAL_BITS)
	{
		REALNAME(Set0Ext)(cos_num);
		*cos_exp = EXPEXT_0;
	}
	else
		*cos_exp = EXPEXT_1 - i;

	// normalize sine result
	i = REALNAME(MantNormExt)(sin_num);
	if (i >= REAL_BITS)
	{
		REALNAME(Set0Ext)(sin_num);
		exp = EXPEXT_0;
	}
	else
		exp = EXPEXT_1 - i;

	// limit range to -1..+1 (result may be a little out of range)
	if (REALNAME(CompExt)(sin_num, exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1) > 0)
	{
		REALNAME(Set1Ext)(sin_num);
		exp = EXPEXT_1;
	}

	if (REALNAME(CompExt)(cos_num, *cos_exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1) > 0)
	{
		REALNAME(Set1Ext)(cos_num);
		*cos_exp = EXPEXT_1;
	}

	// set signs
	*cos_exp |= ((EXP)cos_sign << EXPEXT_BITS);
	return exp | ((EXP)sin_sign << EXPEXT_BITS);
}

void REALNAME(SinCos_CordicFrom)(REAL* sin_num, REAL* cos_num, const REAL* src)
{
	EXP exp, exp2;
	exp = REALNAME(Unpack)(src, sin_num);
	exp = REALNAME(SinCos_CordicFromExt)(sin_num, cos_num, &exp2, sin_num, exp);
	REALNAME(Pack)(sin_num, sin_num, exp);
	REALNAME(Pack)(cos_num, cos_num, exp2);
}

EXP REALNAME(Sin_CordicFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	REAL cos_num;
	EXP exp2;
	return REALNAME(SinCos_CordicFromExt)(num, &cos_num, &exp2, src, src_exp);
}

void REALNAME(Sin_CordicFrom)(REAL* num, const REAL* src)
{
	EXP exp, exp2;
	REAL cos_num;
	exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(SinCos_CordicFromExt)(num, &cos_num, &exp2, num, exp);
	REALNAME(Pack)(num, num, exp);
}

EXP REALNAME(Cos_CordicFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	REAL sin_num;
	EXP exp, exp2;
	exp = REALNAME(SinCos_CordicFromExt)(&sin_num, num, &exp2, src, src_exp);
	return exp2;
}

void REALNAME(Cos_CordicFrom)(REAL* num, const REAL* src)
{
	EXP exp, exp2;
	REAL sin_num;
	exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(SinCos_CordicFromExt)(&sin_num, num, &exp2, num, exp);
	REALNAME(Pack)(num, num, exp2);
}

#endif

// ---------------------------------------------------------------------------
//                          cosine - Taylor serie
// ---------------------------------------------------------------------------
//  Function uses 6 temporary numbers in the stack.

EXP REALNAME(Cos_TaylorFromExt)(REAL* num, const REAL* src, EXP exp)
{
	exp = REALNAME(AddExt)(num, src, exp, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1);
	return REALNAME(Sin_TaylorFromExt)(num, num, exp);
}

void REALNAME(Cos_TaylorFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Cos_TaylorFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

void REALNAME(Cos_TaylorFrom_old)(REAL* num, const REAL* src)
{
	REALNAME(Add)(num, src, &REALNAME(ConstPi05));
	REALNAME(Sin_Taylor_old)(num);
}

// ---------------------------------------------------------------------------
//                      cosine - Chebyshev approximation
// ---------------------------------------------------------------------------

EXP REALNAME(Cos_ChebyshevFromExt)(REAL* num, const REAL* src, EXP exp)
{
	exp = REALNAME(AddExt)(num, src, exp, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1);
	return REALNAME(Sin_ChebyshevFromExt)(num, num, exp);
}

void REALNAME(Cos_ChebyshevFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Cos_ChebyshevFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

void REALNAME(Cos_ChebyshevFrom_old)(REAL* num, const REAL* src)
{
	REALNAME(Add)(num, src, &REALNAME(ConstPi05));
	REALNAME(Sin_ChebyshevFrom)(num, num);
}

// ---------------------------------------------------------------------------
//                            tangent
// ---------------------------------------------------------------------------
//  Function uses 6 temporary numbers in the stack.

void REALNAME(TanFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(Sin_TaylorFrom_old)(&m, src);
	REALNAME(Cos_TaylorFrom_old)(num, src);
	REALNAME(Div)(num, &m, num);
}

EXP REALNAME(Tan_TaylorFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP m_exp;
	exp = REALNAME(SinCos_TaylorFromExt)(num, &m, &m_exp, src, exp);
	return REALNAME(DivExt)(num, num, exp, &m, m_exp);
}

void REALNAME(Tan_TaylorFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Tan_TaylorFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

EXP REALNAME(Tan_ChebyshevFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP m_exp;
	m_exp = REALNAME(Sin_ChebyshevFromExt)(&m, src, exp);
	exp = REALNAME(Cos_ChebyshevFromExt)(num, src, exp);
	return REALNAME(DivExt)(num, &m, m_exp, num, exp);
}

void REALNAME(Tan_ChebyshevFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Tan_ChebyshevFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

EXP REALNAME(Tan_CordicFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP m_exp;
	exp = REALNAME(SinCos_CordicFromExt)(num, &m, &m_exp, src, exp);
	return REALNAME(DivExt)(num, num, exp, &m, m_exp);
}

void REALNAME(Tan_CordicFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(Tan_CordicFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                          cotangent
// ---------------------------------------------------------------------------
//  Function uses 6 temporary numbers in the stack.

void REALNAME(CoTanFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(Sin_TaylorFrom_old)(&m, src);
	REALNAME(Cos_TaylorFrom_old)(num, src);
	REALNAME(Div)(num, num, &m);
}

EXP REALNAME(CoTan_TaylorFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP m_exp;
	exp = REALNAME(SinCos_TaylorFromExt)(num, &m, &m_exp, src, exp);
	return REALNAME(DivExt)(num, &m, m_exp, num, exp);
}

void REALNAME(CoTan_TaylorFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(CoTan_TaylorFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

EXP REALNAME(CoTan_ChebyshevFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP m_exp;
	m_exp = REALNAME(Sin_ChebyshevFromExt)(&m, src, exp);
	exp = REALNAME(Cos_ChebyshevFromExt)(num, src, exp);
	return REALNAME(DivExt)(num, num, exp, &m, m_exp);
}

void REALNAME(CoTan_ChebyshevFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(CoTan_ChebyshevFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

EXP REALNAME(CoTan_CordicFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP m_exp;
	exp = REALNAME(SinCos_CordicFromExt)(num, &m, &m_exp, src, exp);
	return REALNAME(DivExt)(num, &m, m_exp, num, exp);
}

void REALNAME(CoTan_CordicFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(CoTan_CordicFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//          Generate constant pi (using Taylor serie, pi=6*asin(0.5))
// ---------------------------------------------------------------------------
//  Function uses 4 temporary numbers in the stack.

void REALNAME(Pi_old)(REAL* num)
{
	REAL x2, res;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// prepare number
	REALNAME(Set05)(num);

	// square x^2
	REALNAME(SqrFrom)(&x2, num);

	// prepare result accumulator -> x
	REALNAME(Copy)(&res, num);

	// prepare factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by x^2
		REALNAME(Mul)(num, num, &x2);

		// multiply member by coefficient^2
		if (faci > 255)
		{
			REALNAME(MulUInt)(num, num, faci);
			REALNAME(MulUInt)(num, num, faci);
		}
		else
			REALNAME(MulUInt)(num, num, faci*faci);

		// increment factorial coefficient
		faci++;

			// divide member by factorial coefficient
		if (faci > 254)
		{
			REALNAME(DivU16)(num, num, faci);
			REALNAME(DivU16)(num, num, faci+1);
		}
		else
			REALNAME(DivU16)(num, num, faci*(faci+1));

		// increment factorial coefficient
		faci++;

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoop)(&res, num));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// multiply result * 6
	REALNAME(MulUInt)(num, &res, 6);
}

EXP REALNAME(PiExt)(REAL* num)
{
	REAL x2, res;
	EXP x2_exp, res_exp, num_exp;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// prepare number
	REALNAME(Set05Ext)(num);
	num_exp = EXPEXT_1 - 1;

	// square x^2
	x2_exp = REALNAME(SqrFromExt)(&x2, num, num_exp);

	// prepare result accumulator -> x
	REALNAME(Copy)(&res, num);
	res_exp = num_exp;

	// prepare factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by x^2
		num_exp = REALNAME(MulExt)(num, num, num_exp, &x2, x2_exp);

		// multiply member by coefficient^2
		if (faci > 255)
		{
			num_exp = REALNAME(MulUIntExt)(num, num, num_exp, faci);
			num_exp = REALNAME(MulUIntExt)(num, num, num_exp, faci);
		}
		else
			num_exp = REALNAME(MulUIntExt)(num, num, num_exp, faci*faci);

		// increment factorial coefficient
		faci++;

			// divide member by factorial coefficient
		if (faci > 254)
		{
			num_exp = REALNAME(DivU16Ext)(num, num, num_exp, faci);
			num_exp = REALNAME(DivU16Ext)(num, num, num_exp, faci+1);
		}
		else
			num_exp = REALNAME(DivU16Ext)(num, num, num_exp, faci*(faci+1));

		// increment factorial coefficient
		faci++;

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoopExt)(&res, &res_exp, num, num_exp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// multiply result * 6
	return REALNAME(MulUIntExt)(num, &res, res_exp, 6);
}

//  Function uses 4 temporary numbers in the stack.
void REALNAME(Pi)(REAL* num)
{
	EXP exp = REALNAME(PiExt)(num);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//        arcus sine (result is in range -PI/2..+PI/2) - Taylor serie
// ---------------------------------------------------------------------------
//  Taylor serie xi+1 = xi * (2*i-1)^2*x^2 / ((2*i)*(2*i+1)) ... x0 = x
//  arcsin(x) = x + x^3/2/3 + 3*x^5/2/4/5 + 3*5*x^7/2/4/6/7 +
//  For x > 0.75 we use alternate method via arccos: sqrt(1 - x^2)
//  Function uses 7 temporary numbers in the stack.

void REALNAME(ASin_TaylorFrom_old)(REAL* num, const REAL* src)
{
	Bool neg, alt;
	s8 cmp;
	REAL x2, res;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// number is zero, result will be zero
	if (REALNAME(IsZero)(src))
	{
		REALNAME(Set0)(num);
		return;
	}

	// copy
	REALNAME(Copy)(num, src);

	// absolute value
	neg = REALNAME(IsNeg)(num);
	REALNAME(Abs)(num);

	// if number is == 1, use pre-calculated value PI/2 (error if > 1)
	//  Function uses 3 temporary numbers in the stack.
	if (REALNAME(CompEps)(num, &REALNAME(Const1), 4))
	{
		REALNAME(Copy)(num, &REALNAME(ConstPi05));
		if (neg) REALNAME(Neg)(num);
		return;
	}

	// error if value is > 1
	cmp = REALNAME(Comp)(num, &REALNAME(Const1));
	if (cmp > 0)
	{
		REALNAME(SetInf)(num);
		return;
	}

	// check if use alternate method (if > 0.75, we use sqrt(1 - x^2))
	alt = (REALNAME(Comp)(num, &REALNAME(Const075)) > 0);
	if (alt)
	{
		REALNAME(Sqr)(num); // x^2
		REALNAME(Sub)(num, &REALNAME(Const1), num); // 1 - x^2
		// Function uses 5 temporary numbers in the stack.
		REALNAME(Sqrt_Newton_old)(num); // sqrt(1 - x^2)
	}

	// square x^2
	REALNAME(SqrFrom)(&x2, num);

	// prepare result accumulator -> x
	REALNAME(Copy)(&res, num);

	// prepare factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by x^2
		REALNAME(Mul)(num, num, &x2);

		// multiply member by coefficient^2
		if (faci > 255)
		{
			REALNAME(MulUInt)(num, num, faci);
			REALNAME(MulUInt)(num, num, faci);
		}
		else
			REALNAME(MulUInt)(num, num, faci*faci);

		// increment factorial coefficient
		faci++;

		// divide member by factorial coefficient
		if (faci > 254)
		{
			REALNAME(DivU16)(num, num, faci);
			REALNAME(DivU16)(num, num, faci+1);
		}
		else
			REALNAME(DivU16)(num, num, faci*(faci+1));

		// increment factorial coefficient
		faci++;

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoop)(&res, num));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// correction for alternate method
	if (alt)
	{
		// pi/2 - res
		REALNAME(Sub)(&res, &REALNAME(ConstPi05), &res);
	}

	// negate result
	if (neg) REALNAME(Neg)(&res);

	// copy result
	REALNAME(Copy)(num, &res);
}

//  Function uses 7 temporary numbers in the stack.
EXP REALNAME(ASin_TaylorFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	Bool alt;
	s8 cmp, sign;
	REAL x2, res;
	EXP x2_exp, res_exp, num_exp;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// copy source
	REALNAME(Copy)(num, src);

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	num_exp = src_exp & EXPEXT_MASK;

	// overflow or case of small angles (< 2^(-bits/2), including zero): asin(val) = val
	if ((num_exp >= EXPEXT_INF) || (num_exp < EXPEXT_1 - REAL_BITS/2)) return src_exp;

	// error if value is > 1
	cmp = REALNAME(CompExt)(num, num_exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1);
	if (cmp > 0)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// check if use alternate method (if > 0.75, we use sqrt(1 - x^2))
	alt = (REALNAME(CompExt)(num, num_exp, (const REAL*)&REALNAME(Const075Ext), EXPEXT_1 - 1) > 0);
	if (alt)
	{
		num_exp = REALNAME(SqrExt)(num, num_exp); // x^2
		num_exp = REALNAME(SubExt)(num, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1, num, num_exp); // 1 - x^2
		// Function uses 5 temporary numbers in the stack.
		num_exp = REALNAME(SqrtExt)(num, num_exp); // sqrt(1 - x^2)
	}

	// square x^2
	x2_exp = REALNAME(SqrFromExt)(&x2, num, num_exp);

	// prepare result accumulator -> x
	REALNAME(Copy)(&res, num);
	res_exp = num_exp;

	// prepare factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by x^2
		num_exp = REALNAME(MulExt)(num, num, num_exp, &x2, x2_exp);

		// multiply member by coefficient^2
		if (faci > 255)
		{
			num_exp = REALNAME(MulUIntExt)(num, num, num_exp, faci);
			num_exp = REALNAME(MulUIntExt)(num, num, num_exp, faci);
		}
		else
			num_exp = REALNAME(MulUIntExt)(num, num, num_exp, faci*faci);

		// increment factorial coefficient
		faci++;

		// divide member by factorial coefficient
		if (faci > 254)
		{
			num_exp = REALNAME(DivU16Ext)(num, num, num_exp, faci);
			num_exp = REALNAME(DivU16Ext)(num, num, num_exp, faci+1);
		}
		else
			num_exp = REALNAME(DivU16Ext)(num, num, num_exp, faci*(faci+1));

		// increment factorial coefficient
		faci++;

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoopExt)(&res, &res_exp, num, num_exp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// correction for alternate method
	if (alt)
	{
		// pi/2 - res
		res_exp = REALNAME(SubExt)(&res, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1, &res, res_exp);
	}

	// limit to PI/2
	if (REALNAME(CompExt)(&res, res_exp, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1) > 0)
	{
		REALNAME(Copy)(&res, (const REAL*)&REALNAME(ConstPi05Ext));
		res_exp = EXPEXT_1;
	}

	// negate result
	if (sign != 0) res_exp ^= EXPEXT_SIGN;

	// copy result
	REALNAME(Copy)(num, &res);

	return res_exp;
}

//  Function uses 4 temporary numbers in the stack.
void REALNAME(ASin_TaylorFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ASin_TaylorFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//   arcus sine (result is in range -PI/2..+PI/2) - Chebyshev approximation
// ---------------------------------------------------------------------------

#ifdef CHEB_ASIN
EXP REALNAME(ASin_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	Bool alt;
	u8 sign;
	EXP num_exp;
	s8 cmp;

	// small values are inaccurate, use Taylor instead
#if REAL_BITS <= 16 // real16 (exp: 5 bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 5) // 2 deg
#elif REAL_BITS <= 24 // real24 (exp: 6 bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 6) // 1 deg
#elif REAL_BITS <= 32 // real32 (exp: 8 bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 7) // 0.5 deg
#elif REAL_BITS <= 40 // real40 (exp: 9 bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 8) // 0.2 deg
#else // >= real48 (exp: 10 and more bits)
	if ((src_exp & EXPEXT_MASK) < EXPEXT_1 - 9) // 0.1 deg
#endif
		return REALNAME(ASin_TaylorFromExt)(num, src, src_exp);

	// copy
	REALNAME(Copy)(num, src);

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	num_exp = src_exp & EXPEXT_MASK;

	// overflow or case of small angles (< 2^(-bits/2), including zero): asin(val) = val
	if ((num_exp >= EXPEXT_INF) || (num_exp < EXPEXT_1 - REAL_BITS/2)) return src_exp;

	// error if value is > 1
	cmp = REALNAME(CompExt)(num, num_exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1);
	if (cmp > 0)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// check if use alternate method (if > 0.75, we use sqrt(1 - x^2))
	alt = (REALNAME(CompExt)(num, num_exp, (const REAL*)&REALNAME(Const075Ext), EXPEXT_1 - 1) > 0);
	if (alt)
	{
		num_exp = REALNAME(SqrExt)(num, num_exp); // x^2
		num_exp = REALNAME(SubExt)(num, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1, num, num_exp); // 1 - x^2
		// Function uses 5 temporary numbers in the stack.
		num_exp = REALNAME(SqrtExt)(num, num_exp); // sqrt(1 - x^2)
	}
	// here is value 0..0.75 or sqrt(1-0.75^2)..sqrt(1-1^2) = 0.6614..0

	// convert 0..+0.75 to range -1..+1
	num_exp = REALNAME(MulExt)(num, num, num_exp, (const REAL*)&REALNAME(Const83Ext), EXPEXT_1 + 1); // 0..+0.75 -> 0..2
	num_exp = REALNAME(DecExt)(num, num_exp); // 0..2 -> -1..+1

	// calculate function
	num_exp = REALNAME(ChebyshevExt)(num, num_exp, CHEB_ASIN, REALNAME(ConstChebASin));

	// correction for alternate method
	if (alt)
	{
		// pi/2 - res
		num_exp = REALNAME(SubExt)(num, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1, num, num_exp);
	}

	// limit to PI/2
	if (REALNAME(CompExt)(num, num_exp, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1) > 0)
	{
		REALNAME(Copy)(num, (const REAL*)&REALNAME(ConstPi05Ext));
		num_exp = EXPEXT_1;
	}

	// negate result
	if (sign != 0) num_exp ^= EXPEXT_SIGN;

	return num_exp;
}

void REALNAME(ASin_ChebyshevFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ASin_ChebyshevFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}
#endif // CHEB_ASIN > 0

// ---------------------------------------------------------------------------
//                          arcus sine - Cordic
// ---------------------------------------------------------------------------
// @TODO: This function is very inaccurate for some values. Correction is
// possible by using the double iteration method or better calculating using
// asin(x) = atan2(x, sqrt((1-x)*(1+x))).

#ifdef CORD_ATAN
EXP REALNAME(ASin_CordicFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	s8 sign;
	int i, sigma, x_sigma, y_sigma, dx_sigma, dy_sigma;
	const REAL* tab;
	REAL x, y, t, dx, dy, tab_delta;
	EXP exp;

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	exp = src_exp & EXPEXT_MASK;

	// small values are inaccurate, use Taylor instead
	//   The Taylor version is also used for values in the interval 0.98 to 1.00,
	//   for which the standard Cordic calculation is very inaccurate. Another
	//   alternative would be to use a double iteration calculation - the code is
	//   elaborated below,  but not yet functional.
#if REAL_BITS <= 16 // real16 (exp: 5 bits)
	if ((exp < EXPEXT_1 - 5) // 2 deg
#elif REAL_BITS <= 24 // real24 (exp: 6 bits)
	if ((exp < EXPEXT_1 - 6) // 1 deg
#elif REAL_BITS <= 32 // real32 (exp: 8 bits)
	if ((exp < EXPEXT_1 - 7) // 0.5 deg
#elif REAL_BITS <= 40 // real40 (exp: 9 bits)
	if ((exp < EXPEXT_1 - 8) // 0.2 deg
#else // >= real48 (exp: 10 and more bits)
	if ((exp < EXPEXT_1 - 9) // 0.1 deg
#endif
		|| (REALNAME(CompExt)(src, exp, (const REAL*)&REALNAME(ConstLnPi22Ext), EXPEXT_1 - 1) >= 0))
			return REALNAME(ASin_TaylorFromExt)(num, src, src_exp);

	// overflow or case of small angles (< 2^(-bits/2), including zero): asin(val) = val
	if ((exp >= EXPEXT_INF) || (exp < EXPEXT_1 - REAL_BITS/2))
	{
		REALNAME(Copy)(num, src);
		return src_exp;
	}

	// error if value is > 1
	if (REALNAME(CompExt)(src, exp, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1) > 0)
	{
		REALNAME(SetInfExt)(num);
		return EXPEXT_INF | ((EXP)sign << EXPEXT_BITS);
	}

	// copy source -> t
	REALNAME(Copy)(&t, src);

	// denormalize value to 1-base
	REALNAME(MantR)(&t, 0, EXPEXT_1 - exp);

	// initialize vector projections
	REALNAME(Set0Ext)(num); // set angle accumulator to 0
	REALNAME(Set0Ext)(&y); // set Y (=sin) to 0
	REALNAME(Copy)(&x, &REALNAME(ConstAtanInit)); // set X (=cos) to initial value
	sigma = 0;
	y_sigma = 0;
	x_sigma = 0;

	// iterations - tabled part
	tab = &REALNAME(ConstAtan)[0];
	for (i = 0; i < CORD_ATAN; i++)
	{
		// prepare delta X (=cos)
		REALNAME(Copy)(&dx, &x);
		dx_sigma = (x_sigma < 0) ? -1 : 0;
		REALNAME(MantR)(&dx, dx_sigma, i);

		// prepare delta Y (=sin)
		REALNAME(Copy)(&dy, &y);
		dy_sigma = (y_sigma < 0) ? -1 : 0;
		REALNAME(MantR)(&dy, dy_sigma, i);

		// Y < value
		if ((y_sigma < 0) || ((y_sigma == 0) && (REALNAME(MantComp)(&y, &t) < 0)))
		{
			// sub X (=cos), add Y (=sin)
			x_sigma -= REALNAME(MantSub)(&x, &dy, 0) + dy_sigma;
			y_sigma += REALNAME(MantAdd)(&y, &dx, 0) + dx_sigma;

			// add table to angle
			sigma += REALNAME(MantAdd)(num, tab, 0);
		}

		// Y >= value
		else
		{
			// add X (=cos), sub Y (=sin)
			x_sigma += REALNAME(MantAdd)(&x, &dy, 0) + dy_sigma;
			y_sigma -= REALNAME(MantSub)(&y, &dx, 0) + dx_sigma;

			// sub table from angle
			sigma -= REALNAME(MantSub)(num, tab, 0);
		}

		// shift table pointer
		tab++;
	}

	// load last table delta
	REALNAME(Copy)(&tab_delta, &tab[-1]);

	// iterations - hidden table
	for (; i < REAL_BITS; i++)
	{
		// shift delta value
		REALNAME(MantR1)(&tab_delta, 0);

		// prepare delta X (=cos)
		REALNAME(Copy)(&dx, &x);
		dx_sigma = (x_sigma < 0) ? -1 : 0;
		REALNAME(MantR)(&dx, dx_sigma, i);

		// prepare delta Y (=sin)
		REALNAME(Copy)(&dy, &y);
		dy_sigma = (y_sigma < 0) ? -1 : 0;
		REALNAME(MantR)(&dy, dy_sigma, i);

		// Y < value
		if ((y_sigma < 0) || ((y_sigma == 0) && (REALNAME(MantComp)(&y, &t) < 0)))
		{
			// sub X (=cos), add Y (=sin)
			x_sigma -= REALNAME(MantSub)(&x, &dy, 0) + dy_sigma;
			y_sigma += REALNAME(MantAdd)(&y, &dx, 0) + dx_sigma;

			// add table to angle
			sigma += REALNAME(MantAdd)(num, &tab_delta, 0);
		}

		// Y >= value
		else
		{
			// add X (=cos), sub Y (=sin)
			x_sigma += REALNAME(MantAdd)(&x, &dy, 0) + dy_sigma;
			y_sigma -= REALNAME(MantSub)(&y, &dx, 0) + dx_sigma;

			// sub table from angle
			sigma -= REALNAME(MantSub)(num, &tab_delta, 0);
		}
	}

	// number of iterations
#if DEB_LOOPNUM
	Deb_LoopNum += REAL_BITS;	// number of iteration loops
#endif

	// underflow correction
	if (sigma < 0) REALNAME(Set0Ext)(num);

	// normalize result
	i = REALNAME(MantNormExt)(num);
	if (i >= REAL_BITS)
	{
		REALNAME(Set0Ext)(num);
		exp = EXPEXT_0;
	}
	else
		exp = EXPEXT_1 - i;

	return exp ^ ((EXP)sign << EXPEXT_BITS);
}

void REALNAME(ASin_CordicFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ASin_CordicFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}
#endif

// ---------------------------------------------------------------------------
//              arcus cosine (result is in range 0..PI)
// ---------------------------------------------------------------------------
//  Function uses 6 temporary numbers in the stack.

void REALNAME(ACosFrom_old)(REAL* num, const REAL* src)
{
	REALNAME(ASin_TaylorFrom_old)(num, src);
	REALNAME(Sub)(num, &REALNAME(ConstPi05), num);
}

EXP REALNAME(ACosFromExt)(REAL* num, const REAL* src, EXP exp)
{
	exp = REALNAME(ASinFromExt)(num, src, exp);
	return REALNAME(SubExt)(num, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1, num, exp);
}

void REALNAME(ACosFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ACosFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//        arcus tangent (result is in range -PI/2..+PI/2) - Taylor serie
// ---------------------------------------------------------------------------
//  Taylor serie arctan(x) = x - x^3/3 + x^5/5 - x^7/7 + .... (for -1 < x < 1)
//  For abs(x) > 1 we use alternate method: arctan(x)= pi/2 + arctan(-1/x)
//  For abs(x) > 0.5 we use alternate method: arctan(x) = pi/4 + arctan((x-1)/(x+1))
//  Function uses 7 temporary numbers in the stack.

void REALNAME(ATan_TaylorFrom_old)(REAL* num, const REAL* src)
{
	Bool neg;
	REAL add, x2, tmp, res;
	BASE exp;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// if number is 0, return 0
	if (REALNAME(IsZero)(src))
	{
		REALNAME(Set0)(num);
		return;
	}

	// copy
	REALNAME(Copy)(num, src);

	// absolute value
	neg = REALNAME(IsNeg)(num);
	REALNAME(Abs)(num);
/*
	// if number is 1, return pi/4
	if (REALNAME(CompEps)(num, &REALNAME(Const1), 4))
	{
		REALNAME(Copy)(num, &REALNAME(ConstPi05));
		REALNAME(Div2)(num);
		if (neg) REALNAME(Neg)(num);
		return;
	}
*/
	// if abs(x) == 0.5..2.0: arctan = pi/4 + arctan((x-1)/(x+1))
	exp = REALNAME(GetExp)(num);
	if ((exp == EXP_1 - 1) || (exp == EXP_1))
	{
		REALNAME(Copy)(&x2, num);
		REALNAME(Dec)(num); // this = x-1
		REALNAME(Inc)(&x2);  // x2 = x+1
		REALNAME(Div)(num, num, &x2); // this = (x-1)(x+1)
		REALNAME(Copy)(&add, &REALNAME(ConstPi05)); // pi/2
		REALNAME(Div2)(&add); // add = pi/4
	}
	else
	{
		// if abs(x) >= 2: arctan(x) = pi/2 + arctan(-1/x)
		if (exp > EXP_1)
		{
			REALNAME(Copy)(&add, &REALNAME(ConstPi05)); // add = pi/2
			REALNAME(Div)(num, &REALNAME(ConstM1), num); // -1/x
		}

		// if abs(x) < 0.5
		else
			// set 'add' constant to 0
			REALNAME(Set0)(&add);
	}

// here is: -0.5 < x < +0.5

	// square -x^2
	REALNAME(SqrFrom)(&x2, num);
	REALNAME(Neg)(&x2);

	// prepare result accumulator -> x
	REALNAME(Copy)(&res, num);

	// factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by -x^2
		REALNAME(Mul)(num, num, &x2);

		// increment factorial coefficient
		faci += 2;

		// divide member by factorial coefficient
		REALNAME(DivU16)(&tmp, num, faci);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoop)(&res, &tmp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// addition
	REALNAME(Add)(num, &res, &add);

	// negate result
	if (neg) REALNAME(Neg)(num);
}

//  Function uses 6 temporary numbers in the stack.
EXP REALNAME(ATan_TaylorFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	s8 sign;
	REAL add, x2, tmp, res;
	EXP add_exp, x2_exp, tmp_exp, res_exp, num_exp;
	u16 faci;

#if DEB_LOOPNUM
	int loopnum = 0;	// number of iteration loops
#endif

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	num_exp = src_exp & EXPEXT_MASK;

	// infinity - return pi/2
	if (num_exp >= EXPEXT_INF)
	{
		REALNAME(Copy)(num, (const REAL*)&REALNAME(ConstPi05Ext));
		return EXPEXT_1 | ((EXP)sign << EXPEXT_BITS);
	}

	// copy (num_exp contains absolute value)
	REALNAME(Copy)(num, src);

	// case of small angles (< 2^(-bits/2), including zero): atan(x) = x
	if (num_exp < EXPEXT_1 - REAL_BITS/2) return src_exp;

	// if abs(x) == 0.5..2.0: arctan = pi/4 + arctan((x-1)/(x+1))
	if ((num_exp == EXPEXT_1 - 1) || (num_exp == EXPEXT_1))
	{
		REALNAME(Copy)(&x2, num); x2_exp = num_exp;
		num_exp = REALNAME(DecExt)(num, num_exp); // this = x-1
		x2_exp = REALNAME(IncExt)(&x2, x2_exp);  // x2 = x+1
		num_exp = REALNAME(DivExt)(num, num, num_exp, &x2, x2_exp); // this = (x-1)(x+1)
		REALNAME(Copy)(&add, (const REAL*)&REALNAME(ConstPi05Ext)); // pi/2
		add_exp = REALNAME(Div2Ext)(&add, EXPEXT_1); // add = pi/4
	}
	else
	{
		// if abs(x) >= 2: arctan(x) = pi/2 + arctan(-1/x)
		if (num_exp > EXPEXT_1)
		{
			REALNAME(Copy)(&add, (const REAL*)&REALNAME(ConstPi05Ext)); // add = pi/2
			add_exp = EXPEXT_1;
			num_exp = REALNAME(DivExt)(num, (const REAL*)&REALNAME(ConstM1Ext), EXPEXT_1 | EXPEXT_SIGN, num, num_exp); // -1/x
		}

		// if abs(x) < 0.5
		else
		{
			// set 'add' constant to 0
			REALNAME(Set0Ext)(&add);
			add_exp = EXPEXT_0;
		}
	}

// here is: -0.5 < x < +0.5

	// square -x^2
	x2_exp = REALNAME(SqrFromExt)(&x2, num, num_exp) ^ EXPEXT_SIGN;

	// prepare result accumulator -> x
	REALNAME(Copy)(&res, num);
	res_exp = num_exp;

	// factorial coefficient -> 1
	faci = 1;

	// iterations
	do {
		// multiply member by -x^2
		num_exp = REALNAME(MulExt)(num, num, num_exp, &x2, x2_exp);

		// increment factorial coefficient
		faci += 2;

		// divide member by factorial coefficient
		tmp_exp = REALNAME(DivU16Ext)(&tmp, num, num_exp, faci);

#if DEB_LOOPNUM
		loopnum++;	// number of iteration loops
#endif

		// add member to accumulator and check epsilon of loop
	} while (REALNAME(AddLoopExt)(&res, &res_exp, &tmp, tmp_exp));

#if DEB_LOOPNUM
	Deb_LoopNum += loopnum;	// number of iteration loops
#endif

	// addition
	num_exp = REALNAME(AddExt)(num, &res, res_exp, &add, add_exp);

	// negate result
	if (sign != 0) num_exp ^= EXPEXT_SIGN;

	return num_exp;
}

//  Function uses 6 temporary numbers in the stack.
void REALNAME(ATan_TaylorFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ATan_TaylorFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//  arcus tangent (result is in range -PI/2..+PI/2) - Chebyshev approximation
// ---------------------------------------------------------------------------
//  Function uses 10 temporary numbers in the stack.

#ifdef CHEB_ATAN
EXP REALNAME(ATan_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp)
{
	REAL add, x;
	EXP add_exp, x_exp, num_exp;
	u8 sign;

	// unpack source exponent
	sign = (u8)(src_exp >> EXPEXT_BITS);
	num_exp = src_exp & EXPEXT_MASK;

	// infinity - return pi/2
	if (num_exp >= EXPEXT_INF)
	{
		REALNAME(Copy)(num, (const REAL*)&REALNAME(ConstPi05Ext));
		return EXPEXT_1 | ((EXP)sign << EXPEXT_BITS);
	}

	// copy
	REALNAME(Copy)(num, src);

	// case of small angles (< 2^(-bits/2), including zero): atan(x) = x
	if (num_exp < EXPEXT_1 - REAL_BITS/2) return src_exp;

	// if abs(x) >= 1, use acotan
	if (num_exp >= EXPEXT_1)
	{
		REALNAME(Copy)(&add, (const REAL*)&REALNAME(ConstPi05Ext)); // add = pi/2
		add_exp = EXPEXT_1;
		num_exp = REALNAME(DivExt)(num, (const REAL*)&REALNAME(ConstM1Ext), EXPEXT_1 | EXPEXT_SIGN, num, num_exp); // -1/x
		if ((num_exp & EXPEXT_SIGN) == 0) add_exp = EXPEXT_1 | EXPEXT_SIGN; // if result is positive, use -pi/2
	}
	else
	{
		REALNAME(Set0Ext)(&add); // add = 0
		add_exp = EXPEXT_0;
	}

	// save X
	REALNAME(Copy)(&x, num);
	x_exp = num_exp;

// argument here is in range -1..+1

	// calculate 2*x^2-1
	num_exp = REALNAME(SqrExt)(num, num_exp);
	num_exp = REALNAME(Mul2Ext)(num, num_exp);
	num_exp = REALNAME(DecExt)(num, num_exp);

	// calculate function
	num_exp = REALNAME(ChebyshevExt)(num, num_exp, CHEB_ATAN, REALNAME(ConstChebATan));

	// multiply result by X
	num_exp = REALNAME(MulExt)(num, num, num_exp, &x, x_exp);

	// addition
	num_exp = REALNAME(AddExt)(num, num, num_exp, &add, add_exp);

	// negate result
	if (sign != 0) num_exp ^= EXPEXT_SIGN;

	return num_exp;
}

void REALNAME(ATan_ChebyshevFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ATan_ChebyshevFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}
#endif // CHEB_ATAN > 0

// ---------------------------------------------------------------------------
//      arcus tangent of polar coordinates (result is in range 0..2*PI)
// ---------------------------------------------------------------------------

void REALNAME(ATan2_old)(REAL* num, const REAL* x, const REAL* y)
{
	u8 signx, signy;
	BASE expx, expy;
	BASES exps;

	// get signs
	signx = REALNAME(GetSign)(x);
	signy = REALNAME(GetSign)(y);

	// difference of exponents
	expx = REALNAME(GetExp)(x);
	expy = REALNAME(GetExp)(y);
	exps = expy - expx;

	// y much> x, result is pi/2 or pi*3/2
	if ((exps > 2*MANT_BITS) || (expx == 0))
	{
		REALNAME(Copy)(num, &REALNAME(ConstPi05));
		if (signy != 0) REALNAME(Add)(num, num, &REALNAME(ConstPi));
		return;
	}

	// calculate atan(y/x)
	REALNAME(Div)(num, y, x);
	REALNAME(ATan_Taylor_old)(num);

	// x is positive
	if (signx == 0)
	{
		// y is negative, angle = angle + 2*pi
		if (signy != 0)
		{
			REALNAME(Add)(num, &REALNAME(ConstPi2), num);
		}
	}
	else

	// x is negative, angle = angle + pi
	{
		REALNAME(Add)(num, &REALNAME(ConstPi), num);
	}
}

// Atan2-ext prepare (returns True = quit the function), result angle is -PI .. +PI
Bool REALNAME(ATan2ExtPrep)(REAL* num, EXP* num_exp, const REAL* x, EXP x_exp, const REAL* y, EXP y_exp)
{
	u8 x_sign, y_sign;
	EXP exp;

	// unpack source exponents
	x_sign = (u8)(x_exp >> EXPEXT_BITS);
	x_exp &= EXPEXT_MASK;
	y_sign = (u8)(y_exp >> EXPEXT_BITS);
	y_exp &= EXPEXT_MASK;

	// Y is infinity
	if (y_exp >= EXPEXT_INF)
	{
		// prepare result PI/2 (90°)
		REALNAME(Copy)(num, (const REAL*)&REALNAME(ConstPi05Ext)); // PI/2
		exp = EXPEXT_1; // PI/2

		// X is infinity too - result is PI/4 (45°)
		if (x_exp >= EXPEXT_INF) exp--; // (= EXPEXT_1 - 1) PI/4
	}
	else
	{
		// X is infinity, Y is not - result is 0
		if (x_exp >= EXPEXT_INF)
		{
			REALNAME(Set0Ext)(num);
			exp = EXPEXT_0;
		}
		else
		{
			// Y is zero - result is 0
			if (y_exp == EXPEXT_0)
			{
				REALNAME(Set0Ext)(num);
				exp = EXPEXT_0;
			}
			else
			{
				// X is zero - result is PI/2 (90°)
				if (x_exp == EXPEXT_0)
				{
					REALNAME(Copy)(num, (const REAL*)&REALNAME(ConstPi05Ext)); // PI/2
					exp = EXPEXT_1; // PI/2
				}

				// X and Y are in usual range
				else
				{
					// X is much > Y (by half of bits), result is Y/X
					if ((EXPS)(x_exp - y_exp) >= (EXPS)REAL_BITS/2)
					{
						exp = REALNAME(DivExt)(num, y, y_exp, x, x_exp);
					}
					else
					{
						// Y is much > X (by half of bits), result is PI/2 - X/Y
						if ((EXPS)(y_exp - x_exp) >= (EXPS)REAL_BITS/2)
						{
							exp = REALNAME(DivExt)(num, x, x_exp, y, y_exp);
							exp = REALNAME(SubExt)(num, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1, num, exp);
						}
						else
							// X and Y are in usual range - continue to normal function
							return False;
					}
				}
			}
		}
	}

	// shift result by X value (= PI - num)
	if (x_sign != 0) exp = REALNAME(SubExt)(num, (const REAL*)&REALNAME(ConstPiExt), EXPEXT_1+1, num, exp);

	// set sign of the result by Y value
	exp ^= ((EXP)y_sign << EXPEXT_BITS);

	// set result exponent
	*num_exp = exp;

	// quit the function
	return True;
}

// arcus tangent of polar coordinates (result is in range -PI .. +PI)
EXP REALNAME(ATan2Ext)(REAL* num, const REAL* x, EXP x_exp, const REAL* y, EXP y_exp)
{
	u8 signx, signy;
	EXP expx, expy, exp;

	// Atan2-ext prepare (returns True = quit the function), result angle is -PI .. +PI
	if (REALNAME(ATan2ExtPrep)(num, &exp, x, x_exp, y, y_exp)) return exp;

	// unpack source exponents
	signx = (u8)(x_exp >> EXPEXT_BITS);
	expx = x_exp & EXPEXT_MASK;
	signy = (u8)(y_exp >> EXPEXT_BITS);
	expy = y_exp & EXPEXT_MASK;

	// calculate atan(y/x)
	exp = REALNAME(DivExt)(num, y, expy, x, expx);
	exp = REALNAME(ATanExt)(num, exp);

	// shift result by X value (= PI - num)
	if (signx != 0) exp = REALNAME(SubExt)(num, (const REAL*)&REALNAME(ConstPiExt), EXPEXT_1+1, num, exp);

	// set sign of the result by Y value
	exp ^= ((EXP)signy << EXPEXT_BITS);

	return exp;
}

void REALNAME(ATan2)(REAL* num, const REAL* x, const REAL* y)
{
	REAL x_tmp;
	EXP x_exp, y_exp;
	x_exp = REALNAME(Unpack)(x, &x_tmp);
	y_exp = REALNAME(Unpack)(y, num);
	x_exp = REALNAME(ATan2Ext)(num, &x_tmp, x_exp, num, y_exp);
	REALNAME(Pack)(num, num, x_exp);
}

// ---------------------------------------------------------------------------
//  arcus tangent of polar coordinates - Cordic (result is in range -PI .. +PI)
// ---------------------------------------------------------------------------
// @TODO: Defective function! This function is very inaccurate for some values!

#ifdef CORD_ATAN
EXP REALNAME(ATan2_CordicExt)(REAL* num, const REAL* x, EXP x_exp, const REAL* y, EXP y_exp)
{
	s8 x_sign, y_sign;
	Bool corr;
	int i, sigma, x_sigma, y_sigma, dx_sigma, dy_sigma;
	const REAL* tab;
	REAL x2, y2, dx, dy, tab_delta;
	EXP exp;

	// small angles are inaccurate, use Taylor instead
#if REAL_BITS <= 16 // real16 (exp: 5 bits)
	if ((EXPS)((x_exp & EXPEXT_MASK) - (y_exp & EXPEXT_MASK)) > 5) // 2 deg
#elif REAL_BITS <= 24 // real24 (exp: 6 bits)
	if ((EXPS)((x_exp & EXPEXT_MASK) - (y_exp & EXPEXT_MASK)) > 6) // 1 deg
#elif REAL_BITS <= 32 // real32 (exp: 8 bits)
	if ((EXPS)((x_exp & EXPEXT_MASK) - (y_exp & EXPEXT_MASK)) > 7) // 0.5 deg
#elif REAL_BITS <= 40 // real40 (exp: 9 bits)
	if ((EXPS)((x_exp & EXPEXT_MASK) - (y_exp & EXPEXT_MASK)) > 8) // 0.2 deg
#else // >= real48 (exp: 10 and more bits)
	if ((EXPS)((x_exp & EXPEXT_MASK) - (y_exp & EXPEXT_MASK)) > 9) // 0.1 deg
#endif
		return REALNAME(ATan2Ext)(num, x, x_exp, y, y_exp);

	// Atan2-ext prepare (returns True = quit the function), result angle is -PI .. +PI
	if (REALNAME(ATan2ExtPrep)(num, &exp, x, x_exp, y, y_exp)) return exp;

	// unpack source exponents
	x_sign = (u8)(x_exp >> EXPEXT_BITS);
	x_exp &= EXPEXT_MASK;
	y_sign = (u8)(y_exp >> EXPEXT_BITS);
	y_exp &= EXPEXT_MASK;

	// use atan(y/x) for angles <= 45°
	if (REALNAME(CompExt)(x, x_exp, y, y_exp) >= 0)
	{
		y_exp = REALNAME(DivExt)(&y2, y, y_exp, x, x_exp);
		corr = False;
	}
	else
	{
		// use "PI/2 - atan(x/y)" for angles > 45°
		y_exp = REALNAME(DivExt)(&y2, x, x_exp, y, y_exp);
		corr = True;
	}

	REALNAME(Set1Ext)(&x2); // x = 1
	x_exp = EXPEXT_1;
	y_sigma = 0;
	x_sigma = 0;

	// denormalize values to the same exponent (here is x >= y)
	REALNAME(MantR)(&y2, 0, EXPEXT_1 - y_exp);

	// set angle accumulator to 0
	REALNAME(Set0Ext)(num);
	sigma = 0;

	// iterations - tabled part
	tab = &REALNAME(ConstAtan)[0];
	for (i = 0; i < CORD_ATAN; i++)
	{
		// prepare delta X
		REALNAME(Copy)(&dx, &x2);
		dx_sigma = (x_sigma < 0) ? -1 : 0;
		REALNAME(MantR)(&dx, dx_sigma, i);

		// prepare delta Y
		REALNAME(Copy)(&dy, &y2);
		dy_sigma = (y_sigma < 0) ? -1 : 0;
		REALNAME(MantR)(&dy, dy_sigma, i);

		// Y < 0
		if (y_sigma < 0)
		{
			// sub X, add Y
			x_sigma -= REALNAME(MantSub)(&x2, &dy, 0) + dy_sigma;
			y_sigma += REALNAME(MantAdd)(&y2, &dx, 0) + dx_sigma;

			// sub table from angle
			sigma -= REALNAME(MantSub)(num, tab, 0);
		}

		// Y >= 0
		else
		{
			// add X, sub Y
			x_sigma += REALNAME(MantAdd)(&x2, &dy, 0) + dy_sigma;
			y_sigma -= REALNAME(MantSub)(&y2, &dx, 0) + dx_sigma;

			// add table to angle
			sigma += REALNAME(MantAdd)(num, tab, 0);
		}

		// shift table pointer
		tab++;
	}

	// load last table delta
	REALNAME(Copy)(&tab_delta, &tab[-1]);

	// iterations - hidden table
	for (; i < REAL_BITS; i++)
	{
		// shift delta value
		REALNAME(MantR1)(&tab_delta, 0);

		// prepare delta X
		REALNAME(Copy)(&dx, &x2);
		dx_sigma = (x_sigma < 0) ? -1 : 0;
		REALNAME(MantR)(&dx, dx_sigma, i);

		// prepare delta Y
		REALNAME(Copy)(&dy, &y2);
		dy_sigma = (y_sigma < 0) ? -1 : 0;
		REALNAME(MantR)(&dy, dy_sigma, i);

		// Y < 0
		if (y_sigma < 0)
		{
			// sub X, add Y
			x_sigma -= REALNAME(MantSub)(&x2, &dy, 0) + dy_sigma;
			y_sigma += REALNAME(MantAdd)(&y2, &dx, 0) + dx_sigma;

			// sub table from angle
			sigma -= REALNAME(MantSub)(num, &tab_delta, 0);
		}

		// Y >= 0
		else
		{
			// add X, sub Y
			x_sigma += REALNAME(MantAdd)(&x2, &dy, 0) + dy_sigma;
			y_sigma -= REALNAME(MantSub)(&y2, &dx, 0) + dx_sigma;

			// add table to angle
			sigma += REALNAME(MantAdd)(num, &tab_delta, 0);
		}
	}

	// number of iterations
#if DEB_LOOPNUM
	Deb_LoopNum += REAL_BITS;	// number of iteration loops
#endif

	// limiting inaccurate negative values
	if (sigma != 0) REALNAME(Set0Ext)(num);

	// normalize result
	i = REALNAME(MantNormExt)(num);
	if (i >= REAL_BITS)
	{
		REALNAME(Set0Ext)(num);
		exp = EXPEXT_0;
	}
	else
		exp = EXPEXT_1 - i;

	// "PI/2 - atan(x/y)" correction
	if (corr)
	{
		exp = REALNAME(SubExt)(num, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1, num, exp);
	}

	// shift result by X value (= PI - num)
	if (x_sign != 0) exp = REALNAME(SubExt)(num, (const REAL*)&REALNAME(ConstPiExt), EXPEXT_1+1, num, exp);

	// set sign of the result by Y value
	exp ^= ((EXP)y_sign << EXPEXT_BITS);

	return exp;
}

void REALNAME(ATan2_Cordic)(REAL* num, const REAL* x, const REAL* y)
{
	REAL x_tmp;
	EXP x_exp, y_exp;
	x_exp = REALNAME(Unpack)(x, &x_tmp);
	y_exp = REALNAME(Unpack)(y, num);
	x_exp = REALNAME(ATan2_CordicExt)(num, &x_tmp, x_exp, num, y_exp);
	REALNAME(Pack)(num, num, x_exp);
}
#endif

// ---------------------------------------------------------------------------
//          radius of coordinates, radius = sqrt(x^2 + y^2)
// ---------------------------------------------------------------------------

void REALNAME(Radius_old)(REAL* num, const REAL* x, const REAL* y)
{
	REAL tmp;
	REALNAME(SqrFrom)(&tmp, x);
	REALNAME(SqrFrom)(num, y);
	REALNAME(Add)(num, num, &tmp);
	REALNAME(Sqrt_Taylor_old)(num);
}

EXP REALNAME(RadiusExt)(REAL* num, const REAL* x, EXP x_exp, const REAL* y, EXP y_exp)
{
	REAL tmp;
	x_exp = REALNAME(SqrFromExt)(&tmp, x, x_exp);
	y_exp = REALNAME(SqrFromExt)(num, y, y_exp);
	x_exp = REALNAME(AddExt)(num, num, y_exp, &tmp, x_exp);
	return REALNAME(SqrtExt)(num, x_exp);
}

void REALNAME(Radius)(REAL* num, const REAL* x, const REAL* y)
{
	REAL x_tmp;
	EXP x_exp, y_exp;
	x_exp = REALNAME(Unpack)(x, &x_tmp);
	y_exp = REALNAME(Unpack)(y, num);
	x_exp = REALNAME(RadiusExt)(num, &x_tmp, x_exp, num, y_exp);
	REALNAME(Pack)(num, num, x_exp);
}

// ---------------------------------------------------------------------------
//  convert Cartesian coordinates to polar (result angle is in range 0..2*PI)
// ---------------------------------------------------------------------------

void REALNAME(Cart2Pol_old)(REAL* angle, REAL* radius, const REAL* x, const REAL* y)
{
	REAL r;
	REALNAME(Radius_old)(&r, x, y);
	REALNAME(ATan2_old)(angle, x, y);
	REALNAME(Copy)(radius, &r);
}

void REALNAME(Cart2PolExt)(REAL* angle, EXP* angle_exp, REAL* radius, EXP* radius_exp,
		const REAL* x, EXP x_exp, const REAL* y, EXP y_exp)
{
	REAL r;
	EXP r_exp;
	r_exp = REALNAME(RadiusExt)(&r, x, x_exp, y, y_exp);
	*angle_exp = REALNAME(ATan2Ext)(angle, x, x_exp, y, y_exp);
	REALNAME(Copy)(radius, &r);
	*radius_exp = r_exp;
}

void REALNAME(Cart2Pol)(REAL* angle, REAL* radius, const REAL* x, const REAL* y)
{
	REAL x_tmp;
	EXP x_exp, y_exp, a_exp, r_exp;
	x_exp = REALNAME(Unpack)(x, &x_tmp);
	y_exp = REALNAME(Unpack)(y, radius);
	REALNAME(Cart2PolExt)(angle, &a_exp, radius, &r_exp, &x_tmp, x_exp, radius, y_exp);
	REALNAME(Pack)(angle, angle, a_exp);
	REALNAME(Pack)(radius, radius, r_exp);
}

// ---------------------------------------------------------------------------
//               convert polar coordinates to Cartesian
// ---------------------------------------------------------------------------

void REALNAME(Pol2Cart_old)(REAL* x, REAL* y, const REAL* angle, const REAL* radius)
{
	REAL xx, r;
	REALNAME(Copy)(&r, radius); // save radius
	REALNAME(CosFrom)(&xx, angle);
	REALNAME(SinFrom)(y, angle);
	REALNAME(Mul)(x, &xx, &r);
	REALNAME(Mul)(y, y, &r);
}

void REALNAME(Pol2CartExt)(REAL* x, EXP* x_exp, REAL* y, EXP* y_exp, 
		const REAL* angle, EXP angle_exp, const REAL* radius, EXP radius_exp)
{
	REAL xx, r;
	EXP xexp, yexp;
	REALNAME(Copy)(&r, radius); // save radius
	xexp = REALNAME(CosFromExt)(&xx, angle, angle_exp);
	yexp = REALNAME(SinFromExt)(y, angle, angle_exp);
	*x_exp = REALNAME(MulExt)(x, &xx, xexp, &r, radius_exp);
	*y_exp = REALNAME(MulExt)(y, y, yexp, &r, radius_exp);
}

void REALNAME(Pol2Cart)(REAL* x, REAL* y, const REAL* angle, const REAL* radius)
{
	REAL a_tmp;
	EXP x_exp, y_exp, a_exp, r_exp;
	a_exp = REALNAME(Unpack)(angle, &a_tmp);
	r_exp = REALNAME(Unpack)(radius, x);
	REALNAME(Pol2CartExt)(x, &x_exp, y, &y_exp, &a_tmp, a_exp, x, r_exp);
	REALNAME(Pack)(x, x, x_exp);
	REALNAME(Pack)(y, y, y_exp);
}

// ---------------------------------------------------------------------------
//          arcus cotangent (result is in range -PI/2..+PI/2)
// ---------------------------------------------------------------------------
//  Function uses 7 temporary numbers in the stack.

EXP REALNAME(ACoTanFromExt)(REAL* num, const REAL* src, EXP exp)
{
	exp = REALNAME(ATanFromExt)(num, src, exp);
	return REALNAME(SubExt)(num, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1, num, exp);
}

void REALNAME(ACoTanFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ACoTanFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//    trigonometric test function, The Forensics Evaluation Algorithm
// ---------------------------------------------------------------------------
//  Check precision by formula arcsin(arccos(arctan(tan(cos(sin(9)))))) ... in degrees
//  Returns number of equal bits and result difference from number "9" (should be 0).
//  http://www.datamath.org/Forensics.htm
//  Function uses 8 temporary numbers in the stack.

int REALNAME(Test9_old)(REAL* num)
{
	REAL tmp;
	int i;
	u8 oldunit = Unit;				// save old angle unit
	Unit = UNIT_DEG;				// use DEG unit
	REALNAME(SetUInt)(&tmp, 9);		// input value is 9
	REALNAME(Copy)(num, &tmp);		// input value
	REALNAME(ToRad)(num);			// convert to radians
	REALNAME(Sin_Taylor_old)(num);	// sin
	REALNAME(ToRad)(num);			// convert to radians
	REALNAME(Cos_Taylor_old)(num);	// cos
	REALNAME(ToRad)(num);			// convert to radians
	REALNAME(Tan_old)(num);			// tan
	REALNAME(ATan_Taylor_old)(num);	// arctan
	REALNAME(FromRad)(num);			// convert from radians
	REALNAME(ACos_old)(num);		// arccos
	REALNAME(FromRad)(num);			// convert from radians
	REALNAME(ASin_Taylor_old)(num);	// arcsin
	REALNAME(FromRad)(num);			// convert from radians
	Unit = oldunit;					// restore angle unit
	i = MANT_BITS - REALNAME(CheckDif)(num, &tmp); // check difference
	REALNAME(Sub)(num, num, &tmp);	// difference
	return i;
}

int REALNAME(Test9)(REAL* num)
{
	REAL tmp;
	int i;
	u8 oldunit = Unit;				// save old angle unit
	Unit = UNIT_DEG;				// use DEG unit
	REALNAME(SetUInt)(&tmp, 9);		// input value is 9
	REALNAME(Copy)(num, &tmp);		// input value
	REALNAME(ToRad)(num);			// convert to radians
	REALNAME(Sin)(num);				// sin
	REALNAME(ToRad)(num);			// convert to radians
	REALNAME(Cos)(num);				// cos
	REALNAME(ToRad)(num);			// convert to radians
	REALNAME(Tan)(num);				// tan
	REALNAME(ATan)(num);			// arctan
	REALNAME(FromRad)(num);			// convert from radians
	REALNAME(ACos)(num);			// arccos
	REALNAME(FromRad)(num);			// convert from radians
	REALNAME(ASin)(num);			// arcsin
	REALNAME(FromRad)(num);			// convert from radians
	Unit = oldunit;					// restore angle unit
	i = MANT_BITS - REALNAME(CheckDif)(num, &tmp); // check difference
	REALNAME(Sub)(num, num, &tmp);	// difference
	return i;
}

int REALNAME(Test9Ext)(REAL* num)
{
	REAL tmp;
	EXP tmp_exp, exp;
	int i;
	u8 oldunit = Unit;						// save old angle unit
	Unit = UNIT_DEG;						// use DEG unit
	tmp_exp = REALNAME(SetUIntExt)(&tmp, 9); // input value is 9
	REALNAME(Copy)(num, &tmp); exp = tmp_exp; // input value
	exp = REALNAME(ToRadExt)(num, exp);		// convert to radians
	exp = REALNAME(SinExt)(num, exp);		// sin
	exp = REALNAME(ToRadExt)(num, exp);		// convert to radians
	exp = REALNAME(CosExt)(num, exp);		// cos
	exp = REALNAME(ToRadExt)(num, exp);		// convert to radians
	exp = REALNAME(TanExt)(num, exp);		// tan
	exp = REALNAME(ATanExt)(num, exp);		// arctan
	exp = REALNAME(FromRadExt)(num, exp);	// convert from radians
	exp = REALNAME(ACosExt)(num, exp);		// arccos
	exp = REALNAME(FromRadExt)(num, exp);	// convert from radians
	exp = REALNAME(ASinExt)(num, exp);		// arcsin
	exp = REALNAME(FromRadExt)(num, exp);	// convert from radians
	Unit = oldunit;					// restore angle unit
	i = REAL_BITS - 1 - REALNAME(CheckDifExt)(num, exp, &tmp, tmp_exp); // check difference
	exp = REALNAME(SubExt)(num, num, exp, &tmp, tmp_exp);	// difference
	REALNAME(Pack)(num, num, exp);
	return i;
}

// ---------------------------------------------------------------------------
//                          hyperbolic sine
// ---------------------------------------------------------------------------
//  sinh(x) = (e^x - e^-x)/2
//  Function uses 5 temporary numbers in the stack.

void REALNAME(SinHFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(ExpFrom)(num, src);
	REALNAME(RecFrom)(&m, num);
	REALNAME(Sub)(num, num, &m);
	REALNAME(Div2)(num);
}

EXP REALNAME(SinHFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	exp = REALNAME(ExpFromExt)(num, src, exp);
	exp2 = REALNAME(RecFromExt)(&m, num, exp);
	exp = REALNAME(SubExt)(num, num, exp, &m, exp2);
	return REALNAME(Div2Ext)(num, exp);
}

void REALNAME(SinHFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(SinHFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                          hyperbolic cosine
// ---------------------------------------------------------------------------
//  cosh(x) = (e^x + e^-x)/2
//  Function uses 5 temporary numbers in the stack.

void REALNAME(CosHFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(ExpFrom)(num, src);
	REALNAME(RecFrom)(&m, num);
	REALNAME(Add)(num, num, &m);
	REALNAME(Div2)(num);
}

EXP REALNAME(CosHFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	exp = REALNAME(ExpFromExt)(num, src, exp);
	exp2 = REALNAME(RecFromExt)(&m, num, exp);
	exp = REALNAME(AddExt)(num, num, exp, &m, exp2);
	return REALNAME(Div2Ext)(num, exp);
}

void REALNAME(CosHFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(CosHFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                        hyperbolic tangent
// ---------------------------------------------------------------------------
//  tanh(x) = (e^2x - 1) / (e^2x + 1)
//  Function uses 5 temporary numbers in the stack.

void REALNAME(TanHFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(Copy)(num, src);
	REALNAME(Mul2)(num);
	REALNAME(Exp)(num);
	REALNAME(IncFrom)(&m, num);
	REALNAME(Dec)(num);
	REALNAME(Div)(num, num, &m);
}

EXP REALNAME(TanHFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	REALNAME(Copy)(num, src);
	exp = REALNAME(Mul2Ext)(num, exp);
	exp = REALNAME(ExpExt)(num, exp);
	exp2 = REALNAME(IncFromExt)(&m, num, exp);
	exp = REALNAME(DecExt)(num, exp);
	return REALNAME(DivExt)(num, num, exp, &m, exp2);
}

void REALNAME(TanHFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(TanHFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                        hyperbolic cotangent
// ---------------------------------------------------------------------------
//  cotanh(x) = (e^2x + 1) / (e^2x - 1)
//  Function uses 5 temporary numbers in the stack.

void REALNAME(CoTanHFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(Copy)(num, src);
	REALNAME(Mul2)(num);
	REALNAME(Exp)(num);
	REALNAME(DecFrom)(&m, num);
	REALNAME(Inc)(num);
	REALNAME(Div)(num, num, &m);
}

EXP REALNAME(CoTanHFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	REALNAME(Copy)(num, src);
	exp = REALNAME(Mul2Ext)(num, exp);
	exp = REALNAME(ExpExt)(num, exp);
	exp2 = REALNAME(DecFromExt)(&m, num, exp);
	exp = REALNAME(IncExt)(num, exp);
	return REALNAME(DivExt)(num, num, exp, &m, exp2);
}

void REALNAME(CoTanHFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(CoTanHFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                       hyperbolic secant
// ---------------------------------------------------------------------------
//  sech(x) = 2*e^x / (e^2x + 1)
//  Function uses 5 temporary numbers in the stack.

void REALNAME(SecHFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(ExpFrom)(num, src);
	REALNAME(SqrFrom)(&m, num);
	REALNAME(Inc)(&m);
	REALNAME(Mul2)(num);
	REALNAME(Div)(num, num, &m);
}

EXP REALNAME(SecHFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	exp = REALNAME(ExpFromExt)(num, src, exp);
	exp2 = REALNAME(SqrFromExt)(&m, num, exp);
	exp2 = REALNAME(IncExt)(&m, exp2);
	exp = REALNAME(Mul2Ext)(num, exp);
	return REALNAME(DivExt)(num, num, exp, &m, exp2);
}

void REALNAME(SecHFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(SecHFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                        hyperbolic cosecant
// ---------------------------------------------------------------------------
//  csch(x) = 2*e^x / (e^2x - 1)
//  Function uses 5 temporary numbers in the stack.

void REALNAME(CscHFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(ExpFrom)(num, src);
	REALNAME(SqrFrom)(&m, num);
	REALNAME(Dec)(&m);
	REALNAME(Mul2)(num);
	REALNAME(Div)(num, num, &m);
}

EXP REALNAME(CscHFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	exp = REALNAME(ExpFromExt)(num, src, exp);
	exp2 = REALNAME(SqrFromExt)(&m, num, exp);
	exp2 = REALNAME(DecExt)(&m, exp2);
	exp = REALNAME(Mul2Ext)(num, exp);
	return REALNAME(DivExt)(num, num, exp, &m, exp2);
}

void REALNAME(CscHFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(CscHFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                 areasine, inverse hyperbolic sine
// ---------------------------------------------------------------------------
//  arsh(x) = ln(x + sqrt(x^2 + 1))
//  Function uses 6 temporary numbers in the stack.

void REALNAME(ArSinHFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(SqrFrom)(&m, src);
	REALNAME(Inc)(&m);
	REALNAME(Sqrt)(&m);
	REALNAME(Add)(num, src, &m);
	REALNAME(Ln)(num);
}

EXP REALNAME(ArSinHFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	exp2 = REALNAME(SqrFromExt)(&m, src, exp);
	exp2 = REALNAME(IncExt)(&m, exp2);
	exp2 = REALNAME(SqrtExt)(&m, exp2);
	exp = REALNAME(AddExt)(num, src, exp, &m, exp2);
	return REALNAME(LnExt)(num, exp);
}

void REALNAME(ArSinHFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ArSinHFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                  areacosine, inverse hyperbolic cosine
// ---------------------------------------------------------------------------
//  arch(x) = ln(x + sqrt(x^2 - 1))
//  Function uses 6 temporary numbers in the stack.

void REALNAME(ArCosHFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(SqrFrom)(&m, src);
	REALNAME(Dec)(&m);
	REALNAME(Sqrt)(&m);
	REALNAME(Add)(num, src, &m);
	REALNAME(Ln)(num);
}

EXP REALNAME(ArCosHFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	exp2 = REALNAME(SqrFromExt)(&m, src, exp);
	exp2 = REALNAME(DecExt)(&m, exp2);
	exp2 = REALNAME(SqrtExt)(&m, exp2);
	exp = REALNAME(AddExt)(num, src, exp, &m, exp2);
	return REALNAME(LnExt)(num, exp);
}

void REALNAME(ArCosHFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ArCosHFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//             areatangent, inverse hyperbolic tangent
// ---------------------------------------------------------------------------
//  arth(x) = ln((1 + x)/(1 - x))/2
//  Function uses 6 temporary numbers in the stack.

void REALNAME(ArTanHFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(Sub)(&m, &REALNAME(Const1), src);
	REALNAME(IncFrom)(num, src);
	REALNAME(Div)(num, num, &m);
	REALNAME(Ln)(num);
	REALNAME(Div2)(num);
}

EXP REALNAME(ArTanHFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	exp2 = REALNAME(SubExt)(&m, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1, src, exp);
	exp = REALNAME(IncFromExt)(num, src, exp);
	exp = REALNAME(DivExt)(num, num, exp, &m, exp2);
	exp = REALNAME(LnExt)(num, exp);
	return REALNAME(Div2Ext)(num, exp);
}

void REALNAME(ArTanHFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ArTanHFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                areacotangent, inverse hyperbolic cotangent
// ---------------------------------------------------------------------------
//  arcth(x) = ln((x + 1)/(x - 1))/2
//  Function uses 6 temporary numbers in the stack.

void REALNAME(ArCoTanHFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(DecFrom)(&m, src);
	REALNAME(IncFrom)(num, src);
	REALNAME(Div)(num, num, &m);
	REALNAME(Ln)(num);
	REALNAME(Div2)(num);
}

EXP REALNAME(ArCoTanHFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	exp2 = REALNAME(DecFromExt)(&m, src, exp);
	exp = REALNAME(IncFromExt)(num, src, exp);
	exp = REALNAME(DivExt)(num, num, exp, &m, exp2);
	exp = REALNAME(LnExt)(num, exp);
	return REALNAME(Div2Ext)(num, exp);
}

void REALNAME(ArCoTanHFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ArCoTanHFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//                areasecant, inverse hyperbolic secant
// ---------------------------------------------------------------------------
//  arsch(x) = ln((1 + sqrt(1 - x^2))/x)
//  Function uses 6 temporary numbers in the stack.

void REALNAME(ArSecHFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(SqrFrom)(&m, src);
	REALNAME(Sub)(&m, &REALNAME(Const1), &m);
	REALNAME(Sqrt)(&m);
	REALNAME(Inc)(&m);
	REALNAME(Div)(num, &m, num);
	REALNAME(Ln)(num);
}

EXP REALNAME(ArSecHFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	exp2 = REALNAME(SqrFromExt)(&m, src, exp);
	exp2 = REALNAME(SubExt)(&m, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1, &m, exp2);
	exp2 = REALNAME(SqrtExt)(&m, exp2);
	exp2 = REALNAME(IncExt)(&m, exp2);
	exp = REALNAME(DivExt)(num, &m, exp2, num, exp);
	return REALNAME(LnExt)(num, exp);
}

void REALNAME(ArSecHFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ArSecHFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//             areacosecant, inverse hyperbolic cosecant
// ---------------------------------------------------------------------------
//  arcsch(x) = ln((1 - sqrt(1 + x^2))/x) ... x<0
//  arcsch(x) = ln((1 + sqrt(1 + x^2))/x) ... x>0
//  Function uses 6 temporary numbers in the stack.

void REALNAME(ArCscHFrom_old)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(SqrFrom)(&m, src);
	REALNAME(Inc)(&m);
	REALNAME(Sqrt)(&m);
	if (REALNAME(IsNeg)(src))
		REALNAME(Sub)(&m, &REALNAME(Const1), &m);
	else
		REALNAME(Inc)(&m);
	REALNAME(Div)(num, &m, src);
	REALNAME(Ln)(num);
}

EXP REALNAME(ArCscHFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	exp2 = REALNAME(SqrFromExt)(&m, src, exp);
	exp2 = REALNAME(IncExt)(&m, exp2);
	exp2 = REALNAME(SqrtExt)(&m, exp2);
	if ((exp & EXPEXT_SIGN) != 0) // IsNeg
		exp2 = REALNAME(SubExt)(&m, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1, &m, exp2);
	else
		exp2 = REALNAME(IncExt)(&m, exp2);
	exp = REALNAME(DivExt)(num, &m, exp2, num, exp);
	return REALNAME(LnExt)(num, exp);
}

void REALNAME(ArCscHFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(ArCscHFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// ---------------------------------------------------------------------------
//     generate random number in range 0<= .. <1 (resolution max. 64 bits)
// ---------------------------------------------------------------------------

void REALNAME(Rnd)(REAL* num)
{
#if MANT_BITS > 32

	// generate random number
	u64 rnd = RandU64();

	// set random number
	REALNAME(SetU64)(num, rnd);

	// divide by 64 bits
	REALNAME(Pow2)(num, -64);

#elif MANT_BITS > 16

	// generate random number
	u32 rnd = RandU32();

	// set random number
	REALNAME(SetU32)(num, rnd);

	// divide by 32 bits
	REALNAME(Pow2)(num, -32);

#elif MANT_BITS > 8

	// generate random number
	u16 rnd = RandU16();

	// set random number
	REALNAME(SetU16)(num, rnd);

	// divide by 16 bits
	REALNAME(Pow2)(num, -16);

#else

	// generate random number
	u8 rnd = RandU8();

	// set random number
	REALNAME(SetU8)(num, rnd);

	// divide by 8 bits
	REALNAME(Pow2)(num, -8);

#endif

}

EXP REALNAME(RndExt)(REAL* num)
{
	EXP exp;

#if REAL_BITS > 32

	// generate random number
	u64 rnd = RandU64();

	// set random number
	exp = REALNAME(SetU64Ext)(num, rnd);

	// divide by 64 bits
	return REALNAME(Pow2Ext)(num, exp, -64);

#elif MANT_BITS > 16

	// generate random number
	u32 rnd = RandU32();

	// set random number
	exp = REALNAME(SetU32Ext)(num, rnd);

	// divide by 32 bits
	return REALNAME(Pow2Ext)(num, exp, -32);

#elif MANT_BITS > 8

	// generate random number
	u16 rnd = RandU16();

	// set random number
	exp = REALNAME(SetU16Ext)(num, rnd);

	// divide by 16 bits
	return REALNAME(Pow2Ext)(num, exp, -16);

#else

	// generate random number
	u8 rnd = RandU8();

	// set random number
	exp = REALNAME(SetU8Ext)(num, rnd);

	// divide by 8 bits
	return REALNAME(Pow2Ext)(num, exp, -8);

#endif

}

// ---------------------------------------------------------------------------
//         random number in range 0<= .. <num (resolution max. 64 bits)
// ---------------------------------------------------------------------------

EXP REALNAME(RndMaxFromExt)(REAL* num, const REAL* src, EXP exp)
{
	REAL m;
	EXP exp2;
	exp2 = REALNAME(RndExt)(&m);
	return REALNAME(MulExt)(num, src, exp, &m, exp2);
}

void REALNAME(RndMaxFrom)(REAL* num, const REAL* src)
{
	REAL m;
	REALNAME(Rnd)(&m);
	REALNAME(Mul)(num, src, &m);
}

// ---------------------------------------------------------------------------
//     Chebyshev callback functions (input number is in range -1 .. +1)
// ---------------------------------------------------------------------------

// Ln()
void REALNAME(ChebCB_Ln)(REAL* num)
{
	// required interval 1..1.9999
	REALNAME(Inc)(num); // -1..+1 -> 0..+2
	REALNAME(Div2)(num); // 0..+2 -> 0..+1
	REALNAME(Inc)(num); // 0..+1 -> 1..+2
	REALNAME(Ln_Taylor)(num);
}

EXP REALNAME(ChebCB_LnExt)(REAL* num, EXP exp)
{
	// required interval 1..1.9999
	exp = REALNAME(IncExt)(num, exp); // -1..+1 -> 0..+2
	exp = REALNAME(Div2Ext)(num, exp); // 0..+2 -> 0..+1
	exp = REALNAME(IncExt)(num, exp); // 0..+1 -> 1..+2
	return REALNAME(Ln_TaylorExt)(num, exp);
}

// Exp()
void REALNAME(ChebCB_Exp)(REAL* num)
{
	// required interval -0.6931..+0.6931 (-ln(2) .. +ln(2))
	REALNAME(Mul)(num, num, &REALNAME(ConstLn2)); // -1..+1 -> -ln(2)..+ln(2)
	REALNAME(Exp_Taylor)(num);
}

EXP REALNAME(ChebCB_ExpExt)(REAL* num, EXP exp)
{
	// required interval -0.6931..+0.6931 (-ln(2) .. +ln(2))
	exp = REALNAME(MulExt)(num, num, exp, (const REAL*)&REALNAME(ConstLn2Ext), EXPEXT_1 - 1); // -1..+1 -> -ln(2)..+ln(2)
	return REALNAME(Exp_TaylorExt)(num, exp);
}

// Sin()
void REALNAME(ChebCB_Sin)(REAL* num)
{
	// required interval 0..PI/2
	REALNAME(Inc)(num); // -1..+1 -> 0..+2
	REALNAME(Div2)(num); // 0..+2 -> 0..+1
	REALNAME(Mul)(num, num, &REALNAME(ConstPi05)); // 0..+1 -> 0..PI/2
	REALNAME(Sin_Taylor)(num);

/*
	// required interval 0..PI
	REALNAME(Inc)(num); // -1..+1 -> 0..+2
	REALNAME(Mul)(num, num, &REALNAME(ConstPi05)); // 0..+2 -> 0..PI
	REALNAME(Sin_Taylor)(num);
*/
}

EXP REALNAME(ChebCB_SinExt)(REAL* num, EXP exp)
{
	// required interval 0..PI/2
	exp = REALNAME(IncExt)(num, exp); // -1..+1 -> 0..+2
	exp = REALNAME(Div2Ext)(num, exp); // 0..+2 -> 0..+1
	exp = REALNAME(MulExt)(num, num, exp, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1); // 0..+1 -> 0..PI/2
	return REALNAME(Sin_TaylorExt)(num, exp);

/*
	// required interval 0..PI
	exp = REALNAME(IncExt)(num, exp); // -1..+1 -> 0..+2
	exp = REALNAME(MulExt)(num, num, exp, (const REAL*)&REALNAME(ConstPi05Ext), EXPEXT_1); // 0..+2 -> 0..PI
	return REALNAME(Sin_TaylorExt)(num, exp);
*/
}

// ASin()
void REALNAME(ChebCB_ASin)(REAL* num)
{
	// required interval 0..+0.75
	REALNAME(Inc)(num); // -1..+1 -> 0..+2
	REALNAME(Div2)(num);
	REALNAME(Mul)(num, num, &REALNAME(Const075));
	REALNAME(ASin_Taylor)(num);
}

EXP REALNAME(ChebCB_ASinExt)(REAL* num, EXP exp)
{
	// required interval 0..+0.75
	exp = REALNAME(IncExt)(num, exp); // -1..+1 -> 0..+2
	exp = REALNAME(Div2Ext)(num, exp);
	exp = REALNAME(MulExt)(num, num, exp, (const REAL*)&REALNAME(Const075Ext), EXPEXT_1 - 1);
	return REALNAME(ASin_TaylorExt)(num, exp);
}

// ATan()
void REALNAME(ChebCB_ATan)(REAL* num)
{
	REAL x;

	// required result y = x*fnc(2*x^2-1)

	REALNAME(Inc)(num); // x+1, -1..+1 -> 0..+2
	if (REALNAME(IsZero)(num) || REALNAME(IsNeg)(num))
	{
		REALNAME(Set1)(num);
		return;
	}
	REALNAME(Div2)(num); // (x+1)/2, 0..+2 -> 0..+1
	REALNAME(Sqrt_Newton)(num); // sqrt((x+1)/2)
	if (REALNAME(IsZero)(num))
	{
		REALNAME(Set1)(num);
		return;
	}
	REALNAME(Copy)(&x, num);
	REALNAME(ATan_Taylor)(num);
	REALNAME(Div)(num, num, &x); // y/x
}

EXP REALNAME(ChebCB_ATanExt)(REAL* num, EXP exp)
{
	REAL x;
	EXP exp2;

	// required result y = x*fnc(2*x^2-1)

	exp = REALNAME(IncExt)(num, exp); // x+1, -1..+1 -> 0..+2
	if (((exp & EXPEXT_MASK) == EXPEXT_0) || ((exp & EXPEXT_SIGN) != 0)) // num = 0 or num < 0
	{
		REALNAME(Set1Ext)(num);
		return EXPEXT_1;
	}
	exp = REALNAME(Div2Ext)(num, exp); // (x+1)/2, 0..+2 -> 0..+1
	exp = REALNAME(Sqrt_NewtonExt)(num, exp); // sqrt((x+1)/2)
	if ((exp & EXPEXT_MASK) == EXPEXT_0)
	{
		REALNAME(Set1Ext)(num);
		return EXPEXT_1;
	}
	REALNAME(Copy)(&x, num);
	exp2 = REALNAME(ATan_TaylorExt)(num, exp);
	return REALNAME(DivExt)(num, num, exp2, &x, exp); // y/x
}

// Sqrt()
void REALNAME(ChebCB_Sqrt)(REAL* num)
{
	REALNAME(Inc)(num); // -1..+1 -> 0..+2
	REALNAME(Mul)(num, num, &REALNAME(Const075)); // *3/4, 0..+2 -> 0..3/2
	REALNAME(Mul2)(num); // 0..3/2 -> 0..3
	REALNAME(Inc)(num); // 0..3 -> 1..4
	REALNAME(Sqrt_Newton)(num);
}

EXP REALNAME(ChebCB_SqrtExt)(REAL* num, EXP exp)
{
	exp = REALNAME(IncExt)(num, exp); // -1..+1 -> 0..+2
	exp = REALNAME(MulExt)(num, num, exp, (const REAL*)&REALNAME(Const075Ext), EXPEXT_1 - 1); // *3/4, 0..+2 -> 0..3/2
	exp = REALNAME(Mul2Ext)(num, exp); // 0..3/2 -> 0..3
	exp = REALNAME(IncExt)(num, exp); // 0..3 -> 1..4
	return REALNAME(Sqrt_NewtonExt)(num, exp);
}

// ---------------------------------------------------------------------------
//             Calculate coefficients of Chebyshev approximation
// ---------------------------------------------------------------------------
// Requires 2*num REAL numbers to be temporary allocated using malloc function.
//  fnc = callback function to be approximated by Chebyshev polynomial
//  num = number of coefficients (=order of Chebyshev polynomial, min. 2)
//  poly = pointer to array of 'num' polynomial coefficients
//	cb = progress callback function (NULL = none)

void REALNAME(ChebCoef)(REALNAME(chebfnc_cb) fnc, int num, REAL* poly, chebprogress_cb cb)
{
	int i;
	REAL *t1, *t2, *t;
	REAL pi, nn;
	u64 loops, loop;
	int j;
	REAL c, d, f, tmp;

	// check minimal order
	if (num < 2) return;

	for (i = 0; i < num; i++) REALNAME(Set0)(&poly[i]);

	// allocate temporary arrays
	t1 = (REAL*)MemAlloc(num*sizeof(REAL));
	if (t1 == NULL) return;
	t2 = (REAL*)MemAlloc(num*sizeof(REAL));
	if (t2 == NULL)
	{
		MemFree(t1);
		return;
	}

	for (i = 0; i < num; i++)
	{
		REALNAME(Set0)(&t1[i]);
		REALNAME(Set0)(&t2[i]);
	}

	// prepare PI/num and 2/num
	REALNAME(SetUInt)(&pi, (BASE)num);
	REALNAME(Div)(&nn, &REALNAME(Const2), &pi);
	REALNAME(Div)(&pi, &REALNAME(ConstPi), &pi);

	// total number of loops
	loops = (u64)num*num;
	loop = 0;

	// loop through coefficients
	for (i = 0; i < num; i++)
	{
		// calculate one coefficient 
		REALNAME(Set0)(&c);
		for (j = 0; j < num; j++)
		{
			// progress
			if (cb != NULL)
			{
				if ((loop & 0xf) == 0)
				{
					cb((int)(loop*1000/loops));
				}
				loop++;
			}

			// prepare d = (j + 0.5)*PI/num
			REALNAME(SetUInt)(&d, (BASE)j);
			REALNAME(Add)(&d, &d, &REALNAME(Const05));
			REALNAME(Mul)(&d, &d, &pi);

			// cos(d)
			REALNAME(Cos_TaylorFrom)(&f, &d);

			// call user function
			fnc(&f);

			// calculate f*cos(i*d)
			REALNAME(SetUInt)(&tmp, (BASE)i);
			REALNAME(Mul)(&tmp, &tmp, &d);
			REALNAME(Cos_Taylor)(&tmp);
			REALNAME(Mul)(&tmp, &tmp, &f);

			// add to coefficient
			REALNAME(Add)(&c, &c, &tmp);
		}

		// c *= 2/num
		REALNAME(Mul)(&c, &c, &nn);

// t1 is "this" Tn polynom, t2 is both "next" T{n+1} and "previous" T{n-1} polynom

		// T0 polynom
		if (i == 0)
		{
			// T0 = 1
			REALNAME(Set1)(&t1[0]);

			// c0/2
			REALNAME(Copy)(&poly[0], &c);
			REALNAME(Div2)(&poly[0]);
		}

		// T1 polynom
		else if (i == 1)
		{
			// T1 = x
			REALNAME(Set1)(&t1[1]);

			// c1
			REALNAME(Copy)(&poly[1], &c);
		}

		// higher polynoms
		else
		{
			// update level x^0: T{n+1} = - T{n-1}
			REALNAME(Neg)(&t1[0]);

			// poly[0] += t1[0]*c
			REALNAME(Mul)(&tmp, &t1[0], &c);
			REALNAME(Add)(&poly[0], &poly[0], &tmp);

			// update levels x^1..x^(num-1): T{n+1} = 2*x*T{n} - T{n-1}
			for (j = 1; j < num; j++)
			{
				// t1[j] = 2*t2[j-1] - t1[j];
				REALNAME(Copy)(&tmp, &t2[j-1]);
				REALNAME(Mul2)(&tmp);
				REALNAME(Neg)(&t1[j]);
				REALNAME(Add)(&t1[j], &t1[j], &tmp);

				// poly[j] += t1[j]*c
				REALNAME(Mul)(&tmp, &t1[j], &c);
				REALNAME(Add)(&poly[j], &poly[j], &tmp);
			}
		}

		// shift polynoms
		t = t1;
		t1 = t2;
		t2 = t;
	}

	// release temporary arrays
	MemFree(t1);
	MemFree(t2);
}

// Calculate coefficients of Chebyshev approximation
// Requires 2*num REAL numbers to be temporary allocated using malloc function.
//  fnc = callback function to be approximated by Chebyshev polynomial
//  num = number of coefficients (=order of Chebyshev polynomial, min. 2)
//  poly = pointer to array of 'num' polynomial coefficients, mantissas of extended format
//  poly_exp = pointer to array of 'num' polynomial coefficients, exponents of extended format
//	cb = progress callback function (NULL = none)
void REALNAME(ChebCoefExt)(REALNAME(chebfnc_cbext) fnc, int num, REAL* poly, EXP* poly_exp, chebprogress_cb cb)
{
	int i;
	REAL *t1, *t2, *t;
	EXP *t1_exp, *t2_exp, *t_exp;
	REAL pi, nn;
	EXP pi_exp, nn_exp;
	u64 loops, loop;
	int j;
	REAL c, d, f, tmp;
	EXP c_exp, d_exp, f_exp, tmp_exp;

	// check minimal order
	if (num < 2) return;

	for (i = 0; i < num; i++)
	{
		REALNAME(Set0Ext)(&poly[i]);
		poly_exp[i] = EXPEXT_0;
	}

	// allocate temporary arrays
	t1 = (REAL*)MemAlloc(num*sizeof(REAL));
	t2 = (REAL*)MemAlloc(num*sizeof(REAL));
	t1_exp = (EXP*)MemAlloc(num*sizeof(EXP));
	t2_exp = (EXP*)MemAlloc(num*sizeof(EXP));
	if ((t1 == NULL) || (t2 == NULL) || (t1_exp == NULL) || (t2_exp == NULL))
	{
		MemFree(t1);
		MemFree(t2);
		MemFree(t1_exp);
		MemFree(t2_exp);
		return;
	}

	for (i = 0; i < num; i++)
	{
		REALNAME(Set0Ext)(&t1[i]);
		REALNAME(Set0Ext)(&t2[i]);
		t1_exp[i] = EXPEXT_0;
		t2_exp[i] = EXPEXT_0;
	}

	// prepare PI/num and 2/num
	pi_exp = REALNAME(SetUIntExt)(&pi, (BASE)num);
	nn_exp = REALNAME(DivExt)(&nn, (const REAL*)&REALNAME(Const2Ext), EXPEXT_1 + 1, &pi, pi_exp);
	pi_exp = REALNAME(DivExt)(&pi, (const REAL*)&REALNAME(ConstPiExt), EXPEXT_1 + 1, &pi, pi_exp);

	// total number of loops
	loops = (u64)num*num;
	loop = 0;

	// loop through coefficients
	for (i = 0; i < num; i++)
	{
		// calculate one coefficient 
		REALNAME(Set0Ext)(&c);
		c_exp = EXPEXT_0;
		for (j = 0; j < num; j++)
		{
			// progress
			if (cb != NULL)
			{
				if ((loop & 0xf) == 0)
				{
					cb((int)(loop*1000/loops));
				}
				loop++;
			}

			// prepare d = (j + 0.5)*PI/num
			d_exp = REALNAME(SetUIntExt)(&d, (BASE)j);
			d_exp = REALNAME(AddExt)(&d, &d, d_exp, (const REAL*)&REALNAME(Const05Ext), EXPEXT_1 - 1);
			d_exp = REALNAME(MulExt)(&d, &d, d_exp, &pi, pi_exp);

			// cos(d)
			f_exp = REALNAME(Cos_TaylorFromExt)(&f, &d, d_exp);

			// call user function
			f_exp = fnc(&f, f_exp);

			// calculate f*cos(i*d)
			tmp_exp = REALNAME(SetUIntExt)(&tmp, (BASE)i);
			tmp_exp = REALNAME(MulExt)(&tmp, &tmp, tmp_exp, &d, d_exp);
			tmp_exp = REALNAME(Cos_TaylorExt)(&tmp, tmp_exp);
			tmp_exp = REALNAME(MulExt)(&tmp, &tmp, tmp_exp, &f, f_exp);

			// add to coefficient
			c_exp = REALNAME(AddExt)(&c, &c, c_exp, &tmp, tmp_exp);
		}

		// c *= 2/num
		c_exp = REALNAME(MulExt)(&c, &c, c_exp, &nn, nn_exp);

// t1 is "this" Tn polynom, t2 is both "next" T{n+1} and "previous" T{n-1} polynom

		// T0 polynom
		if (i == 0)
		{
			// T0 = 1
			REALNAME(Set1Ext)(&t1[0]);
			t1_exp[0] = EXPEXT_1;

			// c0/2
			REALNAME(Copy)(&poly[0], &c);
			poly_exp[0] = REALNAME(Div2Ext)(&poly[0], c_exp);
		}

		// T1 polynom
		else if (i == 1)
		{
			// T1 = x
			REALNAME(Set1Ext)(&t1[1]);
			t1_exp[1] = EXPEXT_1;

			// c1
			REALNAME(Copy)(&poly[1], &c);
			poly_exp[1] = c_exp;
		}

		// higher polynoms
		else
		{
			// update level x^0: T{n+1} = - T{n-1}
			t1_exp[0] ^= EXPEXT_SIGN; // REALNAME(Neg)(&t1[0]);

			// poly[0] += t1[0]*c
			tmp_exp = REALNAME(MulExt)(&tmp, &t1[0], t1_exp[0], &c, c_exp);
			poly_exp[0] = REALNAME(AddExt)(&poly[0], &poly[0], poly_exp[0], &tmp, tmp_exp);

			// update levels x^1..x^(num-1): T{n+1} = 2*x*T{n} - T{n-1}
			for (j = 1; j < num; j++)
			{
				// t1[j] = 2*t2[j-1] - t1[j];
				REALNAME(Copy)(&tmp, &t2[j-1]);
				tmp_exp = REALNAME(Mul2Ext)(&tmp, t2_exp[j-1]);
				t1_exp[j] ^= EXPEXT_SIGN; // REALNAME(Neg)(&t1[j]);
				t1_exp[j] = REALNAME(AddExt)(&t1[j], &t1[j], t1_exp[j], &tmp, tmp_exp);

				// poly[j] += t1[j]*c
				tmp_exp = REALNAME(MulExt)(&tmp, &t1[j], t1_exp[j], &c, c_exp);
				poly_exp[j] = REALNAME(AddExt)(&poly[j], &poly[j], poly_exp[j], &tmp, tmp_exp);
			}
		}

		// shift polynoms
		t = t1;
		t1 = t2;
		t2 = t;
		t_exp = t1_exp;
		t1_exp = t2_exp;
		t2_exp = t_exp;
	}

	// release temporary arrays
	MemFree(t1);
	MemFree(t2);
	MemFree(t1_exp);
	MemFree(t2_exp);
}

// ---------------------------------------------------------------------------
// Calculate coefficients of Chebyshev approximation - precise, using reference REAL numbers
// ---------------------------------------------------------------------------
// Requires 3*num REALREF numbers to be temporary allocated using malloc function.
//  fnc = index of callback function CHEBCB_*
//  num = number of coefficients (=order of Chebyshev polynomial, min. 2)
//  poly = pointer to array of polynomial coefficients
//	cb = progress callback function (NULL = none)

void REALNAME(ChebCoefRef)(int fnc, int num, REAL* poly, chebprogress_cb cb)
{
#ifdef REALREF // reference number is valid

	int i;
	REALREF* polyref;

	// allocate temporary arrays
	polyref = (REALREF*)MemAlloc(num*sizeof(REALREF));
	if (polyref == NULL) return;

	// generate coefficients
	if (fnc == CHEBCB_LN)
		REALREFNAME(ChebCoef)(REALREFNAME(ChebCB_Ln), num, polyref, cb);
	else if (fnc == CHEBCB_EXP)
		REALREFNAME(ChebCoef)(REALREFNAME(ChebCB_Exp), num, polyref, cb);
	else if (fnc == CHEBCB_SIN)
		REALREFNAME(ChebCoef)(REALREFNAME(ChebCB_Sin), num, polyref, cb);
	else if (fnc == CHEBCB_ASIN)
		REALREFNAME(ChebCoef)(REALREFNAME(ChebCB_ASin), num, polyref, cb);
	else if (fnc == CHEBCB_ATAN)
		REALREFNAME(ChebCoef)(REALREFNAME(ChebCB_ATan), num, polyref, cb);
	else if (fnc == CHEBCB_SQRT)
		REALREFNAME(ChebCoef)(REALREFNAME(ChebCB_Sqrt), num, polyref, cb);
  
	// import coefficients
	for (i = 0; i < num; i++) REALNAME(ImportRef)(&poly[i], &polyref[i]);

	MemFree(polyref);

#else // HASREF

	if (fnc == CHEBCB_LN)
		REALNAME(ChebCoef)(REALNAME(ChebCB_Ln), num, poly, cb);
	else if (fnc == CHEBCB_EXP)
		REALNAME(ChebCoef)(REALNAME(ChebCB_Exp), num, poly, cb);
	else if (fnc == CHEBCB_SIN)
		REALNAME(ChebCoef)(REALNAME(ChebCB_Sin), num, poly, cb);
	else if (fnc == CHEBCB_ASIN)
		REALNAME(ChebCoef)(REALNAME(ChebCB_ASin), num, poly, cb);
	else if (fnc == CHEBCB_ATAN)
		REALNAME(ChebCoef)(REALNAME(ChebCB_ATan), num, poly, cb);
	else if (fnc == CHEBCB_SQRT)
		REALNAME(ChebCoef)(REALNAME(ChebCB_Sqrt), num, poly, cb);

#endif // HASREF
}

// ---------------------------------------------------------------------------
// Calculate coefficients of Chebyshev approximation - precise, using reference REAL numbers and extended destination numbers
// ---------------------------------------------------------------------------
// Requires 3*num REALREF numbers to be temporary allocated using malloc function.
//  fnc = index of callback function CHEBCB_*
//  num = number of coefficients (=order of Chebyshev polynomial, min. 2)
//  poly = pointer to array of polynomial coefficients, mantissas of extended format
//  poly_exp = pointer to array of polynomial coefficients, exponents of extended format
//	cb = progress callback function (NULL = none)

void REALNAME(ChebCoefRefExt)(int fnc, int num, REAL* poly, EXP* poly_exp, chebprogress_cb cb)
{
#ifdef REALREF // reference number is valid

	int i;
	REALREF *polyref;
	EXP *polyexp;

	// allocate temporary arrays
	polyref = (REALREF*)MemAlloc(num*sizeof(REALREF));
	if (polyref == NULL) return;
	polyexp = (EXP*)MemAlloc(num*sizeof(EXP));
	if (polyexp == NULL)
	{
		MemFree(polyref);
		return;
	}

	// generate coefficients
	if (fnc == CHEBCB_LN)
		REALREFNAME(ChebCoefExt)(REALREFNAME(ChebCB_LnExt), num, polyref, polyexp, cb);
	else if (fnc == CHEBCB_EXP)
		REALREFNAME(ChebCoefExt)(REALREFNAME(ChebCB_ExpExt), num, polyref, polyexp, cb);
	else if (fnc == CHEBCB_SIN)
		REALREFNAME(ChebCoefExt)(REALREFNAME(ChebCB_SinExt), num, polyref, polyexp, cb);
	else if (fnc == CHEBCB_ASIN)
		REALREFNAME(ChebCoefExt)(REALREFNAME(ChebCB_ASinExt), num, polyref, polyexp, cb);
	else if (fnc == CHEBCB_ATAN)
		REALREFNAME(ChebCoefExt)(REALREFNAME(ChebCB_ATanExt), num, polyref, polyexp, cb);
	else if (fnc == CHEBCB_SQRT)
		REALREFNAME(ChebCoefExt)(REALREFNAME(ChebCB_SqrtExt), num, polyref, polyexp, cb);
  
	// import coefficients
	for (i = 0; i < num; i++) poly_exp[i] = REALNAME(ImportRefExt2)(&poly[i], &polyref[i], polyexp[i]);

	MemFree(polyref);
	MemFree(polyexp);

#else // HASREF

	if (fnc == CHEBCB_LN)
		REALNAME(ChebCoefExt)(REALNAME(ChebCB_LnExt), num, poly, poly_exp, cb);
	else if (fnc == CHEBCB_EXP)
		REALNAME(ChebCoefExt)(REALNAME(ChebCB_ExpExt), num, poly, poly_exp, cb);
	else if (fnc == CHEBCB_SIN)
		REALNAME(ChebCoefExt)(REALNAME(ChebCB_SinExt), num, poly, poly_exp, cb);
	else if (fnc == CHEBCB_ASIN)
		REALNAME(ChebCoefExt)(REALNAME(ChebCB_ASinExt), num, poly, poly_exp, cb);
	else if (fnc == CHEBCB_ATAN)
		REALNAME(ChebCoefExt)(REALNAME(ChebCB_ATanExt), num, poly, poly_exp, cb);
	else if (fnc == CHEBCB_SQRT)
		REALNAME(ChebCoefExt)(REALNAME(ChebCB_SqrtExt), num, poly, poly_exp, cb);

#endif // HASREF
}

void REALNAME(ChebCoefRefExt_old)(int fnc, int num, REAL* poly, EXP* poly_exp, chebprogress_cb cb)
{
#ifdef REALREF // reference number is valid

	int i;
	REALREF* polyref;

	// allocate temporary arrays
	polyref = (REALREF*)MemAlloc(num*sizeof(REALREF));
	if (polyref == NULL) return;

	// generate coefficients
	if (fnc == CHEBCB_LN)
		REALREFNAME(ChebCoef)(REALREFNAME(ChebCB_Ln), num, polyref, cb);
	else if (fnc == CHEBCB_EXP)
		REALREFNAME(ChebCoef)(REALREFNAME(ChebCB_Exp), num, polyref, cb);
	else if (fnc == CHEBCB_SIN)
		REALREFNAME(ChebCoef)(REALREFNAME(ChebCB_Sin), num, polyref, cb);
	else if (fnc == CHEBCB_ASIN)
		REALREFNAME(ChebCoef)(REALREFNAME(ChebCB_ASin), num, polyref, cb);
	else if (fnc == CHEBCB_ATAN)
		REALREFNAME(ChebCoef)(REALREFNAME(ChebCB_ATan), num, polyref, cb);
	else if (fnc == CHEBCB_SQRT)
		REALREFNAME(ChebCoef)(REALREFNAME(ChebCB_Sqrt), num, polyref, cb);
  
	// import coefficients
	for (i = 0; i < num; i++) poly_exp[i] = REALNAME(ImportRefExt)(&poly[i], &polyref[i]);

	MemFree(polyref);

#else // HASREF

	int i;

	if (fnc == CHEBCB_LN)
		REALNAME(ChebCoef)(REALNAME(ChebCB_Ln), num, poly, cb);
	else if (fnc == CHEBCB_EXP)
		REALNAME(ChebCoef)(REALNAME(ChebCB_Exp), num, poly, cb);
	else if (fnc == CHEBCB_SIN)
		REALNAME(ChebCoef)(REALNAME(ChebCB_Sin), num, poly, cb);
	else if (fnc == CHEBCB_ASIN)
		REALNAME(ChebCoef)(REALNAME(ChebCB_ASin), num, poly, cb);
	else if (fnc == CHEBCB_ATAN)
		REALNAME(ChebCoef)(REALNAME(ChebCB_ATan), num, poly, cb);
	else if (fnc == CHEBCB_SQRT)
		REALNAME(ChebCoef)(REALNAME(ChebCB_Sqrt), num, poly, cb);

	for (i = 0; i < num; i++) poly_exp[i] = REALNAME(Unpack)(&poly[i], &poly[i]);

#endif // HASREF
}

// ---------------------------------------------------------------------------
//             Calculate value of Chebyshev approximation
// ---------------------------------------------------------------------------
//  n = number of coefficients (=order of Chebyshev polynomial)
//  poly = pointer to array of polynomial coefficients
// Input number must be in range -1 .. +1
// Do not use Chebyshev approximation with results near 0, it could be inaccurate.

void REALNAME(Chebyshev)(REAL* num, int n, const REAL* poly)
{
	REAL res;
	int i;

#if DEB_LOOPNUM
	Deb_LoopNum += n;	// number of iteration loops
#endif

	REALNAME(Set0)(&res);
	for (i = n-1; i > 0; i--)
	{
		REALNAME(Add)(&res, &res, &poly[i]);
		REALNAME(Mul)(&res, &res, num);
	}
	REALNAME(Add)(num, &res, &poly[0]);
}

EXP REALNAME(ChebyshevExt)(REAL* num, EXP exp, int n, const REALEXT* poly)
{
	REAL res;
	int i;
	EXP exp_res;

#if DEB_LOOPNUM
	Deb_LoopNum += n;	// number of iteration loops
#endif

	REALNAME(Set0Ext)(&res);
	exp_res = EXPEXT_0;
	for (i = n-1; i > 0; i--)
	{
		exp_res = REALNAME(AddExt)(&res, &res, exp_res, (const REAL*)&poly[i], poly[i].exp);
		exp_res = REALNAME(MulExt)(&res, &res, exp_res, num, exp);
	}
	return REALNAME(AddExt)(num, &res, exp_res, (const REAL*)&poly[0], poly[0].exp);
}

EXP REALNAME(ChebyshevExt2)(REAL* num, EXP exp, int n, const REAL* poly, const EXP* poly_exp)
{
	REAL res;
	int i;
	EXP exp_res;

#if DEB_LOOPNUM
	Deb_LoopNum += n;	// number of iteration loops
#endif

	REALNAME(Set0Ext)(&res);
	exp_res = EXPEXT_0;
	for (i = n-1; i > 0; i--)
	{
		exp_res = REALNAME(AddExt)(&res, &res, exp_res, &poly[i], poly_exp[i]);
		exp_res = REALNAME(MulExt)(&res, &res, exp_res, num, exp);
	}
	return REALNAME(AddExt)(num, &res, exp_res, &poly[0], poly_exp[0]);
}

// ---------------------------------------------------------------------------
// get Bernoulli table number in decimal form (index = 0..BernMax() )
// ---------------------------------------------------------------------------

void REALNAME(BernDec)(REAL* num, int inx)
{
	REAL tmp;

	// invalid index or 0 -> 1
	if ((inx <= 0) || (inx > REALNAME(BernMax)()))
	{
		REALNAME(Set1)(num);
		return;
	}
	
	// 1 -> -0.5
	if (inx == 1)
	{
		REALNAME(SetM05)(num);
		return;
	}

	// odd index -> 0
	if ((inx & 1) == 1)
	{
		REALNAME(Set0)(num);
		return;
	}

	// get table
	inx = inx/2-1;
	REALNAME(ImportBigIntC)(num, &bern_num[inx]);
	REALNAME(ImportBigIntC)(&tmp, &bern_den[inx]);
	REALNAME(Div)(num, num, &tmp);
}

// ---------------------------------------------------------------------------
// get Bernoulli table number - numerator (index = 0..BernMax() )
// ---------------------------------------------------------------------------

void REALNAME(BernNum)(REAL* num, int inx)
{
	// invalid index or 0 -> 1
	if ((inx <= 0) || (inx > REALNAME(BernMax)()))
	{
		REALNAME(Set1)(num);
		return;
	}

	// 1 -> -1
	if (inx == 1)
	{
		REALNAME(SetM1)(num);
		return;
	}

	// odd index -> 0
	if ((inx & 1) == 1)
	{
		REALNAME(Set0)(num);
		return;
	}

	// get table
	inx = inx/2-1;
	REALNAME(ImportBigIntC)(num, &bern_num[inx]);
}

// ---------------------------------------------------------------------------
// get Bernoulli table number - denominator (index = 0..BernMax() )
// ---------------------------------------------------------------------------

void REALNAME(BernDen)(REAL* num, int inx)
{
	// 1 -> 2
	if (inx == 1)
	{
		REALNAME(Set2)(num);
		return;
	}

	// invalid index, 0 or odd index -> 1
	if ((inx <= 0) || (inx > REALNAME(BernMax)()) || ((inx & 1) == 1))
	{
		REALNAME(Set1)(num);
		return;
	}

	// get table
	inx = inx/2-1;
	REALNAME(ImportBigIntC)(num, &bern_den[inx]);
}

// ---------------------------------------------------------------------------
//               integer factorial (number is multiplied repeatedly)
// ---------------------------------------------------------------------------
//  Returns max. reached number (can be used to detect maximum allowed value)
//  Function uses 3 temporary numbers in the stack.

BASE REALNAME(FactInt)(REAL* num, BASE n)
{
	REAL m;
	BASE i;
	REALNAME(Set1)(num);
	for (i = 2; i <= n; i++)
	{
		REALNAME(SetUInt)(&m, i);
		REALNAME(Mul)(num, num, &m);
		if (REALNAME(IsInf)(num)) break;
	}
	return i - 1;
}

EXP REALNAME(FactIntExt)(REAL* num, BASE n)
{
	REAL m;
	BASE i;
	EXP exp, m_exp;
	REALNAME(Set1Ext)(num);
	exp = EXPEXT_1;
	for (i = 2; i <= n; i++)
	{
		m_exp = REALNAME(SetUIntExt)(&m, i);
		exp = REALNAME(MulExt)(num, num, exp, &m, m_exp);
		if (exp >= EXPEXT_MAX) break;
	}
	return exp;
}

// ---------------------------------------------------------------------------
//               non-integer factorial linear approximation
// ---------------------------------------------------------------------------
// Stieltjes, Gamma function, continued fraction
// p = a0/(x + a1/(x + a2/(x + ... an/x
//		a0 = 1 / 12
//		a1 = 1 / 30
//		a2 = 53 / 210
//		a3 = 195 / 371
//		a4 = 22999 / 22737
//		a5 = 29944523 / 19733142
//		a6 = 109535241009 / 48264275462
//		a7 = 29404527905795295658 / 9769214287853155785
//		a8 = 455377030420113432210116914702 / 113084128923675014537885725485
//		a9 = 26370812569397719001931992945645578779849 / 5271244267917980801966553649147604697542
//		a10 = 152537496709054809881638897472985990866753853122697839 / 24274291553105128438297398108902195365373879212227726
//		a11 = 100043420063777451042472529806266909090824649341814868347109676190691 / 13346384670164266280033479022693768890138348905413621178450736182873
// q = p + ln(2*pi)/2 - x + (x + 1/2)*ln(x)
// y = exp(p)

// use work-around correction (0 = no correction)
// - calculate with higher factorial value and divide than back 
#define FACTCORR (REAL_BYTES+REAL_BYTES/2) // (REAL_BYTES*12/8) or more is OK

/*
with work-around correction, maximum and average number of error lower bits, in extended precision:

real16: real16: max=13 ave=9 FACT_COEFF=2 FACTCORR=3
real32: real32: max=13 ave=9 FACT_COEFF=4 FACTCORR=6
real48: real48: max=13 ave=9 FACT_COEFF=6 FACTCORR=9
real64: real64: max=13 ave=9 FACT_COEFF=8 FACTCORR=12
real80: real80: max=13 ave=9 FACT_COEFF=10 FACTCORR=15
real96: real96: max=13 ave=9 FACT_COEFF=12 FACTCORR=18
real128: real128: max=13 ave=9 FACT_COEFF=16 FACTCORR=24
real160: real160: max=13 ave=9 FACT_COEFF=20 FACTCORR=30
real192: real192: max=13 ave=9 FACT_COEFF=24 FACTCORR=36
real256: real256: max=13 ave=9 FACT_COEFF=32 FACTCORR=48
real384: real384: max=13 ave=9 FACT_COEFF=48 FACTCORR=72
real512: real512: max=13 ave=9 FACT_COEFF=64 FACTCORR=96
real768: real768: max=13 ave=10 FACT_COEFF=96 FACTCORR=144
real1024: real1024: max=13 ave=9 FACT_COEFF=128 FACTCORR=192
real1536: real1536: max=13 ave=10 FACT_COEFF=192 FACTCORR=288
real2048: real2048: max=13 ave=12 FACT_COEFF=256 FACTCORR=384
real3072: real3072: max=12 ave=11 FACT_COEFF=384 FACTCORR=576
real4096: real4096: max=38 ave=38 FACT_COEFF=512 FACTCORR=768
*/

#ifdef FACT_COEFF

EXP REALNAME(FactLinFromExt)(REAL* num, const REAL* src, EXP exp)
{
	int i, n, dif;
	REAL p, c, q;
	EXP p_exp, c_exp, q_exp;
	Bool corr;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// number is <= 0, result is 0
	if ((sign != 0) || (exp == EXPEXT_0))
	{
		REALNAME(Set1Ext)(num);
		return EXPEXT_1;
	}

	// work-around correction to raise precision of low numbers - shift calculations to higher values

	// check correction for small numbers
	q_exp = REALNAME(SetUIntExt)(&q, FACTCORR);
	corr = (REALNAME(CompExt)(src, exp, &q, q_exp) < 0);
	if (corr)
	{
		// increase number by difference from correction
		n = (int)REALNAME(GetUIntExt)(src, exp); // current number truncated toward 0
		dif = (int)(FACTCORR - n); // difference
		q_exp = REALNAME(SetUIntExt)(&q, dif);
		exp = REALNAME(AddExt)(num, src, exp, &q, q_exp);	// add difference FACTCORR - num

		// calculate result correction
		REALNAME(Set1Ext)(&q);
		q_exp = EXPEXT_1;
		for (i = FACTCORR; i > n; i--)
			q_exp = REALNAME(DivU16Ext)(&q, &q, q_exp, (u16)i);
	}
	else
		REALNAME(Copy)(num, src);

	// calculate factorial
	REALNAME(Copy)(&p, num);
	p_exp = exp;

	for (i = FACT_COEFF-1; i > 0; i--)
	{
		p_exp = REALNAME(DivExt)(&p, (const REAL*)&REALNAME(ConstFact)[i], REALNAME(ConstFact)[i].exp, &p, p_exp); // ai/xi
		p_exp = REALNAME(AddExt)(&p, &p, p_exp, num, exp); // x + ai/xi
	}

	p_exp = REALNAME(DivExt)(&p, (const REAL*)&REALNAME(ConstFact)[0], REALNAME(ConstFact)[0].exp, &p, p_exp); // a0/x0

	p_exp = REALNAME(AddExt)(&p, &p, p_exp, (const REAL*)&REALNAME(ConstLnPi22Ext), EXPEXT_1 - 1); // p + ln(2*pi)/2
	p_exp = REALNAME(SubExt)(&p, &p, p_exp, num, exp); // p + ln(2*pi)/2 - x

	c_exp = REALNAME(LnFromExt)(&c, num, exp); // ln(x)
	exp = REALNAME(AddExt)(num, num, exp, (const REAL*)&REALNAME(Const05Ext), EXPEXT_1 - 1); // x + 0.5
	exp = REALNAME(MulExt)(num, num, exp, &c, c_exp); // ln(x)*(x + 0.5)

	exp = REALNAME(AddExt)(num, num, exp, &p, p_exp);
	exp = REALNAME(ExpExt)(num, exp);

	// work-around correction
	if (corr) exp = REALNAME(MulExt)(num, num, exp, &q, q_exp);

	return exp;
}

void REALNAME(FactLinFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(FactLinFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

#else // FACT_COEFF

EXP REALNAME(FactLinFromExt)(REAL* num, const REAL* src, EXP exp)
{
	BASE n = REALNAME(GetUIntExt)(src, exp);
	return REALNAME(FactIntExt)(num, n);
}

void REALNAME(FactLinFrom)(REAL* num, const REAL* src)
{
	BASE n = REALNAME(GetUInt)(src);
	if (n > FACT_MAX)
	{
		REALNAME(SetInf)(num);
		return;
	}
	REALNAME(FactInt)(num, n);
}

#endif // FACT_COEFF

// ---------------------------------------------------------------------------
//                 factorial (auto select best method)
// ---------------------------------------------------------------------------

EXP REALNAME(FactFromExt)(REAL* num, const REAL* src, EXP exp)
{
	Bool isint;
	BASE n;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// number is <= 0
	if ((sign != 0) || (exp == EXPEXT_0))
	{
		REALNAME(Set1Ext)(num);
		return EXPEXT_1;
	}

	// check if number is integer
	isint = REALNAME(IsIntExt)(src, exp);
	if (isint)
	{
		// get number
		n = REALNAME(GetUIntExt)(src, exp);

		// use integer factorial
		if (n < REALNAME(FactThres)())
		{
			exp = REALNAME(FactIntExt)(num, n);

			// integer correction
			return REALNAME(RoundExt)(num, exp);
		}
	}

	// use linear factorial
	exp = REALNAME(FactLinFromExt)(num, src, exp);

	// integer correction
	if (isint) exp = REALNAME(RoundExt)(num, exp);

	return exp;
}

void REALNAME(FactFrom)(REAL* num, const REAL* src)
{
	Bool isint;
	BASE n;

	// number is <= 0
	if (REALNAME(IsNeg)(src) || REALNAME(IsZero)(src))
	{
		REALNAME(Set1)(num);
		return;
	}

	// check if number is integer
	isint = REALNAME(IsInt)(src);
	if (isint)
	{
		// get number
		n = REALNAME(GetUInt)(src);

		// overflow
		if (n > FACT_MAX)
		{
			REALNAME(SetInf)(num);
			return;
		}

		// use integer factorial
		if (n < REALNAME(FactThres)())
		{
			REALNAME(FactInt)(num, n);

			// integer correction
			REALNAME(Round)(num);
			return;
		}
	}

	// use linear factorial
	REALNAME(FactLinFrom)(num, src);

	// integer correction
	if (isint) REALNAME(Round)(num);
}

// ---------------------------------------------------------------------------
//           natural logarithm of factorial (using approximation)
// ---------------------------------------------------------------------------

#ifdef FACT_COEFF

EXP REALNAME(FactLnFromExt)(REAL* num, const REAL* src, EXP exp)
{
	int i, n, dif;
	REAL p, c, q;
	EXP p_exp, c_exp, q_exp;
	Bool corr;
	u8 sign;

	// unpack exponent
	sign = (u8)(exp >> EXPEXT_BITS);
	exp &= EXPEXT_MASK;

	// number is <= 0, result is 0
	if ((sign != 0) || (exp == EXPEXT_0))
	{
		REALNAME(Set0Ext)(num);
		return EXPEXT_0;
	}

	// work-around correction to raise precision of low numbers - shift calculations to higher values

	// check correction for small numbers
	q_exp = REALNAME(SetUIntExt)(&q, FACTCORR);
	corr = (REALNAME(CompExt)(src, exp, &q, q_exp) < 0);
	if (corr)
	{
		// increase number by difference from correction
		n = (int)REALNAME(GetUIntExt)(src, exp); // current number truncated toward 0
		dif = (int)(FACTCORR - n); // difference
		q_exp = REALNAME(SetUIntExt)(&q, dif);
		exp = REALNAME(AddExt)(num, src, exp, &q, q_exp);	// add difference FACTCORR - num

		// calculate result correction
		REALNAME(Set1Ext)(&q);
		q_exp = EXPEXT_1;
		for (i = FACTCORR; i > n; i--)
			q_exp = REALNAME(DivU16Ext)(&q, &q, q_exp, (u16)i);
		q_exp = REALNAME(LnExt)(&q, q_exp);
	}
	else
		REALNAME(Copy)(num, src);

	// calculate factorial
	REALNAME(Copy)(&p, num);
	p_exp = exp;

	for (i = FACT_COEFF-1; i > 0; i--)
	{
		p_exp = REALNAME(DivExt)(&p, (const REAL*)&REALNAME(ConstFact)[i], REALNAME(ConstFact)[i].exp, &p, p_exp); // ai/xi
		p_exp = REALNAME(AddExt)(&p, &p, p_exp, num, exp); // x + ai/xi
	}

	p_exp = REALNAME(DivExt)(&p, (const REAL*)&REALNAME(ConstFact)[0], REALNAME(ConstFact)[0].exp, &p, p_exp); // a0/x0

	p_exp = REALNAME(AddExt)(&p, &p, p_exp, (const REAL*)&REALNAME(ConstLnPi22Ext), EXPEXT_1 - 1); // p + ln(2*pi)/2
	p_exp = REALNAME(SubExt)(&p, &p, p_exp, num, exp); // p + ln(2*pi)/2 - x

	c_exp = REALNAME(LnFromExt)(&c, num, exp); // ln(x)
	exp = REALNAME(AddExt)(num, num, exp, (const REAL*)&REALNAME(Const05Ext), EXPEXT_1 - 1); // x + 0.5
	exp = REALNAME(MulExt)(num, num, exp, &c, c_exp); // ln(x)*(x + 0.5)

	exp = REALNAME(AddExt)(num, num, exp, &p, p_exp);

	// work-around correction
	if (corr) exp = REALNAME(AddExt)(num, num, exp, &q, q_exp);

	return exp;
}

void REALNAME(FactLnFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(FactLnFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

#else // FACT_COEFF

EXP REALNAME(FactLnFromExt)(REAL* num, const REAL* src, EXP exp)
{
	BASE n = REALNAME(GetUIntExt)(src, exp);
	exp = REALNAME(FactIntExt)(num, n);
	return REALNAME(LnExt)(num, exp);
}

void REALNAME(FactLnFrom)(REAL* num, const REAL* src)
{
	BASE n = REALNAME(GetUInt)(src);
	if (n > FACT_MAX)
	{
		REALNAME(SetInf)(num);
		return;
	}
	REALNAME(FactInt)(num, n);
	REALNAME(Ln)(num);
}

#endif // FACT_COEFF

#undef FACTCORR

// ---------------------------------------------------------------------------
//           decimal logarithm of factorial (using approximation)
// ---------------------------------------------------------------------------

EXP REALNAME(FactLogFromExt)(REAL* num, const REAL* src, EXP exp)
{
	exp = REALNAME(FactLnFromExt)(num, src, exp);
	return REALNAME(MulExt)(num, num, exp, (const REAL*)&REALNAME(ConstRLn10Ext), EXPEXT_1 - 2);
}

void REALNAME(FactLogFrom)(REAL* num, const REAL* src)
{
	EXP exp = REALNAME(Unpack)(src, num);
	exp = REALNAME(FactLogFromExt)(num, num, exp);
	REALNAME(Pack)(num, num, exp);
}

// decode text
#include "real_totext.h"	// decode number to text
#include "real_fromtext.h"	// encode number from text

#include "real_undef.h"		// undefine

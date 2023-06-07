
// ****************************************************************************
//                                 
//                      Real numbers - common header
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// Format of real number, from higher bits to lower: 1 bit sign, exponent, mantissa
// Exponent + sign must fit into one segment. Exponent can be max. 30 bits.

// Note: It is advised not to use Chebyshev approximations or Cordic method for
// long numbers on Raspberry Pico - they require loading large tables from Flash
// and that is a very time consuming operation, so those functions can be slow.

#include "real_def.h"		// define

#ifdef __cplusplus
extern "C" {
#endif

// real number structure
typedef struct {
	BASE	n[BASE_NUM];	// real number segments
				// - first segment contains lowest bits of mantissa
				// - last segment contains highest bits of mantissa, exponent and sign
} REAL;

// extended real number structure - used as constant (mantissa contains implied bit '1' and is extended to full BASE_NUM segments)
typedef struct {
	BASE	n[BASE_NUM];	// real number segments - mantissa
				// - first segment contains lowest bits of mantissa
				// - last segment contains highest bits of mantissa with implied bit '1'
	EXP		exp;			// packed extended exponent and sign in last bit
} REALEXT;

// === Constants

// Normal precision
extern const REAL REALNAME(Const0);			// 0
extern const REAL REALNAME(Const1);			// 1
extern const REAL REALNAME(ConstM1);		// -1
extern const REAL REALNAME(Const2);			// 2
extern const REAL REALNAME(Const3);			// 3
extern const REAL REALNAME(Const05);		// 0.5
extern const REAL REALNAME(ConstM05);		// -0.5
extern const REAL REALNAME(Const075);		// 0.75
extern const REAL REALNAME(Const83);		// 8/3 (2.6666666667)
extern const REAL REALNAME(Const10);		// 10
extern const REAL REALNAME(Const100);		// 100
extern const REAL REALNAME(ConstExpMax);	// exp(x) max
extern const REAL REALNAME(ConstExpMin);	// exp(x) min
extern const REAL REALNAME(Const01);		// 0.1 (1e-1)
extern const REAL REALNAME(Const001);		// 0.01 (1e-2)
extern const REAL REALNAME(Const1eM4);		// 0.0001 (1e-4)
extern const REAL REALNAME(Const1eM8);		// 0.00000001 (1e-8)
extern const REAL REALNAME(ConstLn2);		// ln(2) (0.693147180559945)
extern const REAL REALNAME(ConstRLn2);		// 1/ln(2) (1.44269504088896)
extern const REAL REALNAME(ConstLn10);		// ln(10) (2.30258509299405)
extern const REAL REALNAME(ConstRLn10);		// 1/ln(10) (0.434294481903252)
extern const REAL REALNAME(ConstLog2);		// log(2) (0.301029995663981)
extern const REAL REALNAME(ConstRLog2);		// 1/log(2) (3.32192809488736)
extern const REAL REALNAME(ConstEul);		// Eul (2.71828182845905)
extern const REAL REALNAME(ConstPi05);		// pi/2 (1.5707963267949)
extern const REAL REALNAME(ConstMPi05);		// -pi/2 (-1.5707963267949)
extern const REAL REALNAME(ConstPi);		// pi (3.14159265358979)
extern const REAL REALNAME(ConstMPi);		// -pi (-3.14159265358979)
extern const REAL REALNAME(ConstPi2);		// pi*2 (6.28318530717959)
extern const REAL REALNAME(ConstMPi2);		// -pi*2 (-6.28318530717959)
extern const REAL REALNAME(ConstRPi2);		// 1/(pi*2) (0.159154943091895)
extern const REAL REALNAME(ConstLnPi22);	// ln(pi*2)/2 (0.918938533204673)
extern const REAL REALNAME(Const180Pi);		// 180/pi (57.2957795130823)
extern const REAL REALNAME(ConstPi180);		// pi/180 (0.0174532925199433)
extern const REAL REALNAME(Const200Pi);		// 200/pi (63.6619772367581)
extern const REAL REALNAME(ConstPi200);		// pi/200 (0.015707963267949)
extern const REAL REALNAME(ConstPhi);		// phi (sectio aurea = (1 + sqrt(5))/2) (1.61803398874989)
extern const REAL REALNAME(ConstSqrt2);		// sqrt(2)
extern const REAL REALNAME(ConstRSqrt2);	// 1/sqrt(2)

// Extended precision
extern const REALEXT REALNAME(Const0Ext);		// 0
extern const REALEXT REALNAME(Const1Ext);		// 1
extern const REALEXT REALNAME(ConstM1Ext);		// -1
extern const REALEXT REALNAME(Const2Ext);		// 2
extern const REALEXT REALNAME(Const3Ext);		// 3
extern const REALEXT REALNAME(Const05Ext);		// 0.5
extern const REALEXT REALNAME(ConstM05Ext);		// -0.5
extern const REALEXT REALNAME(Const075Ext);		// 0.75
extern const REALEXT REALNAME(Const83Ext);		// 8/3 (2.6666666667)
extern const REALEXT REALNAME(Const10Ext);		// 10
extern const REALEXT REALNAME(Const100Ext);		// 100
extern const REALEXT REALNAME(ConstExpMaxExt);	// exp(x) max
extern const REALEXT REALNAME(ConstExpMinExt);	// exp(x) min
extern const REALEXT REALNAME(Const01Ext);		// 0.1 (1e-1)
extern const REALEXT REALNAME(Const001Ext);		// 0.01 (1e-2)
extern const REALEXT REALNAME(Const1eM4Ext);	// 0.0001 (1e-4)
extern const REALEXT REALNAME(Const1eM8Ext);	// 0.00000001 (1e-8)
extern const REALEXT REALNAME(ConstLn2Ext);		// ln(2) (0.693147180559945)
extern const REALEXT REALNAME(ConstRLn2Ext);	// 1/ln(2) (1.44269504088896)
extern const REALEXT REALNAME(ConstLn10Ext);	// ln(10) (2.30258509299405)
extern const REALEXT REALNAME(ConstRLn10Ext);	// 1/ln(10) (0.434294481903252)
extern const REALEXT REALNAME(ConstLog2Ext);	// log(2) (0.301029995663981)
extern const REALEXT REALNAME(ConstRLog2Ext);	// 1/log(2) (3.32192809488736)
extern const REALEXT REALNAME(ConstEulExt);		// Eul (2.71828182845905)
extern const REALEXT REALNAME(ConstPi05Ext);	// pi/2 (1.5707963267949)
extern const REALEXT REALNAME(ConstMPi05Ext);	// -pi/2 (-1.5707963267949)
extern const REALEXT REALNAME(ConstPiExt);		// pi (3.14159265358979)
extern const REALEXT REALNAME(ConstMPiExt);		// -pi (-3.14159265358979)
extern const REALEXT REALNAME(ConstPi2Ext);		// pi*2 (6.28318530717959)
extern const REALEXT REALNAME(ConstMPi2Ext);	// -pi*2 (-6.28318530717959)
extern const REALEXT REALNAME(ConstRPi2Ext);	// 1/(pi*2) (0.159154943091895)
extern const REALEXT REALNAME(ConstLnPi22Ext);	// ln(pi*2)/2 (0.918938533204673)
extern const REALEXT REALNAME(Const180PiExt);	// 180/pi (57.2957795130823)
extern const REALEXT REALNAME(ConstPi180Ext);	// pi/180 (0.0174532925199433)
extern const REALEXT REALNAME(Const200PiExt);	// 200/pi (63.6619772367581)
extern const REALEXT REALNAME(ConstPi200Ext);	// pi/200 (0.015707963267949)
extern const REALEXT REALNAME(ConstPhiExt);		// phi (sectio aurea = (1 + sqrt(5))/2) (1.61803398874989)
extern const REALEXT REALNAME(ConstSqrt2Ext);	// sqrt(2)
extern const REALEXT REALNAME(ConstRSqrt2Ext);	// 1/sqrt(2)

// Decimal exponents (index REAL_DECEXP = number '1') - used by ToText() and FromText()
extern const REAL REALNAME(ConstExp)[REAL_DECEXP*2+1];

// Factorial coefficients - used to calculate linear factorial by FactLin()
#ifdef FACT_COEFF
extern const REALEXT REALNAME(ConstFact)[FACT_COEFF]; // FACT_COEFF = REAL_BYTES
#endif

// Chebyshev coefficients
#ifdef CHEB_LN
extern const REALEXT REALNAME(ConstChebLn)[CHEB_LN]; // Chebyshev coefficients of Ln()
#endif

#ifdef CHEB_EXP
extern const REALEXT REALNAME(ConstChebExp)[CHEB_EXP]; // Chebyshev coefficients of Exp()
#endif

#ifdef CHEB_SIN
extern const REALEXT REALNAME(ConstChebSin)[CHEB_SIN]; // Chebyshev coefficients of Sin()
#endif

#ifdef CHEB_ASIN
extern const REALEXT REALNAME(ConstChebASin)[CHEB_ASIN]; // Chebyshev coefficients of ASin()
#endif

#ifdef CHEB_ATAN
extern const REALEXT REALNAME(ConstChebATan)[CHEB_ATAN]; // Chebyshev coefficients of ATan()
#endif

#ifdef CHEB_SQRT
extern const REALEXT REALNAME(ConstChebSqrt)[CHEB_SQRT]; // Chebyshev coefficients of Sqrt()
#endif

#ifdef CORD_ATAN
extern const REAL REALNAME(ConstAtanInit);	// init value of atan table (=1/expansion factor)
extern const REAL REALNAME(ConstAtan)[CORD_ATAN]; // Cordic atan table (denormalised mantises)
										// Note: Second half of table is equal to angle.
#endif

// === Get setup

// get number size
INLINE int REALNAME(RealBytes)() { return REAL_BYTES; }
INLINE int REALNAME(RealBits)() { return REAL_BITS; }

// get mantissa precision (max. number of digits)
INLINE int REALNAME(MantBits)() { return MANT_BITS; }
INLINE double REALNAME(MantDigDecD)() { return MANT_DIG_DEC_D; }
INLINE int REALNAME(MantDigDec)() { return MANT_DIG_DEC; }
INLINE int REALNAME(MantDigBin)() { return MANT_DIG_BIN; }
INLINE int REALNAME(MantDigOct)() { return MANT_DIG_OCT; }
INLINE int REALNAME(MantDigHex)() { return MANT_DIG_HEX; }

INLINE double REALNAME(MantDigDecDExt)() { return MANT_DIG_DECEXT_D; }
INLINE int REALNAME(MantDigDecExt)() { return MANT_DIG_DECEXT; }

// get exponent size
INLINE int REALNAME(ExpBits)() { return EXP_BITS; }

// get exponent bias
INLINE BASE REALNAME(ExpBias)() { return EXP_BIAS; }

// get exponent number of digits (in decimal format)
INLINE int REALNAME(ExpDig)() { return EXP_DIG; }

// get exponent range (max. decimal value)
INLINE double REALNAME(ExpRangeD)() { return EXP_RANGE_D; }
INLINE BASE REALNAME(ExpRange)() { return EXP_RANGE; }

// required max. size of edit buffer (-1.23456e-234)
// sign, decimal point, mant digits, exp separator, exp sign, exp digits, ASCIIZ zero
INLINE int REALNAME(BufSizeDec)() { return MANT_DIG_DEC + EXP_DIG + 5; }
INLINE int REALNAME(BufSizeBin)() { return MANT_DIG_BIN + EXP_DIG + 7; }
INLINE int REALNAME(BufSizeOct)() { return MANT_DIG_OCT + EXP_DIG + 6; }
INLINE int REALNAME(BufSizeHex)() { return MANT_DIG_HEX + EXP_DIG + 5; }

// get max. factorial
INLINE BASE REALNAME(FactMax)() { return FACT_MAX; }

// threshold to use linear factorial instead of integer factorial
INLINE BASE REALNAME(FactThres)() { return FACT_THRES; }

// get max. Bernoulli table index (=512)
INLINE int REALNAME(BernMax)() { return BIGINT_BERN_NUM*2; }

// check if reference number is supported
INLINE Bool REALNAME(HasRef)()
{
#ifdef REALREF // reference number supported
	return True;
#else
	return False;
#endif
}

// get number of Chebyshev coefficients (fnc = function CHEBCB_*, 0 = not supported)
int REALNAME(ChebFncNum)(int fnc);

// get pointer to Chebyshev coefficients (NULL = not supported)
const REALEXT* REALNAME(ChebCoefTab)(int fnc);

// get number of atan coefficients for Cordic (0 = not supported)
#ifdef CORD_ATAN
INLINE int REALNAME(CordAtanNum)() { return CORD_ATAN; }
#else
INLINE int REALNAME(CordAtanNum)() { return 0; }
#endif

// === Low-level operations
// most mantis functions work for both normal and extended mantises

	// long multiply rH:rL <- a*b
#if !ASM64

#if BASE_BITS == 8 // u8
INLINE void REALNAME(MulHL)(BASE* rH, BASE* rL, BASE a, BASE b)
{
	u16 k = (u16)a*b;
	*rL = (u8)k;
	*rH = (u8)(k >> 8);
}
#elif BASE_BITS == 16 // u16
INLINE void REALNAME(MulHL)(BASE* rH, BASE* rL, BASE a, BASE b)
{
	u32 k = (u32)a*b;
	*rL = (u16)k;
	*rH = (u16)(k >> 16);
}
#elif BASE_BITS == 32 // u32
INLINE void REALNAME(MulHL)(BASE* rH, BASE* rL, BASE a, BASE b)
{
	u64 k = (u64)a*b;
	*rL = (u32)k;
	*rH = (u32)(k >> 32);
}
#else // u64
void REALNAME(MulHL)(BASE* rH, BASE* rL, BASE a, BASE b);
#endif

#else // ASM64
INLINE void REALNAME(MulHL)(BASE* rH, BASE* rL, BASE a, BASE b)
{
#if BASE_BITS == 8 // u8
	MulHL8(rH, rL, a, b);
#elif BASE_BITS == 16 // u16
	MulHL16(rH, rL, a, b);
#elif BASE_BITS == 32 // u32
	MulHL32(rH, rL, a, b);
#else // u64
	MulHL64(rH, rL, a, b);
#endif
}
#endif

// unpack number from normal format to extended format, returns packed extended exponent with sign in highest bit
// - source and destination can be the same
EXP REALNAME(Unpack)(const REAL* num, REAL* dst);
void REALNAME(UnpackExt)(const REAL* num, REALEXT* dst);

// pack number from extended format to normal format (round and check range)
// - source and destination can be the same
// - exponent can be in packed form, with sign in highest bit
void REALNAME(Pack)(REAL* num, const REAL* src, EXP exp);
void REALNAME(PackExt)(REAL* num, const REALEXT* src);

// clear exponent and sign (isolate mantissa)
void REALNAME(ClrExp)(REAL* num);

// denormalize mantissa - clear exponent and sign, restore hidden bit '1'
void REALNAME(Denorm)(REAL* num);

// shift mantissa left to higher bits (returns carry bit 0 or 1)
BASE REALNAME(MantL1)(REAL* num, BASE carry);

// shift mantissa right to lower bits (returns carry bit 0 or 1)
BASE REALNAME(MantR1)(REAL* num, BASE carry);

// shift mantissa left to higher bits by more shifts (returns carry bit 0 or 1)
u8 REALNAME(MantL)(REAL* num, int shift);

// shift mantissa right to lower bits (returns lowest carry bit 0 or 1)
// - Input carry will be extended to 0 or -1 signed bits.
u8 REALNAME(MantR)(REAL* num, Bool carry, int shift);

// count leading zero bits of the mantissa (0..REAL_BITS)
int REALNAME(MantClz)(const REAL* num);

// normalize mantissa (shift left up to bit "1" on exponent position, returns
// number of shifts -EXP_BITS..0..MANT_BITS, or MANT_BITS+1 = mantissa is zero)
int REALNAME(MantNorm)(REAL* num);

// normalize extended mantissa (shift left up to bit "1" on highest position,
// returns number of shifts 0..REAL_BITS-1, or REAL_BITS = mantissa is zero)
int REALNAME(MantNormExt)(REAL* num);

// compare mantissas (returns -1 if num1<num2, 0 if num1==num2, +1 if num1>num2)
s8 REALNAME(MantComp)(const REAL* num1, const REAL* num2);

// add another mantissa to this mantissa (returns carry 0 or 1)
BASE REALNAME(MantAdd)(REAL* num, const REAL* src, BASE carry);
// num = src1 + src2
BASE REALNAME(MantAddFrom)(REAL* num, const REAL* src1, const REAL* src2, BASE carry);

// subtract another mantissa from this mantissa (returns carry 0 or 1)
BASE REALNAME(MantSub)(REAL* num, const REAL* src, BASE carry);
// num = src1 - src2
BASE REALNAME(MantSubFrom)(REAL* num, const REAL* src1, const REAL* src2, BASE carry);

// inverted subtract this mantissa from another mantissa (returns carry 0 or 1)
BASE REALNAME(MantInvSub)(REAL* num, const REAL* src, BASE carry);

// OR another mantissa to this mantissa
void REALNAME(MantOr)(REAL* num, const REAL* src);

// AND another mantissa to this mantissa
void REALNAME(MantAnd)(REAL* num, const REAL* src);

// XOR another mantissa to this mantissa
void REALNAME(MantXor)(REAL* num, const REAL* src);

// increment mantissa (returns carry=1 if result is = 0)
u8 REALNAME(MantInc)(REAL* num);

// decrement mantissa (returns carry=1 if result is = -1)
u8 REALNAME(MantDec)(REAL* num);

// invert mantissa
void REALNAME(MantNot)(REAL* num);

// negate mantissa (returns carry=1 if result is = 0)
u8 REALNAME(MantNeg)(REAL* num);

// add member to accumulator and check epsilon of loop (True=continue loop, num=accumulator)
// - Function uses 2 temporary numbers in the stack.
Bool REALNAME(AddLoop)(REAL* num, const REAL* member);
// - Function uses 1 temporary number in the stack.
Bool REALNAME(AddLoopExt)(REAL* num, EXP* num_exp, const REAL* member, EXP mem_exp);

// copy number from another number
void REALNAME(Copy)(REAL* num, const REAL* src);

// exchange numbers
void REALNAME(Exch)(REAL* num, REAL* num2);

// === Flags and state manipulation
// - meaningful only in normal format, not extended

// get exponent unsigned (with bias)
BASE REALNAME(GetExp)(const REAL* num);

// get exponent signed (without bias)
BASES REALNAME(GetExpS)(const REAL* num);

// get sign (0 or 1)
u8 REALNAME(GetSign)(const REAL* num);

// check if number is zero (can be positive or negative zero)
Bool REALNAME(IsZero)(const REAL* num);

// check if number is infinity (can be positive or negative infinity)
Bool REALNAME(IsInf)(const REAL* num);

// check if number is negative (can be zero or infinity, too)
Bool REALNAME(IsNeg)(const REAL* num);

// set exponent unsigned (with bias)
void REALNAME(SetExp)(REAL* num, BASE exp);

// set exponent signed (without bias)
void REALNAME(SetExpS)(REAL* num, BASES exp);

// set sign (0 or <>0)
void REALNAME(SetSign)(REAL* num, u8 sign);

// copy sign from other number
void REALNAME(CopySign)(REAL* num, const REAL* src);

// === Set/get number

// set value 0 (extended format: set exponent to "EXPEXT_0")
void REALNAME(Set0)(REAL* num);
INLINE void REALNAME(Set0Ext)(REAL* num) { REALNAME(Set0)(num); }

// set value 1 (extended format: set exponent to "EXPEXT_1")
void REALNAME(Set1)(REAL* num);
void REALNAME(Set1Ext)(REAL* num);

// set value -1 (extended format: set exponent to "EXPEXT_1 | EXPEXT_SIGN")
void REALNAME(SetM1)(REAL* num);
INLINE void REALNAME(SetM1Ext)(REAL* num) { REALNAME(Set1Ext)(num); }

// set value 2 (extended format: set exponent to "EXPEXT_1+1")
void REALNAME(Set2)(REAL* num);
INLINE void REALNAME(Set2Ext)(REAL* num) { REALNAME(Set1Ext)(num); }

// set value 0.5 (extended format: set exponent to "EXPEXT_1-1")
void REALNAME(Set05)(REAL* num);
INLINE void REALNAME(Set05Ext)(REAL* num) { REALNAME(Set1Ext)(num); }

// set value -0.5 (extended format: set exponent to "(EXPEXT_1-1) | EXPEXT_SIGN")
void REALNAME(SetM05)(REAL* num);
INLINE void REALNAME(SetM05Ext)(REAL* num) { REALNAME(Set1Ext)(num); }

// set +infinity value (extended format: set exponent to "EXPEXT_INF")
void REALNAME(SetInf)(REAL* num);
INLINE void REALNAME(SetInfExt)(REAL* num) { REALNAME(Set1Ext)(num); }

// set maximal valid number (extended format: set exponent to "EXPEXT_MAX-1")
void REALNAME(SetMax)(REAL* num);
void REALNAME(SetMaxExt)(REAL* num);

// set minimal valid number (extended format: set exponent to "EXPEXT_0+1")
void REALNAME(SetMin)(REAL* num);
INLINE void REALNAME(SetMinExt)(REAL* num) { REALNAME(Set1Ext)(num); }

// set unsigned integer value
void REALNAME(SetUInt)(REAL* num, BASE n);
EXP REALNAME(SetUIntExt)(REAL* num, BASE n);

// set u8 integer value
void REALNAME(SetU8)(REAL* num, u8 n);
EXP REALNAME(SetU8Ext)(REAL* num, u8 n);

// set u16 integer value
void REALNAME(SetU16)(REAL* num, u16 n);
EXP REALNAME(SetU16Ext)(REAL* num, u16 n);

// set u32 integer value
void REALNAME(SetU32)(REAL* num, u32 n);
EXP REALNAME(SetU32Ext)(REAL* num, u32 n);

// set u64 integer value
void REALNAME(SetU64)(REAL* num, u64 n);
EXP REALNAME(SetU64Ext)(REAL* num, u64 n);

// set signed integer value
void REALNAME(SetSInt)(REAL* num, BASES n);
// - extended variant returns packed extended exponent with sign
EXP REALNAME(SetSIntExt)(REAL* num, BASES n);

// set s8 integer value
void REALNAME(SetS8)(REAL* num, s8 n);
// - extended variant returns packed extended exponent with sign
EXP REALNAME(SetS8Ext)(REAL* num, s8 n);

// set s16 integer value
void REALNAME(SetS16)(REAL* num, s16 n);
// - extended variant returns packed extended exponent with sign
EXP REALNAME(SetS16Ext)(REAL* num, s16 n);

// set s32 integer value
void REALNAME(SetS32)(REAL* num, s32 n);
// - extended variant returns packed extended exponent with sign
EXP REALNAME(SetS32Ext)(REAL* num, s32 n);

// set s64 integer value
void REALNAME(SetS64)(REAL* num, s64 n);
// - extended variant returns packed extended exponent with sign
EXP REALNAME(SetS64Ext)(REAL* num, s64 n);

// get unsigned integer (absolute) value (rounded towards zero)
BASE REALNAME(GetUInt_)(const REAL* num, Bool abs);
INLINE BASE REALNAME(GetUInt)(const REAL* num) { return REALNAME(GetUInt_)(num, False); }
INLINE BASE REALNAME(GetUIntAbs)(const REAL* num) { return REALNAME(GetUInt_)(num, True); }
// - exponent can be in packed form, with sign in highest bit
BASE REALNAME(GetUIntExt)(const REAL* num, EXP exp);
INLINE BASE REALNAME(GetUIntAbsExt)(const REAL* num, EXP exp)
	{ return REALNAME(GetUIntExt)(num, exp & EXPEXT_MASK); }

// get u8 integer (absolute) value (rounded towards zero)
u8 REALNAME(GetU8_)(const REAL* num, Bool abs);
INLINE u8 REALNAME(GetU8)(const REAL* num) { return REALNAME(GetU8_)(num, False); }
INLINE u8 REALNAME(GetU8Abs)(const REAL* num) { return REALNAME(GetU8_)(num, True); }
// - exponent can be in packed form, with sign in highest bit
u8 REALNAME(GetU8Ext)(const REAL* num, EXP exp);
INLINE u8 REALNAME(GetU8AbsExt)(const REAL* num, EXP exp)
	{ return REALNAME(GetU8Ext)(num, exp & EXPEXT_MASK); }

// get u16 integer (absolute) value (rounded towards zero)
u16 REALNAME(GetU16_)(const REAL* num, Bool abs);
INLINE u16 REALNAME(GetU16)(const REAL* num) { return REALNAME(GetU16_)(num, False); }
INLINE u16 REALNAME(GetU16Abs)(const REAL* num) { return REALNAME(GetU16_)(num, True); }
// - exponent can be in packed form, with sign in highest bit
u16 REALNAME(GetU16Ext)(const REAL* num, EXP exp);
INLINE u16 REALNAME(GetU16AbsExt)(const REAL* num, EXP exp)
	{ return REALNAME(GetU16Ext)(num, exp & EXPEXT_MASK); }

// get u32 integer (absolute) value (rounded towards zero)
u32 REALNAME(GetU32_)(const REAL* num, Bool abs);
INLINE u32 REALNAME(GetU32)(const REAL* num) { return REALNAME(GetU32_)(num, False); }
INLINE u32 REALNAME(GetU32Abs)(const REAL* num) { return REALNAME(GetU32_)(num, True); }
// - exponent can be in packed form, with sign in highest bit
u32 REALNAME(GetU32Ext)(const REAL* num, EXP exp);
INLINE u32 REALNAME(GetU32AbsExt)(const REAL* num, EXP exp)
	{ return REALNAME(GetU32Ext)(num, exp & EXPEXT_MASK); }

// get u64 integer (absolute) value (rounded towards zero)
u64 REALNAME(GetU64_)(const REAL* num, Bool abs);
INLINE u64 REALNAME(GetU64)(const REAL* num) { return REALNAME(GetU64_)(num, False); }
INLINE u64 REALNAME(GetU64Abs)(const REAL* num) { return REALNAME(GetU64_)(num, True); }
// - exponent can be in packed form, with sign in highest bit
u64 REALNAME(GetU64Ext)(const REAL* num, EXP exp);
INLINE u64 REALNAME(GetU64AbsExt)(const REAL* num, EXP exp)
	{ return REALNAME(GetU64Ext)(num, exp & EXPEXT_MASK); }

// get signed integer value (rounded towards zero)
BASES REALNAME(GetSInt)(const REAL* num);
// - exponent can be in packed form, with sign in highest bit
BASES REALNAME(GetSIntExt)(const REAL* num, EXP exp);

// get s8 integer value (rounded towards zero)
s8 REALNAME(GetS8)(const REAL* num);
// - exponent can be in packed form, with sign in highest bit
s8 REALNAME(GetS8Ext)(const REAL* num, EXP exp);

// get s16 integer value (rounded towards zero)
s16 REALNAME(GetS16)(const REAL* num);
// - exponent can be in packed form, with sign in highest bit
s16 REALNAME(GetS16Ext)(const REAL* num, EXP exp);

// get s32 integer value (rounded towards zero)
s32 REALNAME(GetS32)(const REAL* num);
// - exponent can be in packed form, with sign in highest bit
s32 REALNAME(GetS32Ext)(const REAL* num, EXP exp);

// get s64 integer value (rounded towards zero)
s64 REALNAME(GetS64)(const REAL* num);
// - exponent can be in packed form, with sign in highest bit
s64 REALNAME(GetS64Ext)(const REAL* num, EXP exp);

// import from REAL number of another type
//  num = pointer to this number
//  src = pointer to source REAL number
//	realbytes = size of REAL number in number of bytes
//  expbits = size of exponent in number of bits
void REALNAME(Import)(REAL* num, const void* src, int realbytes, int expbits);
//  Extended version returns exponent in packed form with sign in highest bit.
EXP REALNAME(ImportExt)(REAL* num, const void* src, int realbytes, int expbits);

// import from float
void REALNAME(FromFloat)(REAL* num, float n);

// import from double
void REALNAME(FromDouble)(REAL* num, double n);

// export to float
float REALNAME(ToFloat)(const REAL* num);
//  Extended version uses exponent in packed form with sign in highest bit.
float REALNAME(ToFloatExt)(const REAL* num, EXP exp);

// export to double
double REALNAME(ToDouble)(const REAL* num);
//  Extended version uses exponent in packed form with sign in highest bit.
double REALNAME(ToDoubleExt)(const REAL* num, EXP exp);

#ifdef REALREF // reference number supported
// import number from reference real number
void REALNAME(ImportRef)(REAL* dst, const void* src);

// import extended number from normal reference real number
// - returns packed extended exponent with sign
EXP REALNAME(ImportRefExt)(REAL* dst, const void* src);

// import extended number from extended reference real number
// - returns packed extended exponent with sign
EXP REALNAME(ImportRefExt2)(REAL* dst, const void* src, EXP exp);

// export number to reference real number
void REALNAME(ExportRef)(const REAL* src, void* dst);

// export extended number to normal reference real number
// - exponent can be in packed form, with sign in highest bit
void REALNAME(ExportRefExt)(const REAL* src, EXP exp, void* dst);

#endif

// export number to bigint
void REALNAME(ExportBigInt)(const REAL* num, bigint* dst);

// import number from bigint
void REALNAME(ImportBigInt)(REAL* num, const bigint* src);
EXP REALNAME(ImportBigIntExt)(REAL* num, const bigint* src);
void REALNAME(ImportBigIntC)(REAL* num, const cbigint* src);
EXP REALNAME(ImportBigIntCExt)(REAL* num, const cbigint* src);

// generate test random number (noneg = no negative number)
//  Extended version returns exponent in packed form with sign in highest bit.
void REALNAME(TestRandom)(REAL* num, Bool noneg, BASE expmin, BASE expmax);
EXP REALNAME(TestRandomExt)(REAL* num, Bool noneg, EXP expmin, EXP expmax);

// === Arithmetics operations
// Destination and source can be the same registers.

// add/sub 2 numbers
//  Function uses 2 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 3 us, real32 3 us (optim 700 ns), real48 5 us, real64 4 us (optim 980 ns)
//  real96 5 us, real128 6 us, real160 7 us, real192 8 us
//  real256 10 us, real384 12 us, real512 15 us, real768 21 us, real1024 27 us,
//  real1536 38 us, real2048 60 us, real3072 85 us
void REALNAME(AddSub)(REAL* num, const REAL* num1, const REAL* num2, Bool sub);
INLINE void REALNAME(Add)(REAL* num, const REAL* num1, const REAL* num2) { REALNAME(AddSub)(num, num1, num2, False); }
INLINE void REALNAME(Sub)(REAL* num, const REAL* num1, const REAL* num2) { REALNAME(AddSub)(num, num1, num2, True); }

// Extended add/sub
//  Function uses 1 temporary number in the stack.
//  Exponents are in packed form with sign in highest bit
EXP REALNAME(AddExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2);
INLINE EXP REALNAME(SubExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2)
	{ return REALNAME(AddExt)(num, num1, exp1, num2, exp2 ^ EXPEXT_SIGN); }

#define BITOPER_AND	0
#define BITOPER_OR	1
#define BITOPER_XOR	2

// bitwise operation (oper = BITOPER_AND, BITOPER_OR, BITOPER_XOR)
//  Function uses 2 temporary numbers in the stack.
void REALNAME(Bit)(REAL* num, const REAL* num1, const REAL* num2, u8 oper);
INLINE void REALNAME(BitAnd)(REAL* num, const REAL* num1, const REAL* num2) { REALNAME(Bit)(num, num1, num2, BITOPER_AND); }
INLINE void REALNAME(BitOr)(REAL* num, const REAL* num1, const REAL* num2) { REALNAME(Bit)(num, num1, num2, BITOPER_OR); }
INLINE void REALNAME(BitXor)(REAL* num, const REAL* num1, const REAL* num2) { REALNAME(Bit)(num, num1, num2, BITOPER_XOR); }

// multiply 2 numbers
//  Function uses 2 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 3 us, real32 3 us, real48 9 us, real64 6 us
//  real96 9 us, real128 12 us, real160 15 us, real192 18 us
//  real256 24 us, real384 39 us, real512 55 us, real768 95 us, real1024 146 us,
//  real1536 286 us, real2048 461 us
void REALNAME(Mul)(REAL* num, const REAL* num1, const REAL* num2);

// Extended mul
//  Function uses 1 temporary number in the stack.
//  Exponents are in packed form with sign in highest bit
EXP REALNAME(MulExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2);

// multiply by unsigned integer number u16 or u32
// Takes on R-Pico:
//  real16 2 us, real32 2 us, real48 3 us, real64 3 us
//  real96 4 us, real128 5 us, real160 5 us, real192 6 us
//  real256 8 us, real384 11 us, real512 14 us, real768 20 us, real1024 26 us,
//  real1536 38 us, real2048 50 us, real3072 73 us
void REALNAME(MulUInt)(REAL* num, const REAL* src, BASE n);

// multiply by signed integer number
void REALNAME(MulSInt)(REAL* num, const REAL* src, BASES n);

// Extended multiply by integer
//  Exponents are in packed form with sign in highest bit
EXP REALNAME(MulUIntExt)(REAL* num, const REAL* src, EXP exp, BASE n);
EXP REALNAME(MulSIntExt)(REAL* num, const REAL* src, EXP exp, BASES n);

// divide 2 numbers
//  Function uses 2 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 12 us, real32 18 us, real48 65 us, real64 45 us
//  real96 120 us, real128 210 us, real160 300 us, real192 410 us
//  real256 680 us, real384 1400 us, real512 2500 us, real768 5 ms, real1024 10 ms,
//  real1536 21 ms, real2048 37 ms
void REALNAME(Div)(REAL* num, const REAL* num1, const REAL* num2);

// Extended divide
//  Function uses 2 temporary numbers in the stack.
//  Exponents are in packed form with sign in highest bit
EXP REALNAME(DivExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2);

// divide by u16 integer number
// Takes on R-Pico:
//  real16 3 us, real32 4 us, real48 5 us, real64 5 us
//  real96 7 us, real128 8 us, real160 10 us, real192 11 us
//  real256 14 us, real384 20 us, real512 25 us, real768 37 us, real1024 48 us,
//  real1536 70 us, real2048 93 us, real3072 137 us
void REALNAME(DivU16)(REAL* num, const REAL* src, u16 n);

// divide by s16 integer number
void REALNAME(DivS16)(REAL* num, const REAL* src, s16 n);

// Extended divide by integer
//  Exponents are in packed form with sign in highest bit
EXP REALNAME(DivU16Ext)(REAL* num, const REAL* src, EXP exp, u16 n);
EXP REALNAME(DivS16Ext)(REAL* num, const REAL* src, EXP exp, s16 n);

// multiply by integer power of 2 (bit shift left if positive, or right if negative)
void REALNAME(Pow2)(REAL* num, int pow2);
//  Extended version uses exponent in packed form with sign in highest bit.
EXP REALNAME(Pow2Ext)(REAL* num, EXP exp, int pow2);

// power of 2 numbers (y = base^exp)
//  Function uses 7 temporary numbers in the stack.
void REALNAME(Pow)(REAL* num, const REAL* base, const REAL* exp);

// root of 2 numbers (y = base^(1/exp))
//  Function uses 8 temporary numbers in the stack.
void REALNAME(Root)(REAL* num, const REAL* base, const REAL* exp);

// modulus with floor rounding; result has same sign as divisor num2 (range 0..num2)
//  Function uses 4 temporary numbers in the stack.
void REALNAME(ModFloor)(REAL* num, const REAL* num1, const REAL* num2);
//  Function uses 3 temporary numbers in the stack.
EXP REALNAME(ModFloorExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2);

// modulus with trunc rounding; result has same sign as dividend num1 (range 0..num2 or 0..-num2)
//  Function uses 4 temporary numbers in the stack.
void REALNAME(ModTrunc)(REAL* num, const REAL* num1, const REAL* num2);
//  Function uses 3 temporary numbers in the stack.
EXP REALNAME(ModTruncExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2);

// modulus with nearest rounding; result is in range -num2/2..+num2/2
//  Function uses 4 temporary numbers in the stack.
void REALNAME(ModRound)(REAL* num, const REAL* num1, const REAL* num2);
//  Function uses 3 temporary numbers in the stack.
EXP REALNAME(ModRoundExt)(REAL* num, const REAL* num1, EXP exp1, const REAL* num2, EXP exp2);

// compare 2 numbers (returns -1 if num1<num2, 0 if num1=num2, +1 if num1>num2)
s8 REALNAME(Comp)(const REAL* num1, const REAL* num2);
//  - exponents are in packed form with sign in highest bit
s8 REALNAME(CompExt)(const REAL* num1, EXP exp1, const REAL* num2, EXP exp2);

// compare 2 numbers to equality with ignoring small difference (in number of bits)
//  Function uses 3 temporary numbers in the stack.
Bool REALNAME(CompEps)(const REAL* num1, const REAL* num2, int eps);
//  - exponents are in packed form with sign in highest bit
Bool REALNAME(CompEpsExt)(const REAL* num1, EXP exp1, const REAL* num2, EXP exp2, int eps);

// check difference of numbers (returns number of different bits 0..MANT_BITS)
//  Function uses 3 temporary numbers in the stack.
int REALNAME(CheckDif)(const REAL* num1, const REAL* num2);
//  Function uses 2 temporary numbers in the stack.
//  - exponents are in packed form with sign in highest bit
int REALNAME(CheckDifExt)(const REAL* num1, EXP exp1, const REAL* num2, EXP exp2);

// find greatest common divisor (GCD) of two integer numbers
// Function uss 5 temporary numbers in the stack.
void REALNAME(GCD)(REAL* num, const REAL* num1, const REAL* num2);

// === Functions

// negate (can change sign of zero, too)
void REALNAME(Neg)(REAL* num);

// absolute value
void REALNAME(Abs)(REAL* num);

// square x^2 (timings - see Mul)
//  Function uses 2 temporary numbers in the stack.
INLINE void REALNAME(SqrFrom)(REAL* num, const REAL* src) { REALNAME(Mul)(num, src, src); }
INLINE void REALNAME(Sqr)(REAL* num) { REALNAME(Mul)(num, num, num); }

// extended square x^2
//  Function uses 1 temporary number in the stack.
//  Exponents are in packed form with sign in highest bit
INLINE EXP REALNAME(SqrFromExt)(REAL* num, const REAL* src, EXP exp)
	{ return REALNAME(MulExt)(num, src, exp, src, exp); }
INLINE EXP REALNAME(SqrExt)(REAL* num, EXP exp)
	{ return REALNAME(MulExt)(num, num, exp, num, exp); }

// set signum (sets to 0 if number is zero, 1 if positive or -1 if negative)
void REALNAME(SignumFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Signum)(REAL* num) { REALNAME(SignumFrom)(num, num); }

// compare number to zero (returns -1 if num<0, 0 if num=0, +1 if num>0)
// - Alternative function is signum Signum(), which sets result to the number.
s8 REALNAME(Comp0)(const REAL* num);

// reciprocal value 1/x
//  Function uses 2 temporary numbers in the stack.
INLINE void REALNAME(RecFrom)(REAL* num, const REAL* src)
	{ REALNAME(Div)(num, &REALNAME(Const1), src); }
INLINE void REALNAME(Rec)(REAL* num) { REALNAME(RecFrom)(num, num); }

INLINE EXP REALNAME(RecFromExt)(REAL* num, const REAL* src, EXP exp)
	{ return REALNAME(DivExt)(num, (const REAL*)&REALNAME(Const1Ext), EXPEXT_1, src, exp); }
INLINE EXP REALNAME(RecExt)(REAL* num, EXP exp) { return REALNAME(RecFromExt)(num, num, exp); }

// multiply by 2 (increment exponent)
void REALNAME(Mul2)(REAL* num);
//  Extended version uses exponent in packed form with sign in highest bit.
EXP REALNAME(Mul2Ext)(REAL* num, EXP exp);

// divide by 2 (decrement exponent)
void REALNAME(Div2)(REAL* num);
//  Extended version uses exponent in packed form with sign in highest bit.
EXP REALNAME(Div2Ext)(REAL* num, EXP exp);

// increment number (increase by 1)
//  Function uses 2 temporary numbers in the stack.
void REALNAME(IncFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Inc)(REAL* num) { REALNAME(IncFrom)(num, num); }
//  Function uses 1 temporary number in the stack.
EXP REALNAME(IncFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(IncExt)(REAL* num, EXP exp)
	{ return REALNAME(IncFromExt)(num, num, exp); }

// decrement number (decrease by 1)
//  Function uses 2 temporary numbers in the stack.
void REALNAME(DecFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Dec)(REAL* num) { REALNAME(DecFrom)(num, num); }
//  Function uses 1 temporary number in the stack.
EXP REALNAME(DecFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(DecExt)(REAL* num, EXP exp)
	{ return REALNAME(DecFromExt)(num, num, exp); }

// Truncate, round towards zero (= "integer" function)
void REALNAME(Trunc)(REAL* num);
EXP REALNAME(TruncExt)(REAL* num, EXP exp);

// truncation fraction "num - trunc(num)"; result is -1..0 for num<0 or 0..+1 for num>=0
//  Function uses 3 temporary numbers in the stack.
void REALNAME(TruncFrac)(REAL* num);
EXP REALNAME(TruncFracExt)(REAL* num, EXP exp);

// Round number to nearest integer
//  Function uses 2 temporary numbers in the stack.
//  Half is rounded to higher numbers (+1.5 -> 2.0, -1.5 -> -2.0).
void REALNAME(RoundFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Round)(REAL* num) { REALNAME(RoundFrom)(num, num); }
//  Extended version uses exponent in packed form with sign in highest bit.
EXP REALNAME(RoundFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(RoundExt)(REAL* num, EXP exp) { return REALNAME(RoundFromExt)(num, num, exp); }

// Rounding fraction "num - round(num)" = -0.5..+0.5
//  Function uses 3 temporary numbers in the stack.
void REALNAME(RoundFracFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(RoundFrac)(REAL* num) { REALNAME(RoundFracFrom)(num, num); }
//  Extended version uses exponent in packed form with sign in highest bit.
EXP REALNAME(RoundFracFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(RoundFracExt)(REAL* num, EXP exp) { return REALNAME(RoundFracFromExt)(num, num, exp); }

// rounding down
//  Function uses 2 temporary numbers in the stack.
void REALNAME(Floor)(REAL* num);
EXP REALNAME(FloorExt)(REAL* num, EXP exp);

// rounding down fraction "num - floor(num)" = 0..+1
//  Function uses 3 temporary numbers in the stack.
void REALNAME(FloorFrac)(REAL* num);
//  Function uses 2 temporary numbers in the stack.
EXP REALNAME(FloorFracExt)(REAL* num, EXP exp);

// rounding up
//  Function uses 2 temporary numbers in the stack.
void REALNAME(Ceil)(REAL* num);
EXP REALNAME(CeilExt)(REAL* num, EXP exp);

// rounding up fraction "num - ceil(num)" = -1..0
//  Function uses 3 temporary numbers in the stack.
void REALNAME(CeilFrac)(REAL* num);
//  Function uses 2 temporary numbers in the stack.
EXP REALNAME(CeilFracExt)(REAL* num, EXP exp);

// check if number is integer
Bool REALNAME(IsInt)(const REAL* num);
Bool REALNAME(IsIntExt)(const REAL* num, EXP exp);

// check if number is odd integer
Bool REALNAME(IsOddInt)(const REAL* num);
Bool REALNAME(IsOddIntExt)(const REAL* num, EXP exp);

// check if number is power of 2
Bool REALNAME(IsPow2)(const REAL* num);
Bool REALNAME(IsPow2Ext)(const REAL* num, EXP exp);

// === Ln(x)

// ln(2) constant (0.6931471805599453)
// - uses similar method as Ln_Taylor, but does not require pre-calculated ln(2)
//  Function uses 5 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 190 us (3), real32 250 us (7), real48 460 us (11), real64 480 us (15),
//  real80 900 us (19), real96 900 us (25), real128 1400 us (34), real160 2 ms (44),
//  real192 3 ms (53), real256 6 ms (73), real384 15 ms (112), real512 30 ms (152),
//  real768 88 ms (232), real1024 195 ms (312), real1536 610 ms (472), real2048 1.4 s (634)
void REALNAME(Ln2_old)(REAL* num);
//  Function uses 4 temporary numbers in the stack.
EXP REALNAME(Ln2Ext)(REAL* num);
//  Function uses 4 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 155 us (5), real32 183 us (9), real48 330 us (14), real64 340 us (19),
//  real80 700 us (24), real96 610 us (29), real128 965 us (39), real160 1770 us (49),
//  real192 2 ms (59), real256 4 ms (79), real384 12 ms (119), real512 27 ms (160),
//  real768 82 ms (240), real1024 186 ms (321), real1536 602 ms (482), real2048 1.4 s (643)
void REALNAME(Ln2)(REAL* num);

// natural logarithm - Mercator serie
//  Function uses 5 temporary numbers in the stack.
// Takes on R-Pico (in the worst case, but can be faster):
//  real16 220 us (5), real32 350 us (17), real48 730 us (27), real64 850 us (39),
//  real80 1630 us (49), real96 1680 us (63), real128 2.8 ms (87), real160 4.5 ms (112),
//  real192 6.6 ms (138), real256 13 ms (188), real384 34 ms (290), real512 71 ms (393),
//  real768 213 ms (600), real1024 475 ms (808), real1536 1.5 s (1223), real2048 3.6 s (1642)
void REALNAME(Ln_MercatorFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(Ln_Mercator_old)(REAL* num) { REALNAME(Ln_MercatorFrom_old)(num, num); }
//  Function uses 4 temporary numbers in the stack.
EXP REALNAME(Ln_MercatorFromExt)(REAL* num, const REAL* src, EXP src_exp);
INLINE EXP REALNAME(Ln_MercatorExt)(REAL* num, EXP exp) { return REALNAME(Ln_MercatorFromExt)(num, num, exp); }
//  Function uses 4 temporary numbers in the stack.
// Takes on R-Pico (in the worst case, but can be faster):
//  real16 234 us (11), real32 350 us (24), real48 680 us (36), real64 770 us (49),
//  real80 1600 us (62), real96 1420 us (75), real128 2.4 ms (100), real160 3.8 ms (126),
//  real192 5.7 ms (152), real256 11 ms (204), real384 31 ms (308), real512 68 ms (413),
//  real768 210 ms (622), real1024 476 ms (830), real1536 1.5 s (1249), real2048 3.6 s (1667)
void REALNAME(Ln_MercatorFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Ln_Mercator)(REAL* num) { REALNAME(Ln_MercatorFrom)(num, num); }

// natural logarithm - Taylor serie
//  Function uses 5 temporary numbers in the stack.
// Takes on R-Pico (in the worst case, but can be faster):
//  real16 237 us (2), real32 275 us (5), real48 450 us (7), real64 465 us (10),
//  real80 766 us (12), real96 755 us (16), real128 1130 us(22), real160 1630 us (28),
//  real192 2 ms (34), real256 4 ms (46), real384 10 ms (71), real512 21 ms (97),
//  real768 58 ms (147), real1024 128 ms (198), real1536 394 ms (299), real2048 930 ms (402)
void REALNAME(Ln_TaylorFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(Ln_Taylor_old)(REAL* num) { REALNAME(Ln_TaylorFrom_old)(num, num); }
//  Function uses 4 temporary numbers in the stack.
EXP REALNAME(Ln_TaylorFromExt)(REAL* num, const REAL* src, EXP src_exp);
INLINE EXP REALNAME(Ln_TaylorExt)(REAL* num, EXP exp) { return REALNAME(Ln_TaylorFromExt)(num, num, exp); }
//  Function uses 4 temporary numbers in the stack.
// Takes on R-Pico (in the worst case, but can be faster):
//  real16 236 us (3), real32 270 us (6), real48 430 us (9), real64 445 us (12),
//  real80 737 us (16), real96 665 us (19), real128 960 us(25), real160 1390 us (31),
//  real192 2 ms (38), real256 3.5 ms (50), real384 9 ms (76), real512 19 ms (101),
//  real768 56 ms (152), real1024 124 ms (203), real1536 396 ms (306), real2048 910 ms (408)
void REALNAME(Ln_TaylorFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Ln_Taylor)(REAL* num) { REALNAME(Ln_TaylorFrom)(num, num); }

// natural logarithm - Chebyshev approximation
// Takes on R-Pico:
//  real16 180 us (7), real32 216 us (13), real48 380 us (19), real64 380 us (27),
//  real80 790 us (33), real96 640 us (39), real128 1030 us (51), real160 1600 us (62),
//  real192 2.4 ms (75), real256 5 ms (100), real384 14 ms (151), real512 30 ms (200),
//  real768 97 ms (301), real1024 223 ms (402), real1536 730 ms (602), real2048 - ms (-)
#ifdef CHEB_LN
void REALNAME(Ln_ChebyshevFrom)(REAL* num, const REAL* src);
EXP REALNAME(Ln_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp);
#else
INLINE void REALNAME(Ln_ChebyshevFrom)(REAL* num, const REAL* src) { REALNAME(Ln_TaylorFrom)(num, src); }
INLINE EXP REALNAME(Ln_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp)
	{ return REALNAME(Ln_TaylorFromExt)(num, src, src_exp); }
#endif
INLINE void REALNAME(Ln_Chebyshev)(REAL* num) { REALNAME(Ln_ChebyshevFrom)(num, num); }
INLINE EXP REALNAME(Ln_ChebyshevExt)(REAL* num, EXP exp) { return REALNAME(Ln_ChebyshevFromExt)(num, num, exp); }

// natural logarithm
INLINE void REALNAME(LnFrom)(REAL* num, const REAL* src) { REALNAME(Ln_TaylorFrom)(num, src); }
INLINE void REALNAME(Ln)(REAL* num) { REALNAME(LnFrom)(num, num); }

INLINE EXP REALNAME(LnFromExt)(REAL* num, const REAL* src, EXP exp) { return REALNAME(Ln_TaylorFromExt)(num, src, exp); }
INLINE EXP REALNAME(LnExt)(REAL* num, EXP exp) { return REALNAME(LnFromExt)(num, num, exp); }

// === Exp(x)

// natural exponent - Taylor serie
//  Function uses 4 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 195 us (4), real32 220 us (6), real48 380 us (9), real64 390 us (11)
//  real80 590 us (13), real96 570 us (16), real128 840 us (21), real160 1 ms (25),
//  real192 1.6 ms (30), real256 3 ms (38), real384 6 ms (54), real512 13 ms (69),
//  real768 35 ms (98), real1024 74 ms (125), real1536 221 ms (178), real2048 505 ms (228)
void REALNAME(Exp_TaylorFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(Exp_Taylor_old)(REAL* num) { REALNAME(Exp_TaylorFrom_old)(num, num); }
//  Function uses 3 temporary numbers in the stack.
EXP REALNAME(Exp_TaylorFromExt)(REAL* num, const REAL* src, EXP src_exp);
INLINE EXP REALNAME(Exp_TaylorExt)(REAL* num, EXP exp) { return REALNAME(Exp_TaylorFromExt)(num, num, exp); }
//  Function uses 3 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 195 us (5), real32 220 us (8), real48 350 us (11), real64 350 us (13)
//  real80 570 us (16), real96 480 us (18), real128 700 us (23), real160 1 ms (28),
//  real192 1.4 ms (32), real256 2 ms (40), real384 6 ms (56), real512 12 ms (72),
//  real768 34 ms (100), real1024 74 ms (128), real1536 225 ms (181), real2048 500 ms (231)
void REALNAME(Exp_TaylorFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Exp_Taylor)(REAL* num) { REALNAME(Exp_TaylorFrom)(num, num); }

// natural exponent - Chebyshev approximation
// Takes on R-Pico:
//  real16 180 us (7), real32 200 us (10), real48 345 us (15), real64 319 us (17),
//  real80 554 us (19), real96 460 us (23), real128 680 us(29), real160 940 us (32),
//  real192 1.3 ms (37), real256 2.4 ms (46), real384 6 ms (63), real512 13 ms (81),
//  real768 36 ms (112), real1024 79 ms (142), real1536 243 ms (200), real2048 - ms (-)
#ifdef CHEB_EXP
void REALNAME(Exp_ChebyshevFrom)(REAL* num, const REAL* src);
EXP REALNAME(Exp_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp);
#else
INLINE void REALNAME(Exp_ChebyshevFrom)(REAL* num, const REAL* src) { REALNAME(Exp_TaylorFrom)(num, src); }
INLINE EXP REALNAME(Exp_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp)
	{ return REALNAME(Exp_TaylorFromExt)(num, src, src_exp); }
#endif
INLINE void REALNAME(Exp_Chebyshev)(REAL* num) { REALNAME(Exp_ChebyshevFrom)(num, num); }
INLINE EXP REALNAME(Exp_ChebyshevExt)(REAL* num, EXP exp) { return REALNAME(Exp_ChebyshevFromExt)(num, num, exp); }

// natural exponent
INLINE void REALNAME(ExpFrom)(REAL* num, const REAL* src) { REALNAME(Exp_TaylorFrom)(num, src); }
INLINE void REALNAME(Exp)(REAL* num) { REALNAME(ExpFrom)(num, num); }

INLINE EXP REALNAME(ExpFromExt)(REAL* num, const REAL* src, EXP exp) { return REALNAME(Exp_TaylorFromExt)(num, src, exp); }
INLINE EXP REALNAME(ExpExt)(REAL* num, EXP exp) { return REALNAME(ExpFromExt)(num, num, exp); }

// decimal logarithm
//  Function uses 5 temporary numbers in the stack.
void REALNAME(Log10From)(REAL* num, const REAL* src);
INLINE void REALNAME(Log10)(REAL* num) { REALNAME(Log10From)(num, num); }

// decimal exponent
//  Function uses 5 temporary numbers in the stack.
void REALNAME(Exp10From)(REAL* num, const REAL* src);
INLINE void REALNAME(Exp10)(REAL* num) { REALNAME(Exp10From)(num, num); }

// binary logarithm
//  Function uses 5 temporary numbers in the stack.
void REALNAME(Log2From)(REAL* num, const REAL* src);
INLINE void REALNAME(Log2)(REAL* num) { REALNAME(Log2From)(num, num); }

// binary exponent
//  Function uses 5 temporary numbers in the stack.
void REALNAME(Exp2From)(REAL* num, const REAL* src);
INLINE void REALNAME(Exp2)(REAL* num) { REALNAME(Exp2From)(num, num); }

// === Sqrt(x)

// sqrt (square root) - with logarithm
//  Function uses 5 temporary numbers in the stack.
// Takes on R-Pico (in the worst case, but can be faster):
//  real16 320 us (6), real32 390 us (11), real48 700 us (16), real64 710 us (21),
//  real80 1 ms (25), real96 1 ms (32), real128 2 ms (43), real160 3 ms (53),
//  real192 4 ms (63), real256 7 ms (83), real384 16 ms (124), real512 33 ms (165),
//  real768 93 ms (243), real1024 200 ms (321), real1536 611 ms (474), real2048 1.4 s (628)
void REALNAME(Sqrt_LnFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(Sqrt_Ln_old)(REAL* num) { REALNAME(Sqrt_LnFrom_old)(num, num); }

//  Function uses 4 temporary numbers in the stack.
EXP REALNAME(Sqrt_LnFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(Sqrt_LnExt)(REAL* num, EXP exp) { return REALNAME(Sqrt_LnFromExt)(num, num, exp); }

//  Function uses 4 temporary numbers in the stack.
// Takes on R-Pico (in the worst case, but can be faster):
//  real16 340 us (8), real32 390 us (14), real48 650 us (20), real64 650 us (25),
//  real80 1 ms (32), real96 1 ms (37), real128 2 ms (48), real160 2 ms (58),
//  real192 3 ms (70), real256 6 ms (90), real384 15 ms (132), real512 31 ms (172),
//  real768 90 ms (251), real1024 198 ms (329), real1536 620 ms (485), real2048 1.4 s (637)
void REALNAME(Sqrt_LnFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Sqrt_Ln)(REAL* num) { REALNAME(Sqrt_LnFrom)(num, num); }

// sqrt (square root) - with Newton
//  Function uses 5 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 210 us (5), real32 290 us (7), real48 720 us (8), real64 600 us (8),
//  real80 1.4 ms (8), real96 1.4 ms (9), real128 2 ms (9), real160 3 ms (10),
//  real192 4 ms (10), real256 7 ms (10), real384 16 ms (11), real512 27 ms (11),
//  real768 64 ms (12), real1024 114 ms (12), real1536 263 ms (13), real2048 501 ms (14)
void REALNAME(Sqrt_NewtonFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(Sqrt_Newton_old)(REAL* num) { REALNAME(Sqrt_NewtonFrom_old)(num, num); }

//  Function uses 4 temporary numbers in the stack.
EXP REALNAME(Sqrt_NewtonFromExt)(REAL* num, const REAL* src, EXP src_exp);
INLINE EXP REALNAME(Sqrt_NewtonExt)(REAL* num, EXP exp) { return REALNAME(Sqrt_NewtonFromExt)(num, num, exp); }

//  Function uses 4 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 220 us (6), real32 290 us (7), real48 630 us (8), real64 560 us (8),
//  real80 1.3 ms (9), real96 1.1 ms (9), real128 1.6 ms (9), real160 2.4 ms (10),
//  real192 3 ms (10), real256 6 ms (11), real384 11 ms (11), real512 20 ms (12),
//  real768 43 ms (12), real1024 81 ms (13), real1536 175 ms (13), real2048 332 ms (14)
void REALNAME(Sqrt_NewtonFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Sqrt_Newton)(REAL* num) { REALNAME(Sqrt_NewtonFrom)(num, num); }

// sqrt (square root) - with Taylor serie
//  Function uses 5 temporary numbers in the stack.
// Takes on R-Pico
//  real16 200 us (3), real32 290 us (9), real48 550 us (16), real64 660 us (24)
//  real80 1 ms (30), real96 1.3 ms (40), real128 2 ms (56), real160 3 ms (73),
//  real192 5 ms (90), real256 9 ms (124), real384 25 ms (193), real512 51 ms (262),
//  real768 150 ms (403), real1024 335 ms (543), real1536 1 s (824), real2048 2.5 s (1107)
void REALNAME(Sqrt_TaylorFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(Sqrt_Taylor_old)(REAL* num) { REALNAME(Sqrt_TaylorFrom_old)(num, num); }

//  Function uses 4 temporary numbers in the stack.
EXP REALNAME(Sqrt_TaylorFromExt)(REAL* num, const REAL* src, EXP src_exp);
INLINE EXP REALNAME(Sqrt_TaylorExt)(REAL* num, EXP exp) { return REALNAME(Sqrt_TaylorFromExt)(num, num, exp); }

//  Function uses 4 temporary numbers in the stack.
// Takes on R-Pico
//  real16 200 us (6), real32 290 us (14), real48 550 us (22), real64 620 us (30)
//  real80 1 ms (39), real96 1 ms (48), real128 2 ms (65), real160 3 ms (82),
//  real192 4 ms (100), real256 9 ms (135), real384 23 ms (205), real512 49 ms (276),
//  real768 149 ms (417), real1024 334 ms (558), real1536 1 s (841), real2048 2.5 s (1124)
void REALNAME(Sqrt_TaylorFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Sqrt_Taylor)(REAL* num) { REALNAME(Sqrt_TaylorFrom)(num, num); }

// sqrt (square root) - with Chebyshev
// Takes on R-Pico:
//  real16 165 us (8), real32 235 us (20), real48 430 us (26), real64 460 us (38),
//  real80 1 ms (48), real96 830 us (55), real128 1.4 ms (76), real160 2.4 ms (96),
//  real192 3.7 ms (116), real256 7 ms (155), real384 22 ms (237), real512 48 ms (316),
//  real768 154 ms (476), real1024 355 ms (639), real1536 1 s (961), real2048 - (-)
#ifdef CHEB_SQRT
void REALNAME(Sqrt_ChebyshevFrom)(REAL* num, const REAL* src);
EXP REALNAME(Sqrt_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp);
#else
INLINE void REALNAME(Sqrt_ChebyshevFrom)(REAL* num, const REAL* src) { REALNAME(Sqrt_NewtonFrom)(num, src); }
INLINE EXP REALNAME(Sqrt_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp)
	{ return REALNAME(Sqrt_TaylorFromExt)(num, src, src_exp); }
#endif
INLINE void REALNAME(Sqrt_Chebyshev)(REAL* num) { REALNAME(Sqrt_ChebyshevFrom)(num, num); }
INLINE EXP REALNAME(Sqrt_ChebyshevExt)(REAL* num, EXP exp) { return REALNAME(Sqrt_ChebyshevFromExt)(num, num, exp); }

// sqrt (square root)
INLINE void REALNAME(SqrtFrom)(REAL* num, const REAL* src) { REALNAME(Sqrt_NewtonFrom)(num, src); }
INLINE void REALNAME(Sqrt)(REAL* num) { REALNAME(SqrtFrom)(num, num); }

INLINE EXP REALNAME(SqrtFromExt)(REAL* num, const REAL* src, EXP exp) { return REALNAME(Sqrt_NewtonFromExt)(num, src, exp); }
INLINE EXP REALNAME(SqrtExt)(REAL* num, EXP exp) { return REALNAME(SqrtFromExt)(num, num, exp); }

// === Sin(x)

// convert angle from current angle unit to radians
//  Function uses 2 temporary numbers in the stack.
void REALNAME(ToRad)(REAL* num);
//  Function uses 1 temporary number in the stack.
EXP REALNAME(ToRadExt)(REAL* num, EXP exp);

// convert angle from radians to current angle unit
//  Function uses 2 temporary numbers in the stack.
void REALNAME(FromRad)(REAL* num);
//  Function uses 1 temporary number in the stack.
EXP REALNAME(FromRadExt)(REAL* num, EXP exp);

// normalize angle in radians - unsigned, to range 0..PI*2 (0..360°)
//  Function uses 4 temporary numbers in the stack.
void REALNAME(NormRadU)(REAL* num);

//  Function uses 3 temporary numbers in the stack.
EXP REALNAME(NormRadUExt)(REAL* num, EXP exp);

// normalize angle in radians - signed, to range -PI..+PI (-180°..+180°)
//  Function uses 4 temporary numbers in the stack.
void REALNAME(NormRadS)(REAL* num);

//  Function uses 3 temporary numbers in the stack.
EXP REALNAME(NormRadSExt)(REAL* num, EXP exp);

// sine - Taylor serie
//  Function uses 6 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 215 us (4), real32 235 us (6), real48 370 us (8), real64 380 us (10),
//  real80 540 us (11), real96 520 us (13), real128 680 us (16), real160 980 us (20),
//  real192 1 ms (23), real256 2 ms (28), real384 5 ms (39), real512 9 ms (49),
//  real768 24 ms (68), real1024 52 ms (87), real1536 150 ms (121), real2048 340 ms (153)
void REALNAME(Sin_TaylorFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(Sin_Taylor_old)(REAL* num) { REALNAME(Sin_TaylorFrom_old)(num, num); }

//  Function uses 5 temporary numbers in the stack.
EXP REALNAME(Sin_TaylorFromExt)(REAL* num, const REAL* src, EXP src_exp);
INLINE EXP REALNAME(Sin_TaylorExt)(REAL* num, EXP exp) { return REALNAME(Sin_TaylorFromExt)(num, num, exp); }

//  Function uses 5 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 188 us (5), real32 208 us (7), real48 317 us (9), real64 326 us (11),
//  real80 490 us (13), real96 450 us (15), real128 580 us (18), real160 800 us (21),
//  real192 1 ms (24), real256 2 ms (30), real384 4 ms (41), real512 9 ms (51),
//  real768 24 ms (70), real1024 51 ms (89), real1536 153 ms (123), real2048 337 ms (155)
//  real3072 1 s (217)
void REALNAME(Sin_TaylorFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Sin_Taylor)(REAL* num) { REALNAME(Sin_TaylorFrom)(num, num); }

// sine/cosine - Taylor serie
//  Function uses 7 temporary numbers in the stack.
//  If sin_num and cos_num point to the same number, result is undefined.
//  Returns exponent of the sine.
// Takes on R-Pico:
//  real16 240 us (4), real32 290 us (7), real48 450 us (9), real64 450 us (11),
//  real80 690 us (13), real96 620 us (14), real128 850 us (18), real160 1 ms (21),
//  real192 1.5 ms (24), real256 2.5 ms (30), real384 5.5 ms (41), real512 10 ms (51),
//  real768 28 ms (70), real1024 57 ms (88), real1536 164 ms (122), real2048 357 ms (155)
//  real3072 1 s (217)
EXP REALNAME(SinCos_TaylorFromExt)(REAL* sin_num, REAL* cos_num, EXP* cos_exp, const REAL* src, EXP src_exp);
void REALNAME(SinCos_TaylorFrom)(REAL* sin_num, REAL* cos_num, const REAL* src);

// cosine - Taylor serie
//  Function uses 5 temporary numbers in the stack.
void REALNAME(Cos_TaylorFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(Cos_Taylor_old)(REAL* num) { REALNAME(Cos_TaylorFrom_old)(num, num); }

//  real16 188 us (3), real32 208 us (5), real48 317 us (6), real64 300 us (8),
//  real80 420 us (9), real96 400 us (11), real128 500 us (13), real160 690 us (16),
//  real192 1 ms (18), real256 1.5 ms (23), real384 3.6 ms (32), real512 7 ms (40),
//  real768 20 ms (56), real1024 42 ms (71), real1536 126 ms (100), real2048 280 ms (128)
//  real3072 880 ms (181)
void REALNAME(Cos_TaylorFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Cos_Taylor)(REAL* num) { REALNAME(Cos_TaylorFrom)(num, num); }

EXP REALNAME(Cos_TaylorFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(Cos_TaylorExt)(REAL* num, EXP exp) { return REALNAME(Cos_TaylorFromExt)(num, num, exp); }

// sine - Chebyshev approximation
// Takes on R-Pico:
//  real16 195 us (9), real32 212 us (13), real48 330 us (14), real64 320 us (16),
//  real80 570 us (20), real96 450 us (22), real128 670 us(28), real160 1 ms (33),
//  real192 1.3 ms (38), real256 2.4 ms (47), real384 6 ms (65), real512 13 ms (83),
//  real768 37 ms (116), real1024 81 ms (147), real1536 246 ms (204), real2048 337 ms (155)
#ifdef CHEB_SIN
void REALNAME(Sin_ChebyshevFrom)(REAL* num, const REAL* src);
EXP REALNAME(Sin_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp);
#else
INLINE void REALNAME(Sin_ChebyshevFrom)(REAL* num, const REAL* src) { REALNAME(Sin_TaylorFrom)(num, src); }
INLINE EXP REALNAME(Sin_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp)
	{ return REALNAME(Sin_TaylorFromExt)(num, src, src_exp); }
#endif
INLINE void REALNAME(Sin_Chebyshev)(REAL* num) { REALNAME(Sin_ChebyshevFrom)(num, num); }
INLINE EXP REALNAME(Sin_ChebyshevExt)(REAL* num, EXP exp) { return REALNAME(Sin_ChebyshevFromExt)(num, num, exp); }

// sine/cosine - Cordic
// Takes on R-Pico:
//  real16 177 us (16), real32 215 us (32), real48 440 us (48), real64 410 us (64),
//  real80 840 us (80), real96 730 us (96), real128 1 ms (128), real160 1.5 ms (160),
//  real192 2 ms (192), real256 3 ms (256), real384 6 ms (384), real512 11 ms (512),
//  real768 24 ms (768), real1024 42 ms (1024), real1536 92 ms (1536), real2048 161 ms (2048)
//  real3072 360 ms (3072)
#ifdef CORD_ATAN

EXP REALNAME(SinCos_CordicFromExt)(REAL* sin_num, REAL* cos_num, EXP* cos_exp, const REAL* src, EXP src_exp);
void REALNAME(SinCos_CordicFrom)(REAL* sin_num, REAL* cos_num, const REAL* src);

EXP REALNAME(Sin_CordicFromExt)(REAL* num, const REAL* src, EXP src_exp);
INLINE EXP REALNAME(Sin_CordicExt)(REAL* num, EXP exp)
	{ return REALNAME(Sin_CordicFromExt)(num, num, exp); }

void REALNAME(Sin_CordicFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Sin_Cordic)(REAL* num)
	{ REALNAME(Sin_CordicFrom)(num, num); }

EXP REALNAME(Cos_CordicFromExt)(REAL* num, const REAL* src, EXP src_exp);
INLINE EXP REALNAME(Cos_CordicExt)(REAL* num, EXP exp)
	{ return REALNAME(Cos_CordicFromExt)(num, num, exp); }

void REALNAME(Cos_CordicFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Cos_Cordic)(REAL* num)
	{ REALNAME(Cos_CordicFrom)(num, num); }

#else

INLINE EXP REALNAME(SinCos_CordicFromExt)(REAL* sin_num, REAL* cos_num, EXP* cos_exp, const REAL* src, EXP src_exp)
	{ return REALNAME(SinCos_TaylorFromExt)(sin_num, cos_num, cos_exp, src, src_exp); }
INLINE void REALNAME(SinCos_CordicFrom)(REAL* sin_num, REAL* cos_num, const REAL* src)
	{ REALNAME(SinCos_TaylorFrom)(sin_num, cos_num, src); }

INLINE EXP REALNAME(Sin_CordicFromExt)(REAL* num, const REAL* src, EXP src_exp)
	{ return REALNAME(Sin_TaylorFromExt)(num, src, src_exp); }
INLINE EXP REALNAME(Sin_CordicExt)(REAL* num, EXP exp)
	{ return REALNAME(Sin_TaylorFromExt)(num, num, exp); }

INLINE void REALNAME(Sin_CordicFrom)(REAL* num, const REAL* src)
	{ REALNAME(Sin_TaylorFrom)(num, src); }
INLINE void REALNAME(Sin_Cordic)(REAL* num)
	{ REALNAME(Sin_TaylorFrom)(num, num); }

INLINE EXP REALNAME(Cos_CordicFromExt)(REAL* num, const REAL* src, EXP src_exp)
	{ return REALNAME(Cos_TaylorFromExt)(num, src, src_exp); }
INLINE EXP REALNAME(Cos_CordicExt)(REAL* num, EXP exp)
	{ return REALNAME(Cos_TaylorFromExt)(num, num, exp); }

INLINE void REALNAME(Cos_CordicFrom)(REAL* num, const REAL* src)
	{ REALNAME(Cos_TaylorFrom)(num, src); }
INLINE void REALNAME(Cos_Cordic)(REAL* num)
	{ REALNAME(Cos_TaylorFrom)(num, num); }

#endif

// sine
INLINE void REALNAME(SinFrom)(REAL* num, const REAL* src) { REALNAME(Sin_TaylorFrom)(num, src); }
INLINE void REALNAME(Sin)(REAL* num) { REALNAME(SinFrom)(num, num); }

INLINE EXP REALNAME(SinFromExt)(REAL* num, const REAL* src, EXP exp)
	{ return REALNAME(Sin_TaylorFromExt)(num, src, exp); }
INLINE EXP REALNAME(SinExt)(REAL* num, EXP exp)
	{ return REALNAME(SinFromExt)(num, num, exp); }

// cosine - Chebyshev approximation
void REALNAME(Cos_ChebyshevFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(Cos_Chebyshev_old)(REAL* num)
	{ REALNAME(Cos_ChebyshevFrom_old)(num, num); }

void REALNAME(Cos_ChebyshevFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Cos_Chebyshev)(REAL* num)
	{ REALNAME(Cos_ChebyshevFrom)(num, num); }

EXP REALNAME(Cos_ChebyshevFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(Cos_ChebyshevExt)(REAL* num, EXP exp)
	{ return REALNAME(Cos_ChebyshevFromExt)(num, num, exp); }

// cosine
INLINE void REALNAME(CosFrom)(REAL* num, const REAL* src)
	{ REALNAME(Cos_TaylorFrom)(num, src); }
INLINE void REALNAME(Cos)(REAL* num) { REALNAME(CosFrom)(num, num); }

INLINE EXP REALNAME(CosFromExt)(REAL* num, const REAL* src, EXP exp)
	{ return REALNAME(Cos_TaylorFromExt)(num, src, exp); }
INLINE EXP REALNAME(CosExt)(REAL* num, EXP exp) { return REALNAME(CosFromExt)(num, num, exp); }

// sine-cosine
INLINE EXP REALNAME(SinCosFromExt)(REAL* sin_num, REAL* cos_num, EXP* cos_exp, const REAL* src, EXP src_exp)
	{ return REALNAME(SinCos_TaylorFromExt)(sin_num, cos_num, cos_exp, src, src_exp); }
INLINE void REALNAME(SinCosFrom)(REAL* sin_num, REAL* cos_num, const REAL* src)
	{ REALNAME(SinCos_TaylorFrom)(sin_num, cos_num, src); }

// tangent
//  Function uses 6 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 330 us (9), real32 410 us (15), real48 726 us (19), real64 770 us (24),
//  real80 1.2 ms (26), real96 1.1 ms (31), real128 1.6 ms (38), real160 2.4 ms (46),
//  real192 3.4 ms (52), real256 5 ms (64), real384 13 ms (88), real512 23 ms (110),
//  real768 60 ms (151), real1024 124 ms (191), real1536 351 ms (264), real2048 790 ms (333)
//  real3072 2.6 s (466)
void REALNAME(TanFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(Tan_old)(REAL* num)
	{ REALNAME(TanFrom_old)(num, num); }

EXP REALNAME(Tan_TaylorFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(Tan_TaylorExt)(REAL* num, EXP exp)
	{ return REALNAME(Tan_TaylorFromExt)(num, num, exp); }

// Takes on R-Pico:
//  real16 280 us (4), real32 330 us (7), real48 530 us (11), real64 525 us (11),
//  real80 850 us (13), real96 750 us (14), real128 1 ms (18), real160 1.4 ms (21),
//  real192 1.8 ms (24), real256 3 ms (30), real384 6.6 ms (41), real512 12 ms (51),
//  real768 31 ms (70), real1024 63 ms (88), real1536 178 ms (122), real2048 380 ms (155)
//  real3072 1 s (217)
void REALNAME(Tan_TaylorFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Tan_Taylor)(REAL* num)
	{ REALNAME(Tan_TaylorFrom)(num, num); }

EXP REALNAME(Tan_ChebyshevFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(Tan_ChebyshevExt)(REAL* num, EXP exp)
	{ return REALNAME(Tan_ChebyshevFromExt)(num, num, exp); }

// Takes on R-Pico:
//  real16 288 us (18), real32 330 us (26), real48 590 us (28), real64 520 us (32),
//  real80 1 ms (40), real96 870 us (44), real128 1.3 ms (56), real160 2 ms (66),
//  real192 2.7 ms (76), real256 5 ms (94), real384 13 ms (130), real512 27 ms (166),
//  real768 78 ms (232), real1024 170 ms (294), real1536 507 ms (408), real2048 641 ms (283)
//  real3072 2 s (398)
void REALNAME(Tan_ChebyshevFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Tan_Chebyshev)(REAL* num)
	{ REALNAME(Tan_ChebyshevFrom)(num, num); }

EXP REALNAME(Tan_CordicFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(Tan_CordicExt)(REAL* num, EXP exp)
	{ return REALNAME(Tan_CordicFromExt)(num, num, exp); }

// Takes on R-Pico:
//  real16 215 us (16), real32 258 us (32), real48 536 us (48), real64 475 us (64),
//  real80 992 us (80), real96 840 us (96), real128 1.3 ms (128), real160 1.7 ms (160),
//  real192 2.3 ms (192), real256 3.8 ms (256), real384 8 ms (384), real512 13 ms (512),
//  real768 28 ms (768), real1024 48 ms (1024), real1536 106 ms (1536), real2048 186 ms (2048)
//  real3072 410 ms (3072)
void REALNAME(Tan_CordicFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Tan_Cordic)(REAL* num)
	{ REALNAME(Tan_CordicFrom)(num, num); }

INLINE EXP REALNAME(TanFromExt)(REAL* num, const REAL* src, EXP exp)
	{ return REALNAME(Tan_TaylorFromExt)(num, src, exp); }
INLINE EXP REALNAME(TanExt)(REAL* num, EXP exp)
	{ return REALNAME(TanFromExt)(num, num, exp); }

INLINE void REALNAME(TanFrom)(REAL* num, const REAL* src)
	{ REALNAME(Tan_TaylorFrom)(num, src); }
INLINE void REALNAME(Tan)(REAL* num)
	{ REALNAME(TanFrom)(num, num); }

// cotangent
//  Function uses 6 temporary numbers in the stack.
void REALNAME(CoTanFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(CoTan_old)(REAL* num)
	{ REALNAME(CoTanFrom_old)(num, num); }

EXP REALNAME(CoTan_TaylorFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(CoTan_TaylorExt)(REAL* num, EXP exp)
	{ return REALNAME(CoTan_TaylorFromExt)(num, num, exp); }

void REALNAME(CoTan_TaylorFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(CoTan_Taylor)(REAL* num)
	{ REALNAME(CoTan_TaylorFrom)(num, num); }

EXP REALNAME(CoTan_ChebyshevFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(CoTan_ChebyshevExt)(REAL* num, EXP exp)
	{ return REALNAME(CoTan_ChebyshevFromExt)(num, num, exp); }

void REALNAME(CoTan_ChebyshevFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(CoTan_Chebyshev)(REAL* num)
	{ REALNAME(CoTan_ChebyshevFrom)(num, num); }

EXP REALNAME(CoTan_CordicFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(CoTan_CordicExt)(REAL* num, EXP exp)
	{ return REALNAME(CoTan_CordicFromExt)(num, num, exp); }

void REALNAME(CoTan_CordicFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(CoTan_Cordic)(REAL* num)
	{ REALNAME(CoTan_CordicFrom)(num, num); }

INLINE EXP REALNAME(CoTanFromExt)(REAL* num, const REAL* src, EXP exp)
	{ return REALNAME(CoTan_TaylorFromExt)(num, src, exp); }
INLINE EXP REALNAME(CoTanExt)(REAL* num, EXP exp)
	{ return REALNAME(CoTanFromExt)(num, num, exp); }

INLINE void REALNAME(CoTanFrom)(REAL* num, const REAL* src)
	{ REALNAME(CoTan_TaylorFrom)(num, src); }
INLINE void REALNAME(CoTan)(REAL* num)
	{ REALNAME(CoTanFrom)(num, num); }

// === ASin(x)

// Generate constant pi (using Taylor serie, pi=6*asin(0.5))
//  Function uses 4 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 161 us (3), real32 259 us (9), real48 513 us (16), real64 570 us (24)
//  real96 1 ms (39), real128 2 ms (55), real160 3 ms (70), real192 4 ms (87)
//  real256 9 ms (119), real384 25 ms (186), real512 54 ms (253), real768 159 ms (387), real1024 351 ms (522),
//  real1536 1 s (792), real2048 2.5 s (1064)
void REALNAME(Pi_old)(REAL* num);
EXP REALNAME(PiExt)(REAL* num);
void REALNAME(Pi)(REAL* num);

// arcus sine (result is in range -PI/2..+PI/2) - Taylor serie
//  Function uses 7 temporary numbers in the stack.
// Takes on R-Pico, worst value 0.74 (interval 0 .. 0.75):
//  real16 470 us (11), real32 407 us (18), real48 1 ms (33), real64 1 ms (49),
//  real80 2 ms (62), real96 2 ms (82), real128 4 ms (116), real160 7 ms (151),
//  real192 11 ms (186), real256 22 ms (257), real384 59 ms (401), real512 122 ms (545),
//  real768 355 ms (836), real1024 771 ms (1128), real1536 2.4 s (1713), real2048 6 s (2301)
// Takes on R-Pico, worst value 0.76 (interval 0.75 .. 1):
//  real16 460 us (11), real32 630 us (20), real48 1.3 ms (31), real64 1.4 ms (43),
//  real80 3 ms (52), real96 3 ms (66), real128 5 ms (91), real160 7 ms (115),
//  real192 10 ms (141), real256 20 ms (190), real384 52 ms (292), real512 100 ms (392),
//  real768 289 ms (597), real1024 612 ms (801), real1536 1.8 s (1210), real2048 4 s (1622)
void REALNAME(ASin_TaylorFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(ASin_Taylor_old)(REAL* num) { REALNAME(ASin_TaylorFrom_old)(num, num); }
//  Function uses 6 temporary numbers in the stack.
EXP REALNAME(ASin_TaylorFromExt)(REAL* num, const REAL* src, EXP src_exp);
INLINE EXP REALNAME(ASin_TaylorExt)(REAL* num, EXP exp) { return REALNAME(ASin_TaylorFromExt)(num, num, exp); }
//  Function uses 6 temporary numbers in the stack.
// Takes on R-Pico, worst value 0.74 (interval 0 .. 0.75):
//  real16 280 us (11), real32 440 us (28), real48 1 ms (45), real64 1 ms (62),
//  real80 2 ms (80), real96 2 ms (98), real128 4 ms (134), real160 7 ms (170),
//  real192 10 ms (207), real256 20 ms (280), real384 56 ms (426), real512 118 ms (573),
//  real768 349 ms (866), real1024 770 ms (1160), real1536 2.4 s (1748), real2048 6 s (2337)
// Takes on R-Pico, worst value 0.76 (interval 0.75 .. 1):
//  real16 420 us (15), real32 600 us (27), real48 1.2 ms (39), real64 1.3 ms (52),
//  real80 3 ms (65), real96 3 ms (77), real128 4 ms (103), real160 6 ms (129),
//  real192 10 ms (155), real256 19 ms (206), real384 49 ms (309), real512 100 ms (412),
//  real768 284 ms (618), real1024 609 ms (823), real1536 1.9 s (1235), real2048 4 s (1647)
void REALNAME(ASin_TaylorFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(ASin_Taylor)(REAL* num) { REALNAME(ASin_TaylorFrom)(num, num); }

// arcus sine (result is in range -PI/2..+PI/2) - Chebyshev approximation
// Takes on R-Pico:
//  real16 350 us (14), real32 468 us (27), real48 960 us (34), real64 1 ms (46),
//  real80 2 ms (55), real96 1.8 ms (67), real128 3 ms (85), real160 4.5 ms (105),
//  real192 7 ms (128), real256 13 ms (167), real384 33 ms (248), real512 67 ms (328),
//  real768 196 ms (490), real1024 428 ms (651), real1536 1.3 s (974), real2048 - ms (-)
#ifdef CHEB_ASIN
void REALNAME(ASin_ChebyshevFrom)(REAL* num, const REAL* src);
EXP REALNAME(ASin_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp);
#else
INLINE void REALNAME(ASin_ChebyshevFrom)(REAL* num, const REAL* src) { REALNAME(ASin_TaylorFrom)(num, src); }
INLINE EXP REALNAME(ASin_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp)
	{ return REALNAME(ASin_TaylorFromExt)(num, src, src_exp); }
#endif
INLINE void REALNAME(ASin_Chebyshev)(REAL* num) { REALNAME(ASin_ChebyshevFrom)(num, num); }
INLINE EXP REALNAME(ASin_ChebyshevExt)(REAL* num, EXP exp) { return REALNAME(ASin_ChebyshevFromExt)(num, num, exp); }

// arcus sine - Cordic
// @TODO: This function is very inaccurate for some values. Correction is
// possible by using the double iteration method or better calculating using
// asin(x) = atan2(x, sqrt((1-x)*(1+x))).
// Takes on R-Pico:
//  real16 150 us (16), real32 193 us (32), real48 430 us (48), real64 390 us (64),
//  real80 830 us (80), real96 700 us (96), real128 1 ms (128), real160 1.5 ms (160),
//  real192 2 ms (192), real256 3 ms (256), real384 7 ms (384), real512 11 ms (512),
//  real768 25 ms (768), real1024 43 ms (1024), real1536 93 ms (1536), real2048 165 ms (2048),
//  real3072 370 ms (3072)
EXP REALNAME(ASin_CordicFromExt)(REAL* num, const REAL* src, EXP src_exp);
INLINE EXP REALNAME(ASin_CordicExt)(REAL* num, EXP exp)
	{ return REALNAME(ASin_CordicFromExt)(num, num, exp); }

void REALNAME(ASin_CordicFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(ASin_Cordic)(REAL* num) { REALNAME(ASin_CordicFrom)(num, num); }

// arcus sine
INLINE void REALNAME(ASinFrom)(REAL* num, const REAL* src) { REALNAME(ASin_TaylorFrom)(num, src); }
INLINE void REALNAME(ASin)(REAL* num) { REALNAME(ASin_TaylorFrom)(num, num); }

INLINE EXP REALNAME(ASinFromExt)(REAL* num, const REAL* src, EXP exp) { return REALNAME(ASin_TaylorFromExt)(num, src, exp); }
INLINE EXP REALNAME(ASinExt)(REAL* num, EXP exp) { return REALNAME(ASinFromExt)(num, num, exp); }

// arcus cosine (result is in range 0..PI)
//  Function uses 6 temporary numbers in the stack.
void REALNAME(ACosFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(ACos_old)(REAL* num) { REALNAME(ACosFrom_old)(num, num); }

void REALNAME(ACosFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(ACos)(REAL* num) { REALNAME(ACosFrom)(num, num); }

EXP REALNAME(ACosFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(ACosExt)(REAL* num, EXP exp) { return REALNAME(ACosFromExt)(num, num, exp); }

// === ATan(x)

// arcus tangent (result is in range -PI/2..+PI/2) - Taylor serie
//  Taylor serie arctan(x) = x - x^3/3 + x^5/5 - x^7/7 + .... (for -1 < x < 1)
//  For abs(x) >= 2 we use alternate method: arctan(x)= pi/2 + arctan(-1/x)
//  For 0.5 <= abs(x) < 2 we use alternate method: arctan(x) = pi/4 + arctan((x-1)/(x+1))
//  Function uses 7 temporary numbers in the stack.
// Takes on R-Pico, worst value 0.49, 1st interval (0 .. 0.5):
//  real16 200 us (4), real32 260 us (10), real48 500 us (16), real64 580 us (24),
//  real80 1 ms (29), real96 1 ms (38), real128 1.8 ms (52), real160 2.7 ms (67),
//  real192 4 ms (82), real256 8 ms (112), real384 20 ms (173), real512 42 ms (234),
//  real768 127 ms (357), real1024 282 ms (480), real1536 900 ms (727), real2048 2 s (976)
// Takes on R-Pico, worst value 0.51, 2nd interval (0.5 .. 2.0)
//  real16 250 us (3), real32 300 us (7), real48 530 us (11), real64 550 us (15),
//  real80 1 ms (19), real96 950 us (24), real128 1.5 ms (33), real160 2.2 ms (43),
//  real192 3 ms (52), real256 6 ms (71), real384 15 ms (110), real512 30 ms (148),
//  real768 88 ms (226), real1024 192 ms (304), real1536 600 ms (461), real2048 1.4 s (619)
// Takes on R-Pico, worst value 2.1, 3rd interval (2.0 ..):
//  real16 250 us (4), real32 330 us (10), real48 620 us (16), real64 670 us (23),
//  real80 1.2 ms (28), real96 1.2 ms (36), real128 2 ms (50), real160 3 ms (64),
//  real192 4 ms (79), real256 8 ms (108), real384 21 ms (166), real512 44 ms (225),
//  real768 130 ms (343), real1024 290 ms (462), real1536 900 ms (699), real2048 2 s (938)
void REALNAME(ATan_TaylorFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(ATan_Taylor_old)(REAL* num) { REALNAME(ATan_TaylorFrom_old)(num, num); }

//  Function uses 6 temporary numbers in the stack.
EXP REALNAME(ATan_TaylorFromExt)(REAL* num, const REAL* src, EXP src_exp);
INLINE EXP REALNAME(ATan_TaylorExt)(REAL* num, EXP exp) { return REALNAME(ATan_TaylorFromExt)(num, num, exp); }

//  Function uses 6 temporary numbers in the stack.
// Takes on R-Pico, worst value 0.49, 1st interval (0 .. 0.5):
//  real16 200 us (7), real32 270 us (14), real48 490 us (22), real64 520 us (29),
//  real80 1 ms (37), real96 1 ms (44), real128 1.4 ms (60), real160 2.4 ms (75),
//  real192 3.5 ms (91), real256 7 ms (121), real384 19 ms (183), real512 40 ms (245),
//  real768 125 ms (369), real1024 283 ms (494), real1536 917 ms (742), real2048 2 s (991)
// Takes on R-Pico, worst value 0.51, 2nd interval (0.5 .. 2.0)
//  real16 250 us (5), real32 300 us (9), real48 515 us (14), real64 520 us (19),
//  real80 940 us (24), real96 830 us (28), real128 1.3 ms (38), real160 1.9 ms (48),
//  real192 3 ms (58), real256 5 ms (77), real384 13 ms (116), real512 28 ms (156),
//  real768 84 ms (234), real1024 189 ms (313), real1536 603 ms (471), real2048 1.4 s (628)
// Takes on R-Pico, worst value 2.1, 3rd interval (2.0 ..):
//  real16 259 us (7), real32 330 us (14), real48 590 us (21), real64 620 us (28),
//  real80 1.2 ms (35), real96 1 ms (43), real128 1.7 ms (58), real160 2.6 ms (72),
//  real192 4 ms (87), real256 7 ms (117), real384 19 ms (176), real512 41 ms (236),
//  real768 125 ms (355), real1024 282 ms (475), real1536 905 ms (714), real2048 2 s (953)
void REALNAME(ATan_TaylorFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(ATan_Taylor)(REAL* num) { REALNAME(ATan_TaylorFrom)(num, num); }

// arcus tangent (result is in range -PI/2..+PI/2) - Chebyshev approximation
//  Function uses 10 temporary numbers in the stack.
// Takes on R-Pico:
//  real16 234 us (6), real32 278 us (14), real48 480 us (19), real64 467 us (24),
//  real80 960 us (32), real96 820 us (39), real128 1.2 ms (50), real160 2 ms (62),
//  real192 2.7 ms (73), real256 5 ms (100), real384 15 ms (150), real512 33 ms (199),
//  real768 101 ms (300), real1024 230 ms (401), real1536 745 ms (602), real2048 - ms (-)
#ifdef CHEB_ATAN
void REALNAME(ATan_ChebyshevFrom)(REAL* num, const REAL* src);
EXP REALNAME(ATan_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp);
#else
INLINE void REALNAME(ATan_ChebyshevFrom)(REAL* num, const REAL* src) { REALNAME(ATan_TaylorFrom)(num, src); }
INLINE EXP REALNAME(ATan_ChebyshevFromExt)(REAL* num, const REAL* src, EXP src_exp)
	{ return REALNAME(ATan_TaylorFromExt)(num, src, src_exp); }
#endif
INLINE void REALNAME(ATan_Chebyshev)(REAL* num) { REALNAME(ATan_ChebyshevFrom)(num, num); }
INLINE EXP REALNAME(ATan_ChebyshevExt)(REAL* num, EXP exp) { return REALNAME(ATan_ChebyshevFromExt)(num, num, exp); }

// arcus tangent (result is in range -PI/2..+PI/2)
INLINE void REALNAME(ATanFrom)(REAL* num, const REAL* src) { REALNAME(ATan_TaylorFrom)(num, src); }
INLINE void REALNAME(ATan)(REAL* num) { REALNAME(ATan_TaylorFrom)(num, num); }

INLINE EXP REALNAME(ATanFromExt)(REAL* num, const REAL* src, EXP exp) { return REALNAME(ATan_TaylorFromExt)(num, src, exp); }
INLINE EXP REALNAME(ATanExt)(REAL* num, EXP exp) { return REALNAME(ATanFromExt)(num, num, exp); }

// arcus tangent of polar coordinates (result is in range 0..2*PI)
void REALNAME(ATan2_old)(REAL* num, const REAL* x, const REAL* y);

// arcus tangent of polar coordinates (result is in range -PI .. +PI)
EXP REALNAME(ATan2Ext)(REAL* num, const REAL* x, EXP x_exp, const REAL* y, EXP y_exp);
void REALNAME(ATan2)(REAL* num, const REAL* x, const REAL* y);

// arcus tangent of polar coordinates - Cordic (result is in range -PI .. +PI)
// @TODO: Defective function! This function is very inaccurate for some values!
EXP REALNAME(ATan2_CordicExt)(REAL* num, const REAL* x, EXP x_exp, const REAL* y, EXP y_exp);
void REALNAME(ATan2_Cordic)(REAL* num, const REAL* x, const REAL* y);

// radius of coordinates, radius = sqrt(x^2 + y^2)
void REALNAME(Radius_old)(REAL* num, const REAL* x, const REAL* y);
EXP REALNAME(RadiusExt)(REAL* num, const REAL* x, EXP x_exp, const REAL* y, EXP y_exp);
void REALNAME(Radius)(REAL* num, const REAL* x, const REAL* y);

// convert Cartesian coordinates to polar (result angle is in range 0..2*PI)
void REALNAME(Cart2Pol_old)(REAL* angle, REAL* radius, const REAL* x, const REAL* y);
void REALNAME(Cart2PolExt)(REAL* angle, EXP* angle_exp, REAL* radius, EXP* radius_exp,
		const REAL* x, EXP x_exp, const REAL* y, EXP y_exp);
void REALNAME(Cart2Pol)(REAL* angle, REAL* radius, const REAL* x, const REAL* y);

// convert polar coordinates to Cartesian
void REALNAME(Pol2Cart_old)(REAL* x, REAL* y, const REAL* angle, const REAL* radius);
void REALNAME(Pol2CartExt)(REAL* x, EXP* x_exp, REAL* y, EXP* y_exp, 
		const REAL* angle, EXP angle_exp, const REAL* radius, EXP radius_exp);
void REALNAME(Pol2Cart)(REAL* x, REAL* y, const REAL* angle, const REAL* radius);

// arcus cotangent (result is in range -PI/2..+PI/2)
//  Function uses 7 temporary numbers in the stack.
void REALNAME(ACoTanFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(ACoTan)(REAL* num) { REALNAME(ACoTanFrom)(num, num); }

EXP REALNAME(ACoTanFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(ACoTanExt)(REAL* num, EXP exp) { return REALNAME(ACoTanFromExt)(num, num, exp); }

// trigonometric test function, The Forensics Evaluation Algorithm
//  Check precision by formula arcsin(arccos(arctan(tan(cos(sin(9)))))) ... in degrees
//  Returns number of equal bits and result difference from number "9" (should be 0).
//  http://www.datamath.org/Forensics.htm
//  Function uses 9 temporary numbers in the stack.
//  Number_of_correct_digits = (number_of_correct_bits - 0.5) * 0.30103
// Results: number_of_correct_digits time_on_R-Pico (loops):
//  real16 0dig 1ms (19), real32 1dig 1ms (32), real48 5dig 2ms (43), real64 10dig 2ms (57),
//  real80 13dig 4ms (63), real96 19dig 4ms (75), real128 29dig 6ms (99), real160 38dig 8ms (119),
//  real192 46dig 12ms (138), real256 65dig 20ms (178), real384 104dig 49ms (258), real512 142dig 93ms (334),
//  real768 218dig 248ms (484), real1024 294dig 511ms (630), real1536 447dig 1.4s (917), real2048 601dig 3s (1198)
//  real3072 909dig 10s (1752), real4096 1218dig 24s (2297)
int REALNAME(Test9_old)(REAL* num); // normal precision
// Results: number_of_correct_digits time_on_R-Pico (loops):
//  real16 0dig 1ms (19), real32 2dig 1ms (41), real48 6dig 2ms (52), real64 10dig 2ms (63),
//  real80 14dig 4ms (75), real96 20dig 3ms (87), real128 29dig 5ms (110), real160 38dig 7ms (130),
//  real192 48dig 10ms (151), real256 66dig 17ms (191), real384 104dig 42ms (272), real512 143dig 81ms (349),
//  real768 218dig 223ms (500), real1024 294dig 469ms (646), real1536 448dig 1.3s (933), real2048 602dig 3s (1215)
//  real3072 910dig 9s (1770), real4096 1219dig 22s (2312)
int REALNAME(Test9)(REAL* num); // normal precision
// Results, number of correct digits:
//  real16 0dig 1ms (16), real32 4dig 1ms (41), real48 8dig 2ms (52), real64 13dig 2ms (75),
//  real80 18dig 3ms (75), real96 23dig 3ms (87), real128 32dig 5ms (110), real160 42dig 7ms (130),
//  real192 51dig 10ms (151), real256 71dig 17ms (191), real384 109dig 41ms (272), real512 148dig 81ms (349),
//  real768 225dig 222ms (500), real1024 302dig 466ms (646), real1536 456dig 1.3s (933), real2048 609dig 3s (1215)
//  real3072 917dig 9s (1770), real4096 1219dig 22s (2312)
int REALNAME(Test9Ext)(REAL* num); // extended precision

// hyperbolic sine
//  Function uses 5 temporary numbers in the stack.
void REALNAME(SinHFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(SinH_old)(REAL* num) { REALNAME(SinHFrom_old)(num, num); }

EXP REALNAME(SinHFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(SinHExt)(REAL* num, EXP exp) { return REALNAME(SinHFromExt)(num, num, exp); }

void REALNAME(SinHFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(SinH)(REAL* num) { REALNAME(SinHFrom)(num, num); }

// hyperbolic cosine
//  Function uses 5 temporary numbers in the stack.
void REALNAME(CosHFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(CosH_old)(REAL* num) { REALNAME(CosHFrom_old)(num, num); }

EXP REALNAME(CosHFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(CosHExt)(REAL* num, EXP exp) { return REALNAME(CosHFromExt)(num, num, exp); }

void REALNAME(CosHFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(CosH)(REAL* num) { REALNAME(CosHFrom)(num, num); }

// hyperbolic tangent
//  Function uses 5 temporary numbers in the stack.
void REALNAME(TanHFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(TanH_old)(REAL* num) { REALNAME(TanHFrom_old)(num, num); }

EXP REALNAME(TanHFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(TanHExt)(REAL* num, EXP exp) { return REALNAME(TanHFromExt)(num, num, exp); }

void REALNAME(TanHFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(TanH)(REAL* num) { REALNAME(TanHFrom)(num, num); }

// hyperbolic cotangent
//  Function uses 5 temporary numbers in the stack.
void REALNAME(CoTanHFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(CoTanH_old)(REAL* num) { REALNAME(CoTanHFrom_old)(num, num); }

EXP REALNAME(CoTanHFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(CoTanHExt)(REAL* num, EXP exp) { return REALNAME(CoTanHFromExt)(num, num, exp); }

void REALNAME(CoTanHFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(CoTanH)(REAL* num) { REALNAME(CoTanHFrom)(num, num); }

// hyperbolic secant
//  Function uses 5 temporary numbers in the stack.
void REALNAME(SecHFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(SecH_old)(REAL* num) { REALNAME(SecHFrom_old)(num, num); }

EXP REALNAME(SecHFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(SecHExt)(REAL* num, EXP exp) { return REALNAME(SecHFromExt)(num, num, exp); }

void REALNAME(SecHFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(SecH)(REAL* num) { REALNAME(SecHFrom)(num, num); }

// hyperbolic cosecant
//  Function uses 5 temporary numbers in the stack.
void REALNAME(CscHFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(CscH_old)(REAL* num) { REALNAME(CscHFrom_old)(num, num); }

EXP REALNAME(CscHFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(CscHExt)(REAL* num, EXP exp) { return REALNAME(CscHFromExt)(num, num, exp); }

void REALNAME(CscHFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(CscH)(REAL* num) { REALNAME(CscHFrom)(num, num); }

// areasine, inverse hyperbolic sine
//  Function uses 6 temporary numbers in the stack.
void REALNAME(ArSinHFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(ArSinH_old)(REAL* num) { REALNAME(ArSinHFrom_old)(num, num); }

EXP REALNAME(ArSinHFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(ArSinHExt)(REAL* num, EXP exp) { return REALNAME(ArSinHFromExt)(num, num, exp); }

void REALNAME(ArSinHFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(ArSinH)(REAL* num) { REALNAME(ArSinHFrom)(num, num); }

// areacosine, inverse hyperbolic cosine
//  Function uses 6 temporary numbers in the stack.
void REALNAME(ArCosHFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(ArCosH_old)(REAL* num) { REALNAME(ArCosHFrom_old)(num, num); }

EXP REALNAME(ArCosHFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(ArCosHExt)(REAL* num, EXP exp) { return REALNAME(ArCosHFromExt)(num, num, exp); }

void REALNAME(ArCosHFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(ArCosH)(REAL* num) { REALNAME(ArCosHFrom)(num, num); }

// areatangent, inverse hyperbolic tangent
//  Function uses 6 temporary numbers in the stack.
void REALNAME(ArTanHFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(ArTanH_old)(REAL* num) { REALNAME(ArTanHFrom_old)(num, num); }

EXP REALNAME(ArTanHFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(ArTanHExt)(REAL* num, EXP exp) { return REALNAME(ArTanHFromExt)(num, num, exp); }

void REALNAME(ArTanHFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(ArTanH)(REAL* num) { REALNAME(ArTanHFrom)(num, num); }

// areacotangent, inverse hyperbolic cotangent
//  Function uses 6 temporary numbers in the stack.
void REALNAME(ArCoTanHFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(ArCoTanH_old)(REAL* num) { REALNAME(ArCoTanHFrom_old)(num, num); }

EXP REALNAME(ArCoTanHFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(ArCoTanHExt)(REAL* num, EXP exp) { return REALNAME(ArCoTanHFromExt)(num, num, exp); }

void REALNAME(ArCoTanHFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(ArCoTanH)(REAL* num) { REALNAME(ArCoTanHFrom)(num, num); }

// areasecant, inverse hyperbolic secant
//  Function uses 6 temporary numbers in the stack.
void REALNAME(ArSecHFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(ArSecH_old)(REAL* num) { REALNAME(ArSecHFrom_old)(num, num); }

EXP REALNAME(ArSecHFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(ArSecHExt)(REAL* num, EXP exp) { return REALNAME(ArSecHFromExt)(num, num, exp); }

void REALNAME(ArSecHFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(ArSecH)(REAL* num) { REALNAME(ArSecHFrom)(num, num); }

// areacosecant, inverse hyperbolic cosecant
//  Function uses 6 temporary numbers in the stack.
void REALNAME(ArCscHFrom_old)(REAL* num, const REAL* src);
INLINE void REALNAME(ArCscH_old)(REAL* num) { REALNAME(ArCscHFrom_old)(num, num); }

EXP REALNAME(ArCscHFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(ArCscHExt)(REAL* num, EXP exp) { return REALNAME(ArCscHFromExt)(num, num, exp); }

void REALNAME(ArCscHFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(ArCscH)(REAL* num) { REALNAME(ArCscHFrom)(num, num); }

// generate random number in range 0<= .. <1 (resolution max. 64 bits)
void REALNAME(Rnd)(REAL* num);
EXP REALNAME(RndExt)(REAL* num);

// random number in range 0<= .. <num (resolution max. 64 bits)
void REALNAME(RndMaxFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(RndMax)(REAL* num) { REALNAME(RndMaxFrom)(num, num); }

EXP REALNAME(RndMaxFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(RndMaxExt)(REAL* num, EXP exp) { return REALNAME(RndMaxFromExt)(num, num, exp); }

// Chebyshev callback functions
#define CHEBCB_LN	0	// Ln()
#define CHEBCB_EXP	1	// Exp()
#define CHEBCB_SIN	2	// Sin()
#define CHEBCB_ASIN	3	// ASin()
#define CHEBCB_ATAN	4	// ATan()
#define CHEBCB_SQRT	5	// Sqrt()

// typedef callback function to be approximated by Chebyshev polynomial
//  Input number is in range -1 .. +1
typedef void (REALNAME(chebfnc_cb))(REAL* num);
typedef EXP (REALNAME(chebfnc_cbext))(REAL* num, EXP exp);

// typedef callback function to indicate Chebyshev progress, in 0..1000 per mille)
typedef void (*chebprogress_cb)(int permille);

// Chebyshev callback functions (input number is in range -1 .. +1)
void REALNAME(ChebCB_Ln)(REAL* num); // Ln()
void REALNAME(ChebCB_Exp)(REAL* num); // Exp()
void REALNAME(ChebCB_Sin)(REAL* num); // Sin()
void REALNAME(ChebCB_ASin)(REAL* num); // ASin()
void REALNAME(ChebCB_ATan)(REAL* num); // ATan()
void REALNAME(ChebCB_Sqrt)(REAL* num); // Sqrt()

EXP REALNAME(ChebCB_LnExt)(REAL* num, EXP exp); // Ln()
EXP REALNAME(ChebCB_ExpExt)(REAL* num, EXP exp); // Exp()
EXP REALNAME(ChebCB_SinExt)(REAL* num, EXP exp); // Sin()
EXP REALNAME(ChebCB_ASinExt)(REAL* num, EXP exp); // ASin()
EXP REALNAME(ChebCB_ATanExt)(REAL* num, EXP exp); // ATan()
EXP REALNAME(ChebCB_SqrtExt)(REAL* num, EXP exp); // Sqrt()

// Calculate coefficients of Chebyshev approximation
// Requires 2*num REAL numbers to be temporary allocated using malloc function.
//  fnc = callback function to be approximated by Chebyshev polynomial
//  num = number of coefficients (=order of Chebyshev polynomial, min. 2)
//  poly = pointer to array of 'num' polynomial coefficients
//	cb = progress callback function (NULL = none)
void REALNAME(ChebCoef)(REALNAME(chebfnc_cb) fnc, int num, REAL* poly, chebprogress_cb cb);

// Calculate coefficients of Chebyshev approximation in extended precision
// Requires 2*num REAL numbers to be temporary allocated using malloc function.
//  fnc = callback function to be approximated by Chebyshev polynomial
//  num = number of coefficients (=order of Chebyshev polynomial, min. 2)
//  poly = pointer to array of 'num' polynomial coefficients, mantissas of extended format
//  poly_exp = pointer to array of 'num' polynomial coefficients, exponents of extended format
//	cb = progress callback function (NULL = none)
void REALNAME(ChebCoefExt)(REALNAME(chebfnc_cbext) fnc, int num, REAL* poly, EXP* poly_exp, chebprogress_cb cb);

// Calculate coefficients of Chebyshev approximation - precise, using reference REAL numbers
// Requires 3*num REALREF numbers to be temporary allocated using malloc function.
//  fnc = index of callback function CHEBCB_*
//  num = number of coefficients (=order of Chebyshev polynomial, min. 2)
//  poly = pointer to array of polynomial coefficients
//	cb = progress callback function (NULL = none)
void REALNAME(ChebCoefRef)(int fnc, int num, REAL* poly, chebprogress_cb cb);

// Calculate coefficients of Chebyshev approximation - precise, using reference REAL numbers and extended destination numbers
// Requires 3*num REALREF numbers to be temporary allocated using malloc function.
//  fnc = index of callback function CHEBCB_*
//  num = number of coefficients (=order of Chebyshev polynomial, min. 2)
//  poly = pointer to array of polynomial coefficients, mantissas of extended format
//  poly_exp = pointer to array of polynomial coefficients, exponents of extended format
//	cb = progress callback function (NULL = none)
void REALNAME(ChebCoefRefExt)(int fnc, int num, REAL* poly, EXP* poly_exp, chebprogress_cb cb);
void REALNAME(ChebCoefRefExt_old)(int fnc, int num, REAL* poly, EXP* poly_exp, chebprogress_cb cb);

// Calculate value of Chebyshev approximation
//  num = number of coefficients (=order of Chebyshev polynomial)
//  poly = pointer to array of polynomial coefficients
// Input number must be in range -1 .. +1
// Do not use Chebyshev approximation with results near 0, it could be inaccurate.
void REALNAME(Chebyshev)(REAL* num, int n, const REAL* poly);
EXP REALNAME(ChebyshevExt)(REAL* num, EXP exp, int n, const REALEXT* poly);
EXP REALNAME(ChebyshevExt2)(REAL* num, EXP exp, int n, const REAL* poly, const EXP* poly_exp);

// get Bernoulli table number in decimal form (index = 0..BernMax() )
void REALNAME(BernDec)(REAL* num, int inx);

// get Bernoulli table number - numerator (index = 0..BernMax() )
void REALNAME(BernNum)(REAL* num, int inx);

// get Bernoulli table number - denominator (index = 0..BernMax() )
void REALNAME(BernDen)(REAL* num, int inx);

// integer factorial (number is multiplied repeatedly)
//  Returns max. reached number (can be used to detect maximum allowed value)
//  Function uses 3 temporary numbers in the stack.
//  Set n=(BASE)-1 to calculate max. supported integral.
// Max. allowed values:
//  real16 8, real32 34, real48 98, real64 170
//  real96 536, real128 1754, real160 3210, real192 5910
//  real256 20366, real384 71421, real512 254016, real768 913846, real1024 3318996
//  real1536 23310032, real2048 23310032
// Max. allowed value takes on R-Pico:
//  real16 82 us, real32 190 us, real48 986 us, real64 1 ms
//  real96 6 ms, real128 28 ms, real160 70 ms, real192 165 ms
//  real256 886 ms, real384 6 s, real512 36 s, real768 4.6 min, real1024 29 min,
//  real1536 3 hours, real2048 20 hours
BASE REALNAME(FactInt)(REAL* num, BASE n);
EXP REALNAME(FactIntExt)(REAL* num, BASE n);

// non-integer factorial linear approximation
// Max. allowed values:
//  real16 8, real32 34, real48 98, real64 170
//  real96 536, real128 1754, real160 3210, real192 5910
//  real256 20366, real384 71421, real512 254016,real768 913846, real1024 3318996
//  real1536 23310032, real2048 23310032
// Value "1" which will use max. work-around correction on R-Pico:
//  real16 405 us, real32 514 us, real48 1 ms, real64 1.1 ms,
//  real80 2.3 ms, real96 2.4 ms, real128 4 ms, real160 7 ms,
//  real192 11 ms, real256 23 ms, real384 65 ms, real512 144 ms,
//  real768 440 ms, real1024 1 s, real1536 3.2 s, real2048 7 s,
//  real3072 25 s
// Max. allowed value takes on R-Pico:
//  real16 31 us, real32 139 us, real48 894 us, real64 739 us,
//  real80 2 ms, real96 2 ms, real128 3.6 ms, real160 6 ms,
//  real192 10 ms, real256 22 ms, real384 61 ms, real512 132 ms,
//  real768 427 ms, real1024 1 s,  real1536 3.3 s, real2048 8 s,
//  real3072 25 s
EXP REALNAME(FactLinFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(FactLinExt)(REAL* num, EXP exp) { return REALNAME(FactLinFromExt)(num, num, exp); }

void REALNAME(FactLinFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(FactLin)(REAL* num) { REALNAME(FactLinFrom)(num, num); }

// factorial (auto select best method)
// Max. value below "threshold" calculated as integer on R-Pico:
//  real16 125 us (8), real32 235 us (34), real48 1 ms (98), real64 1.2 ms (159),
//  real80 3 ms (199), real96 3 ms (239), real128 5 ms (319), real160 9 ms (399),
//  real192 14 ms (479), real256 27 ms (639), real384 79 ms (959), real512 175 ms (1279),
//  real768 557 ms (1919), real1024 1.3 s (2559), real1536 4 s (3839), real2048 10 s (5119),
//  real3072 38 s (7679)
EXP REALNAME(FactFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(FactExt)(REAL* num, EXP exp) { return REALNAME(FactFromExt)(num, num, exp); }

void REALNAME(FactFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(Fact)(REAL* num) { REALNAME(FactFrom)(num, num); }

// natural logarithm of factorial (using approximation)
EXP REALNAME(FactLnFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(FactLnExt)(REAL* num, EXP exp) { return REALNAME(FactLnFromExt)(num, num, exp); }

void REALNAME(FactLnFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(FactLn)(REAL* num) { REALNAME(FactLnFrom)(num, num); }

// decimal logarithm of factorial (using approximation)
EXP REALNAME(FactLogFromExt)(REAL* num, const REAL* src, EXP exp);
INLINE EXP REALNAME(FactLogExt)(REAL* num, EXP exp) { return REALNAME(FactLogFromExt)(num, num, exp); }

void REALNAME(FactLogFrom)(REAL* num, const REAL* src);
INLINE void REALNAME(FactLog)(REAL* num) { REALNAME(FactLogFrom)(num, num); }

// Encode number from ASCIIZ text (decimal point: '.', ',' or B7)
// Global flags:
//  Base ... current numeric radix base BASE_*
void REALNAME(FromText)(REAL* num, char* txt);

// Decode number to text buffer
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
int REALNAME(ToText)(const REAL* num, char* buf, int size);

#ifdef __cplusplus
}
#endif

#include "real_undef.h"		// undefine

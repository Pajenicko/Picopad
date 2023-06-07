
// ****************************************************************************
//                                 
//                          Real numbers - define
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#define LOG10_2 0.3010299956639812	// log10(2) ... number_of_digits = number_of_bits * LOG10_2

// base segment configuration
#if BASE_BITS == 16					// u16

#define BASE		u16				// type of mantissa base entry
#define BASES		s16				// type of mantissa base entry, signed
#define BASE_LAST	(BASE)0x8000	// mask of highest bit
#define BASE_MASK	(BASE)0x7fff	// mask of valid mantissa bits
#define BASEDBL		u32				// double base entry

#elif BASE_BITS == 32				// u32

#define BASE		u32				// type of mantissa base entry
#define BASES		s32				// type of mantissa base entry, signed
#define BASE_LAST	(BASE)0x80000000UL	// mask of highest bit
#define BASE_MASK	(BASE)0x7fffffffUL	// mask of valid mantissa bits
#define BASEDBL		u64				// double base entry

#else
#error "Invalid BASE_BITS! (use 16 or 32)"
#endif

// extended exponent
#define EXP			u32				// extended exponent unsigned
#define EXPS		s32				// extended exponent signed
#define EXPEXT_BITS	31				// number of bits of extended exponent

// real number configuration
#define BASE_MAX	((BASE)-1)			// base max value
#define BASE_BYTES	(BASE_BITS/8)		// number of bytes of base segment
#define REAL_BYTES	(BASE_BYTES*BASE_NUM) 	// number of bytes of the number
#define REAL_BITS	(REAL_BYTES*8)			// number of bits of the number
#define FACT_COEFF	REAL_BYTES			// number of factorial coefficients ... (REAL_BYTES*7/8) or more is OK
#define FACT_THRES	(REAL_BYTES*20)		// threshold to use linear factorial instead of integer factorial

#if (REAL_BITS > MAXFACT_COEFF) && !defined(GENCONST)	// max. supported linear factorial
#undef FACT_COEFF
#endif

// mantissa
#define MANT_LAST_BITS	(BASE_BITS-EXP_BITS-1)		// number of bits of mantissa in last segment
#if (MANT_LAST_BITS < 0) || (EXP_BITS > 30)
#error "EXP_BITS can be max. BASE_BITS-1 and max. 30!"
#endif
#define MANT_LAST_MASK	(((BASE)1<<MANT_LAST_BITS)-1)	// mask of mantissa in last segment
#define MANT_BITS	(REAL_BITS-EXP_BITS-1)		// number of bits of mantissa

#define MANT_DIG_DEC_D	((MANT_BITS+1)*LOG10_2)	// max. number of digits per mantissa in DEC format
#define MANT_DIG_DEC	(int)((MANT_BITS+1)*LOG10_2)	// max. number of digits per mantissa in DEC format
#define MANT_DIG_BIN	(int)(MANT_BITS+1)		// max. number of digits per mantissa in BIN format
#define MANT_DIG_OCT	(int)((MANT_BITS+1)/3)		// max. number of digits per mantissa in OCT format
#define MANT_DIG_HEX	(int)((MANT_BITS+1)/4)		// max. number of digits per mantissa in HEX format

#define MANT_DIG_DECEXT_D	(REAL_BITS*LOG10_2)	// max. number of digits per mantissa in DEC format in extended precision
#define MANT_DIG_DECEXT	(int)(REAL_BITS*LOG10_2)	// max. number of digits per mantissa in DEC format in extended precision

// max. bit difference of exponents of loops
#define REAL_BITSLOOP MANT_BITS
#define REAL_BITSLOOPEXT REAL_BITS

// exponent, type 'BASE'
#define EXP_SHIFT	MANT_LAST_BITS			// shift of exponent
#define EXP_MASK	(((BASE)1<<EXP_BITS)-1)		// mask of exponent
#define EXP_BIAS	(((BASE)1<<(EXP_BITS-1))-1)	// exponent bias
#define EXP_0		0					// exponent of value "0"
#define EXP_1		EXP_BIAS			// exponent of value "1"
#define EXP_MAX		EXP_MASK			// maximal exponent (infinity)
#define EXP_INF		EXP_MAX				// exponent of value "infinity"
#define REAL_DECEXP	(EXP_BITS-2)		// number of square decimal exponents

#define EXP_RANGE_D	(EXP_BIAS*LOG10_2)	// exponent range (min. and max. value of decimal exponent)
#define EXP_RANGE	(BASE)(EXP_BIAS*LOG10_2)	// exponent range (min. and max. value of decimal exponent)
#define EXP_DIG		(int)((EXP_BITS+0.5)*LOG10_2)	// max. number of digits per exponent

// extended exponent, type 'EXP' (1 bit in highest bit is reserved for sign)
#define EXPEXT_SIGN	((EXP)1<<EXPEXT_BITS)	// sign in packed extended exponent
#define EXPEXT_MASK	(((EXP)1<<EXPEXT_BITS)-1)	// mask of extended exponent (= 0x7FFFFFFF)
#define EXPEXT_BIAS	(((EXP)1<<(EXPEXT_BITS-1))-1)	// extended exponent bias (= 0x3FFFFFFF)
#define EXPEXT_0	0					// exponent of value 0
#define EXPEXT_1	EXPEXT_BIAS			// exponent of value "1"
#define EXPEXT_MAX	EXPEXT_MASK			// maximal exponent (infinity)
#define EXPEXT_INF	EXPEXT_MAX			// exponent of value "infinity"

// Limiting the usage of large Chebyshev tables
#if REAL_BITS > MAXCHEB_LN
#undef CHEB_LN		// number of Chebyshev coefficients for Ln()
#endif

#if REAL_BITS > MAXCHEB_EXP
#undef CHEB_EXP		// number of Chebyshev coefficients for Exp()
#endif

#if REAL_BITS > MAXCHEB_SIN
#undef CHEB_SIN		// number of Chebyshev coefficients for Sin()
#endif

#if REAL_BITS > MAXCHEB_ASIN
#undef CHEB_ASIN	// number of Chebyshev coefficients for ASin()
#endif

#if REAL_BITS > MAXCHEB_ATAN
#undef CHEB_ATAN	// number of Chebyshev coefficients for ATan()
#endif

#if REAL_BITS > MAXCHEB_SQRT
#undef CHEB_SQRT	// number of Chebyshev coefficients for Sqrt()
#endif

// Cordic
#define CORD_ATAN_FNC(n) ((n)/3+2)	// function to get number of atan coefficients for Cordic

#if REAL_BITS <= MAXCORD_ATAN
#define CORD_ATAN	CORD_ATAN_FNC(REAL_BITS) // number of atan coefficients for Cordic
										// Note: Second half of table is equal to angle.
#endif

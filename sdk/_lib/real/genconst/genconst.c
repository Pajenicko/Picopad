
// ****************************************************************************
//
//                         Generate constants
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "include.h"

// How to upscale to number with higher precision:
//   Table of Bernoulli numbers in bernoulli.c (size BIGINT_BERN_NUM) must
//   be >= than size of bytes of max. used number. If not, generate bigger
//   tables using "bernoulli" program (increase BIGINT_BERN_NUM in bigint.h).
// 1) duplicate file const????.h with max. number to new name and add to the project
// 2) add new definition to real.h
// 3) add new USE_REAL???? to config.h
// 4) update MAXCHEB_* and MAXFACT_COEFF in config.h to new max. number
// 5) add definition of new number to ExportConst() in genconst.c
// 6) add new number tmp???? to "temporary numbers" in genconst.c
// 7) add new number to ChebGen(), GenImport() and GenImportExt() in genconst.c
// 8) (1st GENERATE) compile and generate new constants files (CACHE_* switches can be all on '1')
// 9) replace new generated files const????.h to project
// 10) change definition of "setup template number" (here below) to new number
// 11) (2nd GENERATE) compile and generate new constants files (CACHE_* switches can be all on '1')
// 12) replace new generated files const????.h to project
// 13) (3rd GENERATE) compile and generate new constants files (CACHE_* switches can be all on '1')
// 14) replace new generated files const????.h to project
// 15) if you would now compile and generate new constant files, they should be the same as those in project (or replace them and generate again if needed)

// setup template number (must be higher or same as max. generated number)
#define REAL			real4096	// number type
#define BASE_BITS		32			// number of bits of base entry
#define BASE_NUM		128			// number of base entries
#define EXP_BITS		30			// number of exponent bits (max. 30)
#define REALNAME(x)		Real4096 ## x	// name of functions
#define EXP			u32				// extended exponent unsigned

#define CACHE_COEF		1	// 1=get factorial coefficients from cache
#define CACHE_CHEB_LN	1	// 1=get Chebyshev coefficients Ln() from cache
#define CACHE_CHEB_EXP	1	// 1=get Chebyshev coefficients Exp() from cache
#define CACHE_CHEB_SIN	1	// 1=get Chebyshev coefficients Sin() from cache
#define CACHE_CHEB_ASIN	1	// 1=get Chebyshev coefficients ASin() from cache
#define CACHE_CHEB_ATAN	1	// 1=get Chebyshev coefficients ATan() from cache
#define CACHE_CHEB_SQRT	0	// 1=get Chebyshev coefficients Sqrt() from cache

#include "../real_def.h"			// define

// base constants
REAL TempConst0;			// 0
REAL TempConst1;			// 1
REAL TempConstM1;			// -1
REAL TempConst2;			// 2
REAL TempConst3;			// 3
REAL TempConst05;			// 0.5
REAL TempConstM05;			// -0.5
REAL TempConst075;			// 0.75
REAL TempConst83;			// 8/3
REAL TempConst10;			// 10
REAL TempConst100;			// 100
REAL TempConstExpMax0;		// exp(x) max
REAL TempConstExpMin0;		// exp(x) min
REAL TempConstExpMax;		// exp(x) max
REAL TempConstExpMin;		// exp(x) min
REAL TempConst01;			// 0.1 (1e-1)
REAL TempConst001;			// 0.01 (1e-2)
REAL TempConst1eM4;			// 0.0001 (1e-4)
REAL TempConst1eM8;			// 0.00000001 (1e-8)
REAL TempConstLn2;			// ln(2)
REAL TempConstRLn2;			// 1/ln(2)
REAL TempConstLn10;			// ln(10)
REAL TempConstRLn10;		// 1/ln(10)
REAL TempConstLog2;			// log(2)
REAL TempConstRLog2;		// 1/log(2)
REAL TempConstEul;			// Eul
REAL TempConstPi05;			// pi/2
REAL TempConstPi;			// pi
REAL TempConstPi2;			// pi*2
REAL TempConstRPi2;			// 1/(pi*2)
REAL TempConstLnPi22;		// ln(pi*2)/2
REAL TempConst180Pi;		// 180/pi
REAL TempConstPi180;		// pi/180
REAL TempConst200Pi;		// 200/pi
REAL TempConstPi200;		// pi/200
REAL TempConstPhi;			// phi (sectio aurea = (1 + sqrt(5))/2)
REAL TempConstSqrt2;		// sqrt(2)
REAL TempConstRSqrt2;		// 1/sqrt(2)

// decimal exponents (index REAL_DECEXP = number '1')
// Exponent is in range -2^(REAL_DECEXP-1)..+2^(REAL_DECEXP-1)
REAL TempConstExp[REAL_DECEXP*2+1];

// linear factorial
#ifdef FACT_COEFF
REAL TempConstFact[FACT_COEFF]; // factorial coefficients
#endif

// generate template constants
void GenTempConst()
{
	int i, j;
	REAL* g;

#if !CACHE_COEF
	REAL *s, temp, temp2, *mm, *r, a, b, c;
	int k, kk, n;
#endif

	fprintf(stderr, "Generating base constants: ");

	// 0
	REALNAME(Set0)(&TempConst0);
	fprintf(stderr, "0 ");

	// 1
	REALNAME(Set1)(&TempConst1);
	fprintf(stderr, "1 ");

	// -1
	REALNAME(SetM1)(&TempConstM1);
	fprintf(stderr, "-1 ");

	// 2
	REALNAME(Set2)(&TempConst2);
	fprintf(stderr, "2 ");

	// 3
	REALNAME(SetUInt)(&TempConst3, 3);
	fprintf(stderr, "3 ");

	// 0.5
	REALNAME(Set05)(&TempConst05);
	fprintf(stderr, "0.5 ");

	// -0.5
	REALNAME(SetM05)(&TempConstM05);
	fprintf(stderr, "-0.5 ");

	// 0.75 (=3/4)
	REALNAME(SetUInt)(&TempConst075, 3);
	REALNAME(Div2)(&TempConst075);
	REALNAME(Div2)(&TempConst075);
	fprintf(stderr, "0.75 ");

	// 8/3
	REALNAME(SetUInt)(&TempConst83, 8);
	REALNAME(Div)(&TempConst83, &TempConst83, &TempConst3);
	fprintf(stderr, "8/3 ");

	// 10
	REALNAME(SetUInt)(&TempConst10, 10);
	fprintf(stderr, "10 ");

	// 100
	REALNAME(SetUInt)(&TempConst100, 100);
	fprintf(stderr, "100 ");

	// prepare exponent max and min
	// exp(x) max = EXP_INF*ln(2)+1 ... (used in Exp() to check range, not needed precise value)
	// exp(x) min = EXP_UNDER*ln(2)-1 ... (used in Exp() to check range, not needed precise value)
	REALNAME(FromDouble)(&TempConstExpMax0, (double)((1ULL << (EXP_BITS-1))-1)*log(2.0) + 1);
	REALNAME(FromDouble)(&TempConstExpMin0, -(double)((1ULL << (EXP_BITS-1))-1)*log(2.0) - 1);

	// 0.1 (1e-1)
	REALNAME(RecFrom)(&TempConst01, &TempConst10);
	fprintf(stderr, "0.1 ");

	// 0.01 (1e-2)
	REALNAME(RecFrom)(&TempConst001, &TempConst100);
	fprintf(stderr, "0.01 ");

	// 0.0001 (1e-4)
	REALNAME(SqrFrom)(&TempConst1eM4, &TempConst001);
	fprintf(stderr, "1e-4 ");

	// 0.00000001 (1e-8)
	REALNAME(SqrFrom)(&TempConst1eM8, &TempConst1eM4);
	fprintf(stderr, "1e-8 ");

	// ln(2)
	REALNAME(Ln2)(&TempConstLn2);
	fprintf(stderr, "ln2 ");

	// 1/ln(2)
	REALNAME(RecFrom)(&TempConstRLn2, &TempConstLn2);
	fprintf(stderr, "1/ln2 ");

	// ln(10)
	REALNAME(LnFrom)(&TempConstLn10, &TempConst10);
	fprintf(stderr, "ln10 ");

	// 1/ln(10)
	REALNAME(RecFrom)(&TempConstRLn10, &TempConstLn10);
	fprintf(stderr, "1/ln10 ");

	// log(2) (= ln(2)/ln(10)
	REALNAME(Mul)(&TempConstLog2, &TempConstLn2, &TempConstRLn10);
	fprintf(stderr, "log2 ");

	// 1/log(2)
	REALNAME(RecFrom)(&TempConstRLog2, &TempConstLog2);
	fprintf(stderr, "1/log2 ");

	// Eul (= exp(1))
	REALNAME(ExpFrom)(&TempConstEul, &TempConst1);
	fprintf(stderr, "eul ");

	// pi
	REALNAME(Pi)(&TempConstPi);
	fprintf(stderr, "pi ");

	// pi/2
	REALNAME(DivU16)(&TempConstPi05, &TempConstPi, 2);
	fprintf(stderr, "pi/2 ");

	// pi*2
	REALNAME(MulUInt)(&TempConstPi2, &TempConstPi, 2);
	fprintf(stderr, "pi/2 ");

	// 1/(pi*2)
	REALNAME(RecFrom)(&TempConstRPi2, &TempConstPi2);
	fprintf(stderr, "1/2pi ");

	// ln(pi*2)/2
	REALNAME(LnFrom)(&TempConstLnPi22, &TempConstPi2);
	REALNAME(Div2)(&TempConstLnPi22);
	fprintf(stderr, "ln(2pi)/2 ");

	// 180/pi
	REALNAME(SetUInt)(&TempConst180Pi, 180);
	REALNAME(Div)(&TempConst180Pi, &TempConst180Pi, &TempConstPi);
	fprintf(stderr, "180/pi ");

	// pi/180
	REALNAME(RecFrom)(&TempConstPi180, &TempConst180Pi);
	fprintf(stderr, "pi/180 ");

	// 200/pi
	REALNAME(SetUInt)(&TempConst200Pi, 200);
	REALNAME(Div)(&TempConst200Pi, &TempConst200Pi, &TempConstPi);
	fprintf(stderr, "200/pi ");

	// pi/200
	REALNAME(RecFrom)(&TempConstPi200, &TempConst200Pi);
	fprintf(stderr, "pi/200 ");

	// phi (sectio aurea = (1 + sqrt(5))/2)
	REALNAME(SetUInt)(&TempConstPhi, 5);
	REALNAME(Sqrt)(&TempConstPhi);
	REALNAME(Inc)(&TempConstPhi);
	REALNAME(Div2)(&TempConstPhi);
	fprintf(stderr, "phi ");

	// sqrt(2)
	REALNAME(Sqrt_NewtonFrom)(&TempConstSqrt2, &TempConst2);
	fprintf(stderr, "sqrt2 ");

	// 1/sqrt(2)
	REALNAME(RecFrom)(&TempConstRSqrt2, &TempConstSqrt2);
	fprintf(stderr, "1/sqrt2 ");

	fprintf(stderr, "...done\nGenerating decimal exponents: ");

	// decimal exponents
	{
		g = TempConstExp;
		REALNAME(Copy)(&g[REAL_DECEXP-1], &TempConst01);
		REALNAME(Set1)(&g[REAL_DECEXP]);
		REALNAME(Copy)(&g[REAL_DECEXP+1], &TempConst10);
		j = REAL_DECEXP-2;
		for (i = REAL_DECEXP+2; i < REAL_DECEXP*2+1; i++)
		{
			REALNAME(SqrFrom)(&g[i], &g[i-1]);
			REALNAME(RecFrom)(&g[j], &g[i]);
			j--;
		}
	}

	// factorial coefficients
	// Computes Rutishauser's Quotient-Difference (QD-) algorithm

#if CACHE_COEF		// get factorial coefficients from cache
	fprintf(stderr, "done\nGenerating factorial coefficients: ");
	for (i = 0; i < FACT_COEFF; i++)
	{
		REALNAME(Copy)(&TempConstFact[i], &REALNAME(ConstFact)[i]);
	}
#else // CACHE_COEF


	fprintf(stderr, "done\nGenerating factorial coefficients: Bernoulli numbers ");

	s = (REAL*)malloc(FACT_COEFF*sizeof(REAL)); // result even coefficients with weight
	for (k = 0; k < FACT_COEFF; k++)
	{
		REALNAME(ImportBigIntC)(&temp, &bern_num[k]);
		REALNAME(ImportBigIntC)(&temp2, &bern_den[k]);
		REALNAME(Div)(&s[k], &temp, &temp2);

//		REALNAME(Copy)(&TempConstBern[k], &s[k]);
	
		kk = (2*k+1)*(2*k+2);
		if ((k & 1) != 0) kk = -kk;
		REALNAME(SetSInt)(&temp, kk);
		REALNAME(Div)(&s[k], &s[k], &temp);
	}

	mm = (REAL*)malloc(FACT_COEFF*FACT_COEFF*sizeof(REAL));
	r = (REAL*)malloc(FACT_COEFF*sizeof(REAL));

	for (n = 0; n < FACT_COEFF; n++) REALNAME(Set0)(&mm[n+0*FACT_COEFF]);
	
	for (n = 0; n < FACT_COEFF-1; n++)
	{
		REALNAME(Copy)(&mm[n+1*FACT_COEFF], &s[n+1]);
		REALNAME(Div)(&mm[n+1*FACT_COEFF], &mm[n+1*FACT_COEFF], &s[n]);
	}

	REALNAME(Copy)(&r[0], &s[0]);
	REALNAME(Copy)(&r[1], &mm[0+1*FACT_COEFF]);

	for (k = 2; k < FACT_COEFF; k++)
	{
		fprintf(stderr, "\rGenerating factorial coefficients: %04d/%04d          ", k-2, FACT_COEFF-2);

		for (n = 0; n < FACT_COEFF - k; n++)
		{
			REALNAME(Copy)(&a, &mm[n+1 + (k-2)*FACT_COEFF]);
			REALNAME(Copy)(&b, &mm[n+1 + (k-1)*FACT_COEFF]);
			REALNAME(Copy)(&c, &mm[n + (k-1)*FACT_COEFF]);
			REALNAME(Copy)(&mm[n + k*FACT_COEFF], &a);
			if ((k & 1) == 0)
			{
				REALNAME(Add)(&mm[n + k*FACT_COEFF], &mm[n + k*FACT_COEFF], &b);
				REALNAME(Sub)(&mm[n + k*FACT_COEFF], &mm[n + k*FACT_COEFF], &c);
			}
			else
			{
				REALNAME(Mul)(&mm[n + k*FACT_COEFF], &mm[n + k*FACT_COEFF], &b);
				REALNAME(Div)(&mm[n + k*FACT_COEFF], &mm[n + k*FACT_COEFF], &c);
			}
		}
		REALNAME(Copy)(&r[k], &mm[0 + k*FACT_COEFF]);
	}
	free(s);
	free(mm);

	// save coefficients
	for (n = 0; n < FACT_COEFF; n++)
		REALNAME(Copy)(&TempConstFact[n], &r[n]);
	free(r);
#endif // CACHE_COEF

	fprintf(stderr, "...done\n");
}

// setup of current number
int GenBits; // total bits REAL_BITS
int GenBaseBits; // number of bits of base entry BASE_BITS
int GenBaseNum; // number of base entries BASE_NUM
int GenBaseBytes; // number of bytes
int GenExpBits; // number of exponent bits
int GenMantBits; // bits of mantissa
FILE* GenFile; // output file

// temporary numbers
real16 tmp16;
real32 tmp32;
real48 tmp48;
real64 tmp64;
real80 tmp80;
real96 tmp96;
real128 tmp128;
real160 tmp160;
real192 tmp192;
real256 tmp256;
real384 tmp384;
real512 tmp512;
real768 tmp768;
real1024 tmp1024;
real1536 tmp1536;
real2048 tmp2048;
real3072 tmp3072;
real4096 tmp4096;

EXP tmpexp;

/*
#define GEN_CHEB(re, nm) {								\
		num = nm ## ChebFncNum(fnc);					\
		if (num == 0) return 0;						\
		if (cache) {								\
			poly2 = (void*)(nm ## ChebCoefTab(fnc));	\
			for (i = 0; i < num; i++) REALNAME(Import)(&poly[i], &((const re*)poly2)[i], GenBaseBytes, GenExpBits); \
		} else {									\
			poly2 = (void*)malloc(num*sizeof(re)); \
			nm ## ChebCoefRef(fnc, num, (re*)poly2, ChebProg);		\
			for (i = 0; i < num; i++) REALNAME(Import)(&poly[i], &((const re*)poly2)[i], GenBaseBytes, GenExpBits); \
			free(poly2); } }

// generate chebyshev coefficients (returns number of coefficients)
int ChebGen(int fnc, REAL* poly)
{
	int i, num;
	Bool cache = False;
	void* poly2;

#if CACHE_CHEB_LN	// get Chebyshev coefficients Ln() from cache
	if (fnc == CHEBCB_LN) cache = True;
#endif

#if CACHE_CHEB_EXP	// get Chebyshev coefficients Exp() from cache
	if (fnc == CHEBCB_EXP) cache = True;
#endif

#if CACHE_CHEB_SQRT	// get Chebyshev coefficients Sqrt() from cache
	if (fnc == CHEBCB_SQRT) cache = True;
#endif

#if CACHE_CHEB_SIN	// get Chebyshev coefficients Sin() from cache
	if (fnc == CHEBCB_SIN) cache = True;
#endif

#if CACHE_CHEB_ATAN	// get Chebyshev coefficients ATan() from cache
	if (fnc == CHEBCB_ATAN) cache = True;
#endif

#if CACHE_CHEB_ASIN	// get Chebyshev coefficients ASin() from cache
	if (fnc == CHEBCB_ASIN) cache = True;
#endif

	if (GenBits == 16)
		GEN_CHEB(real16, Real16)
	else if (GenBits == 32)
		GEN_CHEB(real32, Real32)
	else if (GenBits == 48)
		GEN_CHEB(real48, Real48)
	else if (GenBits == 64)
		GEN_CHEB(real64, Real64)
	else if (GenBits == 80)
		GEN_CHEB(real80, Real80)
	else if (GenBits == 96)
		GEN_CHEB(real96, Real96)
	else if (GenBits == 128)
		GEN_CHEB(real128, Real128)
	else if (GenBits == 160)
		GEN_CHEB(real160, Real160)
	else if (GenBits == 192)
		GEN_CHEB(real192, Real192)
	else if (GenBits == 256)
		GEN_CHEB(real256, Real256)
	else if (GenBits == 384)
		GEN_CHEB(real384, Real384)
	else if (GenBits == 512)
		GEN_CHEB(real512, Real512)
	else if (GenBits == 768)
		GEN_CHEB(real768, Real768)
	else if (GenBits == 1024)
		GEN_CHEB(real1024, Real1024)
	else if (GenBits == 1536)
		GEN_CHEB(real1536, Real1536)
	else if (GenBits == 2048)
		GEN_CHEB(real2048, Real2048)
	else if (GenBits == 3072)
		GEN_CHEB(real3072, Real3072)
	else if (GenBits == 4096)
		GEN_CHEB(real4096, Real4096)
	else
	{
		num = 0;
		printf("GenConst: Incorrect GenBits!\n");
	}

	return num;
}
*/

#define GEN_CHEBEXT(re, reext, nm) {								\
		num = nm ## ChebFncNum(fnc);					\
		if (num == 0) return 0;						\
		if (cache) {								\
			poly2 = (void*)(nm ## ChebCoefTab(fnc));	\
			for (i = 0; i < num; i++) { \
				REALNAME(Set0Ext)(&poly[i]); \
				memcpy((u8*)&poly[i] + REAL_BITS/8 - GenBaseBytes, &((const reext*)poly2)[i], GenBaseBytes); \
				REALNAME(Pack)(&poly[i], &poly[i], ((const reext*)poly2)[i].exp); } \
		} else {									\
			poly2 = (void*)malloc(num*sizeof(re)); \
			poly2_exp = (EXP*)malloc(num*sizeof(EXP)); \
			nm ## ChebCoefRefExt(fnc, num, (re*)poly2, poly2_exp, ChebProg);		\
			for (i = 0; i < num; i++) { \
				REALNAME(Set0Ext)(&poly[i]); \
				j = GenBaseBytes; if (j > REAL_BYTES) j = REAL_BYTES; \
				memcpy(((u8*)&poly[i]) + REAL_BYTES - j, &((const re*)poly2)[i], j); \
				REALNAME(Pack)(&poly[i], &poly[i], poly2_exp[i]); } \
			free(poly2); free(poly2_exp); } }

// generate chebyshev coefficients in extended format (returns number of coefficients)
int ChebGenExt(int fnc, REAL* poly)
{
	int i, j, num;
	Bool cache = False;
	void* poly2;
	EXP* poly2_exp;

#if CACHE_CHEB_LN	// get Chebyshev coefficients Ln() from cache
	if (fnc == CHEBCB_LN) cache = True;
#endif

#if CACHE_CHEB_EXP	// get Chebyshev coefficients Exp() from cache
	if (fnc == CHEBCB_EXP) cache = True;
#endif

#if CACHE_CHEB_SQRT	// get Chebyshev coefficients Sqrt() from cache
	if (fnc == CHEBCB_SQRT) cache = True;
#endif

#if CACHE_CHEB_SIN	// get Chebyshev coefficients Sin() from cache
	if (fnc == CHEBCB_SIN) cache = True;
#endif

#if CACHE_CHEB_ATAN	// get Chebyshev coefficients ATan() from cache
	if (fnc == CHEBCB_ATAN) cache = True;
#endif

#if CACHE_CHEB_ASIN	// get Chebyshev coefficients ASin() from cache
	if (fnc == CHEBCB_ASIN) cache = True;
#endif

	if (GenBits == 16)
		GEN_CHEBEXT(real16, real16ext, Real16)
	else if (GenBits == 32)
		GEN_CHEBEXT(real32, real32ext, Real32)
	else if (GenBits == 48)
		GEN_CHEBEXT(real48, real48ext, Real48)
	else if (GenBits == 64)
		GEN_CHEBEXT(real64, real64ext, Real64)
	else if (GenBits == 80)
		GEN_CHEBEXT(real80, real80ext, Real80)
	else if (GenBits == 96)
		GEN_CHEBEXT(real96, real96ext, Real96)
	else if (GenBits == 128)
		GEN_CHEBEXT(real128, real128ext, Real128)
	else if (GenBits == 160)
		GEN_CHEBEXT(real160, real160ext, Real160)
	else if (GenBits == 192)
		GEN_CHEBEXT(real192, real192ext, Real192)
	else if (GenBits == 256)
		GEN_CHEBEXT(real256, real256ext, Real256)
	else if (GenBits == 384)
		GEN_CHEBEXT(real384, real384ext, Real384)
	else if (GenBits == 512)
		GEN_CHEBEXT(real512, real512ext, Real512)
	else if (GenBits == 768)
		GEN_CHEBEXT(real768, real768ext, Real768)
	else if (GenBits == 1024)
		GEN_CHEBEXT(real1024, real1024ext, Real1024)
	else if (GenBits == 1536)
		GEN_CHEBEXT(real1536, real1536ext, Real1536)
	else if (GenBits == 2048)
		GEN_CHEBEXT(real2048, real2048ext, Real2048)
	else if (GenBits == 3072)
		GEN_CHEBEXT(real3072, real3072ext, Real3072)
	else if (GenBits == 4096)
		GEN_CHEBEXT(real4096, real4096ext, Real4096)
	else
	{
		num = 0;
		printf("GenConst: Incorrect GenBits!\n");
	}

	return num;
}

// import temporary number (returns pointer to temporary number)
void* GenImport(const REAL* temp)
{
	switch (GenBits)
	{
	case 16:
		Real16Import(&tmp16, temp, REAL_BYTES, EXP_BITS);
		return &tmp16;

	case 32:
		Real32Import(&tmp32, temp, REAL_BYTES, EXP_BITS);
		return &tmp32;

	case 48:
		Real48Import(&tmp48, temp, REAL_BYTES, EXP_BITS);
		return &tmp48;

	case 64:
		Real64Import(&tmp64, temp, REAL_BYTES, EXP_BITS);
		return &tmp64;

	case 80:
		Real80Import(&tmp80, temp, REAL_BYTES, EXP_BITS);
		return &tmp80;

	case 96:
		Real96Import(&tmp96, temp, REAL_BYTES, EXP_BITS);
		return &tmp96;

	case 128:
		Real128Import(&tmp128, temp, REAL_BYTES, EXP_BITS);
		return &tmp128;

	case 160:
		Real160Import(&tmp160, temp, REAL_BYTES, EXP_BITS);
		return &tmp160;

	case 192:
		Real192Import(&tmp192, temp, REAL_BYTES, EXP_BITS);
		return &tmp192;

	case 256:
		Real256Import(&tmp256, temp, REAL_BYTES, EXP_BITS);
		return &tmp256;

	case 384:
		Real384Import(&tmp384, temp, REAL_BYTES, EXP_BITS);
		return &tmp384;

	case 512:
		Real512Import(&tmp512, temp, REAL_BYTES, EXP_BITS);
		return &tmp512;

	case 768:
		Real768Import(&tmp768, temp, REAL_BYTES, EXP_BITS);
		return &tmp768;

	case 1024:
		Real1024Import(&tmp1024, temp, REAL_BYTES, EXP_BITS);
		return &tmp1024;

	case 1536:
		Real1536Import(&tmp1536, temp, REAL_BYTES, EXP_BITS);
		return &tmp1536;

	case 2048:
		Real2048Import(&tmp2048, temp, REAL_BYTES, EXP_BITS);
		return &tmp2048;

	case 3072:
		Real3072Import(&tmp3072, temp, REAL_BYTES, EXP_BITS);
		return &tmp3072;

	case 4096:
		Real4096Import(&tmp4096, temp, REAL_BYTES, EXP_BITS);
		return &tmp4096;
	}

	return NULL;
}

// print one constant (name = NULL to not print header)
void PrintConst(const char* name, const REAL* temp, const char* comment)
{
	FILE* f;
	double n;
	char bb[100];
	const u16* s16;
	const u32* s32;
	const void* tmp;
	int i;

	f = GenFile;

	// double value
	n = REALNAME(ToDouble)(temp);

	// print number header
	if (name != NULL)
		//fprintf(f, "const real%d Real%d%s =\t{ { ", GenBits, GenBits, name);
		fprintf(f, "const REAL REALNAME(%s) =\t{ { ", name);
	else
		fprintf(f, "\t { { ");

	// import number
	tmp = GenImport(temp);

	// export data
	switch (GenBaseBits)
	{
	case 16:
		s16 = (const u16*)tmp;
		for (i = GenBaseBits*GenBaseNum/16; i > 0; i--)
		{
			if (i > 1)
				fprintf(f, "0x%04x, ", *s16++);
			else
				fprintf(f, "0x%04x }, ", *s16++);
		}
		break;

	case 32:
		s32 = (const u32*)tmp;
		for (i = GenBaseBits*GenBaseNum/32; i > 0; i--)
		{
			if (i > 1)
				fprintf(f, "0x%08x, ", *s32++);
			else
				fprintf(f, "0x%08x }, ", *s32++);
		}
		break;
	}

	// decode number value
	bb[0] = 0;
	sprintf(bb," (%.15lg)", n);

	// print number termination
	if (name != NULL)
		fprintf(f, "};\t// %s %s\n", comment, bb);
	else
		fprintf(f, "},\t// %s %s\n", comment, bb);
}

// import temporary number (returns pointer to temporary number)
void* GenImportExt(const REAL* temp)
{
	switch (GenBits)
	{
	case 16:
		tmpexp = Real16ImportExt(&tmp16, temp, REAL_BYTES, EXP_BITS);
		return &tmp16;

	case 32:
		tmpexp = Real32ImportExt(&tmp32, temp, REAL_BYTES, EXP_BITS);
		return &tmp32;

	case 48:
		tmpexp = Real48ImportExt(&tmp48, temp, REAL_BYTES, EXP_BITS);
		return &tmp48;

	case 64:
		tmpexp = Real64ImportExt(&tmp64, temp, REAL_BYTES, EXP_BITS);
		return &tmp64;

	case 80:
		tmpexp = Real80ImportExt(&tmp80, temp, REAL_BYTES, EXP_BITS);
		return &tmp80;

	case 96:
		tmpexp = Real96ImportExt(&tmp96, temp, REAL_BYTES, EXP_BITS);
		return &tmp96;

	case 128:
		tmpexp = Real128ImportExt(&tmp128, temp, REAL_BYTES, EXP_BITS);
		return &tmp128;

	case 160:
		tmpexp = Real160ImportExt(&tmp160, temp, REAL_BYTES, EXP_BITS);
		return &tmp160;

	case 192:
		tmpexp = Real192ImportExt(&tmp192, temp, REAL_BYTES, EXP_BITS);
		return &tmp192;

	case 256:
		tmpexp = Real256ImportExt(&tmp256, temp, REAL_BYTES, EXP_BITS);
		return &tmp256;

	case 384:
		tmpexp = Real384ImportExt(&tmp384, temp, REAL_BYTES, EXP_BITS);
		return &tmp384;

	case 512:
		tmpexp = Real512ImportExt(&tmp512, temp, REAL_BYTES, EXP_BITS);
		return &tmp512;

	case 768:
		tmpexp = Real768ImportExt(&tmp768, temp, REAL_BYTES, EXP_BITS);
		return &tmp768;

	case 1024:
		tmpexp = Real1024ImportExt(&tmp1024, temp, REAL_BYTES, EXP_BITS);
		return &tmp1024;

	case 1536:
		tmpexp = Real1536ImportExt(&tmp1536, temp, REAL_BYTES, EXP_BITS);
		return &tmp1536;

	case 2048:
		tmpexp = Real2048ImportExt(&tmp2048, temp, REAL_BYTES, EXP_BITS);
		return &tmp2048;

	case 3072:
		tmpexp = Real3072ImportExt(&tmp3072, temp, REAL_BYTES, EXP_BITS);
		return &tmp3072;

	case 4096:
		tmpexp = Real4096ImportExt(&tmp4096, temp, REAL_BYTES, EXP_BITS);
		return &tmp4096;
	}

	return NULL;
}

/*
// extended real number structure - used as constant (mantissa contains implied bit '1' and is extended to full BASE_NUM segments)
typedef struct {
	BASE	n[BASE_NUM];	// real number segments - mantissa
				// - first segment contains lowest bits of mantissa
				// - last segment contains highest bits of mantissa with implied bit '1'
	EXP		exp;			// packed extended exponent and sign in last bit
} REALEXT;
*/

// print extended constant (name = NULL to not print header)
void PrintConstExt(const char* name, const REAL* temp, const char* comment)
{
	FILE* f;
	double n;
	char bb[100];
	const u16* s16;
	const u32* s32;
	const void* tmp;
	int i;

	f = GenFile;

	// double value
	n = REALNAME(ToDouble)(temp);

	// print number header
	if (name != NULL)
		//fprintf(f, "const real%d Real%d%s =\t{ { ", GenBits, GenBits, name);
		fprintf(f, "const REALEXT REALNAME(%s) =\t{ { ", name);
	else
		fprintf(f, "\t { { ");

	// import number
	tmp = GenImportExt(temp);

	// export data
	switch (GenBaseBits)
	{
	case 16:
		s16 = (const u16*)tmp;
		for (i = GenBaseBits*GenBaseNum/16; i > 0; i--)
		{
			if (i > 1)
				fprintf(f, "0x%04x, ", *s16++);
			else
				fprintf(f, "0x%04x }, ", *s16++);
		}
		break;

	case 32:
		s32 = (const u32*)tmp;
		for (i = GenBaseBits*GenBaseNum/32; i > 0; i--)
		{
			if (i > 1)
				fprintf(f, "0x%08x, ", *s32++);
			else
				fprintf(f, "0x%08x }, ", *s32++);
		}
		break;
	}

	// exponent
	fprintf(f, "0x%08x", tmpexp);

	// decode number value
	bb[0] = 0;
	sprintf(bb," (%.15lg)", n);

	// print number termination
	if (name != NULL)
		fprintf(f, "};\t// %s %s\n", comment, bb);
	else
		fprintf(f, "},\t// %s %s\n", comment, bb);
}

// generate constant of one real type
void Gen(int basebits, int basenum, int expbits)
{
	int bits, n, i, j, decexp, factcoeff;
	char filename[50];
	FILE* f;
	char bb[50];
	REAL* poly;
	REAL* g;
	s64 k;

	// setup
	bits = basebits*basenum;
	GenBits = bits; // total bits REAL_BITS
	GenBaseBits = basebits; // number of bits of base entry BASE_BITS
	GenBaseNum = basenum; // number of base entries BASE_NUM
	GenBaseBytes = basebits*basenum/8; // length in bytes
	GenExpBits = expbits; // number of exponent bits
	GenMantBits = bits - expbits - 1; // bits of mantissa

	factcoeff = bits/8;
	if (factcoeff > FACT_COEFF) factcoeff = FACT_COEFF;

	// prepare exponent max and min
	// exp(x) max = EXP_INF*ln(2)+1 ... (used in Exp() to check range, not needed precise value)
	// exp(x) min = EXP_UNDER*ln(2)-1 ... (used in Exp() to check range, not needed precise value)
	REALNAME(FromDouble)(&TempConstExpMax, (double)((1ULL << (expbits-1))-1)*log(2.0) + 1);
	REALNAME(FromDouble)(&TempConstExpMin, -(double)((1ULL << (expbits-1))-1)*log(2.0) - 1);

	// prepare filename
	sprintf(filename, "const%04d.h", bits);
	fprintf(stderr, "\rGenerating %s...\n", filename);

	// create output file
	f = fopen(filename, "wb");
	if (f == NULL)
	{
		fprintf(stderr, "\rERROR creating %s!\n", filename);
		return;
	}
	GenFile = f;

	// print header
	fprintf(f, "\n");
	fprintf(f, "// ****************************************************************************\n");
	fprintf(f, "//\n");
	fprintf(f, "//                           Constant Templates of real%d\n", bits);
	fprintf(f, "//\n");
	fprintf(f, "// ****************************************************************************\n");
	fprintf(f, "// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz\n\n");
	fprintf(f, "// real%d: size %d bytes, %d bits, mantissa %d bits, exponent %d bits\n", bits, bits/8, bits, GenMantBits, expbits);
	fprintf(f, "\n");

	fprintf(f, "// Normal precision:\n");
	PrintConst("Const0",		&TempConst0,			"0");
	PrintConst("Const1",		&TempConst1,			"1");
	PrintConst("ConstM1",		&TempConstM1,			"-1");
	PrintConst("Const2",		&TempConst2,			"2");
	PrintConst("Const3",		&TempConst3,			"3");
	PrintConst("Const05",		&TempConst05,			"0.5");
	PrintConst("ConstM05",		&TempConstM05,			"-0.5");
	PrintConst("Const075",		&TempConst075,			"0.75");
	PrintConst("Const83",		&TempConst83,			"8/3");
	PrintConst("Const10",		&TempConst10,			"10");
	PrintConst("Const100",		&TempConst100,			"100");
	PrintConst("ConstExpMax",	&TempConstExpMax,		"exp(x) max");
	PrintConst("ConstExpMin",	&TempConstExpMin,		"exp(x) min");
	PrintConst("Const01",		&TempConst01,			"0.1 (1e-1)");
	PrintConst("Const001",		&TempConst001,			"0.01 (1e-2)");
	PrintConst("Const1eM4",		&TempConst1eM4,			"0.0001 (1e-4)");
	PrintConst("Const1eM8",		&TempConst1eM8,			"0.00000001 (1e-8)");
	PrintConst("ConstLn2",		&TempConstLn2,			"ln(2)");
	PrintConst("ConstRLn2",		&TempConstRLn2,			"1/ln(2)");
	PrintConst("ConstLn10",		&TempConstLn10,			"ln(10)");
	PrintConst("ConstRLn10",	&TempConstRLn10,		"1/ln(10)");
	PrintConst("ConstLog2",		&TempConstLog2,			"log(2)");
	PrintConst("ConstRLog2",	&TempConstRLog2,		"1/log(2)");
	PrintConst("ConstEul",		&TempConstEul,			"Eul");
	PrintConst("ConstPi05",		&TempConstPi05,			"pi/2");
	PrintConst("ConstPi",		&TempConstPi,			"pi");
	PrintConst("ConstPi2",		&TempConstPi2,			"pi*2");
	PrintConst("ConstRPi2",		&TempConstRPi2,			"1/pi*2");
	PrintConst("ConstLnPi22",	&TempConstLnPi22,		"ln(pi*2)/2");
	PrintConst("Const180Pi",	&TempConst180Pi,		"180/pi");
	PrintConst("ConstPi180",	&TempConstPi180,		"pi/180");
	PrintConst("Const200Pi",	&TempConst200Pi,		"200/pi");
	PrintConst("ConstPi200",	&TempConstPi200,		"pi/200");
	PrintConst("ConstPhi",		&TempConstPhi,			"phi (sectio aurea = (1 + sqrt(5))/2)");
	PrintConst("ConstSqrt2",	&TempConstSqrt2,		"sqrt(2)");
	PrintConst("ConstRSqrt2",	&TempConstRSqrt2,		"1/sqrt(2)");

	fprintf(f, "\n// Extended precision:\n");
	PrintConstExt("Const0Ext",		&TempConst0,			"0");
	PrintConstExt("Const1Ext",		&TempConst1,			"1");
	PrintConstExt("ConstM1Ext",		&TempConstM1,			"-1");
	PrintConstExt("Const2Ext",		&TempConst2,			"2");
	PrintConstExt("Const3Ext",		&TempConst3,			"3");
	PrintConstExt("Const05Ext",		&TempConst05,			"0.5");
	PrintConstExt("ConstM05Ext",	&TempConstM05,			"-0.5");
	PrintConstExt("Const075Ext",	&TempConst075,			"0.75");
	PrintConstExt("Const83Ext",		&TempConst83,			"8/3");
	PrintConstExt("Const10Ext",		&TempConst10,			"10");
	PrintConstExt("Const100Ext",	&TempConst100,			"100");
	PrintConstExt("ConstExpMaxExt",	&TempConstExpMax0,		"exp(x) max");
	PrintConstExt("ConstExpMinExt",	&TempConstExpMin0,		"exp(x) min");
	PrintConstExt("Const01Ext",		&TempConst01,			"0.1 (1e-1)");
	PrintConstExt("Const001Ext",	&TempConst001,			"0.01 (1e-2)");
	PrintConstExt("Const1eM4Ext",	&TempConst1eM4,			"0.0001 (1e-4)");
	PrintConstExt("Const1eM8Ext",	&TempConst1eM8,			"0.00000001 (1e-8)");
	PrintConstExt("ConstLn2Ext",	&TempConstLn2,			"ln(2)");
	PrintConstExt("ConstRLn2Ext",	&TempConstRLn2,			"1/ln(2)");
	PrintConstExt("ConstLn10Ext",	&TempConstLn10,			"ln(10)");
	PrintConstExt("ConstRLn10Ext",	&TempConstRLn10,		"1/ln(10)");
	PrintConstExt("ConstLog2Ext",	&TempConstLog2,			"log(2)");
	PrintConstExt("ConstRLog2Ext",	&TempConstRLog2,		"1/log(2)");
	PrintConstExt("ConstEulExt",	&TempConstEul,			"Eul");
	PrintConstExt("ConstPi05Ext",	&TempConstPi05,			"pi/2");
	PrintConstExt("ConstPiExt",		&TempConstPi,			"pi");
	PrintConstExt("ConstPi2Ext",	&TempConstPi2,			"pi*2");
	PrintConstExt("ConstRPi2Ext",	&TempConstRPi2,			"1/pi*2");
	PrintConstExt("ConstLnPi22Ext",	&TempConstLnPi22,		"ln(pi*2)/2");
	PrintConstExt("Const180PiExt",	&TempConst180Pi,		"180/pi");
	PrintConstExt("ConstPi180Ext",	&TempConstPi180,		"pi/180");
	PrintConstExt("Const200PiExt",	&TempConst200Pi,		"200/pi");
	PrintConstExt("ConstPi200Ext",	&TempConstPi200,		"pi/200");
	PrintConstExt("ConstPhiExt",	&TempConstPhi,			"phi (sectio aurea = (1 + sqrt(5))/2)");
	PrintConstExt("ConstSqrt2Ext",	&TempConstSqrt2,		"sqrt(2)");
	PrintConstExt("ConstRSqrt2Ext",	&TempConstRSqrt2,		"1/sqrt(2)");

	decexp = expbits - 2;
	fprintf(f, "\n// Decimal exponents (index REAL_DECEXP = number '1')\n");
	fprintf(f, "const REAL REALNAME(ConstExp)[REAL_DECEXP*2+1] = {\t// total %d numbers\n", decexp*2+1);

	g = &TempConstExp[REAL_DECEXP-decexp];
	for (i = 0; i < decexp*2+1; i++)
	{
		k = 0;
		if (i < decexp)
		{
			k = -1;
			j = decexp-1;
			while (j > i)
			{
				k *= 2;
				j--;
			}
		}
		else if (i > decexp)
		{
			k = 1;
			j = decexp+1;
			while (j < i)
			{
				k *= 2;
				j++;
			}
		}

		if (k < 0)
			sprintf(bb, "1e%lld (1e-0x%llx)", k, -k);
		else
			sprintf(bb, "1e+%lld (1e+0x%llx)", k, k);

		PrintConst(NULL, &g[i], bb);
	}
	fprintf(f, "};\n");

	// generate factorial coefficients
	n = factcoeff;
	fprintf(f, "\n// Factorial coefficients\n");
	fprintf(f, "#ifdef FACT_COEFF\n");
	fprintf(f, "const REAL REALNAME(ConstFact)[FACT_COEFF] = {\t// FACT_COEFF = %d\n", factcoeff);
	for (i = 0; i < n; i++)
	{
		g = &TempConstFact[i];
		sprintf(bb, "a%d", i);
		PrintConst(NULL, g, bb);
	}
	fprintf(f, "};\n");
	fprintf(f, "#endif\n");

	poly = (REAL*)malloc(10000*sizeof(REAL));

	// generate Chebyshev coefficients Ln()
	ChebProgTab = "Ln (1/6)";
	n = ChebGenExt(CHEBCB_LN, poly);
	if (n > 0)
	{
		fprintf(f, "\n// Chebyshev coefficients of Ln()\n");
		fprintf(f, "#ifdef CHEB_LN\n");
		fprintf(f, "const REALEXT REALNAME(ConstChebLn)[CHEB_LN] = {\t// CHEB_LN = %d\n", n);
		for (i = 0; i < n; i++)
		{
			sprintf(bb, "%d", i);
			PrintConstExt(NULL, &poly[i], bb);
		}
		fprintf(f, "};\n");
		fprintf(f, "#endif\n");
	}

	// generate Chebyshev coefficients Exp()
	ChebProgTab = "Exp (2/6)";
	n = ChebGenExt(CHEBCB_EXP, poly);
	if (n > 0)
	{
		fprintf(f, "\n// Chebyshev coefficients of Exp()\n");
		fprintf(f, "#ifdef CHEB_EXP\n");
		fprintf(f, "const REALEXT REALNAME(ConstChebExp)[CHEB_EXP] = {\t// CHEB_EXP = %d\n", n);
		for (i = 0; i < n; i++)
		{
			sprintf(bb, "%d", i);
			PrintConstExt(NULL, &poly[i], bb);
		}
		fprintf(f, "};\n");
		fprintf(f, "#endif\n");
	}

	// generate Chebyshev coefficients Sin()
	ChebProgTab = "Sin (3/6)";
	n = ChebGenExt(CHEBCB_SIN, poly);
	if (n > 0)
	{
		fprintf(f, "\n// Chebyshev coefficients of Sin()\n");
		fprintf(f, "#ifdef CHEB_SIN\n");
		fprintf(f, "const REALEXT REALNAME(ConstChebSin)[CHEB_SIN] = {\t// CHEB_SIN = %d\n", n);
		for (i = 0; i < n; i++)
		{
			sprintf(bb, "%d", i);
			PrintConstExt(NULL, &poly[i], bb);
		}
		fprintf(f, "};\n");
		fprintf(f, "#endif\n");
	}

	// generate Chebyshev coefficients ASin()
	ChebProgTab = "ASin (4/6)";
	n = ChebGenExt(CHEBCB_ASIN, poly);
	if (n > 0)
	{
		fprintf(f, "\n// Chebyshev coefficients of ASin()\n");
		fprintf(f, "#ifdef CHEB_ASIN\n");
		fprintf(f, "const REALEXT REALNAME(ConstChebASin)[CHEB_ASIN] = {\t// CHEB_ASIN = %d\n", n);
		for (i = 0; i < n; i++)
		{
			sprintf(bb, "%d", i);
			PrintConstExt(NULL, &poly[i], bb);
		}
		fprintf(f, "};\n");
		fprintf(f, "#endif\n");
	}

	// generate Chebyshev coefficients ATan()
	ChebProgTab = "ATan (5/6)";
	n = ChebGenExt(CHEBCB_ATAN, poly);
	if (n > 0)
	{
		fprintf(f, "\n// Chebyshev coefficients of ATan()\n");
		fprintf(f, "#ifdef CHEB_ATAN\n");
		fprintf(f, "const REALEXT REALNAME(ConstChebATan)[CHEB_ATAN] = {\t// CHEB_ATAN = %d\n", n);
		for (i = 0; i < n; i++)
		{
			sprintf(bb, "%d", i);
			PrintConstExt(NULL, &poly[i], bb);
		}
		fprintf(f, "};\n");
		fprintf(f, "#endif\n");
	}

	// generate Chebyshev coefficients Sqrt()
	ChebProgTab = "Sqrt (6/6)";
	n = ChebGenExt(CHEBCB_SQRT, poly);
	if (n > 0)
	{
		fprintf(f, "\n// Chebyshev coefficients of Sqrt()\n");
		fprintf(f, "#ifdef CHEB_SQRT\n");
		fprintf(f, "const REALEXT REALNAME(ConstChebSqrt)[CHEB_SQRT] = {\t// CHEB_SQRT = %d\n", n);
		for (i = 0; i < n; i++)
		{
			sprintf(bb, "%d", i);
			PrintConstExt(NULL, &poly[i], bb);
		}
		fprintf(f, "};\n");
		fprintf(f, "#endif\n");
	}

	fclose(f);
	fprintf(stderr, "\r                           \r");
}

// export constants
void ExportConst()
{
	// generate template constants
	GenTempConst();
	fprintf(stderr, "\r                                                  \r");

	// generate files
//void Gen(int basebits, int basenum, int expbits)
/*	Gen(16, 1, 5); // real16
	Gen(32, 1, 8); // real32
	Gen(16, 3, 10); // real48
	Gen(32, 2, 11); // real64
	Gen(16, 5, 15); // real80
	Gen(32, 3, 13); // real96
	Gen(32, 4, 15); // real128
	Gen(32, 5, 16); // real160
	Gen(32, 6, 17); // real192
	Gen(32, 8, 19); // real256
	Gen(32, 12, 21); // real384
	Gen(32, 16, 23); // real512
	Gen(32, 24, 25); // real768
	Gen(32, 32, 27); // real1024
	Gen(32, 48, 30); // real1536
*/
	Gen(32, 64, 30); // real2048
/*
	Gen(32, 96, 30); // real3072
	Gen(32, 128, 30); // real4096
*/
}

#include "../real_undef.h"			// undefine

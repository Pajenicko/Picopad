
// ****************************************************************************
//                                 
//                            Big integers
//
// ****************************************************************************

#if USE_BIGINT		// use Big Integers (bigint.c, bigint.h)

#ifdef __cplusplus
extern "C" {
#endif

//#define BIGINT_BERN_NUM	512		// number of table Bernoulli numbers - use number 0, 256 or 512
#define BIGINT_BASE_BITS	32		// number of bits of base segment
#define BIGINT_BASE			u32		// type of base segment unsigned
#define BIGINT_BASES		s32		// type of base segment signed

#define BIGINT_BASE_BYTES (BIGINT_BASE_BITS/8)	// number of bytes per base segment
#define BIGINT_BASE_LAST	((BIGINT_BASE)1 << (BIGINT_BASE_BITS-1))	// last bit in segment

// Big integer - constant
typedef struct {
	const BIGINT_BASE*		data;		// array of segments
	int						num;		// number of segments (0=zero number)
	Bool					sign;		// sign flag
} cbigint;

#if BIGINT_BERN_NUM > 0		// number of table Bernoulli numbers - use number 0, 256 or 512

// Bernoulli numbers - numerators
extern const cbigint bern_num[BIGINT_BERN_NUM];

// Bernoulli numbers - denominators
extern const cbigint bern_den[BIGINT_BERN_NUM];

#endif // BIGINT_BERN_NUM > 0		// number of table Bernoulli numbers - use number 0, 256 or 512

// Big integer
typedef struct {
	BIGINT_BASE*	data;		// array of segments (number is always positive)
	int				num;		// number of valid segments (0=zero number)
	int				max;		// maximum allocated segments
	Bool			sign;		// sign flag
} bigint;

// initialize big integer
void BigIntInit(bigint* num);

// terminate big integer
void BigIntTerm(bigint* num);

// allocate array of bigint numbers
bigint* BigIntGetArr(int num);

// release array of bigint numbers
void BigIntFreeArr(bigint* arr, int num);

// resize array of bigint numbers (returns new address of array)
bigint* BigIntResizeArr(bigint* arr, int oldnum, int newnum);

// set number of segments, content will be lost (returns False on memory error)
Bool BigIntSetSize(bigint* num, int n);

// resize number of segments, content will be preserved, new segments will be cleared
//  Memory error is not handled
void BigIntResize(bigint* num, int n);

// reduce - delete zero segments
void BigIntReduce(bigint* num);

// copy from another number
void BigIntCopy(bigint* num, const bigint* src);
void BigIntCopyC(bigint* num, const cbigint* src);

// exchange numbers
void BigIntExch(bigint* num1, bigint* num2);

// compare numbers (result: 1 if num1 > num2, 0 if num1 == num2, -1 if num1 < num2)
int BigIntComp(const bigint* num1, const bigint* num2);

// compare absolute value of numbers (result: 1 if num1 > num2, 0 if num1 == num2, -1 if num1 < num2)
int BigIntCompAbs(const bigint* num1, const bigint* num2);

// get bit length of the number (= 1 + bit position of highest '1')
int BigIntBitLen(const bigint* num);

// get number of lower bits '0' (count trailing zeros)
int BigIntCtz(const bigint* num);

// shift number 1 bit left (= multiply * 2)
void BigIntMul2(bigint* num);

// shift number 1 bit right (= divide / 2)
void BigIntDiv2(bigint* num);

// shift number more bits left
void BigIntLeft(bigint* num, int shift);

// shift number more bits right
void BigIntRight(bigint* num, int shift);

// check if number is zero
INLINE Bool BigIntIsZero(const bigint* num)
	{ return num->num == 0; }

// check if number is negative
INLINE Bool BigIntIsNeg(const bigint* num)
	{ return num->sign; }

// negate number
INLINE void BigIntNeg(bigint* num)
	{ if (num->num > 0) num->sign = !num->sign; }

// absolute value
INLINE void BigIntAbs(bigint* num)
	{ num->sign = False; }

// check if number is equal integer value
Bool BigIntEquInt(const bigint* num, BIGINT_BASES n);

// set value 0
void BigIntSet0(bigint* num);

// set value 1
void BigIntSet1(bigint* num);

// set integer value
void BigIntSetInt(bigint* num, BIGINT_BASES n);

// add/sub two numbers (this = num1 +- num2, operands and destination can be the same)
void BigIntAddSub(bigint* num, const bigint* num1, const bigint* num2, Bool sub);

// add two numbers (this = num1 + num2, operands and destination can be the same)
INLINE void BigIntAdd(bigint* num, const bigint* num1, const bigint* num2)
	{ BigIntAddSub(num, num1, num2, False); }

// subtract two numbers (this = num1 - num2, operands and destination can be the same)
INLINE void BigIntSub(bigint* num, const bigint* num1, const bigint* num2)
	{ BigIntAddSub(num, num1, num2, True); }

// multiply two numbers (this = num1 * num2, operands and destintion can be the same)
void BigIntMul(bigint* num, const bigint* num1, const bigint* num2);

// divide two numbers (this = num1 / num2, rem = remainder or NULL if not required)
void BigIntDivRem(bigint* num, const bigint* num1, const bigint* num2, bigint* rem);
INLINE void BigIntDiv(bigint* num, const bigint* num1, const bigint* num2)
	{ BigIntDivRem(num, num1, num2, NULL); }

// get modulo - remainder (this = this % num, remainder will always be >= 0)
void BigIntMod(bigint* num, const bigint* num2);

// find greatest common divisor GCD (use binary or Euclidean GCD algorithm; result will always be >= 0)
void BigIntGCDBin(bigint* num, const bigint* num1, const bigint* num2);
void BigIntGCDEuc(bigint* num, const bigint* num1, const bigint* num2);
INLINE void BigIntGCD(bigint* num, const bigint* num1, const bigint* num2)
	{ BigIntGCDEuc(num, num1, num2); }

// multiply number * 10 and add digit
void BigIntMul10(bigint* num, u16 carry);

// divide number / 10 and return digit
char BigIntDiv10(bigint* num);

// import number from ASCIIZ text
void BigIntFromText(bigint* num, const char* text);

// export number to text buffer (returns number of characters)
int BigIntToText(const bigint* num, char* buf, int size);

// get max. index of table Bernoulli number (0 = table not supported)
INLINE int BigIntBernMax() { return BIGINT_BERN_NUM*2; }

// load table Bernoulli number - numerator (index = 0..BernMax())
void BigIntBernNum(bigint* num, int inx);

// load table Bernoulli number - denominator (index = 0..BernMax())
void BigIntBernDen(bigint* num, int inx);

// typedef callback function to indicate Bernoulli progress, in 0..1000 per mille)
typedef void (bernoulli_cb)(int permille);

// generate array of even Bernoulli numbers as fraction
//  n = required number of Bernoulli numbers (generate even numbers B2..B2n)
//  numer = pointer to array of 'n' bigint numbers to store result numerators
//			(GetArr function can be used to allocate arrays of bigint)
//  denom = pointer to array of 'n' bigint numbers to store result denominators
//  cb = callback function to indicate progress (NULL=not used)
// Requires '4*n+2' bigint numbers to be temporary allocated using MemAlloc function.
// Note: B0=1 (skipped), B1=-1/2 (skipped), B2=1/6, B3=0 (skipped), B4=-1/30, B5=0 (skipped), ...
void Bernoulli(int n, bigint* numer, bigint* denom, bernoulli_cb cb);

// Test Bernoulli generator with s64
//s64 GCD64(s64 a, s64 b);
//void Bernoulli64(int n, s64* numer, s64* denom);

#ifdef __cplusplus
}
#endif

#endif // USE_BIGINT		// use Big Integers (bigint.c, bigint.h)

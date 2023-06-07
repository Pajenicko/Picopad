
// ****************************************************************************
//                                 
//                            Big integers
//
// ****************************************************************************

#ifdef GENERATOR
#include "bernoulli/include.h"
#else
#include "../../global.h"	// globals
#endif

#if USE_BIGINT		// use Big Integers (bigint.c, bigint.h)

#include "../../_sdk/inc/sdk_bootrom.h"
#include "../../_sdk/inc/sdk_divider.h"
#include "bigint.h"
#include "../inc/lib_mem.h"

// ---------------------------------------------------------------------------
//                       initialize big integer
// ---------------------------------------------------------------------------

void BigIntInit(bigint* num)
{
	num->data = NULL;
	num->num = 0;
	num->max = 0;
	num->sign = False;
}

// ---------------------------------------------------------------------------
//                         terminate big integer
// ---------------------------------------------------------------------------

void BigIntTerm(bigint* num)
{
	MemFree(num->data);
}

// ---------------------------------------------------------------------------
//                  allocate array of bigint numbers
// ---------------------------------------------------------------------------

bigint* BigIntGetArr(int num)
{
	bigint *arr;
	if (num <= 0) return NULL;
	arr = (bigint*)MemAlloc(num*sizeof(bigint));
	if (arr == NULL) return NULL;
	for (num--; num >= 0; num--) BigIntInit(&arr[num]);
	return arr;
}

// ---------------------------------------------------------------------------
//                 release array of bigint numbers
// ---------------------------------------------------------------------------

void BigIntFreeArr(bigint* arr, int num)
{
	if ((arr == NULL) || (num <= 0)) return;
	for (num--; num >= 0; num--) BigIntTerm(&arr[num]);
	MemFree(arr);
}

// ---------------------------------------------------------------------------
//      resize array of bigint numbers (returns new address of array)
// ---------------------------------------------------------------------------

bigint* BigIntResizeArr(bigint* arr, int oldnum, int newnum)
{
	int i;
	bigint* d;

	// create new array
	if (arr == NULL) return BigIntGetArr(newnum);

	// delete array
	if (newnum <= 0)
	{
		BigIntFreeArr(arr, oldnum);
		return NULL;
	}

	// array is equal
	if (oldnum == newnum) return arr;

	// upscale array
	if (newnum > oldnum)
	{
		arr = (bigint*)MemResize(arr, newnum*sizeof(bigint));
		if (arr == NULL) return NULL;
		d = &arr[oldnum];
		for (i = oldnum; i < newnum; i++) BigIntInit(&arr[i]);
		return arr;
	}

	// downscale array
	for (i = newnum; i < oldnum; i++) BigIntTerm(&arr[i]);
	arr = (bigint*)MemResize(arr, newnum*sizeof(bigint));
	return arr;
}

// ---------------------------------------------------------------------------
// set number of segments, content will be lost (returns False on memory error)
// ---------------------------------------------------------------------------

Bool BigIntSetSize(bigint* num, int n)
{
	int max;
	BIGINT_BASE* data;

	// change number of segments
	if (n != num->num)
	{
		// increase number of segments
		if (n > num->num)
		{
			// increase buffer size
			if (n > num->max)
			{
				MemFree(num->data);	// delete old buffer
				max = n + 8; // with some reserve
				data = (BIGINT_BASE*)MemAlloc(max*sizeof(BIGINT_BASE)); // create new buffer
				if (data == NULL)
				{
					num->data = NULL;
					num->num = 0;
					num->max = 0;
					num->sign = 0;
					return False;
				}
				num->data = data;
				num->max = max;
			}
		}

		// set new size
		num->num = n;
	}

	// zero
	if (n == 0) num->sign = False;

	return True;
}

// ---------------------------------------------------------------------------
// resize number of segments, content will be preserved, new segments will be cleared
// ---------------------------------------------------------------------------
// Memory error is not handled

void BigIntResize(bigint* num, int n)
{
	int max, i;
	BIGINT_BASE *data, *d;

	// change number of segments
	if (n != num->num)
	{
		// increase number of segments
		if (n > num->num)
		{
			// increase buffer size
			if (n > num->max)
			{
				max = n + 8; // with some reserve
				data = (BIGINT_BASE*)MemResize(num->data, max*sizeof(BIGINT_BASE));
				num->data = data;
				num->max = max;
			}

			// clear new segments
			i = n - num->num;
			d = &num->data[num->num];
			for (; i > 0; i--) *d++ = 0;
		}

		// set new size
		num->num = n;
	}

	// zero
	if (n == 0) num->sign = False;
}

// ---------------------------------------------------------------------------
//                  reduce - delete zero segments
// ---------------------------------------------------------------------------

void BigIntReduce(bigint* num)
{
	int n;
	BIGINT_BASE* d;

	n = num->num;
	d = &num->data[n];
	for (; n > 0; n--)
	{
		d--;
		if (*d != 0) break;
	}
	num->num = n;
	if (n == 0) num->sign = False;
}

// ---------------------------------------------------------------------------
//                  copy from another number
// ---------------------------------------------------------------------------

void BigIntCopy(bigint* num, const bigint* src)
{
	// identical number
	if (num == src) return;

	// set size of destination buffer
	BigIntSetSize(num, src->num);

	// copy data
	memcpy(num->data, src->data, src->num*sizeof(BIGINT_BASE));

	// copy sign
	num->sign = src->sign;
}

void BigIntCopyC(bigint* num, const cbigint* src)
{
	// set size of destination buffer
	BigIntSetSize(num, src->num);

	// copy data
	memcpy(num->data, src->data, src->num*sizeof(BIGINT_BASE));

	// copy sign
	num->sign = src->sign;
}

// ---------------------------------------------------------------------------
//                      exchange numbers
// ---------------------------------------------------------------------------

void BigIntExch(bigint* num1, bigint* num2)
{
	BIGINT_BASE* d;
	int n, max;
	Bool sign;

	d = num1->data;
	n = num1->num;
	max = num1->max;
	sign = num1->sign;

	num1->data = num2->data;
	num1->num = num2->num;
	num1->max = num2->max;
	num1->sign = num2->sign;

	num2->data = d;
	num2->num = n;
	num2->max = max;
	num2->sign = sign;
}

// ---------------------------------------------------------------------------
// compare numbers (result: 1 if num1 > num2, 0 if num1 == num2, -1 if num1 < num2)
// ---------------------------------------------------------------------------

int BigIntComp(const bigint* num1, const bigint* num2)
{
	Bool sign1, sign2;

	// pointers are equal
	if (num1 == num2) return 0;

	// get signs
	sign1 = num1->sign;
	sign2 = num2->sign;

	// compare signs
	if (!sign1 && sign2) return 1; // num1 (>= 0) > num2 (< 0)
	if (sign1 && !sign2) return -1; // num1 (< 0) < num2 (>= 0)

	// signs are equal
	if (sign1)
		return -BigIntCompAbs(num1, num2);
	else
		return BigIntCompAbs(num1, num2);
}

// ---------------------------------------------------------------------------
// compare absolute value of numbers (result: 1 if num1 > num2, 0 if num1 == num2, -1 if num1 < num2)
// ---------------------------------------------------------------------------

int BigIntCompAbs(const bigint* num1, const bigint* num2)
{
	int n1, n2;
	BIGINT_BASE a1, a2, *s1, *s2;

	// pointers are equal
	if (num1 == num2) return 0;

	// get source number of segments
	n1 = num1->num;
	n2 = num2->num;

	// compare lengths
	if (n1 > n2) return 1;		// num1 > num2
	if (n1 < n2) return -1;		// num1 < num2

	// lengths are equal, compare numbers
	s1 = &num1->data[n1];
	s2 = &num2->data[n1];
	for (; n1 > 0; n1--)
	{
		s1--;
		s2--;
		a1 = *s1;
		a2 = *s2;
		if (a1 > a2) return 1;		// num1 > num2
		if (a1 < a2) return -1;		// num1 < num2
	}

	// numbers are equal
	return 0;
}

// ---------------------------------------------------------------------------
//     get bit length of the number (= 1 + bit position of highest '1')
// ---------------------------------------------------------------------------

int BigIntBitLen(const bigint* num)
{
	int n, pos;

	// get number of whole segments
	n = num->num;
	if (n == 0) return 0;
	n--;

	// bits in whole segments
	pos = n * BIGINT_BASE_BITS;

	// add bits in last segment
	pos += BIGINT_BASE_BITS - clz(num->data[n]);

	return pos;
}

// ---------------------------------------------------------------------------
//          get number of lower bits '0' (count trailing zeros)
// ---------------------------------------------------------------------------

int BigIntCtz(const bigint* num)
{
	int i, n;
	BIGINT_BASE a;
	const BIGINT_BASE *s;

	// zero number
	n = num->num;
	if (n == 0) return 0;

	// count whole segments
	i = 0;
	s = num->data;
	for (; n > 0; n--)
	{
		a = *s++;
		if (a != 0) break;
		i += BIGINT_BASE_BITS;
	}

	// count bits in last non-zero segment
	if (n > 0) i += ctz(a);

	return i;
}

// ---------------------------------------------------------------------------
//           shift number 1 bit left (= multiply * 2)
// ---------------------------------------------------------------------------

void BigIntMul2(bigint* num)
{
	int i;
	BIGINT_BASE *s, b;
	u8 carry, carry2;

	i = num->num;			// number of segments
	s = &num->data[0];		// pointer to first segment
	carry = 0;

	for (; i > 0; i--)
	{
		b = *s;						// load mantissa segment
		carry2 = carry;				// save input carry
		carry = ((b & BIGINT_BASE_LAST) == 0) ? 0 : 1; // get new carry
		b = (b << 1) | carry2;		// shift and add input carry		
		*s++ = b;					// set new segment
	}

	// carry
	if (carry)
	{
		i = num->num;
		BigIntResize(num, i+1);
		num->data[i] = 1;
	}
}

// ---------------------------------------------------------------------------
//             shift number 1 bit right (= divide / 2)
// ---------------------------------------------------------------------------

void BigIntDiv2(bigint* num)
{
	int i;
	BIGINT_BASE *s, b;
	u8 carry, carry2;

	i = num->num;			// number of segments
	s = &num->data[i];		// pointer after end of data
	carry = 0;

	for (; i > 0; i--)
	{
		s--;						// shift pointer
		b = *s;						// load segment
		carry2 = carry;				// save input carry
		carry = (u8)(b & 1);		// get new carry
		b >>= 1;					// shift
		if (carry2) b |= BIGINT_BASE_LAST; // add input carry
		*s = b;					// set new segment
	}

	// reduce
	BigIntReduce(num);
}

// ---------------------------------------------------------------------------
//                    shift number more bits left
// ---------------------------------------------------------------------------

void BigIntLeft(bigint* num, int shift)
{
	int shiftn, shiftb, shiftb2, n, n2, i;
	BIGINT_BASE *s, *d, segH, segL;

	// invalid number of shifts
	if (shift <= 0) return;

	// split number of shifts
	shiftn = shift / BIGINT_BASE_BITS;	// number of shifts by whole segments
	shiftb = shift & (BIGINT_BASE_BITS-1); // number of shifts by remaining bits

	// resize number
	n = num->num;
	n2 = n + shiftn + 1;
	BigIntResize(num, n2);

	// prepare pointers
	s = &num->data[n]; // source after last segment
	d = &num->data[n2]; // destination after last segment

	// shift by whole segments
	if (shiftb == 0)
	{
		*--d = 0;
		for (i = n; i > 0; i--) *--d = *--s;
		for (i = shiftn; i > 0; i--) *--d = 0;
	}

	// shift by bits
	else
	{
		// store first segment
		segH = *--s;
		shiftb2 = BIGINT_BASE_BITS - shiftb;
		*--d = (segH >> shiftb2);

		// shift
		for (i = n - 1; i > 0; i--)
		{
			segL = *--s;
			*--d = (segH << shiftb) | (segL >> shiftb2);
			segH = segL;
		}

		// store last segment
		*--d = (segH << shiftb);

		// clear remaining segments
		for (i = shiftn; i > 0; i--) *--d = 0;
	}

	// reduce
	BigIntReduce(num);
}

// ---------------------------------------------------------------------------
//                   shift number more bits right
// ---------------------------------------------------------------------------

void BigIntRight(bigint* num, int shift)
{
	int n, mx, i;
	int shiftn, shiftb, shiftb2;
	BIGINT_BASE *s, *d, segH, segL;

	// limit number of shifts
	n = num->num;
	mx = n*BIGINT_BASE_BITS;
	if (shift > mx) shift = mx;
	if (shift <= 0) return;

	// split number of shifts
	shiftn = shift / BIGINT_BASE_BITS;	// number of shifts by whole segments
	shiftb = shift & (BIGINT_BASE_BITS - 1); // number of shifts by remaining bits

	// prepare pointers
	d = &num->data[0]; // destination first segment
	s = &num->data[shiftn]; // next segment

	// shift by whole segments
	n -= shiftn;
	if (shiftb == 0)
	{
		for (i = n; i > 0; i--) *d++ = *s++;
		num->num = n;
		return;
	}

	// shift
	segL = *s;
	shiftb2 = BIGINT_BASE_BITS - shiftb;
	for (i = n - 1; i > 0; i--)
	{
		s++;
		segH = *s;
		*d++ = (segH << shiftb2) | (segL >> shiftb);
		segL = segH;
	}

	// store last segment
	segL >>= shiftb;
	*d = segL;

	num->num = n;

	// reduce
	BigIntReduce(num);
}

// ---------------------------------------------------------------------------
//                check if number is equal integer value
// ---------------------------------------------------------------------------

Bool BigIntEquInt(const bigint* num, BIGINT_BASES n)
{
	// zero
	if (n == 0) return BigIntIsZero(num);

	// number is too long
	if (num->num > 1) return False;

	// check sign
	if (n < 0)
	{
		if (!num->sign) return False;
		n = -n;
	}
	else
		if (num->sign) return False;

	// compare segment
	return (BIGINT_BASE)n == num->data[0];
}

// ---------------------------------------------------------------------------
//                             set value 0
// ---------------------------------------------------------------------------

void BigIntSet0(bigint* num)
{
	num->num = 0;
	num->sign = False;
}

// ---------------------------------------------------------------------------
//                             set value 1
// ---------------------------------------------------------------------------

void BigIntSet1(bigint* num)
{
	BigIntSetSize(num, 1);
	num->data[0] = 1;
	num->sign = False;
}

// ---------------------------------------------------------------------------
//                            set integer value
// ---------------------------------------------------------------------------

void BigIntSetInt(bigint* num, BIGINT_BASES n)
{
	Bool sign;

	if (n == 0)
		BigIntSet0(num);
	else
	{
		BigIntSetSize(num, 1);
		sign = (n < 0);
		num->sign = sign;
		if (sign) n = -n;
		num->data[0] = (BIGINT_BASE)n;
	}
}

// ---------------------------------------------------------------------------
// add/sub two numbers (this = num1 +- num2, operands and destination can be the same)
// ---------------------------------------------------------------------------

void BigIntAddSub(bigint* num, const bigint* num1, const bigint* num2, Bool sub)
{
	int n, n0, n1, n2;
	Bool sign1, sign2;
	const BIGINT_BASE *s1, *s2;
	BIGINT_BASE *d, a, b;
	u8 carry;

	// get source number of segments
	n1 = num1->num;
	n2 = num2->num;

	// num2 is zero, copy num1 to destination
	if (n2 == 0)
	{
		BigIntCopy(num, num1);
		return;
	}

	// num1 is zero, copy num2 to destination
	if (n1 == 0)
	{
		BigIntCopy(num, num2);
		if (sub) BigIntNeg(num);
		return;
	}

	// resize destination
	n = n1;
	if (n < n2) n = n2;
	if ((num != num1) && (num != num2))
		BigIntSetSize(num, n);
	else
		BigIntResize(num, n);

	// get signs
	sign1 = num1->sign;
	sign2 = num2->sign;
	if (sub) sign2 = !sign2;

	// prepare data pointers
	s1 = num1->data;
	s2 = num2->data;	
	d = num->data;

	// signs are equal, do addition (can be positive or negative)
	if (sign1 == sign2)
	{
		// set sign
		num->sign = sign1;

		// prepare length of common part
		n0 = n1;
		if (n0 > n2) n0 = n2;

		// add common part
		carry = 0;
		for (; n0 > 0; n0--)
		{
			a = *s1 + carry;
			carry = (a < carry) ? 1 : 0;
			b = *s2;
			a += b;
			carry += (a < b) ? 1 : 0;
			*d = a;
			d++;
			s1++;
			s2++;
		}

		// add rest of num1
		n0 = n1 - n2;
		for (; n0 > 0; n0--)
		{
			a = *s1 + carry;
			carry = (a < carry) ? 1 : 0;
			*d = a;
			d++;
			s1++;
		}

		// add rest of num2
		n0 = n2 - n1;
		for (; n0 > 0; n0--)
		{
			a = *s2 + carry;
			carry = (a < carry) ? 1 : 0;
			*d = a;
			d++;
			s2++;
		}

		// carry, increase size of the number
		if (carry)
		{
			BigIntResize(num, n+1);
			num->data[n] = 1;
		}
	}
	else
	{
		// if num1 is negative and num2 positive, exchange them
		if (sign1)
		{
			n1 = num2->num;
			n2 = num1->num;
			s1 = num2->data;
			s2 = num1->data;	
		}

		// prepare length of common part
		n0 = n1;
		if (n0 > n2) n0 = n2;

		// subtract num2 from num1, common part (dst = num1 - num2)
		carry = 0;
		for (; n0 > 0; n0--)
		{
			b = *s2 + carry;
			carry = (b < carry) ? 1 : 0;
			a = *s1;
			carry += (a < b) ? 1 : 0;
			*d = a - b;
			d++;
			s1++;
			s2++;
		}

		// subtract 0 from rest of num1 (dst = num1 - 0)
		n0 = n1 - n2;
		for (; n0 > 0; n0--)
		{
			b = carry;
			a = *s1;
			carry = (a < b) ? 1 : 0;
			*d = a - b;
			d++;
			s1++;
		}

		// subtract rest of num2 from 0 (dst = 0 - num2)
		n0 = n2 - n1;
		for (; n0 > 0; n0--)
		{
			b = *s2 + carry;
			carry = (b < carry) ? 1 : 0;
			carry += (0 < b) ? 1 : 0;
			*d = 0 - b;
			d++;
			s2++;
		}

		// check result sign
		num->sign = False;
		if (carry)
		{
			num->sign = True;
			d = num->data;

			// negate number - 1st step, invert segments
			for (n0 = n; n0 > 0; n0--)
			{
				*d = ~*d;
				d++;
			}

			// negate number - 2nd step, increment
			d = num->data;
			for (n0 = n; n0 > 0; n0--)
			{
				a = *d + 1;
				*d = a;
				if (a != 0) break;
				d++;
			}
		}
	}

	// reduce destination
	BigIntReduce(num);
}

// ---------------------------------------------------------------------------
// multiply two numbers (this = num1 * num2, operands and destintion can be the same)
// ---------------------------------------------------------------------------

void BigIntMul(bigint* num, const bigint* num1, const bigint* num2)
{
	int i, j, n, n1, n2;
	bigint temp;
	BIGINT_BASE a, b, *d, rH, rL, carry;
	const BIGINT_BASE *s;
	u64 k;
	Bool sign;

	// get source number of segments
	n1 = num1->num;
	n2 = num2->num;

	// some operand is zero, result will be zero
	if ((n1 == 0) || (n2 == 0))
	{
		BigIntSet0(num);
		return;
	}

	// initialize temporary number
	BigIntInit(&temp);

	// resize temporary result number
	n = n1 + n2;
	BigIntSetSize(&temp, n);

	// 1st loop - multiply and store
	a = num1->data[0];
	d = temp.data;
	s = num2->data;
	carry = 0;
	for (j = n2; j > 0; j--)
	{
		k = UMul(a, *s);
		rL = (u32)k;
		rH = (u32)(k >> 32);

		rL += carry;
		if (rL < carry) rH++;
		*d = rL;
		carry = rH;
		d++;
		s++;
	}
	*d = carry;

	// next loops - multiply and add
	for (i = 1; i < n1; i++)
	{
		a = num1->data[i];
		d = &temp.data[i];
		s = num2->data;

		carry = 0;
		for (j = n2; j > 0; j--)
		{
			k = UMul(a, *s);
			rL = (u32)k;
			rH = (u32)(k >> 32);

			rL += carry;
			if (rL < carry) rH++;
			b = *d;
			rL += b;
			*d = rL;
			if (rL < b) rH++;
			carry = rH;
			d++;
			s++;
		}
		*d = carry;
	}

	// set result data
	sign = num1->sign ^ num2->sign;
	BigIntExch(num, &temp);
	num->sign = sign;

	// terminate temporary number
	BigIntTerm(&temp);

	// reduce destination
	BigIntReduce(num);
}

// ---------------------------------------------------------------------------
// divide two numbers (this = num1 / num2, rem = remainder or NULL if not required)
// ---------------------------------------------------------------------------

void BigIntDivRem(bigint* num, const bigint* num1, const bigint* num2, bigint* rem)
{
	int n1, n2, len1, len2, res, n;
	Bool sign1, sign2;
	BIGINT_BASE a, b, c, *d, *d2, m;
	const BIGINT_BASE* s;
	bigint temp1, temp2;
	u8 carry;

	// get source number of segments
	n1 = num1->num;
	n2 = num2->num;

	// prepare result sign (sign2: result, sign1: remainder)
	sign1 = num1->sign;
	sign2 = num2->sign;
	sign2 ^= sign1;

	// some operand is 0, or abs(num1) < abs(num2) ... result will be 0 + num1
	res = BigIntCompAbs(num1, num2);
	if ((n1 == 0) || (n2 == 0) || (res < 0))
	{
		if (rem != NULL) BigIntCopy(rem, num1);
		BigIntSet0(num);
		return;
	}

	// if abs(num1) == abs(num2), result will be (-)1 + 0
	if (res == 0)
	{
		if (rem != NULL) BigIntSet0(rem);
		BigIntSet1(num);
		num->sign = sign2;
		return;
	}

// here is abs(num1) > abd(num2)

	// both numbers are small
	if ((n2 == 1) && (n1 == 1))
	{
		b = num2->data[0];
		a = num1->data[0];

		c = a / b;
		BigIntSetSize(num, 1);
		num->data[0] = c;
		num->sign = sign2;
		BigIntReduce(num);

		if (rem != NULL)
		{
			BigIntSetSize(rem, 1);
			rem->data[0] = a - c*b;
			rem->sign = sign1;
			BigIntReduce(rem);
		}
		return;
	}

	// initialize temporary numbers
	BigIntInit(&temp1);
	BigIntInit(&temp2);

	// copy operands
	BigIntCopy(&temp1, num1);
	BigIntAbs(&temp1);
	BigIntCopy(&temp2, num2);
	BigIntAbs(&temp2);

	// get bit length of numbers (here is len1 >= len2)
	len1 = BigIntBitLen(&temp1);
	len2 = BigIntBitLen(&temp2);

	// shift left num2 to the same bit position as num1
	len1 -= len2;
	len2 += len1;
	BigIntLeft(&temp2, len1);
	BigIntResize(&temp1, temp1.num+1);
	BigIntResize(&temp2, temp1.num);

	// prepare accumulator
	n = ((len1+1) + BIGINT_BASE_BITS-1)/BIGINT_BASE_BITS;
	BigIntSetSize(num, n+1);
	memset(num->data, 0, (n+1)*sizeof(BIGINT_BASE));

	// prepare destination address and mask
	d = &num->data[n-1];
	m = (BIGINT_BASE)1 << (len1 % BIGINT_BASE_BITS);

	// divide numbers (len2 = current bit length)
	for (; len1 >= 0; len1--)
	{
		// set new length of numbers
		temp1.num = (len2+1+BIGINT_BASE_BITS-1) / BIGINT_BASE_BITS;
		temp2.num = temp1.num;

		// if num1 >= num2
		if (BigIntCompAbs(&temp1, &temp2) >= 0)
		{
			// set result bit
			*d |= m;

			// subtract num2 from num1
			d2 = temp1.data;
			s = temp2.data;
			n = temp2.num;
			carry = 0;
			for (; n > 0; n--)
			{
				b = *s + carry;
				carry = (b < carry) ? 1 : 0;
				a = *d2;
				carry += (a < b) ? 1 : 0;
				*d2 = a - b;
				d2++;
				s++;
			}
		}

		// shift mask
		m >>= 1;
		if (m == 0)
		{
			d--;
			m = BIGINT_BASE_LAST;
		}

		// shift num2 1 bit right
		BigIntDiv2(&temp2);
		len2--;
	}

	// reduce result
	num->sign = sign2;
	BigIntReduce(num);

	// store remainder
	if (rem != NULL)
	{
		BigIntCopy(rem, &temp1);
		rem->sign = sign1;
		BigIntReduce(rem);
	}

	// terminate temporary numbers
	BigIntTerm(&temp1);
	BigIntTerm(&temp2);
}

// ---------------------------------------------------------------------------
//      get modulo - remainder (this = this % num, remainder will always be >= 0)
// ---------------------------------------------------------------------------

void BigIntMod(bigint* num, const bigint* num2)
{
	int res, len1, len2, n;
	BIGINT_BASE a, b, *d;
	bigint temp;
	const BIGINT_BASE* s;
	u8 carry;

	// absolute value of num
	BigIntAbs(num);

	// if abs(num1) < abs(num2), result will be num1
	res = BigIntCompAbs(num, num2);
	if (res == -1) return;

	// if abs(num1) == abs(num2), result will be 0
	if ((res == 0) || BigIntIsZero(num) || BigIntIsZero(num2))
	{
		BigIntSet0(num);
		return;
	}

// here is abs(num1) > abd(num2)

	// num2 is 1 segment
	if (num2->num == 1)
	{
		a = num2->data[0];

		// special case: num is power of 2
		if ((a & (a-1)) == 0)
		{
			num->data[0] &= (a - 1);
			num->num = 1;
			BigIntReduce(num);
			return;
		}

		// both numbers are small
		if (num->num == 1)
		{
			num->data[0] = num->data[0] % a;
			BigIntReduce(num);
			return;
		}
	}

	// initialize temporary number
	BigIntInit(&temp);

	// temporary copy of num2
	BigIntCopy(&temp, num2);
	BigIntAbs(&temp);

	// get bit length of numbers (here is len1 >= len2)
	len1 = BigIntBitLen(num);
	len2 = BigIntBitLen(&temp);

	// shift left num2 to the same bit position
	len1 -= len2;
	len2 += len1;
	BigIntLeft(&temp, len1);
	BigIntResize(&temp, temp.num+1);
	BigIntResize(num, temp.num);

	// divide numbers
	for (; len1 >= 0; len1--)
	{
		// set new length of numbers
		temp.num = (len2+1+BIGINT_BASE_BITS-1) / BIGINT_BASE_BITS;
		num->num = temp.num;

		// if num1 >= num2
		if (BigIntCompAbs(num, &temp) >= 0)
		{
			// subtract num2 from num1
			s = temp.data;
			d = num->data;
			n = temp.num;
			carry = 0;
			for (; n > 0; n--)
			{
				b = *s + carry;
				carry = (b < carry) ? 1 : 0;
				a = *d;
				carry += (a < b) ? 1 : 0;
				*d = a - b;
				d++;
				s++;
			}
		}

		// shift num2 1 bit right
		BigIntDiv2(&temp);
		len2--;
	}

	// reduce destination
	BigIntReduce(num);

	// release temporary buffer
	BigIntTerm(&temp);
}

// ---------------------------------------------------------------------------
// find greatest common divisor GCD (use binary GCD algorithm; result will always be >= 0)
// ---------------------------------------------------------------------------
// Binary GCD algorithm (Stein's algorithm) https://en.wikipedia.org/wiki/Binary_GCD_algorithm

void BigIntGCDBin(bigint* num, const bigint* num1, const bigint* num2)
{
	BIGINT_BASE a, b;
	bigint temp;
	int shift, shift2;

	// some number is 0, result will be 1
	if (BigIntIsZero(num1) || BigIntIsZero(num2))
	{
		BigIntSet1(num);
		return;
	}

	// both numbers are small, use fast integer
	if ((num1->num == 1) && (num2->num == 1))
	{
		a = num1->data[0];
		b = num2->data[0];
		for (;;)
		{
			a = a % b;
			if (a == 0)
			{
				a = b;
				break;
			}

			b = b % a;
			if (b == 0) break;
		}

		BigIntSetSize(num, 1);
		num->data[0] = a;
		num->sign = False;
		return;
	}

	// initialize temporary number
	BigIntInit(&temp);

	// copy of numbers
	BigIntCopy(&temp, num2);
	BigIntCopy(num, num1);

	// absolute value
	BigIntAbs(&temp);
	BigIntAbs(num);

	// get common divisor of 2
	shift = BigIntCtz(&temp);
	shift2 = BigIntCtz(num);

	// delete multiplies of 2
	BigIntRight(&temp, shift);
	BigIntRight(num, shift2);
	if (shift > shift2) shift = shift2;

	// search loop
	for (;;)
	{
		if (BigIntComp(num, &temp) > 0) // this > temp
		{
			BigIntSub(num, num, &temp);
			if (BigIntIsZero(num))
			{
				BigIntCopy(num, &temp);
				break;
			}
			BigIntRight(num, BigIntCtz(num));
		}
		else
		{
			BigIntSub(&temp, &temp, num);
			if (BigIntIsZero(&temp))
			{
				break;
			}
			BigIntRight(&temp, BigIntCtz(&temp));
		}
	}

	// add common divisor of 2
	BigIntLeft(num, shift);

	// terminate temporary numbers
	BigIntTerm(&temp);
}

// ---------------------------------------------------------------------------
// find greatest common divisor GCD (use Euclidean GCD algorithm; result will always be >= 0)
// ---------------------------------------------------------------------------
// Binary Euclidean algorithm https://en.wikipedia.org/wiki/Euclidean_algorithm
// https://lemire.me/blog/2013/12/26/fastest-way-to-compute-the-greatest-common-divisor/

void BigIntGCDEuc(bigint* num, const bigint* num1, const bigint* num2)
{
	BIGINT_BASE a, b;
	bigint temp;

	// some number is 0, result will be 1
	if (BigIntIsZero(num1) || BigIntIsZero(num2))
	{
		BigIntSet1(num);
		return;
	}

	// both numbers are small, use fast integer
	if ((num1->num == 1) && (num2->num == 1))
	{
		a = num1->data[0];
		b = num2->data[0];
		for (;;)
		{
			a = a % b;
			if (a == 0)
			{
				a = b;
				break;
			}

			b = b % a;
			if (b == 0) break;
		}

		BigIntSetSize(num, 1);
		num->data[0] = a;
		num->sign = False;
		return;
	}

	// initialize temporary number
	BigIntInit(&temp);

	// copy of numbers
	BigIntCopy(&temp, num2);
	BigIntCopy(num, num1);

	// absolute value
	BigIntAbs(&temp);
	BigIntAbs(num);

	// search loop
	for (;;)
	{
		// get remainder Temp2 % this
		BigIntMod(&temp, num);

		// if remainder is 0, result will be 'this'
		if (BigIntIsZero(&temp)) break;

		// get remainder this % Temp2
		BigIntMod(num, &temp);

		// if remainder is 0, result will be Temp2
		if (BigIntIsZero(num))
		{
			BigIntCopy(num, &temp);
			break;
		}
	}

	// terminate temporary numbers
	BigIntTerm(&temp);
}

// ---------------------------------------------------------------------------
//                     multiply number * 10 and add digit
// ---------------------------------------------------------------------------

void BigIntMul10(bigint* num, u16 carry)
{
	int n;
	u16 *d;
	u32 k;
	
	// expand number
	n = num->num;
	BigIntResize(num, n+1);

	// multiply loop
	d = (u16*)num->data;
	n *= 2;
	for (; n > 0; n--)
	{
		k = *d * 10 + carry;
		*d = (u16)k;
		carry = (u16)(k >> 16);
		d++;
	}
	*d = carry;

	// reduce destination
	BigIntReduce(num);
}

// ---------------------------------------------------------------------------
//              divide number / 10 and return digit
// ---------------------------------------------------------------------------

char BigIntDiv10(bigint* num)
{
	int n;
	u16* d;
	u32 a, carry;

	n = num->num;
	d = (u16*)&num->data[n];
	carry = 0;
	n *= 2;
	for (; n > 0; n--)
	{
		d--;
		carry = *d | (carry << 16);
		a = carry / 10;
		carry -= a*10;
		*d = (u16)a;
	}

	// reduce destination
	BigIntReduce(num);

	return (char)carry;
}

// ---------------------------------------------------------------------------
//             import number from ASCIIZ text
// ---------------------------------------------------------------------------

void BigIntFromText(bigint* num, const char* text)
{
	char ch;
	Bool sign;

	// clear number
	BigIntSet0(num);

	// skip spaces
	for (;;)
	{
		ch = *text++;
		if (ch == 0) return;
		if ((ch < 0) || (ch > ' ')) break;
	}
	
	// get sign
	sign = False;
	if (ch == '+') ch = *text++;
	if (ch == '-')
	{
		ch = *text++;
		sign = True;
	}	

	// add digits
	while ((ch >= '0') && (ch <= '9'))
	{
		BigIntMul10(num, ch - '0');
		ch = *text++;
	}

	// set sign
	if (!BigIntIsZero(num)) num->sign = sign;
}

// ---------------------------------------------------------------------------
//       export number to text buffer (returns number of characters)
// ---------------------------------------------------------------------------

int BigIntToText(const bigint* num, char* buf, int size)
{
	bigint temp;
	char* d;
	int n;

	// initialize temporary number
	BigIntInit(&temp);

	// backup number
	BigIntCopy(&temp, num);

	// prepare pointer to end of buffer
	d = &buf[size];
	
	// store digits
	n = 0;
	do {
		if (n >= size) break;
		d--;
		*d = BigIntDiv10(&temp) + '0';
		n++;
	} while (!BigIntIsZero(&temp));

	// store sign
	if (BigIntIsNeg(num) && (n < size))
	{
		d--;
		*d = '-';
		n++;
	}

	// shift text in buffer
	if (n < size)
	{
		memmove(buf, d, n);
		buf[n] = 0;
	}

	// terminate temporary number
	BigIntTerm(&temp);

	return n;
}

// ---------------------------------------------------------------------------
//      load table Bernoulli number - numerator (index = 0..BernMax())
// ---------------------------------------------------------------------------

void BigIntBernNum(bigint* num, int inx)
{
	// 0 -> 1
	if (inx == 0)
		BigIntSet1(num);

	// 1 -> -1 (-1/2)
	else if (inx == 1)
		BigIntSetInt(num, -1);

	// invalid index or odd index -> 0
	else if ((inx < 0) || (inx > BigIntBernMax()) || ((inx & 1) == 1))
		BigIntSet0(num);

#if BIGINT_BERN_NUM > 0		// number of table Bernoulli numbers - use number 0, 256 or 512

	// get table
	else
		BigIntCopyC(num, &bern_num[inx/2-1]);
#endif
}

// ---------------------------------------------------------------------------
// load table Bernoulli number - denominator (index = 0..BernMax() = 0..4096)
// ---------------------------------------------------------------------------

void BigIntBernDen(bigint* num, int inx)
{
	// 1 -> 2 (-1/2)
	if (inx == 1)
		BigIntSetInt(num, 2);

	// invalid index, 0 or odd index -> 1
	else if ((inx <= 0) || (inx > BigIntBernMax()) || ((inx & 1) == 1))
		BigIntSet1(num);

#if BIGINT_BERN_NUM > 0		// number of table Bernoulli numbers - use number 0, 256 or 512

	// get table
	else
		BigIntCopyC(num, &bern_den[inx/2-1]);
#endif
}

// ---------------------------------------------------------------------------
//         generate array of even Bernoulli numbers as fraction
// ---------------------------------------------------------------------------
//  n = required number of Bernoulli numbers (generate even numbers B2..B2n)
//  numer = pointer to array of 'n' bigint numbers to store result numerators
//			(GetArr function can be used to allocate arrays of bigint)
//  denom = pointer to array of 'n' bigint numbers to store result denominators
//  cb = callback function to indicate progress (NULL=not used)
// Requires '4*n+2' bigint numbers to be temporary allocated using malloc function.
// Note: B0=1 (skipped), B1=-1/2 (skipped), B2=1/6, B3=0 (skipped), B4=-1/30, B5=0 (skipped), ...

void Bernoulli(int n, bigint* numer, bigint* denom, bernoulli_cb cb)
{
	bigint *num, *den, tmp;
	u64 loops, loop;
	int j, m, inx;

	// initialize temporary
	BigIntInit(&tmp);

	// real count of numbers
	n = n*2+1;

	// allocate temporary buffers
	num = BigIntGetArr(n); // numerator
	den = BigIntGetArr(n); // denominator

	// total number of loops
	loops = (u64)n*(n+1)/2;
	loop = 0;	
	if (cb != NULL) cb(0);

	// local variables
	inx = 0; // destination index

	// first entry = 1
	BigIntSet1(&num[0]);
	BigIntSet1(&den[0]);

	// main iteration loop
	for (m = 1; m < n; m++)
	{
		// num[m] = 1; den[m] = m+1
		BigIntSet1(&num[m]);
		BigIntSetInt(&den[m], m+1);

		for (j = m; j >= 1; j--)
		{
			// num[j-1] = num[j-1] * den[j]
			BigIntMul(&num[j-1], &num[j-1], &den[j]);

			// num[j-1] = num[j-1] - num[j]*den[j-1]
			BigIntMul(&tmp, &num[j], &den[j-1]);
			BigIntSub(&num[j-1], &num[j-1], &tmp);

			// den[j-1] = den[j-1] * den[j]
			BigIntMul(&den[j-1], &den[j-1], &den[j]);

			// num[j-1] = num[j-1] * j
			BigIntSetInt(&tmp, j);
			BigIntMul(&num[j-1], &num[j-1], &tmp);

			// divide by greatest common divisor of num[j-1] and den[j-1]
			BigIntGCD(&tmp, &num[j-1], &den[j-1]);
			if (!BigIntEquInt(&tmp, 1))
			{
				BigIntDiv(&num[j-1], &num[j-1], &tmp);
				BigIntDiv(&den[j-1], &den[j-1], &tmp);
			}

			// progress
			if (cb != NULL)
			{
				loop++;
				if ((loop & 0x1ff) == 0) cb((int)(loop*1000/loops));
			}
		}

		// store result
		if ((m & 1) == 0)
		{
			BigIntCopy(&numer[inx], &num[0]);
			BigIntCopy(&denom[inx], &den[0]);
			inx++;
		}
	}

	if (cb != NULL) cb(1000);

	// release buffers
	BigIntFreeArr(num, n);
	BigIntFreeArr(den, n);

	// terminate temporary
	BigIntTerm(&tmp);
}

/*
// Test Bernoulli generator with s64
s64 GCD64(s64 a, s64 b)
{
	// some number is 0, result will be 1
	if ((a == 0) || (b == 0)) return 1;

	if (a < 0) a = -a;
	if (b < 0) b = -b;

	for (;;)
	{
		a = a % b;
		if (a == 0) return b;

		b = b % a;
		if (b == 0) return a;
	}
}

void Bernoulli64(int n, s64* numer, s64* denom)
{
	s64 *num, *den, tmp;
	int j, m, inx;

	// real count of numbers
	n = n*2+1;

	// allocate temporary buffers
	num = (s64*)malloc(n*sizeof(s64)); // numerator
	den = (s64*)malloc(n*sizeof(s64)); // denominator

	// local variables
	inx = 0; // destination index

	// first entry = 1
	num[0] = 1;
	den[0] = 1;

	// main iteration loop
	for (m = 1; m < n; m++)
	{
		// num[m] = 1; den[m] = m+1
		num[m] = 1;
		den[m] = m+1;

		for (j = m; j >= 1; j--)
		{
			// num[j-1] = num[j-1] * den[j]
			num[j-1] = num[j-1] * den[j];

			// num[j-1] = num[j-1] - num[j]*den[j-1]
			tmp = num[j] * den[j-1];
			num[j-1] = num[j-1] - tmp;

			// den[j-1] = den[j-1] * den[j]
			den[j-1] = den[j-1] * den[j];

			// num[j-1] = num[j-1] * j
			num[j-1] = num[j-1] * j;

			// divide by greatest common divisor of num[j-1] and den[j-1]
			tmp = GCD64(num[j-1], den[j-1]);
			if (tmp != 1)
			{
				num[j-1] = num[j-1] / tmp;
				den[j-1] = den[j-1] / tmp;
			}
		}

		// store result
		if ((m & 1) == 0)
		{
			numer[inx] = num[0];
			denom[inx] = den[0];
			inx++;
		}
	}

	// release buffers
	free(num);
	free(den);
}
*/

#endif // USE_BIGINT		// use Big Integers (bigint.c, bigint.h)

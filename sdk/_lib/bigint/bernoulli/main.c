// Generator of Bernoulli numbers, used by linear factorials.
// - Project of MS VC++ 2005 (for Windows)

// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "include.h"

char EditBuf[EDITBUF_MAX+1]; // edit buffer

// Bernoulli progress
void BernCB(int permille)
{
	fprintf(stderr, "\rBernoulli: %d.%d%% ", permille/10, permille % 10);
}

// get number of leading zeros of u32 number
u8 clz(u32 val)
{
	u8 i = 32;
	if (val >= 0x10000) { i = 16; val >>= 16; }
	if (val >= 0x100) { i -= 8; val >>= 8; }
	if (val >= 0x10) { i -= 4; val >>= 4; }
	if (val >= 4) { i -= 2; val >>= 2; }
	if (val >= 2) { i -= 1; val >>= 1; }
	if (val >= 1) i--;
	return i;
}

// count trailing zeros
u8 ctz(u32 val)
{
	u8 i = 0;
	if ((val & 0xffff) == 0) { i = 16; val >>= 16; }
	if ((val & 0xff) == 0) { i += 8; val >>= 8; }
	if ((val & 0xf) == 0) { i += 4; val >>= 4; }
	if ((val & 3) == 0) { i += 2; val >>= 2; }
	if ((val & 1) == 0) { i += 1; }
	return i;
}

// get number of leading zeros of u64 number
u8 clz64(u64 num)
{
	if (num >= 0x100000000ULL)
		return clz((u32)(num >> 32));
	else
		return clz((u32)num) + 32;
}

// Divide modulo unsigned U32
u32 DivModU32(u32 a, u32 b, u32* rem)
{
	u32 c = a/b;
	*rem = a - c*b;
	return c;
}

// Unsigned multiply u32*u32 with result u64
u64 UMul(u32 a, u32 b)
{
	return (u64)a*b;
}

// generate Bernoulli numbers
void GenBern(int bernnum)
{
	bigint *num, *den;
	int i, j, n;
	FILE* f;

// === generate Bernoulli numbers

	num = BigIntGetArr(bernnum);
	den = BigIntGetArr(bernnum);
	Bernoulli(bernnum, num, den, BernCB);

// === generate C file

	f = fopen("bernoulli.c", "w");
	if (f == NULL) fprintf(stderr, "Error opening output file Bernoulli.c\n");

	fprintf(f, "\n// ****************************************************************************\n");
	fprintf(f, "//\n");
	fprintf(f, "//                           Bernoulli numbers\n");
	fprintf(f, "//\n");
	fprintf(f, "// ****************************************************************************\n");
	fprintf(f, "//#define BIGINT_BERN_NUM %d	// number of table Bernoulli numbers (only even numbers B2, B4,..)\n", bernnum);
	fprintf(f, "\n");
	fprintf(f, "//Big integer - constant\n");
	fprintf(f, "//typedef struct\n");
	fprintf(f, "//{\n");
	fprintf(f, "//\tconst u32*\tdata;\t// array of segments\n");
	fprintf(f, "//\tint\t\t\tnum;\t// number of segments (0=zero number)\n");
	fprintf(f, "//\tBool\t\tsign;\t// sign flag\n");
	fprintf(f, "//} cbigint;\n");
	fprintf(f, "\n");
	fprintf(f, "#ifdef GENERATOR\n");
	fprintf(f, "#include \"bernoulli/include.h\"\n");
	fprintf(f, "#else\n");
	fprintf(f, "#include \"../include.h\"\n");
	fprintf(f, "#endif\n");

	// write numerators - data
	fprintf(f, "\n// Bernoulli numbers - numerators, data\n");
	for (i = 0; i < bernnum; i++)
	{
		n = num[i].num;
		fprintf(f, "const u32 bern_num_data%d[%d] = { ", i, n);
		for (j = 0; j < n-1; j++) fprintf(f, "0x%.8x, ", num[i].data[j]);
		fprintf(f, "0x%.8x };\n", num[i].data[j]);
	}

	// write numerators - headers
	fprintf(f, "\n// Bernoulli numbers - numerators, headers\n");
	fprintf(f, "const cbigint bern_num[BIGINT_BERN_NUM] = { // BIGINT_BERN_NUM=%d\n", bernnum);
	for (i = 0; i < bernnum; i++)
	{
		n = num[i].num;
		BigIntToText(&num[i], EditBuf, EDITBUF_MAX);
		fprintf(f, "\t{ bern_num_data%d, %d, %d },\t// B%d: %s\n", i, n, num[i].sign, i*2+2, EditBuf);
	}
	fprintf(f, "};\n");

	// write denominators - data
	fprintf(f, "\n// Bernoulli numbers - denominators, data\n");
	for (i = 0; i < bernnum; i++)
	{
		n = den[i].num;
		fprintf(f, "const u32 bern_den_data%d[%d] = { ", i, n);
		for (j = 0; j < n-1; j++) fprintf(f, "0x%.8x, ", den[i].data[j]);
		fprintf(f, "0x%.8x };\n", den[i].data[j]);
	}

	// write denominators - headers
	fprintf(f, "\n// Bernoulli numbers - denominators, headers\n");
	fprintf(f, "const cbigint bern_den[BIGINT_BERN_NUM] = { // BIGINT_BERN_NUM=%d\n", bernnum);
	for (i = 0; i < bernnum; i++)
	{
		n = den[i].num;
		BigIntToText(&den[i], EditBuf, EDITBUF_MAX);
		fprintf(f, "\t{ bern_den_data%d, %d, %d },\t// B%d: %s\n", i, n, den[i].sign, i*2+2, EditBuf);
	}
	fprintf(f, "};\n");

	fclose(f);

// === generate csv file

	f = fopen("bernoulli.csv", "w");
	if (f == NULL) fprintf(stderr, "Error opening output file Bernoulli.csv\n");

	fprintf(f, "0,1,1\n1,-1,2\n");

	for (i = 0; i < bernnum; i++)
	{
		BigIntToText(&num[i], EditBuf, EDITBUF_MAX);
		fprintf(f, "%d,%s,", i*2+2, EditBuf);
		BigIntToText(&den[i], EditBuf, EDITBUF_MAX);
		fprintf(f, "%s\n", EditBuf);
	}

	fclose(f);

	// destroy buffers
	BigIntFreeArr(num, bernnum);
	BigIntFreeArr(den, bernnum);
}

int main(int argc, char* argv[])
{
	// generate Bernoulli numbers
	GenBern(BIGINT_BERN_NUM);
	return 0;
}

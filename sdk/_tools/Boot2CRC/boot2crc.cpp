#include <stdio.h>
#include <string.h>

#pragma warning(disable : 4996) // function not safe

typedef unsigned char       u8;
typedef unsigned int        u32;

u32 rev(u32 n)
{
	return ((n & 0xff) << 24) | ((n & 0xff00) << 8) | ((n & 0xff0000) >> 8) | ((n & 0xff000000) >> 24);
}

// simulate function from bootrom_misc.S (not real right crc32 calculation)
u32 crc32(const u8* r0, u32 r1)
{
	u32 r2 = 0xffffffff;
	u32 r3;
	u32 r4;
	u32 r5 = 0x04c11db7;
	for (; r1 > 0; r1--)
	{
		r4 = *r0;
		r3 = rev(r2);
		r4 ^= r3;
		r4 <<= 24;

		for (r3 = 8; r3 > 0; r3--)
		{
			if ((r4 & 0x80000000) != 0)
			{
				r4 <<= 1;
				r4 ^= r5;
			}
			else
				r4 <<= 1;
		}

		r2 <<= 8;
		r2 ^= r4;
		r0++;
	}

	return r2;
}

int main(int argc, char* argv[])
{
	if (argc != 2)
	{
		printf("Syntax: boot2crc bootfile.bin\n");
		return 1;
	}

	u8 buf[256];
	memset(buf, 0, 256);
	FILE* f = fopen(argv[1], "rb");
	if (f == NULL)
	{
		printf("File %s not found\n", argv[1]);
		return 1;
	}

	size_t n = fread(buf, 1, 256, f);
	if ((n > 252) || (n < 4))
	{
		printf("Incorrect %s file size\n", argv[1]);
		return 1;
	}
	fclose(f);

	u32 crc = crc32(buf, 252);
	*(u32*)&buf[256-4] = crc;

	f = fopen(argv[1], "wb");
	if (f == NULL)
	{
		printf("Cannot open %s for write\n", argv[1]);
		return 1;
	}

	n = fwrite(buf, 1, 256, f);
	if (n != 256)
	{
		printf("Cannot write to %s\n", argv[1]);
		return 1;
	}
	fclose(f);

	printf("// ****************************************************************************\n");
	printf("//\n");
	printf("//                                Boot 2nd stage\n");
	printf("//\n");
	printf("// ****************************************************************************\n");
	printf("// Do not modify - auto generated\n");
	printf("\n");
	printf("\t.thumb\t\t\t// use 16-bit ARM instructions\n");
	printf("\t.section .boot2,\"ax\"\t// boot2 code section\n");
	printf("\t.syntax unified\n");
	printf("\t.cpu cortex-m0plus\n");
	printf("\n");

	int i;
	u32* s = (u32*)buf;
	for (i = 256/4; i > 0; i--) printf("\t.word\t0x%08x\n", *s++);

	return 0;
}

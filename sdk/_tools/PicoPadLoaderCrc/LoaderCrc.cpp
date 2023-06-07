#include <stdio.h>
#include <string.h>
#include <malloc.h>

#pragma warning(disable : 4996) // function not safe

typedef unsigned char       u8;
typedef unsigned int        u32;

#define LOADER_SIZE	0x8000
u8* Buf = NULL;
int BufNum;

u32 rev(u32 n)
{
	return ((n & 0xff) << 24) | ((n & 0xff00) << 8) | ((n & 0xff0000) >> 8) | ((n & 0xff000000) >> 24);
}

// simulate function from bootrom_misc.S
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
	if (argc != 3)
	{
		printf("Syntax: LoaderCrc program.bin program.uf2\n");
		return 1;
	}

	// open input file
	FILE* f = fopen(argv[1], "rb");
	if (f == NULL)
	{
		printf("File %s not found\n", argv[1]);
		return 1;
	}

	// get file size
	fseek(f, 0, SEEK_END);
	u32 size = (u32)ftell(f);
	fseek(f, 0, SEEK_SET);
	if (size <= LOADER_SIZE+51*4)
	{
		printf("Incorrect %s file size\n", argv[1]);
		fclose(f);
		return 1;
	}

	// create file buffer
	Buf = (u8*)malloc(size);
	if (Buf == NULL)
	{
		printf("Memory error\n");
		fclose(f);
		return 1;
	}

	// load file
	u32 n = (u32)fread(Buf, 1, size, f);
	if (n != size)
	{
		printf("Cannot load file %s\n", argv[1]);
		return 1;
	}
	fclose(f);

	// check header
	u32* h = (u32*)&Buf[LOADER_SIZE + 48*4]; // end of vector table
	if ((h[0] != 0x44415050) // magic "PPAD"
		|| (h[1] != 0x01234567) // application length
		|| (h[2] != 0x89ABCDEF)) // application CRC
	{
		printf("Incorrect format of %s\n", argv[1]);
		return 1;
	}

	// calculate CRC
	size -= LOADER_SIZE + 51*4; // rest of application
	h[1] = size;	// set size of rest of application
	u32 crc = crc32(&Buf[LOADER_SIZE + 51*4], size); // calculate CRC of rest of application
	h[2] = crc;

	// open for write
	f = fopen(argv[1], "r+b");
	if (f == NULL)
	{
		printf("Cannot open %s for write\n", argv[1]);
		return 1;
	}

	// write new header
	fseek(f, LOADER_SIZE + 49*4, SEEK_SET);
	n = (u32)fwrite(&Buf[LOADER_SIZE + 49*4], 1, 2*4, f);
	if (n != 2*4)
	{
		printf("Cannot write to %s\n", argv[1]);
		return 1;
	}
	fclose(f);

	// open 2nd file
	f = fopen(argv[2], "r+b");
	if (f == NULL)
	{
		printf("Cannot open %s for write\n", argv[2]);
		return 1;
	}

	// load header
	fseek(f, 2*LOADER_SIZE + 32 + 48*4, SEEK_SET);
	u32 h2[3];
	n = (u32)fread(h2, 1, 3*4, f);
	if (n != 3*4)
	{
		printf("Cannot read from %s\n", argv[2]);
		return 1;
	}

	// check header
	if ((h2[0] != 0x44415050) // magic "PPAD"
		|| (h2[1] != 0x01234567) // application length
		|| (h2[2] != 0x89ABCDEF)) // application CRC
	{
		printf("Incorrect format of %s\n", argv[2]);
		return 1;
	}

	// write new header
	fseek(f, 2*LOADER_SIZE + 32 + 49*4, SEEK_SET);
	n = (u32)fwrite(&Buf[LOADER_SIZE + 49*4], 1, 2*4, f);
	if (n != 2*4)
	{
		printf("Cannot write to %s\n", argv[2]);
		return 1;
	}
	fclose(f);

	return 0;
}

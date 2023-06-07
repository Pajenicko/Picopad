#include <stdio.h>
#include <string.h>

#pragma warning(disable : 4996) // function not safe

typedef unsigned char       u8;
typedef unsigned int        u32;

#define LOADER_SIZE	0x8000
u8 Buf[LOADER_SIZE+4];

int main(int argc, char* argv[])
{
	if (argc != 3)
	{
		printf("Syntax: LoaderBin loader.bin loader_bin.S\n");
		return 1;
	}

	FILE* f = fopen(argv[1], "rb");
	if (f == NULL)
	{
		printf("File %s not found\n", argv[1]);
		return 1;
	}

	memset(Buf, 0xff, LOADER_SIZE);
	size_t n = fread(Buf, 1, LOADER_SIZE+4, f);
	if ((n > LOADER_SIZE) || (n < 4))
	{
		printf("Incorrect %s file size\n", argv[1]);
		return 1;
	}
	fclose(f);

	f = fopen(argv[2], "wb");
	if (f == NULL)
	{
		printf("Cannot open %s for write\n", argv[2]);
		return 1;
	}

	fprintf(f, "// ****************************************************************************\n");
	fprintf(f, "//\n");
	fprintf(f, "//                                PicoPad Boot Loader\n");
	fprintf(f, "//\n");
	fprintf(f, "// ****************************************************************************\n");
	fprintf(f, "// Do not modify - auto generated\n");
	fprintf(f, "\n");
	fprintf(f, "\t.thumb\t\t\t// use 16-bit ARM instructions\n");
	fprintf(f, "\t.section .boot2,\"ax\"\t// boot2 code section\n");
	fprintf(f, "\t.syntax unified\n");
	fprintf(f, "\t.cpu cortex-m0plus\n");
	fprintf(f, "\n");

	int i;
	u32* s = (u32*)Buf;
	for (i = LOADER_SIZE/4; i > 0; i--) fprintf(f, "\t.word\t0x%08x\n", *s++);

	fclose(f);

	return 0;
}

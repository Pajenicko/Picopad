// Images for PicoPad

#include <stdio.h>
#include <windows.h>

#pragma warning(disable : 4996) // unsafe fopen

typedef signed char s8;
typedef unsigned char u8;
typedef signed short s16;
typedef unsigned short u16;
typedef signed long int s32;
typedef unsigned long int u32;

#pragma pack(push,1)
typedef struct _bmpBITMAPFILEHEADER { // 14 bytes
		u16		bfType;
		u32		bfSize;
		u16		bfReserved1;
		u16		bfReserved2;
		u32		bfOffBits;
} bmpBITMAPFILEHEADER;

typedef struct _bmpBITMAPINFOHEADER{ // 40 bytes at offset 0x0E
		u32		biSize;
		s32		biWidth;
		s32		biHeight;
		u16		biPlanes;
		u16		biBitCount;
		u32		biCompression;
		u32		biSizeImage;
		s32		biXPelsPerMeter;
		s32		biYPelsPerMeter;
		u32		biClrUsed;
		u32		biClrImportant;
		// palettes at offset 54 = 0x36
} bmpBITMAPINFOHEADER;
#pragma pack(pop)

#define bmpBI_RGB	0
#define bmpBI_RLE8	1
#define bmpBI_RLE4	2

u8* Img = NULL; // input file buffer
int W,H,WB; // input file width and height
int B; // bit count
u8* D; // start of image line

// RLE compression
BOOL Rle; // flag - do RLE compression
u8* RleBuf; // RLE buffer with compressed image
u8* RleDst; // RLE destination pointer
int RleNum;	// size of data in RLE buffer, counter of RLE equal pixels
int RawNum; // counter of raw pixels
u8* RawStart; // start of raw data
u8 RlePix; // last RLE pixel

// write byte into RLE buffer
void WriteByte(u8 b)
{
	*RleDst++ = b;
}

// flush RAW string
void FlushRaw()
{
	while (RawNum > 0)
	{
		// prepare length of one sub-string
		int rawnum = RawNum;
		if (rawnum > 128) rawnum = 128;
		RawNum -= rawnum;

		// write raw pixels (flag byte: 0..127 means 1..128 raw pixels)
		WriteByte(rawnum-1); // number of pixels
		for (; rawnum > 0; rawnum--) WriteByte(*RawStart++);
	}
}

// flush RLE string
void FlushRle()
{
	while (RleNum > 0)
	{
		// prepare lenth of one sub-string
		int rlenum = RleNum;
		if (rlenum > 130) rlenum = 130;
		RleNum -= rlenum;

		// convert short RLE string to RAW string
		if (rlenum < 3)
		{
			RawNum += rlenum;
		}

		// write long RLE string
		else
		{
			// at first, flush RAW string
			FlushRaw();

			// write RLE string (flag byte: 128..255 means 3..130 raw pixels)
			WriteByte((rlenum-3)+128); // number of pixels
			WriteByte(RlePix); // write RLE pixel

			// shift RAW start
			RawStart += rlenum;
		}
	}
}

// do RLE compression
void DoRle()
{
	u8 c;
	int i, j;
	u8* s = D;
	RleDst = RleBuf;	// destination pointer	
	RleNum = 0; // reset counter of equal pixels
	RawNum = 0; // reset counter of raw pixels

	for (i = 0; i < H; i++)
	{
		RawStart = s; // start of RAW string

		for (j = 0; j < W; j++)
		{
			// load next pixel
			c = s[j];

			// flush RLE if cannot repeat
			if ((RleNum > 0) && (c != RlePix))
			{
				FlushRle();
			}

			// increase RLE
			RlePix = c;
			RleNum++;
		}

		// flush strings on end of row
		FlushRle();
		FlushRaw();
		s += WB;
	}

	// number of bytes in buffer
	RleNum = (int)(RleDst - RleBuf);
}

// flush RAW4 string
void FlushRaw4()
{
	while (RawNum > 0)
	{
		// prepare length of one sub-string
		int rawnum = RawNum;
		if (rawnum > 8) rawnum = 8;
		RawNum -= rawnum;

		// write raw pixels (flag byte: 0..7 means 1..8 raw pixels)
		WriteByte(rawnum-1); // number of pixels
		for (; rawnum > 0; rawnum--) WriteByte(*RawStart++);
	}
}

// flush RLE4 string
void FlushRle4()
{
	while (RleNum > 0)
	{
		// prepare lenth of one sub-string
		int rlenum = RleNum;
		if (rlenum > 10) rlenum = 10;
		RleNum -= rlenum;

		// convert short RLE string to RAW string
		if (rlenum < 3)
		{
			RawNum += rlenum;
		}

		// write long RLE string
		else
		{
			// at first, flush RAW string
			FlushRaw4();

			// write RLE string (flag byte: 8..15 means 3..10 raw pixels)
			WriteByte((rlenum-3)+8); // number of pixels
			WriteByte(RlePix); // write RLE pixel

			// shift RAW start
			RawStart += rlenum;
		}
	}
}

// do RLE4 compression
void DoRle4()
{
	u8 c;
	int i, j;
	u8* s = D;
	RleDst = RleBuf;	// destination pointer	
	RleNum = 0; // reset counter of equal pixels
	RawNum = 0; // reset counter of raw pixels

	for (i = 0; i < H; i++)
	{
		RawStart = s; // start of RAW string

		for (j = 0; j < W; j++)
		{
			// load next pixel
			c = s[j];

			// flush RLE if cannot repeat
			if ((RleNum > 0) && (c != RlePix))
			{
				FlushRle4();
			}

			// increase RLE
			RlePix = c;
			RleNum++;
		}

		// flush strings on end of row
		FlushRle4();
		FlushRaw4();
		s += WB*2;
	}

	// number of bytes in buffer
	RleNum = (int)(RleDst - RleBuf);
}

// unpack 4-bit image
void Unpack4()
{
	u8* s = &D[WB*H];
	u8* d = &D[WB*2*H];
	int i;
	for (i = WB*H; i > 0; i--)
	{
		d--;
		s--;
		*d = *s & 0x0f;
		d--;
		*d = *s >> 4;
	}
}

// main function
int main(int argc, char* argv[])
{
	// check syntax
	if ((argc != 4) && (argc != 5))
	{
		printf("Syntax: input.bmp output.c name [r]\n");
		printf("    'r' is optional and means to use");
		printf("    RLE compression for 8-bit or 4-bit format");
		return 1;
	}

	// use RLE compression
	Rle = (argc == 5);

// === read input file

	// open main input file
	FILE* f = fopen(argv[1], "rb");
	if (f == NULL)
	{
		printf("Error opening %s\n", argv[1]);
		return 1;
	}

	// size of input file
	fseek(f, 0, SEEK_END);
	int size = ftell(f);
	fseek(f, 0, SEEK_SET);
	if (size < 40)
	{
		printf("Incorrect size of %s\n", argv[1]);
		return 1;
	}

	// create buffer
	Img = (u8*)malloc(size*2);
	if (Img == NULL)
	{
		printf("Memory error\n");
		return 1;
	}

	// read file
	int size2 = (int)fread(Img, 1, size, f);
	fclose(f);
	if (size2 != size)
	{
		printf("Error reading %s\n", argv[1]);
		return 1;
	}

	// check BMP header
	bmpBITMAPFILEHEADER* bmf = (bmpBITMAPFILEHEADER*)Img;
	bmpBITMAPINFOHEADER* bmi = (bmpBITMAPINFOHEADER*)&bmf[1];
	W = bmi->biWidth;
	H = bmi->biHeight;
	B = bmi->biBitCount;
	if (H < 0) H = -H;
	if ((bmf->bfType != 0x4d42) ||
		(bmf->bfOffBits < 0x30) || (bmf->bfOffBits > 0x440) ||
		(bmi->biCompression != bmpBI_RGB) ||
		(W < 4) || (W > 10000) || (H < 4) || (H > 10000) ||
		((B != 24) && (B != 8) && (B != 4) && (B != 1)))
	{
		printf("Incorrect format of input file %s,\n", argv[1]);
		printf("  must be 24-bit, 8-bit, 4-bit or 1-bit uncompressed.\n");
		return 1;
	}
	D = &Img[bmf->bfOffBits];

// === save output file

	// open output file
	f = fopen(argv[2], "wb");
	if (f == NULL)
	{
		printf("Error creating %s\n", argv[2]);
		return 1;
	}

	// save header
	int i, j, n;
	WB = (((W*B+7)/8) + 3)& ~3;

	// 1-bit image
	if (B == 1)
	{
		// info header
		fprintf(f, "#include \"../include.h\"\n\n");
		fprintf(f, "// format: 1-bit pixel graphics\n");
		fprintf(f, "// image width: %d pixels\n", W);
		fprintf(f, "// image height: %d lines\n", H);
		fprintf(f, "// image pitch: %d bytes\n", (W+7)/8);

		// image header
		fprintf(f, "const u8 %s[%d] __attribute__ ((aligned(4))) = {", argv[3], (W+7)/8*H);

		// load image
		n = 0;
		for (i = 0; i < H; i++)
		{
			for (j = 0; j < (W+7)/8; j++)
			{
				if ((n & 0x0f) == 0) fprintf(f, "\n\t");
				fprintf(f, "0x%02X, ", D[j]);
				n++;
			}
			D += WB;
		}
	}

	// paletted 4-bit image
	else if (B == 4)
	{
		// do RLE compression
		RleBuf = NULL;
		RleNum = 0;
		if (Rle)
		{
			// prepare RLE buffer
			RleBuf = (u8*)malloc(W*2*H);
			if (RleBuf == NULL)
			{
				printf("Memory error\n");
				return 1;
			}

			// do compression
			Unpack4();
			DoRle4();
		}

		// info header
		fprintf(f, "#include \"../include.h\"\n\n");
		if (Rle)
			fprintf(f, "// format: compressed 4-bit paletted pixel graphics\n");
		else
			fprintf(f, "// format: 4-bit paletted pixel graphics\n");
		fprintf(f, "// image width: %d pixels\n", W);
		fprintf(f, "// image height: %d lines\n", H);
		fprintf(f, "// image pitch: %d bytes\n", (W+1)/2);

		// palette header
		u8* pal = (u8*)&bmi[1];
		int palN = bmi->biClrUsed;
		if (palN == 0) palN = 16;
		if (palN > 16) palN = 16;
		fprintf(f, "const u16 %s_Pal[%d] __attribute__ ((aligned(4))) = {", argv[3], palN);

		// load palettes
		n = 0;
		for (i = 0; i < palN; i++)
		{
			if ((n & 0x0f) == 0) fprintf(f, "\n\t");
			u8 blue = pal[0];
			u8 green = pal[1];
			u8 red = pal[2];
			u16 b = (blue >> 3) | ((green >> 2) << 5) | ((red >> 3) << 11);
			fprintf(f, "0x%04X, ", b);
			n++;
			pal += 4;
		}

		// compressed image
		if (Rle)
		{
			// image header
			fprintf(f, "\n};\n\nconst u8 %s[%d] __attribute__ ((aligned(4))) = {", argv[3], (RleNum+1)/2);

			// load image
			n = 0;
			u8* s = RleBuf;
			for (i = 0; i < RleNum; i += 2)
			{
				if ((n & 0x0f) == 0) fprintf(f, "\n\t");
				u8 bb = *s++ << 4;
				bb |= *s++;
				fprintf(f, "0x%02X, ", bb);
				n++;
			}
		}

		// uncompressed image
		else
		{
			// image header
			fprintf(f, "\n};\n\nconst u8 %s[%d] __attribute__ ((aligned(4))) = {", argv[3], (W+1)/2*H);

			// load image
			n = 0;
			for (i = 0; i < H; i++)
			{
				for (j = 0; j < (W+1)/2; j++)
				{
					if ((n & 0x0f) == 0) fprintf(f, "\n\t");
					fprintf(f, "0x%02X, ", D[j]);
					n++;
				}
				D += WB;
			}
		}

		free(RleBuf);
	}

	// paletted 8-bit image
	else if (B == 8)
	{
		// do RLE compression
		RleBuf = NULL;
		RleNum = 0;
		if (Rle)
		{
			// prepare RLE buffer
			RleBuf = (u8*)malloc(W*2*H);
			if (RleBuf == NULL)
			{
				printf("Memory error\n");
				return 1;
			}

			// do compression
			DoRle();
		}

		// info header
		fprintf(f, "#include \"../include.h\"\n\n");
		if (Rle)
			fprintf(f, "// format: compressed 8-bit paletted pixel graphics\n");
		else
			fprintf(f, "// format: 8-bit paletted pixel graphics\n");
		fprintf(f, "// image width: %d pixels\n", W);
		fprintf(f, "// image height: %d lines\n", H);
		fprintf(f, "// image pitch: %d bytes\n", W);

		// palette header
		u8* pal = (u8*)&bmi[1];
		int palN = bmi->biClrUsed;
		if (palN == 0) palN = 256;
		fprintf(f, "const u16 %s_Pal[%d] __attribute__ ((aligned(4))) = {", argv[3], palN);

		// load palettes
		n = 0;
		for (i = 0; i < palN; i++)
		{
			if ((n & 0x0f) == 0) fprintf(f, "\n\t");
			u8 blue = pal[0];
			u8 green = pal[1];
			u8 red = pal[2];
			u16 b = (blue >> 3) | ((green >> 2) << 5) | ((red >> 3) << 11);
			fprintf(f, "0x%04X, ", b);
			n++;
			pal += 4;
		}

		// compressed image
		if (Rle)
		{
			// image header
			fprintf(f, "\n};\n\nconst u8 %s[%d] __attribute__ ((aligned(4))) = {", argv[3], RleNum);

			// load image
			n = 0;
			u8* s = RleBuf;
			for (i = 0; i < RleNum; i++)
			{
				if ((n & 0x0f) == 0) fprintf(f, "\n\t");
				fprintf(f, "0x%02X, ", *s++);
				n++;
			}
		}

		// uncompressed image
		else
		{
			// image header
			fprintf(f, "\n};\n\nconst u8 %s[%d] __attribute__ ((aligned(4))) = {", argv[3], W*H);

			// load image
			n = 0;
			for (i = 0; i < H; i++)
			{
				for (j = 0; j < W; j++)
				{
					if ((n & 0x0f) == 0) fprintf(f, "\n\t");
					fprintf(f, "0x%02X, ", D[j]);
					n++;
				}
				D += WB;
			}
		}

		free(RleBuf);
	}

	// 16-bit image
	else
	{
		// info header
		fprintf(f, "#include \"../include.h\"\n\n");
		fprintf(f, "// format: 16-bit pixel graphics\n");
		fprintf(f, "// image width: %d pixels\n", W);
		fprintf(f, "// image height: %d lines\n", H);
		fprintf(f, "// image pitch: %d bytes\n", W*2);
		fprintf(f, "const u16 %s[%d] __attribute__ ((aligned(4))) = {", argv[3], W*H);

		// load image
		n = 0;
		for (i = 0; i < H; i++)
		{
			for (j = 0; j < W; j++)
			{
				if ((n & 0x0f) == 0) fprintf(f, "\n\t");
				u8 blue = D[j*3];
				u8 green = D[j*3+1];
				u8 red = D[j*3+2];
				u16 b = (blue >> 3) | ((green >> 2) << 5) | ((red >> 3) << 11);
				fprintf(f, "0x%04X, ", b);
				n++;
			}
			D += WB;
		}
	}

	fprintf(f, "\n};\n");

	fclose(f);
	free(Img);

	return 0;
}


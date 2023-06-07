
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

#define LINENUM	50	// number of lines
#define SPEEDMIN 2.0f	// minimal speed
#define SPEEDMAX 7.0f	// maximal speed
#define LENMIN	40	// minimal length of color
#define LENMAX	200	// maximal length of color
#define LEVMIN	(3*80)	// minimal bright level

// coordinates
enum {
	C_X1 = 0,
	C_Y1,
	C_X2,
	C_Y2,

	C_NUM		// number of coordinates
};

// current coordinate of the head
float Coord[C_NUM];	// coordinate
u16 CoordMax[C_NUM];	// max. coordinate
float Delta[C_NUM];	// delta
u8 R, G, B;

// length of color segment
int ColLen;

// lines
typedef struct {
	u8	r, g, b;	// line color
	int	coord[C_NUM];	// line coordinates
} sLine;

sLine	Lines[LINENUM];	// list of lines
int Head;		// head index

int main()
{
	int i, j, k, rr, gg, bb;
	sLine* line;

	// initialize line head to random position and color
	CoordMax[C_X1] = WIDTH-1;
	CoordMax[C_Y1] = HEIGHT-1;
	CoordMax[C_X2] = WIDTH-1;
	CoordMax[C_Y2] = HEIGHT-1;

	for (i = 0; i < C_NUM; i++)
	{
		Coord[i] = RandU16Max(CoordMax[i]);
		Delta[i] = RandFloatMinMax(SPEEDMIN, SPEEDMAX);
		if ((RandU8() & 1) != 0) Delta[i] = -Delta[i];
	}

	do {
		R = RandU8();
		G = RandU8();
		B = RandU8();
	} while (R+G+B < LEVMIN);
	Head = 0;

	ColLen = RandU8MinMax(LENMIN,LENMAX);
	memset(Lines, 0, sizeof(Lines));

	// main loop
	while (True)
	{
		// draw lines
		j = Head;
		for (i = 0; i < LINENUM; i++)
		{
			// pointer to the line
			line = &Lines[j];

			// calculate color components
			rr = (int)((float)line->r * i / (LINENUM-1) + 0.5f);
			if (rr > 255) rr = 255;

			gg = (int)((float)line->g * i / (LINENUM-1) + 0.5f);
			if (gg > 255) gg = 255;

			bb = (int)((float)line->b * i / (LINENUM-1) + 0.5f);
			if (bb > 255) bb = 255;

			// draw line
			DrawLine(line->coord[C_X1], line->coord[C_Y1], line->coord[C_X2], line->coord[C_Y2], RGBTO16(rr,gg,bb));

			// shift line index
			j++;
			if (j >= LINENUM) j = 0;
		}

		// generate new head line
		j = Head;
		line = &Lines[j];
		for (i = 0; i < C_NUM; i++) line->coord[i] = (int)(Coord[i] + 0.5f);
		line->r = R;
		line->g = G;
		line->b = B;

		// shift header
		j++;
		if (j >= LINENUM) j = 0;
		Head = j;

		// shift coordinates
		for (i = 0; i < C_NUM; i++)
		{
			Coord[i] += Delta[i];
			if (Coord[i] < 0)
			{
				Coord[i] = 0;
				Delta[i] = RandFloatMinMax(SPEEDMIN, SPEEDMAX);
			}

			if (Coord[i] > CoordMax[i])
			{
				Coord[i] = CoordMax[i];
				Delta[i] = -RandFloatMinMax(SPEEDMIN, SPEEDMAX);
			}
		}

		// generate new color
		ColLen--;
		if (ColLen <= 0)
		{
			ColLen = RandU8MinMax(LENMIN,LENMAX);

			do {
				R = RandU8();
				G = RandU8();
				B = RandU8();
			} while (R+G+B < LEVMIN);
		}

		// update display
		DispUpdate();

		switch (KeyGet())
		{
		// reset to boot loader
		case KEY_Y: ResetToBootLoader();

#if USE_SCREENSHOT		// use screen shots
		case KEY_X:
			ScreenShot();
			break;
#endif
		}
	}
}

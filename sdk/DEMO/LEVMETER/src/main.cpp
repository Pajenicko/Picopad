
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

// spectrum data line
u8 Samp1[SAMPNUM]; // real data samples 0..15
u8 Samp2[SAMPNUM]; // real data samples 0..15

s8 Samp1Dir[SAMPNUM];
s8 Samp2Dir[SAMPNUM];

u8 Samp1Filt[SAMPNUM]; // filtered samples
u8 Samp2Filt[SAMPNUM]; // filtered samples

// colors
const u16 Colors[SAMPMAX] = {
	COL_CYAN,
	COL_CYAN,

	COL_GREEN,
	COL_GREEN,
	COL_GREEN,
	COL_GREEN,
	COL_GREEN,
	COL_GREEN,

	COL_YELLOW,
	COL_YELLOW,
	COL_YELLOW,
	COL_YELLOW,

	COL_RED,
	COL_RED,
	COL_RED,
	COL_RED,
};

int main()
{
	int i, j, off;
	int a, b;

	// initialize sound output
	PlaySoundRep(TestSnd, SNDLEN);

	// draw reproboxes
	DrawImg4Rle(Repro1Img, Repro1Img_Pal, REPRO1X, REPROY, REPROW, REPROH);
	DrawImg4Rle(Repro2Img, Repro2Img_Pal, REPRO2X, REPROY, REPROW, REPROH);

	// main loop
	while (True)
	{
		// membranes update (by sound offset)
		int off = (SNDLEN - SoundCnt[0]) % BEATINT;
		off = (off < BEATON) ? MEMBOFF : 0;
		DrawBlit4Pal(Repro3Img, Repro3Img_Pal, 0, 0, REPRO1X+MEMB1X+off, REPROY+MEMBY+off, MEMBW, MEMBH, MEMBW, COL_WHITE);
		DrawBlit4Pal(Repro3Img, Repro3Img_Pal, 0, 0, REPRO2X+MEMB1X+off, REPROY+MEMBY+off, MEMBW, MEMBH, MEMBW, COL_WHITE);

		// generate samples
		for (i = 0; i < SAMPNUM; i++)
		{
			// generate new direction
			if (RandU8() < 100)
			{
				Samp1Dir[i] = RandS8MinMax(-2, +2);
				Samp2Dir[i] = RandS8MinMax(-2, +2);
			}

			// change sample 1 value
			a = Samp1[i] + Samp1Dir[i];
			if (a < 0) a = 0;
			if (a >= SAMPMAX) a = SAMPMAX-1;
			Samp1[i] = a;

			// change sample 2 value
			a = Samp2[i] + Samp2Dir[i];
			if (a < 0) a = 0;
			if (a >= SAMPMAX) a = SAMPMAX-1;
			Samp2[i] = a;
		}

		// display samples
		for (i = 0; i < SAMPNUM; i++)
		{
			 // filter samples for more realistic progress
			a = Samp1[i];
			b = Samp2[i];
			if ((i > 0) && (i < SAMPNUM-1))
			{
				a = (a*2 + Samp1[i-1] + Samp1[i+1]) >> 2;
				b = (b*2 + Samp2[i-1] + Samp2[i+1]) >> 2;
			}

			for (j = 0; j < SAMPMAX; j++)
			{

				if (a >= (SAMPMAX-1-j))
					DrawRect(GRAPH1X+i*8, GRAPHY+j*3, 7, 2, Colors[SAMPMAX-1-j]);
				else
					DrawRect(GRAPH1X+i*8, GRAPHY+j*3, 7, 2, RGBTO16(0, 0, 100));

				if (b >= (SAMPMAX-j))
					DrawRect(GRAPH2X+i*8, GRAPHY+j*3, 7, 2, Colors[SAMPMAX-1-j]);
				else
					DrawRect(GRAPH2X+i*8, GRAPHY+j*3, 7, 2, RGBTO16(0, 0, 100));
			}
		}

		// update display
		DispUpdate();

		// short delay
		WaitMs(20);

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

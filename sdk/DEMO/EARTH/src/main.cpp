
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

#define USERANDSHADOW	2	// 2=use blend shadow, 1=use random shadow, 0=use rastered shadow

// precalculated U coordinate
#define UNUM 800
#define UNUM2 (UNUM/2)
int UTab[UNUM];

// main function
int main()
{
	int i, x, y, xr, u, v, off;
	u16* d;
	const u8 *s1, *s2;
	u16 c1, c2;
	u32 t, t2;
	u8 night;

	// clear draw box
	for (i = 0; i < FRAMESIZE; i++) FrameBuf[i] = COL_BLACK;

	// prepare U table
	for (i = 0; i < UNUM; i++)
	{
		UTab[i] = (int)((asinf((float)(i-UNUM2)/UNUM2)/PI2+0.25f)*EARTHW);
	}

	// main loop
	off = 0;
	t = Time();
	while (True)
	{
		// Y loop
		for (y = -GLOBER; y < +GLOBER; y++)
		{
			// X offset
			xr = (int)(sqrtf((float)GLOBER*GLOBER - y*y) + 0.5f);
			if (xr == 0) xr = 1; // to avoid divide by zero

			// destination address
			d = &FrameBuf[GLOBEX-xr + (y+GLOBEY)*WIDTH];

			// texture V coordinate
			v = (int)((asinf((float)y/GLOBER)/PI+0.5f)*EARTHH);

			// source address
			s1 = &Earth1Img[v*EARTHW];
			s2 = &Earth2Img[v*EARTHW];

			// X loop
			for (x = -xr; x < xr; x++)
			{
				// texture U coordinate
				u = UTab[x*UNUM2/xr+UNUM2];

#define SHADOWBEG	(xr*7/16) // shadow beging
#define SHADOW1		(xr*8/16) // shadow boundary 1
#define SHADOW2		(xr*9/16) // shadow boundary 2
#define SHADOWEND	(xr*10/16) // shadow end

#if USERANDSHADOW == 2 // use blend shadow

				// select bitmap
				if (x < SHADOWBEG) // always day
					night = False;	// day
				else if (x >= SHADOWEND) // always night
					night = True;	// night
				else
					night = 2 + (x - SHADOWBEG)*16/(SHADOWEND-SHADOWBEG);

#elif USERANDSHADOW == 1 // use random shadow

				// select bitmap
				if (x < SHADOWBEG) // always day
					night = False;	// day
				else if (x >= SHADOWEND) // always night
					night = True;	// night
				else
				{
					if (x <= (int)RandU16MinMax(SHADOWBEG, SHADOWEND))
						night = False;	// day
					else
						night = True;	// night
				}

#else // use random shadow

				if (x < SHADOWBEG) // always day
					night = False;	// day
				else if (x >= SHADOWEND) // always night
					night = True;	// night
				else if (x < SHADOW1) // light shadow
				{
					if (((x & 1) + ((y & 1)<<1)) == 0)
						night = True;	// night
					else
						night = False;	// day
				}
				else if (x < SHADOW2) // shadow
				{
					if (((x + y) & 1) == 0)
						night = True;	// night
					else
						night = False;	// day
				}
				else // dark shadow
				{
					if (((x & 1) + ((y & 1)<<1)) != 3)
						night = True;	// night
					else
						night = False;	// day
				}

#endif // use random shadow

				// draw pixel
				c1 = Earth1Img_Pal[s1[(u + off + EARTHW/2) & (EARTHW-1)]]; // day
				c2 = Earth2Img_Pal[s2[(u + off + EARTHW/2) & (EARTHW-1)]]; // night

				if (night > 1)
					*d++ = BlendCol16(c1, c2, night - 2);
				else if (night)
					*d++ = c2;
				else
					*d++ = c1;
			}
		}

		// shift angle
		off -= 3;
		while (off < EARTHW) off += EARTHW;

		// update display
		DispUpdateAll();

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

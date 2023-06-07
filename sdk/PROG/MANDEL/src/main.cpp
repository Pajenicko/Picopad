
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************
// Mandlebrot set

/*
Integer arithmetics:

Value range:
- ci, cr ..... -2 to +2
- zr, zi .... -2 to +2

- zr2 = zr*zr, zi2 = zi*zi .... 0 to +4
- if (zr2 + zi2 > 4) break; ..... zr2, zi2 .... 0 to +4 (zr, zi .... -2 to +2)
- zi = 2*zr*zi + ci; ..... -10 to +10
- zr = zr2 - zi2 + cr; .... -6 to +6

- zr2 = zr*zr, zi2 = zi*zi .... 0 to +60
- if (zr2 + zi2 > 4) break; ..... zr2, zi2 .... 0 to +4 (zr, zi .... -2 to +2)
- zi = 2*zr*zi + ci; ..... -10 to +10
- zr = zr2 - zi2 + cr; .... -6 to +6

Need 6 bits for integer part of number + 1 bit for sign.

We will use 32-bit integer with highest 7 bits as integer part and 25 lower bits as decimal part.
*/

#include "../include.h"

#define RENDER_2CORES	1	// 1 = use both cores to render
#define RENDER_FIXASM	1	// 1 = use fixed int in assembler

#define USE_AUTO 0	// auto arithmetics
#define USE_INT	1	// use integer arithmetics (max. SizeN = 17, baze repaint 480 ms or one core 717 ms, C variant 517 ms or one core 793 ms)
#define USE_BIG	2	// use big integer arithmetics (max. SizeN = 42, baze repaint 2324 ms or one core 3933 ms)
#define USE_FLT	3	// use float arithmetics (max. SizeN = 19, baze repaint 2075 ms or one core 3584 ms)
#define USE_DBL	4	// use double arithmetics (max. SizeN = 25, baze repaint 3165 ms or one core 5278 ms)

int Arithm = USE_AUTO; // used arithmetics

// current coordinates
double Size = 1;	// Zoom = 1/Size
int SizeN = 0;		// size step
double OffX = 0;
double OffY = 0;
int Steps = 32; // number of steps
int Shift = 0; // number of shift to convert steps to gradient
int Width = WIDTH;

// gradient
extern "C" const u16 Grad[32] = {
	RGBTO16(0,0,84),
	RGBTO16(0,0,195),
	RGBTO16(0,41,195),
	RGBTO16(0,84,195),
	RGBTO16(0,117,195),
	RGBTO16(0,166,255),
	RGBTO16(0,195,255),
	RGBTO16(0,230,255),
	RGBTO16(0,230,195),
	RGBTO16(0,195,195),
	RGBTO16(0,195,84),
	RGBTO16(41,195,0),
	RGBTO16(84,195,0),
	RGBTO16(117,230,0),
	RGBTO16(166,255,0),
	RGBTO16(195,255,0),
	RGBTO16(230,255,0),
	RGBTO16(255,255,0),
	RGBTO16(255,230,0),
	RGBTO16(255,195,0),
	RGBTO16(255,166,0),
	RGBTO16(255,117,0),
	RGBTO16(255,84,0),
	RGBTO16(255,0,0),
	RGBTO16(255,0,84),
	RGBTO16(255,0,195),
	RGBTO16(255,41,255),
	RGBTO16(255,84,255),
	RGBTO16(255,117,255),
	RGBTO16(255,166,255),
	RGBTO16(255,195,255),
	RGBTO16(255,255,255),
};

// processed lines
Bool Ok[HEIGHT];

// Mandelbrot state
int CurY = HEIGHT; // current Y (HEIGHT = not active)
int IncY = 1; // current increment Y
fixed X0i, Y0i, SXi, SYi; // increment in fixed format
float X0f, Y0f, SXf, SYf; // increment in float format
double X0d, Y0d, SXd, SYd, Cid; // increment in double format
big X0b, Y0b, SXb, SYb; // increment in big fixed format
u16* Dst; // current buffer
int DstInc; // increment Dst
u32 StartTime; // start time of render

// Core1 state
u16* Core1Dst; // current buffer
double Core1Cid; // increment in double format

#if RENDER_2CORES // use both cores

void (* volatile QCore1Fnc)() = NULL; // core 1 remote function

// core 1 remote
void QCore1()
{
	void (*fnc)();

	// infinite loop
	while (True)
	{
		// data memory barrier
		dmb();

		// execute remote function
		fnc = QCore1Fnc;
		if (fnc != NULL)
		{
			fnc();
			dmb();
			QCore1Fnc = NULL;
		}
	}
}

// execute core 1 remote function (QVGA must be running)
void QCore1Exec(void (*fnc)())
{
	dmb();
	QCore1Fnc = fnc;
	dmb();
}

// check if core 1 is busy (executing remote function)
Bool QCore1Busy()
{
	dmb();
	return QCore1Fnc != NULL;
}

// wait if core 1 is busy (executing remote function)
void QCore1Wait()
{
	while (QCore1Busy()) {}
}

#endif // RENDER_2CORES // use both cores

// update Y increment
void MandelUpdate()
{
#if RENDER_2CORES // use both cores
	// wait for core1
	QCore1Wait();
#endif

	// current Y
	CurY = 0;

	// ci = ((double)(HEIGHT-y)/HEIGHT - 0.5f)*3*size + offy;
	// ci = y*sy + y0;
	SYd = -3*Size/HEIGHT * IncY;
	SYf = (float)SYd;
	SYi = DblToFixed(SYd);
	SYb = DblToBig(SYd);

	// start Ci
	Cid = Y0d;

	// pointer to buffer
	Dst = FrameBuf;
	DstInc = IncY * WIDTH;
}

// start new image
void MandelStart()
{
#if RENDER_2CORES // use both cores
	// wait for core1
	QCore1Wait();
#endif

	// current Y increment
	IncY = 1;
	while (IncY*2 < HEIGHT) IncY *= 2;

	// shift
	Shift = 0;
	while ((Steps >> Shift) > 32) Shift++;

	// prepare X increment
	// cr = ((double)x/WIDTH - 0.5f)*4*size + offx;
	// cr = x*sx + x0;
	SXd = 4*Size/WIDTH;
	X0d = OffX - 2*Size;
	SXf = (float)SXd;
	X0f = (float)X0d;
	SXi = DblToFixed(SXd);
	X0i = DblToFixed(X0d);
	SXb = DblToBig(SXd);
	X0b = DblToBig(X0d);

	// ci = ((double)(HEIGHT-y)/HEIGHT - 0.5f)*3*size + offy;
	// ci = y*sy + y0;
	Y0d = OffY + 1.5f*Size;
	Y0f = (float)Y0d;
	Y0i = DblToFixed(Y0d);
	Y0b = DblToBig(Y0d);

	// clear buffer
	memset(FrameBuf, 0, WIDTH*HEIGHT*2);
	memset(Ok, False, HEIGHT*sizeof(Bool));

	DispUpdateAll();

	// update Y increment
	MandelUpdate();

	// get start time
	StartTime = Time();
}

// calculate Mandelbrot float
//  default render time (X,Y=[0,0], scale=1, steps=64, sysclk=125MHz, res=264x200): 2.28 sec
void NOFLASH(MandelFloat)(u16* dst, float ci)
{
	int x, i;
	float zr, zi, zr2, zi2, cr, sx;
	int steps = Steps;
	int w = WIDTH;
	const u16* g = Grad;
	int s = Shift;

	// prepare cr
	sx = SXf;
	cr = X0f;

	// X loop
	for (x = 0; x < w; x++)
	{
		zr = cr;
		zi = ci;

		for (i = steps; i > 0; i--)
		{
			zr2 = zr*zr;
			zi2 = zi*zi;
			if (zr2 + zi2 > 4.0f) break;
			zi = 2*zr*zi + ci;
			zr = zr2 - zi2 + cr;
		}

		if (i == 0)
			*dst = 0;
		else
			*dst = g[(steps - i) >> s];

		dst++;
		cr += sx;
	}
}

// calculate Mandelbrot double
//  default render time (X,Y=[0,0], scale=1, steps=64, sysclk=125MHz, res=264x200): 4.10 sec
void NOFLASH(MandelDouble)(u16* dst, double ci)
{
	int x, i;
	double zr, zi, zr2, zi2, cr, sx;
	int steps = Steps;
	int w = WIDTH;
	const u16* g = Grad;
	int s = Shift;

	// prepare cr
	sx = SXd;
	cr = X0f;

	// X loop
	for (x = 0; x < w; x++)
	{
		zr = cr;
		zi = ci;

		for (i = steps; i > 0; i--)
		{
			zr2 = zr*zr;
			zi2 = zi*zi;
			if (zr2 + zi2 > 4.0) break;
			zi = 2*zr*zi + ci;
			zr = zr2 - zi2 + cr;
		}

		if (i == 0)
			*dst = 0;
		else
			*dst = g[(steps - i) >> s];

		dst++;
		cr += sx;
	}
}

// calculate Mandelbrot fixed integer
//  default render time (X,Y=[0,0], scale=1, steps=64, sysclk=125MHz, res=264x200): 0.32 sec
//  Note: This function is realized in assembly, but speed is almost the same.
void NOFLASH(MandelFixedC)(u16* dst, fixed ci)
{
	int x, i;
	fixed zr, zi, zr2, zi2, cr, sx;
	int steps = Steps;
	int w = WIDTH;
	const u16* g = Grad;
	int s = Shift;

	// prepare cr
	sx = SXi;
	cr = X0i;

	// X loop	
	for (x = 0; x < w; x++)
	{
		zr = cr;
		zi = ci;

		for (i = steps; i > 0; i--)
		{
			zr2 = FixedSqr(zr);
			zi2 = FixedSqr(zi);
			if (FixedGr(FixedAdd(zr2, zi2), (4 << 25))) break;
			zi = FixedAdd(FixedMul2(FixedMul(zr, zi)), ci);
			zr = FixedAdd(FixedSub(zr2, zi2), cr);
		}

		if (i == 0)
			*dst = 0;
		else
			*dst = g[(steps - i) >> s];

		dst++;
		cr = FixedAdd(cr, sx);
	}
}

// multiply two unsigned big fixed point integers
big BigUMul(big a, big b)
{
	u64 rH, rL;

	//       aHaL
	//     x bHbL
	// ----------
	//       aLbL ...   k0
	//     aLbH   ...  k1
	//     aHbL   ...  k2
	//   aHbH     ... k3

	// prepare elements
	u32 aL = (u32)a;
	u32 aH = (u32)(a >> 32);
	u32 bL = (u32)b;
	u32 bH = (u32)(b >> 32);

	// multiply elements (max. FFFF * FFFF = FFFE0001)
	u64 k0 = (u64)aL*bL;
	u64 k1 = (u64)aL*bH;
	u64 k2 = (u64)aH*bL;
	u64 k3 = (u64)aH*bH;

	// add komponents
	k1 += (k0 >> 32); // max. FFFE0001 + FFFE = FFFEFFFF, no carry yet
	k1 += k2; // max. FFFEFFFF + FFFE0001 = 1FFFD0000, it can carry
	if (k1 < k2) k3 += (u64)1ULL << 32; // add carry, FFFE0001 + 10000 = FFFF0001, no carry

	// result, max. FFFFFFFF * FFFFFFFF = FFFFFFFE:00000001
	rL = (k1 << 32) + (u32)k0; // result low, FFFF0000 + FFFF = FFFFFFFF, no carry
	rH = k3 + (k1 >> 32); // result high, FFFF0001 + FFFD = FFFFFFFE, no carry 

	// shift result 57 bits right
	return (rH << 7) + (rL >> 57);
}

// calculate Mandelbrot big integer
void NOFLASH(MandelBig)(u16* dst, big ci)
{
	int x, i;
	big zr, zi, zr2, zi2, cr, sx;
	int steps = Steps;
	int w = WIDTH;
	const u16* g = Grad;
	int s = Shift;

	// prepare cr
	sx = SXb;
	cr = X0b;

	// X loop	
	for (x = 0; x < w; x++)
	{
		zr = cr;
		zi = ci;

		for (i = steps; i > 0; i--)
		{
			zr2 = BigSqr(zr);
			zi2 = BigSqr(zi);
			if (BigGr(BigAdd(zr2, zi2), (4LL << 57))) break;
			zi = BigAdd(BigMul2(BigMul(zr, zi)), ci);
			zr = BigAdd(BigSub(zr2, zi2), cr);
		}

		if (i == 0)
			*dst = 0;
		else
			*dst = g[(steps - i) >> s];

		dst++;
		cr = BigAdd(cr, sx);
	}
}

#if RENDER_2CORES // use both cores
// render using Core1
void MandelCore1()
{
	if (Arithm == USE_AUTO)
	{
		if (SizeN <= 17)
#if RENDER_FIXASM	// 1 = use fixed int in assembler
			MandelFixed(Core1Dst, DblToFixed(Core1Cid));
#else
			MandelFixedC(Core1Dst, DblToFixed(Core1Cid));
#endif
		else
			MandelBig(Core1Dst, DblToBig(Core1Cid));
	}
	else
	{
		if (Arithm == USE_INT)
#if RENDER_FIXASM	// 1 = use fixed int in assembler
			MandelFixed(Core1Dst, DblToFixed(Core1Cid));
#else
			MandelFixedC(Core1Dst, DblToFixed(Core1Cid));
#endif
		else if (Arithm == USE_BIG)
			MandelBig(Core1Dst, DblToBig(Core1Cid));
		else if (Arithm == USE_FLT)
			MandelFloat(Core1Dst, (float)Core1Cid);
		else
			MandelDouble(Core1Dst, Core1Cid);
	}
}
#endif

int main()
{
	int c;

#if RENDER_2CORES // use both cores
	// run core 1
	Core1Exec(QCore1);
#endif

	// start new image
	MandelStart();

	while (true)
	{
		// keys
		c = KeyGet();
		if ((c != NOKEY))
		{

			switch (c)
			{
			case KEY_UP: // move up
				if (KeyPressed(KEY_A))
				{
					Size /= 2;
					SizeN++;
				}
				else
					OffY += Size;
				MandelStart();
				break;

			case KEY_LEFT: // move left
				if (KeyPressed(KEY_A))
				{
					Steps /= 2;
					Shift--;
					if (Steps < 1) Steps = 1;
				}
				else
					OffX -= Size;
				MandelStart();
				break;

			case KEY_RIGHT: // move right
				if (KeyPressed(KEY_A))
				{
					Steps *= 2;
					if (Steps < 0) Steps = 0x40000000;
				}
				else
					OffX += Size;
				MandelStart();
				break;

			case KEY_DOWN: // move down
				if (KeyPressed(KEY_A))
				{
					Size *= 2;
					SizeN--;
					if (Size >= 1)
					{
						Size = 1;
						SizeN = 0;
					}
				}
				else
					OffY -= Size;
				MandelStart();
				break;

			case KEY_Y: // quit
				ResetToBootLoader();
				break;

#if USE_SCREENSHOT		// use screen shots
			case KEY_X:
				ScreenShot();
				break;
#endif

			default:
				break;
			}
		}

		// render line
		if (CurY < HEIGHT)
		{
			if (!Ok[CurY])
			{
				Ok[CurY] = True;

				DispDirtyRect(0, CurY-4, DispWidth, 5);
		
				// render line
#if RENDER_2CORES // use both cores
				if (!QCore1Busy())
				{
					Core1Dst = Dst;
					Core1Cid = Cid;
					QCore1Exec(MandelCore1);
				}
				else 
#endif
				if (Arithm == USE_AUTO)
				{
					if (SizeN <= 17)
#if RENDER_FIXASM	// 1 = use fixed int in assembler
						MandelFixed(Dst, DblToFixed(Cid));
#else
						MandelFixedC(Dst, DblToFixed(Cid));
#endif
					else
						MandelBig(Dst, DblToBig(Cid));
				}
				else
				{
					if (Arithm == USE_INT)
#if RENDER_FIXASM	// 1 = use fixed int in assembler
						MandelFixed(Dst, DblToFixed(Cid));
#else
						MandelFixedC(Dst, DblToFixed(Cid));
#endif
					else if (Arithm == USE_BIG)
						MandelBig(Dst, DblToBig(Cid));
					else if (Arithm == USE_FLT)
						MandelFloat(Dst, (float)Cid);
					else
						MandelDouble(Dst, Cid);
				}
			}

			// next line
			CurY += IncY;
			Cid += SYd;
			Dst += DstInc;

			DispUpdate();

			if (CurY >= HEIGHT)
			{
				if (IncY > 1)
				{
					IncY /= 2;
					MandelUpdate();
				}
				else
				{
/*
					// display zoom and render time
					char buf[30];
					int i = DecNum(buf, SizeN, 0);
					buf[i++] = ' ';
					i += DecNum(&buf[i], (Time() - StartTime)/1000, 0);
					buf[i++] = ' ';
					buf[i++] = 0;
					DrawTextBg(buf, 0, 0, COL_WHITE, COL_BLACK);
*/
				}
			}
		}
		else
		{
			DispUpdate();

			// indicate work done
			LedOn(LED1);
			WaitMs(125);
			LedOff(LED1);
			WaitMs(125);
		}
	}
}

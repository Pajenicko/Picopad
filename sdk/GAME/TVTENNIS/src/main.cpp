
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "include.h"

#define SEGM	4	// base segment size in pixels
#define DIGW	4	// digit width in segments
#define DIGH	7	// digit height in segments
#define DIGSEG	SEGM	// size of digit segment in pixels
#define NUMW	((DIGW+2)*DIGSEG) // width of digit in pixels (= 24)
#define MAXSCORE 99	// max. score
#define NETW	(2*SEGM) // width of middle net
#define DIGNUM	2	// number of digits of one score
#define PADDLEW	(2*SEGM) // paddle width
#define PADDLEH	(12*SEGM) // paddle height
#define BALLSIZE (2*SEGM) // ball size
#define PADDLELX SEGM	// left paddle X coordinate
#define PADDLERX (WIDTH - SEGM - PADDLEW) // right paddle X coordinate

#define PADDLESPEED 0.00025f // paddle speed
#define BALLSPEED 0.0003f // ball speed

#define BALL_IN	0	// ball is in game
#define BALL_L	1	// ball is served by left player
#define BALL_R	2	// ball is served by right player

// time delta
u32 OldTime;
int TimeDelta;

// computer
Bool Comp[2];
float CompX[2]; // X coordinate for delayed computer response
float CompY[2]; // Y coordinate of computer inaccuracy
u32 LastOut; // last out time (to start new serve)

// current score
u8 Score[2];
Bool ScoreUpdate;
Bool Tied; // tied paddles

// paddle Y coordinate (middle)
float PaddleY[2];
Bool PaddleUpdate[2];
float OldPaddleY[2];

// ball state BALL_*
u8 BallState;
float BallX, BallY, BallDir;
Bool BallUpdate;
float OldBallX, OldBallY;

// digits patterns
const u8 Digits[10*DIGH] = {
	// 0
	0b1111,
	0b1001,
	0b1001,
	0b1001,
	0b1001,
	0b1001,
	0b1111,

	// 1
	0b0001,
	0b0001,
	0b0001,
	0b0001,
	0b0001,
	0b0001,
	0b0001,

	// 2
	0b1111,
	0b0001,
	0b0001,
	0b1111,
	0b1000,
	0b1000,
	0b1111,
	
	// 3
	0b1111,
	0b0001,
	0b0001,
	0b0111,
	0b0001,
	0b0001,
	0b1111,

	// 4
	0b1001,
	0b1001,
	0b1001,
	0b1111,
	0b0001,
	0b0001,
	0b0001,

	// 5
	0b1111,
	0b1000,
	0b1000,
	0b1111,
	0b0001,
	0b0001,
	0b1111,

	// 6
	0b1111,
	0b1000,
	0b1000,
	0b1111,
	0b1001,
	0b1001,
	0b1111,

	// 7
	0b1111,
	0b0001,
	0b0001,
	0b0001,
	0b0001,
	0b0001,
	0b0001,

	// 8
	0b1111,
	0b1001,
	0b1001,
	0b1111,
	0b1001,
	0b1001,
	0b1111,

	// 9
	0b1111,
	0b1001,
	0b1001,
	0b1111,
	0b0001,
	0b0001,
	0b1111,
};

// prepare auto play
void NewAuto()
{
	CompX[0] = WIDTH * (0.25f + RandFloat()*0.5f);
	CompY[0] = 1.04f * (PADDLEH + BALLSIZE) * (RandFloat() - 0.5f);

	CompX[1] = WIDTH * (0.25f + RandFloat()*0.5f);
	CompY[1] = 1.04f * (PADDLEH + BALLSIZE) * (RandFloat() - 0.5f);
}

// new game
void NewGame()
{
	int i;
	for (i = 0; i < 2; i++)
	{
		Score[i] = 0;
		PaddleY[i] = HEIGHT/2;
	}
	BallState = BALL_L;
	LastOut = Time();
	BallY = HEIGHT/2;
	NewAuto();
}

// display middle net
void DispNet(int height)
{
	DrawRect((WIDTH - NETW)/2, 0, NETW, height, RGBTO16(0, 186, 255));
}

// display one score
void DispScore(int inx)
{
	int j, row, col, x, y;
	u8 dig[2], k;
	u16 c;
	const u8* s;

	// decode number (2 digits)
	dig[0] = Score[inx]/10;
	dig[1] = Score[inx] - dig[0]*10;

	// start X coordinate
	x = (inx == 0) ? ((WIDTH - NETW)/2 - 2*NUMW) : ((WIDTH + NETW)/2 + 2*DIGSEG);

	// decode digits
	for (j = 0; j < 2; j++)
	{
		y = 0;
		s = &Digits[dig[j]*DIGH];

		// decode digit rows
		for (row = 0; row < DIGH; row++)
		{
			k = *s++;

			// decode digit columns
			for (col = 0; col < DIGW; col++)
			{
				// draw one digit segment
				c = ((k & B3) == 0) ? COL_BLACK : COL_GREEN;
				DrawRect(x+col*DIGSEG, y+row*DIGSEG, DIGSEG, DIGSEG, c);
				k <<= 1;
			}
		}

		// shift X coordinate
		x += NUMW;
	}
}

// display both scores
void DispScores()
{
	DispScore(0);
	DispScore(1);
}

// clear old paddle
void ClearPaddle(int inx)
{
	int x = (inx == 0) ? PADDLELX : PADDLERX;
	DrawRect(x, (int)OldPaddleY[inx] - PADDLEH/2, PADDLEW, PADDLEH, COL_BLACK);
}

// display one paddle
void DispPaddle(int inx)
{
	int x = (inx == 0) ? PADDLELX : PADDLERX;
	DrawRect(x, (int)PaddleY[inx] - PADDLEH/2, PADDLEW, PADDLEH, COL_YELLOW);
}

// display both paddles
void DispPaddles()
{
	DispPaddle(0);
	DispPaddle(1);
}

// clear old ball
void ClearBall()
{
	DrawRect((int)OldBallX - BALLSIZE/2, (int)OldBallY - BALLSIZE/2,
		BALLSIZE, BALLSIZE, COL_BLACK);
}

// display ball
void DispBall()
{
	if (BallState == BALL_IN) DrawRect((int)BallX - BALLSIZE/2, (int)BallY - BALLSIZE/2,
		BALLSIZE, BALLSIZE, COL_RED);
}

// display all
void DispAll()
{
	int i, j, row, col, k, x, y;

	// clear screen
	DrawClear(COL_BLACK);

	// display middle net
	DispNet(HEIGHT);

	// display both scores
	DispScores();

	// display both paddles
	DispPaddles();

	// display ball
	DispBall();

        // display update
	DispUpdate();
}

// game control
void GameControl()
{
	u8 key0 = NOKEY;
	u8 key1 = NOKEY;
	float autoy;

	// save current position
	OldPaddleY[0] = PaddleY[0];
	OldPaddleY[1] = PaddleY[1];

	// auto play
	if ((Comp[0]) && (BallX <= CompX[0]))
	{
		autoy = BallY + CompY[0];
		if (PaddleY[0] < autoy) key0 = KEY_DOWN;
		if (PaddleY[0] > autoy) key0 = KEY_UP;
	}

	if ((Comp[1]) && (BallX >= CompX[1]))
	{
		autoy = BallY + CompY[1];
		if (PaddleY[1] < autoy) key1 = KEY_DOWN;
		if (PaddleY[1] > autoy) key1 = KEY_UP;
	}

	// left player up
	if ((KeyPressed(KEY_UP) && !Comp[0]) || ((Tied || Comp[1]) && KeyPressed(KEY_X) && !Comp[0]) || (key0 == KEY_UP))
	{
		PaddleY[0] -= TimeDelta*PADDLESPEED;
		if (PaddleY[0] < PADDLEH/2) PaddleY[0] = PADDLEH/2;
		PaddleUpdate[0] = True;
	}

	// left player down
	if ((KeyPressed(KEY_DOWN) && !Comp[0]) || ((Tied || Comp[1]) && KeyPressed(KEY_A) && !Comp[0]) || (key0 == KEY_DOWN))
	{
		PaddleY[0] += TimeDelta*PADDLESPEED;
		if (PaddleY[0] > HEIGHT - PADDLEH/2) PaddleY[0] = HEIGHT - PADDLEH/2;
		PaddleUpdate[0] = True;
	}

	// right player up
	if ((KeyPressed(KEY_X) && !Comp[1]) || ((Tied || Comp[0]) && KeyPressed(KEY_UP) && !Comp[1]) || (key1 == KEY_UP))
	{
		PaddleY[1] -= TimeDelta*PADDLESPEED;
		if (PaddleY[1] < PADDLEH/2) PaddleY[1] = PADDLEH/2;
		PaddleUpdate[1] = True;
	}

	// right player down
	if ((KeyPressed(KEY_A) && !Comp[1]) || ((Tied || Comp[0]) && KeyPressed(KEY_DOWN) && !Comp[1]) || (key1 == KEY_DOWN))
	{
		PaddleY[1] += TimeDelta*PADDLESPEED;
		if (PaddleY[1] > HEIGHT - PADDLEH/2) PaddleY[1] = HEIGHT - PADDLEH/2;
		PaddleUpdate[1] = True;
	}
}

// move ball
void GameBall()
{
	// move ball
	if (BallState == BALL_IN)
	{
		// ball increment
		float d = TimeDelta*BALLSPEED;

		// save old position
		OldBallX = BallX;
		OldBallY = BallY;

		// ball new coordinate
		float ballx = BallX + d*cosf(BallDir);
		float bally = BallY - d*sinf(BallDir);

		// bounce off the top edge
		if (bally <= BALLSIZE/2)
		{
			bally = BALLSIZE/2;
			BallDir = -BallDir;
			PLAYSOUND(BoundSnd);
		}

		// bounce off the bottom edge
		if (bally >= HEIGHT - BALLSIZE/2)
		{
			bally = HEIGHT - BALLSIZE/2;
			BallDir = -BallDir;
			PLAYSOUND(BoundSnd);
		}

		// bounce off the left paddle
		//  Note: Using old "BallX" coordinate for case the animation step is too large.
		if (	(ballx - BALLSIZE/2 <= PADDLELX + PADDLEW) && // new X coordinate
			(BallX + BALLSIZE/2 >= PADDLELX) && // old X coordinate
			(bally - BALLSIZE/2 <= PaddleY[0] + PADDLEH/2) &&
			(bally + BALLSIZE/2 >= PaddleY[0] - PADDLEH/2))
		{
			ballx = PADDLELX + PADDLEW + BALLSIZE/2;
			BallDir = PI/4 * (PaddleY[0] - bally) / (PADDLEH/2);
			PLAYSOUND(PaddleSnd);

			// prepare auto play
			NewAuto();
		}

		// bounce off the right paddle
		//  Note: Using old "BallX" coordinate for case the animation step is too large.
		if (	(ballx + BALLSIZE/2 >= PADDLERX) && // new X coordinate
			(BallX - BALLSIZE/2 <= PADDLERX + PADDLEW) && // old X coordinate
			(bally - BALLSIZE/2 <= PaddleY[1] + PADDLEH/2) &&
			(bally + BALLSIZE/2 >= PaddleY[1] - PADDLEH/2))
		{
			ballx = PADDLERX - BALLSIZE/2;
			BallDir = PI - (PI/4 * (PaddleY[1] - bally) / (PADDLEH/2));
			PLAYSOUND(PaddleSnd);

			// prepare auto play
			NewAuto();
		}

		// ball is out left
		if (ballx < -BALLSIZE)
		{
			if (Score[1] < MAXSCORE) Score[1]++;
			ScoreUpdate = True;
			BallState = BALL_L;			
			PLAYSOUND(OutSnd);
			LastOut = Time();
			BallY = HEIGHT/2;
			NewAuto();
		}

		// ball is out right
		if (ballx > WIDTH + BALLSIZE)
		{
			if (Score[0] < MAXSCORE) Score[0]++;
			ScoreUpdate = True;
			BallState = BALL_R;			
			PLAYSOUND(OutSnd);
			LastOut = Time();
			BallY = HEIGHT/2;
			NewAuto();
		}

		// new position
		BallX = ballx;
		BallY = bally;
		BallUpdate = True;
	}
}

// game display update
void GameUpdate()
{
	// ball needs update
	if (BallUpdate)
	{
		// ball is near score
		if ((BallY < DIGH*SEGM+BALLSIZE) &&
			(BallX >= WIDTH/2 - NETW - 2*NUMW - BALLSIZE) &&
			(BallX <= WIDTH/2 + NETW + 2*NUMW + BALLSIZE))
		{
			// clear old ball
			ClearBall();

			// display score
			DispScores();
			ScoreUpdate = False;

			// display middle net
			DispNet(10*SEGM);
		}

		// ball is near middle net
		else if ((BallX >= (WIDTH - NETW)/2 - BALLSIZE) &&
				(BallX <= (WIDTH + NETW)/2 + BALLSIZE))
		{
			// clear old ball
			ClearBall();

			// display middle net
			DispNet(HEIGHT);
		}

		// ball is near left paddle
		else if ((BallX <= PADDLELX + PADDLEW + BALLSIZE) &&
			(BallY >= PaddleY[0] - PADDLEH/2 - BALLSIZE) &&
			(BallY <= PaddleY[0] + PADDLEH/2 + BALLSIZE))

		{
			// clear old ball
			ClearBall();

			// clear left paddle
			if (PaddleUpdate[0]) ClearPaddle(0);

			// display left paddle
			DispPaddle(0);
			PaddleUpdate[0] = False;
		}

		// ball is near right paddle
		else if ((BallX >= PADDLERX - BALLSIZE) &&
			(BallY >= PaddleY[1] - PADDLEH/2 - BALLSIZE) &&
			(BallY <= PaddleY[1] + PADDLEH/2 + BALLSIZE))
		{
			// clear old ball
			ClearBall();

			// clear right paddle
			if (PaddleUpdate[1]) ClearPaddle(1);

			// display right paddle
			DispPaddle(1);
			PaddleUpdate[1] = False;
		}

		// ball is elsewhere
		else
		{
			// clear old ball
			ClearBall();
		} 

		// display new ball
		DispBall();

		// display update
		DispUpdate();
		BallUpdate = False;
	}

	// left paddle needs update
	if (PaddleUpdate[0])
	{
		// clear left paddle
		ClearPaddle(0);

		// display left paddle
		DispPaddle(0);
		PaddleUpdate[0] = False;

		// display update
		DispUpdate();
	}

	// right paddle needs update
	if (PaddleUpdate[1])
	{
		// clear right paddle
		ClearPaddle(1);

		// display right paddle
		DispPaddle(1);
		PaddleUpdate[1] = False;

		// display update
		DispUpdate();
	}

	// score needs update
	if (ScoreUpdate)
	{
		// display score
		DispScores();
		ScoreUpdate = False;

		// display update
		DispUpdate();
	}
}

// play on game
void Game(Bool comp1, Bool comp2, Bool tied)
{
	u8 ch;

	// store computer flag
	Comp[0] = comp1;
	Comp[1] = comp2;
	Tied = tied;

	// start new game
	NewGame();
	u32 t;

	// wait for key release
	DispAll();
	while (KeyPressed(KEY_LEFT) || KeyPressed(KEY_RIGHT) ||
		KeyPressed(KEY_UP) || KeyPressed(KEY_DOWN) ||
		KeyPressed(KEY_A) || KeyPressed(KEY_X)) {}
	KeyFlush();

	// game loop
	OldTime = Time();
	while (True)
	{
		// get key
		ch = KeyGet();

		// auto serve
		if ((ch == NOKEY) && ((Time() - LastOut) >= 1000000))
		{
			if (((BallState == BALL_L) && Comp[0]) ||
				((BallState == BALL_R) && Comp[1]))
				ch = KEY_LEFT;
		}

		// key
		switch (ch)
		{
		// exit
		case KEY_Y:
#if USE_SCREENSHOT		// use screen shots
			ScreenShot();
#endif
			KeyFlush();
			return;

		// serve ball
		case KEY_LEFT:
		case KEY_RIGHT:
		case KEY_B:
			if (BallState != BALL_IN)
			{
				// left player serves
				if (BallState == BALL_L)
				{
					BallX = PADDLELX + PADDLEW + BALLSIZE/2;
					BallY = PaddleY[0];
					BallDir = RandFloatMinMax(-PI/4, +PI/4);
				}
				else
				{
					BallX = PADDLERX - BALLSIZE/2;
					BallY = PaddleY[1];
					BallDir = RandFloatMinMax(PI*3/4, PI*5/4);
				}
				BallState = BALL_IN;
				PLAYSOUND(ServeSnd);
			}
			KeyFlush();
			break;

		case NOKEY:
			break;

		default:
			KeyFlush();
			break;
		}

		// time delta
		t = Time();
		TimeDelta = t - OldTime;
		OldTime = t;

		// game control
		GameControl();

		// move ball
		GameBall();

		// game display update
		GameUpdate();
	}
}

// open screen
void Open()
{
	// set font
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;
	DrawFontWidth = 8;

	while (True)
	{
		// draw title
		DrawClear(COL_BLACK);
		DrawText2("TV Tennis", (WIDTH - 9*16)/2, 5, COL_YELLOW);

#define MENUX 10
#define MENUY 45
#define MENUDY 16
		// draw menu
		DrawText("Press key to start the game:", MENUX, MENUY + 0*MENUDY, COL_GREEN);
		DrawText("LEFT ...... Play with left paddle", MENUX, MENUY+1*MENUDY, COL_WHITE);
		DrawText("RIGHT ..... Play with right paddle", MENUX, MENUY+2*MENUDY, COL_WHITE);
		DrawText("DOWN ...... 2 players", MENUX, MENUY+3*MENUDY, COL_WHITE);
		DrawText("UP ........ Demo", MENUX, MENUY+4*MENUDY, COL_WHITE);
		DrawText("A ......... Play with tied paddles", MENUX, MENUY+5*MENUDY, COL_WHITE);

#define MENUY2 (MENUY+7*MENUDY)
		// draw game control
		DrawText("Game control:", MENUX, MENUY2+0*MENUDY, COL_GREEN);
		DrawText("LEFT or RIGHT ... Throw the ball", MENUX, MENUY2+1*MENUDY, COL_WHITE);
		DrawText("UP/DOWN ......... Left paddle", MENUX, MENUY2+2*MENUDY, COL_WHITE);
		DrawText("X/A ............. Right paddle", MENUX, MENUY2+3*MENUDY, COL_WHITE);
		DrawText("Y ............... Quit the game", MENUX, MENUY2+4*MENUDY, COL_WHITE);

		// display update
		DispUpdate();

		// key
		switch (KeyGet())
		{
		case KEY_LEFT:
			Game(False, True, False);
			break;

		case KEY_RIGHT:
			Game(True, False, False);
			break;

		case KEY_DOWN:
			Game(False, False, False);
			break;

		case KEY_UP:
			Game(True, True, False);
			break;

		case KEY_A:
			Game(False, False, True);
			break;

		case KEY_Y: ResetToBootLoader();
		}

		// short delay
		WaitMs(10);
	}
}

int main()
{
	// open menu
	Open();
}

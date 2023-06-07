
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "include.h"

// open selection
int OpenSelInx = 0;

// open text
const char* const OpenText[] = {
	"None of the black or red ants remember",
	"who and when started their age-old war",
	"for the anthill \"At the Two Spruces\".",
	"In order to put an end to the eternal",
	"battles, they decided to build castles,",
	"with the help of which they would gain",
	"dominance over the whole territory.",
	"The aim of the game is to build a castle with a height of 100",
	"or destroy the opponent's castle. Each card consumes certain",
	"amount of resources (number at the top right). The rate of",
	"resource generation depends on the amount of workers.",
};

// display open screen
void DispOpen()
{
	// clear screen
	DrawRect(0, 0, WIDTH, HEIGHT, COL_BLACK);

	// display ants
	DrawImg4Pal(OpenImg, OpenImg_Pal, 0, 0, 0, 0, 120, 120, 240);
	DrawImg4Pal(OpenImg, OpenImg_Pal, 120, 0, WIDTH-120, 53, 120, 120, 240);

	// display title
	DrawImg4Pal(TitleImg, TitleImg_Pal, 0, 0, 120+20, 0, 140, 53, 140);
	DrawImg4Pal(Title2Img, Title2Img_Pal, 0, 0, 120+10, 53, 60, 50, 60);

	// display open text
	pDrawFont = FontTiny5x8;
	DrawFontHeight = 8;
	DrawFontWidth = 5;
	int i;
	for (i = 0; i < count_of(OpenText); i++)
	{
		DrawText(OpenText[i], 0, 110+i*8, COL_WHITE);
	}
}

// display open selection
void DispOpenSel()
{
	DrawImg4Pal(OpenSelImg, OpenSelImg_Pal, 0, 0, 0, HEIGHT-40, WIDTH, 40, WIDTH);
	DrawBlit4Pal(OpenSel2Img, OpenSel2Img_Pal, 0, 0, OpenSelInx*80, HEIGHT-40, 80, 40, 80, COL_BLACK);
}

// main function
int main()
{
	char ch;
	u32 t;

	// display open screen
	DispOpen();
	DispOpenSel();

	// main loop
	t = Time(); // auto-demo time
	while (True)
	{
		// input from keyboard
		ch = KeyGet();
		switch (ch)
		{
		// cursor left
		case KEY_LEFT:
			OpenSelInx--;
			if (OpenSelInx < 0) OpenSelInx = 3;
			DispOpenSel();
			KeyFlush();
			t = Time(); // reset auto-demo time
			break;

		// cursor right
		case KEY_RIGHT:
			OpenSelInx++;
			if (OpenSelInx > 3) OpenSelInx = 0;
			DispOpenSel();
			KeyFlush();
			t = Time(); // reset auto-demo time
			break;

		// run game
		case KEY_DOWN:
		case KEY_A:
			Game(OpenSelInx >= 2, ((OpenSelInx & 1) != 0), False);
			DispOpen();
			DispOpenSel();
			KeyFlush();
			t = Time(); // reset auto-demo time
			break;
	
		// no key
		case NOKEY:
			if ((u32)(Time() - t) >= 15000000ul) // auto demo after 15 seconds
			{
				Game(True, True, True);
				DispOpen();
				DispOpenSel();
				KeyFlush();
				t = Time(); // reset auto-demo time
			}
			break;

		// reset to boot loader
		case KEY_Y:
			ResetToBootLoader();
			break;

		// unknown key
		default:
			KeyFlush();
			t = Time(); // reset auto-demo time
			break;
		}

		// display update
		DispUpdate();
	}
}

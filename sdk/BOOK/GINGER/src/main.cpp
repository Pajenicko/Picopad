
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

const u16* const ImgPalList[PAGES] = { // list of palettes of images
	Img01_Pal,
	Img02_Pal,
	Img03_Pal,
	Img04_Pal,
	Img05_Pal,
	Img06_Pal,
	Img07_Pal,
	Img08_Pal,
	Img09_Pal,
	Img10_Pal,
	Img11_Pal,
	Img12_Pal,
	Img13_Pal,
	Img14_Pal,
	Img15_Pal,
	Img16_Pal,
	Img17_Pal,
	Img18_Pal,
	Img19_Pal,
	Img20_Pal,
	Img01_Pal,
	Img22_Pal,
};

const u8* const ImgList[PAGES] = { // list of images
	Img01,
	Img02,
	Img03,
	Img04,
	Img05,
	Img06,
	Img07,
	Img08,
	Img09,
	Img10,
	Img11,
	Img12,
	Img13,
	Img14,
	Img15,
	Img16,
	Img17,
	Img18,
	Img19,
	Img20,
	Img01,
	Img22,
};

// current page
int Page = 0;
int PageRowsNum;
int PageRowTop;

//const char Title[] = "THE GINGERBREAD HOUSE";

// Text
const char* const PageText[PAGES] = {
	// 1
	//===================================="
	"      Gemtree Software presents\n"
	"    fairy tale for Raspberry Pico\n"
	"      >>> Gingerbread House <<<\n"
	"      (c) 2023 Miroslav Nemecek\n",

	// 2
	"1) Once upon a time there lived a poor wood-cutter, his wife and their two\n"
	"children. The children were called John and Mary. Their father used to go to\n"
	"the forest to dig the stubs. In the summer nice weather, he used to take the\n"
	"kids with him. John and Mary picked up strawberries and they always brought\n"
	"a full jug for their mother.",

	// 3
	"2) One day the father had his job far in the forest and he didn't want the\n"
	"children to go with him, because their legs could hurt them. But John and Mary\n"
	"promised that their legs would not hurt so their father took them with him.\n",

	// 4
	"3) They went for a long time through the forest pathways till they came to a\n"
	"glade. Father admonished the kids not to go too far away, because they could\n"
	"lose their way. Afterwards he began to work.",

	// 5
	"4) John and Mary went to picked up strawberries. They weren't afraid of\n"
	"losing their way, because all the time they heard the wooden axe of their\n"
	"father striking at the stubs.",

	// 6
	"5) When they picked up the full jug and ate bread their mother had given to\n"
	"them for their way, they sat down under a big tree, because their legs would\n"
	"carry them no longer. But after a while, their eyes closed of fatigue and\n"
	"John and Mary fell fast asleep.",

	// 7
	"6) When they awoke at last, it was getting dark in the forest. The children\n"
	"got frightened and looked quickly for their father. They shouted: \"Daddy!,\n"
	"Daddy!\", but their father did not answer. Only the cuckoo gossiped somewhere\n"
	"in the forest brushwood: \"Cuckoo, cuckoo, cuckoo\" and owl had hooted:\n"
	"\"Hoo, hoo\". The darkness thickened and John and Mary searched for their way\n"
	"in vain. They had lost it.",

	// 8
	"7) They stayed alone in the forest and the night was falling. They walked\n"
	"through the brushwood and were frightened. When they didn't know how to get\n"
	"out, Mary, completely depressed, told John: \"John, climb up the tree as high\n"
	"as you can and look at all sides. You may see the light from our house\n"
	"somewhere. Are you frightened?\" \"No, I am not, Mary. Wait a moment, I will\n"
	"be up immediately.\"",

	// 9
	"8) John climbed up the tree, looked around, and suddenly caught sight of a\n"
	"small light afar. He climbed down the tree quickly and told Mary what he had\n"
	"seen. And they went on this direction. At that moment, the clouds dispersed,\n"
	"the moon came out and showed them their way.",

	// 10
	"9) They reached a big meadow, where a nice little house stood. When they\n"
	"approached this house, they wondered. It was made from the gingerbread. They\n"
	"gazed at the house for a while and in the end John broke off a piece from it.\n"
	"Oh, it was such a sweet gingerbread. Mary broke off a piece as well.",

	// 11
	"10) The door of this gingerbread house opened suddenly and an ugly witch went\n"
	"out of the house. The kids were very frightened and before they could recover\n"
	"themselves, the old witch took them firmly by their hands and whimpered: \"Have\n"
	"you enjoyed my gingerbread, dear children? Have you enjoyed it? Don't be afraid\n"
	"of me. You'll be well with me. Very well. Ha-ha, ha-ha.\"",

	// 12
	"11) She closed both of them into the stable. Oh, how sad they were there. But\n"
	"the witch was very lucky to catch the children and she laughed again and\n"
	"again.",

	// 13
	"12) In the morning, she pulled Mary out of the stable, but John remained\n"
	"closed there. Mary had to help her and the witch cooked good meals and fed\n"
	"John to get fat as soon as possible. She was a very wicked witch and she\n"
	"wanted to eat those children.",

	// 14
	"13) She smacked her lips again and again and proved daily whether John was\n"
	"getting fat: \"Show me your finger John. Show it and I'll look at it.\" She\n"
	"wanted to test whether John was already thick enough. But John was a clever\n"
	"boy and stretched out always a little piece of wood on the witch. The witch\n"
	"did not recognize anything. She always cut into the piece of wood by her\n"
	"knife and recognized that John was still too thin.",

	// 15
	"14) However, one morning the witch ordered Mary to bring a lot of wood,\n"
	"because she was going to roast some meat that day. Afterwards, she made a\n"
	"fire in the stove and prepared a big shovel. As soon as she brought the stove\n"
	"to a great heat, she said: \"And now we bring the meat to be roasted.\" She\n"
	"went into the stable and brought John. The things were looking bad.",

	// 16
	"15) The witch already kept the shovel, opened the stove and grimaced at John.\n"
	"\"Come on, you dear kid, do sit down on the shovel and look into the stove\n"
	"whether it is already warm enough. I will bake you cakes.\" But John\n"
	"purposely sat only on the edge of the shovel and immediately fell from it.\n"
	"The witch was angry and grumbled.",

	// 17
	"16) Suddenly, Mary had a good idea and said: \"So, granny, show us how to sit\n"
	"on the shovel.\" \"I will show it to you, kids, I will. Do keep the shovel\n"
	"well.\"",

	// 18
	"17) The children leapt to the shovel, the witch sat down on it properly, and\n"
	"John and Mary pushed her into the stove and closed the door. Done. So much\n"
	"cry. The witch shook the stove door so that the whole gingerbread house\n"
	"vibrated.",

	// 19
	"18) But the children didn't mind it. They ran out from the gingerbread house\n"
	"and aimed to the forest. They ran through the first path they saw and did not\n"
	"look back at all.",

	// 20
	"19) Fortunately, the path led directly to their parent's house. John and Mary\n"
	"ran home quite out of breath. Their father and mother sat there sadly and\n"
	"they were crying. But suddenly the children appeared. They were so happy.",

	// 21
	"20) And the gingerbread house with the wicked witch disappeared somewhere in\n"
	"the forest and nobody heard anything about it anymore.",

	// 22
	//===================================="
	"\n"
	"           T H E     E N D\n",
};

// open page
void OpenPage()
{
	// draw image
	DrawImgRle(ImgList[Page], ImgPalList[Page], 0, 0, IMGWIDTH, IMGHEIGHT);

	// clear text box
	DrawRect(0, IMGHEIGHT, WIDTH, TXTHEIGHT, COL_BLACK);

	// prepare text
	pText txt, txt2;
	TextInit(&txt);
	TextInit(&txt2);
	TextSetStr(&txt, PageText[Page]);
	if ((Page != 0) && (Page != PAGES-1)) TextReformat(&txt, ROWLEN);

	// display text rows
	int lines = TextRowsNum(&txt);
	PageRowsNum = lines;
	int i, j;
	j = 0;
	for (i = PageRowTop; i < PageRowTop + TEXTROWS; i++)
	{
		if (i >= lines) break;
		TextRow(&txt2, &txt, i);
		if ((Page == 0) && (i == 2))
			DrawText(TextPtr(&txt2), 0, IMGHEIGHT + j*8, COL_YELLOW);
		else
			DrawText(TextPtr(&txt2), 0, IMGHEIGHT + j*8, COL_WHITE);
		j++;
	}

	// display bar
	if (lines > TEXTROWS)
	{
		DrawRect(WIDTH - BARWIDTH, IMGHEIGHT, BARWIDTH, TXTHEIGHT, RGBTO16(120,120,120));
		int y1 = PageRowTop*TXTHEIGHT/lines;
		int y2 = (TEXTROWS + PageRowTop)*TXTHEIGHT/lines;
		DrawRect(WIDTH - BARWIDTH+2, IMGHEIGHT+y1+1, BARWIDTH-4, y2-y1-2, RGBTO16(200,200,200));
	}

	TextTerm(&txt);
	TextTerm(&txt2);
}

int main()
{
	char ch;

	// open first page
	Page = 0;
	PageRowTop = 0;
	OpenPage();

	// main loop
	while (true)
	{
		ch = KeyGet();
		switch (ch)
		{
		case KEY_LEFT:
			Page--;
			if (Page < 0) Page = PAGES-1;
			PageRowTop = 0;
			OpenPage();
			break;

		case KEY_RIGHT:
			Page++;
			if (Page >= PAGES) Page = 0;
			PageRowTop = 0;
			OpenPage();
			break;

		case KEY_DOWN:
			if (PageRowTop < PageRowsNum - TEXTROWS)
			{
				PageRowTop++;
				OpenPage();
			}
			break;

		case KEY_UP:
			if (PageRowTop > 0)
			{
				PageRowTop--;
				OpenPage();
			}
			break;

		case KEY_Y:
			ResetToBootLoader();
			break;

#if USE_SCREENSHOT		// use screen shots
		case KEY_X:
			ScreenShot();
			break;
#endif
		}

		DispUpdate();
	}
}

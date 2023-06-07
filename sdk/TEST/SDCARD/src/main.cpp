
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

// display error
void DispError()
{
	DrawTextBg(" ERROR! ", (WIDTH-8*8)/2, (HEIGHT-16)/2, COL_YELLOW, COL_RED);
	DispUpdate();
	while (KeyGet() == NOKEY) {}
}

// test write
void TestWrite()
{
	int i;
	sFile file;

	// clear screen
	DrawClear(COL_BLACK);

	// delete file
	FileDelete("/$TEMP$.TXT");

	// create file
	if (!FileCreate(&file, "/$TEMP$.TXT"))
	{
		DispError();
		return;
	}

	// write file
	FileWrite(&file, "Test file OK", 12);

	// close file
	FileClose(&file);

	// flush disk writes
	DiskFlush();

	// open file
	if (!FileOpen(&file, "/$TEMP$.TXT"))
	{
		DispError();
		return;
	}

	// read file
	char buf[11];
	i = FileRead(&file, buf, 12);
	buf[i] = 0;
	DrawText(buf, 0, 0, COL_WHITE);
	FileClose(&file);

	// display update
	DispUpdate();
	while (KeyGet() == NOKEY) {}
}

// hex view
void HexView()
{
	pText txt;
	TextInit(&txt);
	int i, y;

	sFile file;

	DrawClear(COL_BLACK);

	// set root directory
	SetDir("/");

	// open file
	if (!FileOpen(&file, "LOADER.UF2"))
	{
		TextTerm(&txt);
		DispError();
		return;
	}

	u8 buf[8];
	char buf2[8];

	for (y = 0; y < HEIGHT; y += 16)
	{
		// read one row
		FileRead(&file, buf, 8);

		// visible characters
		for (i = 0; i < 8; i++)
		{
			buf2[i] = buf[i];
			if (buf[i] == 0) buf2[i] = '.';
		}

		// print row
		TextPrint(&txt, "%04X: %02X %02X %02X %02X - %02X %02X %02X %02X %c%c%c%c%c%c%c%c",
			file.off - 8,
			buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7],
			buf2[0], buf2[1], buf2[2], buf2[3], buf2[4], buf2[5], buf2[6], buf2[7] );

		DrawText(TextPtr(&txt), 0, y, COL_WHITE);

		// display update
		DispUpdate();
	}

	// close file
	FileClose(&file);

	DispUpdate();
	while (KeyGet() == NOKEY) {}
	TextTerm(&txt);
}

// dir list
void DirList()
{
	pText txt;
	TextInit(&txt);

	sFile filef; // search structure
	sFileInfo filei; // search file info
	int y;
	char buf[10];

	DrawClear(COL_BLACK);

	// set root directory
	SetDir("/");

	// open search
	if (!FindOpen(&filef, ""))
	{
		TextTerm(&txt);
		DispError();
		return;
	}

	for (y = 0; y < HEIGHT; y += 16)
	{
		// find next file
		if (!FindNext(&filef, &filei, ATTR_DIR_MASK, "*.*")) break;

		// print name
		DrawText(filei.name, 0, y, COL_WHITE);

		// print attributes
		buf[0] = ((filei.attr & ATTR_RO) == 0) ? '.' : 'R';
		buf[1] = ((filei.attr & ATTR_HID) == 0) ? '.' : 'H';
		buf[2] = ((filei.attr & ATTR_SYS) == 0) ? '.' : 'S';
		buf[3] = ((filei.attr & ATTR_DIR) == 0) ? '.' : 'D';
		buf[4] = ((filei.attr & ATTR_ARCH) == 0) ? '.' : 'A';
		buf[5] = 0;
		DrawText(buf, 13*8, y, COL_WHITE);

		// print size
		TextPrint(&txt, "% 6u KB", filei.size/1024);
		DrawText(TextPtr(&txt), 19*8, y, COL_WHITE);

		// print date
		TextPrint(&txt, "% 2u/%02u/%04u", DosMon(filei.wdate), DosDay(filei.wdate), DosYear(filei.wdate));
		DrawText(TextPtr(&txt), 30*8, y, COL_WHITE);

		// display update
		DispUpdate();
	}

	DispUpdate();
	while (KeyGet() == NOKEY) {}
	TextTerm(&txt);
}

int main()
{
	int i;

	pText txt;
	TextInit(&txt);

	// initialize SD card interface (this function is called internally from the DeviceInit() function)
	SDInit();

	int y;
	while (True)
	{
		// clear screen
		DrawClear(COL_BLACK);
		y = 0;

		// draw title
		DrawText("SD Card", 0, y, COL_YELLOW);
		y += 16;

		// connect to SD card (this function is called internally from the DiskMount() function)
		DrawText("SDType:", 0, y, COL_WHITE);
		SDConnect();
		DrawText(GetSDName(), 8*8, y, COL_WHITE);
		y += 16;

		if (SDType != SD_NONE)
		{
			// get media size (in number of 512B sectors)
			TextPrint(&txt, "Media size: %u MB", SDMediaSize()/2048);
			DrawText(TextPtr(&txt), 0, y, COL_WHITE);
			y += 16;

			// mount disk
			DiskMount();
			DrawText("File System:", 0, y, COL_WHITE);
			DrawText(DiskFATName(), 13*8, y, COL_WHITE);
			y += 16;

			if (DiskMounted())
			{
				TextPrint(&txt, "Cluster size: %u sectors (%u bytes)", DiskClustSect(), DiskClustSize());
				DrawText(TextPtr(&txt), 0, y, COL_WHITE);
				y += 16;

				TextPrint(&txt, "Root entries: %u (0 on FAT32)", DiskRootNum());
				DrawText(TextPtr(&txt), 0, y, COL_WHITE);
				y += 16;

				TextPrint(&txt, "Disk size: %u MB", DiskTotalKB()/1024);
				DrawText(TextPtr(&txt), 0, y, COL_WHITE);
				y += 16;

				TextPrint(&txt, "Used space: %u MB", DiskUsedKB()/1024);
				DrawText(TextPtr(&txt), 0, y, COL_WHITE);
				y += 16;

				TextPrint(&txt, "Free space: %u MB", DiskFreeKB()/1024);
				DrawText(TextPtr(&txt), 0, y, COL_WHITE);
				y += 16;


				DrawText("Press A to list files in ROOT", 0, y, COL_GREEN);
				y += 16;
				DrawText("Press B to HEX view file LOADER.UF2", 0, y, COL_GREEN);
				y += 16;
				DrawText("Press X to write file $TEMP$.TXT", 0, y, COL_GREEN);
				y += 16;
			}
		}

		// update display and wait 1 second
		LedFlip(LED1);
		DispUpdate();

		// key input
		for (i = 10; i > 0; i--)
		{
			switch (KeyGet())
			{
			case KEY_Y:
#if USE_SCREENSHOT		// use screen shots
				ScreenShot();
#endif
				ResetToBootLoader();

			case KEY_A:
				if (DiskMounted())
				{
					DirList();
					DrawClear(COL_BLACK);
					DispUpdate();
				}
				break;

			case KEY_B:
				if (DiskMounted())
				{
					HexView();
					DrawClear(COL_BLACK);
					DispUpdate();
				}
				break;

			case KEY_X:
				if (DiskMounted())
				{
					TestWrite();
					DrawClear(COL_BLACK);
					DispUpdate();
				}
				break;
			}

			WaitMs(100);
		}
	}
}

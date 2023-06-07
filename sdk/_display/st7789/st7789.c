
// ****************************************************************************
//
//                          Display controller ST7789
//
// ****************************************************************************

#include "../../global.h"	// globals

#if USE_ST7789		// use ST7789 TFT display (st7789.c, st7789.h)

#include "st7789.h"
#include "../../_sdk/inc/sdk_spi.h"
#include "../../_sdk/inc/sdk_gpio.h"
#include "../../_sdk/inc/sdk_timer.h"

// ST7789 commands
#define ST7789_NOP		0x00	// no operation
#define ST7789_SWRESET		0x01	// software reset
#define ST7789_RDDID		0x04
#define ST7789_RDDST		0x09

#define ST7789_SLPIN		0x10	// enable sleep mode
#define ST7789_SLPOUT		0x11	// disable sleep mode
#define ST7789_PTLON		0x12
#define ST7789_NORON		0x13

#define ST7789_INVOFF		0x20	// disable inversion mode
#define ST7789_INVON		0x21	// enable inversion mode
#define ST7789_DISPOFF		0x28	// disable display
#define ST7789_DISPON		0x29	// enable display
#define ST7789_CASET		0x2A	// set start and end column of draw window
#define ST7789_RASET		0x2B	// set start and end row of draw window
#define ST7789_RAMWR		0x2C	// start write data to draw window
#define ST7789_RAMRD		0x2E	// start read data from draw window

#define ST7789_PTLAR		0x30
#define ST7789_VSCRDEF		0x33
#define ST7789_COLMOD		0x3A	// set color mode (data COLOR_MODE_*)
#define ST7789_MADCTL		0x36	// set rotation mode (data RotationTab)
#define ST7789_VSCSAD		0x37

#define ST7789_MADCTL_MY	0x80
#define ST7789_MADCTL_MX	0x40
#define ST7789_MADCTL_MV	0x20
#define ST7789_MADCTL_ML	0x10
#define ST7789_MADCTL_BGR	0x08
#define ST7789_MADCTL_MH	0x04
#define ST7789_MADCTL_RGB	0x00

#define ST7789_RDID1		0xDA
#define ST7789_RDID2		0xDB
#define ST7789_RDID3		0xDC
#define ST7789_RDID4		0xDD

#define ST7789_RAMCTRL		0xB0	// RAM control, data 2 bytes:
// 1st byte (unused bits are 0; default 0x00):
//   B1,B0: interface 0 MCU, 1 RGB, 2 VSYNC
//   B4: ram access from 0 MCU, 1 RGB
// 2nd byte (default 0xF0):
//   B1,B0: method of pixel data transfer
//   B2: RGB interface bus width 0=18 bits, 1=6 bits
//   B3: endian 0=big MSB first, 1=little LSB first
//   B5,B4: align 65K data with bit 0: 0=equ 0, 1=equ 1, 2=equ high bit, 3=equ green bit 0
//   B7,B6: 1

// color mode ST7789_COLMOD
#define COLOR_MODE_65K		0x50	// 65K-color space (RGB 5-6-5)
#define COLOR_MODE_262K		0x60	// 262K-color space (RGB 6-6-6)
#define COLOR_MODE_12BIT	0x03	// 12-bit data, 4K-color space (RGB 4-4-4)
#define COLOR_MODE_16BIT	0x05	// 16-bit data (RGB 5-6-5)
#define COLOR_MODE_18BIT	0x06	// 18-bit data (RGB 6-6-6)
#define COLOR_MODE_16M		0x07	// 24-bit data (RGB 8-8-8)

#define CS_ON	GPIO_Out0(DISP_CS_PIN); cb()	// activate chip selection
#define CS_OFF	cb(); GPIO_Out1(DISP_CS_PIN)	// deactivate chip selection
#define RES_ON	GPIO_Out0(DISP_RES_PIN); cb()	// activate reset
#define RES_OFF	cb(); GPIO_Out1(DISP_RES_PIN)	// deactivate reset
#define DC_CMD	GPIO_Out0(DISP_DC_PIN); cb()	// set command mode
#define DC_DATA	GPIO_Out1(DISP_DC_PIN); cb()	// set data mode

// frame buffer in RGB 5-6-5 pixel format
ALIGNED u16 FrameBuf[FRAMESIZE];

const u8 RotationTab[4] = { 0x00, 0x60, 0xc0, 0xa0 }; // rotation mode for ST7789_MADCTL
u8 DispRot;	// current display rotation
u16 DispWidth, DispHeight; // current display size

// dirty window to update
int DispDirtyX1, DispDirtyX2, DispDirtyY1, DispDirtyY2;

// last system time of auto update
u32 DispAutoUpdateLast;

// write command
void DispWriteCmd(u8 cmd)
{
	CS_ON;		// activate chip selection
	DC_CMD;		// set command mode
	SPI_Send8(DISP_SPI, &cmd, 1); // send command to SPI
	CS_OFF; 	// deactivate chip selection
}

// write data to display
void DispWriteData(const void* data, int len)
{
	CS_ON;		// activate chip selection
	DC_DATA;	// set data mode
	SPI_Send8(DISP_SPI, data, len); // send data to SPI
	CS_OFF; 	// deactivate chip selection
}

// write command and data to display
void DispWriteCmdData(u8 cmd, const void* data, int len)
{
	CS_ON;		// activate chip selection
	DC_CMD;		// set command mode
	SPI_Send8(DISP_SPI, &cmd, 1); // send command to SPI
	DC_DATA;	// set data mode
	SPI_Send8(DISP_SPI, data, len); // send data to SPI
	CS_OFF; 	// deactivate chip selection
}

// hard reset display
void DispHardReset()
{
	CS_ON;		// activate chip selection
	RES_OFF;	// deactivate reset
	WaitMs(50);
	RES_ON;		// activate reset
	WaitMs(50);	// reset delay
	RES_OFF;	// deactivate reset
	WaitMs(150);	// wait for initialization
	CS_OFF; 	// deactivate chip selection
}

// soft reset display
void DispSoftReset()
{
	DispWriteCmd(ST7789_SWRESET);
	WaitMs(150);
}

// enable sleep mode
void DispSleepEnable()
{
	DispWriteCmd(ST7789_SLPIN);
}

// disable sleep mode
void DispSleepDisable()
{
	DispWriteCmd(ST7789_SLPOUT);
}

// enable inversion mode
void DispInvEnable()
{
	DispWriteCmd(ST7789_INVON);
}

// disable inversion mode
void DispInvDisable()
{
	DispWriteCmd(ST7789_INVOFF);
}

// set color mode COLOR_MODE_*
void DispColorMode(u8 mode)
{
	DispWriteCmdData(ST7789_COLMOD, &mode, 1);
}

// set display rotation
//  0 Portrait
//  1 Landscape
//  2 Inverted Portrait
//  3 Inverted Landscape
void DispRotation(u8 rot)
{
	DispRot = rot;	// save current display rotation
	if ((rot & 1) == 0)
	{
		// portrait
		DispWidth = 240;
		DispHeight = 320;
	}
	else
	{
		// landscape
		DispWidth = 320;
		DispHeight = 240;
	}
	DispWriteCmdData(ST7789_MADCTL, &RotationTab[rot], 1);
}	

// set draw window
void DispWindow(u16 x1, u16 x2, u16 y1, u16 y2)
{
	u16 buf[2];

	// set columns
	buf[0] = ENDIAN16(x1);
	buf[1] = ENDIAN16(x2-1);
	DispWriteCmdData(ST7789_CASET, buf, 4);

	// set rows
	buf[0] = ENDIAN16(y1);
	buf[1] = ENDIAN16(y2-1);
	DispWriteCmdData(ST7789_RASET, buf, 4);

	// send command to send data
	DispWriteCmd(ST7789_RAMWR);
}

// set dirty all frame buffer
void DispDirtyAll()
{
	DispDirtyX1 = 0;
	DispDirtyX2 = DispWidth;
	DispDirtyY1 = 0;
	DispDirtyY2 = DispHeight;
}

// set dirty none (clear after update)
void DispDirtyNone()
{
	DispDirtyX1 = DispWidth;
	DispDirtyX2 = 0;
	DispDirtyY1 = DispHeight;
	DispDirtyY2 = 0;
}

// update dirty area by rectangle (check valid range)
void DispDirtyRect(int x, int y, int w, int h)
{
	if (x < 0)
	{
		w += x;
		x = 0;
	}
	if (x + w > DispWidth) w = DispWidth - x;
	if (w <= 0) return;

	if (y < 0)
	{
		h += y;
		y = 0;
	}
	if (y + h > DispHeight) h = DispHeight - y;
	if (h <= 0) return;

	if (x < DispDirtyX1) DispDirtyX1 = x;
	if (x + w > DispDirtyX2) DispDirtyX2 = x + w;
	if (y < DispDirtyY1) DispDirtyY1 = y;
	if (y + h > DispDirtyY2) DispDirtyY2 = y + h;
}

// update dirty area by pixel (check valid range)
void DispDirtyPoint(int x, int y)
{
	if (((u32)x < (u32)DispWidth) && ((u32)y < (u32)DispHeight))
	{
		if (x < DispDirtyX1) DispDirtyX1 = x;
		if (x + 1 > DispDirtyX2) DispDirtyX2 = x + 1;
		if (y < DispDirtyY1) DispDirtyY1 = y;
		if (y + 1 > DispDirtyY2) DispDirtyY2 = y + 1;
	}
}

// update - send dirty window to display
void DispUpdate()
{
	if ((DispDirtyX1 < DispDirtyX2) && (DispDirtyY1 < DispDirtyY2))
	{
		// set draw window
		DispWindow((u16)DispDirtyX1, (u16)DispDirtyX2, (u16)DispDirtyY1, (u16)DispDirtyY2);

		// send data from frame buffer
		u16* s0 = &FrameBuf[DispDirtyX1 + DispDirtyY1*DispWidth];
		int i;//, j;
		for (i = DispDirtyY2 - DispDirtyY1; i > 0; i--)
		{
			DispWriteData(s0, (DispDirtyX2 - DispDirtyX1)*2);
			s0 += DispWidth;
		}

		// set dirty none
		DispDirtyNone();
	}
}

// auto update after delta time in [ms] of running program
void DispAutoUpdate(u32 ms)
{
	// interval in [us]
	u32 us = ms*1000;

	// check interval from last update
	if ((u32)(Time() - DispAutoUpdateLast) >= us)
	{
		// update display
		DispUpdate();

		// start measure new time interval of running program
		DispAutoUpdateLast = Time();
	}
}

// refresh update all display
void DispUpdateAll()
{
	// set dirty all frame buffer
	DispDirtyAll();

	// update - send dirty window to display
	DispUpdate();
}

// initialize display
//  rot ... rotation mode
//		0 Portrait
//		1 Landscape
//		2 Inverted Portrait
//		3 Inverted Landscape
void DispInit(u8 rot)
{
	// SPI initialize
	SPI_Init(DISP_SPI, DISP_SPI_BAUD);
	SPI_Pol(DISP_SPI, 1); // polarity 1
	SPI_Phase(DISP_SPI, 1); // phase 1

	// setup pins
	GPIO_Out0(DISP_BLK_PIN);
	GPIO_DirOut(DISP_BLK_PIN);
	GPIO_Fnc(DISP_BLK_PIN, GPIO_FNC_SIO);

	GPIO_Out1(DISP_DC_PIN);
	GPIO_DirOut(DISP_DC_PIN);
	GPIO_Fnc(DISP_DC_PIN, GPIO_FNC_SIO);

	GPIO_Out1(DISP_SCK_PIN);
	GPIO_DirOut(DISP_SCK_PIN);
	GPIO_Fnc(DISP_SCK_PIN, GPIO_FNC_SPI);

	GPIO_Out1(DIDP_MOSI_PIN);
	GPIO_DirOut(DIDP_MOSI_PIN);
	GPIO_Fnc(DIDP_MOSI_PIN, GPIO_FNC_SPI);

	GPIO_Out1(DISP_RES_PIN);
	GPIO_DirOut(DISP_RES_PIN);
	GPIO_Fnc(DISP_RES_PIN, GPIO_FNC_SIO);

	GPIO_Out1(DISP_CS_PIN);
	GPIO_DirOut(DISP_CS_PIN);
	GPIO_Fnc(DISP_CS_PIN, GPIO_FNC_SIO);

	// display initialize
	DispHardReset();	// hard reset
	DispSoftReset();	// soft reset
	DispSleepDisable();	// disable sleep mode

	u8 buf[2];
	buf[0] =		// data of RAM control 1 (default 0x00)
		0 +		//   B1,B0: interface 0 MCU, 1 RGB, 2 VSYNC
		0;		//   B4: ram access from 0 MCU, 1 RGB
	buf[1] =		// data of RAM control 2 (default 0xF0)
		0 +		//   B1,B0: method of pixel data transfer
		//B2 +		//   B2: RGB interface bus width 0=18 bits, 1=6 bits
		B3 +		//   B3: endian 0=big MSB first, 1=little LSB first
		(2<<4) +	//   B5,B4: align 65K data with bit 0: 0=equ 0, 1=equ 1, 2=equ high bit, 3=equ green bit 0
		B6+B7;		//   B7,B6: 1
	DispWriteCmdData(ST7789_RAMCTRL, buf, 2); // set RAM control

	DispColorMode(COLOR_MODE_65K | COLOR_MODE_16BIT); // set color mode to RGB 16-bit 565
	WaitMs(50);
	DispRotation(rot);	// set rotation mode
	DispInvEnable();	// enable inversion
	WaitMs(10);
	GPIO_Out1(DISP_BLK_PIN); // set backlight on

	// clear display
	int i;
	for (i = 0; i < FRAMESIZE; i++) FrameBuf[i] = COL_BLACK;
	DispUpdateAll();	// update all display (for 1st time to avoid display flickering)
	DispWriteCmd(ST7789_DISPON); // enable display
	DispUpdateAll();	// update all display
}

// terminate display
void DispTerm()
{
	// clear display
	int i;
	for (i = 0; i < FRAMESIZE; i++) FrameBuf[i] = COL_BLACK;
	DispUpdateAll();	// update all display (for 1st time to avoid display flickering)

	// disable display
	DispWriteCmd(ST7789_DISPOFF);

	// terminate pins
	GPIO_Reset(DISP_BLK_PIN);
	GPIO_Reset(DISP_DC_PIN);
	GPIO_Reset(DISP_SCK_PIN);
	GPIO_Reset(DIDP_MOSI_PIN);
	GPIO_Reset(DISP_RES_PIN);
	GPIO_Reset(DISP_CS_PIN);
}

#endif // USE_ST7789		// use ST7789 TFT display (st7789.c, st7789.h)

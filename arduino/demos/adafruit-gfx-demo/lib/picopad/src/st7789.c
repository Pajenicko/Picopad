
// ****************************************************************************
//
//                          Display controller ST7789
//
// ****************************************************************************
// PicoLibSDK - Alternative SDK library for Raspberry Pico and RP2040
// Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz, hardyplotter2@gmail.com
// 	https://github.com/Panda381/PicoLibSDK
//	https://www.breatharian.eu/hw/picolibsdk/index_en.html
//	https://github.com/pajenicko/picopad
//	https://picopad.eu/en/
// License:
//	This source code is freely available for any purpose, including commercial.
//	It is possible to take and modify the code or parts of it, without restriction.

#include "picopad.h"

#if USE_ST7789		// use ST7789 TFT display (st7789.c, st7789.h)

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

#define ST7789_MADCTL_MY	0x80	// B7: page address order (0=top to bottom, 1=bottom to top)
#define ST7789_MADCTL_MX	0x40	// B6: column address order (0=left to right, 1=right to left)
#define ST7789_MADCTL_MV	0x20	// B5: page/column order (0=normal mode, 1=reverse mode)
#define ST7789_MADCTL_ML	0x10	// B4: line address order (LCD refresh 0=top to bottom, 1=bottom to top)
#define ST7789_MADCTL_RGB	0x08	// B3: RGB/BGR order (0=RGB, 1=BGR)
#define ST7789_MADCTL_MH	0x04	// B2: display latch order (LD refresh 0=left to right, 1=right to left)

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
//   B3: endian 0=big MSB first, 1=little LSB first (little endian LSB MSB = Intel, big endian MSB LSB = Motorola)
//   B5,B4: align 65K data with bit 0: 0=equ 0, 1=equ 1, 2=equ high bit, 3=equ green bit 0
//   B7,B6: 1

// color mode ST7789_COLMOD (select both color space and data format)
#define COLOR_MODE_65K		0x50	// 65K-color space (RGB 5-6-5)
#define COLOR_MODE_262K		0x60	// 262K-color space (RGB 6-6-6)
#define COLOR_MODE_12BIT	0x03	// 12-bit data, 4K-color space (RGB 4-4-4)
#define COLOR_MODE_16BIT	0x05	// 16-bit data (RGB 5-6-5)
#define COLOR_MODE_18BIT	0x06	// 18-bit data (RGB 6-6-6)
#define COLOR_MODE_16M		0x07	// 24-bit data (RGB 8-8-8)

#define CS_ON	GPIO_Out0(DISP_CS_PIN); _cb()	// activate chip selection
#define CS_OFF	_cb(); GPIO_Out1(DISP_CS_PIN)	// deactivate chip selection
#define RES_ON	GPIO_Out0(DISP_RES_PIN); _cb()	// activate reset
#define RES_OFF	_cb(); GPIO_Out1(DISP_RES_PIN)	// deactivate reset
#define DC_CMD	GPIO_Out0(DISP_DC_PIN); _cb()	// set command mode
#define DC_DATA	GPIO_Out1(DISP_DC_PIN); _cb()	// set data mode

#if USE_FRAMEBUF	// use default display frame buffer
// frame buffer in RGB 5-6-5 pixel format
ALIGNED u16 FrameBuf[FRAMESIZE];
#endif // USE_FRAMEBUF

#if USE_EMUSCREENSHOT		// use emulator screen shots
volatile Bool DoEmuScreenShot = False;	// request to do emulator screenshot
#endif

// rotation mode for ST7789_MADCTL
const u8 RotationTab[4] = {
	0x00,		// 0: Portrait
	0x60,		// 1: Landscape (ST7789_MADCTL_MX + ST7789_MADCTL_MV)
	0xc0,		// 2: Inverted Portrait (ST7789_MADCTL_MY + ST7789_MADCTL_MX)
	0xa0,		// 3: Inverted Landscape (ST7789_MADCTL_MY + ST7789_MADCTL_MV)
};

//u8 DispRot;			// current display rotation 0..3

// dirty window to update
int DispDirtyX1, DispDirtyX2, DispDirtyY1, DispDirtyY2;

// strip of back buffer
/*
u16* pDrawBuf = FrameBuf; // current draw buffer
int DispStripInx = 0;	// current index of back buffer strip
int DispMinY = 0;	// minimal Y; base of back buffer strip
int DispMaxY = HEIGHT;	// maximal Y + 1; end of back buffer strip
*/

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

#if USE_DISP_DMA		// use DMA output do LCD display
// write data to display using DMA
void DispWriteDataDMA(const void* data, int len)
{
	CS_ON;		// activate chip selection
	DC_DATA;	// set data mode
	SPI_Send8DMA(DISP_SPI, DMA_TEMP_CHAN(), (const u8*)data, len); // send data to SPI, using DMA
	CS_OFF; 	// deactivate chip selection
}
#endif // USE_DISP_DMA

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

#if USE_FRAMEBUF

// set dirty all frame buffer
void DispDirtyAll()
{
	DispDirtyX1 = 0;
	DispDirtyX2 = WIDTH;
	DispDirtyY1 = 0;
	DispDirtyY2 = HEIGHT;
}

// set dirty none (clear after update)
void DispDirtyNone()
{
	DispDirtyX1 = WIDTH;
	DispDirtyX2 = 0;
	DispDirtyY1 = HEIGHT;
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
	if (x + w > WIDTH) w = WIDTH - x;
	if (w <= 0) return;

	if (y < 0)
	{
		h += y;
		y = 0;
	}
	if (y + h > HEIGHT) h = HEIGHT - y;
	if (h <= 0) return;

	if (x < DispDirtyX1) DispDirtyX1 = x;
	if (x + w > DispDirtyX2) DispDirtyX2 = x + w;
	if (y < DispDirtyY1) DispDirtyY1 = y;
	if (y + h > DispDirtyY2) DispDirtyY2 = y + h;
}

// update dirty area by pixel (check valid range)
void DispDirtyPoint(int x, int y)
{
	if (((u32)x < (u32)WIDTH) && ((u32)y < (u32)HEIGHT))
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
		// synchronize external display (to start waiting for active CS)
		u8 d = 0xff;
		CS_OFF; 	// deactivate chip selection
		DC_CMD;		// set command mode
		SPI_Send8(DISP_SPI, &d, 1); // send data to SPI

		// set draw window
		DispWindow((u16)DispDirtyX1, (u16)DispDirtyX2, (u16)DispDirtyY1, (u16)DispDirtyY2);

		// send data from frame buffer
		u16* s0 = &FrameBuf[DispDirtyX1 + DispDirtyY1*WIDTH];
		int i;
#if USE_DISP_DMA		// use DMA output do LCD display
		if (DispDirtyX2 - DispDirtyX1 > 20)
		{
			for (i = DispDirtyY2 - DispDirtyY1; i > 0; i--)
			{
				DispWriteDataDMA(s0, (DispDirtyX2 - DispDirtyX1)*2);
				s0 += WIDTH;
			}
		}
		else
#endif // USE_DISP_DMA
		{
			for (i = DispDirtyY2 - DispDirtyY1; i > 0; i--)
			{
				DispWriteData(s0, (DispDirtyX2 - DispDirtyX1)*2);
				s0 += WIDTH;
			}
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

#endif

void DispClear() {
	DispWindow(0, WIDTH, 0, HEIGHT);
	u16 row[WIDTH] = {0};
	memset(&row, 0, WIDTH * 2);

	for (int i = 0; i < HEIGHT; i++)
		DispWriteData(&row, WIDTH * 2);
}

// display backlight control
void DispBacklight(u8 backlight)
{
	PWM_Comp(BACKLIGHT_SLICE, BACKLIGHT_CHAN, backlight);
}

// display backlight control config update
void DispBacklightUpdate()
{
#if USE_CONFIG			// use device configuration (lib_config.c, lib_config.h)
	DispBacklight(Config.backlight);
#else
	DispBacklight(255);
#endif
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
	// TODO TVE is it necessary?
	//spi_set_format(DISP_SPI, 8, SPI_CPOL_1, SPI_CPHA_1, SPI_MSB_FIRST);

	// setup backlight PWM
	PWM_Reset(BACKLIGHT_SLICE);
	PWM_GpioInit(DISP_BLK_PIN);
	uint PWM_GPIO_SLICE = pwm_gpio_to_slice_num(DISP_BLK_PIN);
	gpio_set_function(DISP_BLK_PIN, GPIO_FUNC_PWM);
	pwm_config config = pwm_get_default_config();
	//  125 MHz: 125000000/5644800 = 22.144, INT=22, FRAC=2,
	pwm_config_set_clkdiv_int_frac(&config, 22, 2);
	pwm_config_set_wrap(&config, 255);
	DispBacklight(0);
	pwm_init(PWM_GPIO_SLICE, &config, true);

	// setup pins
	GPIO_Out1(DISP_DC_PIN);
	GPIO_DirOut(DISP_DC_PIN);
	GPIO_Fnc(DISP_DC_PIN, GPIO_FNC_SIO);
//	GPIO_Drive4mA(DISP_DC_PIN);

	GPIO_Out1(DISP_SCK_PIN);
	GPIO_DirOut(DISP_SCK_PIN);
	GPIO_Fnc(DISP_SCK_PIN, GPIO_FNC_SPI);
	GPIO_Drive8mA(DISP_SCK_PIN); // required by extern display

	GPIO_Out1(DISP_MOSI_PIN);
	GPIO_DirOut(DISP_MOSI_PIN);
	GPIO_Fnc(DISP_MOSI_PIN, GPIO_FNC_SPI);
//	GPIO_Drive4mA(DISP_MOSI_PIN);

	GPIO_Out1(DISP_RES_PIN);
	GPIO_DirOut(DISP_RES_PIN);
	GPIO_Fnc(DISP_RES_PIN, GPIO_FNC_SIO);
//	GPIO_Drive4mA(DISP_RES_PIN);

	GPIO_Out1(DISP_CS_PIN);
	GPIO_DirOut(DISP_CS_PIN);
	GPIO_Fnc(DISP_CS_PIN, GPIO_FNC_SIO);
//	GPIO_Drive4mA(DISP_CS_PIN);

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
		B3 +		//   B3: endian 0=big MSB first, 1=little LSB first (little endian LSB MSB = Intel, big endian MSB LSB = Motorola)
		(2<<4) +	//   B5,B4: align 65K data with bit 0: 0=equ 0, 1=equ 1, 2=equ high bit, 3=equ green bit 0
		B6+B7;		//   B7,B6: 1
	DispWriteCmdData(ST7789_RAMCTRL, buf, 2); // set RAM control

	DispColorMode(COLOR_MODE_65K | COLOR_MODE_16BIT); // set color mode to RGB 16-bit 565
	WaitMs(50);
	DispRotation(rot);	// set rotation mode
	DispInvEnable();	// enable inversion
	WaitMs(10);

	DispBacklightUpdate();	// update backlight

	// strip of back buffer
/*
	pDrawBuf = FrameBuf;	// current draw buffer
	DispStripInx = 0;	// current index of back buffer strip
	DispMinY = 0;		// minimal Y; base of back buffer strip
	DispMaxY = HEIGHT;	// maximal Y + 1; end of back buffer strip
*/

	// clear display
#if USE_FRAMEBUF	// use default display frame buffer
	int i;
	for (i = 0; i < FRAMESIZE; i++) FrameBuf[i] = 0;
	DispUpdateAll();	// update all display (for 1st time to avoid display flickering)
	DispWriteCmd(ST7789_DISPON); // enable display
	DispUpdateAll();	// update all display
#else
	DispClear();
	DispWriteCmd(ST7789_DISPON); // enable display
	DispClear();
#endif // USE_FRAMEBUF
}

// terminate display
void DispTerm()
{
#if USE_FRAMEBUF	// use default display frame buffer
	// clear display
	int i;
	for (i = 0; i < FRAMESIZE; i++) FrameBuf[i] = 0;
	DispUpdateAll();	// update all display (for 1st time to avoid display flickering)
#endif

	// disable display
	DispWriteCmd(ST7789_DISPOFF);

	// terminate backlight PWM
	PWM_Disable(BACKLIGHT_SLICE);
	PWM_Reset(BACKLIGHT_SLICE);
	GPIO_Reset(DISP_BLK_PIN);

	// terminate pins
	GPIO_Reset(DISP_DC_PIN);
	GPIO_Reset(DISP_SCK_PIN);
	GPIO_Reset(DISP_MOSI_PIN);
	GPIO_Reset(DISP_RES_PIN);
	GPIO_Reset(DISP_CS_PIN);
}

#endif // USE_ST7789		// use ST7789 TFT display (st7789.c, st7789.h)
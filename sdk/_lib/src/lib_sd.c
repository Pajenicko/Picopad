
// ****************************************************************************
//                                 
//                                 SD card
//
// ****************************************************************************

#include "../../global.h"	// globals

#if USE_SD		// use SD card (lib_sd.c, lib_sd.h)

#include "../../_sdk/inc/sdk_spi.h"
#include "../../_sdk/inc/sdk_gpio.h"
#include "../../_sdk/inc/sdk_timer.h"

#if USE_FAT	// use FAT file system (lib_fat.c, lib_fat.h)
#include "../inc/lib_fat.h"
#else
#ifndef SECT_SIZE
#define SECT_SIZE 512
#endif
#endif

// SPI speed (warning - speed 0 is unreliable)
//  3: clk/64=340 kHz, 2: clk/32=690 kHz, 1: clk/8 = 2.8 MHz, 0: clk/2 = 11 MHz
//#define SPISPEED	1	// SPI speed 0..3

// SD card type
u8 SDType = SD_NONE;

// SD card type name
const char SDName0[] = "-no-";
const char SDName1[] = "MMC";
const char SDName2[] = "SDv1";
const char SDName3[] = "SDv2";
const char SDName4[] = "SDHC";
const char* const SDName[5] = { SDName0, SDName1, SDName2, SDName3, SDName4 };

// SD buffer
u8 SDBuf[16];

// MMC/SD commands (ACMD<n> = command sequence CMD55 - CMD<n>)
#define ACMD 0x80	// ACMD command flag

#define CMD0_IDLE	0		// GO_IDLE_STATE (start SPI mode, software reset), response R1
#define CMD1_MMCOP	1		// SEND_OP_COND (MMC), initiate initialization process, response R1
#define CMD8_IF		8		// SEND_IF_COND, only SDC V2, check voltage range, response R7
#define CMD9_CSD	9		// SEND_CSD, read CSD register, response R1
#define CMD10_CID	10		// SEND_CID, read CID register, response R1
#define CMD12_STOP	12		// STOP_TRANSMISSION, stop to read data, response R1
#define ACMD13_STATE	(ACMD+13)	// SD_STATUS (SDC)
#define CMD13_STATUS	13		// SEND_STATUS, response R2
#define CMD16_SETLEN	16		// SET_BLOCKLEN (arg=block length), change R/W block size, response R1
#define CMD17_READ1	17		// READ_SINGLE_BLOCK (arg=data address), response R1
#define CMD18_READMUL	18		// READ_MULTIPLE_BLOCK (arg=data address), response R1
//#define CMD23_SETCNT	23		// SET_BLOCK_COUNT (MMC)
//#define ACMD23_ERASE	(ACMD+23)	// SET_WR_BLK_ERASE_COUNT (SDC), for only SDC, 
#define CMD24_WRITE1	24		// WRITE_SINGLE_BLOCK (arg=data address), write a block, response R1
#define CMD25_WRITEMUL	25		// WRITE_MULTIPLE_BLOCK (arg=data address), write multiple blocks, response R1
#define CMD27_PROGCSD	27		// PROGRAM_CSD, response R1
#define CMD28_SETWP	28		// SET_WRITE_PROT (arg=data address), set write protection, response R1b
#define CMD29_CLRWP	29		// CLR_WRITE_PROT (arg=data address), clear write protection, response R1b
#define CMD30_SNDRWP	30		// SEND_WRITE_PROT (arg=data address), send write protection, response R1
#define CMD32_ERASE_BEG	32		// ERASE_ER_BLK_START, TAG_SECTOR_START (arg=data address), response R1
#define CMD33_ERASE_END	33		// ERASE_ER_BLK_END, TAG_SECTOR_END (arg=data address), response R1
#define CMD34_UNTAG	34		// UNTAG_SECTOR (arg=data address), response R1
#define CMD35_GRP_BEG	35		// TAG_ERASE_GROUP_START (arg=data address), response R1
#define CMD36_GRP_END	36		// TAG_ERASE_GROUP_END (arg=data address), response R1
#define CMD37_GRP_UNTAG	37		// UNTAG_ERASE_GROUP (arg=data address), response R1
#define CMD38_ERASE	38		// ERASE (arg=stuff bits)
#define ACMD41_SDCOP	(ACMD+41)	// APP_SEND_OP_COND (only SDC, arg=OCR contents), initiate initialization process, response R1
#define CMD42_UNLOCK	42		// LOCK_UNLOCK (arg=stuff bits), response R1b
#define CMD55_APP	55		// APP_CMD (arg=stuff bits), leading command of ACMD<n> commads, response R1
#define CMD58_OCR	58		// READ_OCR (arg=stuff bits), read OCR, response R3
#define CMD59_CRC	59		// CRC_ON_OFF (arg=crc option), enable CRC, response R1

// R1 response (1 byte; R1b equals R1, with additional busy bytes):
#define R1_IDLE_STATE	B0	// in idle state
#define R1_ERASE_RESET	B1	// erase reset
#define R1_ILL_COMMAND	B2	// illegal command error
#define R1_COM_CRC_ERR	B3	// CRC error
#define R1_ERASE_ERR	B4	// erase sequence error
#define R1_ADDR_ERR	B5	// address error
#define R1_PARAM_ERR	B6	// parameter error

// R2 response (2 bytes); 1st byte is R1, 2nd byte:
#define R2_CARD_LOCKED	B0
#define R2_WPERASE_SKIP	B1
#define R2_ERR		B2
#define R2_CARD_ERR	B3
#define R2_ECC_FAIL	B4
#define R2_WP_VIOLATION	B5
#define R2_INVAL_ERASE	B6
#define R2_OUT_OF_RANGE	B7

// R3 response (5 bytes); 1st byte is R1, 2nd..5th byte:
#define R3_OCR_MASK	0xffffffffUL

// Data Response (1 byte):
#define DR_STATUS_MASK		0x0e
#define DR_STATUS_ACCEPTED	0x05
#define DR_STATUS_CRC_ERR	0x0a
#define DR_STATUS_WRITE_ERR	0x0c

// communication with SD card using SPI protocol:
// - to start SPI mode, unselect card (set CS to 1) and togle clock at least 74 cycles,
//   than select card (set CS to 0) and send CMD0 to reset card (0x40, 0, 0, 0, 0, 0x95)
//   (01 000000 00000000 00000000 00000000 00000000 1001010 1),
//   card should response (after max. 16 cycles) with 8 bits of status (0x01 on success) - R1 response
// - clock should be in range 100..400 kHz
// - command 48 bits (from highest bits to lowest):
//	b47: 0 start bit
//	b48: 1 start bit
//	b40..b45: command number (6 bits, 0..63)
//	b8..b39: argument (32 bits)
//	b1..b7: CRC (7 bits), ignored by default except CMD8
//	b0: 1 stop bit
//    or:
//      byte 5 (b40..b47): command and start bits
//	byte 4 (b32..b39): argument byte 3
//	byte 3 (b24..b31): argument byte 2
//	byte 2 (b16..b23): argument byte 1
//	byte 1 (b8..b15): argument byte 0
//	byte 0 (b0..b7): CRC and stop bit
//
// After sending command it requires 8 clock cycles before response.

// get SD card type name (in ROM)
const char* GetSDName()
{
	return SDName[SDType];
}

// send and receive SPI byte (to simple receive byte, send 0xff byte)
u8 SDByte(u8 data)
{
	// send byte
	while (SPI_TxIsFull(SD_SPI)) {}
	SPI_Write(SD_SPI, data);

	// read byte
	while (SPI_RxIsEmpty(SD_SPI)) {}
	return (u8)SPI_Read(SD_SPI);
}

// unselect SD card
static inline void SDUnsel()
{
	// set SS signal to HIGH (=unselect)
	GPIO_Out1(SD_CS);

	// send dummy clock to free SPI bus
	SDByte(0xff);
	SDByte(0xff);
	SDByte(0xff);
}

// select SD card
static inline void SDSel()
{
	// set CS signal to LOW (=select)
	GPIO_Out0(SD_CS);

	// send dummy clock to free SPI bus
	SDByte(0xff);
}

// send command with argument to SD card and return response (0 or 1 is OK, 0xff=timeout, other=error)
u8 SDSendCmd(u8 cmd, u32 arg)
{
	u8 res, n;

	// send leading command CMD55 of ACMD* command
	if ((cmd & ACMD) != 0)
	{
		cmd &= ~ACMD;
		res = SDSendCmd(CMD55_APP, 0);
		if (res > 1)
		{
			return res;
		}
	}

	// send dummy clock to free SPI bus
	SDByte(0xff);
	SDByte(0xff);
	SDByte(0xff);

	// send command packet
	SDByte(0x40 | cmd); // send command and start bits
	SDByte((u8)(arg >> 24)); // send byte 3 of the argument
	SDByte((u8)(arg >> 16)); // send byte 2 of the argument
	SDByte((u8)(arg >> 8)); // send byte 1 of the argument
	SDByte((u8)arg); // send byte 0 of the argument

	// send CRC
	n = 0xff; // dummy CRC and stop bit
	if (cmd == CMD0_IDLE) n = 0x95; // CRC for idle command
	if (cmd == CMD8_IF) n = 0x87; // CRC for IF command
	SDByte(n); // send CRC and stop bit

	// receive response (max. 10 attempts)
	for (n = 10; n > 0; n--)
	{
		// send dummy clock and get response
		res = SDByte(0xff);
		if ((res & 0x80) == 0) break;
	}

	// response (or 0xff on timeout error)
	return res;
}

// connect to SD card after inserting (returns False on error)
Bool SDConnect()
{
	u8 n, res;

	// unknown card type
	SDType = SD_NONE;

	// set SPI to low speed (250 kHz)
	SPI_Baudrate(SD_SPI, SD_BAUDLOW);

	// flush false received bytes
	SPI_RxFlush(SD_SPI);

	// unselect card (and send 3x FF)
	SDUnsel();

	// initialize connection - send 10 empty bytes (=80 clocks), takes 300 us
	for (n = 20; n > 0; n--) SDByte(0xff);

	// select SD card
	SDSel();

	// reset card and set SPI mode, go to idle mode
	for (n = 100; n > 0; n--)
	{
		res = SDSendCmd(CMD0_IDLE, 0);
		if (res == R1_IDLE_STATE) break;
	}

	// initialization timeout
	if (n == 0)
	{
		// unselect card
		SDUnsel();

		return False;
	}

	// we have at least MMC card
	SDType = SD_MMC;

	// check SD v2 card, switch to 3.3V
	res = SDSendCmd(CMD8_IF, 0x000001aa); // support 2.7-3.6V ?
	if ((res & R1_ILL_COMMAND) == 0)
	{
		SDByte(0xff);
		SDByte(0xff);
		res = SDByte(0xff);
		n = SDByte(0xff);
		if ((res == 1) && (n == 0xaa)) // check returned argument 0x000001aa
			SDType = SD_SD2;
	}

	// check SD v1 card
	if (SDType == SD_MMC)
	{
		res = SDSendCmd(ACMD41_SDCOP, 0);
		if ((res & R1_ILL_COMMAND) == 0) SDType = SD_SD1;
	}

	// wait for card to get ready (max. 0.3 second)
	for (n = 30; n > 0; n--)
	{
		// wait for initialization
		if (SDType == SD_SD2)
			res = SDSendCmd(ACMD41_SDCOP, B30);
		else if (SDType == SD_SD1)
			res = SDSendCmd(ACMD41_SDCOP, 0);
		else
			res = SDSendCmd(CMD1_MMCOP, 0);

		// initializadion completed
		if ((res & R1_IDLE_STATE) == 0) break;

		// wait 10 ms
		WaitMs(10);
	}

	// initialization timeout
	if (n == 0)
	{
		SDType = SD_NONE;

		// unselect card
		SDUnsel();

		return False;
	}

	// check SDHC card
	if (SDType == SD_SD2)
	{
		res = SDSendCmd(CMD58_OCR, 0);
		if (res <= 1)
		{
			if ((SDByte(0xff) & 0x40) != 0)
				SDType = SD_SDHC;
			SDByte(0xff);
			SDByte(0xff);
			SDByte(0xff);
		}
	}

	// set sector length to standard 512 bytes
	SDSendCmd(CMD16_SETLEN, SECT_SIZE);

	// unselect card
	SDUnsel();

	// set SPI to high speed
	SPI_Baudrate(SD_SPI, SD_BAUD);

	return True;
}

// disconnect SD card
void SDDisconnect()
{
	// set SPI to low speed (250 kHz)
	SPI_Baudrate(SD_SPI, SD_BAUDLOW);

	// unselect card
	SDUnsel();

	// invalidate disk type
	SDType = SD_NONE;
}

// read data block (returns False on error)
Bool SDReadBlock(u8* buffer, int num)
{
	// wait for data block (wait for start byte 0xfe)
	int n;
	u8 res;
	for(n = 60000; n > 0; n--)
	{
		res = SDByte(0xff);
		if (res != 0xff) break;
	}

	if (res != 0xfe) return False;

	// read data
	for (n = 0; n < num; n++) buffer[n] = SDByte(0xff);

	// get CRC16
	SDByte(0xff);
	SDByte(0xff);

	return True;
}

// open SD card
void SDOpen()
{
	// set SPI to high speed
	SPI_Baudrate(SD_SPI, SD_BAUD);

	// select SD card
	SDSel();

	// send dummy clock to free SPI bus
	SDByte(0xff);
	SDByte(0xff);
	SDByte(0xff);
}

// close SD card
void SDClose()
{
	// unselect card
	SDUnsel();

	// free SPI bus
	SDByte(0xff);
	SDByte(0xff);
	SDByte(0xff);
	SDByte(0xff);
}

// read one sector from SD card (returns False on error)
Bool SDReadSect(u32 sector, u8* buffer)
{
	// check if card is connected
	if (SDType == SD_NONE) return False;

	// open SD card
	SDOpen();

	// convert sector number to offset
	if (SDType != SD_SDHC) sector *= SECT_SIZE;

	// send command to get single block
	u8 res = SDSendCmd(CMD17_READ1, sector);
	if (res != 0)
	{
		// unselect card
		SDUnsel();

		return False;
	}

	// receive data block
	res = SDReadBlock(buffer, SECT_SIZE);

	// close SD card
	SDClose();

	return res;
}

// write one sector to SD card (returns False on error)
Bool SDWriteSect(u32 sector, const u8* buffer)
{
	// check if card is connected
	if (SDType == SD_NONE) return False;

	// open SD card
	SDOpen();

	// convert sector number to offset
	if (SDType != SD_SDHC) sector *= SECT_SIZE;

	// send command to write single block
	u8 res = SDSendCmd(CMD24_WRITE1, sector);
	if (res != 0)
	{
		// unselect card
		SDUnsel();

		return False;
	}

	// wait for card is ready
	int n;
	for(n = 60000; n > 0; n--)
	{
		res = SDByte(0xff);
		if (res == 0xff) break;
	}

	if (n == 0)
	{
		// unselect card
		SDUnsel();

		return False;
	}

	// send start byte
	SDByte(0xfe);

	// write data
	for (n = 0; n < SECT_SIZE; n++) SDByte(buffer[n]);

	// set CRC16
	SDByte(0xff);
	SDByte(0xff);

	// wait while card is busy
	for(n = 60000; n > 0; n--)
	{
		res = SDByte(0xff);
		if (res == 0xff) break;
	}
	SDByte(0xff);

	// close SD card
	SDClose();

	return True;
}

// get media size (in number of sectors; returns 0 on error)
u32 SDMediaSize()
{
	// check if card is connected
	if (SDType == SD_NONE) return 0;

	// open SD card
	SDOpen();

	// send command to read CSD
	u32 size = 0;
	if ((SDSendCmd(CMD9_CSD, 0) == 0) && SDReadBlock(SDBuf, 16))
	{
		// SDC ver 2.00
		if ((SDBuf[0] >> 6) == 1)
		{
			u32 csize = SDBuf[9] + ((u32)SDBuf[8] << 8) + ((u32)(SDBuf[7] & 0x3f) << 16) + 1;
			size = csize << 10;
		}
		// SDC ver 1.xx or MMC ver 3
		else
		{
			u8 n = (SDBuf[5] & 0xf) + ((SDBuf[10] & 0x80) >> 7) + ((SDBuf[9] & 0x03) << 1) + 2;
			u32 csize = (SDBuf[8] >> 6) + ((u32)SDBuf[7] << 2) + ((u32)(SDBuf[6] & 0x03) << 10) + 1;
			size = csize << (n - 9);
		}
	}

	// close SD card
	SDClose();

	return size;
}

// initialize SD card interface (must be re-initialized after changing system clock)
void SDInit()
{
	// initialize SPI interface
	//   Motorola format: MSB first, master mode, SCK low when idle (leading edge rising, trailing
	//	edge falling), clock phase: leading edge sample, trailing edge setup, 8 data bits
	SPI_Init(SD_SPI, SD_BAUDLOW);

	// initialize pins
	GPIO_Fnc(SD_RX, GPIO_FNC_SPI);
	GPIO_Fnc(SD_SCK, GPIO_FNC_SPI);
	GPIO_Fnc(SD_TX, GPIO_FNC_SPI);

	// initialize CS (active state is LOW)
	GPIO_Init(SD_CS);
	GPIO_Out1(SD_CS);
	GPIO_DirOut(SD_CS);
}

// terminate SD card interface
void SDTerm()
{
	// set SS signal to HIGH (=unselect)
	GPIO_Out1(SD_CS);

	// SPI terminate
	SPI_Term(SD_SPI);

	// terminate pins
	GPIO_Reset(SD_RX);
	GPIO_Reset(SD_SCK);
	GPIO_Reset(SD_TX);
	GPIO_Reset(SD_CS);
}

#endif // USE_SD		// use SD card (lib_sd.c, lib_sd.h)

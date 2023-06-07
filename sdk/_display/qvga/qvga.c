
// ****************************************************************************
//
//                                  QVGA
//
// ****************************************************************************
// VGA resolution:
// - 640x480 pixels
// - vertical frequency 60 Hz
// - horizontal frequency 31.4685 kHz
// - pixel clock 25.175 MHz
//
// QVGA resolution:
// - 320x240 pixels
// - vertical double image scanlines
// - vertical frequency 60 Hz
// - horizontal frequency 31.4685 kHz
// - pixel clock 12.5875 MHz
//
// VGA vertical timings:
// - 525 scanlines total
// - line 1,2: (2) vertical sync
// - line 3..35: (33) dark
// - line 36..515: (480) image lines 0..479
// - line 516..525: (10) dark
//
// VGA horizontal timings:
// - 31.77781 total scanline in [us] (800 pixels, QVGA 400 pixels)
// - 0.63556 H front porch (after image, before HSYNC) in [us] (16 pixels, QVGA 8 pixels)
// - 3.81334 H sync pulse in [us] (96 pixels, QVGA 48 pixels)
// - 1.90667 H back porch (after HSYNC, before image) in [us] (48 pixels, QVGA 24 pixels)
// - 25.42224 H full visible in [us] (640 pixels, QVGA 320 pixels)
// - 0.0397222625 us per pixel at VGA, 0.079444525 us per pixel at QVGA
//
// We want reach 25.175 pixel clock (at 640x480). Default system clock is 125 MHz, which is
// approx. 5x pixel clock. We need 25.175*5 = 125.875 MHz. We use nearest frequency 126 MHz.
//	126000, 1512000, 126, 6, 2,     // 126.00MHz, VC0=1512MHz, FBDIV=126, PD1=6, PD2=2
//	126000, 504000, 42, 4, 1,       // 126.00MHz, VC0=504MHz, FBDIV=42, PD1=4, PD2=1
//	sysclk=126.000000 MHz, vco=504 MHz, fbdiv=42, pd1=4, pd2=1
//	sysclk=126.000000 MHz, vco=504 MHz, fbdiv=42, pd1=2, pd2=2
//	sysclk=126.000000 MHz, vco=756 MHz, fbdiv=63, pd1=6, pd2=1
//	sysclk=126.000000 MHz, vco=756 MHz, fbdiv=63, pd1=3, pd2=2
//	sysclk=126.000000 MHz, vco=1008 MHz, fbdiv=84, pd1=4, pd2=2 !!!!!
//	sysclk=126.000000 MHz, vco=1260 MHz, fbdiv=105, pd1=5, pd2=2
//	sysclk=126.000000 MHz, vco=1512 MHz, fbdiv=126, pd1=6, pd2=2
//	sysclk=126.000000 MHz, vco=1512 MHz, fbdiv=126, pd1=4, pd2=3
// Pixel clock is now:
//      5 system clock ticks per pixel at VGA ... pixel clock = 25.2 MHz, 0.039683 us per pixel
//     10 system clock ticks per pixel at QVGA ... pixel clock = 12.6 MHz, 0.079365 us per pixel
//
// - active image is 640*5=3200 clock ticks = 25.3968 us (QVGA: 1600 clock ticks)
// - total scanline is 126*31.77781=4004 clock ticks (QVGA: 2002 clock ticks)
// - H front porch = 82 clock ticks (QVGA: 41 clock ticks)
// - H sync pulse = 480 clock ticks (QVGA: 240 clock ticks)
// - H back porch = 242 clock ticks (QVGA: 121 clock ticks)

// in case of system clock = 125 MHz
// - PIO clock = system clock / 2
// - 5 PIO clocks per pixel = 10 system clocks per pixel
// - PIO clock = 62.5 MHz
// - pixel clock = 12.5 MHz
// - active image (320 pixels): 320*5 = 1600 PIO clocks = 3200 system ticks = 25.6 us (2.2 pixels stays invisible)
// - total scanline: 125*31.77781 = 3972 system clocks = 1986 PIO clocks
// - H front porch = 34 PIO clk
// - H sync = 238 PIO clk
// - H back = 114 PIO clk

#include "../../global.h"	// globals

#if USE_QVGA		// use QVGA display (qvga.c, qvga.h)

#include "qvga.h"
//#include "../qvga.pio.h"
#include "../../_key/key56.h"
#include "sdk_cpu.h"
#include "sdk_pio.h"
#include "sdk_dma.h"
#include "sdk_irq.h"
#include "sdk_pll.h"
#include "sdk_gpio.h"
#include "sdk_clocks.h"
#include "sdk_multicore.h"

#undef PICO_NO_HARDWARE
#define PICO_NO_HARDWARE 1	// this switch is not use on other places of the SDK, only in PIO program
#include "../qvga.pio.h"

// PIO command (jmp=program address, num=loop counter)
#define QVGACMD(jmp, num) ( ((u32)((jmp)+QVGAOff)<<27) | (u32)(num))

// pointer to current frame buffer
u8* pFrameBuf;

// QVGA PIO
uint QVGAOff;	// offset of QVGA PIO program

// Scanline data buffers (commands sent to PIO)
u32 ScanLineImg[3];	// image: HSYNC ... back porch ... image command
u32 ScanLineFp;		// front porch
u32 ScanLineDark[2];	// dark: HSYNC ... back porch + dark + front porch
u32 ScanLineSync[2];	// vertical sync: VHSYNC ... VSYNC(back porch + dark + front porch)

// Scanline control buffers
#define CB_MAX 8	// size of one scanline control buffer (1 link to data buffer requires 2x u32)
u32 ScanLineCB[2*CB_MAX]; // 2 control buffers
int QVgaBufInx;		// current running control buffer
u32* ScanLineCBNext;	// next control buffer

// handler variables
volatile int QVgaScanLine; // current processed scan line 0... (next displayed scan line)
volatile u32 QVgaFrame;	// frame counter

// VGA DMA handler - called on end of every scanline
void NOFLASH(QVgaLine)()
{
	// Clear the interrupt request for DMA control channel
	DMA_IRQ0Clear(QVGA_DMA_PIO);

	// update DMA control channel and run it
	DMA_SetReadTrig(QVGA_DMA_CB, ScanLineCBNext);

	// switch current buffer index (bufinx = current preparing buffer, MiniVgaBufInx = current running buffer)
	int bufinx = QVgaBufInx;
	QVgaBufInx = bufinx ^ 1;

	// prepare control buffer to be processed
	u32* cb = &ScanLineCB[bufinx*CB_MAX];
	ScanLineCBNext = cb;

	// increment scanline (1..)
	int line = QVgaScanLine; // current scanline
	line++; 		// new current scanline
	if (line >= QVGA_VTOT) // last scanline?
	{
		QVgaFrame++;	// increment frame counter
		line = 0; 	// restart scanline
	}
	QVgaScanLine = line;	// store new scanline

	// check scanline
	line -= QVGA_VSYNC;
	if (line < 0)
	{
		KeyScan();

		// VSYNC
		*cb++ = 2;
		*cb++ = (u32)&ScanLineSync[0];
	}
	else
	{
		// front porch and back porch
		line -= QVGA_VBACK;
		if ((line < 0) || (line >= QVGA_VACT))
		{
			// dark line
			*cb++ = 2;
			*cb++ = (u32)&ScanLineDark[0];
		}

		// image scanlines
		else
		{
			// prepare image line
			line >>= 1;

			// HSYNC ... back porch ... image command
			*cb++ = 3;
			*cb++ = (u32)&ScanLineImg[0];

			// image data
			*cb++ = WIDTH/4;
			*cb++ = (u32)&pFrameBuf[line*WIDTH];

			// front porch
			*cb++ = 1;
			*cb++ = (u32)&ScanLineFp;
		}
	}

	// end mark
	*cb++ = 0;
	*cb = 0;
}

// initialize QVGA PIO
void QVgaPioInit()
{
	// initialize PIO
	PioInit(QVGA_PIO);

	// load PIO program
	QVGAOff = 0;
	PioLoadProg(QVGA_PIO, qvga_program_instructions, count_of(qvga_program_instructions), QVGAOff);

	// PIO set wrap address
	PioSetWrap(QVGA_PIO, QVGA_SM, QVGAOff + qvga_wrap_target, QVGAOff + qvga_wrap);

	// set start address
	PioSetAddr(QVGA_PIO, QVGA_SM, QVGAOff+qvga_offset_entry);

	// configure GPIOs for use by PIO
	PioSetupGPIO(QVGA_PIO, QVGA_GPIO_FIRST, QVGA_GPIO_NUM);
	PioSetupGPIO(QVGA_PIO, QVGA_GPIO_HSYNC, 2);

	// set pin direction to output
	PioSetPinDir(QVGA_PIO, QVGA_SM, QVGA_GPIO_FIRST, QVGA_GPIO_NUM, 1);
	PioSetPinDir(QVGA_PIO, QVGA_SM, QVGA_GPIO_HSYNC, 2, 1);

	// negate HSYNC and VSYNC output
	GPIO_OutOverInvert(QVGA_GPIO_HSYNC);
	GPIO_OutOverInvert(QVGA_GPIO_VSYNC);

	// map state machine's OUT and MOV pins	
	PioSetupOut(QVGA_PIO, QVGA_SM, QVGA_GPIO_FIRST, QVGA_GPIO_NUM);

	// set sideset pins (HSYNC and VSYNC, 2 bits, no optional, no pindirs)
	PioSetupSideset(QVGA_PIO, QVGA_SM, QVGA_GPIO_HSYNC, 2, False, False);

	// join FIFO to send only
	PioSetFifoJoin(QVGA_PIO, QVGA_SM, PIO_FIFO_JOIN_TX);

	// PIO clock divider
	PioSetClkdiv(QVGA_PIO, QVGA_SM, QVGA_CLKDIV*256);

	// shift right, autopull, pull threshold
	PioSetOutShift(QVGA_PIO, QVGA_SM, True, True, 32);
}

// initialize scanline buffers
void QVgaBufInit()
{
	// image scanline data buffer: HSYNC ... back porch ... image command
	ScanLineImg[0] = QVGACMD(qvga_offset_hsync, QVGA_HSYNC-3); // HSYNC
	ScanLineImg[1] = QVGACMD(qvga_offset_dark, QVGA_BP-4); // back porch
	ScanLineImg[2] = QVGACMD(qvga_offset_output, WIDTH-2); // image

	// front porch
	ScanLineFp = QVGACMD(qvga_offset_dark, QVGA_FP-4); // front porch

	// dark scanline: HSYNC ... back porch + dark + front porch
	ScanLineDark[0] = QVGACMD(qvga_offset_hsync, QVGA_HSYNC-3); // HSYNC
	ScanLineDark[1] = QVGACMD(qvga_offset_dark, QVGA_TOTAL-QVGA_HSYNC-4); // back porch + dark + front porch

	// vertical sync: VHSYNC ... VSYNC(back porch + dark + front porch)
	ScanLineSync[0] = QVGACMD(qvga_offset_vhsync, QVGA_HSYNC-3); // VHSYNC
	ScanLineSync[1] = QVGACMD(qvga_offset_vsync, QVGA_TOTAL-QVGA_HSYNC-3); // VSYNC(back porch + dark + front porch)

	// control buffer 1 - initialize to VSYNC
	ScanLineCB[0] = 2; // send 2x u32 (send ScanLineSync)
	ScanLineCB[1] = (u32)&ScanLineSync[0]; // VSYNC data buffer
	ScanLineCB[2] = 0; // stop mark
	ScanLineCB[3] = 0; // stop mark

	// control buffer 1 - initialize to VSYNC
	ScanLineCB[CB_MAX+0] = 2; // send 2x u32 (send ScanLineSync)
	ScanLineCB[CB_MAX+1] = (u32)&ScanLineSync[0]; // VSYNC data buffer
	ScanLineCB[CB_MAX+2] = 0; // stop mark
	ScanLineCB[CB_MAX+3] = 0; // stop mark
}

// initialize QVGA DMA
//   control blocks aliases:
//                  +0x0        +0x4          +0x8          +0xC (Trigger)
// 0x00 (alias 0):  READ_ADDR   WRITE_ADDR    TRANS_COUNT   CTRL_TRIG
// 0x10 (alias 1):  CTRL        READ_ADDR     WRITE_ADDR    TRANS_COUNT_TRIG
// 0x20 (alias 2):  CTRL        TRANS_COUNT   READ_ADDR     WRITE_ADDR_TRIG
// 0x30 (alias 3):  CTRL        WRITE_ADDR    TRANS_COUNT   READ_ADDR_TRIG ... we use this!
void QVgaDmaInit()
{

// ==== prepare DMA control channel

	DMA_Config(QVGA_DMA_CB,		// channel
		&ScanLineCB[0],		// read address - as first, control buffer 1 will be sent out
		&DMA_CHAN(QVGA_DMA_PIO)[DMA_CH_AL3_COUNT], // write address to COUNT and READ_TRIG
		2,			// number of transfers = 2 * u32
			// DMA_CTRL_SNIFF |	// not sniff
			// DMA_CTRL_BSWAP |	// not byte swap
			// DMA_CTRL_QUIET |	// not quiet
			DMA_CTRL_TREQ_FORCE |	// permanent request
			DMA_CTRL_CHAIN(QVGA_DMA_CB) | // disable chaining
			DMA_CTRL_RING_WRITE |	// wrap ring on write
			DMA_CTRL_RING_SIZE(3) | // ring size = 8 bytes
			DMA_CTRL_INC_WRITE |	// increment write
			DMA_CTRL_INC_READ |	// increment read
			DMA_CTRL_SIZE(DMA_SIZE_32) | // data size 32 bits
			// DMA_CTRL_HIGH_PRIORITY | // not high priority
			DMA_CTRL_EN);		// enable DMA

// ==== prepare DMA data channel

	DMA_Config(QVGA_DMA_PIO,	// channel
		NULL,			// read address
		PIO_TXF(QVGA_PIO, QVGA_SM), // write address - PIO port
		0,			// number of transfers
			// DMA_CTRL_SNIFF |	// not sniff
			// DMA_CTRL_BSWAP |	// not byte swap
			DMA_CTRL_QUIET |	// quiet
			DMA_CTRL_TREQ(PioGetDreq(QVGA_PIO, QVGA_SM, True)) | // data request from PIO
			DMA_CTRL_CHAIN(QVGA_DMA_CB) | // chain to control DMA channel
			// DMA_CTRL_RING_WRITE | // not wrap ring on write
			// DMA_CTRL_RING_SIZE(3) | // not ring
			// DMA_CTRL_INC_WRITE |	// not increment write
			DMA_CTRL_INC_READ |	// increment read
			DMA_CTRL_SIZE(DMA_SIZE_32) | // data size 32 bits
			DMA_CTRL_HIGH_PRIORITY | // high priority
			DMA_CTRL_EN);		// enable DMA

// ==== initialize IRQ0, raised from DMA data channel

	// enable DMA channel IRQ0
	DMA_IRQ0Enable(QVGA_DMA_PIO);

	// set DMA IRQ handler
	SetHandler(IRQ_DMA_0, QVgaLine);

	// set highest IRQ priority
	NVIC_IRQPrio(IRQ_DMA_0, IRQ_PRIO_REALTIME);
}

// initialize QVGA (changes system clock)
void QVgaInit()
{
	// initialize system clock
	ClockPllSysFreq(126000);

	// initialize keyboard
	KeyInit();

	// setup keyboard timings after changing display timings
	KeySetup(QVGA_VSYNC, 60);

	dmb();

	// initialize PIO
	QVgaPioInit();

	// initialize scanline buffers
	QVgaBufInit();

	// initialize DMA
	QVgaDmaInit();

	// initialize parameters
	QVgaScanLine = 0; // currently processed scanline
	QVgaBufInx = 0; // at first, control buffer 1 will be sent out
	QVgaFrame = 0; // current frame
	ScanLineCBNext = &ScanLineCB[CB_MAX]; // send control buffer 2 next

	// enable DMA IRQ
	NVIC_IRQEnable(IRQ_DMA_0);

	// start DMA
	DMA_Start(QVGA_DMA_CB);

	// run state machine
	PioSMEnable(QVGA_PIO, QVGA_SM);
}

// terminate QVGA (changes system clock)
void QVgaTerm()
{
	// abort DMA channels (interrupt data channel first and then control channel)
	DMA_Abort(QVGA_DMA_PIO); // pre-abort, could be chaining right now
	DMA_Abort(QVGA_DMA_CB);

	// disable IRQ0 from DMA0
	NVIC_IRQDisable(IRQ_DMA_0);
	DMA_IRQ0Disable(QVGA_DMA_PIO);

	// Clear the interrupt request for DMA control channel
	DMA_IRQ0Clear(QVGA_DMA_PIO);

	// reset PIO
	PioInit(QVGA_PIO);

	// set default system clock
	ClockPllSysFreq(125000);
}

void (* volatile QCore1Fnc)() = NULL; // core 1 remote function

#define QVGA_REQNO 	0	// request - no
#define QVGA_REQINIT    1	// request - init
#define QVGA_REQTERM	2	// request - terminate
volatile int QVgaReq = QVGA_REQNO;	// current QVGA request

// QVGA core
void QVgaCore()
{
	void (*fnc)();
	int req;

	// infinite loop
	while (True)
	{
		// data memory barrier
		dmb();

		// initialize/terminate QVGA
		req = QVgaReq;
		if (req != QVGA_REQNO)
		{
			if (req == QVGA_REQINIT)
				QVgaInit(); // initialize
			else
				QVgaTerm(); // terminate

			QVgaReq = QVGA_REQNO;
		}		

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

// check VSYNC
Bool QIsVSync()
{
	return ((QVgaScanLine < QVGA_VSYNC+QVGA_VBACK) ||
		(QVgaScanLine >= QVGA_VTOT-QVGA_VFRONT));
}

// wait for VSync scanline
void QWaitVSync()
{
	// wait for end of VSync
	while (QIsVSync()) { dmb(); }

	// wait for start of VSync
	while (!QIsVSync()) { dmb(); }
}

// start QVGA on CPU 1 (must be paired with QVgaStop)
void QVgaStart()
{
	// run VGA core
	Core1Exec(QVgaCore);

	// initialize QVGA
	QVgaReq = QVGA_REQINIT;
	dmb();
	while (QVgaReq != QVGA_REQNO) { dmb(); }
}

// terminate QVGA on CPU 1 (must be paired with QVgaStart)
void QVgaStop()
{
	// terminate QVGA
	QVgaReq = QVGA_REQTERM;
	dmb();
	while (QVgaReq != QVGA_REQNO) { dmb(); }

	// core 1 reset
	Core1Reset();
}

#endif // USE_QVGA		// use QVGA display (qvga.c, qvga.h)

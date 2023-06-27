
// ****************************************************************************
//                                 
//                           Default Library Configuration
//
// ****************************************************************************

/*
Default system resources
------------------------
DMA 10 and 11 are reserved for temporary operations (DMA_MemCopy, CrcxxDMA),
but they can be used temporary by user program, too. Search: UARTSAMPLE_TXDMA,
UARTSAMPLE_RXDMA, DMA_TEMP_CHAN.

DMA channels 2 to 9 are used by VGA library. DMA channels 8 and 9 are used by
QVA library.

Spinlock 31 is used by system memory allocator, safe integer etc. Spinlocks
29 and 30 are used by UART test sample. Search: SYS_SPIN, UARTSAMPLE_TXSPIN,
UARTSAMPLE_RXSPIN.

Hardware interpolators are used when drawing to canvas (DRAW_HWINTER_INX) and
by VGA driver rendering service.
*/

#ifndef _CONFIG_DEF_H
#define _CONFIG_DEF_H

// ----------------------------------------------------------------------------
//                      Device custom configutation
// ----------------------------------------------------------------------------

#if USE_PICOINO			// use Picoino device configuration
#include "_devices/picoino/_config.h"
#endif

#if USE_PICOINO_LOADER		// use Picoino-loader device configuration
#include "_devices/picoino_loader/_config.h"
#endif

#if USE_PICOPAD			// use PicoPad device configuration
#include "_devices/picopad/_config.h"
#endif

#if USE_PC
#define ASM64		1		// 1 = use assembler x64 optimization, if available
#endif

// ----------------------------------------------------------------------------
//              SDK modules, folder _sdk (1=use, 0=do not use)
// ----------------------------------------------------------------------------

#ifndef USE_ADC
#define USE_ADC		1		// use ADC controller (sdk_adc.c, sdk_adc.h)
#endif

#ifndef USE_DMA
#define USE_DMA		1		// use DMA controller (sdk_dma.c, sdk_dma.h)
#endif

#ifndef USE_DOUBLE
#define USE_DOUBLE	1		// use Double-floating point (sdk_double.c, sdk_double_asm.S, sdk_double.h)
#endif

#ifndef USE_FIFO
#define USE_FIFO	1		// use Inter-core FIFO (sdk_fifo.c, sdk_fifo.h)
#endif

#ifndef USE_FLASH
#define USE_FLASH	1		// use Flash memory programming (sdk_flash.c, sdk_flash.h)
#endif

#ifndef USE_FLOAT
#define USE_FLOAT	1		// use Single-floating point (sdk_float.c, sdk_float_asm.S, sdk_float.h)
#endif

#ifndef USE_I2C
#define USE_I2C		1		// use I2C interface (sdk_i2c.c, sdk_i2c.h)
#endif

#ifndef USE_INTERP
#define USE_INTERP	1		// use interpolator (sdk_interp.c, sdk_interp.h)
#endif

#ifndef USE_IRQ
#define USE_IRQ		1		// use IRQ interrupts (sdk_irq.c, sdk_irq.h)
#endif

#ifndef USE_MULTICORE
#define USE_MULTICORE	1		// use Multicore (sdk_multicore.c, sdk_multicore.h)
#endif

#ifndef USE_PIO
#define USE_PIO		1		// use PIO (sdk_pio.c, sdk_pio.h)
#endif

#ifndef USE_PLL
#define USE_PLL		1		// use PLL phase-locked loop (sdk_pll.c, sdk_pll.h)
#endif

#ifndef USE_PWM
#define USE_PWM		1		// use PWM (sdk_pwm.c, sdk_pwm.h)
#endif

#ifndef USE_ROSC
#define USE_ROSC	1		// use ROSC ring oscillator (sdk_rosc.c, sdk_rosc.h)
#endif

#ifndef USE_RTC
#define USE_RTC		1		// use RTC Real-time clock (sdk_rtc.c, sdk_rtc.h)
#endif

#ifndef USE_SPI
#define USE_SPI		1		// use SPI interface (sdk_spi.c, sdk_spi.h)
#endif

#ifndef USE_SPINLOCK
#define USE_SPINLOCK	1		// use Spinlock (sdk_spinlock.c, sdk_spinlock.h)
#endif

#ifndef USE_SYSTICK
#define USE_SYSTICK	1		// use SysTick system timer (sdk_systime.c, sdk_systime.h)
#endif

#ifndef USE_TIMER
#define USE_TIMER	1		// use Timer with alarm (sdk_timer.c, sdk_timer.h)
#endif

#ifndef USE_UART
#define USE_UART	1		// use UART serial port (sdk_uart.c, sdk_uart.h)
#endif

#ifndef USE_WATCHDOG
#define USE_WATCHDOG	1		// use Watchdog timer (sdk_watchdog.c, sdk_watchdog.h)
#endif

#ifndef USE_XOSC
#define USE_XOSC	1		// use XOSC crystal oscillator (sdk_xosc.c, sdk_xosc.h)
#endif

// ----------------------------------------------------------------------------
//              Library modules, folder _lib (1=use, 0=do not use)
// ----------------------------------------------------------------------------

#ifndef USE_ALARM
#define USE_ALARM	1		// use SysTick alarm (lib_alarm.c, lib_alarm.h)
#endif

#ifndef USE_CALENDAR
#define USE_CALENDAR	1		// use 32-bit calendar (lib_calendar.c, lib_calendar.h)
#endif

#ifndef USE_CALENDAR64
#define USE_CALENDAR64	1		// use 64-bit calendar (lib_calendar64.c, lib_calendar64.h)
#endif

#ifndef USE_CANVAS
#define USE_CANVAS	0		// use Canvas (lib_canvas.c, lib_canvas.h)
#endif

#ifndef USE_COLOR
#define USE_COLOR	1		// use color vector (lib_color.c, lib_color.h)
#endif

#ifndef USE_CRC
#define USE_CRC		1		// use CRC Check Sum (lib_crc.c, lib_crc.h)
#endif

#ifndef USE_DECNUM
#define USE_DECNUM	1		// use DecNum (decnum.c, decnum.h)
#endif

#ifndef USE_DRAWTFT
#define USE_DRAWTFT	0		// use TFT drawing (lib_drawtft.c, lib_drawtft.h)
#endif

#ifndef USE_FAT
#define USE_FAT		0		// use FAT file system (lib_fat.c, lib_fat.h)
#endif

#ifndef USE_LIST
#define USE_LIST	1		// use Doubly Linked List (lib_list.c, lib_list.h)
#endif

#ifndef USE_MAT2D
#define USE_MAT2D	1		// use 2D transformation matrix (lib_mat2d.c, lib_mat2d.h)
#endif

#ifndef USE_MEM
#define USE_MEM		1		// use Memory Allocator (lib_mem.c, lib_mem.h)
#endif

#ifndef USE_PRINT
#define USE_PRINT	1		// use Formated print (lib_print.c, lib_print.h)
#endif

#ifndef USE_PWMSND
#define USE_PWMSND	0		// use PWM sound output; set 1.. = number of channels (lib_pwmsnd.c, lib_pwmsnd.h)
#endif

#ifndef USE_QDRAW
#define USE_QDRAW	0		// use QVGA drawing (lib_qdraw.c, lib_qdraw.h)
#endif

#ifndef USE_RAND
#define USE_RAND	1		// use Random number generator (lib_rand.c, lib_rand.h)
#endif

#ifndef USE_RECT
#define USE_RECT	1		// use Rectangle (lib_rect.c, lib_rect.h)
#endif

#ifndef USE_RING
#define USE_RING	1		// use Ring buffer (lib_ring.c, lib_ring.h)
#endif

#ifndef USE_RINGRX
#define USE_RINGRX	0		// use Ring buffer with DMA receiver (lib_ringrx.c, lib_ringrx.h)
#endif

#ifndef USE_RINGTX
#define USE_RINGTX	0		// use Ring buffer with DMA transmitter (lib_ringtx.c, lib_ringtx.h)
#endif

#ifndef USE_SD
#define USE_SD		0		// use SD card (lib_sd.c, lib_sd.h)
#endif

#ifndef USE_STREAM
#define USE_STREAM	1		// use Data stream (lib_stream.c, lib_stream.h)
#endif

#ifndef USE_TEXT
#define USE_TEXT	1		// use Text strings, except StrLen and StrComp (lib_text.c, lib_textnum.c, lib_text.h)
#endif

#ifndef USE_TEXTLIST
#define USE_TEXTLIST	1		// use List of text strings (lib_textlist.c, lib_textlist.h)
#endif

#ifndef USE_TPRINT
#define USE_TPRINT	0		// use Text Print (lib_tprint.c, lib_tprint.h)
#endif

#ifndef USE_TREE
#define USE_TREE	1		// use Tree list (lib_tree.c, lib_tree.h)
#endif

#ifndef FONT
#define FONT		FontBold8x16	// default system font
#endif

#ifndef FONTW
#define FONTW		8		// width of system font
#endif

#ifndef FONTH
#define FONTH		16		// height of system font
#endif

// ----------------------------------------------------------------------------
//               Big integers, folder _bigint (1=use, 0=do not use)
// ----------------------------------------------------------------------------

#ifndef USE_BIGINT
#define USE_BIGINT	0		// use Big Integers (bigint.c, bigint.h)
#endif

#ifndef BIGINT_BERN_NUM
#if USE_BIGINT
#define BIGINT_BERN_NUM	512		// number of table Bernoulli numbers - use number 0, 256 or 512
#else
#define BIGINT_BERN_NUM	0		// number of table Bernoulli numbers - use number 0, 256 or 512
#endif
#endif

// ----------------------------------------------------------------------------
//                   REAL numbers  (1=use, 0=do not use)
// ----------------------------------------------------------------------------
// To generate constants with GenConst generator, enable all number types
// to allow more accurate generation of Chebyshev constants.

#ifndef USE_REAL
#define USE_REAL	1		// use real numbers
#endif

#ifndef USE_REAL16
#define USE_REAL16	0		// 1 = use real16 numbers (3 digits, exp +-4)
#endif

#ifndef USE_REAL32
#define USE_REAL32	0		// 1 = use real32 numbers (float, 7 digits, exp +-38)
#endif

#ifndef USE_REAL48
#define USE_REAL48	0		// 1 = use real48 numbers (11 digits, exp +-153)
#endif

#ifndef USE_REAL64
#define USE_REAL64	0		// 1 = use real64 numbers (double, 16 digits, exp +-308)
#endif

#ifndef USE_REAL80
#define USE_REAL80	0		// 1 = use real80 numbers (19 digits, exp +-4932)
#endif

#ifndef USE_REAL96
#define USE_REAL96	0		// 1 = use real96 numbers (25 digits, exp +-1233)
#endif

#ifndef USE_REAL128
#define USE_REAL128	0		// 1 = use real128 numbers (34 digits, exp +-4932)
#endif

#ifndef USE_REAL160
#define USE_REAL160	0		// 1 = use real160 numbers (43 digits, exp +-9864)
#endif

#ifndef USE_REAL192
#define USE_REAL192	0		// 1 = use real192 numbers (52 digits, exp +-19728)
#endif

#ifndef USE_REAL256
#define USE_REAL256	0		// 1 = use real256 numbers (71 digits, exp +-78913)
#endif

#ifndef USE_REAL384
#define USE_REAL384	0		// 1 = use real384 numbers (109 digits, exp +-315652)
#endif

#ifndef USE_REAL512
#define USE_REAL512	0		// 1 = use real512 numbers (147 digits, exp +-1262611)
#endif

#ifndef USE_REAL768
#define USE_REAL768	0		// 1 = use real768 numbers (224 digits, exp +-5050445)
#endif

#ifndef USE_REAL1024
#define USE_REAL1024	0		// 1 = use real1024 numbers (300 digits, exp +-20201781)
#endif

#ifndef USE_REAL1536
#define USE_REAL1536	0		// 1 = use real1536 numbers (453 digits, exp +-161614248)
#endif

#ifndef USE_REAL2048
#define USE_REAL2048	0		// 1 = use real2048 numbers (607 digits, exp +-161614248)
#endif

#ifndef USE_REAL3072
#define USE_REAL3072	0		// 1 = use real3072 numbers (915 digits, exp +-161614248)
#endif

#ifndef USE_REAL4096
#define USE_REAL4096	0		// 1 = use real4096 numbers (1224 digits, exp +-161614248)
#endif

// Limiting the usage of large Chebyshev tables
//  Chebyshev approximations can speed up calculations of mathematical functions.
//  However, the use of Chebyshev approximations for long numbers takes a lot of
//  Flash memory and can be slow due to slow Flash memory access. If needed, set
//  a limit here on the bit length of the numbers for which Chebyshev approximations
//  will be used. Calculations using Chebyshev approximations are not recommended for
//  use in this library. The tables are prepared up to a maximum number size of 1536 bits.
#ifndef MAXCHEB_LN
#define MAXCHEB_LN	0 //1536		// max. REAL number supporting Chebyshev approximations of Ln()
#endif

#ifndef MAXCHEB_EXP
#define MAXCHEB_EXP	0 //1536		// max. REAL number supporting Chebyshev approximations of Exp()
#endif

#ifndef MAXCHEB_SIN
#define MAXCHEB_SIN	0 //1536		// max. REAL number supporting Chebyshev approximations of Sin()
#endif

#ifndef MAXCHEB_ASIN
#define MAXCHEB_ASIN	0 //1536		// max. REAL number supporting Chebyshev approximations of ASin()
#endif

#ifndef MAXCHEB_ATAN
#define MAXCHEB_ATAN	0 //1536		// max. REAL number supporting Chebyshev approximations of ATan()
#endif

#ifndef MAXCHEB_SQRT
#define MAXCHEB_SQRT	0 //1536		// max. REAL number supporting Chebyshev approximations of Sqrt()
#endif

// Limiting the usage of large Cordic tables (see note of Chebyshev tables)
//   Note: Calculations using Cordic are not complete in this library because
//   they have lower precision and they are not recommended for use in this library.
#ifndef MAXCORD_ATAN
#define MAXCORD_ATAN	0 //4096	// max. REAL number supporting Cordic atan table (to calculate sin, cos, tan, asin, acos, atan)
#endif

// Limiting the usage of linear factorials
//  Calculating the linear factorial requires tables that take up much Flash memory.
//  If you need to limit the size of the tables, set a limit here of the bit length of
//  the numbers that will support the linear factorial. The integer factorial
//  can still be used, but it is slow for large numbers.
#ifndef MAXFACT_COEFF
#define MAXFACT_COEFF	4096	// max. REAL number supporting linear factorial
#endif

// ----------------------------------------------------------------------------
//                            Miscellaneous Settings
// ----------------------------------------------------------------------------

#ifndef USE_MEMLOCK
#define USE_MEMLOCK	1		// use multicore lock of Memory Allocator (lib_mem.c, lib_mem.h)
#endif

#ifndef DRAW_HWINTER
#define DRAW_HWINTER	1		// 1=use hardware interpolator to draw images on Canvas
#endif

#ifndef DRAW_HWINTER_INX
#define DRAW_HWINTER_INX 0		// index of hardware interpolator to draw on canvas
#endif

#ifndef TEMP_NOISE
#define TEMP_NOISE	20		// number of steps of noise reduction of temperature measurement, 0 = not used (requires array of u16)
#endif

#ifndef USE_STACKCHECK
#define USE_STACKCHECK	0		// use Stack check (sdk_cpu.c, sdk_cpu.h)
#endif

#ifndef ASM64
#define ASM64		0		// 1 = use assembler x64 optimization, if available
#endif

#define BOOTLOADER_SIZE	0x8000		// size of boot loader
#define BOOTLOADER_DATA	32		// boot loader resident data

// ----------------------------------------------------------------------------
//              UART test sample (files sdk_uart.c, sdk_uart.h)
// ----------------------------------------------------------------------------

#ifndef UARTSAMPLE
#define UARTSAMPLE		0	// flag in sdk_uart.*, compile UART test sample: 1 = compile, 0 = not
#endif

#ifndef UARTSAMPLE_UART
#define UARTSAMPLE_UART		0	// UART 0 or 1
#endif

#ifndef UARTSAMPLE_TXORDER
#define UARTSAMPLE_TXORDER	7	// order of size of transmitter ring buffers (size in bytes = 1 << order)
#endif

#ifndef UARTSAMPLE_RXORDER
#define UARTSAMPLE_RXORDER	7	// order of size of receiver ring buffers (size in bytes = 1 << order)
#endif

#ifndef UARTSAMPLE_TXMODE
#define UARTSAMPLE_TXMODE	3	// transmit mode: 0=polling, 1=interrupt, 2=DMA stream, 3=DMA single
#endif

#ifndef UARTSAMPLE_RXMODE
#define UARTSAMPLE_RXMODE	2	// receive mode: 0=polling, 1=interrupt, 2=DMA stream
#endif

#ifndef UARTSAMPLE_TXDMA
#define UARTSAMPLE_TXDMA	10	// transmitter DMA channel 0..11 (used in DMA mode)
#endif

#ifndef UARTSAMPLE_RXDMA
#define UARTSAMPLE_RXDMA	11	// receiver DMA channel 0..11 (used in DMA mode)
#endif

#ifndef UARTSAMPLE_TXSPIN
#define UARTSAMPLE_TXSPIN	29	// transmitter spinlock 0..31 (-1 = not used)
#endif

#ifndef UARTSAMPLE_RXSPIN
#define UARTSAMPLE_RXSPIN	30	// receiver spinlock 0..31 (-1 = not used)
#endif

// ----------------------------------------------------------------------------
//                            System resources
// ----------------------------------------------------------------------------

// DMA temporary channel to calculate CRC and memory copy/fill.
//  CPU0 uses DMA channel 11, CPU1 uses DMA channel 10, so functions can be used
//  simultaneously, without collision. However, they cannot be used simultaneously in an interrupt.
#ifndef DMA_TEMP_CHAN
#define DMA_TEMP_CHAN()	(DMA_CHANNELS - 1 - CpuID())
#endif

#ifndef SYS_SPIN
#define SYS_SPIN	31		// system spinlock (memory allocator, safe integer etc.; -1 = not used)
#endif

#ifndef ROSC_MHZ
#define ROSC_MHZ	6		// ring oscillator frequency in MHz (default 6 MHz)
#endif

#ifndef XOSC_MHZ
#define XOSC_MHZ	12		// crystal oscillator frequency in MHz (must be in range 1..15 MHz, default 12 MHz)
#endif

#ifndef PLL_KHZ
#define PLL_KHZ		125000		// PLL system frequency in kHz (default 125000 kHz)
#endif

#ifndef BATTERY_FULL
#define BATTERY_FULL	4.2f		// voltage of full battery
#endif

#ifndef BATTERY_FULL_INT
#define BATTERY_FULL_INT 4200		// voltage of full battery
#endif

#ifndef BATTERY_EMPTY
#define BATTERY_EMPTY	3.1f		// voltage of empty battery
#endif

#ifndef BATTERY_EMPTY_INT
#define BATTERY_EMPTY_INT 3100		// voltage of empty battery
#endif

#ifndef USE_SCREENSHOT			// use screen shots
#define USE_SCREENSHOT	0		// use screen shots
#endif

// ----------------------------------------------------------------------------
//                             Auto-dependencies
// ----------------------------------------------------------------------------

#if USE_MEMLOCK
#undef USE_SPINLOCK
#define USE_SPINLOCK 1
#endif

#if USE_QVGA
#undef USE_PIO
#define USE_PIO 1
#undef USE_DMA
#define USE_DMA 1
#undef USE_IRQ
#define USE_IRQ 1
#undef USE_PLL
#define USE_PLL 1
#undef USE_MULTICORE
#define USE_MULTICORE 1
#endif

#if USE_VGA
#undef USE_PIO
#define USE_PIO 1
#undef USE_DMA
#define USE_DMA 1
#undef USE_IRQ
#define USE_IRQ 1
#undef USE_PLL
#define USE_PLL 1
#undef USE_MULTICORE
#define USE_MULTICORE 1
#endif

#if USE_SCREENSHOT
#undef USE_FAT
#define USE_FAT 1
#undef USE_SD
#define USE_SD 1
#endif

#if USE_FAT
#undef USE_SD
#define USE_SD 1
#endif

#if USE_SD
#undef USE_SPI
#define USE_SPI 1
#undef USE_TIMER
#define USE_TIMER 1
#endif

#if USE_ALARM
#undef USE_SYSTICK
#define USE_SYSTICK 1
#undef USE_LIST
#define USE_LIST 1
#endif

#if USE_CALENDAR64
#undef USE_CALENDAR
#define USE_CALENDAR 1
#endif

#if USE_RTC
#undef USE_CALENDAR
#define USE_CALENDAR 1
#undef USE_IRQ
#define USE_IRQ 1
#endif

#if USE_TEXTLIST
#undef USE_TEXT
#define USE_TEXT 1
#endif

#if USE_TEXT
#undef USE_MEM
#define USE_MEM 1
#undef USE_CALENDAR
#define USE_CALENDAR 1
#undef USE_PRINT
#define USE_PRINT 1
#endif

#if USE_MEM
#undef USE_LIST
#define USE_LIST 1
#endif

#if USE_UART
#undef USE_PRINT
#define USE_PRINT 1
#endif

#if USE_RING
#undef USE_PRINT
#define USE_PRINT 1
#endif

#if USE_RINGRX
#undef USE_DMA
#define USE_DMA 1
#endif

#if USE_RINGTX
#undef USE_DMA
#define USE_DMA 1
#undef USE_PRINT
#define USE_PRINT 1
#endif

#if USE_PRINT
#undef USE_STREAM
#define USE_STREAM 1
#endif

#if USE_MULTICORE
#undef USE_FIFO
#define USE_FIFO 1
#undef USE_IRQ
#define USE_IRQ 1
#endif

#if USE_SYSTICK
#undef USE_IRQ
#define USE_IRQ 1
#endif

#if USE_PLL
#undef USE_XOSC
#define USE_XOSC 1
#endif

#if USE_FIFO
#undef USE_TIMER
#define USE_TIMER 1
#endif

#if USE_TIMER
#undef USE_IRQ
#define USE_IRQ 1
#endif

#if USE_FLASH
#undef USE_CRC
#define USE_CRC 1
#endif

#if USE_CRC
#undef USE_DMA
#define USE_DMA 1
#endif

#endif // _CONFIG_DEF_H

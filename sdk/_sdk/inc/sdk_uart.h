
// ****************************************************************************
//
//                            UART serial port
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// (RP2040 datasheet page 427)
// UART controller is based on ARM Primecell UART PL011 revision r1p5
//  ... IrDA and modem mode of PL011 on RP2040 is not supported

// UART signals (active in LOW; inputs should be pull-ups):
//   TX ... -> (output) transmitted data -> connect to RX
//   RX ... <- (input) received data -> connect to TX
//   CTS ... <- (input) input flow control (= can send data) -> connect to RTS
//   RTS ... -> (output) output flow control (= can receive data) -> connect to CTS

// After init, connect UART to GPIO pins using GPIO_Fnc(pin, GPIO_FNC_UART).
// After connecting the GPIO, wait a moment with WaitUs(50) and
// then flush any fake received characters with UART_RecvFlush.

//   GPIO0  ... UART0 TX
//   GPIO1  ... UART0 RX
//   GPIO2  ... UART0 CTS
//   GPIO3  ... UART0 RTS

//   GPIO4  ... UART1 TX
//   GPIO5  ... UART1 RX
//   GPIO6  ... UART1 CTS
//   GPIO7  ... UART1 RTS

//   GPIO8  ... UART1 TX
//   GPIO9  ... UART1 RX
//   GPIO10 ... UART1 CTS
//   GPIO11 ... UART1 RTS

//   GPIO12 ... UART0 TX
//   GPIO13 ... UART0 RX
//   GPIO14 ... UART0 CTS
//   GPIO15 ... UART0 RTS

//   GPIO16 ... UART0 TX
//   GPIO17 ... UART0 RX
//   GPIO18 ... UART0 CTS
//   GPIO19 ... UART0 RTS

//   GPIO20 ... UART1 TX
//   GPIO21 ... UART1 RX
//   GPIO22 ... UART1 CTS
//  (GPIO23 ... UART1 RTS)

//  (GPIO24 ... UART1 TX)
//  (GPIO25 ... UART1 RX)
//   GPIO26 ... UART1 CTS
//   GPIO27 ... UART1 RTS

//   GPIO28 ... UART0 TX
//  (GPIO29 ... UART0 RX)

// using external compilation switch and parameters (from config_def.h):
//#define UARTSAMPLE	1	// flag in sdk_uart.*, compile UART test sample: 1 = compile, 0 = not

#if USE_UART	// use UART serial port (sdk_uart.c, sdk_uart.h)

#ifndef _SDK_UART_H
#define _SDK_UART_H

//#include "resource.h"		// Resources
#include "../sdk_addressmap.h"		// Register address offsets
#include "sdk_reset.h"
#include "../../_lib/inc/lib_ring.h"		// ring buffer
#include "../../_lib/inc/lib_stream.h"		// ring buffer

#ifdef __cplusplus
extern "C" {
#endif

//#define UART0_BASE		0x40034000	// UART0 serial port
//#define UART1_BASE		0x40038000	// UART1 serial port
#define UART_BASE(uart) (UART0_BASE+(uart)*0x4000)	// UART base address (uart = 0 or 1)
#define UART_DR(uart)	((volatile u32*)(UART_BASE(uart)+0))	// data register (uart = 0 or 1)
#define UART_RSR(uart)	((volatile u32*)(UART_BASE(uart)+4))	// receive status register (uart = 0 or 1)
#define UART_FR(uart)	((volatile u32*)(UART_BASE(uart)+0x18))	// flag register (uart = 0 or 1)
#define UART_IBRD(uart)	((volatile u32*)(UART_BASE(uart)+0x24))	// integer baud rate register (uart = 0 or 1)
#define UART_FBRD(uart)	((volatile u32*)(UART_BASE(uart)+0x28))	// fractional baud rate register (uart = 0 or 1)
#define UART_LCR(uart)	((volatile u32*)(UART_BASE(uart)+0x2C))	// line control register (uart = 0 or 1)
#define UART_CR(uart)	((volatile u32*)(UART_BASE(uart)+0x30))	// control register (uart = 0 or 1)
#define UART_IFLS(uart)	((volatile u32*)(UART_BASE(uart)+0x34))	// interrupt FIFO level select register (uart = 0 or 1)
#define UART_IMCS(uart)	((volatile u32*)(UART_BASE(uart)+0x38))	// interrupt mask register (uart = 0 or 1)
#define UART_RIS(uart)	((volatile u32*)(UART_BASE(uart)+0x3C))	// raw interrupt status register (uart = 0 or 1)
#define UART_MIS(uart)	((volatile u32*)(UART_BASE(uart)+0x40))	// masked interrupt status register (uart = 0 or 1)
#define UART_ICR(uart)	((volatile u32*)(UART_BASE(uart)+0x44))	// interrupt clear register (uart = 0 or 1)
#define UART_DMACR(uart) ((volatile u32*)(UART_BASE(uart)+0x48)) // DMA control register (uart = 0 or 1)
#define UART_DREQ(uart,rx) (DREQ_UART0_TX + (uart)*2 + (rx))

// parity
#define UART_PARITY_NONE	0	// no parity bit (PEN=0, EPS=0, SPS=0)
#define UART_PARITY_ODD		1	// odd parity (PEN=1, EPS=0, SPS=0)
#define UART_PARITY_EVEN	2	// even parity (PEN=1, EPS=1, SPS=0)
#define UART_PARITY_ONE		3	// one parity (PEN=1, EPS=0, SPS=1)
#define UART_PARITY_ZERO	4	// zero parity (PEN=1, EPS=1, SPS=1)

// FIFO trigger points (every FIFO is 32 entries deep)
#define UART_LEVEL_VERYLOW	0	// 1/8 (4 + 28 entries)
#define UART_LEVEL_LOW		1	// 1/4 (2/8) (8 + 24 entries)
#define UART_LEVEL_MID		2	// 1/2 (4/8) (16 + 16 entries) ... default
#define UART_LEVEL_HIGH		3	// 3/4 (6/8) (24 + 8 entries)
#define UART_LEVEL_VERYHIGH	4	// 7/8 (28 + 4 entries)

// UART interrupt
#define UART_IRQ_OVERRUN	10	// overrun error
#define UART_IRQ_BREAK		9	// break error
#define UART_IRQ_PARITY		8	// parity error
#define UART_IRQ_FRAME		7	// framing error
#define UART_IRQ_TIMEOUT	6	// receive timeout (if receive FIFO is not empty and no more data comes during 32-bit period)
#define UART_IRQ_TX		5	// transmit
#define UART_IRQ_RX		4	// receive
#define UART_IRQ_CTS		1	// CTS

// receive character with error flags (error flags are cleared when condition disappears)
//  bit 11: OE overrun error (receive data is lost)
//  bit 10: BE break error (long "LOW" on RX input)
//  bit 9: parity error (incorrect parity of received character)
//  bit 8: framing error (invalid stop bit)
//  bit 0..7: data byte
// Every entry in receive FIFO contains 8 bit character with 4 error bits.
INLINE u16 UART_RecvCharFlags(u8 uart) { return (u16)(*UART_DR(uart) & 0xfff); }

// receive character, does not wait if not ready
INLINE char UART_RecvChar(u8 uart) { return (char)*UART_DR(uart); }

// send character, does not wait if not ready
INLINE void UART_SendChar(u8 uart, char data) { *UART_DR(uart) = (u8)data; }

// get overrun error (returns 1 = receive FIFO is full and data is lost)
INLINE u8 UART_OverrunError(u8 uart) { return (u8)((*UART_RSR(uart) >> 3) & 1); }

// clear overrun error
INLINE void UART_OverrunClear(u8 uart) { *UART_RSR(uart) = B3; }

// get break error (returns 1 = break condition 'LOW' detected)
INLINE u8 UART_BreakError(u8 uart) { return (u8)((*UART_RSR(uart) >> 2) & 1); }

// clear break error
INLINE void UART_BreakClear(u8 uart) { *UART_RSR(uart) = B2; }

// get parity error (returns 1 = incorrect parity received)
INLINE u8 UART_ParityError(u8 uart) { return (u8)((*UART_RSR(uart) >> 1) & 1); }

// clear parity error
INLINE void UART_ParityClear(u8 uart) { *UART_RSR(uart) = B1; }

// get framing error (returns 1 = invalid stop bit)
INLINE u8 UART_FrameError(u8 uart) { return (u8)(*UART_RSR(uart) & 1); }

// clear framing error
INLINE void UART_FrameClear(u8 uart) { *UART_RSR(uart) = B0; }

// get flag: 1 = transmit FIFO is empty
INLINE u8 UART_TxEmpty(u8 uart) { return (u8)((*UART_FR(uart) >> 7) & 1); }

// get flag: 1 = receive FIFO is full
INLINE u8 UART_RxFull(u8 uart) { return (u8)((*UART_FR(uart) >> 6) & 1); }

// get flag: 1 = transmit FIFO is full
INLINE u8 UART_TxFull(u8 uart) { return (u8)((*UART_FR(uart) >> 5) & 1); }

// get flag: 1 = receive FIFO is empty
INLINE u8 UART_RxEmpty(u8 uart) { return (u8)((*UART_FR(uart) >> 4) & 1); }

// get flag: 1 = UART is busy transmitting data from shift register
INLINE u8 UART_Busy(u8 uart) { return (u8)((*UART_FR(uart) >> 3) & 1); }

// get flag: 1 = CTS (clear to send) input is LOW (active)
INLINE u8 UART_CTS(u8 uart) { return (u8)(*UART_FR(uart) & 1); }

// set integer baud rate divisor
INLINE void UART_IBaud(u8 uart, u16 ibaud) { *UART_IBRD(uart) = ibaud; }

// get integer baud rate divisor
INLINE u16 UART_GetIBaud(u8 uart) { return (u16)*UART_IBRD(uart); }

// set fractional baud rate divisor (= 1/64 fraction)
INLINE void UART_FBaud(u8 uart, u8 fbaud) { *UART_FBRD(uart) = fbaud; }

// get fractional baud rate divisor (= 1/64 fraction)
INLINE u8 UART_GetFBaud(u8 uart) { return (u8)(*UART_FBRD(uart) & 0x3f); }

// set baudrate (range 45..3'000'000 with default clk_peri = 48 MHz; hardware support up to 921'600 bps)
void UART_Baud(u8 uart, u32 baudrate);

// get baudrate
u32 UART_GetBaud(u8 uart);

// set parity UART_PARITY_* (default UART_PARITY_NONE)
void UART_Parity(u8 uart, u8 parity);

// set word length to 5..8 (default 5 bits)
INLINE void UART_Word(u8 uart, u8 len) { RegMask(UART_LCR(uart), (u32)(len-5)<<5, B5|B6); }

// enable FIFO (every FIFO is 32 entries deep)
INLINE void UART_FifoEnable(u8 uart) { RegSet(UART_LCR(uart), B4); }

// disable FIFO (default state; every FIFO is 1 entry deep)
INLINE void UART_FifoDisable(u8 uart) { RegClr(UART_LCR(uart), B4); }

// set 1 stop bit (default value)
INLINE void UART_Stop1(u8 uart) { RegClr(UART_LCR(uart), B3); }

// set 2 stop bits
INLINE void UART_Stop2(u8 uart) { RegSet(UART_LCR(uart), B3); }

// send break signal - set TX output to LOW (min. for 2 frames; get UART_BreakError state)
INLINE void UART_BreakOn(u8 uart) { RegSet(UART_LCR(uart), B0); }
INLINE void UART_BreakOff(u8 uart) { RegClr(UART_LCR(uart), B0); }

// CTS hardware flow control enable (if enabled, data is only transmitted when CTR signal is LOW)
INLINE void UART_CTSEnable(u8 uart) { RegSet(UART_CR(uart), B15); }

// CTS hardware flow control disable (default state; if disabled, data is always transmitted)
INLINE void UART_CTSDisable(u8 uart) { RegClr(UART_CR(uart), B15); }

// RTS hardware flow control enable (if enabled, data is requested by setting the RTS signal
//   to LOW only if there is free space in the receive FIFO)
INLINE void UART_RTSEnable(u8 uart) { RegSet(UART_CR(uart), B14); }

// RTS hardware flow control disable (default state; if disabled, RTS signal is not controlled)
INLINE void UART_RTSDisable(u8 uart) { RegClr(UART_CR(uart), B14); }

// set RTS output ON (output RTS signal when RTS control is disabled: set RTS output to LOW)
INLINE void UART_RTSOutON(u8 uart) { RegSet(UART_CR(uart), B11); }

// set RTS output OFF (default state; output RTS signal when RTS control is disabled: set RTS output to HIGH)
INLINE void UART_RTSOutOFF(u8 uart) { RegClr(UART_CR(uart), B11); }

// enable receiver (default state)
INLINE void UART_RxEnable(u8 uart) { RegSet(UART_CR(uart), B9); }

// disable receiver
INLINE void UART_RxDisable(u8 uart) { RegClr(UART_CR(uart), B9); }

// enable transmitter (default state)
INLINE void UART_TxEnable(u8 uart) { RegSet(UART_CR(uart), B8); }

// disable transmitter
INLINE void UART_TxDisable(u8 uart) { RegClr(UART_CR(uart), B8); }

// enable loopback test
void UART_LoopEnable(u8 uart);

// disable loopback test (default state)
void UART_LoopDisable(u8 uart);

// UART enable
INLINE void UART_Enable(u8 uart) { RegSet(UART_CR(uart), B0); }

// UART disable (default state)
INLINE void UART_Disable(u8 uart) { RegClr(UART_CR(uart), B0); }

// set receive interrupt FIFO level select UART_LEVEL_* (default UART_LEVEL_MID)
INLINE void UART_RxLevel(u8 uart, u8 level) { RegMask(UART_IFLS(uart), (u32)level<<3, B3|B4|B5); }

// set transmit interrupt FIFO level select UART_LEVEL_* (default UART_LEVEL_MID)
INLINE void UART_TxLevel(u8 uart, u8 level) { RegMask(UART_IFLS(uart), level, B0|B1|B2); }

// enable interrupt UART_IRQ_*
INLINE void UART_EnableIRQ(u8 uart, u8 irq) { RegSet(UART_IMCS(uart), BIT(irq)); }

// disable interrupt UART_IRQ_*
INLINE void UART_DisableIRQ(u8 uart, u8 irq) { RegClr(UART_IMCS(uart), BIT(irq)); }

// check if raw interrupt (before enabling) UART_IRQ_* is raised
INLINE Bool UART_RawIRQ(u8 uart, u8 irq) { return (*UART_RIS(uart) & BIT(irq)) != 0; }

// check if masked interrupt (after enabling) UART_IRQ_* is raised
INLINE Bool UART_IRQ(u8 uart, u8 irq) { return (*UART_MIS(uart) & BIT(irq)) != 0; }

// clear interrupt UART_IRQ_*
INLINE void UART_ClearIRQ(u8 uart, u8 irq) { RegSet(UART_ICR(uart), BIT(irq)); }

// enable DMA on error
INLINE void UART_EnableErrDMA(u8 uart) { RegSet(UART_DMACR(uart), B2); }

// disable DMA on error (default state)
INLINE void UART_DisableErrDMA(u8 uart) { RegClr(UART_DMACR(uart), B2); }

// enable transmit DMA
INLINE void UART_EnableTxDMA(u8 uart) { RegSet(UART_DMACR(uart), B1); }

// disable transmit DMA (default state)
INLINE void UART_DisableTxDMA(u8 uart) { RegClr(UART_DMACR(uart), B1); }

// enable receive DMA
INLINE void UART_EnableRxDMA(u8 uart) { RegSet(UART_DMACR(uart), B0); }

// disable receive DMA (default state)
INLINE void UART_DisableRxDMA(u8 uart) { RegClr(UART_DMACR(uart), B0); }

// === extended functions

// soft reset UART (restore to its default state; takes 0.5 us)
void UART_SoftReset(u8 uart);

// hard reset UART (send reset signal; takes 0.5 us)
INLINE void UART_HardReset(u8 uart) { ResetPeriphery(BIT(RESET_UART0 + uart)); }

// reset UART to its default state
INLINE void UART_Reset(u8 uart) { UART_HardReset(uart); }

// initialize UART (and reset to default state) ... GPIO pins are not initialized
//   uart ... uart number 0 or 1
//   baudrate ... baudrate 45 to 3'000'000 Baud; hardware support up to 921'600 bps
//   word ... word length 5 to 8 bits
//   parity ... parity UART_PARITY_*
//   stop ... number of stop bits 1 or 2
//   hw ... use hardware flow control CTS/RTS
// After init, connect UART to GPIO pins using GPIO_Fnc(pin, GPIO_FNC_UART).
// After connecting the GPIO, wait a moment with WaitUs(50) and
// then flush any fake received characters with UART_RecvFlush.
void UART_Init(u8 uart, u32 baudrate, u8 word, u8 parity, u8 stop, Bool hw);

// default initialize UART: 115200 Baud, 8 bits, no parity, 1 stop, no hw control ... GPIO pins are not initialized
// After init, connect UART to GPIO pins using GPIO_Fnc(pin, GPIO_FNC_UART).
// After connecting the GPIO, wait a moment with WaitUs(50) and
// then flush any fake received characters with UART_RecvFlush.
INLINE void UART_InitDef(u8 uart) { UART_Init(uart, 115200, 8, UART_PARITY_NONE, 1, False); }

// waiting for end of transmission (including transmission shift register)
INLINE void UART_TxWait(u8 uart) { while (UART_Busy(uart)) {} }

// check if next character can be transmitted
INLINE Bool UART_SendReady(u8 uart) { return !UART_TxFull(uart); }

// check if next character can be received
INLINE Bool UART_RecvReady(u8 uart) { return !UART_RxEmpty(uart); }

// send one character with waiting
void UART_SendCharWait(u8 uart, char data);

// receive one character with waiting
char UART_RecvCharWait(u8 uart);

// flush received character
void UART_RecvFlush(u8 uart);

// send buffer with blocking
void UART_Send(u8 uart, const u8* src, u32 len);

// receive buffer without blocking, returns number of successfully read characters
u32 UART_Recv(u8 uart, u8* dst, u32 len);

// initialize stream to write to UART with blocking
void StreamWriteUartInit(sStream* str, u8 uart);

// formated print with blocking, with argument list (returns number of characters, without terminating 0)
u32 UART_PrintArg(u8 uart, const char* fmt, va_list args);

// formated print with blocking, with variadic arguments (returns number of characters, without terminating 0)
NOINLINE u32 UART_Print(u8 uart, const char* fmt, ...);

// === UART test sample (with Tx/Rx loopback)
//
//  In this test example, signals Tx and Rx are connected by an internal loopback.
//  To use real signals, disconnect loopback with 'UART_LoopDisable' function and
//  connect signals to GPIOs with GPIO_Fnc(pin, GPIO_FNC_UART).
//
//  When polling mode is used for both transmit and receive, some test data may
//  be lost due to limited FIFO capacity (which is 32 characters).

// To setup UART test sample, edit flags UARTSAMPLE* in resource.h

#if UARTSAMPLE		// compilation switch from resource.h - compile UART test sample

// --- transmitter

// check if next character can be sent
Bool UartSample_SendReady();

// send character (wait if not ready)
void UartSample_SendChar(char ch);

// send buffer (wait if not ready)
void UartSample_SendBuf(const char* buf, int len);

// print to UART
NOINLINE u32 UartSample_Print(const char* fmt, ...);

#if UARTSAMPLE_TXMODE >= 2	// 2 = DMA stream, 3 = DMA single

// get free space in send buffer
int UartSample_SendFree();

#endif // UARTSAMPLE_TXMODE

// --- receiver

// check if next character can be received
Bool UartSample_RecvReady();

// receive character (wait if not ready)
char UartSample_RecvChar();

// receive buffer (without waiting), returns number of received characters
u32 UartSample_RecvBuf(char* buf, int len);

// --- initialize

// initialize sample UART
void UartSample_Init();

// terminate sample UART
void UartSample_Term();

#endif // UARTSAMPLE

#ifdef __cplusplus
}
#endif

#endif // _SDK_UART_H

#endif // USE_UART	// use UART serial port (sdk_uart.c, sdk_uart.h)

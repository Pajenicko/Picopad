
// ****************************************************************************
//
//                            UART serial port
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_UART	// use UART serial port (sdk_uart.c, sdk_uart.h)

#include "../inc/sdk_uart.h"
#include "../inc/sdk_clocks.h"
#include "../inc/sdk_timer.h"
#include "../inc/sdk_reset.h"
#include "../inc/sdk_cpu.h"
#include "../../_lib/inc/lib_ring.h"
#include "../../_lib/inc/lib_ringtx.h"
#include "../../_lib/inc/lib_ringrx.h"
#include "../../_lib/inc/lib_text.h"
#include "../../_lib/inc/lib_stream.h"
#include "../../_lib/inc/lib_print.h"

// set baudrate (range 45..3'000'000 with default clk_peri = 48 MHz; hardware support up to 921'600 bps)
void UART_Baud(u8 uart, u32 baudrate)
{
	// divisor = 2 * 64 * UARTCLK / (16 * baud_rate) = 2 * 4 * UARTCLK / baud_rate
	u32 div = (8 * CurrentFreq[CLK_PERI] + baudrate/2 ) / baudrate;

	// divisor integer part = divisor / 128
	u32 idiv = div >> 7;

	// divisor fractional part
	u32 fdiv = ((div & 0x7f) + 1) / 2;

	// limit ranges
	if (idiv == 0) // underflow, limit to minimal divisor
	{
		idiv = 1;
		fdiv = 0;
	}
	else if (idiv >= 65535) // overflow, limit to maximal divisor
	{
		idiv = 65535;
		fdiv = 0;
	}

	// set divisor
	*UART_IBRD(uart) = idiv;
	*UART_FBRD(uart) = fdiv;

	// dummy line control register write, to latch new divisor
	RegSet(UART_LCR(uart), 0);		
}

// get baudrate
u32 UART_GetBaud(u8 uart)
{
	// baud_rate_divisor = UARTCLK / (16 * baud_rate) ... fraction is in 1/64
	u32 k = 64 * *UART_IBRD(uart) + *UART_FBRD(uart);
	return (4 * CurrentFreq[CLK_PERI] + k/2) / k;
}

// set parity UART_PARITY_* (default UART_PARITY_NONE)
void UART_Parity(u8 uart, u8 parity)
{
	// bit 7: SPS stick parity enable
	// bit 2: EPS even parity select
	// bit 1: PEN parity enable
	u32 k = 0; // no parity
	if (parity > 0)
	{
		k = B1; // PEN parity enable
		if (parity >= 3) k |= B7; // SPS stick parity enable
		if ((parity & 1) == 0) k |= B2; // EPS even parity select
	}
	RegMask(UART_LCR(uart), k, B1|B2|B7);
}

// enable loopback test
void UART_LoopEnable(u8 uart)
{
	RegSet(UART_CR(uart), B7); // reconnect to loopback
#if USE_TIMER	// use Timer with alarm (sdk_timer.c, sdk_timer.h)
	WaitUs(50);  // wait to stabilize connection
#else
	int i;
	for (i = 1000; i > 0; i--) cb();
#endif
	UART_RecvFlush(0); // flush fake received characters
}

// disable loopback test (default state)
void UART_LoopDisable(u8 uart)
{
	RegClr(UART_CR(uart), B7); // reconnect to pins
#if USE_TIMER	// use Timer with alarm (sdk_timer.c, sdk_timer.h)
	WaitUs(50);  // wait to stabilize connection
#else
	int i;
	for (i = 1000; i > 0; i--) cb();
#endif
	UART_RecvFlush(0); // flush fake received characters
}

// === extended functions

// soft reset UART (restore to its default state; takes 0.5 us)
void UART_SoftReset(u8 uart)
{
	*UART_CR(uart) = B9|B8;		// disable UART
	*UART_IMCS(uart) = 0;		// disable interrupts
	*UART_DMACR(uart) = 0;		// disable DMAs
	*UART_ICR(uart) = 0x7ff;	// clear interrupts
	*UART_IFLS(uart) = 2 | (2 << 3); // FIFO levels
	*UART_LCR(uart) = 0;		// reset line control register
	*UART_IBRD(uart) = 0;		// integer baud rate
	*UART_FBRD(uart) = 0;		// fractional baud rate
	*UART_RSR(uart) = 0x0f;		// clear receive errors
}

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
void UART_Init(u8 uart, u32 baudrate, u8 word, u8 parity, u8 stop, Bool hw)
{
	// reset UART to its default state
	UART_Reset(uart);

	// set baudrate
	UART_Baud(uart, baudrate);

	// set word length
	UART_Word(uart, word);

	// set parity
	UART_Parity(uart, parity);

	// set 2 stop bits (or 1 stop bit otherwise)
	if (stop > 1) UART_Stop2(uart);

	// set hardware control
	if (hw)
	{
		UART_CTSEnable(uart);
		UART_RTSEnable(uart);
	}

	// enable FIFO
	UART_FifoEnable(uart);

	// enable UART
	UART_Enable(uart);
}

// send one character with waiting
void UART_SendCharWait(u8 uart, char data)
{
	while (!UART_SendReady(uart)) {}
	UART_SendChar(uart, data);
}

// receive one character with waiting
char UART_RecvCharWait(u8 uart)
{
	while (!UART_RecvReady(uart)) {}
	return UART_RecvChar(uart);
}

// flush received character
void UART_RecvFlush(u8 uart)
{
	while (UART_RecvReady(uart)) UART_RecvChar(uart);
}

// send buffer with blocking
void UART_Send(u8 uart, const u8* src, u32 len)
{
	for (; len > 0; len--) UART_SendCharWait(uart, *src++);
}

// receive buffer without blocking, returns number of successfully read characters
u32 UART_Recv(u8 uart, u8* dst, u32 len)
{
	u32 num = 0;
	for (; len > 0; len--)
	{
		if (!UART_RecvReady(uart)) break;
		*dst++ = UART_RecvChar(uart);
		num++;
	}
	return num;
}

// callback - write data to UART
static u32 StreamWriteUart(sStream* str, const void* buf, u32 num)
{
	// destination uart
	u8 uart = (u8)str->cookie;

	// send data to uart with blocking
	UART_Send(uart, (const u8*)buf, num);

	return num;
}

// initialize stream to write to UART with blocking
void StreamWriteUartInit(sStream* str, u8 uart)
{
	Stream0Init(str); // clear stream descriptor
	str->cookie = uart; // cookie = uart number
	str->write = StreamWriteUart; // write function
}

// formated print with blocking, with argument list (returns number of characters, without terminating 0)
u32 UART_PrintArg(u8 uart, const char* fmt, va_list args)
{
	// write and read stream
	sStream wstr, rstr;

	// initialize stream to read from
	StreamReadBufInit(&rstr, fmt, StrLen(fmt));

	// initialize stream to write to
	StreamWriteUartInit(&wstr, uart);
	
	// print string
	return StreamPrintArg(&wstr, &rstr, args);
}

// formated print with blocking, with variadic arguments (returns number of characters, without terminating 0)
NOINLINE u32 UART_Print(u8 uart, const char* fmt, ...)
{
	u32 n;
	va_list args;
	va_start(args, fmt);
	n = UART_PrintArg(uart, fmt, args);
	va_end(args);
	return n;
}

// === UART test sample (with Tx/Rx loopback)

#if UARTSAMPLE		// compilation switch from config_def.h - compile UART test sample

// --- transmitter, 1) polling mode

#if UARTSAMPLE_TXMODE == 0	// 0 = polling mode

// check if next character can be sent
Bool UartSample_SendReady() { return UART_SendReady(UARTSAMPLE_UART); }

// send character (wait if not ready)
void UartSample_SendChar(char ch) { UART_SendCharWait(UARTSAMPLE_UART, ch); }

// send buffer (wait if not ready)
void UartSample_SendBuf(const char* buf, int len) { UART_Send(UARTSAMPLE_UART, buf, len); }

// print to UART
NOINLINE u32 UartSample_Print(const char* fmt, ...)
{
	u32 n;
	va_list args;
	va_start(args, fmt);
	n = UART_PrintArg(UARTSAMPLE_UART, fmt, args);
	va_end(args);
	return n;
}

// --- transmitter, 2) interrupt mode

#elif UARTSAMPLE_TXMODE == 1	// 1 = interrupt mode with ring buffer

// internal function to force next send data
void UartSample_SendForce(sRing* ring)
{
	NVIC_IRQForce(IRQ_UART0 + UARTSAMPLE_UART); // force UART interrupt
}

// send ring buffer
//   name, size in bytes, index of spinlock, force send handler, cookie
RING(UartSample_TxBuf, 1<<UARTSAMPLE_TXORDER, UARTSAMPLE_TXSPIN, UartSample_SendForce, 0);

// check if next character can be sent
Bool UartSample_SendReady() { return RingWriteReady(&UartSample_TxBuf, 1); }

// send character (wait if not ready)
void UartSample_SendChar(char ch) { RingWrite8Wait(&UartSample_TxBuf, (u8)ch); }

// send buffer (wait if not ready)
void UartSample_SendBuf(const char* buf, int len) { RingWriteWait(&UartSample_TxBuf, buf, len); }

// print to UART
NOINLINE u32 UartSample_Print(const char* fmt, ...)
{
	u32 n;
	va_list args;
	va_start(args, fmt);
	n = RingPrintArg(&UartSample_TxBuf, fmt, args);
	va_end(args);
	return n;
}

// --- transmitter, 3) DMA mode

#elif UARTSAMPLE_TXMODE >= 2	// 2 = DMA stream, 3 = DMA single

// DMA send ring buffer
//   name, port, index of spinlock, order of size, dma channel, data request, entry size
RINGTX(UartSample_TxBuf, UART_DR(UARTSAMPLE_UART), UARTSAMPLE_TXSPIN, UARTSAMPLE_TXORDER,
	UARTSAMPLE_TXDMA, UART_DREQ(UARTSAMPLE_UART,0), DMA_SIZE_8);

// check if next character can be sent
Bool UartSample_SendReady() { return RingTxReady(&UartSample_TxBuf, 1); }

// send character (wait if not ready)
void UartSample_SendChar(char ch) { RingTxWrite8Wait(&UartSample_TxBuf, (u8)ch); }

// send buffer (wait if not ready)
void UartSample_SendBuf(const char* buf, int len) { RingTxWriteSend(&UartSample_TxBuf, buf, len); }

// get free space in send buffer
int UartSample_SendFree() { return RingTxFree(&UartSample_TxBuf); }

// print to UART
NOINLINE u32 UartSample_Print(const char* fmt, ...)
{
	u32 n;
	va_list args;
	va_start(args, fmt);
	n = RingTxPrintArg(&UartSample_TxBuf, fmt, args);
	va_end(args);
	return n;
}

#endif // UARTSAMPLE_TXMODE

// --- receiver, 1) polling mode

#if UARTSAMPLE_RXMODE == 0	// 0 = polling mode

// check if next character can be received
Bool UartSample_RecvReady() { return UART_RecvReady(UARTSAMPLE_UART); }

// receive character (wait if not ready)
char UartSample_RecvChar() { return UART_RecvCharWait(UARTSAMPLE_UART); }

// receive buffer (without waiting), returns number of received characters
u32 UartSample_RecvBuf(char* buf, int len) { return UART_Recv(UARTSAMPLE_UART, buf, len); }

// --- receiver, 2) interrupt mode

#elif UARTSAMPLE_RXMODE == 1	// 1 = interrupt mode with ring buffer

// receive ring buffer
//   name, size in bytes, index of spinlock, force send handler, cookie
RING(UartSample_RxBuf, 1<<UARTSAMPLE_RXORDER, UARTSAMPLE_RXSPIN, NULL, 0);

// check if next character can be received
Bool UartSample_RecvReady() { return RingReadReady(&UartSample_RxBuf, 1); }

// receive character (wait if not ready)
char UartSample_RecvChar() { return (char)RingRead8Wait(&UartSample_RxBuf); }

// receive buffer, returns number of received characters
u32 UartSample_RecvBuf(char* buf, int len) { return RingReadData(&UartSample_RxBuf, buf, len); }

// --- receiver, 3) DMA mode

#elif UARTSAMPLE_RXMODE == 2	// 2 = DMA with ring buffer

// DMA receive ring buffer
//   name, port, index of spinlock, order of size, dma channel, data request, entry size
RINGRX(UartSample_RxBuf, UART_DR(UARTSAMPLE_UART), UARTSAMPLE_RXSPIN, UARTSAMPLE_RXORDER,
	UARTSAMPLE_RXDMA, UART_DREQ(UARTSAMPLE_UART,1), DMA_SIZE_8);

// check if next character can be received
Bool UartSample_RecvReady() { return RingRxReady(&UartSample_RxBuf, 1); }

// receive character (wait if not ready)
char UartSample_RecvChar() { return (char)RingRxRead8Wait(&UartSample_RxBuf); }

// receive buffer, returns number of received characters
u32 UartSample_RecvBuf(char* buf, int len) { return RingRxReadData(&UartSample_RxBuf, buf, len); }

#endif // UARTSAMPLE_RXMODE

// --- initialize

// UART handler
// - remember to keep the state of the divider in the interrupt handler in case division is used in the handler
void UartSample_Handler()
{
	char ch;

#if UARTSAMPLE_TXMODE == 1	// 1 = interrupt mode with ring buffer

	// send data
	while (UART_SendReady(UARTSAMPLE_UART) && // free space in transmit FIFO
		RingReadReady(&UartSample_TxBuf, 1)) // some data are ready to send
			UART_SendChar(UARTSAMPLE_UART, RingRead8Wait(&UartSample_TxBuf));

	// clear transmit interrupt request (when there is no more data to send)
	UART_ClearIRQ(UARTSAMPLE_UART, UART_IRQ_TX);

#endif // UARTSAMPLE_TXMODE

#if UARTSAMPLE_RXMODE == 1	// 1 = interrupt mode with ring buffer

	// receive data
	while (UART_RecvReady(UARTSAMPLE_UART)) // received data ready
	{
		ch = UART_RecvChar(UARTSAMPLE_UART); // receive character from UART
		if (RingWriteReady(&UartSample_RxBuf, 1)) // if space in receive buffer
			RingWrite8(&UartSample_RxBuf, ch); // send character
		// otherwise lost received data if receive buffer is full
	}

#endif // UARTSAMPLE_RXMODE

}

// initialize sample UART (uses UART0, 512 bytes of RAM and 2 spinlocks)
void UartSample_Init()
{
	// default initialize UART: 115200 Baud, 8 bits, no parity, 1 stop, no hw control
	UART_InitDef(UARTSAMPLE_UART);

	// activate loopback test
	UART_LoopEnable(UARTSAMPLE_UART);

#if UARTSAMPLE_RXMODE == 2	// 2 = DMA with ring buffer

	// enable Rx DMA
	UART_EnableRxDMA(UARTSAMPLE_UART);

	// start DMA read transfer
	RingRxStart(&UartSample_RxBuf);

#endif // UARTSAMPLE_RXMODE

#if UARTSAMPLE_TXMODE >= 2	// 2 = DMA stream, 3 = DMA single

	// fill up send buffer with 'SYN' character
	memset(UartSample_TxBuf_buf, CH_SYN, (1<<UARTSAMPLE_TXORDER));

	// prepare ring buffer
	RingTxPrep(&UartSample_TxBuf);

	// enable Tx DMA
	UART_EnableTxDMA(UARTSAMPLE_UART);

#endif // UARTSAMPLE_TXMODE

#if UARTSAMPLE_TXMODE == 2	// 2 = DMA stream

	// start DMA write transfer
	RingTxStart(&UartSample_TxBuf);

#endif // UARTSAMPLE_TXMODE

#if (UARTSAMPLE_TXMODE == 1) || (UARTSAMPLE_RXMODE == 1) // 1 = interrupt mode with ring buffer
	// set UART handler
	SetHandler(IRQ_UART0 + UARTSAMPLE_UART, UartSample_Handler);

	// enable UART interrupt
	NVIC_IRQEnable(IRQ_UART0 + UARTSAMPLE_UART);
#endif // UARTSAMPLE_TXMODE, UARTSAMPLE_RXMODE

	// enable interrupts from FIFO
// Receive interrupt is triggered when the FIFO threshold level is reached.
// We also need a receive timeout interrupt (occurs if a character does not
// arrive for 32 clock cycles) to get the rest of the received bytes out of the FIFO.

#if UARTSAMPLE_TXMODE == 1	// 1 = interrupt mode with ring buffer
	UART_EnableIRQ(UARTSAMPLE_UART, UART_IRQ_TX); // enable transmit interrupt
#endif // UARTSAMPLE_TXMODE

#if UARTSAMPLE_RXMODE == 1	// 1 = interrupt mode with ring buffer
	UART_EnableIRQ(UARTSAMPLE_UART, UART_IRQ_RX); // enable receive interrupt
	UART_EnableIRQ(UARTSAMPLE_UART, UART_IRQ_TIMEOUT); // enable receive timeout interrupt
#endif // UARTSAMPLE_RXMODE

	// enable global interrupt
	//ei(); // should be already enabled, but don't forget to it
}

// terminate sample UART
void UartSample_Term()
{
#if UARTSAMPLE_TXMODE == 2	// 2 = DMA with ring buffer

	// stop DMA write transfer
	RingTxStop(&UartSample_TxBuf);

	// disable Tx DMA
	UART_DisableTxDMA(UARTSAMPLE_UART);

#endif // UARTSAMPLE_TXMODE

#if UARTSAMPLE_RXMODE == 2	// 2 = DMA with ring buffer

	// stop DMA read transfer
	RingRxStop(&UartSample_RxBuf);

	// disable Rx DMA
	UART_DisableRxDMA(UARTSAMPLE_UART);

#endif // UARTSAMPLE_RXMODE

#if (UARTSAMPLE_TXMODE == 1) || (UARTSAMPLE_RXMODE == 1) // 1 = interrupt mode with ring buffer
	// disable interrupts from FIFO
	UART_DisableIRQ(UARTSAMPLE_UART, UART_IRQ_TX); // disable transmit interrupt
	UART_DisableIRQ(UARTSAMPLE_UART, UART_IRQ_RX); // disable receive interrupt
	UART_DisableIRQ(UARTSAMPLE_UART, UART_IRQ_TIMEOUT); // enable receive timeout interrupt
	
	// disable UART interrupt
	NVIC_IRQDisable(IRQ_UART0 + UARTSAMPLE_UART);
#endif // UARTSAMPLE_TXMODE, UARTSAMPLE_RXMODE

	// reset UART to its defalt state
	UART_Reset(UARTSAMPLE_UART);
}

#endif // UARTSAMPLE

#endif // USE_UART	// use UART serial port (sdk_uart.c, sdk_uart.h)

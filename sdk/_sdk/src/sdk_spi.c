
// ****************************************************************************
//
//                            SPI interface
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_SPI	// use SPI interface (sdk_spi.c, sdk_spi.h)

#include "../inc/sdk_spi.h"
#include "../inc/sdk_clocks.h"
#include "../inc/sdk_reset.h"

// SPI reset (spi = 0 or 1)
void SPI_Reset(u8 spi)
{
	u32 mask = BIT((spi == 0) ? RESET_SPI0 : RESET_SPI1);
	ResetPeripheryOn(mask);
	ResetPeripheryOffWait(mask);
}

// SPI initialize to Motorola 8-bit Master mode (polarity 0, phase 0)
void SPI_Init(u8 spi, u32 baudrate)
{
	// SPI reset
	SPI_Reset(spi);

	// set SPI baudrate
	SPI_Baudrate(spi, baudrate);

	// set format: 8 data bits, polarity 0=steady state LOW, phase 0=first clock edge
	SPI_DataSize(spi, 8);
	SPI_Pol(spi, 0);
	SPI_Phase(spi, 0);

	// enable DMA transfers - harmless if DMA is not listening
	SPI_TxDmaEnable(spi);
	SPI_RxDmaEnable(spi);

	// enable SPI
	SPI_Enable(spi);
}

// SPI terminate
void SPI_Term(u8 spi)
{
	// disable SPI
	SPI_Disable(spi);

	// disable DMA transfers
	SPI_TxDmaDisable(spi);
	SPI_RxDmaDisable(spi);

	// SPI reset
	SPI_Reset(spi);
}

// set SPI baudrate (check real baudrate with SPI_GetBaudrate)
void SPI_Baudrate(u8 spi, u32 baudrate)
{
	u32 freq, prescale, postdiv;

	// get current peripheral clock
	freq = CurrentFreq[CLK_PERI];
	if (baudrate > freq) baudrate = freq; // baudrate is too high

	// find smallest prescale value which puts output frequency in
	// range of post-divide. Prescale is an even number from 2 to 254.
	for (prescale = 2; prescale <= 254; prescale += 2)
	{
		if (freq < (prescale+2)*256*(u64)baudrate) break;
	}
	if (prescale > 254) prescale = 254; // baudrate is too low

	// find largest post-divide which makes output <= baudrate.
	// Post-divide is an integer from 1 to 256.
	for (postdiv = 256; postdiv > 1; postdiv--)
	{
		if ((u32)(freq / (prescale * (postdiv - 1))) > baudrate) break;
	}

	// set prescaler
	*SPI_CPSR(spi) = prescale;

	// set post-divider
	RegMask(SPI_CR0(spi), (postdiv - 1) << 8, 0xff00);
}

// get current SPI baudrate
u32 SPI_GetBaudrate(u8 spi)
{
	u32 freq = CurrentFreq[CLK_PERI]; // peripheral clock, typically 48000000
	u32 prescale = *SPI_CPSR(spi) & 0xff; // clock prescale divisor, 2..254 even number
	u32 postdiv = ((*SPI_CR0(spi) >> 8) & 0xff) + 1; // post-divider, 1..256
	return freq / (prescale * postdiv);
}

// send and receive 8-bit data simultaneously
void SPI_Send8Recv(u8 spi, const u8* src, u8* dst, int len)
{
	int rx_len = len;
	int tx_len = len;

	// flush false received data
	SPI_RxFlush(spi);

	while ((rx_len > 0) || (tx_len > 0))
	{
		// send data
		if ((tx_len > 0) && !SPI_TxIsFull(spi))
		{
			SPI_Write(spi, *src++);
			tx_len--;
		}

		// receive data
		if ((rx_len > 0) && !SPI_RxIsEmpty(spi))
		{
			*dst++ = (u8)SPI_Read(spi);
			rx_len--;
		}
	}
}

// send 8-bit data, discard any data received back
void SPI_Send8(u8 spi, const u8* src, int len)
{
	// send data
	for (; len > 0; len--)
	{
		// send data
		while (SPI_TxIsFull(spi)) {}
		SPI_Write(spi, *src++);

		// flush received data
		SPI_RxFlush(spi);
	}

	// waiting for transmission to complete
	while (SPI_IsBusy(spi)) SPI_RxFlush(spi);

	// flush rest of received data
	SPI_RxFlush(spi);

	// clear interrupt on receive overrun status
	SPI_RxOverClear(spi);
}

// receive 8-bit data, send repeated byte (usually 0)
void SPI_Recv8(u8 spi, u8 repeated_tx, u8* dst, int len)
{
	int rx_len = len;
	int tx_len = len;

	// flush false received data
	SPI_RxFlush(spi);

	while ((rx_len > 0) || (tx_len > 0))
	{
		// send repeated data
		if ((tx_len > 0) && !SPI_TxIsFull(spi))
		{
			SPI_Write(spi, repeated_tx);
			tx_len--;
		}

		// receive data
		if ((rx_len > 0) && !SPI_RxIsEmpty(spi))
		{
			*dst++ = (u8)SPI_Read(spi);
			rx_len--;
		}
	}
}

// send and receive 16-bit data simultaneously
void SPI_Send16Recv(u8 spi, const u16* src, u16* dst, int len)
{
	int rx_len = len;
	int tx_len = len;

	// flush false received data
	SPI_RxFlush(spi);

	while ((rx_len > 0) || (tx_len > 0))
	{
		// send data
		if ((tx_len > 0) && !SPI_TxIsFull(spi))
		{
			SPI_Write(spi, *src++);
			tx_len--;
		}

		// receive data
		if ((rx_len > 0) && !SPI_RxIsEmpty(spi))
		{
			*dst++ = (u16)SPI_Read(spi);
			rx_len--;
		}
	}
}

// send 16-bit data, discard any data received back
void SPI_Send16(u8 spi, const u16* src, int len)
{
	// send data
	for (; len > 0; len--)
	{
		// send data
		while (SPI_TxIsFull(spi)) {}
		SPI_Write(spi, *src++);

		// flush received data
		SPI_RxFlush(spi);
	}

	// waiting for transmission to complete
	while (SPI_IsBusy(spi)) SPI_RxFlush(spi);

	// flush rest of received data
	SPI_RxFlush(spi);

	// clear interrupt on receive overrun status
	SPI_RxOverClear(spi);
}

// receive 16-bit data, send repeated word (usually 0)
void SPI_Recv16(u8 spi, u16 repeated_tx, u16* dst, int len)
{
	int rx_len = len;
	int tx_len = len;

	// flush false received data
	SPI_RxFlush(spi);

	while ((rx_len > 0) || (tx_len > 0))
	{
		// send repeated data
		if ((tx_len > 0) && !SPI_TxIsFull(spi))
		{
			SPI_Write(spi, repeated_tx);
			tx_len--;
		}

		// receive data
		if ((rx_len > 0) && !SPI_RxIsEmpty(spi))
		{
			*dst++ = (u16)SPI_Read(spi);
			rx_len--;
		}
	}
}

#endif // USE_SPI	// use SPI interface (sdk_spi.c, sdk_spi.h)

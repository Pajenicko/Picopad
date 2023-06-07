
// ****************************************************************************
//
//                            I2C interface
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_I2C	// use I2C interface (sdk_i2c.c, sdk_i2c.h)

#include "../inc/sdk_cpu.h"
#include "../inc/sdk_timer.h"
#include "../inc/sdk_i2c.h"
#include "../inc/sdk_clocks.h"
#include "../inc/sdk_reset.h"
#include "../sdk_dreq.h"

// flag - restart I2C on next transmission
Bool I2C_RestartOnNext[I2C_NUM];

// I2C reset
void I2C_Reset(u8 i2c)
{
	u32 mask = BIT((i2c == 0) ? RESET_I2C0 : RESET_I2C1);
	ResetPeripheryOn(mask);
	ResetPeripheryOffWait(mask);
}

// I2C terminate
void I2C_Term(u8 i2c)
{
	// I2C disable (wait to complete)
	I2C_Disable(i2c);

	// I2C reset
	I2C_Reset(i2c);
}

// I2C initialize (to master mode)
//   Speed of standard mode 0 to 100 kb/s, fast mode 400 kb/s, fast mode plus 1000 kb/s.
//   Minimum system clock CLK_SYS: standard mode min. 2.7 MHz, fast mode 12 MHz, fast mode plus 32 MHz.
void I2C_Init(u8 i2c, u32 baudrate)
{
	// I2C disable and reset
	I2C_Term(i2c);

	// no restart on next
	I2C_RestartOnNext[i2c] = False;

	// disable I2C (not needed, but wait to complete initialization)
	I2C_Disable(i2c);

	// configure fast-mode master with Restart support, 7-bit addresses
	*I2C_CON(i2c) = 
		B0 +		// Master mode enabled
		(2 << 1) + 	// fast mode
		B5 +		// master restart support
		B6 +		// slave disable
		B8;		// controlled generation of TX_EMPTY interrupt
		
	// set FIFO thresholds to minimum samples
	*I2C_RX_TL(i2c) = 0;	// receive FIFO threshold register
	*I2C_TX_TL(i2c) = 0;	// transmit FIFO threshold register

	// enable TX and RX DREQ signalling - harmless if DMA is not listening
	*I2C_DMA_CR(i2c) = B0+B1;

	// set I2C baudrate and enable I2C (requied only in master mode)
	I2C_Baudrate(i2c, baudrate);
}

// I2C switch to slave mode
//  addr ... slave address, must be in interval from 0x08 to 0x77
void I2C_SlaveMode(u8 i2c, u8 addr)
{
	// disable I2C
	I2C_Disable(i2c);

	// set slave mode (enable slave, disable master, hold bus)
	RegMask(I2C_CON(i2c), B9, B9+B6+B0);

	// set slave address
	*I2C_SAR(i2c) = addr;

	// I2C enable
	I2C_Enable(i2c);
}

// I2C switch to master mode
void I2C_MasterMode(u8 i2c)
{
	// disable I2C
	I2C_Disable(i2c);

	// set master mode (disable slave, enable master, not holding bus)
	RegMask(I2C_CON(i2c), B6+B0, B9+B6+B0);

	// I2C enable
	I2C_Enable(i2c);
}

// I2C enable (wait to complete)
void I2C_Enable(u8 i2c)
{
	cb();
	RegSet(I2C_ENABLE(i2c), B0);
	cb();
	while (!I2C_IsEnabled(i2c)) {}
	cb();
}

// I2C disable (wait to complete)
void I2C_Disable(u8 i2c)
{
	cb();
	RegClr(I2C_ENABLE(i2c), B0);
	cb();
	while (I2C_IsEnabled(i2c)) {}
	cb();
}

// set I2C baudrate and enable I2C (requied only in master mode)
//   Speed of standard mode 0 to 100 kb/s, fast mode 400 kb/s, fast mode plus 1000 kb/s. Can use I2C_BAUDRATE_*.
//   Minimum system clock CLK_SYS: standard mode min. 2.7 MHz, fast mode 12 MHz, fast mode plus 32 MHz.
void I2C_Baudrate(u8 i2c, u32 baudrate)
{
	// I2C must be disabled
	I2C_Disable(i2c);
	if (baudrate == 0) return;

	// set standard or fast mode (high speed mode is not supported)
	RegMask(I2C_CON(i2c), ((baudrate >= 110000) ? 2 : 1) << 1, B1+B2);	

	// get current system clock
	u32 freq = CurrentFreq[CLK_SYS];

// LOW pulse: LCNT + 1 (+ SCL rise time)
// HIGH pulse: HCNT + SPKLEN + 7 (+ SCL fall time)
// period: LCNT + HCNT + SPKLEN + 8 (+ SCL rise+fall time)
// required:
//   SPKLEN >= 1
//   LCNT >= SPKLEN + 7
//   HCNT >= SPKLEN + 5 (SS: max. 65525)
//   period SPKLEN+LCNT+HCNT >= 1+7 + 1+5 + 1 + 8 = 23

// SCL minimum high period: 4 us for 100 kbps, 0.6 us for 400 kpbs, 0.26 for 1000 kbps
// SCL minimum low period: 4.7 us for 100 kbps, 1.3 us for 400 kpbs, 0.5 for 1000 kbps

// CNT high period on 48 MHz: 192 clk for 100 kbps, 29 clk for 400 kpbs, 12 clk for 1000 kbps
// CNT low period on 48 MHz: 226 clk for 100 kbps, 62 ckl for 400 kpbs, 24 clk for 1000 kbps

	// total clock cycles per one bit
	u32 period = (freq + baudrate/2) / baudrate;
	if (period < 23) period = 23;

	// get pulses (period: LCNT + HCNT + SPKLEN + 8)
	period -= 8;
	u32 spklen = period / 16;
	if (spklen < 1) spklen = 1;
	if (spklen > 255) spklen = 255;
	period -= spklen;
	u32 lcnt = period * 3 / 5; // lcnt should be a little longer than hcnt
	if (lcnt < spklen + 7) lcnt = spklen + 7;
	if (lcnt > 0xffff) lcnt = 0xffff;
	u32 hcnt = period - lcnt;
	if (hcnt < spklen + 5) hcnt = spklen + 5;
	if (hcnt > 65525) hcnt = 65525;

	// set counters
	*I2C_SS_SCL_HCNT(i2c) = hcnt;
	*I2C_SS_SCL_LCNT(i2c) = lcnt;
	*I2C_FS_SCL_HCNT(i2c) = hcnt;
	*I2C_FS_SCL_LCNT(i2c) = lcnt;
	*I2C_FS_SPKLEN(i2c) = spklen;

	// set tx hold count (300 ns for standard mode and fast mode, 120 fs for fast mode plus)
	u32 hold;
	if (baudrate < 600000)
		hold = freq*3/10000000+1; // 300 ns
	else
		hold = freq*3/25000000+1; // 120 ns
	if (hold > lcnt - 2) hold = lcnt - 2;
	RegMask(I2C_SDA_HOLD(i2c), hold, 0xffff);

	// I2C enable
	I2C_Enable(i2c);
}

// get current I2C baudrate
u32 I2C_GetBaudrate(u8 i2c)
{
	u32 freq = CurrentFreq[CLK_SYS];
	u32 hcnt = *I2C_FS_SCL_HCNT(i2c) & 0xffff;
	u32 lcnt = *I2C_FS_SCL_LCNT(i2c) & 0xffff;
	u32 spklen = *I2C_FS_SPKLEN(i2c) & 0xff;
	u32 period = lcnt + hcnt + spklen + 8;
	return (freq + period/2) / period;
}

// send data from buffer
void I2C_SendData(u8 i2c, const u8* src, int len)
{
	for (; len > 0; len--)
	{
		while (I2C_TxFifo(i2c) == 0) {}
		*I2C_DATA_CMD(i2c) = *src++;
	}
}

// receive data to buffer
void I2C_RecvData(u8 i2c, u8* dst, int len)
{
	for (; len > 0; len--)
	{
		while (I2C_RxFifo(i2c) == 0) {}
		*dst++ = (u8)*I2C_DATA_CMD(i2c);
	}
}

// send message to slave
//  i2c ... I2C number 0 or 1
//  addr ... slave address of device to write to, must be in interval from 0x08 to 0x77
//  src ... pointer to data to send
//  len .. length of data in bytest to send (must be > 0)
//  nostop ... no stop after end of transmission (next transfer will begin with Restart, not Start)
//  timeout ... timeout in [us] of one character sent (0=no timeout)
// Returns number of bytes sent, can be less than 'len' in case of error.
int I2C_SendMsg(u8 i2c, u8 addr, const u8* src, int len, Bool nostop, u32 timeout)
{
	// cannot send 0 data bytes
	if (len <= 0) return 0;

	// set target address (temporary disable I2C)
	I2C_Disable(i2c);
	*I2C_TAR(i2c) = addr;	
	I2C_Enable(i2c);

	// send data
	Bool abort = False;
	u32 d, t;
	int data_sent;
	for (data_sent = 0; data_sent < len; data_sent++)
	{
		// get data byte to send
		d = *src++;	// data byte to send

		// restart on start of new transmission
		if ((data_sent == 0) && I2C_RestartOnNext[i2c]) d |= B10;

		// stop message, sent STOP condition
		if ((data_sent == len-1) && !nostop) d |= B9;

		// write data
		*I2C_DATA_CMD(i2c) = d;

		// wait for end of transmission or timeout
		t = Time();
		do {
			if (timeout > 0)
			{
				if ((u32)(Time() - t) >= timeout) abort = True;
			}

		} while (!abort && ((*I2C_RAW_INTR_STAT(i2c) & B4) == 0)); // check TX_EMPTY flag

		// character was sent (no timeout)
		if (!abort)
		{
			// check transmission abort
			if (*I2C_TX_ABRT_SOURCE(i2c) != 0)
			{
				// clear abort flags by reading flag register
				(void)*I2C_CLR_TX_ABRT(i2c);
				abort = True;
			}

			// if abort or if last byte was sent, wait for end of transmission (wait for STOP condition)
			if (abort || ((data_sent == len-1) && !nostop))
			{
				do {
					if (timeout > 0)
					{
						if ((u32)(Time() - t) >= timeout) abort = True;
					}
				} while (!abort && ((*I2C_RAW_INTR_STAT(i2c) & B9) == 0)); // check STOP_DET flag

				// if not timeout, clear stop-detection flag
				if (!abort) (void)*I2C_CLR_STOP_DET(i2c);
			}
		}

		// abort (timeout or transmission abort)
		if (abort) break;
	}

	// restart on next transmission
	I2C_RestartOnNext[i2c] = nostop;

	// return data sent (should be equal to len)
	return data_sent;
}

// read message from slave
//  i2c ... I2C number 0 or 1
//  addr ... slave address of device to read from, must be in interval from 0x08 to 0x77
//  dst ... pointer to buffer to receive data
//  len .. length of data in bytest to receive (must be > 0)
//  nostop ... no stop after end of transfer (next transfer will begin with Restart, not Start)
//  timeout ... timeout in [us] of one character received (0=no timeout)
// Returns number of bytes received, can be less than 'len' in case of error.
int I2C_RecvMsg(u8 i2c, u8 addr, u8* dst, int len, Bool nostop, u32 timeout)
{
	// cannot receive 0 data bytes
	if (len <= 0) return 0;

	// set target address (temporary disable I2C)
	I2C_Disable(i2c);
	*I2C_TAR(i2c) = addr;	
	I2C_Enable(i2c);

	// receive data
	Bool abort = False;
	u32 d, t;
	int data_recv;
	for (data_recv = 0; data_recv < len; data_recv++)
	{
		// wait for TX FIFO
		while (I2C_TxFifo(i2c) == 0) {}

		// write command "read data"	
		d = B8; // command: master read
		if ((data_recv == 0) && I2C_RestartOnNext[i2c]) d |= B10; // restart on start of new transmission
		if ((data_recv == len-1) && !nostop) d |= B9; // stop message, sent STOP condition
		*I2C_DATA_CMD(i2c) = d; // write command

		// wait for receiving character or timeout
		t = Time();
		do {
			// check transfer abort
			if (*I2C_TX_ABRT_SOURCE(i2c) != 0)
			{
				// clear abort flags by reading flag register
				(void)*I2C_CLR_TX_ABRT(i2c);
				abort = True;
			}

			// check timeout
			if (timeout > 0)
			{
				if ((u32)(Time() - t) >= timeout) abort = True;
			}

		} while (!abort && (I2C_RxFifo(i2c) == 0));

		// abort (timeout or transfer abort)
		if (abort) break;

		// read data into buffer
		*dst++ = (u8)*I2C_DATA_CMD(i2c);
	}

	// restart on next transmission
	I2C_RestartOnNext[i2c] = nostop;

	// return data received (should be equal to len)
	return data_recv;
}

#endif // USE_I2C	// use I2C interface (sdk_i2c.c, sdk_i2c.h)

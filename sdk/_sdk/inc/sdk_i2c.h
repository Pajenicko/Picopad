
// ****************************************************************************
//
//                            I2C interface
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// To configure I2C pins SCL and SDA, set pull-up enabled, slew rate limited, schmitt trigger enabled.
// Default slave address is 0x055.
// Speed: standard mode 0 to 100 kb/s, fast mode 400 kb/s, fast mode plus 1000 kb/s.

/* Minimum system clock CLK_SYS derived from minimal values of registers:
speed SS:
	clkfreq = 2.7 MHz
	min SPKLEN = 1
	SCL low = 13 clk
	SCL low prog = 12
	SCL low time = 4.7 us
	SCL high = 14 clk
	SCL high prog = 6
	SCL high time = 5.2 us
speed FS:
	clkfreq = 12 MHz
	min SPKLEN = 1
	SCL low = 16 clk
	SCL low prog = 15
	SCL low time = 1.33 us
	SCL high = 14 clk
	SCL high prog = 6
	SCL high time = 1.16 us
speed FM+:
	clkfreq = 32 MHz
	min SPKLEN = 2
	SCL low = 16 clk
	SCL low prog = 15
	SCL low time = 0.5 us
	SCL high = 16 clk
	SCL high prog = 7
	SCL high time = 0.5 us
*/

#if USE_I2C	// use I2C interface (sdk_i2c.c, sdk_i2c.h)

#ifndef _SDK_I2C_H
#define _SDK_I2C_H

#include "../sdk_addressmap.h"		// Register address offsets
#include "../sdk_dreq.h"

#ifdef __cplusplus
extern "C" {
#endif

#define I2C_NUM			2		// number of I2C controllers
#define I2C_TXFIFO_NUM		16		// number of I2C tansmit FIFO entries
#define I2C_RXFIFO_NUM		16		// number of I2C receive FIFO entries
#define I2C_SLAVE_ADDR		0x055		// default slave address

// default baudrate
#define I2C_BAUDRATE_SS		100000		// standard mode 100 kb/s
#define I2C_BAUDRATE_FS		400000		// fast mode 400 kb/s
#define I2C_BAUDRATE_FP		1000000		// fast mode plus 1000 kb/s

// I2C registers (i2c = 0 or 1)
//#define I2C0_BASE		0x40044000	// I2C0 interface
//#define I2C1_BASE		0x40048000	// I2C1 interface
#define I2C_BASE(i2c)		(I2C0_BASE+(i2c)*0x4000)	// I2C base address (i2c = 0 or 1)

#define I2C_CON(i2c)		((volatile u32*)(I2C_BASE(i2c)+0x00))	// control register ... DW_apb_i2c must be enabled
#define I2C_TAR(i2c)		((volatile u32*)(I2C_BASE(i2c)+0x04))	// target address register
#define I2C_SAR(i2c)		((volatile u32*)(I2C_BASE(i2c)+0x08))	// slave address register
#define I2C_DATA_CMD(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x10))	// data buffer and command register
#define I2C_SS_SCL_HCNT(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x14))	// standard speed I2C clock SCL High count register
#define I2C_SS_SCL_LCNT(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x18))	// standard speed I2C clock SCL Low count register
#define I2C_FS_SCL_HCNT(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x1C))	// fast speed I2C clock SCL High count register
#define I2C_FS_SCL_LCNT(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x20))	// fast speed I2C clock SCL Low count register
#define I2C_INTR_STAT(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x2C))	// interrupt status register
#define I2C_INTR_MASK(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x30))	// interrupt mask register
#define I2C_RAW_INTR_STAT(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x34))	// raw interrupt status register
#define I2C_RX_TL(i2c)		((volatile u32*)(I2C_BASE(i2c)+0x38))	// receive FIFO threshold register
#define I2C_TX_TL(i2c)		((volatile u32*)(I2C_BASE(i2c)+0x3C))	// transmit FIFO threshold register
#define I2C_CLR_INTR(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x40))	// clear interrupt
#define I2C_CLR_RX_UNDER(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x44))	// clear RX_UNDER
#define I2C_CLR_RX_OVER(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x48))	// clear RX_OVER
#define I2C_CLR_TX_OVER(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x4C))	// clear TX_OVER
#define I2C_CLR_RD_REQ(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x50))	// clear RD_REQ
#define I2C_CLR_TX_ABRT(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x54))	// clear TX_ABRT
#define I2C_CLR_RX_DONE(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x58))	// clear RX_DONE
#define I2C_CLR_ACTIVITY(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x5C))	// clear ACTIVITY
#define I2C_CLR_STOP_DET(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x60))	// clear STOP_DET
#define I2C_CLR_START_DET(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x64))	// clear START_DET
#define I2C_CLR_GEN_CALL(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x68))	// clear GEN_CALL
#define I2C_ENABLE(i2c)		((volatile u32*)(I2C_BASE(i2c)+0x6C))	// enable
#define I2C_STATUS(i2c)		((volatile u32*)(I2C_BASE(i2c)+0x70))	// status
#define I2C_TXFLR(i2c)		((volatile u32*)(I2C_BASE(i2c)+0x74))	// transmit FIFO level
#define I2C_RXFLR(i2c)		((volatile u32*)(I2C_BASE(i2c)+0x78))	// receive FIFO level
#define I2C_SDA_HOLD(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x7C))	// SDA hold time length
#define I2C_TX_ABRT_SOURCE(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x80))	// transmit abort source
#define I2C_SLV_DATA_NACK_ONLY(i2c) ((volatile u32*)(I2C_BASE(i2c)+0x84)) // generate slave data NACK
#define I2C_DMA_CR(i2c)		((volatile u32*)(I2C_BASE(i2c)+0x88))	// DMA control
#define I2C_DMA_TDLR(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x8C))	// DMA transmit data level
#define I2C_DMA_RDLR(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x90))	// DMA receive data level
#define I2C_SDA_SETUP(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x94))	// SDA setup
#define I2C_ACK_GENERAL_CALL(i2c) ((volatile u32*)(I2C_BASE(i2c)+0x98))	// ACK general call
#define I2C_ENABLE_STATUS(i2c)	((volatile u32*)(I2C_BASE(i2c)+0x9C))	// enable status
#define I2C_FS_SPKLEN(i2c)	((volatile u32*)(I2C_BASE(i2c)+0xA0))	// spike suppression limit
#define I2C_CLR_RESTART_DET(i2c) ((volatile u32*)(I2C_BASE(i2c)+0xA8))	// clear RESTART_DET
#define I2C_COMP_PARAM_1(i2c)	((volatile u32*)(I2C_BASE(i2c)+0xF4))	// component parameter register 1
#define I2C_COMP_VERSION(i2c)	((volatile u32*)(I2C_BASE(i2c)+0xF8))	// component version
#define I2C_COMP_TYPE(i2c)	((volatile u32*)(I2C_BASE(i2c)+0xFC))	// component type

// I2C reset
void I2C_Reset(u8 i2c);

// I2C terminate
void I2C_Term(u8 i2c);

// I2C initialize (to master mode)
//   Speed of standard mode 0 to 100 kb/s, fast mode 400 kb/s, fast mode plus 1000 kb/s.
//   Minimum system clock CLK_SYS: standard mode min. 2.7 MHz, fast mode 12 MHz, fast mode plus 32 MHz.
void I2C_Init(u8 i2c, u32 baudrate);

// I2C switch to slave mode
//  addr ... slave address, must be in interval from 0x08 to 0x77
void I2C_SlaveMode(u8 i2c, u8 addr);

// I2C switch to master mode
void I2C_MasterMode(u8 i2c);

// check if I2C is enabled
INLINE Bool I2C_IsEnabled(u8 i2c) { return (*I2C_ENABLE_STATUS(i2c) & B0) != 0; }

// I2C enable (wait to complete)
void I2C_Enable(u8 i2c);

// I2C disable (wait to complete)
void I2C_Disable(u8 i2c);

// check if I2C transfer is active
INLINE Bool I2C_IsActive(u8 i2c) { return (*I2C_STATUS(i2c) & B0) != 0; }

// set I2C baudrate and enable I2C (requied only in master mode)
//   Speed of standard mode 0 to 100 kb/s, fast mode 400 kb/s, fast mode plus 1000 kb/s. Can use I2C_BAUDRATE_*.
//   Minimum system clock CLK_SYS: standard mode min. 2.7 MHz, fast mode 12 MHz, fast mode plus 32 MHz.
void I2C_Baudrate(u8 i2c, u32 baudrate);

// get current I2C baudrate
u32 I2C_GetBaudrate(u8 i2c);

// get remaining space in transmit FIFO (0 = transmit FIFO is full)
INLINE u8 I2C_TxFifo(u8 i2c) { return I2C_TXFIFO_NUM - *I2C_TXFLR(i2c); }

// get number of entries in receive FIFO (0 = receive FIFO is empty)
INLINE u8 I2C_RxFifo(u8 i2c) { return *I2C_RXFLR(i2c); }

// send data from buffer
void I2C_SendData(u8 i2c, const u8* src, int len);

// receive data to buffer
void I2C_RecvData(u8 i2c, u8* dst, int len);

// get DREQ to use for pacing transfers
//  i2c ... I2C number 0 or 1
//  tx ... True for sending data to I2C, False for receiving data from I2C
INLINE u8 I2C_GetDreq(u8 i2c, Bool tx) { return DREQ_I2C0_TX + i2c*2 + (tx ? 0 : 1); }

// send message to slave
//  i2c ... I2C number 0 or 1
//  addr ... slave address of device to write to, must be in interval from 0x08 to 0x77
//  src ... pointer to data to send
//  len .. length of data in bytest to send (must be > 0)
//  nostop ... no stop after end of transmission (next transfer will begin with Restart, not Start)
//  timeout ... timeout in [us] of one character sent (0=no timeout)
// Returns number of bytes sent, can be less than 'len' in case of error.
int I2C_SendMsg(u8 i2c, u8 addr, const u8* src, int len, Bool nostop, u32 timeout);

// read message from slave
//  i2c ... I2C number 0 or 1
//  addr ... slave address of device to read from, must be in interval from 0x08 to 0x77
//  dst ... pointer to buffer to receive data
//  len .. length of data in bytest to receive (must be > 0)
//  nostop ... no stop after end of transfer (next transfer will begin with Restart, not Start)
//  timeout ... timeout in [us] of one character received (0=no timeout)
// Returns number of bytes received, can be less than 'len' in case of error.
int I2C_RecvMsg(u8 i2c, u8 addr, u8* dst, int len, Bool nostop, u32 timeout);

#ifdef __cplusplus
}
#endif

#endif // _SDK_I2C_H

#endif // USE_I2C	// use I2C interface (sdk_i2c.c, sdk_i2c.h)

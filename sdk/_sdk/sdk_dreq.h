
// ****************************************************************************
//
//                           DREQ data request channels
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#ifndef _SDK_DREQ_H
#define _SDK_DREQ_H

// extern data request channels
#define DREQ_PIO0_TX0	0x00
#define DREQ_PIO0_TX1	0x01
#define DREQ_PIO0_TX2	0x02
#define DREQ_PIO0_TX3	0x03
#define DREQ_PIO0_RX0	0x04
#define DREQ_PIO0_RX1	0x05
#define DREQ_PIO0_RX2	0x06
#define DREQ_PIO0_RX3	0x07
#define DREQ_PIO1_TX0	0x08
#define DREQ_PIO1_TX1	0x09
#define DREQ_PIO1_TX2	0x0a
#define DREQ_PIO1_TX3	0x0b
#define DREQ_PIO1_RX0	0x0c
#define DREQ_PIO1_RX1	0x0d
#define DREQ_PIO1_RX2	0x0e
#define DREQ_PIO1_RX3	0x0f
#define DREQ_SPI0_TX	0x10
#define DREQ_SPI0_RX	0x11
#define DREQ_SPI1_TX	0x12
#define DREQ_SPI1_RX	0x13
#define DREQ_UART0_TX	0x14
#define DREQ_UART0_RX	0x15
#define DREQ_UART1_TX	0x16
#define DREQ_UART1_RX	0x17
#define DREQ_PWM_WRAP0	0x18
#define DREQ_PWM_WRAP1	0x19
#define DREQ_PWM_WRAP2	0x1a
#define DREQ_PWM_WRAP3	0x1b
#define DREQ_PWM_WRAP4	0x1c
#define DREQ_PWM_WRAP5	0x1d
#define DREQ_PWM_WRAP6	0x1e
#define DREQ_PWM_WRAP7	0x1f
#define DREQ_I2C0_TX	0x20
#define DREQ_I2C0_RX	0x21
#define DREQ_I2C1_TX	0x22
#define DREQ_I2C1_RX	0x23
#define DREQ_ADC	0x24
#define DREQ_XIP_STREAM	0x25
#define DREQ_XIP_SSITX	0x26
#define DREQ_XIP_SSIRX	0x27

// internal DMA data request
#define DREQ_TIMER0	0x3b
#define DREQ_TIMER1	0x3c
#define DREQ_TIMER2	0x3d
#define DREQ_TIMER3	0x3e

#define DREQ_TIMER(timer) (DREQ_TIMER0+(timer))

#define DREQ_FORCE	0x3f	// permanent request

#endif // _SDK_DREQ_H

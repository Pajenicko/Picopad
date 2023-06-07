#include "sdk_addressmap.h"	// Register address offsets
#include "sdk_dreq.h"		// DREQ data request channels
#include "sdk_sftable.h"	// offsets of floating-point functions

#include "inc/sdk_adc.h"	// ADC
#include "inc/sdk_bootrom.h"	// Boot ROM
#include "inc/sdk_clocks.h"	// Clocks
#include "inc/sdk_cpu.h"	// CPU control
#include "inc/sdk_divider.h"	// integer divider
#include "inc/sdk_dma.h"	// DMA controller
#include "inc/sdk_double.h"	// double-floating-point
#include "inc/sdk_fifo.h"	// inter-core FIFO
#include "inc/sdk_flash.h"	// Flash memory
#include "inc/sdk_float.h"	// single-floating-point
#include "inc/sdk_gpio.h"	// GPIO pins
#include "inc/sdk_i2c.h"	// I2C interface
#include "inc/sdk_interp.h"	// interpolator
#include "inc/sdk_irq.h"	// IRQ interrupt request
#include "inc/sdk_multicore.h"	// multicore
#include "inc/sdk_pio.h"	// PIO
#include "inc/sdk_pll.h"	// PLL phase-locked loop
#include "inc/sdk_pwm.h"	// PWM
#include "inc/sdk_qspi.h"	// QSPI flash pins
#include "inc/sdk_reset.h"	// reset and power-on
#include "inc/sdk_rosc.h"	// ROSC ring oscillator
#include "inc/sdk_rtc.h"	// RTC Real-time clock
#include "inc/sdk_spi.h"	// SPI interface
#include "inc/sdk_spinlock.h"	// spin lock
#include "inc/sdk_ssi.h"	// SSI synchronous serial interface
#include "inc/sdk_systime.h"	// SysTick system timer
#include "inc/sdk_timer.h"	// Timer
#include "inc/sdk_uart.h"	// UART serial port
#include "inc/sdk_watchdog.h"	// Watchdog timer
#include "inc/sdk_xip.h"	// XIP flash control
#include "inc/sdk_xosc.h"	// XOSC cystal oscillator

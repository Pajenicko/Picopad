
/**
* MIT License
*
* Copyright (c) 2023 Tomas Vecera, tomas@vecera.dev
*
* Portions of this software are derived from the PicoLibSDK:
*   Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz, hardyplotter2@gmail.com
*   Repository: https://github.com/Panda381/PicoLibSDK
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
* documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
* rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
* persons to whom the Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
* Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
* WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
* OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include "picopad.h"
#include "RP2040.h"
#include "hardware/resets.h"

// Repeating timer for periodical call KeyScan
struct repeating_timer timer0;

bool repeating_timer_callback(struct repeating_timer *t) {
	KeyScan();
	return true;
}

// Device init
void device_init() {
	// initialize LEDs
#if USE_PICOPAD_LED
	led_init();
#endif

#if USE_SD
	sd_init();
	sleep_ms(100);

	// Try to load config file from SD card, if rebooted by watchdog, try to loaded data from memory
#if USE_CONFIG
	if (watchdog_hw->scratch[4] == WATCHDOG_MAGIC_VALUE) {
		load_config_data();
	} else {
		load_config_file();
	}
	watchdog_hw->scratch[4] = 0;
#endif

#else
	// Disable SD LED
	gpio_init(SD_CS);
	gpio_put(SD_CS, 1);
	gpio_set_dir(SD_CS, GPIO_OUT);

	// Try to load config file from memmory
	load_config_data();
#endif

#if USE_ST7789
	// initialize display
	DispInit(DISP_ROTATION);
#endif

	// initilize keys
	KeyInit();

	// init battery measurement
	BatInit();

#if USE_PWMSND
	PWMSndInit();
#endif

#if SYSTICK_KEYSCAN
	add_repeating_timer_us(1000, repeating_timer_callback, NULL, &timer0);
#endif
}

// Device terminate
void device_terminate() {
	// terminate LEDs
#if USE_PICOPAD_LED
	led_terminate();
#endif

#if USE_ST7789
	// terminate display
	DispTerm();
#endif

	// terminate keys
	KeyTerm();

	// terminate battery measurement
	BatTerm();

#if USE_PWMSND
	// terminate PWM sound output
	PWMSndTerm();
#endif

#if USE_SD
	// terminate SD card interface
	sd_terminate();
#endif

#if SYSTICK_KEYSCAN
	cancel_repeating_timer(&timer0);
#endif
}

/**
 * Resets the device to the USB boot mode - BOOTSEL.
 */
void reset_to_bootsel() {
	reset_usb_boot(0, 0);
}

/**
 * Resets the device to the onboard bootloader.
 */
void reset_to_boot_loader() {
	// Set a magic value to the watchdog's scratch register to indicate a bootloader reset
	watchdog_hw->scratch[4] = WATCHDOG_MAGIC_VALUE;

	// Enable the watchdog with a very short timeout
	watchdog_enable(1, 1);

	// Infinite loop: The watchdog will reset the system before breaking out of this loop
	while(true);
}

void disable_interrupts() {
	SysTick->CTRL &= ~1;

	NVIC->ICER[0] = 0xFFFFFFFF;
	NVIC->ICPR[0] = 0xFFFFFFFF;
}

void reset_peripherals() {
	reset_block(~(
			RESETS_RESET_IO_QSPI_BITS |
			RESETS_RESET_PADS_QSPI_BITS |
			RESETS_RESET_SYSCFG_BITS |
			RESETS_RESET_PLL_SYS_BITS
	));
}


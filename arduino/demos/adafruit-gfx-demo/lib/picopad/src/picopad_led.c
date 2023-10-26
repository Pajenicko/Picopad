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

#if USE_PICOPAD_LED

// Structure for LED configuration
typedef struct {
		uint8_t pin;       // GPIO pin for the LED
		bool inverted; // Inversion flag for the LED
} led_config_t;

// LED configurations
const led_config_t led_configs[LED_NUM] = {
		{LED1_PIN, true},
		{LED2_PIN, false}
};

// set LED ON
void led_on(uint8_t inx) {
	gpio_put(led_configs[inx].pin, 1);
}

// set LED OFF
void led_off(uint8_t inx) {
	gpio_put(led_configs[inx].pin, 0);
}

// flip LED
void led_flip(uint8_t inx) {
	gpio_xor_mask(1UL << led_configs[inx].pin);
}

// initialize LEDs
void led_init() {
	for (int i = 0; i < LED_NUM; i++) {
		gpio_init(led_configs[i].pin);
		gpio_set_dir(led_configs[i].pin, GPIO_OUT);
		if (led_configs[i].inverted) gpio_set_outover(led_configs[i].pin, GPIO_OVERRIDE_INVERT);
		led_off(i);
	}
}

// terminate LEDs
void led_terminate() {
	for (int i = 0; i < LED_NUM; i++) {
		gpio_deinit(led_configs[i].pin);
	}
}

#endif

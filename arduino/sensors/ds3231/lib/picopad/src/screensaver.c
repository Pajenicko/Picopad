/**
* MIT License
*
* Copyright (c) 2023 Tomas Vecera, tomas@vecera.dev
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

#if USE_ST7789

static uint32_t screensaver_timeout_ms = 0;
static uint32_t last_activity_ms = 0;
static repeating_timer_t screensaver_timer;
static bool disabled_screen = false;

// Fade in effect
static void fade_in_screen() {
#if USE_PICOPAD_LED
	led_flip(LED1);
#endif
#if USE_CONFIG
	int bl_val = load_config_data().brightness;
#else
	int bl_val = 5;
#endif
	for (int brightness = bl_val; brightness >= 0; brightness--) {
		SetBrightness(brightness, false);
		sleep_ms(FADE_EFFECT_TIME);
	}
	disabled_screen = true;
	DispOff();
}

// Fade out effect
static void fade_out_screen() {
#if USE_CONFIG
	int bl_val = load_config_data().brightness;
#else
	int bl_val = 5;
#endif
	for (int brightness = 0; brightness <= bl_val; brightness++) {
		SetBrightness(brightness, false);
		sleep_ms(FADE_EFFECT_TIME);
	}
	disabled_screen = false;
	DispOn();
#if USE_PICOPAD_LED
	led_flip(LED1);
#endif
}

// Timer callback to check for inactivity
static bool screensaver_timer_callback(__attribute__((unused)) repeating_timer_t *t) {
	uint32_t current_time = to_ms_since_boot(get_absolute_time());

	if ((current_time - last_activity_ms) >= screensaver_timeout_ms) {
		fade_in_screen();
		// Stop the timer once the screen is faded out
		return false;
	}
	// Keep the timer running
	return true;
}

// Initialize the screensaver module
void screensaver_init() {
	last_activity_ms = to_ms_since_boot(get_absolute_time());
#if USE_CONFIG
	uint8_t screen_sleep = load_config_data().screen_sleep;
#else
	uint8_t screen_sleep = 0;
#endif

	if (screen_sleep > 0 && screen_sleep <= 9) {
		screensaver_timeout_ms = screen_sleep * 120 * 1000;
		add_repeating_timer_us(screensaver_timeout_ms * 1000, screensaver_timer_callback, NULL, &screensaver_timer);
	}
}

// Reset the screensaver timer (call this when there's activity)
char screensaver_reset_timer(char ch) {
	if (screensaver_timeout_ms && ch != NOKEY) {
		last_activity_ms = to_ms_since_boot(get_absolute_time());

		// Cancel the existing timer
		cancel_repeating_timer(&screensaver_timer);
		// Fade out the screen
		if (disabled_screen) {
			KeyFlush();
			fade_out_screen();
			ch = NOKEY;
		}

		// Restart the timer
		add_repeating_timer_us(screensaver_timeout_ms * 1000, screensaver_timer_callback, NULL, &screensaver_timer);
	}

	return ch;
}

#endif
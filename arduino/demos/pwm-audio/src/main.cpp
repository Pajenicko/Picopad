/*
 * Code from: https://github.com/earlephilhower/arduino-pico/tree/master/libraries/PWMAudio/examples/PlayRaw
 *
 * This example plays a raw, headerless, mono 16b, 44.1 sample using the PWMAudio library on GPIO 1.
 * Released to the public domain by Earle F. Philhower, III <earlephilhower@yahoo.com>
*/

#include "Arduino.h"
#include "picopad.h"
#include <PWMAudio.h>
#include "wav.h"

// The sample pointers
const int16_t *start = (const int16_t *) out_raw;
const int16_t *p = start;

// Create the PWM audio device on GPIO 15
PWMAudio pwm(PWMSND_GPIO);

unsigned int count = 0;

char ch;

// Function to delay for a specified number of milliseconds
// Additionally, it checks for a key press every 10 milliseconds.
// If the Y key is pressed, the system resets to the bootloader.
void wait(uint16_t ms) {
	for (uint16_t i = 0; i < ms / 10; i++) {
		sleep_ms(10);
		if (KeyGet() == KEY_Y) reset_to_boot_loader();
	}
}

void cb() {
	while (pwm.availableForWrite()) {
		pwm.write(*p++);
		count += 2;
		if (count >= sizeof(out_raw)) {
			count = 0;
			p = start;
		}
	}
}

// Setup function to initialize the system and display
void setup() {
	// Initialize serial communication
	Serial.begin(115200);
	delay(100);
	Serial.println("Test PWM audio application starting...");

	// Initialize the device and display
	device_init();
	DrawClear();
	SelFont8x8();
	DrawText("PWMAudio library test", WIDTH / 2 - (10 * 8), HEIGHT / 2 - 4, COL_WHITE);
	DispUpdate();

	pwm.onTransmit(cb);
	pwm.begin(44100);
}

// Main loop function
void loop() {
	ch = KeyGet();
	if (ch == KEY_Y)
		reset_to_boot_loader();
}

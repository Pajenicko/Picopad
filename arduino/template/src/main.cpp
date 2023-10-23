#include "Arduino.h"
#include "picopad.h"

int ch;

// Function to delay for a specified number of milliseconds
// Additionally, it checks for a key press every 10 milliseconds.
// If the Y key is pressed, the system resets to the bootloader.
void wait(uint16_t ms) {
	for (uint16_t i = 0; i < ms / 10; i++) {
		delay(10);
		if (KeyGet() == KEY_Y) reset_to_boot_loader();
	}
}

// Setup function to initialize the system and display
void setup() {
	// Initialize serial communication
	Serial.begin(115200);
	delay(100);
	Serial.println("Application starting...");

	// Initialize the device and display
	device_init();
	DrawClear();
	DispUpdate();
	SelFont8x8();
}

// Main loop function
void loop() {
	// Check for key press
	ch = KeyGet();

	// Clear display and draw GL5516 image
	DrawClear();

	// Set font and size
	pDrawFont = FontBold8x8;
	DrawFontHeight = 8;
	DrawText("Hello world!", (WIDTH / 2) - (12 * 8 / 2), HEIGHT / 2, COL_WHITE);

	// Update the display
	DispUpdate();

	// Delay for 100 milliseconds
	wait(100);
}

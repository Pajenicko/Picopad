#include "Arduino.h"
#include "picopad.h"
#include "images.h"
#include "hcsr04.h"

HCSR04 sensor(1, 0);

// Variable to hold the distance reading from the sensor
float distance;
// Array to hold the formatted distance as a string
char distanceText[20];

char ch;

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
	Serial.println("HCSR04 sensor application starting...");

	// Initialize the device and display
	device_init();
	DrawClear();
	DispUpdate();

	// Set the font to bold, height 16
	pDrawFont = FontBoldB8x16;
	DrawFontHeight = 16;
}

// Main loop function
void loop() {
	// Check for key press
	ch = KeyGet();

	// Clear the display
	DrawClear();
	// Draw sensor image on the display
	DrawImgRle(Hcsr04Img_RLE, Hcsr04Img_Pal, 0, 0, 320, 240);

	// Draw the connected icon on the display
	DrawImgRle(ConnectedImg_RLE, ConnectedImg_Pal, 284, 3, 30, 30);

	// Read the distance from the sensor
	distance = sensor.read();
	// Delay for 100 milliseconds
	wait(100);

	// If the distance reading is invalid or out of range, display ----.- CM
	if (distance <= 0 || distance >= 1200) {
		snprintf(distanceText, sizeof(distanceText), "%s CM", "----.-");
	}
		// Otherwise, display the distance reading in CM
	else {
		snprintf(distanceText, sizeof(distanceText), "%0.1f CM", distance);
	}

	// Draw the distance text on the display
	DrawText2(distanceText, 105, 120, COL_WHITE);

	// Update the display
	DispUpdate();

	// Delay for 1 second
	wait(1000);
}

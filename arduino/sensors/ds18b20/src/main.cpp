#include "Arduino.h"
#include "picopad.h"
#include "images.h"
#include <microDS18B20.h>

// Defines the GPIO pin for the DS18B20 temperature sensor
#define DS18B20_GPIO_PIN 26
// Defines a temperature correction factor
#define TEMP_CORRECTION (-0.7f)

// Create a DS18B20 sensor object
MicroDS18B20<DS18B20_GPIO_PIN> sensor;

// Array to store the address of the DS18B20 sensor
uint8_t address[8];

// String to store the sensor address in hexadecimal format
char hexString[17];

// Strings to display the sensor's address and temperature
char addressText[40];
char temperatureText[10];

// Variable to indicate if the sensor is connected
bool connected = false;

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
	Serial.println("DS18B20 sensor application starting...");

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

	// Clears the display and sets the background image
	DrawClear();
	DrawImgRle(Ds18B20Img_RLE, Ds18B20Img_Pal, 0, 0, 320, 240);

	// Reads the ROM address of the DS18B20 temperature sensor
	connected = sensor.readAddress(address);
	for (int i = 0; i < 8; i++) {
		snprintf(hexString + i * 2, 3, "%02X", address[i]);
	}
	snprintf(addressText, sizeof(addressText), "Address: 0x%s", hexString);
	wait(100);

	// Check if the sensor is connected
	if (connected) {
		// Display a connected icon
		DrawImgRle(ConnectedImg_RLE, ConnectedImg_Pal, 284, 3, 30, 30);

		// Fetch the temperature reading and apply the correction factor
		float temperature = sensor.getTemp() + TEMP_CORRECTION;

		// Convert temperature to a string
		snprintf(temperatureText, sizeof(temperatureText), "%3.1f`C", temperature);

		// Display the temperature and sensor address
		pDrawFont = FontBoldB8x16;
		DrawFontHeight = 16;
		DrawText2(temperatureText, 130, 80, COL_WHITE);

		pDrawFont = FontBold8x8;
		DrawFontHeight = 8;
		DrawText(addressText, WIDTH / 2 - (strlen(addressText) * 8) / 2, 175, COL_WHITE);

		// Initiate a new temperature reading for the next cycle
		sensor.requestTemp();
	} else {
		// Display a disconnected icon and message if the sensor is not connected
		DrawImgRle(DconnectedImg_RLE, DconnectedImg_Pal, 284, 8, 30, 30);
		DrawRect(12, 45, 200, HEIGHT - 12, COL_BLACK);
		const char *d = "DISCONNECTED";
		DrawText2(d, (HEIGHT / 2) - (strlen(d) * 8) / 2, (WIDTH / 2) - (strlen(d) * 8) / 2, COL_RED);
	}

	// Update the display
	DispUpdate();

	// Delay for 1 second
	wait(1000);
}

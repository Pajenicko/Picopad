#include "Arduino.h"
#include "picopad.h"
#include "images.h"

// Constants for ADC reading and lux calculation
#define KNOWN_RESISTOR 1000
#define LUX_CONVERSION_CONSTANT 29634400
#define LDR_LUX_POWER_VALUE 1.6689
#define PICO_MAX_ADC_READING 4095

// GL5516 LDR (Light Dependent Resistor) specific constants
#define GL5516_PIN 26
#define GL5516_ADC 0

float resistanceRatio, ldrResistance, lightIntensityLux;
int rawADCValue, ch;
char rawText[8];
char luxText[10];

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
	Serial.println("GL5516 sensor application starting...");

	// Initialize the device and display
	device_init();
	DrawClear();
	DispUpdate();
	SelFont8x8();

	// Initialize ADC and GL5516 GPIO
	ADC_Init();
	ADC_PinInit(GL5516_PIN);
}

// Main loop function
void loop() {
	// Check for key press
	ch = KeyGet();

	// Switch ADC to GL5516 input
	ADC_Mux(GL5516_ADC);

	// Clear display and draw GL5516 image
	DrawClear();
	DrawImgRle(Gl5516Img_RLE, Gl5516Img_Pal, 0, 0, 320, 240);

	// Set font and size
	pDrawFont = FontBold8x8;
	DrawFontHeight = 8;

	// Read ADC value
	rawADCValue = ADC_Single();

	// Avoid division by zero by capping the raw ADC reading
	if (rawADCValue > 4095)
		rawADCValue = 4095;

	// Calculate resistance ratio based on raw ADC value
	resistanceRatio = (PICO_MAX_ADC_READING / (float) rawADCValue) - 1;

	// Calculate the actual resistance of the LDR
	ldrResistance = KNOWN_RESISTOR * resistanceRatio;

	// Calculate the light intensity in Lux
	lightIntensityLux = LUX_CONVERSION_CONSTANT / (float) pow(ldrResistance, LDR_LUX_POWER_VALUE);

	// Calculate positions for text display
	uint8_t y = 155;
	uint8_t lx = WIDTH / 4;

	// Format and display light intensity and raw ADC value
	snprintf(luxText, sizeof(luxText), "%0.1f", lightIntensityLux);
	DrawText2(luxText, lx - static_cast<int>(strlen(luxText) * 16) / 2, y, COL_WHITE);
	DrawText("LUX", lx - (3 * 8) / 2, y + 25, COL_WHITE);

	snprintf(rawText, sizeof(rawText), "%d", rawADCValue);
	DrawText2(rawText, (lx * 3) - static_cast<int>(strlen(rawText) * 16) / 2, y, COL_WHITE);
	DrawText("RAW", (lx * 3) - (3 * 8) / 2, y + 25, COL_WHITE);

	// Update the display
	DispUpdate();

	// Delay for 100 milliseconds
	wait(100);
}

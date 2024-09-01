// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../img/images.cpp"
#include "../img/lux_alt.cpp"

// Constants for ADC reading and lux calculation
#define KNOWN_RESISTOR 1000
#define LUX_CONVERSION_CONSTANT 29634400
#define LDR_LUX_POWER_VALUE 1.6689
#define PICO_MAX_ADC_READING 4095

// GL5516 LDR (Light Dependent Resistor) specific constants
#define GL5516_PIN 26
#define GL5516_ADC 0

// Add a flag to keep track of the current image being displayed
enum ImageMode {
		IMAGE_GL5516,
		IMAGE_LUX
};

ImageMode currentImageMode = IMAGE_GL5516;

void displayLuxImage() {
	// Clear the display with black color
	DrawClear();

	// Display lux.h
	DrawImgRle(LuxAltImg_RLE, LuxAltImg_Pal, 0, 0, 320, 240);

	// Updates the display with the drawn elements
	DispUpdate();
}

int main() {
	float resistanceRatio, ldrResistance, lightIntensityLux;
	int rawADCValue;
	char rawText[8];
	char luxText[10];

	// Initialize ADC and GL5516 GPIO
	ADC_Init();
	ADC_PinInit(GL5516_PIN);

	// Draw the original GL5516 image before entering the main loop
	DrawClear();
	DrawImgRle(Gl5516Img_RLE, Gl5516Img_Pal, 0, 0, 320, 240);
	DispUpdate();

	// Set font and size for the measured values text
	pDrawFont = FontBold8x8;
	DrawFontHeight = 8;

	// Calculate positions for text display
	uint8_t y = 155;
	uint8_t lx = WIDTH / 4;
	char key;

	do {
		// Check for key press
		key = KeyGet();

		// If X key is pressed (value 4)
		if (key == KEY_X) {
			// Toggle between displaying lux image and original image
			if (currentImageMode == IMAGE_GL5516) {
				// Display the lux image
				displayLuxImage();
				currentImageMode = IMAGE_LUX;
			} else {
				// Display the original GL5516 image
				DrawClear();
				DrawImgRle(Gl5516Img_RLE, Gl5516Img_Pal, 0, 0, 320, 240);
				DispUpdate();
				currentImageMode = IMAGE_GL5516;
			}

			// Wait for a short moment to avoid registering multiple key presses
			sleep_ms(500);
		}

		// If the lux image is displayed, and we should show the measured values
		if (currentImageMode == IMAGE_GL5516) {
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

			// Format and display light intensity and raw ADC value as text
			snprintf(luxText, sizeof(luxText), "%0.1f", lightIntensityLux);
			snprintf(rawText, sizeof(rawText), "%d", rawADCValue);

			// Clear display and draw GL5516 image
			DrawClear();
			DrawImgRle(Gl5516Img_RLE, Gl5516Img_Pal, 0, 0, 320, 240);

			// Display the measured values
			DrawText2(rawText, (lx * 3) - static_cast<int>(strlen(rawText) * 16) / 2, y, COL_WHITE);
			DrawText("RAW", (lx * 3) - (3 * 8) / 2, y + 25, COL_WHITE);

			DrawText2(luxText, lx - static_cast<int>(strlen(luxText) * 16) / 2, y, COL_WHITE);
			DrawText("LUX", lx - (3 * 8) / 2, y + 25, COL_WHITE);

			// Update the display
			DispUpdate();
		}
		// Wait for a short moment to avoid registering multiple key presses
		WaitMs(100);

	} while (key != KEY_Y);

#if USE_SCREENSHOT		// use screen shots
	ScreenShot();
#endif
	ResetToBootLoader();
}


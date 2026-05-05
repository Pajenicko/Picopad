/*
 * Original code from: https://www.hackster.io/brzi/google-chrome-dinosaur-game-on-3-4-tft-c8ad88
 *
 * Display configuration - If you want to use an alternative graphic or TFT driver library, change the following
 * defines to 0 in the picopad.h header - lib/picopad/include/picopad.h
 *
 * Use ST7789 driver. Set to 0 to disable.
 *
 * #ifndef USE_ST7789
 * #define USE_ST7789    0
 * #endif
 *
 * Use DRAWTFT driver. Set to 0 to disable.
 *
 * #ifndef USE_DRAWTFT
 * #define USE_DRAWTFT  0
 * #endif
 */
#include "Arduino.h"
#include <Adafruit_GFX.h>    // Core graphics library
#include <Adafruit_ST7789.h> // Hardware-specific library for ST7789
#include <SPI.h>
#include "picopad.h"
#include <DinoGame.h>

// #define USE_NOINTERNET

#ifdef USE_NOINTERNET

#include "no_internet.h"

#endif

#define TFT_BLK       DISP_BLK_PIN
#define TFT_DC        DISP_DC_PIN
#define TFT_SCLK      DISP_SCK_PIN
#define TFT_MOSI      DIDP_MOSI_PIN
#define TFT_RST       DISP_RES_PIN
#define TFT_CS        DISP_CS_PIN

Adafruit_ST7789 tft = Adafruit_ST7789(TFT_CS, TFT_DC, DISP_RES_PIN);
DinoGame game(tft);

// Function to delay for a specified number of milliseconds
// Additionally, it checks for a key press every 10 milliseconds.
// If the Y key is pressed, the system resets to the bootloader.
void wait(uint16_t ms) {
	for (uint16_t i = 0; i < ms / 10; i++) {
		sleep_ms(10);
		if (KeyGet() == KEY_Y) reset_to_boot_loader();
	}
}

void setup(void) {
	// Initialize serial communication
	Serial.begin(115200);
	delay(100);
	Serial.println("Test Adafruit GFX application starting...");

	// Initialize the device and display
	device_init();

	tft.init(240, 320, SPI_MODE2);
	tft.setRotation(3);
	tft.setSPISpeed(62500000);

	tft.fillScreen(ST77XX_BLACK);
	delay(100);
	pinMode(TFT_BLK, OUTPUT);
	digitalWrite(TFT_BLK, HIGH); // Backlight on

	Serial.println(F("Initialized"));
	game.newGame();
#ifdef USE_NOINTERNET
	tft.drawRGBBitmap(0, 131, no_internet, 320, 109);
#endif
}

char ch, c;

void loop() {
	c = Serial.read();
	if (c >= '0' && c <= '9') game.setSpeedModifier(c - '0');

	ch = KeyGet();
	switch (ch) {
		case KEY_UP:
			game.jump();
			break;
		case KEY_DOWN:
			game.duck();
			break;
		case KEY_Y:
			reset_to_boot_loader();
			break;
		default:
			game.stand();
	}

	while (game.isGameOver()) {
		ch = KeyGet();
		if (ch == KEY_Y)
			reset_to_boot_loader();
		if (ch == KEY_A) {
			game.newGame();
#ifdef USE_NOINTERNET
			tft.drawRGBBitmap(0, 131, no_internet, 320, 109);
#endif
			break;
		}
	}
	game.loop();
}


// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************
#include "Arduino.h"
#include "include.h"

char ch;

// Setup function to initialize the system and display
void setup() {
	// Initialize serial communication
	Serial.begin(115200);
	delay(100);
	Serial.println("PACMAN game starting...");

	// Initialize the device and display
	device_init();
	DrawClear();
	LastTime = Time();
	MaxScore = 0;
}

// loop with open screen
void loop() {
	// draw title
	DrawClear();
	SelFont8x16();
	DrawText2("PacMan", (WIDTH - 6 * 16) / 2, 0, COL_YELLOW);

#define MENUX 10
#define MENUY 60
#define MENUDY 16
	DrawText("Game control:", MENUX + 16, MENUY + 0 * MENUDY, COL_GREEN);
	DrawText("arrows .......... Move", MENUX, MENUY + 1 * MENUDY, COL_WHITE);
	DrawText("A ............... Pause", MENUX, MENUY + 2 * MENUDY, COL_WHITE);
	DrawText("Y ............... Quit the game", MENUX, MENUY + 3 * MENUDY, COL_WHITE);
	DrawText("Press key 'A' to start the game", MENUX + 16, MENUY + 4 * MENUDY, COL_GREEN);

	DispUpdate();

	do ch = KeyGet(); while (ch == NOKEY);
	if (ch == KEY_Y) reset_to_boot_loader();
	if (ch == KEY_A) OpenGame();
}

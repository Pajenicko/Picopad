#include "Arduino.h"
#include "picopad.h"
#include "images.h"
#include "scd4x.h"

// Connect to GPIO0 SDA, GPIO1 SCL
auto SCD41 = SCD4x(SCD4x_SENSOR_SCD41);

char ch;
bool connected;
char address[20];
char temperature[8];
char humidity[8];
char co2Text[8];
int normalizedCO2;
uint16_t gaugeColor;

// This function is responsible for waiting a specific amount of time (ms).
// Additionally, it checks every 10 milliseconds to see if the 'Y' key is pressed,
// if it is, it triggers a reset to the bootloader.
void wait(uint16_t ms) {
	for (uint16_t i = 0; i < ms / 10; i++) {
		delay(10);
		if (KeyGet() == KEY_Y) reset_to_boot_loader();
	}
}

void DrawGauge(int x0, int y0, int r_outer, int r_inner, int percentage, uint16_t gauge_col, uint16_t fill_col) {
	float angle;
	float radian;
	float x, y;
	float pi = 3.14159;
	int filledToAngle = percentage * 3.6; // convert percentage to degrees
	int gap = 4; // adjust this to increase or decrease the gap

	// draw outer circle
	for (angle = 0; angle < 360; angle += 0.01) {
		radian = (angle - 90) * (pi / 180); // shift by -90 degrees to start at top
		x = x0 + r_outer * cos(radian);
		y = y0 + r_outer * sin(radian);
		DrawPoint(x, y, gauge_col);
	}

	// draw inner circle
	for (angle = 0; angle < 360; angle += 0.01) {
		radian = (angle - 90) * (pi / 180); // shift by -90 degrees to start at top
		x = x0 + r_inner * cos(radian);
		y = y0 + r_inner * sin(radian);
		DrawPoint(x, y, gauge_col);
	}

	// fill between circles
	for (angle = 0; angle < filledToAngle; angle += 0.01) {
		radian = (angle - 90) * (pi / 180); // shift by -90 degrees to start at top

		for (int r = r_inner + gap; r <= r_outer - gap; r++) {
			int x_fill = x0 + r * cos(radian);
			int y_fill = y0 + r * sin(radian);
			DrawPoint(x_fill, y_fill, fill_col);
		}
	}
}

// Setup function to initialize the system and display
void setup() {
	// Initialize serial communication
	Serial.begin(115200);
	delay(100);
	Serial.println("SCD41 sensor application starting...");

	// Initialize the device and display
	device_init();
	DrawClear();
	DrawImgRle(Scd41Img_RLE, Scd41Img_Pal, 0, 0, 320, 240);
	const char *d = "CONNECTING";
	DrawText2(d, (HEIGHT / 2) - (strlen(d) * 8) / 2, (WIDTH / 2) - (strlen(d) * 8) / 2, COL_YELLOW);
	DispUpdate();
	KeyFlush();

	connected = SCD41.begin(false, true);
	SCD41.startLowPowerPeriodicMeasurement();
	delay(100);
}

// Main loop function
void loop() {
	if (connected) {
		DrawClear();
		DrawImgRle(Scd41Img_RLE, Scd41Img_Pal, 0, 0, 320, 240);
		DrawImgRle(ConnectedImg_RLE, ConnectedImg_Pal, 284, 8, 30, 30);

		// Prepares text to display the address.
		snprintf(address, sizeof(address), "Address: 0x%x", SCD4x_ADDRESS);

		SelFont8x8();
		// Draws the address to the display.
		DrawText(address, 112, 19, COL_WHITE);

		ch = NOKEY;
		do {
			ch = KeyGet();
			delay(1);
		} while (!SCD41.readMeasurement() && ch == NOKEY);

		if (ch == KEY_Y) reset_to_boot_loader();

		int CO2 = SCD41.getCO2();
		snprintf(temperature, sizeof(temperature), "%.1f`C", SCD41.getTemperature());
		snprintf(humidity, sizeof(humidity), "%.1f%%", SCD41.getHumidity());

		if (CO2 >= 1500) {
			normalizedCO2 = 100;
		} else {
			normalizedCO2 = (int) ((CO2 / 1500.0) * 100.0);
		}

		if (CO2 < 600) {
			gaugeColor = 0x07E0; // Green
		} else if (CO2 < 1000) {
			gaugeColor = 0xFFE0; // Light yellow
		} else if (CO2 < 1500) {
			gaugeColor = 0xFD20; // Orange
		} else {
			gaugeColor = 0xF800; // Red
		}

		DrawGauge(160, 120, 60, 45, normalizedCO2, COL_WHITE, gaugeColor);

		snprintf(co2Text, sizeof(co2Text), "%u", CO2);

		pDrawFont = FontBold8x8;
		DrawFontHeight = 8;
		DrawText2(co2Text, 170 - static_cast<int>((strlen(co2Text) + 1) * 8), 120 - 10, COL_WHITE);
		DrawText("ppm", 170 - 20, 120 + 15, COL_WHITE);

		DrawText(temperature, 43 - static_cast<int>((strlen(temperature) * 8) / 2), 160, COL_WHITE);

		DrawText(humidity, 278 - static_cast<int>((strlen(humidity) * 8) / 2), 160, COL_WHITE);

		DispUpdate();
	} else {
		DrawImgRle(DconnectedImg_RLE, DconnectedImg_Pal, 284, 8, 30, 30);
		DrawRect(12, 45, 320, HEIGHT - 80, COL_BLACK);
		const char *d = "DISCONNECTED";
		DrawText2(d, (HEIGHT / 2) - (strlen(d) * 8) / 2, (WIDTH / 2) - (strlen(d) * 8) / 2, COL_RED);
		DispUpdate();
		do {} while (KeyGet() == NOKEY);
		reset_to_boot_loader();
	}

	// redraw display
	DispUpdate();

	// Delay for 100 ms
	wait(100);

}

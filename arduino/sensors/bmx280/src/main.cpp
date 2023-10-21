#include "Arduino.h"
#include "picopad.h"
#include "images.h"
#include "bme280.h"

// Connect to GPIO0 SDA, GPIO1 SCL
BME280 sensor = BME280();

char ch;
bool connected;
char chipId[20];
char address[20];
bool lastConnected = true;

// This function is responsible for waiting a specific amount of time (ms).
// Additionally, it checks every 10 milliseconds to see if the 'Y' key is pressed,
// if it is, it triggers a reset to the bootloader.
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
	Serial.println("BM(E/P)280 sensor application starting...");

	// Initialize the device and display
	device_init();
	DrawClear();
	DispUpdate();

	KeyFlush();

	connected = sensor.begin(BMX280_ADDRESS, BMP280_CHIPID);
	lastConnected = true;
	delay(100);
}

// Main loop function
void loop() {
	// Check for key press
	ch = KeyGet();
	DrawClear();
	DrawImgRle(SensorImg_RLE, SensorImg_Pal, 0, 0, 320, 240);

	if (!lastConnected && connected) {
		connected = sensor.begin();
		wait(100);
	}

	snprintf(chipId, sizeof(chipId), "ChipID: 0x%x", sensor.sensorID());
	snprintf(address, sizeof(address), "A: 0x%x", BMX280_ADDRESS);

	SelFont8x8();
	DrawText(chipId, 112, 19, COL_WHITE);
	DrawText(address, 112 + (strlen(chipId) * 8) + 8, 19, COL_WHITE);

	pDrawFont = FontBold8x8; // font 8x8
	DrawFontHeight = 8; // font height

	if (connected) {

		char temperature[8];
		snprintf(temperature, sizeof(temperature), "%.1f`C", sensor.readTemperature());

		char humidity[8];
		snprintf(humidity, sizeof(humidity), "%.1f%%", sensor.readHumidity());

		float pressureValue = sensor.readPressure() / 100.0f;
		char pressure[11];
		snprintf(pressure, sizeof(pressure), "%.1f", pressureValue);

		float altitudeValue = sensor.readAltitude();
		char altitude[20];
		snprintf(altitude, sizeof(altitude), "%.0f m", altitudeValue);

		char sealevel[20];
		snprintf(sealevel, sizeof(sealevel), "%.0f hPa", sensor.seaLevelForAltitude(altitudeValue, pressureValue));

		char waterBoilingPoint[20];
		snprintf(waterBoilingPoint, sizeof(waterBoilingPoint), "%.1f`C", sensor.waterBoilingPoint(pressureValue));

		DrawImgRle(ConnectedImg_RLE, ConnectedImg_Pal, 284, 3, 30, 30);

		DrawText2(temperature, 80, 60, COL_WHITE);
		DrawText2(humidity, 80, 118, COL_WHITE);
		DrawText2(pressure, 80, 178, COL_WHITE);
		DrawText2("hPa", 80 + (strlen(pressure) * 16) + 4, 178, COL_WHITE);

		uint8_t ay = 60;
		uint8_t dy = 15;
		DrawText("Altitude", 260 - (strlen("Altitude") * 8) / 2, ay, COL_WHITE);
		DrawText(altitude, 260 - (strlen(altitude) * 8) / 2, ay + dy, COL_WHITE);

		DrawText("Sea Level", 260 - (strlen("Sea Level") * 8) / 2, ay + 3 * dy, COL_WHITE);
		DrawText(sealevel, 260 - (strlen(sealevel) * 8) / 2, ay + 4 * dy, COL_WHITE);

		DrawText("WBDP", 260 - (strlen("WBDP") * 8) / 2, ay + 6 * dy, COL_WHITE);
		DrawText(waterBoilingPoint, 260 - (strlen(waterBoilingPoint) * 8) / 2, ay + 7 * dy, COL_WHITE);

	} else {
		DrawImgRle(DconnectedImg_RLE, DconnectedImg_Pal, 284, 8, 30, 30);
		DrawRect(12, 45, 80, HEIGHT - 12, COL_BLACK);
		const char *d = "DISCONNECTED";
		DrawText2(d, (HEIGHT / 2) - (strlen(d) * 8) / 2, (WIDTH / 2) - (strlen(d) * 8) / 2, COL_RED);
	}

	// redraw display
	DispUpdate();

	// Delay for 100 ms
	wait(100);

	lastConnected = connected;
	connected = sensor.readSensorId();
}

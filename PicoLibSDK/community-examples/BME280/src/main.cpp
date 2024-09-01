// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../img/images.cpp"
#include "bme280.h"

// BME280
#define SENSOR_CHIP_ID BME280_CHIPID
// BMP280
//#define SENSOR_CHIP_ID BMP280_CHIPID

int main() {
    I2C_Init(0, 400000);
    GPIO_Fnc(0, GPIO_FNC_I2C);
    GPIO_Fnc(1, GPIO_FNC_I2C);
    GPIO_PullUp(0);
    GPIO_PullUp(1);
    I2C_Enable(0);

    auto sensor = BME280(0);
    bool connected = sensor.begin(BMX280_ADDRESS, SENSOR_CHIP_ID);
    bool lastConnected = true;
    WaitMs(100);

    pText txt;
    TextInit(&txt);

    do {
        DrawClear();

        DrawImgRle(SensorImg_RLE, SensorImg_Pal, 0, 0, 320, 240);

        if (!lastConnected && connected) {
            connected = sensor.begin();
            WaitMs(100);
        }

        SelFont8x8();

        TextPrint(&txt, "ChipID: 0x%x", sensor.sensorID());
        DrawText(TextPtr(&txt), 112, 19, COL_WHITE);
        int x = 112 + (TextLen(&txt) * 8) + 8;

        TextPrint(&txt, "A: 0x%x", BMX280_ADDRESS);
        DrawText(TextPtr(&txt), x, 19, COL_WHITE);

        pDrawFont = FontBold8x8; // font 8x8
        DrawFontHeight = 8; // font height

        if (connected) {

            DrawImgRle(ConnectedImg_RLE, ConnectedImg_Pal, 284, 3, 30, 30);

            TextPrint(&txt, "%.1f`C", sensor.readTemperature());
            DrawText2(TextPtr(&txt), 80, 60, COL_WHITE);

            TextPrint(&txt, "%.1f%%", sensor.readHumidity());
            DrawText2(TextPtr(&txt), 80, 118, COL_WHITE);

            float pressureValue = sensor.readPressure() / 100.0f;
            TextPrint(&txt, "%.1f", pressureValue);
            DrawText2(TextPtr(&txt), 80, 178, COL_WHITE);
            DrawText2("hPa", 80 + (TextLen(&txt) * 16) + 4, 178, COL_WHITE);

            u8 ay = 60;
            u8 dy = 15;

            float altitudeValue = sensor.readAltitude();
            TextPrint(&txt, "%.1f m", altitudeValue);
            DrawText("Altitude", 260 - (strlen("Altitude") * 8) / 2, ay, COL_WHITE);
            DrawText(TextPtr(&txt), 260 - (TextLen(&txt) * 8) / 2, ay + dy, COL_WHITE);

            TextPrint(&txt, "%.1f hPa", sensor.seaLevelForAltitude(altitudeValue, pressureValue));
            DrawText("Sea Level", 260 - (strlen("Sea Level") * 8) / 2, ay + 3 * dy, COL_WHITE);
            DrawText(TextPtr(&txt), 260 - (TextLen(&txt) * 8) / 2, ay + 4 * dy, COL_WHITE);

            TextPrint(&txt, "%.1f`C", sensor.waterBoilingPoint(pressureValue));
            DrawText("WBDP", 260 - (strlen("WBDP") * 8) / 2, ay + 6 * dy, COL_WHITE);
            DrawText(TextPtr(&txt), 260 - (TextLen(&txt) * 8) / 2, ay + 7 * dy, COL_WHITE);

        } else {
            DrawImgRle(DconnectedImg_RLE, DconnectedImg_Pal, 284, 8, 30, 30);
            DrawRect(12, 45, 80, HEIGHT - 12, COL_BLACK);
            const char * d = "DISCONNECTED";
            DrawText2(d, (HEIGHT / 2) - (strlen(d) * 8 ) / 2, (WIDTH / 2) - (strlen(d) * 8 ) / 2, COL_RED);
        }

        // redraw display
        DispUpdate();

        WaitMs(100);

        lastConnected = connected;
        connected = sensor.readSensorId(SENSOR_CHIP_ID);
    } while (KeyGet() == NOKEY);

#if USE_SCREENSHOT		// use screen shots
		ScreenShot();
#endif
    ResetToBootLoader();
}

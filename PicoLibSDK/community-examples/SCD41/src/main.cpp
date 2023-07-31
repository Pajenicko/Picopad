// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "scd4x.h"
#include "../img/images.cpp"

void DrawGauge(int x0, int y0, int r_outer, int r_inner, int percentage, u16 gauge_col, u16 fill_col) {
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

int main() {

    DrawClear();
    KeyFlush();
    DrawImgRle(Scd41Img_RLE, Scd41Img_Pal, 0, 0, 320, 240);
    DrawImgRle(DconnectedImg_RLE, DconnectedImg_Pal, 284, 8, 30, 30);
    DrawRect(12, 45, 320, HEIGHT - 80, COL_BLACK);
    DrawText("Connecting...", 112, 19, COL_WHITE);

    DispUpdate();

    auto SCD41 = SCD4x(SCD4x_SENSOR_SCD41);

    I2C_Init(0, 400000);
    GPIO_Fnc(0, GPIO_FNC_I2C);
    GPIO_Fnc(1, GPIO_FNC_I2C);
    GPIO_PullUp(0);
    GPIO_PullUp(1);
    I2C_Enable(0);

    bool connected = SCD41.begin(0, false, true);
    SCD41.startLowPowerPeriodicMeasurement();
    WaitMs(100);

    pText txt;
    TextInit(&txt);

    if (connected) {
        do {
            DrawClear();
            DrawImgRle(Scd41Img_RLE, Scd41Img_Pal, 0, 0, 320, 240);
            DrawImgRle(ConnectedImg_RLE, ConnectedImg_Pal, 284, 8, 30, 30);

            SelFont8x8();

            // Prepares text to display the address.
            TextPrint(&txt, "Address: 0x%x", SCD4x_ADDRESS);
            // Draws the address to the display.
            DrawText(TextPtr(&txt), 112, 19, COL_WHITE);

            char ch = NOKEY;
            do {
                ch = KeyGet();
                WaitMs(1);
            } while (!SCD41.readMeasurement() && ch == NOKEY);

            if (ch == KEY_Y) ResetToBootLoader();

            int CO2 = SCD41.getCO2();
            int normalizedCO2;
            if (CO2 >= 1500) {
                normalizedCO2 = 100;
            } else {
                normalizedCO2 = (int) ((CO2 / 1500.0) * 100.0);
            }

            u16 gaugeColor;
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

            pDrawFont = FontBold8x8;
            DrawFontHeight = 8;

            TextPrint(&txt, "%u", CO2);
            DrawText2(TextPtr(&txt), 170 - static_cast<int>((TextLen(&txt) + 1) * 8), 120 - 10, COL_WHITE);
            DrawText("ppm", 170 - 20, 120 + 15, COL_WHITE);

            TextPrint(&txt, "%.1f`C", SCD41.getTemperature());
            DrawText(TextPtr(&txt), 43 - static_cast<int>((TextLen(&txt) * 8) / 2), 160, COL_WHITE);

            TextPrint(&txt, "%.1f%%", SCD41.getHumidity());
            DrawText(TextPtr(&txt), 278 - static_cast<int>((TextLen(&txt) * 8) / 2), 160, COL_WHITE);

            DispUpdate();

        } while (KeyGet() == NOKEY);
    } else {
        DrawImgRle(DconnectedImg_RLE, DconnectedImg_Pal, 284, 8, 30, 30);
        DrawRect(12, 45, 320, HEIGHT - 80, COL_BLACK);
        const char *d = "DISCONNECTED";
        DrawText2(d, (HEIGHT / 2) - (strlen(d) * 8) / 2, (WIDTH / 2) - (strlen(d) * 8) / 2, COL_RED);
        DispUpdate();
        do {} while (KeyGet() == NOKEY);
        ResetToBootLoader();
    }

    ResetToBootLoader();
}
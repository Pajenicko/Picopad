#include "Arduino.h"
#include "picopad.h"
#include "images.h"
#include "hardware/rtc.h"
#include "SimpleDS3231.hpp"

// Create a SimpleDS3231 RTC object
// Connect C to SCL GPIO1, D to SDA GPIO0
SimpleDS3231 rtc;

char ch;

// Set up variables to store time, date and temperature data
bool connected;

uint8_t hrs, mins, sec, day, mon, dotw, lastMin, temperature;
int year;

// Structure the datetime data into a single datetime_t object
datetime_t rtcDateTime;

// Create a char array to hold the temperature string
char temperatureText[20];

// Center point of the clock's hands
int center_x = WIDTH / 2 - 68;
int center_y = HEIGHT / 2 + 5;

// Define the Point structure for drawing polygons
typedef struct {
		int x, y;
} Point;

#define MAX_INTERSECTIONS 100

// This function is responsible for waiting a specific amount of time (ms).
// Additionally, it checks every 10 milliseconds to see if the 'Y' key is pressed,
// if it is, it triggers a reset to the bootloader.
void wait(uint16_t ms) {
	for (uint16_t i = 0; i < ms / 10; i++) {
		sleep_ms(10);
		if (KeyGet() == KEY_Y) reset_to_boot_loader();
	}
}

// Comparison function used in qsort to sort array of intersections
int compare(const void *a, const void *b) {
	return (*(int *) a - *(int *) b);
}

// This function is used to draw a polygon on the screen. It takes an array of points,
// the number of points in the array, and the color of the polygon as inputs. It first checks
// if there are enough points to form a polygon (minimum 3), then it calculates the maximum and
// minimum y-values to figure out which lines to scan. It then checks which edges of the polygon
// intersect with each scanline and stores these intersections. It then draws horizontal lines
// between each pair of intersections to fill the polygon.
void DrawPolygon(Point points[], int numberOfPoints, u16 col) {
	if (numberOfPoints < 3) {
		return;
	}

	int minY = points[0].y, maxY = points[0].y;
	for (int i = 1; i < numberOfPoints; ++i) {
		if (points[i].y < minY) minY = points[i].y;
		if (points[i].y > maxY) maxY = points[i].y;
	}

	for (int y = minY; y <= maxY; ++y) {
		int intersectXs[MAX_INTERSECTIONS];
		int numIntersects = 0;
		for (int i = 0; i < numberOfPoints; ++i) {
			Point p1 = points[i];
			Point p2 = points[(i + 1) % numberOfPoints];
			if ((p1.y <= y && p2.y > y) || (p2.y <= y && p1.y > y)) { // crossing the scanline
				float x = p1.x + (float) (y - p1.y) / (p2.y - p1.y) * (p2.x - p1.x);
				intersectXs[numIntersects++] = (int) x;
			}
		}
		qsort(intersectXs, numIntersects, sizeof(int), compare);
		for (int i = 0; i + 1 < numIntersects; i += 2) {
			DrawLine(intersectXs[i], y, intersectXs[i + 1], y, col);
		}
	}
}

// This function is a wrapper around DrawPolygon for the specific case of a triangle. It takes
// the coordinates of three points and a color as inputs, constructs an array of points from the
// coordinates, and passes this array to DrawPolygon.
void DrawTriangle(int x0, int y0, int x1, int y1, int x2, int y2, u16 col) {
	Point points[] = {{x0, y0},
										{x1, y1},
										{x2, y2}};
	DrawPolygon(points, 3, col);
}

// This function is used to draw thin lines on the display. It accepts angle, long length, and short length
// as parameters. This function is primarily used for rendering the second hand of the clock.
void draw_hand_thin(float hand_angle, float hand_lenght_long, float hand_legth_short) {

	int xpos, ypos, xpos2, ypos2;

	// calculate starting and ending position of the second hand
	xpos = static_cast<int>(round(center_x + sin(radians(hand_angle)) * hand_lenght_long));
	ypos = static_cast<int>(round(center_y - cos(radians(hand_angle)) * hand_lenght_long));
	xpos2 = static_cast<int>(round(center_x + sin(radians(hand_angle + 180)) * hand_legth_short));
	ypos2 = static_cast<int>(round(center_y - cos(radians(hand_angle + 180)) * hand_legth_short));

	DrawLine(xpos, ypos, xpos2, ypos2, COL_RED); // draw the main line
	DrawFillCircle(xpos2, ypos2, 3, COL_BLACK); // draw small outline white circle
	DrawCircle(xpos2, ypos2, 4, COL_RED); // draw small outline white circle
}

// This function is used to draw bold lines on the display. It accepts angle, long length, short length,
// and dot size as parameters. This function is primarily used for rendering the hour and minute hands of the clock.
void draw_hand_bold(float hand_angle, float hand_lenght_long, float hand_legth_short, float hand_dot_size) {
	int xpos, ypos, xpos2, ypos2, tri_xoff, tri_yoff;

	// calculate positions of the two circles
	xpos = static_cast<int>(round(center_x + sin(radians(hand_angle)) * hand_lenght_long));
	ypos = static_cast<int>(round(center_y - cos(radians(hand_angle)) * hand_lenght_long));
	xpos2 = static_cast<int>(round(center_x + sin(radians(hand_angle)) * hand_legth_short));
	ypos2 = static_cast<int>(round(center_y - cos(radians(hand_angle)) * hand_legth_short));

	tri_xoff = static_cast<int>(round(sin(radians(hand_angle + 90)) * hand_dot_size));
	tri_yoff = static_cast<int>(round(-cos(radians(hand_angle + 90)) * hand_dot_size));

	DrawLine(center_x, center_y, xpos2, ypos2, COL_WHITE); // draw the line from one circle to the center
	DrawFillCircle(xpos, ypos, hand_dot_size, COL_WHITE); // draw filled white circle
	DrawFillCircle(xpos2, ypos2, hand_dot_size, COL_WHITE); // draw filled white circle

	// two filled triangles are used to draw a rotated rectangle between two circles
	DrawTriangle(xpos + tri_xoff, ypos + tri_yoff,
							 xpos - tri_xoff, ypos - tri_yoff,
							 xpos2 + tri_xoff, ypos2 + tri_yoff, COL_WHITE);

	DrawTriangle(xpos2 + tri_xoff, ypos2 + tri_yoff,
							 xpos2 - tri_xoff, ypos2 - tri_yoff,
							 xpos - tri_xoff, ypos - tri_yoff, COL_WHITE);
}

// This function is responsible for drawing the clock dial. It draws the outer circle, the small ticks
// for every minute, larger ticks for every hour, and labels for the 12, 3, 6, and 9 positions.
void draw_dial() {
	float xpos;
	float ypos;
	float xpos2;
	float ypos2;

	DrawCircle(center_x, center_y, 63, COL_WHITE); // draw fullscreen circle

	// draw 60 dots (pixels) around the circle, one for every minute/second
	for (int i = 0; i < 60; i++) { // draw 60 pixels around the circle
		xpos = round(center_x + sin(radians(i * 6)) * 60); // calculate x pos based on angle and radius
		ypos = round(center_y - cos(radians(i * 6)) * 60); // calculate y pos based on angle and radius

		DrawPoint(xpos, ypos, COL_WHITE); // draw white pixel on position xpos and ypos
	}

	// drawing big tickmarks
	for (int i = 0; i < 12; i++) {
		if ((i % 3) != 0) { // only draw tickmarks for some numbers, leave empty space for 12, 3, 6, and 9
			xpos = round(center_x + sin(radians(i * 30)) * 54); // calculate x pos based on angle and radius
			ypos = round(center_y - cos(radians(i * 30)) * 54); // calculate y pos based on angle and radius
			xpos2 = round(center_x + sin(radians(i * 30)) * 46); // calculate x pos based on angle and radius
			ypos2 = round(center_y - cos(radians(i * 30)) * 46); // calculate y pos based on angle and radius

			DrawLine(xpos, ypos, xpos2, ypos2, COL_WHITE); // draw a line for a tickmark
		}
	}

	// draw labels 12, 3, 6 and 9, positions are hardcoded
	SelFont8x8();
	DrawText("12", center_x - 7, center_y - 50, COL_WHITE);
	DrawText("3", center_x + 48, center_y - 3, COL_WHITE);
	DrawText("6", center_x - 3, center_y + 50, COL_WHITE);
	DrawText("9", center_x - 55, center_y - 3, COL_WHITE);
}

// Setup function to initialize the system and display
void setup() {
	// Initialize serial communication
	Serial.begin(115200);
	delay(100);
	Serial.println("DS3231 module application starting...");

	// Initialize the device and display
	device_init();
	DrawClear();
	DispUpdate();

	// Check if the real-time clock (RTC) is running, if not, initialize it
	if (!rtc_running())
		rtc_init();

	// Set initial RTC time and date values, then disable this section (presumably by commenting it out)
//    rtc.set_hou(6, false, false);
//    rtc.set_min(40);
//    rtc.set_day(26);
//    rtc.set_sec(0);
//    rtc.set_mon(7);
//    rtc.set_year(2023);
	// Allow the RTC to update with the newly set values
	delay(100);

	// Get current time and date from RTC
	hrs = rtc.get_hou();
	mins = rtc.get_min();
	lastMin = mins;
	sec = rtc.get_sec();
	day = rtc.get_day();
	dotw = 0;
	mon = rtc.get_mon();
	year = rtc.get_year();
	// Get current temperature from RTC
	temperature = rtc.get_temp();

	rtcDateTime = {
			static_cast<int16_t>(year),
			static_cast<int8_t>(mon),
			static_cast<int8_t>(day),
			static_cast<int8_t>(dotw),
			static_cast<int8_t>(hrs),
			static_cast<int8_t>(mins),
			static_cast<int8_t>(sec)
	};

	// Set the internal RTC time and date based on rtcDateTime
	rtc_set_datetime(&rtcDateTime);
}

// Main loop function
void loop() {
	// Check for key press
	ch = KeyGet();

	// Check if the RTC data is being successfully retrieved
	connected = rtc_get_datetime(&rtcDateTime);
	// Update the time and date variables
	hrs = rtcDateTime.hour;
	mins = rtcDateTime.min;
	sec = rtcDateTime.sec;
	day = rtcDateTime.day;
	mon = rtcDateTime.month;
	// Update the temperature every minute
	if (mins != lastMin) {
		temperature = rtc.get_temp();
		lastMin = mins;
	}

	// Clear the display and draw the clock background
	DrawClear();
	DrawImgRle(ClockImg_RLE, ClockImg_Pal, 0, 0, 320, 240);
	// Draw the clock dial
	draw_dial();

	// Convert the temperature to a string
	snprintf(temperatureText, sizeof(temperatureText), "Temp:%3.1hhu`C", temperature);

	// Draw the clock hands
	draw_hand_bold(hrs * 30 + (mins / 2), 32, 10, 2); // hour hand
	draw_hand_bold(mins * 6, 45, 10, 2); // minute hand
	DrawFillCircle(center_x, center_y, 4, COL_WHITE);
	DrawFillCircle(center_x, center_y, 2, COL_BLACK);
	draw_hand_thin(sec * 6, 56, 24); // second hand

	// Check if the RTC is connected
	if (connected) {
		// If connected, draw the connected image
		DrawImgRle(ConnectedImg_RLE, ConnectedImg_Pal, 284, 3, 30, 30);

		// Repeat the process of drawing the clock hands
		draw_hand_bold(hrs * 30 + (mins / 2), 32, 10, 2); // hour hand
		draw_hand_bold(mins * 6, 45, 10, 2); // minute hand
		DrawFillCircle(center_x, center_y, 4, COL_WHITE);
		DrawFillCircle(center_x, center_y, 2, COL_BLACK);
		draw_hand_thin(sec * 6, 56, 24); // second hand

		// Display the current time, date and temperature on the display
		int num;
		int nx = 165;

		int ny = 63;
		num = hrs > 9 ? hrs / 10 : 0;
		DrawImgPal(NumbersImg + (num * 36), NumbersImg_Pal, nx, ny, 32, 41, 354);
		num = hrs > 9 ? hrs % 10 : hrs;
		DrawImgPal(NumbersImg + (num * 36), NumbersImg_Pal, nx + 32, ny, 32, 41, 354);
		nx += 72;
		num = mins > 9 ? mins / 10 : 0;
		DrawImgPal(NumbersImg + (num * 36), NumbersImg_Pal, nx, ny, 32, 41, 354);
		num = mins > 9 ? mins % 10 : mins;
		DrawImgPal(NumbersImg + (num * 36), NumbersImg_Pal, nx + 32, ny, 32, 41, 354);

		nx = 165;
		ny += 70;
		num = day > 9 ? day / 10 : 0;
		DrawImgPal(NumbersImg + (num * 36), NumbersImg_Pal, nx, ny, 32, 41, 354);
		num = day > 9 ? day % 10 : day;
		DrawImgPal(NumbersImg + (num * 36), NumbersImg_Pal, nx + 32, ny, 32, 41, 354);
		nx += 72;
		num = mon > 9 ? mon / 10 : 0;
		DrawImgPal(NumbersImg + (num * 36), NumbersImg_Pal, nx, ny, 32, 41, 354);
		num = mon > 9 ? mon % 10 : mon;
		DrawImgPal(NumbersImg + (num * 36), NumbersImg_Pal, nx + 32, ny, 32, 41, 354);

		pDrawFont = FontBold8x8;
		DrawFontHeight = 8;
		// Draw the temperature text at the specified location
		DrawText(temperatureText, 30, 215, COL_WHITE);
	} else {
		// If the RTC is not connected, draw the disconnected image and display a disconnected message
		DrawImgRle(DconnectedImg_RLE, DconnectedImg_Pal, 284, 8, 30, 30);
		DrawRect(12, 45, WIDTH, HEIGHT - 35 - 45, COL_BLACK);
		const char *d = "DISCONNECTED";
		DrawText2(d, (HEIGHT / 2) - (strlen(d) * 8) / 2, (WIDTH / 2) - (strlen(d) * 8) / 2, COL_RED);
	}

	// Update the display
	DispUpdate();

	// Delay for 100 ms
	wait(100);
}

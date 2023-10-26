/**
* MIT License
*
* Copyright (c) 2023 Tomas Vecera, tomas@vecera.dev
*
* Portions of this software are derived from the PicoLibSDK:
*   Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz, hardyplotter2@gmail.com
*   Repository: https://github.com/Panda381/PicoLibSDK
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
* documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
* rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
* persons to whom the Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
* Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
* WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
* OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#ifndef NE3_SCOPE_TINY_DRAWTFT_H
#define NE3_SCOPE_TINY_DRAWTFT_H

#define COL_RED    RGBTO16(255,0,0)  // 0xF800
#define COL_WHITE  RGBTO16(255,255,255)  // 0xFFFF
#define COL_GREEN  RGBTO16(0,255,0)  // 0x07E0

auto pDrawFont = FONT; // font 8x16
int DrawFontHeight = FONTH; // font height
int DrawFontWidth = FONTW; // font width (5 to 8)

void DrawPoint(int x, int y, uint16_t col) {
	DispWindow(x, x + 1, y, y + 1);
	DispWriteData(&col, 2);
}

void DrawChar(char chr, int x, int y, uint16_t col) {
	int x0 = x;
	int i, j;

	// prepare pointer to font sample
	const uint8_t *s = &pDrawFont[chr];

	// loop through lines of one character
	for (i = DrawFontHeight; i > 0; i--) {
		// get one font sample
		chr = *s;
		s += 256;

		// loop through pixels of one character line
		x = x0;
		for (j = DrawFontWidth; j > 0; j--) {
			// pixel is set
			if ((chr & 0x80) != 0) DrawPoint(x, y, col);
			x++;
			chr <<= 1;
		}
		y++;
	}
}

void DrawText(const char *text, int x, int y, uint16_t col) {
	uint8_t ch;

	// loop through characters of text
	for (;;) {
		// get next character of the text
		ch = (uint8_t) *text++;
		if (ch == 0) break;

		// draw character
		DrawChar(ch, x, y, col);

		// shift to next character position
		x += DrawFontWidth;
	}
}

#endif //NE3_SCOPE_TINY_DRAWTFT_H

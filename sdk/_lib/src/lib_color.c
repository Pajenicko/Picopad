
// ****************************************************************************
//
//                               Color vector
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_COLOR	// use color vector (lib_color.c, lib_color.h)

#include "../inc/lib_color.h"

// clamp color value to valid range 0..1
void ColorClamp(sColor* col)
{
	col->r = CLAMP01(col->r);
	col->g = CLAMP01(col->g);
	col->b = CLAMP01(col->b);
	col->a = CLAMP01(col->a);
}

// absolute value of color
void ColorAbs(sColor* col)
{
	col->r = ABS(col->r);
	col->g = ABS(col->g);
	col->b = ABS(col->b);
	col->a = ABS(col->a);
}

// convert color to gray value
color_float ColorGetGray(sColor* col)
{
	return (color_float)(0.2126*col->r + 0.7152*col->g + 0.0722*col->b);
}

u8 ColorGetGrayByte(sColor* col)
{
	int v = (int)(ColorGetGray(col)*255+0.5);
	return (u8)CLAMPU8(v);
}

// get linear gray value (average value)
color_float ColorGetLinGray(sColor* col)
{
	return (col->r + col->g + col->b)/3;
}

// decolorize (set to average gray value)
void ColorDecolor(sColor* col)
{
	color_float v = ColorGetGray(col);
	col->r = v;
	col->g = v;
	col->b = v;
}

// transposition between 2 colors (k: 0=src1 .. 1=src2)
void ColorTrans(sColor* dst, const sColor* src1, const sColor* src2, color_float k)
{
	color_float k2 = 1 - k;
	dst->r = src1->r * k2 + src2->r * k;
	dst->g = src1->g * k2 + src2->g * k;
	dst->b = src1->b * k2 + src2->b * k;
	dst->a = src1->a * k2 + src2->a * k;
}

// blend by src alpha (a: 0=dst,...1=src)
void ColorBlend(sColor* dst, const sColor* src)
{
	color_float k = src->a;
	color_float k2 = 1 - k;
	dst->r = dst->r * k2 + src->r * k;
	dst->g = dst->g * k2 + src->g * k;
	dst->b = dst->b * k2 + src->b * k;
	dst->a = dst->a * k2 + src->a * k;
}

// blend by dst alpha (a: 0=src,...1=dst)
void ColorBlendInv(sColor* dst, const sColor* src)
{
	color_float k = dst->a;
	color_float k2 = 1 - k;
	dst->r = dst->r * k + src->r * k2;
	dst->g = dst->g * k + src->g * k2;
	dst->b = dst->b * k + src->b * k2;
	dst->a = dst->a * k + src->a * k2;
}

// resize color interval (from 0..1 to min..max)
void ColorRange(sColor* col, color_float min, color_float max)
{
	color_float d = max - min;
	col->r = col->r * d + min;
	col->g = col->g * d + min;
	col->b = col->b * d + min;
}

// average colors
void ColorAvg(sColor* col, const sColor* src)
{
	col->r = (col->r + src->r)/2;
	col->g = (col->g + src->g)/2;
	col->b = (col->b + src->b)/2;
	col->a = (col->a + src->a)/2;
}

// minimize color
void ColorMin(sColor* col, const sColor* src)
{
	if (src->r < col->r) col->r = src->r;
	if (src->g < col->g) col->g = src->g;
	if (src->b < col->b) col->b = src->b;
	if (src->a < col->a) col->a = src->a;
}

// maximize color
void ColorMax(sColor* col, const sColor* src)
{
	if (src->r > col->r) col->r = src->r;
	if (src->g > col->g) col->g = src->g;
	if (src->b > col->b) col->b = src->b;
	if (src->a > col->a) col->a = src->a;
}

// adjust brightness (0.5 = no change, >0.5 rise, <0.5 lower brightness)
void ColorBright(sColor* col, color_float bright)
{
	if (bright == (color_float)0.5) return;

	if (bright <= (color_float)0.5)
	{
		bright *= 2;
		col->r *= bright;
		col->g *= bright;
		col->b *= bright;
	}
	else
	{
		bright = 2*(1 - bright);
		col->r = 1 - (1 - col->r)*bright;
		col->g = 1 - (1 - col->g)*bright;
		col->b = 1 - (1 - col->b)*bright;
	}
}

// adjust contrast (0.5 = no change)
void ColorContrast(sColor* col, color_float contrast)
{
	contrast = contrast*contrast*4; // 0..4, middle 1
	color_float k = (1 - contrast)/2;
	col->r = col->r*contrast + k;
	col->g = col->g*contrast + k;
	col->b = col->b*contrast + k;
	ColorClamp(col);
}

// adjust brightness level (controls are in range 0..1, 0.5=linear)
void ColorLevel(sColor* col, color_float bright, color_float contrast, color_float gamma)
{
	// prepare control ranges
	contrast = contrast*contrast*4; // 0..4, middle 1
	gamma = (color_float)(1/(gamma*gamma*3+(color_float)0.25)); // 4..1/3.25, middle 1

	// set brightness and contrasst (new=(old-0.5)*contrast+0.5+(brightness-0.5)
	bright -= contrast/2;
	col->r = col->r*contrast + bright;
	col->g = col->g*contrast + bright;
	col->b = col->b*contrast + bright;

	// clamp range
	ColorClamp(col);

	// set gamma
	if (gamma != 1)
	{
		col->r = pow(col->r, gamma);
		col->g = pow(col->g, gamma);
		col->b = pow(col->b, gamma);
	}
}

// convert color to RGB
u32 ColorRGB(sColor* col)
{
	return ColorR(col) | ((u32)ColorG(col) << 8) | ((u32)ColorB(col) << 16);
}

// convert color to RGBA
u32 ColorRGBA(sColor* col)
{
	return ColorR(col) | ((u32)ColorG(col) << 8) | ((u32)ColorB(col) << 16) | ((u32)ColorA(col) << 24);
}

// convert color to BGR
u32 ColorBGR(sColor* col)
{
	return ColorB(col) | ((u32)ColorG(col) << 8) | ((u32)ColorR(col) << 16);
}

// convert color to BGRA
u32 ColorBGRA(sColor* col)
{
	return ColorB(col) | ((u32)ColorG(col) << 8) | ((u32)ColorR(col) << 16) | ((u32)ColorA(col) << 24);
}

// convert color to 16-bit RGB
u16 ColorRGB16(sColor* col)
{
	return (u16)RGBTO16(ColorR(col), ColorG(col), ColorB(col));
}

// convert color to 15-bit RGB
u16 ColorRGB15(sColor* col)
{
	return (u16)RGBTO15(ColorR(col), ColorG(col), ColorB(col));
}

// internal: convert HUE to RGB channel
void ColorHueToRGB(sColor* col, color_float m1, color_float m2, color_float hue, color_float* chan)
{
	if (hue < 0) hue++;
	if (hue >= 1) hue--;

	if ((6*hue) < 1)
		*chan = m1 + (m2 - m1)*hue*6;
	else
		if ((2*hue) < 1)
			*chan = m2;
		else
			if ((3*hue) < 2)
				*chan = m1 + (m2 - m1) * ((color_float)2/3 - hue) * 6;
			else
				*chan = m1;
}

// convert RGB to HSL
void ColorRGBToHSL(sColor* col)
{
	// normalize values
	ColorClamp(col);

	// max and min value
	color_float max = MAX(MAX(col->r,col->g),col->b);
	color_float min = MIN(MIN(col->r,col->g),col->b);

	// prepare HSL
	color_float hue = 0;
	color_float lum = (max + min)/2;
	color_float sat = 0;

	color_float delta = max - min;
	if (ABS(delta)>0.001)
	{
		if (lum < 0.5)
			sat = delta / (max + min);
		else
			sat = delta / (2 - max - min);

		if (col->r >= max)
			hue = (col->g - col->b) / delta;
		else
			if (col->g >= max)
				hue = 2 + (col->b - col->r) / delta;
			else
				hue = 4 + (col->r - col->g) / delta;

		hue /= 6;
		if (hue < 0) hue += 1;
	}

	// store HSL values
	col->r = hue;
	col->g = sat;
	col->b = lum;
}

// convert HSL to RGB
void ColorHSLToRGB(sColor* col)
{
	// normalize values
	ColorClamp(col);

	// load HSL
	color_float hue = col->r;
	color_float sat = col->g;
	color_float lum = col->b;
	color_float m1, m2;

	// gray color
	if (sat <= 0.001)
	{
		col->r = lum;
		col->g = lum;
		col->b = lum;
	}
	else
	{
		if (lum <= 0.5)
			m2 = lum*(1 + sat);
		else
			m2 = lum + sat - lum*sat;

		m1 = 2*lum - m2;

		ColorHueToRGB(col, m1, m2, hue + (color_float)1/3, &col->r);
		ColorHueToRGB(col, m1, m2, hue, &col->g);
		ColorHueToRGB(col, m1, m2, hue - (color_float)1/3, &col->b);
	}
}

// convert RGB to HSV
void ColorRGBToHSV(sColor* col)
{
	// normalize values
	ColorClamp(col);

	// minimum and maximum value
	color_float max = MAX(MAX(col->r,col->g),col->b);
	color_float min = MIN(MIN(col->r,col->g),col->b);

	// black color
	color_float hue = 0;
	color_float sat = 0;
	color_float val = 0;

	// not black
	if (max > 0.001)
	{
		// set value
		val = max;

		// normalize saturation
		color_float chroma = max - min;
		sat = chroma / max;

		// not gray
		if (sat > 0.001)
		{
			// compute hue
			if (col->r >= max)
				hue = (col->g - col->b) / chroma;
			else
				if (col->g >= max)
					hue = 2 + (col->b - col->r) / chroma;
				else
					hue = 4 + (col->r - col->g) / chroma;
			hue /= 6;
			if (hue < 0) hue += 1;
		}
		else
			sat = 0;
	}

	col->r = hue;
	col->g = sat;
	col->b = val;
}

// convert HSV to RGB
void ColorHSVToRGB(sColor* col)
{
	// normalize values
	ColorClamp(col);

	// get HSV values
	color_float hue = col->r*6;
	color_float sat = col->g;
	color_float val = col->b;

	// preset gray color
	col->r = val;
	col->g = val;
	col->b = val;

	// valid color
	if (sat > 0.001)
	{
		// get color region and reminder in region
		int reg = (int)hue; // color region 0..5
		if (reg > 5) reg = 5;
		color_float rem = hue - reg;	// reminder in region

		// temporary coefficients
		color_float p = val*(1-sat);
		color_float q = val*(1-sat*rem);
		color_float t = val*(1-sat*(1-rem));

		// get RGB in region
		switch (reg)
		{
		case 0: col->g = t; col->b = p; break;
		case 1: col->r = q; col->b = p; break;
		case 2: col->r = p; col->b = t; break;
		case 3: col->r = p; col->g = q; break;
		case 4: col->r = t; col->g = p; break;
		default: col->g = p; col->b = q;
		}
	}
}

#endif // USE_COLOR	// use color vector (lib_color.c, lib_color.h)

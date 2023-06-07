
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************
// All graphics and movements are multiply of 4 pixels.

#ifndef _MAIN_H
#define _MAIN_H

// === sounds

// sound format: PCM mono 8-bit 22050Hz
extern const u8 Tone1Snd[739];
extern const u8 Tone2Snd[827];
extern const u8 Tone3Snd[656];
extern const u8 Tone4Snd[754];
extern const u8 ShootSnd[9002];
extern const u8 HitSnd[7846];
extern const u8 CrashSnd[19308];
extern const u8 MotherSnd[3167];

// === sprite images

// format: 4-bit paletted pixel graphics
// image width: 36 pixels
// image height: 56 lines
// image pitch: 18 bytes
extern const u16 SpritesImg_Pal[8] __attribute__ ((aligned(4)));
extern const u8 SpritesImg[1008] __attribute__ ((aligned(4)));
#define SPRITESIMGW	36	// width of image with sprites

// === aliens

#define ALIENW		12	// alien width
#define ALIENH		8	// alien height

#define ALIENNUMX	11	// number of aliens in X direction
#define ALIENNUMY	5	// number of aliens in Y direction
#define ALIENNUM	(ALIENNUMX*ALIENNUMY) // number of aliens (= 55)
#define ALIENSPACEX	4	// space between aliens in X direction
#define ALIENDX		(ALIENW+ALIENSPACEX) // alien delta X coordinate (= 16)
#define ALIENTOTW	(ALIENNUMX*ALIENDX - ALIENSPACEX) // alien total initial widh (= 172)
#define ALIENTOTX	(((WIDTH - ALIENTOTW)/2) & ~3) // alien block initial X coordinate, rounded down to 4 pixels (= 72)

#define ALIENSPACEY	8	// space between aliens in Y direction
#define ALIENDY		(ALIENH+ALIENSPACEY) // alien delta Y coordinate (= 16)
#define ALIENTOTH	(ALIENNUMY*ALIENDY - ALIENSPACEY) // alien total initial height (= 72)
#define ALIENTOTY	40	// alien block initial Y coordinate, must be multiply of 4
#define ALIENMAXY	112	// alien block initial max. Y coordinate, must be multiply of 4
#define ALIENMINX	0	// alien min. X coordinate
#define ALIENMAXX	WIDTH	// alien max. X coordinate

// === enemy missiles

#define MISSILENUM	10	// max. number of missiles
#define MISSILEW	4	// enemy missile width
#define MISSILEH	8	// enemy missile height
#define MISSILE1IMGX	24	// enemy missile 1 image X coordinate
#define MISSILE1IMGY	32	// enemy missile 1 image Y coordinate
#define MISSILE2IMGX	24	// enemy missile 2 image X coordinate
#define MISSILE2IMGY	40	// enemy missile 2 image Y coordinate

#define MISSILEEXPW	8	// enemy missile explosion width
#define MISSILEEXPH	8	// enemy missile explosion height
#define MISSILEEXPIMGX	28	// enemy missile explosion image X coordinate
#define MISSILEEXPIMGY	32	// enemy missile explosion image Y coordinate
#define MISSILEINVIMGX	28	// enemy missile inverted explosion image X coordinate
#define MISSILEINVIMGY	40	// enemy missile inverted explosion image Y coordinate

// === spaceship

#define SHIPW		12	// ship width
#define SHIPH		8	// ship height
#define SHIPIMGX	0	// ship image X coordinate in sprites
#define SHIPIMGY	24	// ship image Y coordinate in sprites
#define SHIPEXPIMGX	24	// ship explosion image X coordinate
#define SHIPEXPIMGY	24	// ship explosion image Y coordinate
#define SHIPY		(HEIGHT-16-8-SHIPH) // ship Y coordinate (= 208, must be multiply of 4)
#define SHIPX		(((WIDTH - SHIPW)/2) & ~3) // ship initial X coordinate (= 152, must be multiply of 4)
#define SHIPDX		16	// delta X of ship lives

// === spaceship shoots

#define SHOOTW		4	// shoot width
#define SHOOTH		8	// shoot height
#define SHOOTIMGX	12	// shoot image X coordinate
#define SHOOTIMGY	24	// shoot image Y coordinate

#define SHOOTEXPW	4	// shoot explosion width
#define SHOOTEXPH	8	// shoot explosion height
#define SHOOTEXPX	16	// shoot explosion image X coordinate
#define SHOOTEXPY	24	// shoot explosion image Y coordinate

#define SHOOTEXP2X	20	// shoot explosion inverted image X coordinate
#define SHOOTEXP2Y	24	// shoot explosion inverted image Y coordinate

// === score

#define LINEY1		20 // line 1 Y coordinate
#define LINEY2		(HEIGHT-20) // line 2 Y coordinate
#define SCOREY		0	// score Y coordinate
#define SCOREX		0	// score X coordinate
#define MAXSCOREX	(WIDTH-15*8)	// max. score X coordinate
#define LEVELY		(HEIGHT-16) // level Y coordinate
#define LEVELX		(WIDTH-9*8) // level X coordinate

// === house

#define HOUSEW		24	// house width
#define HOUSEH		16	// house height
#define HOUSEIMGX	0	// house image X coordinate in sprites
#define HOUSEIMGY	32	// house image Y coordinate in sprites
#define HOUSEY		(SHIPY-8-HOUSEH) // house Y coordinate (= 184, must be multiply of 4)

#define HOUSENUM	4	// number of houses
#define HOUSEDX		(3*ALIENDX) // house delta X coordinate (= 48)
#define HOUSESPACEX	(HOUSEDX - HOUSEW) // space between houses (= 24)
#define HOUSETOTW	(HOUSENUM*HOUSEDX - HOUSESPACEX) // house total width (= 168)
#define HOUSEX		(((WIDTH-HOUSETOTW)/2) & ~3) // house X coordinate (= 76, must be multiply of 4)

//#define HOUSECOL	RGBTO16(255, 128, 0) // house color

// === mothership

#define MOTHERY		24	// alien mothership Y coordinate
#define MOTHERW		16	// alien mothership width
#define MOTHERH		8	// alien mothership height
#define MOTHERIMGX	0	// alien mothership image X coordinate in sprites
#define MOTHERIMGY	48	// alien mothership image Y coordinate in sprites

#define MOTHEREXPIMGX	16	// alien mothership explosion image X coordinate in sprites
#define MOTHEREXPIMGY	48	// alien mothership explosion image Y coordinate in sprites

#define NEXTMOTHER	500	// number of steps to generate new mothership
#define MOTHERCHAN	2	// mothershiop sound channel

#endif // _MAIN_H

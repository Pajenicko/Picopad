
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H


#define FRAMECOL 0	// frame color

// repro image
#define REPROW	132	// repro width
#define REPROH	192	// repro height
#define REPROGAP 40	// gap between boxes
#define REPROY	0	// repro Y
#define REPRO1X 8	// repro 1 X
#define REPRO2X	(REPRO1X+REPROW+REPROGAP) // repro 2 X (= 180, right gap 8)

// membrane
#define MEMBW	68	// membrane width
#define MEMBH	68	// membrane height
#define MEMB1X	33	// membrane 1 X coordinate, relative to repro box
#define MEMB2X	33	// membrane 2 X coordinate, relative to repro box
#define MEMBY	85	// membrane Y coordinate, relative to repro box
#define MEMBOFF	1	// membrane shift offset

// graph
#define GRAPHGAP 48	// horizontal gap
#define GRAPHW	128	// graph width (16 samples by 8 pixels)
#define GRAPHH	48	// graph height (16 rows by 3 lines)
#define GRAPH1X	8	// graph 1 X
#define GRAPH2X 182	// graph 2 X
#define GRAPHY	(REPROY+REPROH)	// graph Y (= 192)

// data
#define SAMPNUM 16	// number of samples
#define SAMPMAX 16	// max. range of samples

// format: compressed 4-bit paletted pixel graphics
// image width: 132 pixels
// image height: 192 lines
// image pitch: 66 bytes
extern const u16 Repro1Img_Pal[16] __attribute__ ((aligned(4)));
extern const u8 Repro1Img[8769] __attribute__ ((aligned(4)));

// format: compressed 4-bit paletted pixel graphics
// image width: 132 pixels
// image height: 192 lines
// image pitch: 66 bytes
extern const u16 Repro2Img_Pal[16] __attribute__ ((aligned(4)));
extern const u8 Repro2Img[8552] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 68 pixels
// image height: 68 lines
// image pitch: 34 bytes
extern const u16 Repro3Img_Pal[16] __attribute__ ((aligned(4)));
extern const u8 Repro3Img[2312] __attribute__ ((aligned(4)));

// sound format: PCM mono 8-bit 22050Hz
extern const u8 TestSnd[154512];

#define SNDLEN sizeof(TestSnd) // sound length
#define BEATNUM	16	// number of sound beats
#define BEATINT	(SNDLEN/BEATNUM) // beat interval (= 9657)
#define BEATON (BEATINT/8) // beat on state

#endif // _MAIN_H

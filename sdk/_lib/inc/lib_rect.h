
// ****************************************************************************
//
//                                 Rectangle
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#if USE_RECT	// use Rectangle (lib_rect.c, lib_rect.h)

#ifndef _RECT_H
#define _RECT_H

#ifdef __cplusplus
extern "C" {
#endif

// rectangle
typedef struct {
	int	x;	// left
	int	y;	// top
	int	w;	// width
	int	h;	// height
} sRect;

// set rectangle (with size)
void RectSet(sRect* r, int x, int y, int w, int h);

// set rectangle (with coordinates)
void RectSet2(sRect* r, int x, int y, int x2, int y2);

// clear rectangle
void RectClear(sRect* r);

// move left top corner (preserve size)
void RectMove(sRect* r, int x, int y);

// move right bottom corner (change size)
void RectMove2(sRect* r, int x2, int y2);

// shift relative (move top corner, preserve size)
void RectShift(sRect* r, int dx, int dy);

// set size (preserve left top corner)
void RectResize(sRect* r, int w, int h);

// copy rectangle
void RectCopy(sRect* dst, const sRect* src);

// copy rectangle and shift relative
void RectCopyShift(sRect* dst, const sRect* src, int dx, int dy);

// check if rectangle is valid (size > 0)
Bool RectIsValid(const sRect* r);

// check if point hits the rectangle
Bool RectHit(const sRect* r, int x, int y);

// check if rectangle partially overlaps another rectangle
Bool RectOverlap(const sRect* r, const sRect* r2);

// check if rectangle rin is whole inside another rectangle rout
Bool RectInside(const sRect* rin, const sRect* rout);

// check if rectangles are equal
Bool RectEqu(const sRect* r, const sRect* r2);

// clip rectangle rin by another rectangle rout
void RectClip(sRect* rin, const sRect* rout);

// merge rectangle dst with another rectangle src
void RectMerge(sRect* dst, const sRect* src);

#ifdef __cplusplus
}
#endif

#endif // _RECT_H

#endif // USE_RECT	// use Rectangle (lib_rect.c, lib_rect.h)

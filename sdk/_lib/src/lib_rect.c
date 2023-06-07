
// ****************************************************************************
//
//                                 Rectangle
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_RECT	// use Rectangle (lib_rect.c, lib_rect.h)

#include "../inc/lib_rect.h"

// Set rectangle (with size)
void RectSet(sRect* r, int x, int y, int w, int h)
{
	r->x = x;
	r->y = y;
	r->w = w;
	r->h = h;
}

// Set rectangle (with coordinates)
void RectSet2(sRect* r, int x, int y, int x2, int y2)
{
	r->x = x;
	r->y = y;
	r->w = x2 - x;
	r->h = y2 - y;
}

// Clear rectangle
void RectClear(sRect* r)
{
	r->x = 0;
	r->y = 0;
	r->w = 0;
	r->h = 0;
}

// Move left top corner (preserve size)
void RectMove(sRect* r, int x, int y)
{
	r->x = x;
	r->y = y;
}

// Move right bottom corner (change size)
void RectMove2(sRect* r, int x2, int y2)
{
	r->w = x2 - r->x;
	r->h = y2 - r->y;
}

// Shift relative (move top corner, preserve size)
void RectShift(sRect* r, int dx, int dy)
{
	r->x += dx;
	r->y += dy;
}

// Set size (preserve left top corner)
void RectResize(sRect* r, int w, int h)
{
	r->w = w;
	r->h = h;
}

// copy rectangle
void RectCopy(sRect* dst, const sRect* src)
{
	dst->x = src->x;
	dst->y = src->y;
	dst->w = src->w;
	dst->h = src->h;
}

// copy rectangle and shift relative
void RectCopyShift(sRect* dst, const sRect* src, int dx, int dy)
{
	dst->x = src->x + dx;
	dst->y = src->y + dy;
	dst->w = src->w;
	dst->h = src->h;
}

// check if rectangle is valid (size > 0)
Bool RectIsValid(const sRect* r)
{
	return (r->w > 0) && (r->h > 0);
}

// check if point hits the rectangle
Bool RectHit(const sRect* r, int x, int y)
{
	return (x >= r->x) && (y >= r->y) && (x < r->x + r->w) && (y < r->y + r->h);
}

// check if rectangle partially overlaps another rectangle
Bool RectOverlap(const sRect* r, const sRect* r2)
{
	return (r->x < r2->x + r2->w) && (r->y < r2->y + r2->h) &&
		(r->x + r->w > r2->x) && (r->y + r->h > r2->y);
}

// check if rectangle rin is whole inside another rectangle rout
Bool RectInside(const sRect* rin, const sRect* rout)
{
	return (rin->x >= rout->x) && (rin->y >= rout->y) &&
		(rin->x + rin->w <= rout->x + rout->w) &&
		(rin->y + rin->h <= rout->y + rout->h);
}

// check if rectangles are equal
Bool RectEqu(const sRect* r, const sRect* r2)
{
	return (r->x == r2->x) && (r->y == r2->y) && (r->w == r2->w) && (r->h == r2->h);
}

// clip rectangle rin by another rectangle rout
void RectClip(sRect* rin, const sRect* rout)
{
	if (rin->x < rout->x) rin->x = rout->x;
	if (rin->x > rout->x + rout->w) rin->x = rout->x + rout->w;

	if (rin->y < rout->y) rin->y = rout->y;
	if (rin->y > rout->y + rout->h) rin->y = rout->y + rout->h;

	if (rin->x + rin->w < rout->x) rin->w = rout->x - rin->x;
	if (rin->x + rin->w > rout->x + rout->w) rin->w = rout->x + rout->w - rin->x;

	if (rin->y + rin->h < rout->y) rin->h = rout->y - rin->y;
	if (rin->y + rin->h > rout->y + rout->h) rin->h = rout->y + rout->h - rin->y;
}

// merge rectangle dst with another rectangle src
void RectMerge(sRect* dst, const sRect* src)
{
	if (dst->x > src->x) dst->x = src->x;
	if (dst->y > src->y) dst->y = src->y;
	if (dst->x + dst->w < src->x + src->w) dst->w = src->x + src->w - dst->x;
	if (dst->y + dst->h < src->y + src->h) dst->h = src->y + src->h - dst->y;
}

#endif // USE_RECT	// use Rectangle (lib_rect.c, lib_rect.h)

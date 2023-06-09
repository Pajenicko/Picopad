#include "../include.h"

// format: 4-bit paletted pixel graphics
// image width: 320 pixels
// image height: 40 lines
// image pitch: 160 bytes
const u16 OpenSelImg_Pal[16] __attribute__ ((aligned(4))) = {
	0x0000, 0xFFFF, 0x0004, 0x0027, 0x0862, 0x010D, 0x31A6, 0x02F9, 0x4DFD, 0x0105, 0x0262, 0x0380, 0x5226, 0x7901, 0xCE18, 0x836D, 
};

const u8 OpenSelImg[6400] __attribute__ ((aligned(4))) = {
	0x00, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 
	0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 
	0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x00, 0x00, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 
	0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 
	0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x00, 
	0x00, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 
	0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 
	0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x00, 0x00, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 
	0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 
	0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x44, 0x00, 
	0x05, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 
	0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 
	0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x30, 0x05, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 
	0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 
	0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x30, 
	0x05, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 
	0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 
	0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x30, 0x05, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 
	0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 
	0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x30, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x23, 0x33, 0x53, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x23, 0x33, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x39, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x23, 0x33, 0x53, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x23, 0x33, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x39, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x35, 0x33, 0x55, 0x33, 0x33, 0x33, 0x35, 0x33, 0x35, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 0x93, 0x33, 0x33, 0x33, 
	0x93, 0x33, 0x93, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x35, 0x33, 0x55, 
	0x33, 0x33, 0x33, 0x35, 0x33, 0x35, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x93, 0x39, 0x93, 0x33, 0x33, 0x33, 0x93, 0x33, 0x93, 0x33, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x35, 0x33, 0x55, 0x33, 0x33, 0x33, 0x35, 0x33, 0x35, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 0x93, 0x33, 0x33, 0x33, 
	0x93, 0x33, 0x93, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x35, 0x33, 0x55, 
	0x33, 0x33, 0x33, 0x35, 0x33, 0x35, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x93, 0x39, 0x93, 0x33, 0x33, 0x33, 0x93, 0x33, 0x93, 0x33, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x55, 0x33, 0x53, 0x37, 0x55, 0x53, 0x53, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x33, 0x39, 0x99, 0x93, 0x99, 
	0x39, 0x93, 0x39, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x55, 0x33, 
	0x53, 0x37, 0x55, 0x53, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x93, 0x33, 0x39, 0x99, 0x93, 0x99, 0x39, 0x93, 0x39, 0x33, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x55, 0x33, 0x53, 0x37, 0x55, 0x53, 0x53, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x33, 0x39, 0x99, 0x93, 0x99, 
	0x39, 0x93, 0x39, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x55, 0x33, 
	0x53, 0x37, 0x55, 0x53, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x93, 0x33, 0x39, 0x99, 0x93, 0x99, 0x39, 0x93, 0x39, 0x33, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x25, 0x35, 0x32, 0x57, 0x55, 0x55, 0x55, 0x55, 0x55, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 0x99, 0x99, 0x99, 0x9A, 0x93, 
	0x39, 0x99, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x25, 0x35, 0x32, 
	0x57, 0x55, 0x55, 0x55, 0x55, 0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x99, 0x99, 0x99, 0x99, 0x9A, 0x93, 0x39, 0x99, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x25, 0x35, 0x32, 0x57, 0x55, 0x55, 0x55, 0x55, 0x55, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 0x99, 0x99, 0x99, 0x9A, 0x93, 
	0x39, 0x99, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x25, 0x35, 0x32, 
	0x57, 0x55, 0x55, 0x55, 0x55, 0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x99, 0x99, 0x99, 0x99, 0x9A, 0x93, 0x39, 0x99, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x55, 0x55, 0x55, 0x55, 0x75, 0x75, 0x55, 0x35, 0x55, 0x53, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x93, 0x99, 0xA9, 0xAA, 0x99, 
	0x99, 0x99, 0x93, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x55, 0x55, 0x55, 
	0x55, 0x75, 0x75, 0x55, 0x35, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x39, 0x99, 0x93, 0x99, 0xA9, 0xAA, 0x99, 0x99, 0x99, 0x93, 0x33, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x55, 0x55, 0x55, 0x55, 0x75, 0x75, 0x55, 0x35, 0x55, 0x53, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x93, 0x99, 0xA9, 0xAA, 0x99, 
	0x99, 0x99, 0x93, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x55, 0x55, 0x55, 
	0x55, 0x75, 0x75, 0x55, 0x35, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x39, 0x99, 0x93, 0x99, 0xA9, 0xAA, 0x99, 0x99, 0x99, 0x93, 0x33, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x32, 0x33, 0x35, 0x55, 0x55, 0x57, 0x75, 0x77, 0x77, 0x75, 0x55, 0x55, 0x55, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x39, 0x99, 0xA9, 0x9A, 0xAA, 0xA9, 0xAA, 
	0x99, 0x99, 0x99, 0x93, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x32, 0x33, 0x35, 0x55, 0x55, 0x57, 
	0x75, 0x77, 0x77, 0x75, 0x55, 0x55, 0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x39, 0x39, 0x99, 0xA9, 0x9A, 0xAA, 0xA9, 0xAA, 0x99, 0x99, 0x99, 0x93, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x32, 0x33, 0x35, 0x55, 0x55, 0x57, 0x75, 0x77, 0x77, 0x75, 0x55, 0x55, 0x55, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x39, 0x99, 0xA9, 0x9A, 0xAA, 0xA9, 0xAA, 
	0x99, 0x99, 0x99, 0x93, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x32, 0x33, 0x35, 0x55, 0x55, 0x57, 
	0x75, 0x77, 0x77, 0x75, 0x55, 0x55, 0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x39, 0x39, 0x99, 0xA9, 0x9A, 0xAA, 0xA9, 0xAA, 0x99, 0x99, 0x99, 0x93, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x35, 0x55, 0x57, 0x57, 0x77, 0x75, 0x77, 0x77, 0x75, 0x55, 0x55, 0x53, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x99, 0x9A, 0xAA, 0xAC, 0xCB, 0xAA, 
	0xA9, 0xA9, 0x99, 0x93, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x35, 0x55, 0x57, 0x57, 
	0x77, 0x75, 0x77, 0x77, 0x75, 0x55, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x39, 0x99, 0x99, 0x9A, 0xAA, 0xAC, 0xCB, 0xAA, 0xA9, 0xA9, 0x99, 0x93, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x35, 0x55, 0x57, 0x57, 0x77, 0x75, 0x77, 0x77, 0x75, 0x55, 0x55, 0x53, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x99, 0x9A, 0xAA, 0xAC, 0xCB, 0xAA, 
	0xA9, 0xA9, 0x99, 0x93, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x35, 0x55, 0x57, 0x57, 
	0x77, 0x75, 0x77, 0x77, 0x75, 0x55, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x39, 0x99, 0x99, 0x9A, 0xAA, 0xAC, 0xCB, 0xAA, 0xA9, 0xA9, 0x99, 0x93, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x32, 0x33, 0x33, 0x35, 0x55, 0x77, 0x77, 0x77, 0x50, 0x77, 0x05, 0x77, 0x35, 0x55, 0x55, 
	0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x99, 0x99, 0xBB, 0xDC, 0xBD, 0xDB, 0xBB, 
	0xBA, 0xA9, 0xA9, 0x93, 0x33, 0x33, 0x33, 0x20, 0x05, 0x32, 0x33, 0x33, 0x35, 0x55, 0x77, 0x77, 
	0x77, 0x50, 0x77, 0x05, 0x77, 0x35, 0x55, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 
	0x99, 0x99, 0x99, 0xBB, 0xDC, 0xBD, 0xDB, 0xBB, 0xBA, 0xA9, 0xA9, 0x93, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x32, 0x33, 0x33, 0x35, 0x55, 0x77, 0x77, 0x77, 0x50, 0x77, 0x05, 0x77, 0x35, 0x55, 0x55, 
	0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x99, 0x99, 0xBB, 0xDC, 0xBD, 0xDB, 0xBB, 
	0xBA, 0xA9, 0xA9, 0x93, 0x33, 0x33, 0x33, 0x20, 0x05, 0x32, 0x33, 0x33, 0x35, 0x55, 0x77, 0x77, 
	0x77, 0x50, 0x77, 0x05, 0x77, 0x35, 0x55, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 
	0x99, 0x99, 0x99, 0xBB, 0xDC, 0xBD, 0xDB, 0xBB, 0xBA, 0xA9, 0xA9, 0x93, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x55, 0x35, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x25, 0x77, 0x75, 0x55, 0x53, 
	0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x99, 0x9A, 0xAB, 0xDD, 0xBB, 0xBB, 0xBB, 
	0xBB, 0xAA, 0xAA, 0x33, 0x93, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x55, 0x35, 0x77, 0x77, 0x77, 
	0x77, 0x77, 0x77, 0x25, 0x77, 0x75, 0x55, 0x53, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 
	0x99, 0x99, 0x9A, 0xAB, 0xDD, 0xBB, 0xBB, 0xBB, 0xBB, 0xAA, 0xAA, 0x33, 0x93, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x55, 0x35, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x25, 0x77, 0x75, 0x55, 0x53, 
	0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x99, 0x9A, 0xAB, 0xDD, 0xBB, 0xBB, 0xBB, 
	0xBB, 0xAA, 0xAA, 0x33, 0x93, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x55, 0x35, 0x77, 0x77, 0x77, 
	0x77, 0x77, 0x77, 0x25, 0x77, 0x75, 0x55, 0x53, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 
	0x99, 0x99, 0x9A, 0xAB, 0xDD, 0xBB, 0xBB, 0xBB, 0xBB, 0xAA, 0xAA, 0x33, 0x93, 0x33, 0x33, 0x20, 
	0x05, 0x32, 0x33, 0x55, 0x55, 0x57, 0x77, 0x77, 0x77, 0x57, 0x75, 0x77, 0x77, 0x77, 0x75, 0x55, 
	0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x9A, 0xAB, 0xAA, 0xBB, 0xAB, 0xCB, 0xBB, 
	0xBA, 0xBA, 0xA9, 0x99, 0x99, 0x33, 0x33, 0x20, 0x05, 0x32, 0x33, 0x55, 0x55, 0x57, 0x77, 0x77, 
	0x77, 0x57, 0x75, 0x77, 0x77, 0x77, 0x75, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 
	0x99, 0x9A, 0xAB, 0xAA, 0xBB, 0xAB, 0xCB, 0xBB, 0xBA, 0xBA, 0xA9, 0x99, 0x99, 0x33, 0x33, 0x20, 
	0x05, 0x32, 0x33, 0x55, 0x55, 0x57, 0x77, 0x77, 0x77, 0x57, 0x75, 0x77, 0x77, 0x77, 0x75, 0x55, 
	0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x9A, 0xAB, 0xAA, 0xBB, 0xAB, 0xCB, 0xBB, 
	0xBA, 0xBA, 0xA9, 0x99, 0x99, 0x33, 0x33, 0x20, 0x05, 0x32, 0x33, 0x55, 0x55, 0x57, 0x77, 0x77, 
	0x77, 0x57, 0x75, 0x77, 0x77, 0x77, 0x75, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 
	0x99, 0x9A, 0xAB, 0xAA, 0xBB, 0xAB, 0xCB, 0xBB, 0xBA, 0xBA, 0xA9, 0x99, 0x99, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x35, 0x55, 0x77, 0x77, 0x77, 0x50, 0x00, 0x44, 0x77, 0x77, 0x77, 0x77, 0x75, 
	0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 0x9A, 0xAA, 0xAB, 0xBB, 0xBC, 0xDD, 0xDD, 0xDC, 
	0xBB, 0xBA, 0xAA, 0x99, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x35, 0x55, 0x77, 0x77, 0x77, 
	0x50, 0x00, 0x44, 0x77, 0x77, 0x77, 0x77, 0x75, 0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 
	0x9A, 0xAA, 0xAB, 0xBB, 0xBC, 0xDD, 0xDD, 0xDC, 0xBB, 0xBA, 0xAA, 0x99, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x35, 0x55, 0x77, 0x77, 0x77, 0x50, 0x00, 0x44, 0x77, 0x77, 0x77, 0x77, 0x75, 
	0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 0x9A, 0xAA, 0xAB, 0xBB, 0xBC, 0xDD, 0xDD, 0xDC, 
	0xBB, 0xBA, 0xAA, 0x99, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x35, 0x55, 0x77, 0x77, 0x77, 
	0x50, 0x00, 0x44, 0x77, 0x77, 0x77, 0x77, 0x75, 0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 
	0x9A, 0xAA, 0xAB, 0xBB, 0xBC, 0xDD, 0xDD, 0xDC, 0xBB, 0xBA, 0xAA, 0x99, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x35, 0x57, 0x77, 0x77, 0x70, 0x0C, 0xC0, 0x0F, 0xC3, 0x77, 0x77, 0x75, 0x53, 
	0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x99, 0x9A, 0xBB, 0xBB, 0xDD, 0xDD, 0xDD, 0xDD, 
	0xDB, 0xBA, 0xBA, 0xA9, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x35, 0x57, 0x77, 0x77, 0x70, 
	0x0C, 0xC0, 0x0F, 0xC3, 0x77, 0x77, 0x75, 0x53, 0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 
	0x99, 0x9A, 0xBB, 0xBB, 0xDD, 0xDD, 0xDD, 0xDD, 0xDB, 0xBA, 0xBA, 0xA9, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x35, 0x57, 0x77, 0x77, 0x70, 0x0C, 0xC0, 0x0F, 0xC3, 0x77, 0x77, 0x75, 0x53, 
	0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x99, 0x9A, 0xBB, 0xBB, 0xDD, 0xDD, 0xDD, 0xDD, 
	0xDB, 0xBA, 0xBA, 0xA9, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x35, 0x57, 0x77, 0x77, 0x70, 
	0x0C, 0xC0, 0x0F, 0xC3, 0x77, 0x77, 0x75, 0x53, 0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 
	0x99, 0x9A, 0xBB, 0xBB, 0xDD, 0xDD, 0xDD, 0xDD, 0xDB, 0xBA, 0xBA, 0xA9, 0x33, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x55, 0x57, 0x77, 0x77, 0x00, 0xF1, 0x1C, 0xC1, 0x1C, 0x57, 0x77, 0x75, 0x55, 
	0x55, 0x32, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x99, 0xAA, 0xAB, 0xBD, 0xCD, 0xDC, 0x6D, 0xCC, 
	0xDD, 0xBB, 0xAB, 0xA9, 0x93, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x55, 0x57, 0x77, 0x77, 0x00, 
	0xF1, 0x1C, 0xC1, 0x1C, 0x57, 0x77, 0x75, 0x55, 0x55, 0x32, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 
	0x99, 0xAA, 0xAB, 0xBD, 0xCD, 0xDC, 0x6D, 0xCC, 0xDD, 0xBB, 0xAB, 0xA9, 0x93, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x55, 0x57, 0x77, 0x77, 0x00, 0xF1, 0x1C, 0xC1, 0x1C, 0x57, 0x77, 0x75, 0x55, 
	0x55, 0x32, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x99, 0xAA, 0xAB, 0xBD, 0xCD, 0xDC, 0x6D, 0xCC, 
	0xDD, 0xBB, 0xAB, 0xA9, 0x93, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x55, 0x57, 0x77, 0x77, 0x00, 
	0xF1, 0x1C, 0xC1, 0x1C, 0x57, 0x77, 0x75, 0x55, 0x55, 0x32, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 
	0x99, 0xAA, 0xAB, 0xBD, 0xCD, 0xDC, 0x6D, 0xCC, 0xDD, 0xBB, 0xAB, 0xA9, 0x93, 0x33, 0x33, 0x20, 
	0x05, 0x32, 0x33, 0x57, 0x57, 0x77, 0x74, 0x04, 0x1E, 0xCE, 0x1E, 0xCE, 0x05, 0x77, 0x77, 0x75, 
	0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 0x9A, 0xAA, 0xBB, 0xDD, 0x90, 0xEE, 0x00, 0x1E, 
	0xDD, 0xCB, 0xAA, 0xAA, 0x93, 0x33, 0x33, 0x20, 0x05, 0x32, 0x33, 0x57, 0x57, 0x77, 0x74, 0x04, 
	0x1E, 0xCE, 0x1E, 0xCE, 0x05, 0x77, 0x77, 0x75, 0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 
	0x9A, 0xAA, 0xBB, 0xDD, 0x90, 0xEE, 0x00, 0x1E, 0xDD, 0xCB, 0xAA, 0xAA, 0x93, 0x33, 0x33, 0x20, 
	0x05, 0x32, 0x33, 0x57, 0x57, 0x77, 0x74, 0x04, 0x1E, 0xCE, 0x1E, 0xCE, 0x05, 0x77, 0x77, 0x75, 
	0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 0x9A, 0xAA, 0xBB, 0xDD, 0x90, 0xEE, 0x00, 0x1E, 
	0xDD, 0xCB, 0xAA, 0xAA, 0x93, 0x33, 0x33, 0x20, 0x05, 0x32, 0x33, 0x57, 0x57, 0x77, 0x74, 0x04, 
	0x1E, 0xCE, 0x1E, 0xCE, 0x05, 0x77, 0x77, 0x75, 0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 
	0x9A, 0xAA, 0xBB, 0xDD, 0x90, 0xEE, 0x00, 0x1E, 0xDD, 0xCB, 0xAA, 0xAA, 0x93, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x55, 0x57, 0x77, 0x50, 0x06, 0x1F, 0x0F, 0x1F, 0x0F, 0x62, 0x77, 0x77, 0x55, 
	0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x39, 0xA9, 0x9A, 0xAA, 0xBA, 0xDF, 0x40, 0x11, 0x00, 0x1E, 
	0xDD, 0xDB, 0xBA, 0xA9, 0x99, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x55, 0x57, 0x77, 0x50, 0x06, 
	0x1F, 0x0F, 0x1F, 0x0F, 0x62, 0x77, 0x77, 0x55, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x39, 0xA9, 
	0x9A, 0xAA, 0xBA, 0xDF, 0x40, 0x11, 0x00, 0x1E, 0xDD, 0xDB, 0xBA, 0xA9, 0x99, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x55, 0x57, 0x77, 0x50, 0x06, 0x1F, 0x0F, 0x1F, 0x0F, 0x62, 0x77, 0x77, 0x55, 
	0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x39, 0xA9, 0x9A, 0xAA, 0xBA, 0xDF, 0x40, 0x11, 0x00, 0x1E, 
	0xDD, 0xDB, 0xBA, 0xA9, 0x99, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x55, 0x57, 0x77, 0x50, 0x06, 
	0x1F, 0x0F, 0x1F, 0x0F, 0x62, 0x77, 0x77, 0x55, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x39, 0xA9, 
	0x9A, 0xAA, 0xBA, 0xDF, 0x40, 0x11, 0x00, 0x1E, 0xDD, 0xDB, 0xBA, 0xA9, 0x99, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x55, 0x77, 0x77, 0x30, 0x06, 0x1F, 0x0F, 0x1F, 0x0F, 0x60, 0x77, 0x77, 0x55, 
	0x33, 0x55, 0x33, 0x33, 0x33, 0x39, 0x93, 0x39, 0x99, 0xAA, 0xAC, 0xDE, 0xC0, 0x11, 0x60, 0x1E, 
	0xDD, 0xDB, 0xBA, 0xBA, 0x99, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x55, 0x77, 0x77, 0x30, 0x06, 
	0x1F, 0x0F, 0x1F, 0x0F, 0x60, 0x77, 0x77, 0x55, 0x33, 0x55, 0x33, 0x33, 0x33, 0x39, 0x93, 0x39, 
	0x99, 0xAA, 0xAC, 0xDE, 0xC0, 0x11, 0x60, 0x1E, 0xDD, 0xDB, 0xBA, 0xBA, 0x99, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x55, 0x77, 0x77, 0x30, 0x06, 0x1F, 0x0F, 0x1F, 0x0F, 0x60, 0x77, 0x77, 0x55, 
	0x33, 0x55, 0x33, 0x33, 0x33, 0x39, 0x93, 0x39, 0x99, 0xAA, 0xAC, 0xDE, 0xC0, 0x11, 0x60, 0x1E, 
	0xDD, 0xDB, 0xBA, 0xBA, 0x99, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x55, 0x77, 0x77, 0x30, 0x06, 
	0x1F, 0x0F, 0x1F, 0x0F, 0x60, 0x77, 0x77, 0x55, 0x33, 0x55, 0x33, 0x33, 0x33, 0x39, 0x93, 0x39, 
	0x99, 0xAA, 0xAC, 0xDE, 0xC0, 0x11, 0x60, 0x1E, 0xDD, 0xDB, 0xBA, 0xBA, 0x99, 0x33, 0x33, 0x20, 
	0x05, 0x32, 0x35, 0x55, 0x77, 0x77, 0x40, 0x04, 0x1E, 0x0F, 0x1E, 0x0F, 0x40, 0x77, 0x77, 0x57, 
	0x52, 0x55, 0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 0x99, 0xAA, 0xBD, 0xDD, 0xEE, 0x1E, 0xEE, 0x1F, 
	0xDD, 0xDC, 0xBA, 0xAA, 0x99, 0x33, 0x33, 0x20, 0x05, 0x32, 0x35, 0x55, 0x77, 0x77, 0x40, 0x04, 
	0x1E, 0x0F, 0x1E, 0x0F, 0x40, 0x77, 0x77, 0x57, 0x52, 0x55, 0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 
	0x99, 0xAA, 0xBD, 0xDD, 0xEE, 0x1E, 0xEE, 0x1F, 0xDD, 0xDC, 0xBA, 0xAA, 0x99, 0x33, 0x33, 0x20, 
	0x05, 0x32, 0x35, 0x55, 0x77, 0x77, 0x40, 0x04, 0x1E, 0x0F, 0x1E, 0x0F, 0x40, 0x77, 0x77, 0x57, 
	0x52, 0x55, 0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 0x99, 0xAA, 0xBD, 0xDD, 0xEE, 0x1E, 0xEE, 0x1F, 
	0xDD, 0xDC, 0xBA, 0xAA, 0x99, 0x33, 0x33, 0x20, 0x05, 0x32, 0x35, 0x55, 0x77, 0x77, 0x40, 0x04, 
	0x1E, 0x0F, 0x1E, 0x0F, 0x40, 0x77, 0x77, 0x57, 0x52, 0x55, 0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 
	0x99, 0xAA, 0xBD, 0xDD, 0xEE, 0x1E, 0xEE, 0x1F, 0xDD, 0xDC, 0xBA, 0xAA, 0x99, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x35, 0x77, 0x77, 0x40, 0x00, 0xF1, 0xE4, 0xC1, 0xE6, 0x00, 0x77, 0x77, 0x55, 
	0x33, 0x55, 0x23, 0x33, 0x33, 0x33, 0x93, 0x39, 0x39, 0xAA, 0xBC, 0xDD, 0xE1, 0xED, 0xE1, 0xED, 
	0xDD, 0xDC, 0xBB, 0xAA, 0x93, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x35, 0x77, 0x77, 0x40, 0x00, 
	0xF1, 0xE4, 0xC1, 0xE6, 0x00, 0x77, 0x77, 0x55, 0x33, 0x55, 0x23, 0x33, 0x33, 0x33, 0x93, 0x39, 
	0x39, 0xAA, 0xBC, 0xDD, 0xE1, 0xED, 0xE1, 0xED, 0xDD, 0xDC, 0xBB, 0xAA, 0x93, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x35, 0x77, 0x77, 0x20, 0x00, 0xC1, 0xE4, 0xC1, 0xE6, 0x00, 0x77, 0x77, 0x55, 
	0x33, 0x55, 0x23, 0x33, 0x33, 0x33, 0x93, 0x39, 0x39, 0xAA, 0xBC, 0xDD, 0xE1, 0xED, 0xE1, 0xED, 
	0xDD, 0xDC, 0xBB, 0xAA, 0x93, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x35, 0x77, 0x77, 0x20, 0x00, 
	0xC1, 0xE4, 0xC1, 0xE6, 0x00, 0x77, 0x77, 0x55, 0x33, 0x55, 0x23, 0x33, 0x33, 0x33, 0x93, 0x39, 
	0x39, 0xAA, 0xBC, 0xDD, 0xE1, 0xED, 0xE1, 0xED, 0xDD, 0xDC, 0xBB, 0xAA, 0x93, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x35, 0x57, 0x77, 0x30, 0x00, 0x06, 0xC0, 0x06, 0x60, 0x00, 0x77, 0x75, 0x75, 
	0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x9A, 0x9A, 0xBC, 0xDD, 0xDD, 0xDD, 0xDF, 0xDD, 
	0xDD, 0xDB, 0xBB, 0xAA, 0x93, 0x93, 0x33, 0x20, 0x05, 0x33, 0x33, 0x35, 0x57, 0x77, 0x30, 0x00, 
	0x06, 0xC0, 0x06, 0x60, 0x00, 0x77, 0x75, 0x75, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 
	0x9A, 0x9A, 0xBC, 0xDD, 0xDD, 0xDD, 0xDF, 0xD4, 0x44, 0x44, 0xAA, 0x44, 0x42, 0x44, 0x03, 0x20, 
	0x05, 0x34, 0x22, 0x23, 0x35, 0x55, 0x40, 0x00, 0x0C, 0xC0, 0x06, 0x60, 0x00, 0x77, 0x75, 0x75, 
	0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x9A, 0x9A, 0xBC, 0xDD, 0xDD, 0xDD, 0xDF, 0xDD, 
	0xDD, 0xDB, 0xBB, 0xAA, 0x93, 0x93, 0x33, 0x20, 0x05, 0x32, 0x42, 0x23, 0x35, 0x55, 0x40, 0x00, 
	0x0C, 0xC0, 0x06, 0x60, 0x00, 0x77, 0x75, 0x75, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 
	0x9A, 0x9A, 0xBC, 0xDD, 0xDD, 0xDD, 0xDF, 0xDD, 0x44, 0x44, 0xAA, 0x44, 0x42, 0x44, 0x42, 0x40, 
	0x05, 0x33, 0x55, 0x55, 0x77, 0x77, 0x50, 0x00, 0x64, 0x00, 0x00, 0x60, 0x09, 0x77, 0x77, 0x75, 
	0x35, 0x53, 0x33, 0x33, 0x33, 0x33, 0x39, 0x39, 0x9A, 0xAB, 0xBA, 0xDD, 0xDC, 0xDD, 0xDD, 0xDD, 
	0xDD, 0xDB, 0xBA, 0xAA, 0x99, 0x93, 0x33, 0x20, 0x05, 0x33, 0x55, 0x55, 0x77, 0x77, 0x50, 0x00, 
	0x64, 0x00, 0x00, 0x60, 0x09, 0x77, 0x77, 0x75, 0x35, 0x53, 0x33, 0x33, 0x33, 0x33, 0x39, 0x39, 
	0x9A, 0xAB, 0xBA, 0xDD, 0xDC, 0xDD, 0xDD, 0xD6, 0xFC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xF6, 0x00, 
	0x05, 0x9F, 0xFC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCF, 0xC0, 0x00, 0x00, 0x60, 0x09, 0x77, 0x77, 0x75, 
	0x35, 0x53, 0x33, 0x33, 0x33, 0x33, 0x39, 0x39, 0x9A, 0xAB, 0xBA, 0xDD, 0xDC, 0xDD, 0xDD, 0xDD, 
	0xDD, 0xDB, 0xBA, 0xAA, 0x99, 0x93, 0x33, 0x20, 0x05, 0x36, 0xFC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCF, 
	0xF4, 0x00, 0x00, 0x60, 0x09, 0x77, 0x77, 0x75, 0x35, 0x53, 0x33, 0x33, 0x33, 0x33, 0x39, 0x39, 
	0x9A, 0xAB, 0xBA, 0xDD, 0xDC, 0xDD, 0xDD, 0xD6, 0x6F, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xFF, 0x40, 
	0x05, 0x33, 0x23, 0x55, 0x57, 0x77, 0x70, 0x00, 0x6F, 0xFC, 0xCF, 0xF0, 0x05, 0x77, 0x77, 0x55, 
	0x53, 0x55, 0x33, 0x33, 0x33, 0x33, 0x99, 0x99, 0x9A, 0xAA, 0xAB, 0xDD, 0xCF, 0xCC, 0xDF, 0xFD, 
	0xDD, 0xCB, 0xBA, 0xA9, 0x99, 0x33, 0x33, 0x20, 0x05, 0x33, 0x23, 0x55, 0x57, 0x77, 0x70, 0x00, 
	0x6F, 0xFC, 0xCF, 0xF0, 0x05, 0x77, 0x77, 0x55, 0x53, 0x55, 0x33, 0x33, 0x33, 0x33, 0x99, 0x99, 
	0x9A, 0xAA, 0xAB, 0xDD, 0xCF, 0xCC, 0xDF, 0x6C, 0xF6, 0x66, 0x66, 0x66, 0x66, 0x66, 0xFC, 0x00, 
	0x03, 0x6F, 0x66, 0x66, 0x66, 0x66, 0x66, 0x6C, 0xF6, 0xFC, 0xCF, 0xF0, 0x05, 0x77, 0x77, 0x55, 
	0x53, 0x55, 0x33, 0x33, 0x33, 0x33, 0x99, 0x99, 0x9A, 0xAA, 0xAB, 0xDD, 0xCF, 0xCC, 0xDF, 0xFD, 
	0xDD, 0xCB, 0xBA, 0xA9, 0x99, 0x33, 0x33, 0x20, 0x05, 0x2C, 0xF6, 0x66, 0x66, 0x66, 0x66, 0x66, 
	0xFC, 0xCC, 0xCF, 0xF0, 0x05, 0x77, 0x77, 0x55, 0x53, 0x55, 0x33, 0x33, 0x33, 0x33, 0x99, 0x99, 
	0x9A, 0xAA, 0xAB, 0xDD, 0xCF, 0xCC, 0xDF, 0xF6, 0xFC, 0x66, 0x66, 0x66, 0x66, 0x66, 0x6F, 0x40, 
	0x05, 0x33, 0x33, 0x55, 0x57, 0x77, 0x77, 0x00, 0x04, 0xFD, 0xDC, 0x00, 0x57, 0x77, 0x75, 0x55, 
	0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 0x99, 0xAA, 0xAA, 0xBD, 0xDD, 0xFD, 0xFD, 0xDD, 
	0xDD, 0xBB, 0xAA, 0xA9, 0x93, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x55, 0x57, 0x77, 0x77, 0x00, 
	0x04, 0xFD, 0xDC, 0x00, 0x57, 0x77, 0x75, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 
	0x99, 0xAA, 0xAA, 0xBD, 0xDD, 0xFD, 0xFD, 0x4C, 0x67, 0x88, 0x88, 0x88, 0x88, 0x87, 0x6C, 0x00, 
	0x03, 0x6C, 0x58, 0x88, 0x88, 0x88, 0x88, 0x89, 0xC4, 0xFD, 0xDC, 0x00, 0x57, 0x77, 0x75, 0x55, 
	0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 0x99, 0xAA, 0xAA, 0xBD, 0xDD, 0xFD, 0xFD, 0xDD, 
	0xDD, 0xBB, 0xAA, 0xA9, 0x93, 0x33, 0x33, 0x20, 0x05, 0x2C, 0x67, 0x88, 0x88, 0x88, 0x88, 0x87, 
	0x66, 0xDD, 0xDC, 0x00, 0x57, 0x77, 0x75, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 
	0x99, 0xAA, 0xAA, 0xBD, 0xDD, 0xFD, 0xFD, 0xD4, 0xC6, 0x88, 0x88, 0x88, 0x88, 0x88, 0x9C, 0x40, 
	0x05, 0x33, 0x33, 0x35, 0x57, 0x77, 0x77, 0x70, 0x00, 0x06, 0x60, 0x05, 0x77, 0x77, 0x55, 0x53, 
	0x33, 0x32, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x39, 0x99, 0xAA, 0xBB, 0xDD, 0xDD, 0xCD, 0xDD, 
	0xDB, 0xBA, 0xAB, 0xA9, 0x93, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x35, 0x57, 0x77, 0x77, 0x70, 
	0x00, 0x06, 0x60, 0x05, 0x77, 0x77, 0x55, 0x53, 0x33, 0x32, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 
	0x39, 0x99, 0xAA, 0xBB, 0xDD, 0xDD, 0xCD, 0xDC, 0xC7, 0x88, 0x88, 0x88, 0x88, 0x87, 0x6C, 0x00, 
	0x03, 0x6C, 0x58, 0x88, 0x88, 0x88, 0x88, 0x86, 0xC0, 0x06, 0x60, 0x05, 0x77, 0x77, 0x55, 0x53, 
	0x33, 0x32, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x39, 0x99, 0xAA, 0xBB, 0xDD, 0xDD, 0xCD, 0xDD, 
	0xDB, 0xBA, 0xAB, 0xA9, 0x93, 0x33, 0x33, 0x20, 0x05, 0x2C, 0xC7, 0x88, 0x88, 0x88, 0x88, 0x87, 
	0x66, 0x06, 0x60, 0x05, 0x77, 0x77, 0x55, 0x53, 0x33, 0x32, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 
	0x39, 0x99, 0xAA, 0xBB, 0xDD, 0xDD, 0xCD, 0xD4, 0xC6, 0x88, 0x88, 0x88, 0x88, 0x88, 0x5C, 0x40, 
	0x05, 0x33, 0x33, 0x35, 0x77, 0x77, 0x77, 0x77, 0x54, 0x00, 0x05, 0x77, 0x77, 0x77, 0x55, 0x53, 
	0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 0x99, 0x9A, 0xAA, 0xBB, 0xBC, 0xDD, 0xDD, 0xDB, 
	0xBB, 0xBA, 0xAA, 0xA9, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x35, 0x77, 0x77, 0x77, 0x77, 
	0x54, 0x00, 0x05, 0x77, 0x77, 0x77, 0x55, 0x53, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 
	0x99, 0x9A, 0xAA, 0xBB, 0xBC, 0xDD, 0xDD, 0x4C, 0xC7, 0x88, 0x88, 0x88, 0x88, 0x87, 0x6C, 0x00, 
	0x03, 0x6C, 0x58, 0x88, 0x88, 0x88, 0x88, 0x86, 0xC4, 0x40, 0x05, 0x77, 0x77, 0x77, 0x55, 0x53, 
	0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 0x99, 0x9A, 0xAA, 0xBB, 0xBC, 0xDD, 0xDD, 0xDB, 
	0xBB, 0xBA, 0xAA, 0xA9, 0x33, 0x33, 0x33, 0x20, 0x05, 0x2C, 0xC7, 0x88, 0x88, 0x88, 0x88, 0x87, 
	0x6C, 0x00, 0x05, 0x77, 0x77, 0x77, 0x55, 0x53, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 
	0x99, 0x9A, 0xAA, 0xBB, 0xBC, 0xDD, 0xDD, 0xD4, 0xC6, 0x88, 0x88, 0x88, 0x88, 0x88, 0x5C, 0x40, 
	0x05, 0x33, 0x33, 0x55, 0x55, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x75, 0x55, 0x53, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0xAA, 0xBA, 0xAB, 0xBB, 0xBB, 0xBB, 
	0xBB, 0xBB, 0xAA, 0x99, 0x93, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x55, 0x55, 0x77, 0x77, 0x77, 
	0x77, 0x77, 0x77, 0x77, 0x77, 0x75, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x39, 0x99, 0xAA, 0xBA, 0xAB, 0xBB, 0xBB, 0xAC, 0xC7, 0x88, 0x88, 0x88, 0x88, 0x87, 0x6C, 0x00, 
	0x03, 0x6C, 0x58, 0x88, 0x88, 0x88, 0x88, 0x86, 0xC5, 0x77, 0x77, 0x77, 0x77, 0x75, 0x55, 0x53, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0xAA, 0xBA, 0xAB, 0xBB, 0xBB, 0xBB, 
	0xBB, 0xBB, 0xAA, 0x99, 0x93, 0x33, 0x33, 0x20, 0x05, 0x2C, 0xC7, 0x88, 0x88, 0x88, 0x88, 0x87, 
	0x6C, 0x77, 0x77, 0x77, 0x77, 0x75, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x39, 0x99, 0xAA, 0xBA, 0xAB, 0xBB, 0xBB, 0xBA, 0xC6, 0x88, 0x88, 0x88, 0x88, 0x88, 0x5C, 0x40, 
	0x05, 0x33, 0x33, 0x55, 0x55, 0x57, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x75, 0x37, 0x52, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x3A, 0x93, 0xAA, 0xAA, 0xAA, 0xBB, 0xBB, 0xBB, 
	0xBA, 0xBA, 0xA9, 0x99, 0x93, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x55, 0x55, 0x57, 0x77, 0x77, 
	0x77, 0x77, 0x77, 0x77, 0x77, 0x75, 0x37, 0x52, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x3A, 0x93, 0xAA, 0xAA, 0xAA, 0xBB, 0xBB, 0xAC, 0xC7, 0x88, 0x88, 0x88, 0x88, 0x87, 0x6C, 0x00, 
	0x03, 0x6C, 0x58, 0x88, 0x88, 0x88, 0x88, 0x86, 0xC5, 0x77, 0x77, 0x77, 0x77, 0x75, 0x37, 0x52, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x3A, 0x93, 0xAA, 0xAA, 0xAA, 0xBB, 0xBB, 0xBB, 
	0xBA, 0xBA, 0xA9, 0x99, 0x93, 0x33, 0x33, 0x20, 0x05, 0x2C, 0xC7, 0x88, 0x88, 0x88, 0x88, 0x87, 
	0x6C, 0x77, 0x77, 0x77, 0x77, 0x75, 0x37, 0x52, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x3A, 0x93, 0xAA, 0xAA, 0xAA, 0xBB, 0xBB, 0xB4, 0xC6, 0x88, 0x88, 0x88, 0x88, 0x88, 0x5C, 0x40, 
	0x05, 0x33, 0x33, 0x33, 0x55, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x55, 0x53, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 0x99, 0xAA, 0xBA, 0xAA, 0xBB, 0xBB, 
	0xAA, 0xBA, 0xA9, 0x99, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x55, 0x77, 0x77, 0x77, 
	0x77, 0x77, 0x77, 0x77, 0x77, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x99, 0x99, 0xAA, 0xBA, 0xAA, 0xBB, 0xAC, 0x67, 0x88, 0x88, 0x88, 0x88, 0x87, 0x6C, 0x00, 
	0x03, 0x6C, 0x58, 0x88, 0x88, 0x88, 0x88, 0x86, 0xC5, 0x77, 0x77, 0x77, 0x77, 0x55, 0x53, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x99, 0x99, 0xAA, 0xBA, 0xAA, 0xBB, 0xBB, 
	0xAA, 0xBA, 0xA9, 0x99, 0x33, 0x33, 0x33, 0x20, 0x05, 0x2C, 0x67, 0x88, 0x88, 0x88, 0x88, 0x87, 
	0x6C, 0x77, 0x77, 0x77, 0x77, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x99, 0x99, 0xAA, 0xBA, 0xAA, 0xBB, 0xB4, 0xC6, 0x88, 0x88, 0x88, 0x88, 0x88, 0x5C, 0x40, 
	0x05, 0x32, 0x33, 0x33, 0x25, 0x77, 0x57, 0x77, 0x77, 0x77, 0x77, 0x77, 0x75, 0x35, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x33, 0x99, 0xAA, 0xAA, 0xAA, 0xAB, 0xAA, 
	0xAA, 0xAA, 0xAA, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x32, 0x33, 0x33, 0x25, 0x77, 0x57, 0x77, 
	0x77, 0x77, 0x77, 0x77, 0x75, 0x35, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x93, 0x33, 0x99, 0xAA, 0xAA, 0xAA, 0xAB, 0xAC, 0xC9, 0x55, 0x55, 0x55, 0x55, 0x59, 0xCC, 0x00, 
	0x03, 0x6F, 0x95, 0x55, 0x55, 0x55, 0x55, 0x56, 0xC5, 0x77, 0x77, 0x77, 0x75, 0x35, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x33, 0x99, 0xAA, 0xAA, 0xAA, 0xAB, 0xAA, 
	0xAA, 0xAA, 0xAA, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x2C, 0xC9, 0x55, 0x55, 0x55, 0x55, 0x59, 
	0xCC, 0x57, 0x77, 0x77, 0x75, 0x35, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x93, 0x33, 0x99, 0xAA, 0xAA, 0xAA, 0xAB, 0xA4, 0xF6, 0x55, 0x55, 0x55, 0x55, 0x55, 0x9F, 0x40, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x35, 0x57, 0x57, 0x77, 0x77, 0x77, 0x75, 0x55, 0x55, 0x53, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x39, 0x99, 0x99, 0x9A, 0xAA, 0xAA, 0xAA, 
	0x9A, 0xA9, 0x93, 0x93, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x35, 0x57, 0x57, 
	0x77, 0x77, 0x77, 0x75, 0x55, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x39, 0x39, 0x99, 0x99, 0x9A, 0xAA, 0xAA, 0xA6, 0xFC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xF6, 0x00, 
	0x03, 0x9F, 0xFC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCF, 0xC5, 0x77, 0x77, 0x75, 0x55, 0x55, 0x53, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x39, 0x99, 0x99, 0x9A, 0xAA, 0xAA, 0xAA, 
	0x9A, 0xA9, 0x93, 0x93, 0x33, 0x33, 0x33, 0x20, 0x05, 0x26, 0xFC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 
	0xF6, 0x57, 0x77, 0x75, 0x55, 0x55, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x39, 0x39, 0x99, 0x99, 0x9A, 0xAA, 0xAA, 0xA4, 0xFF, 0xCC, 0xCC, 0xCC, 0xCC, 0xCC, 0xFF, 0x40, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x55, 0x55, 0x55, 0x57, 0x55, 0x55, 0x55, 0x35, 0x55, 0x35, 0x53, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x99, 0x93, 0x99, 0x99, 0x9A, 0xA9, 
	0x99, 0x99, 0x99, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x55, 0x55, 0x55, 
	0x57, 0x55, 0x55, 0x55, 0x35, 0x55, 0x35, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x39, 0x99, 0x99, 0x93, 0x99, 0x99, 0x9A, 0x44, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x64, 0x40, 
	0x03, 0x46, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x45, 0x75, 0x55, 0x55, 0x35, 0x55, 0x35, 0x53, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x39, 0x99, 0x99, 0x93, 0x99, 0x99, 0x9A, 0xA9, 
	0x99, 0x99, 0x99, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x34, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 
	0x64, 0x55, 0x55, 0x55, 0x35, 0x55, 0x35, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x39, 0x99, 0x99, 0x93, 0x99, 0x99, 0x9A, 0xA4, 0x46, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x00, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x32, 0x35, 0x53, 0x55, 0x53, 0x55, 0x53, 0x53, 0x35, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x99, 0x99, 0x99, 0x99, 0x99, 
	0x39, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x32, 0x35, 0x53, 
	0x55, 0x53, 0x55, 0x53, 0x53, 0x35, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x93, 0x99, 0x99, 0x99, 0x99, 0x94, 0x66, 0x66, 0x64, 0x44, 0x66, 0x66, 0x64, 0x40, 
	0x05, 0x96, 0x66, 0x66, 0x64, 0x46, 0x66, 0x66, 0x63, 0x53, 0x55, 0x53, 0x53, 0x35, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x99, 0x99, 0x99, 0x99, 0x99, 
	0x39, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x34, 0x66, 0x66, 0x64, 0x44, 0x66, 0x66, 
	0x64, 0x33, 0x55, 0x53, 0x53, 0x35, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x93, 0x99, 0x99, 0x99, 0x99, 0x94, 0x66, 0x66, 0x66, 0x44, 0x66, 0x66, 0x66, 0x40, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x35, 0x35, 0x55, 0x53, 0x53, 0x53, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x99, 0x99, 0x99, 0x93, 
	0x93, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x35, 
	0x35, 0x55, 0x53, 0x53, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x93, 0x99, 0x99, 0x99, 0x99, 0x44, 0x22, 0x0C, 0xC6, 0x42, 0x22, 0x23, 0x20, 
	0x05, 0x32, 0x22, 0x20, 0x6C, 0xC4, 0x22, 0x33, 0x35, 0x55, 0x53, 0x53, 0x53, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x99, 0x99, 0x99, 0x93, 
	0x93, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x32, 0x22, 0x22, 0x0C, 0xC6, 0x42, 0x33, 
	0x25, 0x55, 0x53, 0x53, 0x53, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x93, 0x99, 0x99, 0x99, 0x99, 0x44, 0x22, 0x44, 0xCC, 0x60, 0x22, 0x22, 0x90, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x35, 0x33, 0x55, 0x53, 0x55, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 0x39, 0x39, 
	0x93, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x35, 
	0x33, 0x55, 0x53, 0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 0x39, 0x39, 0x93, 0x33, 0xCE, 0xEE, 0xC2, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x36, 0xFE, 0xEF, 0x93, 0x35, 0x33, 0x55, 0x53, 0x55, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 0x39, 0x39, 
	0x93, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x32, 0xCE, 0xEE, 0xC3, 0x35, 
	0x53, 0x55, 0x53, 0x55, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x93, 0x39, 0x39, 0x39, 0x93, 0x33, 0x4F, 0xEE, 0xF9, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x35, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x35, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x34, 0xCF, 0xFF, 0xC4, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x26, 0xFF, 0xFF, 0x63, 0x33, 0x33, 0x33, 0x35, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x34, 0xCF, 0xFF, 0xC4, 0x33, 
	0x33, 0x33, 0x35, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x6F, 0xFF, 0xF6, 0x23, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x22, 0x22, 0x23, 0x33, 0x33, 0x20, 
	0x05, 0x33, 0x33, 0x32, 0x22, 0x22, 0x23, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x20, 0x05, 0x33, 0x33, 0x33, 0x22, 0x22, 0x23, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
	0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x32, 0x22, 0x22, 0x33, 0x33, 0x20, 
	0x03, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 
	0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 
	0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x40, 0x03, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 
	0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 
	0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x40, 
	0x03, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 
	0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 
	0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x40, 0x03, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 
	0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 
	0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x40, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
};

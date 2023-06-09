#include "../include.h"

// format: compressed 4-bit paletted pixel graphics
// image width: 131 pixels
// image height: 90 lines
// image pitch: 66 bytes
const u16 GridImg_Pal[16] __attribute__ ((aligned(4))) = {
	0xF79E, 0xAD75, 0x6B6D, 0x528A, 0x39E7, 0x39C7, 0x3186, 0x2965, 0x2124, 0x18E3, 0x10A2, 0x0861, 0x0841, 0x0020, 0x0000, 0x0000, 
};

const u8 GridImg[2988] __attribute__ ((aligned(4))) = {
	0x02, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0x21, 0x1F, 
	0xCC, 0x3F, 0x38, 0xEC, 0xC3, 0xF3, 0x8D, 0xBC, 0x3F, 0x53, 0xFC, 0xC3, 0xF4, 0x3F, 0xDC, 0x13, 
	0xAD, 0xC2, 0xA3, 0xAD, 0xC1, 0xA3, 0xDC, 0x3F, 0x34, 0xFC, 0xC3, 0xF3, 0x5F, 0xBC, 0x3D, 0x83, 
	0xFD, 0xC3, 0xF3, 0x6F, 0xBC, 0x2F, 0xA0, 0x11, 0x1E, 0xF1, 0x6A, 0xEF, 0x16, 0xAD, 0xF1, 0x97, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x6D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x17, 0x9D, 
	0xF1, 0xA6, 0xFF, 0x16, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x4A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA4, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x4A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA4, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x4A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA4, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x4A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA4, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x4A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA4, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x4A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA4, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA4, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA4, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x21, 0x19, 0xC4, 0x37, 0x23, 0x6D, 0x41, 0x36, 0xC4, 
	0x36, 0x22, 0x7C, 0x42, 0x63, 0x3E, 0x51, 0x24, 0xD5, 0x24, 0x24, 0xD5, 0x23, 0x36, 0xC4, 0x37, 
	0x22, 0x6C, 0x42, 0x63, 0x4C, 0x53, 0x63, 0x26, 0xC4, 0x36, 0x32, 0x6C, 0x42, 0x73, 0x02, 0x11, 
	0xFC, 0xA3, 0xC3, 0x7B, 0xCA, 0x2B, 0x49, 0xCA, 0x3C, 0x43, 0xCC, 0xA3, 0xC4, 0x4C, 0xDA, 0x13, 
	0x9E, 0xA0, 0x3E, 0xA1, 0x83, 0xDA, 0x3C, 0x34, 0xCC, 0xA3, 0xC4, 0x7B, 0xBA, 0x3B, 0x83, 0xBE, 
	0xA2, 0x38, 0xBB, 0xA2, 0xD8, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x4A, 0xDF, 0x18, 0x6E, 0xF1, 
	0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 0x1A, 
	0x4F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x4A, 0xDF, 0x18, 0x6E, 0xF1, 
	0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 0x1A, 
	0x4F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x4A, 0xDF, 0x18, 0x6E, 0xF1, 
	0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 0x1A, 
	0x4F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x4A, 0xDF, 0x18, 0x6E, 0xF1, 
	0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 0x1A, 
	0x4F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 0x6E, 0xF1, 
	0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 0x1A, 
	0x5F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 0x6E, 0xF1, 
	0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 0x1A, 
	0x5F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 0x6E, 0xF1, 
	0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 0x1A, 
	0x5F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 0x6E, 0xF1, 
	0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 0x1A, 
	0x5F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 0x6E, 0xF1, 
	0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 0x1A, 
	0x5F, 0xF1, 0x59, 0xDF, 0x1B, 0x02, 0x11, 0x9C, 0x43, 0x62, 0x35, 0xD4, 0x13, 0x6C, 0x43, 0x62, 
	0x27, 0xC4, 0x26, 0x33, 0xE5, 0x12, 0x4D, 0x52, 0x42, 0x4D, 0x52, 0x33, 0x6C, 0x43, 0x62, 0x26, 
	0xC4, 0x36, 0x34, 0x5B, 0x43, 0x53, 0x26, 0xC4, 0x35, 0x32, 0x6C, 0x42, 0x73, 0x02, 0x11, 0xFC, 
	0xA3, 0xD3, 0x8C, 0xCA, 0x3C, 0x49, 0xBB, 0xA3, 0xD5, 0x4E, 0xCA, 0x3D, 0x55, 0xDD, 0xB1, 0x3A, 
	0xDB, 0x2A, 0x3A, 0xDB, 0x29, 0x4B, 0xCA, 0x3E, 0x45, 0xDC, 0xA3, 0xE4, 0x7C, 0xCB, 0x28, 0x3C, 
	0xCA, 0x4B, 0xB3, 0x8C, 0xBA, 0x2F, 0x90, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x6E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x6E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x21, 0x19, 0xC4, 0x36, 0x23, 0x5D, 0x41, 0x36, 0xC4, 
	0x36, 0x22, 0x7C, 0x42, 0x63, 0x3E, 0x51, 0x24, 0xD5, 0x24, 0x24, 0xD5, 0x23, 0x36, 0xC4, 0x36, 
	0x22, 0x6C, 0x41, 0x63, 0xD4, 0x35, 0x32, 0x6C, 0x43, 0x53, 0x26, 0xC4, 0x27, 0x30, 0x21, 0x1F, 
	0xCC, 0x3F, 0x48, 0xDC, 0xC2, 0xE4, 0xAC, 0xC5, 0xF7, 0x4F, 0xCC, 0xAB, 0x3F, 0x65, 0xFD, 0xC1, 
	0x4A, 0xDC, 0x2B, 0x4B, 0xDC, 0x2A, 0x4C, 0xCB, 0x3F, 0x46, 0xFA, 0xB5, 0xCC, 0xF5, 0x8F, 0xBC, 
	0x3D, 0x94, 0xED, 0xC3, 0xE4, 0x9D, 0xBC, 0x2F, 0xA0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 
	0xF1, 0x86, 0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 
	0x16, 0x8D, 0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 
	0xF1, 0x86, 0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 
	0x16, 0x8D, 0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 
	0xF1, 0x86, 0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 
	0x16, 0x8D, 0xF1, 0xA5, 0xFF, 0x16, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 
	0xF1, 0x86, 0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 
	0x16, 0x8D, 0xF1, 0xA5, 0xFF, 0x16, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 
	0xF1, 0x86, 0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 
	0x16, 0x8D, 0xF1, 0xA5, 0xFF, 0x16, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 
	0xF1, 0x86, 0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 
	0x16, 0x8D, 0xF1, 0xA5, 0xFF, 0x16, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 
	0xF1, 0x86, 0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 
	0x16, 0x8D, 0xF1, 0xA5, 0xFF, 0x16, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 
	0xF1, 0x86, 0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 
	0x16, 0x8D, 0xF1, 0xA5, 0xFF, 0x16, 0x9D, 0xF1, 0xB0, 0x21, 0x1F, 0xCD, 0x3F, 0x49, 0xFC, 0xD3, 
	0xF5, 0xAF, 0xBD, 0x3F, 0x85, 0xFC, 0xD3, 0xF7, 0x6F, 0xDD, 0x24, 0xBE, 0xBD, 0x4E, 0xC4, 0xCE, 
	0xBD, 0x2E, 0xB4, 0xDD, 0x3F, 0x67, 0xFC, 0xD3, 0xF6, 0x8F, 0xBD, 0x3F, 0xA4, 0xFD, 0xD3, 0xF5, 
	0x9F, 0xBD, 0x2F, 0xA0, 0x21, 0x19, 0xC4, 0x37, 0x23, 0x5D, 0x41, 0x36, 0xC4, 0x36, 0x22, 0x7C, 
	0x42, 0x63, 0x3E, 0x51, 0x24, 0xD5, 0x24, 0x24, 0xD5, 0x23, 0x36, 0xC4, 0x36, 0x22, 0x6C, 0x42, 
	0x63, 0x4A, 0x55, 0x44, 0x53, 0x26, 0xC4, 0x35, 0x32, 0x7C, 0x42, 0x73, 0x02, 0x11, 0xFC, 0xD3, 
	0xF4, 0x9F, 0xCD, 0x3F, 0x5A, 0xFB, 0xD3, 0xF8, 0x5F, 0xCD, 0x3F, 0x76, 0xFD, 0xD2, 0x4B, 0xEB, 
	0xD4, 0xEC, 0x4C, 0xEB, 0xD2, 0xEB, 0x4D, 0xD3, 0xF6, 0x7F, 0xCD, 0x3F, 0x68, 0xFB, 0xD3, 0xFA, 
	0x4F, 0xDD, 0x3F, 0x59, 0xFB, 0xD2, 0xFA, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 
	0x6E, 0xF1, 0x87, 0xEF, 0x15, 0xCD, 0xF2, 0xD5, 0xDD, 0xF1, 0xC5, 0xEF, 0x17, 0x8E, 0xF1, 0x68, 
	0xDF, 0x1A, 0x5F, 0xF1, 0x69, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 
	0x6E, 0xF1, 0x87, 0xEF, 0x15, 0xCD, 0xF2, 0xD5, 0xDD, 0xF1, 0xC5, 0xEF, 0x17, 0x8E, 0xF1, 0x68, 
	0xDF, 0x1A, 0x5F, 0xF1, 0x69, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 
	0x6E, 0xF1, 0x87, 0xEF, 0x15, 0xCD, 0xF2, 0xD5, 0xDD, 0xF1, 0xC5, 0xEF, 0x17, 0x8E, 0xF1, 0x68, 
	0xDF, 0x1A, 0x5F, 0xF1, 0x69, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 
	0x6E, 0xF1, 0x87, 0xEF, 0x15, 0xCD, 0xF2, 0xD5, 0xDD, 0xF1, 0xC5, 0xEF, 0x17, 0x8E, 0xF1, 0x68, 
	0xDF, 0x1A, 0x5F, 0xF1, 0x69, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 
	0x6E, 0xF1, 0x87, 0xEF, 0x15, 0xCD, 0xF2, 0xD5, 0xDD, 0xF1, 0xC5, 0xEF, 0x17, 0x8E, 0xF1, 0x68, 
	0xDF, 0x1A, 0x5F, 0xF1, 0x69, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 
	0x6E, 0xF1, 0x87, 0xEF, 0x15, 0xCD, 0xF2, 0xD5, 0xDD, 0xF1, 0xC5, 0xEF, 0x17, 0x8E, 0xF1, 0x68, 
	0xDF, 0x1A, 0x5F, 0xF1, 0x69, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 
	0x6E, 0xF1, 0x87, 0xEF, 0x15, 0xCD, 0xF2, 0xD5, 0xDD, 0xF1, 0xC5, 0xEF, 0x17, 0x8E, 0xF1, 0x68, 
	0xDF, 0x1A, 0x5F, 0xF1, 0x69, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 
	0x6E, 0xF1, 0x87, 0xEF, 0x15, 0xCD, 0xF2, 0xD5, 0xDD, 0xF1, 0xC5, 0xEF, 0x17, 0x8E, 0xF1, 0x68, 
	0xDF, 0x1A, 0x5F, 0xF1, 0x59, 0xDF, 0x1B, 0x02, 0x11, 0xFC, 0xC3, 0xF4, 0x9D, 0xCC, 0x2E, 0x4A, 
	0xCC, 0x3F, 0x74, 0xFC, 0xC3, 0xF7, 0x5F, 0xDC, 0x14, 0xAD, 0xC2, 0xB4, 0xBD, 0xC1, 0xA4, 0xDC, 
	0x3F, 0x46, 0xFC, 0xC3, 0xF5, 0x8F, 0xBC, 0x3D, 0x94, 0xFD, 0xC3, 0xE4, 0x9E, 0xBC, 0x2F, 0xA0, 
	0x21, 0x19, 0xC4, 0x36, 0x23, 0x5D, 0x41, 0x36, 0xC4, 0x36, 0x22, 0x7C, 0x42, 0x63, 0x3E, 0x51, 
	0x24, 0xD5, 0x24, 0x24, 0xD5, 0x23, 0x36, 0xC4, 0x36, 0x22, 0x6C, 0x41, 0x63, 0xD4, 0x35, 0x32, 
	0x6C, 0x43, 0x53, 0x26, 0xC4, 0x27, 0x30, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x6E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x15, 0xAD, 0xF1, 0x86, 
	0xEF, 0x18, 0x6E, 0xF1, 0x5C, 0xDF, 0x2D, 0x5D, 0xDF, 0x1C, 0x5E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 
	0xF1, 0xA5, 0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x21, 0x1A, 0xC6, 0x38, 0x23, 0x7D, 0x61, 0x36, 0xC5, 
	0x37, 0x32, 0x8C, 0x53, 0x73, 0x37, 0xD6, 0x22, 0x57, 0xC6, 0x25, 0x25, 0xC6, 0x37, 0x43, 0x7C, 
	0x53, 0x82, 0x37, 0xC5, 0x27, 0x34, 0xC6, 0x37, 0x42, 0x8C, 0x63, 0x74, 0x27, 0xC6, 0x28, 0x30, 
	0x21, 0x1E, 0xC8, 0x3A, 0x34, 0x9D, 0x80, 0x3D, 0x83, 0x93, 0x3A, 0xC8, 0x39, 0x34, 0x9D, 0x81, 
	0x37, 0xE8, 0x03, 0xE8, 0x26, 0x39, 0xC8, 0x3A, 0x33, 0x9C, 0x83, 0x93, 0x59, 0xB8, 0x39, 0x53, 
	0x9C, 0x82, 0x97, 0x3D, 0x82, 0xA4, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 0x6E, 
	0xF1, 0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 
	0x1A, 0x5F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 0x6E, 
	0xF1, 0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 
	0x1A, 0x5F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 0x6E, 
	0xF1, 0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 
	0x1A, 0x5F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 0x6E, 
	0xF1, 0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 
	0x1A, 0x5F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x5A, 0xDF, 0x18, 0x6E, 
	0xF1, 0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 
	0x1A, 0x5F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x4A, 0xDF, 0x18, 0x6E, 
	0xF1, 0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 
	0x1A, 0x4F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x4A, 0xDF, 0x18, 0x6E, 
	0xF1, 0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 
	0x1A, 0x4F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x4A, 0xDF, 0x18, 0x6E, 
	0xF1, 0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 
	0x1A, 0x4F, 0xF1, 0x59, 0xDF, 0x1B, 0x01, 0x11, 0xEF, 0x15, 0xAE, 0xF1, 0x4A, 0xDF, 0x18, 0x6E, 
	0xF1, 0x86, 0xEF, 0x14, 0xCD, 0xF2, 0xD4, 0xDD, 0xF1, 0xC4, 0xEF, 0x16, 0x8E, 0xF1, 0x68, 0xDF, 
	0x1A, 0x4F, 0xF1, 0x59, 0xDF, 0x1B, 0x02, 0x11, 0xFC, 0xA3, 0xC3, 0x7B, 0xCA, 0x2B, 0x49, 0xCA, 
	0x3C, 0x43, 0xCC, 0xA3, 0xC4, 0x4C, 0xDA, 0x13, 0x9E, 0xA0, 0x3E, 0xA1, 0x83, 0xDA, 0x3C, 0x34, 
	0xCC, 0xA3, 0xC4, 0x7B, 0xBA, 0x3B, 0x83, 0xBE, 0xA2, 0x38, 0xBB, 0xA2, 0xD8, 0x02, 0x11, 0x9C, 
	0x43, 0x72, 0x36, 0xD4, 0x13, 0x6C, 0x43, 0x62, 0x27, 0xC4, 0x26, 0x33, 0xE5, 0x12, 0x4D, 0x52, 
	0x42, 0x4D, 0x52, 0x33, 0x6C, 0x43, 0x72, 0x26, 0xC4, 0x26, 0x34, 0xC5, 0x36, 0x32, 0x6C, 0x43, 
	0x63, 0x26, 0xC4, 0x27, 0x30, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 0xEF, 0x18, 
	0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 0xF1, 0xA4, 
	0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x5A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 0xEF, 0x18, 
	0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 0xF1, 0xA4, 
	0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x4A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 0xEF, 0x18, 
	0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 0xF1, 0xA4, 
	0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x4A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 0xEF, 0x18, 
	0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 0xF1, 0xA4, 
	0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x4A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 0xEF, 0x18, 
	0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 0xF1, 0xA4, 
	0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x4A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 0xEF, 0x18, 
	0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 0xF1, 0xA4, 
	0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x4A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 0xEF, 0x18, 
	0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 0xF1, 0xA4, 
	0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x4A, 0xEF, 0x14, 0xAD, 0xF1, 0x86, 0xEF, 0x18, 
	0x6E, 0xF1, 0x4C, 0xDF, 0x2D, 0x4D, 0xDF, 0x1C, 0x4E, 0xF1, 0x68, 0xEF, 0x16, 0x8D, 0xF1, 0xA4, 
	0xFF, 0x15, 0x9D, 0xF1, 0xB0, 0x11, 0x1E, 0xF1, 0x6A, 0xEF, 0x16, 0xAD, 0xF1, 0x97, 0xEF, 0x18, 
	0x7E, 0xF1, 0x5C, 0xDF, 0x2D, 0x6D, 0xDF, 0x1C, 0x5E, 0xF1, 0x78, 0xEF, 0x17, 0x9D, 0xF1, 0xA6, 
	0xFF, 0x16, 0x9D, 0xF1, 0xB0, 0x21, 0x1F, 0xCC, 0x3F, 0x38, 0xEC, 0xC3, 0xF3, 0x8D, 0xBC, 0x3F, 
	0x53, 0xFC, 0xC3, 0xF4, 0x3F, 0xDC, 0x13, 0xAD, 0xC2, 0xA3, 0xAD, 0xC1, 0xA3, 0xDC, 0x3F, 0x34, 
	0xFC, 0xC3, 0xF3, 0x5F, 0xBC, 0x3D, 0x83, 0xFD, 0xC3, 0xF3, 0x6F, 0xBC, 0x2F, 0xA0, 0x02, 0xF0, 
	0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 
};

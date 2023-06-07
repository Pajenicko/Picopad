
// === QVGA display
#ifndef USE_QVGA
#define USE_QVGA	1		// use QVGA display (qvga.c, qvga.h)
#endif

#ifndef USE_QDRAW
#define USE_QDRAW	0		// use QVGA drawing (lib_qdraw.c, lib_qdraw.h)
#endif

#ifndef WIDTH
#define WIDTH	320			// display width
#endif

#ifndef HEIGHT
#define HEIGHT	240			// display height
#endif

#ifndef FRAMESIZE
#define FRAMESIZE (WIDTH*HEIGHT) 	// frame size in number of colors
#endif

#ifndef QVGA_GPIO_FIRST
#define QVGA_GPIO_FIRST	2		// first VGA GPIO
#endif

#ifndef QVGA_GPIO_NUM
#define QVGA_GPIO_NUM	8		// number of VGA color GPIOs, without HSYNC and VSYNC
#endif

#ifndef QVGA_GPIO_LAST
#define QVGA_GPIO_LAST	(QVGA_GPIO_FIRST+QVGA_GPIO_NUM-1) // last VGA GPIO
#endif

#ifndef QVGA_GPIO_HSYNC
#define QVGA_GPIO_HSYNC	10		// VGA HSYNC GPIO
#endif

#ifndef QVGA_GPIO_VSYNC
#define QVGA_GPIO_VSYNC	(QVGA_GPIO_HSYNC+1) // VGA VSYNC GPIO (QVGA requires VSYNC = HSYNC+1)
#endif

#ifndef QVGA_PIO
#define QVGA_PIO	0		// VGA PIO
#endif

#ifndef QVGA_SM
#define QVGA_SM		0		// VGA state machine of base layer 0
#endif

#ifndef QVGA_DMA
#define QVGA_DMA	8		// QVGA DMA base channel (QVGA requires 2 DMA channels)
#endif

#ifndef QVGA_DMA_CB
#define QVGA_DMA_CB	(QVGA_DMA+0)	// VGA DMA channel - control block of base layer
#endif

#ifndef QVGA_DMA_PIO
#define QVGA_DMA_PIO	(QVGA_DMA+1)	// VGA DMA channel - copy data of base layer to PIO (raises IRQ0 on quiet)
#endif

// keyboard
#ifndef USE_KEY56
#define USE_KEY56	1		// use keyboard 56 keys serial (key56.c, key56.h)
#endif

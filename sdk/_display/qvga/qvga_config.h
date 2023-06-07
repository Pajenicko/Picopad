
// ****************************************************************************
//
//                                    QVGA configuration
//
// ****************************************************************************

// QVGA horizonal timings
#define QVGA_CLKDIV	2	// SM divide clock ticks
#define QVGA_CPP	5	// state machine clock ticks per pixel
#define QVGA_SYSCPP	(QVGA_CLKDIV*QVGA_SMCPP) // system clock ticks per pixel (=10)

// 126 MHz timings
#define QVGA_VCO	(1008*1000*1000) // PLL VCO frequency in Hz
#define QVGA_FBDIV	84	// PLL FBDIV
#define QVGA_PD1	4	// PLL PD1
#define QVGA_PD2	2	// PLL PD2
#define QVGA_TOTAL	2002	// total clock ticks (= QVGA_HSYNC + QVGA_BP + WIDTH*QVGA_CPP[1600] + QVGA_FP)
#define QVGA_HSYNC	240	// horizontal sync clock ticks
#define QVGA_BP		121	// back porch clock ticks
#define QVGA_FP		41	// front porch clock ticks

// QVGA vertical timings
#define QVGA_VTOT	525	// total scanlines (= QVGA_VSYNC + QVGA_VBACK + QVGA_VACT + QVGA_VFRONT)
#define QVGA_VSYNC	2	// length of V sync (number of scanlines)
#define QVGA_VBACK	33	// V back porch
#define QVGA_VACT	480	// V active scanlines (= 2*HEIGHT)
#define QVGA_VFRONT	10	// V front porch

// default timings (125 MHz)
#define QVGA_DEF_VCO	(1500*1000*1000) // PLL VCO frequency in Hz
#define QVGA_DEF_FBDIV	125	// PLL FBDIV
#define QVGA_DEF_PD1	4	// PLL PD1
#define QVGA_DEF_PD2	3	// PLL PD2

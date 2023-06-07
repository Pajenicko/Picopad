
// ****************************************************************************
//                                 
//                              All Includes
//
// ****************************************************************************

// globals
#include "global.h"			// globals

// SDK
#include "_sdk/_include.h"		// SDK includes

// library
#include "_lib/_include.h"		// library includes

// big interers
#include "_lib/bigint/bigint.h"		// big integers

// real numbers
#if USE_REAL	// use real numbers
#define REAL_PATH	"real_h.h"
#include "_lib/real/real.h"		// all real numbers
#endif // USE_REAL

// fonts
#include "_font/_include.h"

// devices
#if USE_PICOINO			// use Picoino device configuration
//#include "_devices/picoino/_include.h"
#endif

#if USE_PICOINO_LOADER		// use Picoino-loader device configuration
//#include "_devices/picoino_loader/_include.h"
#endif

#if USE_PICOPAD		// use PicoPad device configuration
#include "_devices/picopad/_include.h"
#endif

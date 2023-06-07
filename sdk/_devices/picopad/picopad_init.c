
// ****************************************************************************
//
//                              PicoPad Init
//
// ****************************************************************************

#include "../../global.h"	// globals
#include "../../_lib/inc/lib_pwmsnd.h"
#include "../../_display/st7789/st7789.h"
#include "../../_lib/inc/lib_fat.h"
#include "../../_lib/inc/lib_sd.h"
#include "picopad_bat.h"
#include "picopad_key.h"
#include "picopad_led.h"
#include "picopad_spk.h"

// Device init
void DeviceInit()
{
	// initialize LEDs
	LedInit();

	// initialize display
	DispInit(1);

	// initilize keys
	KeyInit();

	// init battery measurement
	BatInit();

#if USE_PWMSND		// use PWM sound output; set 1.. = number of channels (lib_pwmsnd.c, lib_pwmsnd.h)
	// initialize PWM sound output (must be re-initialized after changing CLK_SYS system clock)
	PWMSndInit();
#endif

#if USE_SD		// use SD card (lib_sd.c, lib_sd.h)
	// initialize SD card interface (must be re-initialized after changing system clock)
	SDInit();
#endif
}

// Device terminate
void DeviceTerm()
{
	// terminate LEDs
	LedTerm();

	// terminate display
	DispTerm();

	// terminate keys
	KeyTerm();

	// terminate battery measurement
	BatTerm();

#if USE_PWMSND	// use PWM sound output; set 1.. = number of channels (lib_pwmsnd.c, lib_pwmsnd.h)
	// terminate PWM sound output
	PWMSndTerm();
#endif

#if USE_SD		// use SD card (lib_sd.c, lib_sd.h)
	// terminate SD card interface
	SDTerm();
#endif
}

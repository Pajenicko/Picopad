
// ****************************************************************************
//
//                               Device configuration
//
// ****************************************************************************
// PicoLibSDK - Alternative SDK library for Raspberry Pico and RP2040
// Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz, hardyplotter2@gmail.com
// 	https://github.com/Panda381/PicoLibSDK
//	https://www.breatharian.eu/hw/picolibsdk/index_en.html
//	https://github.com/pajenicko/picopad
//	https://picopad.eu/en/
// License:
//	This source code is freely available for any purpose, including commercial.
//	It is possible to take and modify the code or parts of it, without restriction.

#if USE_CONFIG			// use device configuration (lib_config.c, lib_config.h)

#ifndef _LIB_CONFIG_H
#define _LIB_CONFIG_H

#ifdef __cplusplus
extern "C" {
#endif

//#define FLASH_PAGE_SIZE (1u << 8)	// Flash page size 256 B (to program)
//#define FLASH_SECTOR_SIZE (1u << 12)	// Flash sector size 4 KB (to erase)

#define CONFIG_ADDR	((const sConfig*)0x101FF000) // configuration base address
#define CONFIG_FLASH_OFF ((u32)CONFIG_ADDR - XIP_BASE) // configuration offset in flash memory
#define CONFIG_TOTAL_SIZE FLASH_SECTOR_SIZE	// total size of configuration array (= 4096)
#define CONFIG_SIZE	32		// size of configuration structure 32 B (must be power of 2!)
#define CONFIG_PER_PAGE	(FLASH_PAGE_SIZE/CONFIG_SIZE) // number of configuration structures per flash page (= 8)
#define CONFIG_NUM	(CONFIG_TOTAL_SIZE/CONFIG_SIZE) // total number of configuration structures (= 128)

#define CONFIG_VOLUME_STEP	10		// sound volume steps per level
#define CONFIG_VOLUME_FULL	10		// sound volume default level (100% full volume)
#define CONFIG_VOLUME_FULLSTEP	(CONFIG_VOLUME_FULL*CONFIG_VOLUME_STEP) // full volume in steps
#define CONFIG_VOLUME_MAX	25		// max. sound volume level

#define CONFIG_BACKLIGHT_MIN	1		// minimal backlight after loading configuration
#define CONFIG_BACKLIGHT_MAX	8		// max. backlight level

#define CONFIG_BATTERY_FULL_MAX	5500		// max. voltage of full battery in [mV]
#define CONFIG_BATTERY_EMPTY_MIN 1800		// min. voltage of empty battery in [mV]
#define CONFIG_BATTERY_DIODE_MIN 0		// min. voltage drop on diode in [mV]
#define CONFIG_BATTERY_DIODE_MAX 2000		// max. voltage drop on diode in [mV]

#define CONFIG_ADC_REF_MIN	2400		// min. ADC reference
#define CONFIG_ADC_REF_MAX	4200		// max. ADC reference

#define CONFIG_TEMP_BASE_MIN	0.69f		// min. temperature base voltage at 27�C
#define CONFIG_TEMP_BASE_MAX	0.72f		// max. temperature base voltage at 27�C
#define CONFIG_TEMP_SLOPE_MIN	0.0015f		// min. temperature slope - voltage per 1 degree
#define CONFIG_TEMP_SLOPE_MAX	0.0019f		// max. temperature slope - voltage per 1 degree

// Datasheet: 12MHz crystal with 30ppm tolerance (= 11999640 to 12000360, variation +- 360 Hz)
#define CONFIG_CRYSTAL_MIN	11998000	// min. crystal frequency (tolerance 167 ppm)
#define CONFIG_CRYSTAL_MAX	12002000	// max. crystal frequency (tolerance 167 ppm)

// configuration structure (pay attention to correct alignment of structure members!)
typedef struct {
	// 32-bit aligned
	u16	crc;		// 0: checksum Crc16AFast (CRC-16 CCITT normal)
	u8	volume;		// 2: sound volume percentage 0..255, level 0..25 (0..250%) in multiply of 10 (default 100% = 10*10 = 100 = CONFIG_VOLUME_FULLSTEP)
	u8	backlight;	// 3: display backlight 0..255 (default 255), level 0..8 (values 0, 1, 3, 7, 15, 31, 63, 127, 255)
	// 32-bit aligned
	u16	bat_full;	// 4: voltage of full battery in [mV] (default BATTERY_FULL_INT = 4200)
	u16	bat_empty;	// 6: voltage of empty batter in [mV] (default BATTERY_EMPTY_INT = 3100)
	// 32-bit aligned
	u16	bat_diode;	// 8: voltage drop on diode in [mV] (default BAT_DIODE_FV_INT = 311)
	u16	adc_ref;	// 10: ADC reference voltage in [mV] (default ADC_UREF_INT = 3300)
	// 32-bit aligned
	float	temp_base;	// 12: temperature base voltage at 27�C (default TEMP_BASE = 0.70600f)
	// 32-bit aligned
	float	temp_slope;	// 16: temperature slope - voltage per 1 degree (default TEMP_SLOPE = 0.001721f)
	// 32-bit aligned
	u32	crystal;	// 20: crystal frequency in [Hz] (default 12000000) ... value (u32)-1 indicates invalid config
	// 32-bit aligned
	u8	stuffing[CONFIG_SIZE-24]; // 24: (8) alignment to page size (default value 0xff)
} sConfig;

// compile-time check
STATIC_ASSERT(sizeof(sConfig) == CONFIG_SIZE, "Incorrect sConfig structure alignment!");

// current configuration
extern sConfig Config;

// calculate CRC of the config structure
u16 ConfigGetCRC(const sConfig* cfg);

// set configuration structure to default values
void ConfigSetDef(sConfig* cfg);

// clear configuration memory
void ConfigClear();

// load configuration from flash (set to default if not found; returns configuration index or -1 if not found)
int ConfigLoad();

// save configuration
//  If core 1 is running, lockout it or reset it! If VGA driver is running, stop it!
void ConfigSave();

// === Volume

// get sound volume level (returns 0..CONFIG_VOLUME_MAX)
INLINE u8 ConfigGetVolume() { return (u8)(Config.volume / CONFIG_VOLUME_STEP); }

// set sound volume level 0..CONFIG_VOLUME_MAX (limits range, updates playing sound, does not save configuration)
void ConfigSetVolume(int volume);

// increase sound volume level (limits range, updates playing sound, does not save configuration)
void ConfigIncVolume();

// decrease sound volume level (limits range, updates playing sound, does not save configuration)
void ConfigDecVolume();

// === Backlight

// get backlight level (returns 0..CONFIG_BACKLIGHT_MAX)
INLINE u8 ConfigGetBacklight() { return Order(Config.backlight); }

// set backlight level 0..CONFIG_BACKLIGHT_MAX (limts range, updated backlight, does not save configuration)
void ConfigSetBacklight(int backlight);

// increase backlight (limts range, updated backlight, does not save configuration)
void ConfigIncBacklight();

// decrease backlight (limts range, updated backlight, does not save configuration)
void ConfigDecBacklight();

// === Battery

// get voltage of full battery in [mV]
INLINE u16 ConfigGetBatFullInt() { return Config.bat_full; }

// get voltage of full battery in [V]
float ConfigGetBatFull();

// set voltage of full battery in [mV] (limits range, does not save configuration)
void ConfigSetBatFullInt(int mv);

// increase voltage of full battery (limits range, does not save configuration)
void ConfigIncBatFull();

// decrease voltage of full battery (limits range, does not save configuration)
void ConfigDecBatFull();

// get voltage of empty battery in [mV]
INLINE u16 ConfigGetBatEmptyInt() { return Config.bat_empty; }

// get voltage of empty battery in [V]
float ConfigGetBatEmpty();

// set voltage of empty battery in [mV] (limits range, does not save configuration)
void ConfigSetBatEmptyInt(int mv);

// increase voltage of empty battery (limits range, does not save configuration)
void ConfigIncBatEmpty();

// decrease voltage of empty battery (limits range, does not save configuration)
void ConfigDecBatEmpty();

// get voltage drop on diode in [mV]
INLINE u16 ConfigGetBatDiodeInt() { return Config.bat_diode; }

// get voltage drop on diode in [V]
float ConfigGetBatDiode();

// set voltage drop on diode in [mV] (limits range, does not save configuration)
void ConfigSetBatDiodeInt(int mv);

// increase voltage drop on diode (limits range, does not save configuration)
void ConfigIncBatDiode();

// decrease voltage drop on diode (limits range, does not save configuration)
void ConfigDecBatDiode();

// === ADC

// get ADC reference in [mV]
INLINE u16 ConfigGetAdcRefInt() { return Config.adc_ref; }

// get ADC reference in [V]
float ConfigGetAdcRef();

// set ADC reference in [mV] (limits range, does not save configuration)
void ConfigSetAdcRefInt(int mv);

// increase ADC reference (limits range, does not save configuration)
void ConfigIncAdcRef();

// decrease ADC reference (limits range, does not save configuration)
void ConfigDecAdcRef();

// === Temperature

// get temperature base voltage at 27�C
INLINE float ConfigGetTempBase() { return Config.temp_base; }

// set temperature base voltage at 27�C (limits range, does not save configuration)
void ConfigSetTempBase(float mv);

// increase temperature base voltage at 27�C (limits range, does not save configuration)
void ConfigIncTempBase();

// decrease temperature base voltage at 27�C (limits range, does not save configuration)
void ConfigDecTempBase();

// get temperature slope - voltage per 1 degree
INLINE float ConfigGetTempSlope() { return Config.temp_slope; }

// set temperature slope - voltage per 1 degree (limits range, does not save configuration)
void ConfigSetTempSlope(float mv);

// increase temperature slope - voltage per 1 degree (limits range, does not save configuration)
void ConfigIncTempSlope();

// decrease temperature slope - voltage per 1 degree (limits range, does not save configuration)
void ConfigDecTempSlope();

// === Crystal

// get crystal in Hz
INLINE u32 ConfigGetCrystal() { return Config.crystal; }

// set crystal in Hz (limits range, does not save configuration)
void ConfigSetCrystal(u32 hz);

// increase crystal (limits range, does not save configuration)
void ConfigIncCrystal();

// decrease crystal (limits range, does not save configuration)
void ConfigDecCrystal();

#ifdef __cplusplus
}
#endif

#endif // _LIB_CONFIG_H

#endif // USE_CONFIG		// use device configuration (lib_config.c, lib_config.h)

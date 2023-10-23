
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

#include "picopad.h"	// globals

#if USE_CONFIG			// use device configuration (lib_config.c, lib_config.h)

#include "sdk_flash.h"

// current configuration
sConfig Config;

// calculate CRC of the config structure
u16 ConfigGetCRC(const sConfig* cfg)
{
	return Crc16AFast((const u8*)cfg + 2, CONFIG_SIZE - 2);
}

// set configuration structure to default values
void ConfigSetDef(sConfig* cfg)
{
	memset(cfg, 0xff, CONFIG_SIZE);
	cfg->volume = CONFIG_VOLUME_FULLSTEP;	// sound volume percentage 0..255, steps 0..25 (0..250%) in multiply of 10 (default 100% = 10*10 = 100)
	cfg->backlight = 255;			// display backlight 0..255 (default 255)
	cfg->bat_full = BATTERY_FULL_INT;	// voltage of full battery in [mV] (default BATTERY_FULL_INT = 4200)
	cfg->bat_empty = BATTERY_EMPTY_INT;	// voltage of empty batter in [mV] (default BATTERY_EMPTY_INT = 3100)
	cfg->bat_diode = BAT_DIODE_FV_INT;	// voltage drop on diode in [mV] (default BAT_DIODE_FV_INT = 311)
	cfg->adc_ref = ADC_UREF_INT;		// ADC reference voltage in [mV] (default ADC_UREF_INT = 3300)
	cfg->temp_base = TEMP_BASE;		// temperature base voltage at 27�C (default TEMP_BASE = 0.706f)
	cfg->temp_slope = TEMP_SLOPE;		// temperature slope - voltage per 1 degree (default TEMP_SLOPE = 0.001721f)
	cfg->crystal = 12000000;		// crystal frequency in [Hz] (default 12000000)
}

// clear configuration memory
void ConfigClear()
{
	FlashErase(CONFIG_FLASH_OFF, FLASH_SECTOR_SIZE);
}

// load configuration from flash (set to default if not found; returns configuration index or -1 if not found)
int ConfigLoad()
{
	// set configuration to default values
	ConfigSetDef(&Config);

	// find last valid configuration
	int i = CONFIG_NUM-1;
	const sConfig* cfg = &CONFIG_ADDR[i];
	for (; i >= 0; i--)
	{
		// check config validity
		if ((cfg->crystal != (u32)-1) && (ConfigGetCRC(cfg) == cfg->crc))
		{
			// copy configuration
			memcpy(&Config, cfg, CONFIG_SIZE);

			// check minimal backlight (to avoid dark screen)
			if (Config.backlight < CONFIG_BACKLIGHT_MIN) Config.backlight = CONFIG_BACKLIGHT_MIN;
			break;
		}
		cfg--;
	}
	return i;
}

// save configuration
//  If core 1 is running, lockout it or reset it! If VGA driver is running, stop it!
void ConfigSave()
{
	// forbidden crystal value
	if (Config.crystal == (u32)-1) Config.crystal = (u32)-2;

	// calculate CRC
	Config.crc = ConfigGetCRC(&Config);

	// buffer to load one flash page
	sConfig c[CONFIG_PER_PAGE];

	// find last unused config entry
	int i = CONFIG_NUM-1;
	int ok = -1;
	const sConfig* cfg = &CONFIG_ADDR[i];
	int j;
	for (; i >= 0; i--)
	{
		// check if config is not used (all bytes must be 0xff)
		for (j = 0; j < CONFIG_SIZE/4; j++) if (((const u32*)cfg)[j] != (u32)-1) break;

		// config is empty
		if (j == CONFIG_SIZE/4)
			ok = i;
		else
			break;

		cfg--;
	}

	// free entry not found, clear flash page
	if (ok < 0)
	{
		ConfigClear();
		ok = 0;
	}

	// base index of whole page
	i = ok & ~(CONFIG_PER_PAGE-1);

	// load whole page
	memcpy(c, &CONFIG_ADDR[i], FLASH_PAGE_SIZE);

	// update config
	memcpy(&c[ok - i], &Config, CONFIG_SIZE);

	// write page
	FlashProgram((u32)&CONFIG_ADDR[i] - XIP_BASE, (const u8*)c, FLASH_PAGE_SIZE);
}

// === Volume

// set sound volume level 0..CONFIG_VOLUME_MAX (limits range, updates playing sound, does not save configuration)
void ConfigSetVolume(int volume)
{
	// rescale
	volume *= CONFIG_VOLUME_STEP;

	// limit range
	if (volume < 0) volume = 0;
	if (volume > 255) volume = 255;

	// set config
	Config.volume = (u8)volume;

#if USE_PWMSND		// use PWM sound output; set 1.. = number of channels (lib_pwmsnd.c, lib_pwmsnd.h)
	// update playing sound
	GlobalVolumeUpdate();
#endif
}

// increase sound volume level (limits range, updates playing sound, does not save configuration)
void ConfigIncVolume()
{
	ConfigSetVolume(ConfigGetVolume() + 1);
}

// decrease sound volume level (limits range, updates playing sound, does not save configuration)
void ConfigDecVolume()
{
	ConfigSetVolume(ConfigGetVolume() - 1);
}

// === Backlight

// set backlight level 0..CONFIG_BACKLIGHT_MAX (limts range, updated backlight, does not save configuration)
void ConfigSetBacklight(int backlight)
{
	// limit range
	if (backlight < 0) backlight = 0;
	if (backlight > 8) backlight = 8;

	// rescale
	backlight = (1 << backlight) - 1;

	// set config
	Config.backlight = backlight;

#if USE_ST7789		// use ST7789 TFT display (st7789.c, st7789.h)
	// display backlight control config update
	DispBacklightUpdate();
#endif
}

// increase backlight (limts range, updated backlight, does not save configuration)
void ConfigIncBacklight()
{
	ConfigSetBacklight(ConfigGetBacklight() + 1);
}

// decrease backlight (limts range, updated backlight, does not save configuration)
void ConfigDecBacklight()
{
	ConfigSetBacklight(ConfigGetBacklight() - 1);
}

// === Battery

// get voltage of full battery in [V]
float ConfigGetBatFull()
{
	return Config.bat_full * 0.001f;
}

// set voltage of full battery in [mV] (limits range, does not save configuration)
void ConfigSetBatFullInt(int mv)
{
	if (mv <= Config.bat_empty) mv = Config.bat_empty + 1;
	if (mv > CONFIG_BATTERY_FULL_MAX) mv = CONFIG_BATTERY_FULL_MAX;
	Config.bat_full = (u16)mv;
}

// increase voltage of full battery (limits range, does not save configuration)
void ConfigIncBatFull()
{
	ConfigSetBatFullInt(Config.bat_full + 1);
}

// decrease voltage of full battery (limits range, does not save configuration)
void ConfigDecBatFull()
{
	ConfigSetBatFullInt(Config.bat_full - 1);
}

// get voltage of empty battery in [V]
float ConfigGetBatEmpty()
{
	return Config.bat_empty * 0.001f;
}

// set voltage of empty battery in [mV] (limits range, does not save configuration)
void ConfigSetBatEmptyInt(int mv)
{
	if (mv < CONFIG_BATTERY_EMPTY_MIN) mv = CONFIG_BATTERY_EMPTY_MIN;
	if (mv >= Config.bat_full) mv = Config.bat_full - 1;
	Config.bat_empty = (u16)mv;
}

// increase voltage of empty battery (limits range, does not save configuration)
void ConfigIncBatEmpty()
{
	ConfigSetBatEmptyInt(Config.bat_empty + 1);
}

// decrease voltage of empty battery (limits range, does not save configuration)
void ConfigDecBatEmpty()
{
	ConfigSetBatEmptyInt(Config.bat_empty - 1);
}

// get voltage drop on diode in [V]
float ConfigGetBatDiode()
{
	return Config.bat_diode * 0.001f;
}

// set voltage drop on diode in [mV] (limits range, does not save configuration)
void ConfigSetBatDiodeInt(int mv)
{
	if (mv < CONFIG_BATTERY_DIODE_MIN) mv = CONFIG_BATTERY_DIODE_MIN;
	if (mv > CONFIG_BATTERY_DIODE_MAX) mv = CONFIG_BATTERY_DIODE_MAX;
	Config.bat_diode = (u16)mv;
}

// increase voltage drop on diode (limits range, does not save configuration)
void ConfigIncBatDiode()
{
	ConfigSetBatDiodeInt(Config.bat_diode + 1);
}

// decrease voltage drop on diode (limits range, does not save configuration)
void ConfigDecBatDiode()
{
	ConfigSetBatDiodeInt(Config.bat_diode - 1);
}

// === ADC

// get ADC reference in [V]
float ConfigGetAdcRef()
{
	return Config.adc_ref * 0.001f;
}

// set ADC reference in [mV] (limits range, does not save configuration)
void ConfigSetAdcRefInt(int mv)
{
	if (mv < CONFIG_ADC_REF_MIN) mv = CONFIG_ADC_REF_MIN;
	if (mv > CONFIG_ADC_REF_MAX) mv = CONFIG_ADC_REF_MAX;
	Config.adc_ref = (u16)mv;
}

// increase ADC reference (limits range, does not save configuration)
void ConfigIncAdcRef()
{
	ConfigSetAdcRefInt(Config.adc_ref + 1);
}

// decrease ADC reference (limits range, does not save configuration)
void ConfigDecAdcRef()
{
	ConfigSetAdcRefInt(Config.adc_ref - 1);
}

// === Temperature

// set temperature base voltage at 27�C (limits range, does not save configuration)
void ConfigSetTempBase(float mv)
{
	if (mv < CONFIG_TEMP_BASE_MIN) mv = CONFIG_TEMP_BASE_MIN;
	if (mv > CONFIG_TEMP_BASE_MAX) mv = CONFIG_TEMP_BASE_MAX;
	Config.temp_base = mv;
}

// increase temperature base voltage at 27�C (limits range, does not save configuration)
void ConfigIncTempBase()
{
	ConfigSetTempBase(Config.temp_base + 0.00001f);
}

// decrease temperature base voltage at 27�C (limits range, does not save configuration)
void ConfigDecTempBase()
{
	ConfigSetTempBase(Config.temp_base - 0.00001f);
}

// set temperature slope - voltage per 1 degree (limits range, does not save configuration)
void ConfigSetTempSlope(float mv)
{
	if (mv < CONFIG_TEMP_SLOPE_MIN) mv = CONFIG_TEMP_SLOPE_MIN;
	if (mv > CONFIG_TEMP_SLOPE_MAX) mv = CONFIG_TEMP_SLOPE_MAX;
	Config.temp_slope = mv;
}

// increase temperature slope - voltage per 1 degree (limits range, does not save configuration)
void ConfigIncTempSlope()
{
	ConfigSetTempSlope(Config.temp_slope + 0.000001f);
}

// decrease temperature slope - voltage per 1 degree (limits range, does not save configuration)
void ConfigDecTempSlope()
{
	ConfigSetTempSlope(Config.temp_slope - 0.000001f);
}

// set crystal in Hz (limits range, does not save configuration)
void ConfigSetCrystal(u32 hz)
{
	if (hz < CONFIG_CRYSTAL_MIN) hz = CONFIG_CRYSTAL_MIN;
	if (hz > CONFIG_CRYSTAL_MAX) hz = CONFIG_CRYSTAL_MAX;
	Config.crystal = hz;
}

// increase crystal (limits range, does not save configuration)
void ConfigIncCrystal()
{
	ConfigSetCrystal(Config.crystal + 1);
}

// decrease crystal (limits range, does not save configuration)
void ConfigDecCrystal()
{
	ConfigSetCrystal(Config.crystal - 1);
}

#endif // USE_CONFIG		// use device configuration (lib_config.c, lib_config.h)

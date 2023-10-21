/**
* MIT License
*
* Copyright (c) 2023 Tomas Vecera, tomas@vecera.dev
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
* documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
* rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
* persons to whom the Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
* Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
* WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
* OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include "picopad.h"

// Check if the configuration usage flag is enabled
#if USE_CONFIG

#include "pico/printf.h"

// Define the size of the configuration data without its CRC value
#define CONFIG_SIZE_WITHOUT_CRC 26

// Structure to hold configuration data and place it in the ".configdata" section
struct config_data_t __attribute__((section(".configdata"))) config_data;

// Strings for formatting and file I/O
char cr[] = "\n";
char volumeTxt[8 + 1];
char brightnessTxt[12 + 1];
char screenSleepTxt[14 + 1];
char refreshBatteryTxt[17 + 1];
char batteryAlarmTxt[15 + 1];
char buff[71];

// Check if SD card support is enabled
#if USE_SD
FIL cfgFile; // File handle for configuration file
#endif

// Function to get default configuration data
struct config_data_t get_default_config_data() {
	struct config_data_t default_config = {
			DEFAULT_BRIGHTNESS,
			DEFAULT_VOLUME,
			DEFAULT_SCREEN_SLEEP,
			DEFAULT_REFRESH_BATTERY,
			DEFAULT_BATTERY_ALARM,
			{0},
			0
	};

	return default_config;
}

// Function to load configuration data from memory
struct config_data_t load_config_data() {
	// Calculate CRC for the data, excluding the stored CRC itself
	uint32_t calculated_crc = CRC32(&config_data, CONFIG_SIZE_WITHOUT_CRC);

	// Check if the calculated CRC matches the stored one
	if (calculated_crc == config_data.crc) {
		return config_data;
	} else {
		// If the CRCs don't match, return a config_data_t with default values
		struct config_data_t default_config = get_default_config_data();
		default_config.crc = CRC32(&config_data, CONFIG_SIZE_WITHOUT_CRC);

		return default_config;
	}
}

// Function to save configuration data to memory
void save_config_data(struct config_data_t new_config) {
	// Set the new values, excluding the CRC
	config_data.brightness = new_config.brightness;
	config_data.volume = new_config.volume;
	config_data.screen_sleep = new_config.screen_sleep;
	config_data.refresh_battery = new_config.refresh_battery;
	config_data.battery_alarm = new_config.battery_alarm;
	memcpy(config_data.reserved, new_config.reserved, sizeof(config_data.reserved));

	// Calculate and store the new CRC
	config_data.crc = CRC32(&config_data, CONFIG_SIZE_WITHOUT_CRC);
}

void update_config_field(uint8_t *field, uint8_t value) {
	*field = value;
	config_data.crc = CRC32(&config_data, CONFIG_SIZE_WITHOUT_CRC);

#if USE_SD
	save_config_to_file();
#endif
}

// Function to save volume to the configuration
void save_volume(uint8_t volume) {
	update_config_field(&config_data.volume, volume);
}

// Function to save brightness to the configuration
void save_brightness(uint8_t brightness) {
	update_config_field(&config_data.brightness, brightness);
}

#if USE_SD

// Function to save configuration data to SD card
void save_config_to_file() {
	if (sd_mount()) {
		if (file_open(&cfgFile, CONFIG_FILE, FA_WRITE | FA_OPEN_ALWAYS)) {
			// Format the data strings
			snprintf(volumeTxt, 9, "volume %u", config_data.volume);
			snprintf(brightnessTxt, 13, "brightness %u", config_data.brightness);
			snprintf(screenSleepTxt, 15, "screen_sleep %u", config_data.screen_sleep);
			snprintf(refreshBatteryTxt, 18, "refresh_battery %u", config_data.refresh_battery);
			snprintf(batteryAlarmTxt, 16, "battery_alarm %u", config_data.battery_alarm);

			// Concatenate the data strings
			strcpy(buff, volumeTxt);
			strcat(buff, cr);
			strcat(buff, brightnessTxt);
			strcat(buff, cr);
			strcat(buff, screenSleepTxt);
			strcat(buff, cr);
			strcat(buff, refreshBatteryTxt);
			strcat(buff, cr);
			strcat(buff, batteryAlarmTxt);

			// Write the concatenated string to the file
			file_write(&cfgFile, buff, 70);
			file_close(&cfgFile);
		}
	}
}

#endif

// Function to load configuration data from SD card and save to memory
void load_config_file() {
	struct config_data_t default_config = get_default_config_data();

#if USE_SD
	if (sd_mount()) {
		if (!file_exist(CONFIG_FILE)) {
			// If the config file doesn't exist, save default configuration data
			save_config_data(default_config);
			save_config_to_file();
		} else {
			if (file_open(&cfgFile, CONFIG_FILE, FA_READ)) {
				// Read and parse the configuration values from the file
				// Load volume
				if (file_read(&cfgFile, buff, 9) == 9) {
					uint8_t volume = buff[7] - '0';
					if (volume >= 0 && volume <= 5)
						default_config.volume = volume;
				}
				// Load brightness
				if (file_read(&cfgFile, buff, 12) == 12) {
					uint8_t brightness = buff[11] - '0';
					if (brightness >= 0 && brightness <= 5)
						default_config.brightness = brightness;
				}
				// Load screen sleep time
				if (file_read(&cfgFile, buff, 14) == 14) {
					uint8_t screen_sleep = buff[13] - '0';
					if (screen_sleep >= 0 && screen_sleep <= 9)
						default_config.screen_sleep = screen_sleep;
				}
				// Load refresh battery status time
				if (file_read(&cfgFile, buff, 17) == 17) {
					uint8_t refresh_battery = buff[16] - '0';
					if (refresh_battery >= 0 && refresh_battery <= 9)
						default_config.refresh_battery = refresh_battery;
				}
				// Load battery alarm ON/OFF
				if (file_read(&cfgFile, buff, 15) == 15) {
					uint8_t battery_alarm = buff[14] - '0';
					if (battery_alarm >= 0 && battery_alarm <= 1)
						default_config.battery_alarm = battery_alarm;
				}
				file_close(&cfgFile);
			}
		}
	}
#endif

	// Save the parsed configuration data to memory
	save_config_data(default_config);
}

#endif

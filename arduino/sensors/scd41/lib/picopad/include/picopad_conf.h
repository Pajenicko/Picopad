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
#if USE_CONFIG

#ifndef PICOPAD_SDK_CONFIG_H
#define PICOPAD_SDK_CONFIG_H

#ifdef __cplusplus
extern "C" {
#endif

#define CONFIG_DATA_SIZE  32    // boot loader resident data

#define CONFIG_FILE "picopad.cfg"

struct config_data_t {
		uint8_t brightness;
		uint8_t volume;
		uint8_t screen_sleep;
		uint8_t refresh_battery;
		uint8_t battery_alarm;
		uint8_t reserved[21]; // struct padding
		uint32_t crc;
};
static_assert(sizeof(struct config_data_t) == CONFIG_DATA_SIZE, "configdata must be CONFIG_DATA_SIZE bytes");

struct config_data_t load_config_data();

void save_config_data(struct config_data_t new_config);

void save_volume(uint8_t volume);

void save_brightness(uint8_t brightness);

void load_config_file();

#if USE_SD
void save_config_to_file();
#endif

#ifdef __cplusplus
}
#endif

#endif // PICOPAD_SDK_CONFIG_H

#endif
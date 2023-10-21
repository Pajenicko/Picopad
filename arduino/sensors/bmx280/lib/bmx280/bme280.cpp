/*
BSD 3-Clause License

Copyright (c) 2022, Darren Horrocks
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
// https://github.com/bizzehdee/pico-libs/tree/master/src/common/bmp280

#include "pico/time.h"
#include "hardware/gpio.h"
#include <math.h>
#include "bme280.h"

BME280::BME280() {
	this->i2cInst = i2c0;
}

BME280::~BME280() {
	this->i2cInst = nullptr;
}

bool BME280::begin(uint8_t addrValue, uint8_t chipIdValue) {
	i2c_init(this->i2cInst, 400000);
	gpio_set_function(0, GPIO_FUNC_I2C);
	gpio_set_function(1, GPIO_FUNC_I2C);
	gpio_pull_up(0);
	gpio_pull_up(1);

	this->addr = addrValue;
	_sensorID = read8(BME280_REGISTER_CHIPID);
	if (_sensorID != chipIdValue) {
		return false;
	}

	readCoefficients();
	setSampling();

	return true;
}

bool BME280::readSensorId() {
	_sensorID = read8(BME280_REGISTER_CHIPID);
	if (_sensorID == BME280_CHIPID || _sensorID == BMP280_CHIPID) {
		return true;
	}

	return false;
}

void BME280::reset() {
	write8(BME280_REGISTER_SOFTRESET, MODE_SOFT_RESET_CODE);
}

uint8_t BME280::getStatus() {
	return read8(BME280_REGISTER_STATUS);
}

uint8_t BME280::sensorID() const {
	return _sensorID;
}

float BME280::readTemperature() {
	int32_t var1, var2;
	if (!_sensorID)
		return NAN; // begin() not called yet

	int32_t adc_T = read24(BME280_REGISTER_TEMPDATA);
	adc_T >>= 4;

	var1 = ((((adc_T >> 3) - ((int32_t) _bme280_calib.dig_T1 << 1))) *
					((int32_t) _bme280_calib.dig_T2)) >> 11;

	var2 = (((((adc_T >> 4) - ((int32_t) _bme280_calib.dig_T1)) *
						((adc_T >> 4) - ((int32_t) _bme280_calib.dig_T1))) >> 12) *
					((int32_t) _bme280_calib.dig_T3)) >> 14;

	t_fine = var1 + var2;

	float T = (t_fine * 5 + 128) >> 8;
	return T / 100;
}

float BME280::readPressure() {
	int64_t var1, var2, p;
	if (!_sensorID)
		return NAN; // begin() not called yet

	// Must be done first to get the t_fine variable set up
	readTemperature();

	int32_t adc_P = read24(BME280_REGISTER_PRESSUREDATA);
	adc_P >>= 4;

	var1 = ((int64_t) t_fine) - 128000;
	var2 = var1 * var1 * (int64_t) _bme280_calib.dig_P6;
	var2 = var2 + ((var1 * (int64_t) _bme280_calib.dig_P5) << 17);
	var2 = var2 + (((int64_t) _bme280_calib.dig_P4) << 35);
	var1 = ((var1 * var1 * (int64_t) _bme280_calib.dig_P3) >> 8) +
				 ((var1 * (int64_t) _bme280_calib.dig_P2) << 12);
	var1 =
			(((((int64_t) 1) << 47) + var1)) * ((int64_t) _bme280_calib.dig_P1) >> 33;

	if (var1 == 0) {
		return 0; // avoid exception caused by division by zero
	}
	p = 1048576 - adc_P;
	p = (((p << 31) - var2) * 3125) / var1;
	var1 = (((int64_t) _bme280_calib.dig_P9) * (p >> 13) * (p >> 13)) >> 25;
	var2 = (((int64_t) _bme280_calib.dig_P8) * p) >> 19;

	p = ((p + var1 + var2) >> 8) + (((int64_t) _bme280_calib.dig_P7) << 4);
	return (float) p / 256;
}

/*!
 *  @brief  Returns the humidity from the sensor
 *  @returns the humidity value read from the device
 */
float BME280::readHumidity() {
	int32_t var1, var2, var3, var4, var5;

	readTemperature(); // must be done first to get t_fine

	int32_t adc_H = read16(BME280_REGISTER_HUMIDDATA);
	if (adc_H == 0x8000) // value in case humidity measurement was disabled
		return NAN;

	var1 = t_fine - ((int32_t) 76800);
	var2 = (int32_t) (adc_H * 16384);
	var3 = (int32_t) (((int32_t) _bme280_calib.dig_H4) * 1048576);
	var4 = ((int32_t) _bme280_calib.dig_H5) * var1;
	var5 = (((var2 - var3) - var4) + (int32_t) 16384) / 32768;
	var2 = (var1 * ((int32_t) _bme280_calib.dig_H6)) / 1024;
	var3 = (var1 * ((int32_t) _bme280_calib.dig_H3)) / 2048;
	var4 = ((var2 * (var3 + (int32_t) 32768)) / 1024) + (int32_t) 2097152;
	var2 = ((var4 * ((int32_t) _bme280_calib.dig_H2)) + 8192) / 16384;
	var3 = var5 * var2;
	var4 = ((var3 / 32768) * (var3 / 32768)) / 128;
	var5 = var3 - ((var4 * ((int32_t) _bme280_calib.dig_H1)) / 16);
	var5 = (var5 < 0 ? 0 : var5);
	var5 = (var5 > 419430400 ? 419430400 : var5);
	uint32_t H = (uint32_t) (var5 / 4096);

	return (float) H / 1024.0;
}

float BME280::readAltitude(float seaLevelhPa) {
	float altitude;

	float pressure = readPressure(); // in Si units for Pascal
	pressure /= 100;

	altitude = 44330.0f * (1.0f - pow(pressure / seaLevelhPa, 0.1903f));

	return altitude;
}

float BME280::seaLevelForAltitude(float altitude, float atmospheric) {
	return atmospheric / pow(1.0f - (altitude / 44330.0f), 5.255f);
}

float BME280::waterBoilingPoint(float pressure) {
	return (234.175f * log(pressure / 6.1078f)) /
				 (17.08085f - log(pressure / 6.1078f));
}

bool BME280::takeForcedMeasurement() {
	return false;
}

void BME280::setSampling(sensor_mode mode,
												 sensor_sampling tempSampling,
												 sensor_sampling pressSampling,
												 sensor_sampling humSampling,
												 sensor_filter filter,
												 standby_duration duration) {
	_measReg.mode = mode;
	_measReg.osrs_t = tempSampling;
	_measReg.osrs_p = pressSampling;

	_humReg.osrs_h = humSampling;
	_configReg.filter = filter;
	_configReg.t_sb = duration;
	_configReg.spi3w_en = 0;

	// making sure sensor is in sleep mode before setting configuration
	// as it otherwise may be ignored
	write8(BME280_REGISTER_CONTROL, MODE_SLEEP);

	// you must make sure to also set REGISTER_CONTROL after setting the
	// CONTROLHUMID register, otherwise the values won't be applied (see
	// DS 5.4.3)
	write8(BME280_REGISTER_CONTROLHUMID, _humReg.get());
	write8(BME280_REGISTER_CONFIG, _configReg.get());
	write8(BME280_REGISTER_CONTROL, _measReg.get());
}

void BME280::readCoefficients() {
	_bme280_calib.dig_T1 = read16_LE(BME280_REGISTER_DIG_T1);
	_bme280_calib.dig_T2 = readS16_LE(BME280_REGISTER_DIG_T2);
	_bme280_calib.dig_T3 = readS16_LE(BME280_REGISTER_DIG_T3);

	_bme280_calib.dig_P1 = read16_LE(BME280_REGISTER_DIG_P1);
	_bme280_calib.dig_P2 = readS16_LE(BME280_REGISTER_DIG_P2);
	_bme280_calib.dig_P3 = readS16_LE(BME280_REGISTER_DIG_P3);
	_bme280_calib.dig_P4 = readS16_LE(BME280_REGISTER_DIG_P4);
	_bme280_calib.dig_P5 = readS16_LE(BME280_REGISTER_DIG_P5);
	_bme280_calib.dig_P6 = readS16_LE(BME280_REGISTER_DIG_P6);
	_bme280_calib.dig_P7 = readS16_LE(BME280_REGISTER_DIG_P7);
	_bme280_calib.dig_P8 = readS16_LE(BME280_REGISTER_DIG_P8);
	_bme280_calib.dig_P9 = readS16_LE(BME280_REGISTER_DIG_P9);

	_bme280_calib.dig_H1 = read8(BME280_REGISTER_DIG_H1);
	_bme280_calib.dig_H2 = readS16_LE(BME280_REGISTER_DIG_H2);
	_bme280_calib.dig_H3 = read8(BME280_REGISTER_DIG_H3);
	_bme280_calib.dig_H4 = ((int8_t) read8(BME280_REGISTER_DIG_H4) << 4) |
												 (read8(BME280_REGISTER_DIG_H4 + 1) & 0xF);
	_bme280_calib.dig_H5 = ((int8_t) read8(BME280_REGISTER_DIG_H5 + 1) << 4) |
												 (read8(BME280_REGISTER_DIG_H5) >> 4);
	_bme280_calib.dig_H6 = (int8_t) read8(BME280_REGISTER_DIG_H6);
}

uint8_t BME280::read8(unsigned char reg) {
	uint8_t buffer[1];
	if (i2cInst) {
		buffer[0] = uint8_t(reg);
		absolute_time_t timeout = make_timeout_time_ms(TIMEOUT_MS);

		i2c_write_blocking_until(i2cInst, addr, buffer, 1, false, timeout);
		i2c_read_blocking_until(i2cInst, addr, buffer, 1, false, timeout);
	}
	return buffer[0];
}

uint16_t BME280::read16(unsigned char reg) {
	uint8_t buffer[2];

	if (i2cInst) {
		buffer[0] = uint8_t(reg);
		absolute_time_t timeout = make_timeout_time_ms(TIMEOUT_MS);

		i2c_write_blocking_until(i2cInst, addr, buffer, 1, false, timeout);
		i2c_read_blocking_until(i2cInst, addr, buffer, 2, false, timeout);
	}
	return uint16_t(buffer[0]) << 8 | uint16_t(buffer[1]);
}

uint16_t BME280::read16_LE(unsigned char reg) {
	uint16_t temp = read16(reg);
	return (temp >> 8) | (temp << 8);
}

int16_t BME280::readS16_LE(unsigned char reg) {
	return (int16_t) read16_LE(reg);
}

uint32_t BME280::read24(unsigned char reg) {
	uint8_t buffer[3];

	if (i2cInst) {
		buffer[0] = uint8_t(reg);
		absolute_time_t timeout = make_timeout_time_ms(TIMEOUT_MS);

		i2c_write_blocking_until(i2cInst, addr, buffer, 1, false, timeout);
		i2c_read_blocking_until(i2cInst, addr, buffer, 3, false, timeout);
	}
	return uint32_t(buffer[0]) << 16 | uint32_t(buffer[1]) << 8 |
				 uint32_t(buffer[2]);
}

void BME280::write8(unsigned char reg, unsigned char value) {
	uint8_t buffer[2];
	buffer[1] = value;
	if (i2cInst) {
		buffer[0] = reg;
		absolute_time_t timeout = make_timeout_time_ms(TIMEOUT_MS);
		i2c_write_blocking_until(i2cInst, addr, buffer, 2, false, timeout);
	}
}
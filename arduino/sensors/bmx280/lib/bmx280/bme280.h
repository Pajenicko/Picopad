/*
BSD 3-Clause License

 https://github.com/bizzehdee/pico-libs/blob/master/src/common/bme280

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

#ifndef __BME280_H__
#define __BME280_H__

#include "hardware/i2c.h"

/*!
 *  I2C ADDRESS/BITS/SETTINGS
 */
#define BMX280_ADDRESS (0x76)     /**< The default I2C address for the sensor. */
#define BMX280_ADDRESS_ALT (0x77) /**< Alternative I2C address for the sensor. */

#define BMP280_CHIPID (0x58)      /**< Default chip ID. */
#define BME280_CHIPID (0x60)      /**< Default chip ID. */

#define TIMEOUT_MS 100

enum {
    BME280_REGISTER_DIG_T1 = 0x88,
    BME280_REGISTER_DIG_T2 = 0x8A,
    BME280_REGISTER_DIG_T3 = 0x8C,

    BME280_REGISTER_DIG_P1 = 0x8E,
    BME280_REGISTER_DIG_P2 = 0x90,
    BME280_REGISTER_DIG_P3 = 0x92,
    BME280_REGISTER_DIG_P4 = 0x94,
    BME280_REGISTER_DIG_P5 = 0x96,
    BME280_REGISTER_DIG_P6 = 0x98,
    BME280_REGISTER_DIG_P7 = 0x9A,
    BME280_REGISTER_DIG_P8 = 0x9C,
    BME280_REGISTER_DIG_P9 = 0x9E,

    BME280_REGISTER_DIG_H1 = 0xA1,
    BME280_REGISTER_DIG_H2 = 0xE1,
    BME280_REGISTER_DIG_H3 = 0xE3,
    BME280_REGISTER_DIG_H4 = 0xE4,
    BME280_REGISTER_DIG_H5 = 0xE5,
    BME280_REGISTER_DIG_H6 = 0xE7,

    BME280_REGISTER_CHIPID = 0xD0,
    BME280_REGISTER_VERSION = 0xD1,
    BME280_REGISTER_SOFTRESET = 0xE0,

    BME280_REGISTER_CAL26 = 0xE1, // R calibration stored in 0xE1-0xF0

    BME280_REGISTER_CONTROLHUMID = 0xF2,
    BME280_REGISTER_STATUS = 0XF3,
    BME280_REGISTER_CONTROL = 0xF4,
    BME280_REGISTER_CONFIG = 0xF5,
    BME280_REGISTER_PRESSUREDATA = 0xF7,
    BME280_REGISTER_TEMPDATA = 0xFA,
    BME280_REGISTER_HUMIDDATA = 0xFD
};

typedef struct {
    uint16_t dig_T1; ///< temperature compensation value
    int16_t dig_T2;  ///< temperature compensation value
    int16_t dig_T3;  ///< temperature compensation value

    uint16_t dig_P1; ///< pressure compensation value
    int16_t dig_P2;  ///< pressure compensation value
    int16_t dig_P3;  ///< pressure compensation value
    int16_t dig_P4;  ///< pressure compensation value
    int16_t dig_P5;  ///< pressure compensation value
    int16_t dig_P6;  ///< pressure compensation value
    int16_t dig_P7;  ///< pressure compensation value
    int16_t dig_P8;  ///< pressure compensation value
    int16_t dig_P9;  ///< pressure compensation value

    uint8_t dig_H1; ///< humidity compensation value
    int16_t dig_H2; ///< humidity compensation value
    uint8_t dig_H3; ///< humidity compensation value
    int16_t dig_H4; ///< humidity compensation value
    int16_t dig_H5; ///< humidity compensation value
    int8_t dig_H6;  ///< humidity compensation value
} bme280_calib_data;

class BME280 {
public:
    /** Oversampling rate for the sensor. */
    enum sensor_sampling {
        /** No over-sampling. */
        SAMPLING_NONE = 0x00,
        /** 1x over-sampling. */
        SAMPLING_X1 = 0x01,
        /** 2x over-sampling. */
        SAMPLING_X2 = 0x02,
        /** 4x over-sampling. */
        SAMPLING_X4 = 0x03,
        /** 8x over-sampling. */
        SAMPLING_X8 = 0x04,
        /** 16x over-sampling. */
        SAMPLING_X16 = 0x05
    };

    /** Operating mode for the sensor. */
    enum sensor_mode {
        /** Sleep mode. */
        MODE_SLEEP = 0x00,
        /** Forced mode. */
        MODE_FORCED = 0x01,
        /** Normal mode. */
        MODE_NORMAL = 0x03,
        /** Software reset. */
        MODE_SOFT_RESET_CODE = 0xB6
    };

    /** Filtering level for sensor data. */
    enum sensor_filter {
        /** No filtering. */
        FILTER_OFF = 0x00,
        /** 2x filtering. */
        FILTER_X2 = 0x01,
        /** 4x filtering. */
        FILTER_X4 = 0x02,
        /** 8x filtering. */
        FILTER_X8 = 0x03,
        /** 16x filtering. */
        FILTER_X16 = 0x04
    };

    /** Standby duration in ms */
    enum standby_duration {
        /** 1 ms standby. */
        STANDBY_MS_1 = 0x00,
        /** 62.5 ms standby. */
        STANDBY_MS_63 = 0x01,
        /** 125 ms standby. */
        STANDBY_MS_125 = 0x02,
        /** 250 ms standby. */
        STANDBY_MS_250 = 0x03,
        /** 500 ms standby. */
        STANDBY_MS_500 = 0x04,
        /** 1000 ms standby. */
        STANDBY_MS_1000 = 0x05,
        /** 2000 ms standby. */
        STANDBY_MS_2000 = 0x06,
        /** 4000 ms standby. */
        STANDBY_MS_4000 = 0x07
    };

    // default to i2c0, pins 4/5
    explicit BME280();

    ~BME280();

    bool begin(uint8_t addr = BMX280_ADDRESS, uint8_t chipid = BME280_CHIPID);

    bool readSensorId();

    void reset();

    uint8_t getStatus();

    [[nodiscard]] uint8_t sensorID() const;

    float readTemperature();

    float readPressure();

    float readHumidity();

    float readAltitude(float seaLevelhPa = 1013.25);

    float seaLevelForAltitude(float altitude, float atmospheric);

    float waterBoilingPoint(float pressure);

    bool takeForcedMeasurement();

    void setSampling(sensor_mode mode = MODE_NORMAL,
                     sensor_sampling tempSampling = SAMPLING_X16,
                     sensor_sampling pressSampling = SAMPLING_X16,
                     sensor_sampling humSampling = SAMPLING_X16,
                     sensor_filter filter = FILTER_OFF,
                     standby_duration duration = STANDBY_MS_1);

private:
    struct config {
        /** Initialize to power-on-reset state */
        config() : t_sb(STANDBY_MS_1), filter(FILTER_OFF), none(0), spi3w_en(0) {}

        /** Inactive duration (standby time) in normal mode */
        unsigned int t_sb: 3;
        /** Filter settings */
        unsigned int filter: 3;
        /** Unused - don't set */
        unsigned int none: 1;
        /** Enables 3-wire SPI */
        unsigned int spi3w_en: 1;

        /** Used to retrieve the assembled config register's byte value. */
        [[nodiscard]] unsigned int get() const { return (t_sb << 5) | (filter << 2) | spi3w_en; }
    };

    /** Encapsulates trhe ctrl_meas register */
    struct ctrl_meas {
        /** Initialize to power-on-reset state */
        ctrl_meas()
                : osrs_t(SAMPLING_NONE), osrs_p(SAMPLING_NONE), mode(MODE_SLEEP) {}

        /** Temperature oversampling. */
        unsigned int osrs_t: 3;
        /** Pressure oversampling. */
        unsigned int osrs_p: 3;
        /** Device mode */
        unsigned int mode: 2;

        /** Used to retrieve the assembled ctrl_meas register's byte value. */
        [[nodiscard]] unsigned int get() const { return (osrs_t << 5) | (osrs_p << 2) | mode; }
    };

    struct ctrl_hum {
        /// unused - don't set
        unsigned int none : 5;

        // pressure oversampling
        // 000 = skipped
        // 001 = x1
        // 010 = x2
        // 011 = x4
        // 100 = x8
        // 101 and above = x16
        unsigned int osrs_h : 3; ///< pressure oversampling

        /// @return combined ctrl hum register
        unsigned int get() { return (osrs_h); }
    };
    ctrl_hum _humReg; //!< hum register object

private:
    void readCoefficients();

    uint8_t read8(unsigned char reg);

    uint16_t read16(unsigned char reg);

    uint16_t read16_LE(unsigned char reg);

    int16_t readS16_LE(unsigned char reg);

    void write8(unsigned char reg, unsigned char value);

    uint32_t read24(unsigned char reg);

private:
    i2c_inst_t *i2cInst = nullptr;
    uint8_t addr = BMX280_ADDRESS;
    int32_t _sensorID = 0;
    bme280_calib_data _bme280_calib;
    config _configReg;
    ctrl_meas _measReg;
    int32_t t_fine;
};

#endif // __BME280_H__

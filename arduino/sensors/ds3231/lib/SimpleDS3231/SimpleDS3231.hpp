/*
 * Simple Raspberry Pi Pico driver for DS3231 RTC module.
 *
 * Written by Victor Gabriel Costin.
 * Licensed under the MIT license.
 * https://github.com/CostinV92/SimpleDS3231
 */

#include "pico/stdlib.h"

#ifndef __SIMPLE_DS3231_HPP__
#define __SIMPLE_DS3231_HPP__

#define TIMEOUT_MS 100

class SimpleDS3231 {
private:
    uint8_t             _sec = 0;
    uint8_t             _min = 0;
    uint8_t             _hou = 0;
    uint8_t             _day = 0;
    uint8_t             _mon = 0;
    int                 _year = 0;

    bool                _is_pm = false;
    bool                _12_format = false;

    uint8_t             _data_buffer[8];
    char                _time_str_buffer[12];
    char                _date_str_buffer[11];

    void                _read_data_reg(uint8_t reg, uint8_t n_regs);
    void                _write_data_reg(uint8_t reg, uint8_t n_regs);

    void                _format_time_string();
    void                _format_date_string();

    uint8_t             _decode_gen(uint8_t data);
    void                _decode_hou();

    uint8_t             _encode_gen(uint8_t data);
    uint8_t             _encode_hou(uint8_t hou, bool am_pm_format, bool is_pm);

public:
    explicit SimpleDS3231(uint sda = 0, uint scl = 1);

    uint8_t             get_temp();

    uint8_t             get_hou();
    uint8_t             get_min();
    uint8_t             get_sec();
    const char*         get_time_str();

    void                set_sec(uint8_t sec);
    void                set_min(uint8_t min);
    void                set_hou(uint8_t hou, bool am_pm_format, bool is_pm);
    void                set_time(uint8_t hou, uint8_t min, uint8_t sec,
                                 bool am_pm_format, bool is_pm);

    uint8_t             get_day();
    uint8_t             get_mon();
    int                 get_year();
    const char*         get_date_str();

    void                set_day(uint8_t day);
    void                set_mon(uint8_t mon);
    void                set_year(int year);
    void                set_date(uint8_t day, uint8_t mon, int year);
};

#endif /* __SIMPLE_DS3231_HPP__ */

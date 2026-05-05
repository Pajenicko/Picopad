/*
 * pico-pi-one-wire Library, derived from the mbed DS1820 Library, for the
 * Dallas (Maxim) 1-Wire Devices
 * Copyright (c) 2010, Michael Hagberg <Michael@RedBoxCode.com>
 *
 * This version uses a single instance to talk to multiple one wire devices.
 * During configuration the devices will be listed and the addresses
 * then stored within the system  they are associated with.
 *
 * Then previously stored addresses are used to query devices.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#ifndef PICO_PI_ONEWIRE_H
#define PICO_PI_ONEWIRE_H

#define FAMILY_CODE address.rom[0]
#define FAMILY_CODE_DS18S20 0x10 //9bit temp
#define FAMILY_CODE_DS18B20 0x28 //9-12bit temp also known as MAX31820
#define FAMILY_CODE_DS1822 0x22  //9-12bit temp
#define FAMILY_CODE_MAX31826 0x3B//12bit temp + 1k EEPROM
#define FAMILY_CODE_DS2404 0x04  //RTC
#define FAMILY_CODE_DS2417 0x27  //RTC
#define FAMILY_CODE_DS2740 0x36  //Current measurement
#define FAMILY_CODE_DS2502 0x09  //1k EEPROM

static const int ReadScratchPadCommand = 0xBE;
static const int ReadPowerSupplyCommand = 0xB4;
static const int ConvertTempCommand = 0x44;
static const int MatchROMCommand = 0x55;
static const int ReadROMCommand = 0x33;
static const int SearchROMCommand = 0xF0;
static const int SkipROMCommand = 0xCC;
static const int WriteScratchPadCommand = 0x4E;
static const int ROMSize = 8;
struct rom_address_t {
	uint8_t rom[ROMSize];
};

/**
 * OneWire with DS1820 Dallas 1-Wire Temperature Probe
 *
 * Example:
 * @code
 * #include "one_wire.h"
 *
 * One_wire one_wire(15); //GP15 - Pin 20 on Pi Pico
 *
 * int main() {
 *     one_wire.init();
 *     rom_address_t address{};
 *     while (true) {
 *         one_wire.single_device_read_rom(address);
 *         one_wire.convert_temperature(address, true, true);
 *         printf("It is %3.1foC\n", one_wire.temperature(address));
 *         sleep_ms(1000);
 *     }
 * }
 * @endcode
 */
class One_wire {
public:
	enum {
		invalid_conversion = -1000,
		not_controllable = 0xFFFFFFFF
	};

	/** Create a one wire bus object connected to the specified pins
	 *
	 * The bus might either by regular powered or parasite powered. If it is parasite
	 * powered and power_pin is set, that pin will be used to switch an external mosfet
	 * connecting data to Vdd. If it is parasite powered and the pin is not set, the
	 * regular data pin is used to supply extra power when required. This will be
	 * sufficient as long as the number of devices is limited.
	 *
	 * @param data_pin pin for the data bus
	 * @param power_pin (optional) pin to control the power MOSFET
	 * @param power_polarity (optional) which sets active state (false for active low (default), true for active high)
	 */
	explicit One_wire(unsigned int data_pin, unsigned int power_pin = not_controllable, bool power_polarity = false);
	~One_wire();

	/**
	 * Initialise and determine if any devices are using parasitic power
	 */
	void init();

	/**
	 * Finds all one wire devices and returns the count
	 *
	 * @return - number of devices found
	 */
	int find_and_count_devices_on_bus();

	/**
	 * Get address of devices previously found
	 *
	 * @param index the index into found devices
	 * @return the address of
	 */
	static rom_address_t &get_address(int index);

	/**
	 * This routine will initiate the temperature conversion within
	 * one or all temperature devices.
	 *
	 * @param wait if true or parasitic power is used, waits up to 750 ms for
	 * conversion otherwise returns immediately.
	 * @param address allows the function to apply to a specific device or
	 * to all devices on the 1-Wire bus.
	 * @returns milliseconds until conversion will complete.
	 */
	int convert_temperature(rom_address_t &address, bool wait, bool all);

	/**
	 * Changes the "endianness" of the unique device ID in supplied address
	 * so that it can be conveniently printed out and manipulated as a number.
	 *
	 * @param address the address you received from OneWire::get_address(i).
	 * @returns device ID as unsigned 64-bit integer.
	 */
	static uint64_t to_uint64(rom_address_t &address);

	/**
	 * This function will return the temperature measured by the specific device.
	 *
	 * @param convert_to_fahrenheit whether to convert the degC to Fahrenheit
	 * @returns temperature for that scale, or OneWire::invalid_conversion (-1000) if CRC error detected.
	 */
	float temperature(rom_address_t &address, bool convert_to_fahrenheit = false);

	/**
	 * This function sets the temperature resolution for supported devices
	 * in the configuration register.
	 *
	 * @param resolution number between 9 and 12 to specify resolution
	 * @returns true if successful
	 */
	bool set_resolution(rom_address_t &address, unsigned int resolution);

	/**
	 * Assuming a single device is attached, do a Read ROM
	 *
	 * @param rom_address the address will be filled into this parameter
	 */
	void single_device_read_rom(rom_address_t &rom_address);

	/**
	 * Static utility method for easy conversion from previously stored addresses
	 *
	 * @param hex_address the address as a human readable hex string
	 * @return the rom address
	 */
	static rom_address_t address_from_hex(const char *hex_address);

private:
	unsigned int _data_pin;
	unsigned int _parasite_pin;
	bool _parasite_power{};
	bool _power_mosfet;
	bool _power_polarity;
	uint8_t _search_ROM[8] = {0, 0, 0, 0, 0, 0, 0, 0};
	uint8_t ram[9]{};

	int _last_discrepancy;	// search state
	bool _last_device;  // search state

	static uint8_t crc_byte(uint8_t crc, uint8_t byte);

	static void bit_write(uint8_t &value, int bit, bool set);

	[[nodiscard]] bool reset_check_for_device() const;

	void match_rom(rom_address_t &address);

	void skip_rom();

	void onewire_bit_out(bool bit_data) const;

	void onewire_byte_out(uint8_t data);

	[[nodiscard]] bool onewire_bit_in() const;

	uint8_t onewire_byte_in();

	static bool rom_checksum_error(uint8_t *address);

	bool ram_checksum_error();

	bool search_rom_find_next();

	void read_scratch_pad(rom_address_t &address);

	void write_scratch_pad(rom_address_t &address, int data);

	bool power_supply_available(rom_address_t &address, bool all);
};


#endif// PICO_PI_ONEWIRE_H
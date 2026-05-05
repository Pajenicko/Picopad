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

#include "../include.h"
#include "one_wire.h"
#include <vector>

std::vector<rom_address_t> found_addresses;

One_wire::One_wire(uint data_pin, uint power_pin, bool power_polarity)
		: _data_pin(data_pin),
		  _parasite_pin(power_pin),
		  _power_polarity(power_polarity),
		  _power_mosfet(power_pin != not_controllable) {
}

void One_wire::init() {
	gpio_init(_data_pin);
	if (_parasite_pin != not_controllable) {
		gpio_init(_parasite_pin);
	}
	for (uint8_t &byte_counter : ram) {
		byte_counter = 0x00;
	}

	rom_address_t address{};
	_parasite_power = !power_supply_available(address, true);
}

One_wire::~One_wire() {
	found_addresses.clear();
}

bool One_wire::reset_check_for_device() const {
	// This will return false if no devices are present on the data bus
	bool presence = false;
	gpio_init(_data_pin);
	gpio_set_dir(_data_pin, GPIO_OUT);
	gpio_put(_data_pin, false); // bring low for 480us
	sleep_us(480);
	gpio_set_dir(_data_pin, GPIO_IN); // let the data line float high
	sleep_us(70); // wait 70us
	if (!gpio_get(_data_pin)) {
		// see if any devices are pulling the data line low
		presence = true;
	}
	sleep_us(410);
	return presence;
}

void One_wire::onewire_bit_out(bool bit_data) const {
	gpio_set_dir(_data_pin, GPIO_OUT);
	gpio_put(_data_pin, false);
	sleep_us(3);// (spec 1-15us)
	if (bit_data) {
		gpio_put(_data_pin, true);
		sleep_us(55);
	} else {
		sleep_us(60);// (spec 60-120us)
		gpio_put(_data_pin, true);
		sleep_us(5);// allow bus to float high before next bit_out
	}
}

void One_wire::onewire_byte_out(uint8_t data) {
	int n;
	for (n = 0; n < 8; n++) {
		onewire_bit_out((bool) (data & 0x01));
		data = data >> 1;// now the next bit is in the least sig bit position.
	}
}

bool One_wire::onewire_bit_in() const {
	bool answer;
	gpio_set_dir(_data_pin, GPIO_OUT);
	gpio_put(_data_pin, false);
	sleep_us(3);// (spec 1-15us)
	gpio_set_dir(_data_pin, GPIO_IN);
	sleep_us(3);// (spec read within 15us)
	answer = gpio_get(_data_pin);
	sleep_us(45);
	return answer;
}

uint8_t One_wire::onewire_byte_in() {
	uint8_t answer = 0x00;
	int i;
	for (i = 0; i < 8; i++) {
		answer = answer >> 1;// shift over to make room for the next bit
		if (onewire_bit_in())
			answer = (uint8_t) (answer | 0x80);// if the data port is high, make this bit a 1
	}
	return answer;
}

int One_wire::find_and_count_devices_on_bus() {
	found_addresses.clear();
	_last_discrepancy = 0;	// start search from begining
	_last_device = 0;
	while (search_rom_find_next()) {
	}
	return (int) found_addresses.size();
}

rom_address_t One_wire::address_from_hex(const char *hex_address) {
	rom_address_t address = rom_address_t();
	for (uint8_t i = 0; i < ROMSize; i++) {
		char buffer[3];
		strncpy(buffer, &hex_address[i * 2], 2);
		buffer[2] = '\0';
		address.rom[i] = (uint8_t) strtol(buffer, nullptr, 16);
	}
	return address;
}

rom_address_t &One_wire::get_address(int index) {
	return found_addresses[index];
}

void One_wire::bit_write(uint8_t &value, int bit, bool set) {
	if (bit <= 7 && bit >= 0) {
		if (set) {
			value |= (1 << bit);
		} else {
			value &= ~(1 << bit);
		}
	}
}

void One_wire::single_device_read_rom(rom_address_t &rom_address) {
	if (!reset_check_for_device()) {
		return;
	} else {
		onewire_byte_out(ReadROMCommand);
		for (int bit_index = 0; bit_index < 64; bit_index++) {
			bool bit = onewire_bit_in();
			bit_write((uint8_t &) rom_address.rom[bit_index / 8], (bit_index % 8), bit);
		}
	}
}

bool One_wire::search_rom_find_next() {


	int discrepancy_marker, rom_bit_index;
	bool bitA, bitB;
	uint8_t byte_counter, bit_mask;

	if (!reset_check_for_device()) {
		printf("Failed to reset one wire bus\n");
		return false;
	} else {
		if (_last_device) {
			return false;	// all devices found
		}
		rom_bit_index = 1;
		discrepancy_marker = 0;
		onewire_byte_out(SearchROMCommand);
		byte_counter = 0;
		bit_mask = 0x01;
		while (rom_bit_index <= 64) {
			bitA = onewire_bit_in();
			bitB = onewire_bit_in();
			if (bitA & bitB) {
				discrepancy_marker = 0;// data read error, this should never happen
				rom_bit_index = 0xFF;
				printf("Data read error - no devices on bus?\r\n");
			} else {
				if (bitA | bitB) {
					// Set ROM bit to Bit_A
					if (bitA) {
						_search_ROM[byte_counter] =
								_search_ROM[byte_counter] | bit_mask;// Set ROM bit to one
					} else {
						_search_ROM[byte_counter] =
								_search_ROM[byte_counter] & ~bit_mask;// Set ROM bit to zero
					}
				} else {
					// both bits A and B are low, so there are two or more devices present
					if (rom_bit_index == _last_discrepancy) {
						_search_ROM[byte_counter] =
								_search_ROM[byte_counter] | bit_mask;// Set ROM bit to one
					} else {
						if (rom_bit_index > _last_discrepancy) {
							_search_ROM[byte_counter] =
									_search_ROM[byte_counter] & ~bit_mask;// Set ROM bit to zero
							discrepancy_marker = rom_bit_index;
						} else {
							if ((_search_ROM[byte_counter] & bit_mask) == 0x00)
								discrepancy_marker = rom_bit_index;
						}
					}
				}
				onewire_bit_out(_search_ROM[byte_counter] & bit_mask);
				rom_bit_index++;
				if (bit_mask & 0x80) {
					byte_counter++;
					bit_mask = 0x01;
				} else {
					bit_mask = bit_mask << 1;
				}
			}
		}
		_last_discrepancy = discrepancy_marker;
		if (rom_bit_index != 0xFF) {
			#ifdef _LIST_ROMS
			printf ("Found %02x%02x%02x%02x%02x%02x%02x%02x\n",
				_search_ROM[0], _search_ROM[1], _search_ROM[2], _search_ROM[3],
				_search_ROM[4], _search_ROM[5], _search_ROM[6], _search_ROM[7]
				);
			#endif

			if (rom_checksum_error(_search_ROM)) {// Check the CRC
				printf("failed crc\r\n");
				return false;
			}
			rom_address_t address{};
			for (byte_counter = 0; byte_counter < 8; byte_counter++) {
				address.rom[byte_counter] = _search_ROM[byte_counter];
			}
			found_addresses.push_back(address);
			_last_device = _last_discrepancy == 0;
			return true;
		} else {
			return false;
		}
	}
}

void One_wire::match_rom(rom_address_t &address) {
	int i;
	if (reset_check_for_device()) {
		onewire_byte_out(MatchROMCommand);
		for (i = 0; i < 8; i++) {
			onewire_byte_out(address.rom[i]);
		}
	} else {
		printf("match_rom failed\n");
	}
}

void One_wire::skip_rom() {
	if (reset_check_for_device()) {
		onewire_byte_out(SkipROMCommand);
	} else {
		printf("skip_rom failed\n");
	}
}

bool One_wire::rom_checksum_error(uint8_t *address) {
	uint8_t crc = 0x00;
	int i;
	for (i = 0; i < 7; i++) {// Only going to shift the lower 7 bytes
		crc = crc_byte(crc, address[i]);
	}
	// After 7 bytes CRC should equal the 8th byte (ROM CRC)
	return (crc != address[7]);// will return true if there is a CRC checksum mis-match
}

bool One_wire::ram_checksum_error() {
	uint8_t crc = 0x00;
	int i;
	for (i = 0; i < 8; i++) {// Only going to shift the lower 8 bytes
		crc = crc_byte(crc, ram[i]);
	}
	// After 8 bytes CRC should equal the 9th byte (RAM CRC)
	return (crc != ram[8]);// will return true if there is a CRC checksum mis-match
}

uint8_t One_wire::crc_byte(uint8_t crc, uint8_t byte) {
	int j;
	for (j = 0; j < 8; j++) {
		if ((byte & 0x01) ^ (crc & 0x01)) {
			// DATA ^ LSB CRC = 1
			crc = crc >> 1;
			// Set the MSB to 1
			crc = (uint8_t) (crc | 0x80);
			// Check bit 3
			if (crc & 0x04) {
				crc = (uint8_t) (crc & 0xFB);// Bit 3 is set, so clear it
			} else {
				crc = (uint8_t) (crc | 0x04);// Bit 3 is clear, so set it
			}
			// Check bit 4
			if (crc & 0x08) {
				crc = (uint8_t) (crc & 0xF7);// Bit 4 is set, so clear it
			} else {
				crc = (uint8_t) (crc | 0x08);// Bit 4 is clear, so set it
			}
		} else {
			// DATA ^ LSB CRC = 0
			crc = crc >> 1;
			// clear MSB
			crc = (uint8_t) (crc & 0x7F);
			// No need to check bits, with DATA ^ LSB CRC = 0, they will remain unchanged
		}
		byte = byte >> 1;
	}
	return crc;
}

int One_wire::convert_temperature(rom_address_t &address, bool wait, bool all) {
	int delay_time = 750;// Default delay time
	uint8_t resolution;
	if (all)
		skip_rom();// Skip ROM command, will convert for ALL devices, wait maximum time
	else {
		match_rom(address);
		if ((FAMILY_CODE == FAMILY_CODE_DS18B20) || (FAMILY_CODE == FAMILY_CODE_DS1822)) {
			resolution = (uint8_t) (ram[4] & 0x60);
			if (resolution == 0x00) // 9 bits
				delay_time = 94;
			if (resolution == 0x20) // 10 bits
				delay_time = 188;
			if (resolution == 0x40) // 11 bits.
				delay_time = 375;
			//Note 12bits uses the 750ms default
		}
		if (FAMILY_CODE == FAMILY_CODE_MAX31826) {
			delay_time = 150;// 12bit conversion
		}
	}

	onewire_byte_out(ConvertTempCommand);// perform temperature conversion
	if (_parasite_power) {
		if (_power_mosfet) {
			gpio_put(_parasite_pin, _power_polarity);// Parasite power strong pull up
			sleep_ms(delay_time);
			gpio_put(_parasite_pin, !_power_polarity);
			delay_time = 0;
		} else {
			gpio_set_dir(_data_pin, GPIO_OUT);
			gpio_put(_data_pin, true);
			sleep_ms(delay_time);
			gpio_set_dir(_data_pin, GPIO_IN);
		}
	} else {
		if (wait) {
			sleep_ms(delay_time);
			delay_time = 0;
		}
	}
	return delay_time;
}

void One_wire::read_scratch_pad(rom_address_t &address) {
	int i;
	match_rom(address);
	onewire_byte_out(ReadScratchPadCommand);
	for (i = 0; i < 9; i++) {
		ram[i] = onewire_byte_in();
	}
}

bool One_wire::set_resolution(rom_address_t &address, unsigned int resolution) {
	bool answer = false;
	switch (FAMILY_CODE) {
		case FAMILY_CODE_DS18B20:
		case FAMILY_CODE_DS18S20:
		case FAMILY_CODE_DS1822:
			resolution = resolution - 9;
			if (resolution < 4) {
				resolution = resolution << 5;                    // align the bits
				ram[4] = (uint8_t) ((ram[4] & 0x60) | resolution);// mask out old data, insert new
				write_scratch_pad(address, (ram[2] << 8) + ram[3]);
				answer = true;
			}
			break;
		default:
			break;
	}
	return answer;
}

void One_wire::write_scratch_pad(rom_address_t &address, int data) {
	ram[3] = (uint8_t) data;
	ram[2] = (uint8_t) (data >> 8);
	match_rom(address);
	onewire_byte_out(WriteScratchPadCommand);
	onewire_byte_out(ram[2]);// T(H)
	onewire_byte_out(ram[3]);// T(L)
	if ((FAMILY_CODE == FAMILY_CODE_DS18S20) || (FAMILY_CODE == FAMILY_CODE_DS18B20) ||
		(FAMILY_CODE == FAMILY_CODE_DS1822)) {
		onewire_byte_out(ram[4]);// Configuration register
	}
}

uint64_t One_wire::to_uint64(rom_address_t &address) {
        return  ((uint64_t)address.rom[7])        |
               (((uint64_t)address.rom[6]) << 8 ) |
               (((uint64_t)address.rom[5]) << 16) |
               (((uint64_t)address.rom[4]) << 24) |
               (((uint64_t)address.rom[3]) << 32) |
               (((uint64_t)address.rom[2]) << 40) |
               (((uint64_t)address.rom[1]) << 48) |
               (((uint64_t)address.rom[0]) << 56);
}

float One_wire::temperature(rom_address_t &address, bool convert_to_fahrenheit) {
	float answer, remaining_count, count_per_degree;
	int reading;
	read_scratch_pad(address);
	if (ram_checksum_error())
		// Indicate we got a CRC error
		answer = invalid_conversion;
	else {
		reading = (ram[1] << 8) + ram[0];
		if (reading & 0x8000) {                    // negative degrees C
			reading = 0 - ((reading ^ 0xffff) + 1);// 2's comp then convert to signed int
		}

		answer = (float) reading;

		switch (FAMILY_CODE) {
			case FAMILY_CODE_MAX31826:
			case FAMILY_CODE_DS18B20:
			case FAMILY_CODE_DS1822:
				answer = answer / 16.0f;
				break;
			case FAMILY_CODE_DS18S20:
				remaining_count = ram[6];
				count_per_degree = ram[7];
				answer = (float) (std::floor(answer / 2.0f) - 0.25f +
								  (count_per_degree - remaining_count) / count_per_degree);
				break;
			default:
				printf("Unsupported device family\n");
				break;
		}

		if (convert_to_fahrenheit) {
			answer = answer * 9.0f / 5.0f + 32.0f;
		}
	}
	return answer;
}

bool One_wire::power_supply_available(rom_address_t &address, bool all) {
	if (all) {
		skip_rom();
	} else {
		match_rom(address);
	}
	onewire_byte_out(ReadPowerSupplyCommand);
	return onewire_bit_in();
}

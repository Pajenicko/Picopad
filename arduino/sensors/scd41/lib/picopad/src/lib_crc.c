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

#if USE_CRC

#define CRC32_INIT  ((uint32_t)-1l)
#define CRC32_POLY 0x04C11DB7

/**
 * Reflects the least significant 'bits' of 'data' to produce a mirrored value.
 *
 * @param data The input data to be reflected.
 * @param bits The number of bits to reflect.
 * @return The reflected value.
 */
uint32_t reflect(uint32_t data, int bits) {
	uint32_t result = 0;

	// Iterate through each bit of the data
	for (int i = 0; i < bits; i++) {
		// If the current bit is set
		if (data & (1 << i)) {
			// Set the corresponding bit in the result in a mirrored position
			result |= 1 << (bits - 1 - i);
		}
	}

	return result;
}

/**
 * Computes the CRC32 checksum for the given data buffer using a specified polynomial.
 *
 * @param crc Initial CRC value.
 * @param buf Pointer to the data buffer.
 * @param len Length of the data buffer.
 * @return The CRC32 checksum.
 */
uint32_t CRC32POLY(uint32_t crc, const void *buf, int len) {
	const uint8_t *s = (const uint8_t *) buf;  // Cast the buffer to a byte pointer for byte-wise processing

	// Process each byte of the data
	for (; len > 0; len--, s++) {
		// XOR the reflected byte with the most significant byte of the CRC
		crc ^= reflect(*s, 8) << 24;

		// Process each bit of the byte
		for (int i = 0; i < 8; i++) {
			// If the MSB of the CRC is set
			if (crc & 0x80000000) {
				// Shift left and XOR with the polynomial
				crc = (crc << 1) ^ CRC32_POLY;
			} else {
				// Simply shift left
				crc <<= 1;
			}
		}
	}

	// Reflect the final CRC and XOR with 0xFFFFFFFF
	return reflect(crc, 32) ^ 0xFFFFFFFF;
}

/**
 * Computes the CRC32 checksum for the given data buffer using DMA.
 * This function uses the DMA hardware to offload the CRC calculation.
 * Reference: https://crccalc.com/?crc=123456789&method=CRC-32&datatype=ascii&outtype=0
 *
 * @param ptr Pointer to the data buffer.
 * @param len Length of the data buffer in bytes.
 * @return The CRC32 checksum.
 */
uint32_t CRC32(const void *ptr, int len) {
	// Variable to store the computed CRC32 value
	uint32_t crc;

	// Dummy destination for DMA transfer; data won't be actually written here
	uint32_t dummy_dest[1];

	// Claim an unused DMA channel
	int chan = dma_claim_unused_channel(true);

	// Get default DMA channel configuration
	dma_channel_config c = dma_channel_get_default_config(chan);

	// Set the transfer data size to 32 bits
	channel_config_set_transfer_data_size(&c, DMA_SIZE_32);
	// Enable read address increment; we'll be reading from source in sequence
	channel_config_set_read_increment(&c, true);
	// Disable write address increment as we're writing to a dummy destination
	channel_config_set_write_increment(&c, false);

	// CRC32 specific DMA configuration
	// Enable the sniffer hardware which computes the CRC32 on-the-fly
	channel_config_set_sniff_enable(&c, true);
	// Set the initial value for CRC32 calculation
	dma_sniffer_set_data_accumulator(CRC32_INIT);
	// Enable bit-reversal on the CRC32 output, as required by CRC32 spec
	dma_sniffer_set_output_reverse_enabled(true);
	// Turn on CRC32 calculation mode in the sniffer
	dma_sniffer_enable(chan, DMA_SNIFF_CTRL_CALC_VALUE_CRC32R, true);

	// Configure and start the DMA transfer
	dma_channel_configure(
			chan,          // Channel to be configured
			&c,            // The configuration we just set up
			dummy_dest,    // The (unchanging) write address (dummy destination)
			ptr,           // The initial read address
			len / 4,       // Number of 32-bit transfers
			true           // Start the transfer immediately
	);

	// Wait for the DMA transfer (and CRC computation) to complete
	dma_channel_wait_for_finish_blocking(chan);

	// Retrieve the computed CRC32 value from the sniffer, and apply bit-wise NOT operation
	crc = ~dma_sniffer_get_data_accumulator() & 0xFFFFFFFF;

	// Disable the CRC32 sniffer and release the DMA channel
	dma_sniffer_disable();
	dma_channel_unclaim(chan);

	return crc;
}

#endif
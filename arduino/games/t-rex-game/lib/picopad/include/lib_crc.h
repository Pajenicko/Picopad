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
#if USE_CRC

#ifndef CRC_H
#define CRC_H

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Computes the CRC32 checksum for the given data buffer using a specified polynomial.
 *
 * @param crc Initial CRC value.
 * @param buf Pointer to the data buffer.
 * @param len Length of the data buffer.
 * @return The CRC32 checksum.
 */
uint32_t CRC32POLY(uint32_t crc, const void *buf, int len);

/**
* Computes the CRC32 checksum for the given data buffer using DMA.
* This function uses the DMA hardware to offload the CRC calculation.
* Reference: https://crccalc.com/?crc=123456789&method=CRC-32&datatype=ascii&outtype=0
*
* @param ptr Pointer to the data buffer.
* @param len Length of the data buffer in bytes.
* @return The CRC32 checksum.
*/
uint32_t CRC32(const void *ptr, int len);

#ifdef __cplusplus
}
#endif

#endif // CRC_H

#endif // USE_CRC

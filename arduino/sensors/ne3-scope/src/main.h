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

#ifndef NE3_SCOPE_MAIN_H
#define NE3_SCOPE_MAIN_H

#include "Arduino.h"

#define IMAGE_SIZE (605 + (50 * 1024) - 1)
#define MAX_BUFFER_SIZE 1500

const char *ssid = "HNDEC_55-FC0F48";
const int udpPort = 36000;
const char *ip = "192.168.169.1";
const int port = 8800;

struct Header {
		uint16_t message_size;
		uint64_t image_number;
		uint16_t frame_number;
		uint8_t chunk_number;
		uint8_t total_chunks;
		uint16_t image_size;
		uint16_t width;
		uint16_t height;
		uint8_t quality;
		uint16_t chunk_size;

		explicit Header(const uint8_t *header_data) {
			message_size = *reinterpret_cast<const uint16_t *>(&header_data[2]);
			image_number = *reinterpret_cast<const uint64_t *>(&header_data[8]);
			frame_number = *reinterpret_cast<const uint16_t *>(&header_data[16]);
			chunk_number = header_data[32];
			total_chunks = header_data[36];
			image_size = *reinterpret_cast<const uint16_t *>(&header_data[40]);
			width = *reinterpret_cast<const uint16_t *>(&header_data[44]);
			height = *reinterpret_cast<const uint16_t *>(&header_data[46]);
			quality = header_data[48];
			chunk_size = *reinterpret_cast<const uint16_t *>(&header_data[54]);
		}

		void print() const {
			Serial.printf("message_size: %hu | ", message_size);
			Serial.printf("image_number: %llu | ", image_number);
			Serial.printf("frame_number: %hu | ", frame_number);
			Serial.printf("chunk_number: %d | ", chunk_number);
			Serial.printf("total_chunks: %d | ", total_chunks);
			Serial.printf("image_size: %hu | ", image_size);
			Serial.printf("width: %hu | ", width);
			Serial.printf("height: %hu | ", height);
			Serial.printf("quality: %d | ", quality);
			Serial.printf("chunk_size: %hu \n", chunk_size);
		}
};

#endif //NE3_SCOPE_MAIN_H

/**
* MIT License
*
* Copyright (c) 2023 Tomas Vecera, tomas@vecera.dev
*
* Portions of this software are derived from the NE3-Scope python client:
* https://github.com/haxko/NE3-Scope/tree/main
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

#include "main.h"
#include "picopad.h"
#include <WiFi.h>
#include <JPEGDEC.h>
#include "jpg_headers.h"
#include "lwip/udp.h"
#include "tiny_drawtft.h"

// Global Variables
uint8_t chunk_count = 0; // Count of chunks received
uint8_t chunks[IMAGE_SIZE]; // Array to hold image chunks
int total_size = 0; // Total size of the received image
uint8_t incomingPacket[1500]; // Buffer to hold incoming UDP packets
uint64_t current_img_number = 1; // Current image number being processed
uint64_t last_full_image = 0; // The last complete image received
double current_angle = 0; // Current angle value
struct udp_pcb *upcb; // UDP Protocol Control Block
char buf[1500]; // Buffer to hold temporary data

// Variables to hold various timestamps
unsigned long last_msg = millis();
unsigned long last_request_more = millis();
unsigned long last_null_packet = millis();
unsigned long lTime;
unsigned long now;

// JPEG decoder object
JPEGDEC jpeg;

// Function to get JPG Header based on quality
const uint8_t *getJpgHeader(uint8_t quality) {
	switch (quality) {
		case 5:
			return jpeg_header_640x360_Q5;
		case 10:
			return jpeg_header_640x360_Q10;
		case 25:
			return jpeg_header_640x360_Q25;
		case 50:
			return jpeg_header_640x360_Q50;
		case 75:
			return jpeg_header_640x360_Q75;
		case 100:
			return jpeg_header_640x360_Q100;
		default:
			return jpeg_header_640x360_Q75;
	}
}

// Function to send UDP data to a specified port
int send_udp_data(u16_t dest_port, const char *data, size_t data_size) {
	struct pbuf *p;
	ip_addr_t dest_ip;

	// It creates a pbuf (packet buffer) and sends it to the specified IP and port.
	if (!ipaddr_aton(ip, &dest_ip)) {
		Serial.println("Error creating IP address");
		return -1;
	}

	// Handles errors such as allocation failure and return failure.
	p = pbuf_alloc(PBUF_TRANSPORT, data_size, PBUF_RAM);
	if (!p) {
		Serial.println("Error alloc pbuf");
		return -1;
	}
	memcpy(p->payload, data, data_size);

	if (udp_sendto(upcb, p, &dest_ip, dest_port) != ERR_OK) {
		pbuf_free(p);
		Serial.println("Error sendto");
		return -1;
	}
	pbuf_free(p);

	return 0;
}

// Function to send camera initial packet
void send_init() {
	char data_init[] = {0xef, 0x00, 0x04, 0x00};
	// Sends a specific initialization packet to a predefined port.
	send_udp_data(port, data_init, sizeof(data_init));
}

// Function to send a null UDP packet to camera
void send_null_pkt() {
	char data[] = {};
	// Sends a null packet to port 1234.
	send_udp_data(1234, data, sizeof(data));
}

// Function to convert length to bytes
void len_to_bytes(uint16_t l, uint8_t *result) {
	result[0] = l & 0xff;
	result[1] = (l >> 8) & 0xff;
}

// Function to convert an integer to bytes
void int_to_bytes(uint64_t num, uint8_t *bytes) {
	for (int i = 0; i < 8; i++) {
		bytes[i] = (num >> (8 * i)) & 0xFF;
	}
}

// Function to send ACK+REQ messages as one UDP message
void send_msgs(uint8_t **msgs, size_t *msg_lens, size_t num_msgs) {
	uint8_t to_send[1024];
	uint8_t *ptr = to_send;

	memcpy(ptr, "\x02\x02\x00\x01", 4);
	ptr += 4;
	int_to_bytes(num_msgs, ptr);
	ptr += 8;
	memcpy(ptr, "\x00\x00\x00\x00\x00\x00\x00\x00\x0a\x4b\x14\x2d\x00\x00\x00\x00", 16);
	ptr += 16;

	for (size_t i = 0; i < num_msgs; i++) {
		memcpy(ptr, msgs[i], msg_lens[i]);
		ptr += msg_lens[i];
	}

	memcpy(ptr, "\x00\x00\x00\x00\x00\x00\x00\x00", 8);
	ptr += 8;

	char final_msg[1024 + 4];
	final_msg[0] = 0xef;
	final_msg[1] = 0x02;
	uint8_t len_bytes[2];
	len_to_bytes(ptr - to_send + 4, len_bytes);
	memcpy(final_msg + 2, len_bytes, 2);
	memcpy(final_msg + 4, to_send, ptr - to_send);

	send_udp_data(port, final_msg, ptr - to_send + 4);
}

// Function creates ACK message of an image
void msg_ack_img(uint64_t img_number, uint8_t *result) {
	int_to_bytes(img_number, result);

	uint8_t fixed_bytes[] = {0x01, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF};
	memcpy(result + 8, fixed_bytes, 12);
}

// Function creates REQ message of an image
void msg_req_img(uint64_t img_number, uint8_t *result) {
	int_to_bytes(img_number, result);

	uint8_t fixed_bytes[] = {0x03, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00};
	memcpy(result + 8, fixed_bytes, 8);
}

// Callback function to draw JPEG image
int JPEGDraw(JPEGDRAW *pDraw) {
	DispWindow(pDraw->x, pDraw->x + pDraw->iWidth, pDraw->y + 30, pDraw->y + 30 + pDraw->iHeight);
	DispWriteData(pDraw->pPixels, (pDraw->iWidth * pDraw->iHeight) * 2);
	return 1;
}

// Function to print WiFi status to the Serial port
void printWifiStatus() {
	Serial.print("SSID: ");
	Serial.println(WiFi.SSID());
	IPAddress localIo = WiFi.localIP();
	Serial.print("IP Address: ");
	Serial.println(localIo);
	long rssi = WiFi.RSSI();
	Serial.print("Signal strength (RSSI):");
	Serial.print(rssi);
	Serial.println(" dBm");
}

// Callback function to handle received UDP packets
// Handles received UDP packets and processes image chunks.
void udp_recv_callback(void *arg, struct udp_pcb *l_upcb, struct pbuf *p, const ip_addr_t *addr, u16_t l_port) {
	uint8_t buffer[MAX_BUFFER_SIZE];
	u16_t copied = 0;
	struct pbuf *current = p;

	while (current != nullptr && copied < MAX_BUFFER_SIZE) {
		u16_t to_copy = current->len;
		if (copied + to_copy > MAX_BUFFER_SIZE) {
			to_copy = MAX_BUFFER_SIZE - copied;
		}
		memcpy(buffer + copied, current->payload, to_copy);
		copied += to_copy;
		current = current->next;
	}

	if (p->tot_len) {
		memcpy(incomingPacket, buffer, p->tot_len);
		if (incomingPacket[0] == 0x93 && incomingPacket[1] == 0x01) {
			last_msg = millis();
			incomingPacket[p->tot_len] = 0;
			auto header = Header(incomingPacket);

			if (header.image_number > current_img_number) {
				chunk_count = 0;
				total_size = 605;
				current_img_number = header.image_number;
				memset(chunks, 0, IMAGE_SIZE);
				memcpy(chunks, getJpgHeader(header.quality), 605);
			}

			if (header.image_number == current_img_number) {
				int chunkSize = header.message_size - 56;
				if (chunkSize > 1024) chunkSize = 1024;

				if (header.chunk_number == 0) {
					header.print();
					chunk_count = 0;
					total_size = 605;
					current_img_number = header.image_number;
					memcpy(chunks, getJpgHeader(header.quality), 605);

					char x_str[6];
					memcpy(x_str, incomingPacket + header.chunk_size, 5);
					x_str[5] = '\0';
					int x = (int) strtol(x_str, nullptr, 10);

					char y_str[7];
					memcpy(y_str, incomingPacket + header.chunk_size + 6, 6);
					y_str[6] = '\0';
					int y = (int) strtol(y_str, nullptr, 10);

					if (x == 0 && y == 1024) {
						current_angle = 90;
					} else {
						current_angle = atan2(x, y);
						current_angle = current_angle * (180.0 / M_PI);
					}
				}

				memcpy(chunks + 605 + header.chunk_number * 1024, incomingPacket + 56, chunkSize);
				chunk_count++;
				total_size += chunkSize;
				if (chunk_count == header.total_chunks) {
					chunks[total_size] = 0xff;
					chunks[total_size + 1] = 0xd9;
					total_size = total_size + 2;
					last_full_image = header.image_number;
					uint8_t msg_ack[20];
					uint8_t msg_req[16];
					msg_ack_img(current_img_number, msg_ack);
					msg_req_img(current_img_number + 1, msg_req);
					uint8_t *msgs[] = {msg_ack, msg_req};
					size_t msg_lens[] = {sizeof(msg_ack), sizeof(msg_req)};
					send_msgs(msgs, msg_lens, 2);

					if (jpeg.openRAM(chunks, total_size, JPEGDraw)) {
						lTime = micros();
						Serial.printf("Total size: %d\n", total_size);
						int result = jpeg.decode(0, 0, JPEG_SCALE_HALF);
						jpeg.close();
						lTime = micros() - lTime;
						Serial.printf("Result: %d\n", result);
						Serial.printf("%d x %d image, decode time = %d us\n", jpeg.getWidth(), jpeg.getHeight(), (int) lTime);
					}
				}
				if (chunk_count < header.total_chunks && millis() > last_request_more + 25) {
					send_msgs(nullptr, nullptr, 0);
					last_request_more = millis();
				}
				if (millis() > last_null_packet + 5000) {
					send_null_pkt();
					last_null_packet = millis();
				}
			}
		}
	}
	pbuf_free(p);
	memset(buffer, 0, MAX_BUFFER_SIZE);
}

void setup() {
	int dx = 10;
	int dy = 40;
	Serial.begin(115200);
	delay(1000);
	Serial.println("NE3 scope application starting...");

	device_init();
	DispClear();

	DrawText("NE3 scope application starting...", dx, dy, COL_WHITE);
	dy += 15;
	DrawText("Conn. to HNDEC_55-FC0F48: ", dx, dy, COL_WHITE);

	Serial.printf("Connecting to %s ", ssid);
	unsigned long wifi_start = millis();
	WiFi.begin(ssid);
	while (WiFi.status() != WL_CONNECTED) {
		if (KeyGet() == KEY_Y) reset_to_boot_loader();
		delay(500);
		Serial.print(".");
		if (millis() > wifi_start + 10000)
			DrawText("DISCONNECTED", dx + (25 * 8) + 8, dy, COL_RED);
	}
	DrawText("CONNECTED", dx + (25 * 8) + 8, dy, COL_GREEN);
	dy += 15;
	printWifiStatus();

	Serial.printf("Starting UDP stack: ");
	DrawText("Starting UDP stack: ", dx, dy, COL_WHITE);
	upcb = udp_new();
	if (!upcb) {
		Serial.print("ERROR\n");
		DrawText("ERROR", dx + (20 * 8) + 8, dy, COL_RED);
		while (KeyGet() != KEY_Y) {}
		reset_to_boot_loader();
	}
	Serial.print("OK\n");
	DrawText("OK", dx + (20 * 8) + 8, dy, COL_GREEN);
	dy += 15;

	Serial.printf("UDP port 36000 bind: ");
	DrawText("UDP port 36000 bind: ", dx, dy, COL_WHITE);
	if (udp_bind(upcb, IP_ADDR_ANY, udpPort) != ERR_OK) {
		udp_remove(upcb);
		Serial.print("ERROR\n");
		DrawText("ERROR", dx + (21 * 8) + 8, dy, COL_RED);
		while (KeyGet() != KEY_Y) {}
		reset_to_boot_loader();
	}
	Serial.print("OK\n");
	DrawText("OK", dx + (21 * 8) + 8, dy, COL_GREEN);
	dy += 30;

	Serial.printf("Waiting for first image frame ...");
	DrawText("Waiting for first image frame ...", dx, dy, COL_WHITE);

	udp_recv(upcb, udp_recv_callback, nullptr);
	Serial.print("UDP Listening on IP: ");
	Serial.println(WiFi.localIP());

	send_null_pkt();
	send_init();
}

void loop() {

	if (KeyGet() == KEY_Y) reset_to_boot_loader();
	now = millis();

	if (millis() > last_msg + 2000) {
		Serial.println("Timeout: Send INIT");
		chunk_count = 0;
		total_size = 0;
		current_img_number = 1;
		last_full_image = 0;
		memset(chunks, 0, IMAGE_SIZE);
		send_init();
		last_msg = millis();
	}

	if (last_full_image > 0 && last_full_image == current_img_number) {
		Serial.println("Timeout: Send ACK");
		uint8_t msg_ack[20];
		uint8_t msg_req[16];
		msg_ack_img(current_img_number, msg_ack);
		msg_req_img(current_img_number + 1, msg_req);
		uint8_t *msgs[] = {msg_ack, msg_req};
		size_t msg_lens[] = {sizeof(msg_ack), sizeof(msg_req)};
		send_msgs(msgs, msg_lens, 2);

		chunk_count = 0;
		total_size = 0;
		current_img_number = 1;
		last_full_image = 0;
		memset(chunks, 0, IMAGE_SIZE);
		last_msg = millis();
	}
}
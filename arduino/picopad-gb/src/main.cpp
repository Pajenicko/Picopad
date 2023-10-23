#include "Arduino.h"
#include "picopad.h"
#include "pico/stdlib.h"
#include <hardware/vreg.h>
#include <pico/multicore.h>
#include "pico/sem.h"
#include "hardware/timer.h"

// Experimental FULL GBC support
#ifndef PEANUT_FULL_GBC_SUPPORT
#define PEANUT_FULL_GBC_SUPPORT 1
#endif

// Enable sound
#define ENABLE_SOUND  1
// Enable LCD
#define ENABLE_LCD    1
// High accuracy mode for Peanut GB
#define PEANUT_GB_HIGH_LCD_ACCURACY 1

// Peanut GB library
#include <PWMAudio.h>
#include "minigb_apu.h"
#include "peanut_gb.h"

#if ENABLE_SOUND
int16_t *stream;
auto monoStream = new int16_t[AUDIO_BUFFER_SIZE_BYTES / 2];

// The sample pointers
const int16_t *start = (const int16_t *) monoStream;
const int16_t *p = start;

PWMAudio pwm(PWMSND_GPIO);
unsigned int count = 0;
#endif

float volume = 0;

// ROM data
extern const unsigned char gameRom[];
// ROM Bank 0 data
static unsigned char romBank0[65536];
// Game RAM
static uint8_t gameRam[65536];

// LCD Line status
semaphore_t lcdLineStatus;

// Previous joypad state
static struct {
		unsigned a: 1;
		unsigned b: 1;
		unsigned select: 1;
		unsigned start: 1;
		unsigned right: 1;
		unsigned left: 1;
		unsigned up: 1;
		unsigned down: 1;
} prevGamepadState;

// Multicore command structure
union coreCommand {
		struct {
#define NO_OPERATION_CMD        0
#define DRAW_LCD_LINE_CMD       1
#define IDLE_SET_CMD            2
				uint8_t cmd;
				uint8_t unused1;
				uint8_t unused2;
				uint8_t data;
		};
		uint32_t full;
};

// Pixel data buffer
static uint8_t pixelBuffer[LCD_WIDTH];

// GameBoy context
static struct gb_s gbContext;

// GameBoy ROM read function
uint8_t gbRomRead(struct gb_s *gb, const uint_fast32_t addr) {
	(void) gb;
	if (addr < sizeof(romBank0))
		return romBank0[addr];

	return gameRom[addr];
}

// GameBoy cartridge RAM read function
uint8_t gbCartRamRead(struct gb_s *gb, const uint_fast32_t addr) {
	(void) gb;
	return gameRam[addr];
}

// GameBoy cartridge RAM write function
void gbCartRamWrite(struct gb_s *gb, const uint_fast32_t addr, const uint8_t val) {
	gameRam[addr] = val;
}

// Error handler function
void gbErrorHandler(struct gb_s *gb, const enum gb_error_e gb_err, const uint16_t addr) {
	reset_usb_boot(0, 0);
}

// Palette definition
static const uint16_t greyscalePalette[3][4] = {
		{0xFFFF, 0xAD55, 0x52AA, 0x0000},
		{0xFFFF, 0xAD55, 0x52AA, 0x0000},
		{0xFFFF, 0xAD55, 0x52AA, 0x0000}
};

static const uint16_t colorPalette[3][4] = {
		{0xFFFF, 0xED13, 0xA207, 0x0000,},
		{0xFFFF, 0xED13, 0xA207, 0x0000,},
		{0xFFFF, 0x9E89, 0x3C9B, 0x0000,},
};

#if PEANUT_FULL_GBC_SUPPORT

inline uint16_t convertRGB555toRGB565(uint16_t color) {
	uint16_t r = (color & 0x7C00) << 1;  // Shift red channel left
	uint16_t g = (color & 0x03E0) << 1;  // Shift green channel left
	uint16_t b = (color & 0x001F);       // Blue channel stays the same

	// If the least significant bit of the original green channel was set, increment the new green channel
	if (color & 0x0020) {
		g |= 0x0020;
	}
	return r | g | b;
}

#endif

inline void core1DrawLine(const uint_fast8_t line) {
	static uint16_t fb[WIDTH];

	for (uint8_t x = 0; x < LCD_WIDTH; x++) {
		uint16_t color;
#if PEANUT_FULL_GBC_SUPPORT
		if (gbContext.cgb.cgbMode) {  // CGB
			color = convertRGB555toRGB565(gbContext.cgb.fixPalette[pixelBuffer[x]]);
		} else {  // DMG
#endif
			color = colorPalette[(pixelBuffer[x] & LCD_PALETTE_ALL) >> 4][pixelBuffer[x] & 3];
#if PEANUT_FULL_GBC_SUPPORT
		}
#endif
		fb[2 * x] = color;
		fb[(2 * x + 1)] = color;
	}

	bool duplicate = line % 3 != 0;
	uint_fast8_t duplicateLines = line / 3;
	uint_fast8_t writeLine = (2 * line) - duplicateLines;
	writeLine += !duplicate;

	if (duplicate && line < 143) {
		DispWindow(0, WIDTH, writeLine, writeLine + 2);
		DispWriteData(fb, WIDTH * 2);
		DispWriteData(fb, WIDTH * 2);
	} else {
		DispWindow(0, WIDTH, writeLine, writeLine + 1);
		DispWriteData(fb, WIDTH * 2);
	}

//	DrawLine(fb, writeLine);
//	if (duplicate && line < 143) {
//		DrawLine(fb, writeLine + 1);
//	}

	sem_release(&lcdLineStatus);
}

void lcdDrawLine(struct gb_s *gb, const uint8_t pixels[LCD_WIDTH], const uint_fast8_t line) {
	coreCommand cmd{};

	/* Wait until previous line is sent. */
	sem_acquire_blocking(&lcdLineStatus);

	memcpy(pixelBuffer, pixels, LCD_WIDTH);

	/* Populate command. */
	cmd.cmd = DRAW_LCD_LINE_CMD;
	cmd.data = line;

	multicore_fifo_push_blocking(cmd.full);
}

// Main function for Core 1
void core1_entry() {
	union coreCommand cmd{};

	DispClear();

	while (true) {
		cmd.full = multicore_fifo_pop_blocking();
		switch (cmd.cmd) {
			case DRAW_LCD_LINE_CMD:
				core1DrawLine(cmd.data);
				break;
			case IDLE_SET_CMD:
			case NO_OPERATION_CMD:
			default:
				break;
		}
	}
}

#if ENABLE_SOUND

void cb() {
	while (pwm.availableForWrite()) {
		pwm.write(*p++, false);
		count++;
		if (count >= AUDIO_SAMPLES) {
			count = 0;
			p = start;
		}
	}
}

#endif

bool repeating_timer_callback(struct repeating_timer *t) {
	KeyScan();
	return true;
}

void setup(void) {
	// Overclocking the system
	{
		// Frequency of the voltage controlled oscillator (VCO) - 266MHz
		const unsigned vcoFrequency = 1596 * 1000 * 1000;
		const unsigned div1 = 6, div2 = 1;

		// Setting voltage and system clock
		vreg_set_voltage(VREG_VOLTAGE_1_15);
		sleep_ms(2);
		set_sys_clock_pll(vcoFrequency, div1, div2);
		sleep_ms(2);
	}

	// Configure clocks and initialize SPI
	clock_configure(clk_peri, 0, CLOCKS_CLK_PERI_CTRL_AUXSRC_VALUE_CLKSRC_PLL_SYS, 133000 * 1000, 133000 * 1000);

	device_init();
	DispClear();

	volume = Config.volume > 100 ? 100 : Config.volume;
	volume = volume > 0 ? static_cast<float>(0.2f * exp(log(10) * volume / 100)) : 0;

	// Variable for storing return status of initialization
	enum gb_init_error_e initStatus;
	// Initialize GB context
	memcpy(romBank0, gameRom, sizeof(romBank0));
	initStatus = gb_init(&gbContext, &gbRomRead, &gbCartRamRead, &gbCartRamWrite, &gbErrorHandler, nullptr);
	if (initStatus != GB_INIT_NO_ERROR) {
		reset_usb_boot(0, 0);
	}

	gb_init_lcd(&gbContext, &lcdDrawLine);

	sem_init(&lcdLineStatus, 1, 1);

	// Start Core1, which processes requests to the LCD
	multicore_launch_core1(core1_entry);

#if ENABLE_SOUND
	if (volume > 0) {
		stream = static_cast<int16_t *>(malloc(AUDIO_BUFFER_SIZE_BYTES));
		assert(stream != nullptr);
		memset(stream, 0, AUDIO_BUFFER_SIZE_BYTES);  // Zero out the stream buffer

		pwm.onTransmit(cb);
		pwm.setBuffers(4, 64);
		pwm.begin(32768);

		// Init audio
		audio_init();
	}
#endif
}

// Main game loop
void loop() {
	// Turn ON Peanut GB frame skip
	// You should change based on ROM
#if PEANUT_FULL_GBC_SUPPORT
	if (gbContext.cgb.cgbMode) {
		// Uncomment = Super turbo mod :)
		gbContext.direct.frame_skip = 1;
		//gbContext.direct.interlace = 1;
	} else {
		gbContext.direct.frame_skip = 1;
	}
#else
	gbContext.direct.frame_skip = 1;
	gbContext.display.frame_skip_count = 1;
#endif

	do {
		gb_run_frame(&gbContext);

#if ENABLE_SOUND
		if (volume > 0) {

			audio_callback(nullptr, stream, AUDIO_BUFFER_SIZE_BYTES);

			int32_t leftChannel, rightChannel;
			int i, j = 0;
			for (i = 0; i < AUDIO_BUFFER_SIZE_BYTES / 2; i += 2) {
				leftChannel = stream[i];
				rightChannel = stream[i + 1];
				// Convert to mono 16bit and apply gain factor
				auto monoSample = static_cast<int32_t>(((leftChannel + rightChannel) / 2) * volume);
				// Clip the value to the range of a 16-bit signed integer
				monoSample = MIN(MAX(monoSample, -32768), 32767);
				monoStream[i / 2] = static_cast<int16_t>(monoSample);
				j++;
			}
		}
#endif
		// Update gamepad state
		prevGamepadState.up = gbContext.direct.joypad_bits.up;
		prevGamepadState.down = gbContext.direct.joypad_bits.down;
		prevGamepadState.left = gbContext.direct.joypad_bits.left;
		prevGamepadState.right = gbContext.direct.joypad_bits.right;
		prevGamepadState.a = gbContext.direct.joypad_bits.a;
		prevGamepadState.b = gbContext.direct.joypad_bits.b;
		prevGamepadState.select = gbContext.direct.joypad_bits.select;
		prevGamepadState.start = gbContext.direct.joypad_bits.start;

		// Map Picopad buttons to Peanut GB emulator
		gbContext.direct.joypad_bits.up = !KeyPressed(KEY_UP);
		gbContext.direct.joypad_bits.down = !KeyPressed(KEY_DOWN);
		gbContext.direct.joypad_bits.left = !KeyPressed(KEY_LEFT);
		gbContext.direct.joypad_bits.right = !KeyPressed(KEY_RIGHT);
		gbContext.direct.joypad_bits.a = !KeyPressed(KEY_A);
		gbContext.direct.joypad_bits.b = !KeyPressed(KEY_B);
		gbContext.direct.joypad_bits.start = !KeyPressed(KEY_X);
		gbContext.direct.joypad_bits.select = !KeyPressed(KEY_Y);

		if (!gbContext.direct.joypad_bits.select) {
			if (!gbContext.direct.joypad_bits.start && prevGamepadState.start) {
				// Reset core1 and reset to bootloader
				reset_to_boot_loader();
			}

			if (!gbContext.direct.joypad_bits.a && prevGamepadState.a) {
				/* select + A: enable/disable frame-skip => fast-forward */
				gbContext.direct.frame_skip = !gbContext.direct.frame_skip;
			}
		}

	} while (true);
}

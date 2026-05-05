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

// Check if SD card functionality is enabled
#if USE_SD

// Include headers related to SD card and disk I/O operations
#include "sd_card.h"
#include "diskio.h"
#include "pico/printf.h"

// Hardware Configuration of SPI "objects"
// Note: Multiple SD cards can be driven by one SPI if they use different slave selects.
static spi_t spis[] = {
		{
				.hw_inst=SD_SPI,
				.miso_gpio=SD_RX,
				.mosi_gpio=SD_TX,
				.sck_gpio=SD_SCK,
				.baud_rate=SD_BAUD,
				.DMA_IRQ_num=DMA_IRQ_1,
		}
};

// Configuration of the SD Card "objects"
static sd_card_t sd_cards[] = {
		{
				.pcName="0:",
				.spi_if = {
						.spi = &spis[0],
						.ss_gpio = SD_CS
				},
				.use_card_detect = false,
				.m_Status = STA_NOINIT
		}
};

// Return the number of available SD cards
size_t sd_get_num() {
	return count_of(sd_cards);
}

// Get the SD card by its number
sd_card_t *sd_get_by_num(size_t num) {
	if (num <= sd_get_num()) {
		return &sd_cards[num];
	} else {
		return NULL;
	}
}

// Return the number of available SPIs
size_t spi_get_num() {
	return count_of(spis);
}

// Get the SPI by its number
spi_t *spi_get_by_num(size_t num) {
	if (num <= sd_get_num()) {
		return &spis[num];
	} else {
		return NULL;
	}
}

// Unmount the SD card from the system
void sd_unmount() {
	sd_card_t *pSD = sd_get_by_num(0);
	if (pSD->sd_test_com(pSD)) {
		f_unmount("");
	}
}

// Mount the SD card to the system
bool sd_mount() {
	sd_card_t *pSD = sd_get_by_num(0);
	if (!pSD->sd_test_com(pSD)) return false;
	return f_mount(&pSD->fatfs, "", 1) == FR_OK;
}

// Open an existing file on the SD card
bool file_open(FIL *file, const char *path, BYTE mode) {
	sd_card_t *pSD = sd_get_by_num(0);
	if (!pSD->sd_test_com(pSD)) return false;
	if (file == NULL || path[0] == 0) return false;

	return f_open(file, path, mode) == FR_OK;
}

// Create or overwrite a file on the SD card
bool file_create(FIL *file, const char *path) {
	sd_card_t *pSD = sd_get_by_num(0);
	if (!pSD->sd_test_com(pSD)) return false;
	if (file == NULL || path[0] == 0) return false;
	if (!file_open(file, path, FA_WRITE | FA_OPEN_ALWAYS)) return false;

	return f_sync(file) == FR_OK;
}

// Close an opened file on the SD card
bool file_close(FIL *file) {
	sd_card_t *pSD = sd_get_by_num(0);
	if (!pSD->sd_test_com(pSD)) return false;
	if (file == NULL) return false;
	if (f_sync(file) != FR_OK) return false;

	return f_close(file) == FR_OK;
}

// Read from an opened file on the SD card
int file_read(FIL *file, void *buf, uint32_t num) {
	sd_card_t *pSD = sd_get_by_num(0);
	if (!pSD->sd_test_com(pSD)) return 0;
	if (file == NULL || num == 0) return 0;

	UINT count = 0;
	FRESULT result = f_read(file, buf, num, &count);

	if (result != FR_OK) return 0;

	return count;
}

// Check if a file exists on the SD card
bool file_exist(const char *path) {
	sd_card_t *pSD = sd_get_by_num(0);
	if (!pSD->sd_test_com(pSD)) return false;
	if (path[0] == 0) return false;
	FILINFO info;

	return f_stat(path, &info) == FR_OK;
}

// Write to an opened file on the SD card
bool file_write(FIL *file, const void *buf, uint32_t num) {
	sd_card_t *pSD = sd_get_by_num(0);
	if (!pSD->sd_test_com(pSD)) return false;
	if (num == 0 || file == NULL) return false;

	UINT count = 0;
	FRESULT result = f_write(file, buf, num, &count);

	if (result != FR_OK) return false;

	return num == count;
}

// Check if the provided file is currently opened
bool is_file_open(FIL *file) {
	sd_card_t *pSD = sd_get_by_num(0);
	if (!pSD->sd_test_com(pSD)) return false;

	return (file != NULL) && (file->flag != 0) && (file->err == 0);
}

// Change the current directory on the SD card
bool set_dir(const char *path) {
	sd_card_t *pSD = sd_get_by_num(0);
	if (!pSD->sd_test_com(pSD)) return false;

	return f_chdir(path) == FR_OK;
}

// Get the current directory on the SD card
uint16_t get_dir(char *buf, uint16_t len) {
	sd_card_t *pSD = sd_get_by_num(0);
	if (!pSD->sd_test_com(pSD)) return 0;

	FRESULT res = f_getcwd(buf, len);
	uint16_t path_length = strlen(buf);

	return path_length > len || res != FR_OK ? 0 : path_length;
}

uint16_t find_dir_by_cluster(uint32_t cluster, char *path, uint16_t len) {
	FRESULT res;
	DIR dir, tempDir;
	UINT i;
	static FILINFO fno;

	res = f_opendir(&dir, path);
	if (res != FR_OK) return 0;

	for (;;) {
		res = f_readdir(&dir, &fno);
		if (res != FR_OK || fno.fname[0] == 0) break;

		if (fno.fattrib & AM_DIR) {
			char tempPath[len + 1];
			snprintf(tempPath, len, "%s/%s", path, fno.fname);

			if (f_opendir(&tempDir, tempPath) == FR_OK) {
				if (tempDir.clust == cluster) {
					strncpy(path, tempPath, len);
					f_closedir(&dir);
					f_closedir(&tempDir);
					return strlen(path);
				}
				f_closedir(&tempDir);
			}

			i = strlen(path);
			if (i + strlen(fno.fname) + 2 > len) {
				f_closedir(&dir);
				return 0;
			}

			sprintf(&path[i], "/%s", fno.fname);
			uint16_t result = find_dir_by_cluster(cluster, path, len);
			if (result) {
				f_closedir(&dir);
				return result;
			}

			path[i] = 0;
		}
	}

	f_closedir(&dir);
	return 0;
}

bool get_dir_cluster(char *pat, uint32_t *cluster) {
	if (strlen(pat) == 0) return false;
	DIR currentDir;
	*cluster = 0;

	if (f_opendir(&currentDir, pat) == FR_OK) {
		*cluster = currentDir.clust;
		set_dir(pat);
	} else {
		return false;
	}

	f_closedir(&currentDir);

	return true;
}

/*
 * f_findfirst wrapper function
 *
 * dir - Pointer to the blank directory object
 * file - Pointer to the file information structure
 * path - Pointer to the directory to open
 * pattern - Pointer to the matching pattern
 */
bool open_search(DIR *dir, FILINFO *file, char *path, const char *pattern) {
	return f_findfirst(dir, file, path, pattern) == FR_OK;
}

/*
 * f_findnext wrapper function
 *
 * dir - Pointer to the open directory object
 * file - Pointer to the file information structure
 */
bool find_next(DIR *dir, FILINFO *file) {
	return f_findnext(dir, file) == FR_OK && file->fname[0];
}

bool close_search(DIR *dir) {
	return f_closedir(dir) == FR_OK;
}

// Get the size of the provided file
uint32_t file_size(FIL *file) {
	sd_card_t *pSD = sd_get_by_num(0);
	if (!pSD->sd_test_com(pSD)) return 0;

	if (pSD->fatfs.fs_type == FS_EXFAT) {
		return file->obj.c_size;
	}

	return file->obj.objsize;
}

// Seek file read/write pointer (returns false on error)
bool file_seek(FIL *file, uint32_t off) {
	sd_card_t *pSD = sd_get_by_num(0);
	if (!pSD->sd_test_com(pSD)) return false;
	if (file == NULL) return false;

	return f_lseek(file, off) == FR_OK;
}

void sd_init() {
	// initialize pins
	gpio_set_function(SD_RX, GPIO_FUNC_SPI);
	gpio_set_function(SD_SCK, GPIO_FUNC_SPI);
	gpio_set_function(SD_TX, GPIO_FUNC_SPI);

	// initialize CS (active state is LOW)
	gpio_init(SD_CS);
	gpio_put(SD_CS, 1);
	gpio_set_dir(SD_CS, GPIO_OUT);

	spi_init(SD_SPI, SD_BAUD);

	sd_init_driver();
}

// Terminate SD card interface
void sd_terminate() {
	sd_unmount();

	// set SS signal to HIGH (=unselect)
	gpio_put(SD_CS, 1);

	// SPI terminate
	spi_deinit(SD_SPI);

	// Terminate pins
	gpio_deinit(SD_RX);
	gpio_deinit(SD_SCK);
	gpio_deinit(SD_TX);
	gpio_deinit(SD_CS);
}

#endif
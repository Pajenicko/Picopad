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
// Preprocessor checks if SD card functionality is enabled
#if USE_SD

#ifndef SD_H
#define SD_H

#ifdef __cplusplus
extern "C" {
#endif

// Undefine and redefine the macro FF_VOLUMES to 1
#undef FF_VOLUMES
#define FF_VOLUMES    1

// Initialize the SD card interface
void sd_init();

// Terminate the SD card interface
void sd_terminate();

// Mount the SD card to the system
bool sd_mount();

// Unmount the SD card from the system
void sd_unmount();

// Open an existing file on the SD card
bool file_open(FIL *file, const char *path, BYTE mode);

// Create or overwrite a file on the SD card
bool file_create(FIL *file, const char *path);

// Close an opened file on the SD card
bool file_close(FIL *file);

// Read from an opened file on the SD card
int file_read(FIL *file, void *buf, uint32_t num);

// Check if a file exists on the SD card
bool file_exist(const char *path);

// Write to an opened file on the SD card
bool file_write(FIL *file, const void *buf, uint32_t num);

// Change the current directory on the SD card
bool set_dir(const char *path);

// Get the current directory on the SD card
uint16_t get_dir(char *buf, uint16_t len);

// Check if the provided file is currently opened
bool is_file_open(FIL *file);

// Get the size of the provided file
uint32_t file_size(FIL *file);

// Seek to a specific position in the file
bool file_seek(FIL *file, uint32_t off);

uint16_t find_dir_by_cluster(uint32_t cluster, char *path, uint16_t len);

bool get_dir_cluster(char *pat, uint32_t *cluster);

bool open_search(DIR *dir, FILINFO *file, char *path, const char *pattern);

bool close_search(DIR *dir);

bool find_next(DIR *dir, FILINFO *file);

#ifdef __cplusplus
}
#endif

#endif

#endif // USE_SD

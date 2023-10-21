#ifndef USER_CONFIG_H
#define USER_CONFIG_H

#define DEFAULT_BRIGHTNESS 5
#define DEFAULT_VOLUME 5
#define DEFAULT_SCREEN_SLEEP 1
#define DEFAULT_REFRESH_BATTERY 1
#define DEFAULT_BATTERY_ALARM 1

// Battery alarm threshold to play alarm battery low sound. Can be 0..12
#define BATTERY_ALARM_THRESHOLD 1

// Duration (in seconds) for which the battery alarm will play an annoying sound :)
#define BATTERY_ALARM_DURATION 0.5

// Use ST7789 driver. Set to 0 to disable.
#define USE_ST7789    1

// Use DRAWTFT driver. Set to 0 to disable.s
#define USE_DRAWTFT  1

// PWM sound
#define USE_PWMSND  4  // 4 - use PWM sound output; set 1.. = number of channels (lib_pwmsnd.c, lib_pwmsnd.h)

#define USE_SD 1

#define USE_CRC 1

#define USE_CONFIG 1

#define SYSTICK_KEYSCAN    1  // call KeyScan() function from SysTick system timer

#define USE_PICOPAD_LED  1

#define SD_BAUD 4000000  //2000000 // 7000000 // 12500000 // SD card baud speed (should be max. 7-12 Mbit/s; default standard bus speed

#endif //USER_CONFIG_H


// ****************************************************************************
//
//                                PWM sound output
//
// ****************************************************************************
// PicoLibSDK - Alternative SDK library for Raspberry Pico and RP2040
// Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz, hardyplotter2@gmail.com
// 	https://github.com/Panda381/PicoLibSDK
//	https://www.breatharian.eu/hw/picolibsdk/index_en.html
//	https://github.com/pajenicko/picopad
//	https://picopad.eu/en/
// License:
//	This source code is freely available for any purpose, including commercial.
//	It is possible to take and modify the code or parts of it, without restriction.

// Sounds are at format 8-bit unsigned (middle at 128), 22050 samples per second, mono
// PWM cycle is 256: TOP = 255
// Required PWM clock: 22050*256 = 5644800 Hz

// ... GP19 ... MOSI + sound output (PWM1 B)

#if USE_PWMSND		// use PWM sound output; set 1.. = number of channels (lib_pwmsnd.c, lib_pwmsnd.h)

#ifndef _PWMSND_H
#define _PWMSND_H

#ifdef __cplusplus
extern "C" {
#endif

//#define PWMSND_GPIO	0	// PWM output GPIO pin (0..29)

#define PWMSND_SLICE	PWM_GPIOTOSLICE(PWMSND_GPIO) // PWM slice index
#define PWMSND_CHAN	PWM_GPIOTOCHAN(PWMSND_GPIO) // PWM channel index (=1)

#define SOUNDRATE	22050	// sound rate [Hz]
#define PWMSND_TOP	255	// PRM top (period = PWMSND_TOP + 1 = 256)
#define PWMSND_CLOCK	(SOUNDRATE*(PWMSND_TOP+1)) // PWM clock (= 22050*256 = 5644800)

#define SNDFRAC	10	// number of fraction bits
#define SNDINT (1<<SNDFRAC) // integer part of sound fraction

// current sound
extern const u8* CurSound[USE_PWMSND];	// current playing sound
extern volatile int SoundCnt[USE_PWMSND]; // counter of current playing sound (<=0 no sound)
extern int SoundInc[USE_PWMSND];	// pointer increment
extern volatile int SoundAcc[USE_PWMSND]; // pointer accumulator
extern const u8* NextSound[USE_PWMSND];	// next sound to play repeated sound
extern int NextSoundCnt[USE_PWMSND];	// counter of next sound (0=no repeated sound)
extern int SoundVol[USE_PWMSND]; // sound volume (SNDINT = normal)

extern Bool GlobalSoundOff;	// global sound OFF

// initialize PWM sound output (must be re-initialized after changing CLK_SYS system clock)
void PWMSndInit();

void PWMSndInitInternal(uint8_t integer, uint8_t fract);

// terminate PWM sound output
void PWMSndTerm();

// stop playing sound
void StopSoundChan(u8 chan);
void StopSound();

// output PWM sound (sound must be PCM 8-bit mono 22050Hz)
//  chan = channel 0..
//  snd = pointer to sound
//  len = length of sound in number of samples
//  rep = True to repeat sample
//  speed = relative speed (1=normal)
//  volume = volume (1=normal)
void PlaySoundChan(u8 chan, const u8* snd, int len, Bool rep, float speed, float volume);
void PlaySound(const u8* snd, int len);
#define PLAYSOUND(snd) PlaySound((snd), count_of(snd))

// output PWM sound repeated
void PlaySoundRep(const u8* snd, int len);
#define PLAYSOUNDREP(snd) PlaySoundRep((snd), count_of(snd))

// update sound speed (1=normal speed)
void SpeedSoundChan(u8 chan, float speed);
void SpeedSound(float speed);

// update sound volume (1=normal volume)
void VolumeSoundChan(u8 chan, float volume);
void VolumeSound(float volume);

// check if playing sound
Bool PlayingSoundChan(u8 chan);
Bool PlayingSound();

// set next repeated sound
void SetNextSoundChan(u8 chan, const u8* snd, int len);
void SetNextSound(const u8* snd, int len);

// global sound set OFF
void GlobalSoundSetOff();

// global sound set ON
void GlobalSoundSetOn();

void SetVolume(u8 value);

#ifdef __cplusplus
}
#endif

#endif // _PWMSND_H

#endif // USE_PWMSND		// use PWM sound output; set 1.. = number of channels (lib_pwmsnd.c, lib_pwmsnd.h)

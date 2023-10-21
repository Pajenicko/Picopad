
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

// Note: Cannot use DMA, because sample is 8-bit, but CC port requires 16-bit write.

#include "picopad.h"

#if USE_PWMSND

#include "RP2040.h"

// current sound
const u8* CurSound[USE_PWMSND]; // current playing sound
volatile int SoundCnt[USE_PWMSND]; // counter of current playing sound (<=0 no sound)
int SoundInc[USE_PWMSND]; // pointer increment
volatile int SoundAcc[USE_PWMSND]; // pointer accumulator
const u8* NextSound[USE_PWMSND]; // next sound to play repeated sound
int NextSoundCnt[USE_PWMSND]; // counter of next sound (0=no repeated sound)
int SoundVol[USE_PWMSND]; // sound volume (SNDINT = normal)

Bool GlobalSoundOff = False;	// global sound OFF

float GlobalVolume = 1;

// PWM sound interrupt service
void PWMSndIrq() {
    uint PWM_GPIO_SLICE = pwm_gpio_to_slice_num(PWMSND_GPIO);
    uint PWM_GPIO_CHANNEL = pwm_gpio_to_channel(PWMSND_GPIO);

    // clear interrupt request
    pwm_clear_irq(PWM_GPIO_SLICE);

    // default sample if no sound
    int samp = 128 * SNDINT;

    // check if sound is playing
    int ch;
    bool sound_playing = false;

    for (ch = 0; ch < USE_PWMSND; ch++) {
        int cnt = SoundCnt[ch];
        if (cnt > 0) {
            sound_playing = true;
            // get next sample
            const u8 *snd = CurSound[ch];
            samp += (int) (*snd - 128) * SoundVol[ch];

            // increment pointer accumulator
            int acc = SoundAcc[ch] + SoundInc[ch];
            int i = acc >> SNDFRAC; // whole increment
            snd += i;
            cnt -= i;
            acc &= (SNDINT - 1);

            // repeated sample
            if (cnt <= 0) {
                cnt = NextSoundCnt[ch];
                snd = NextSound[ch];
            }

            // save new pointer
            SoundCnt[ch] = cnt;
            SoundAcc[ch] = acc;
            CurSound[ch] = snd;
        }
    }

    if (sound_playing) {
        samp >>= SNDFRAC;
        if (samp < 0) samp = 0;
        if (samp > 255) samp = 255;

        // write PWM sample
        pwm_set_chan_level(PWM_GPIO_SLICE, PWM_GPIO_CHANNEL, (u8) samp);
    } else {
        pwm_set_chan_level(PWM_GPIO_SLICE, PWM_GPIO_CHANNEL, 0);
    }
}

void PWMSndInit() {
    PWMSndInitInternal(22, 2);
}

// initialize PWM sound output (must be re-initialized after changing CLK_SYS system clock)
void PWMSndInitInternal(uint8_t integer, uint8_t fract) {
	SetVolume(load_config_data().volume);
    // sound is OFF
    if (GlobalSoundOff) return;

    uint PWM_GPIO_SLICE = pwm_gpio_to_slice_num(PWMSND_GPIO);
    uint PWM_GPIO_CHANNEL = pwm_gpio_to_channel(PWMSND_GPIO);

    // reset PWM to default state
    pwm_set_irq_enabled(PWM_GPIO_SLICE, false);
    pwm_clear_irq(PWM_GPIO_SLICE);
    pwm_config config = pwm_get_default_config();
    config.csr = 0;
    config.div = 0x10;
    config.top = 0xffff;

    // set GPIO function to PWM
    gpio_set_function(PWMSND_GPIO, GPIO_FUNC_PWM);

    // clear descriptors
    int i;
    for (i = 0; i < USE_PWMSND; i++) SoundCnt[i] = 0;

    // set IRQ handler

    irq_set_exclusive_handler(PWM_IRQ_WRAP, PWMSndIrq);
    NVIC_EnableIRQ(PWM_IRQ_WRAP);

    // set clock divider
    //  125 MHz: 125000000/5644800 = 22.144, INT=22, FRAC=2,
    //     real sample rate = 125000000/(22+2/16)/256 = 22069Hz
	pwm_config_set_clkdiv_int_frac(&config, integer, fract);

    // set period to 256 cycles
    pwm_config_set_wrap(&config, PWMSND_TOP);

    pwm_init(PWM_GPIO_SLICE, &config, false);

    pwm_set_chan_level(PWM_GPIO_SLICE, PWM_GPIO_CHANNEL, 128);

    // enable PWM (will be enabled on 1st using of some sound to avoid speaker noise)
    // pwm_set_enabled(PWM_GPIO_SLICE, true);

    // interrupt enable
    pwm_set_irq_enabled(PWM_GPIO_SLICE, true);
}

// terminate PWM sound output
void PWMSndTerm() {
    uint PWM_GPIO_SLICE = pwm_gpio_to_slice_num(PWMSND_GPIO);

    // disable PWM
    pwm_set_enabled(PWM_GPIO_SLICE, false);

    // interrupt disable
    pwm_set_irq_enabled(PWM_GPIO_SLICE, false);

    // clear interrupt request
    pwm_clear_irq(PWM_GPIO_SLICE);

    // set GPIO function to default
    gpio_init(PWMSND_GPIO);
}

// stop playing sound
void StopSoundChan(u8 chan) {
    _dmb();
    SoundCnt[chan] = 0;
    _dmb();
}

void StopSound()
{
	StopSoundChan(0);
}

// output PWM sound (sound must be PCM 8-bit mono 22050Hz)
//  chan = channel 0..
//  snd = pointer to sound
//  len = length of sound in number of samples
//  rep = True to repeat sample
//  speed = relative speed (1=normal)
//  volume = volume (1=normal)
void PlaySoundChan(u8 chan, const u8* snd, int len, Bool rep, float speed, float volume)
{
	if (GlobalSoundOff) return;
	uint PWM_GPIO_SLICE = pwm_gpio_to_slice_num(PWMSND_GPIO);

	// stop playing sound
	StopSoundChan(chan);

	// repeated sound
	NextSoundCnt[chan] = 0;
	if (rep)
	{
		NextSound[chan] = snd;
		NextSoundCnt[chan] = len;
	}

	// sound speed
	SoundInc[chan] = (int)(SNDINT*speed + 0.5f);
	SoundAcc[chan] = 0;

    // sound volume
    SoundVol[chan] = (int) (SNDINT * GlobalVolume + 0.5f);

	// start current sound
	CurSound[chan] = snd;
	_dmb();
	SoundCnt[chan] = len;
	_dmb();

    // enable PWM
    pwm_set_enabled(PWM_GPIO_SLICE, true);
}

void PlaySound(const u8* snd, int len)
{
	PlaySoundChan(0, snd, len, False, 1, 1);
}

// output PWM sound repeated
void PlaySoundRep(const u8* snd, int len)
{
	PlaySoundChan(0, snd, len, True, 1, 1);
}

// update sound speed (1=normal speed)
void SpeedSoundChan(u8 chan, float speed)
{
	SoundInc[chan] = (int)(SNDINT*speed + 0.5f);
}

void SpeedSound(float speed)
{
	SpeedSoundChan(0, speed);
}

// update sound volume (1=normal volume)
void VolumeSoundChan(u8 chan, float volume)
{
	SoundVol[chan] = (int)(SNDINT*volume + 0.5f);
}

void VolumeSound(float volume)
{
	VolumeSoundChan(0, volume);
}

// check if playing sound
Bool PlayingSoundChan(u8 chan)
{
	if (GlobalSoundOff) return False;

	return SoundCnt[chan] > 0;
}

Bool PlayingSound()
{
	if (GlobalSoundOff) return False;

	return PlayingSoundChan(0);
}

// set next repeated sound
void SetNextSoundChan(u8 chan, const u8* snd, int len)
{
	// check if this sound is already next sound
	if (PlayingSoundChan(chan) && (NextSound[chan] == snd) && (NextSoundCnt[chan] == len)) return;

	// disable next sound
	NextSoundCnt[chan] = 0;
	_dmb();

	// start sound if not playing
	if (SoundCnt[chan] == 0)
	{
		CurSound[chan] = snd;
		_dmb();
		SoundCnt[chan] = len;
		_dmb();
	}

	// set next sound
	NextSound[chan] = snd;
	_dmb();
	NextSoundCnt[chan] = len;
}

void SetNextSound(const u8* snd, int len)
{
	SetNextSoundChan(0, snd, len);
}

// global sound set OFF
void GlobalSoundSetOff() {
    save_volume(0);
    PWMSndTerm();
}

// global sound set ON
void GlobalSoundSetOn() {
    PWMSndTerm();
    save_volume(DEFAULT_VOLUME);
    PWMSndInit();
}

float linear_to_logarithmic(float i) {
    return 0.1f * exp(log(10) * i / 5);
}

void SetVolume(u8 value) {
    if (value > 5) value = 5;
    GlobalSoundOff = value == 0;
    GlobalVolume = linear_to_logarithmic(value);
    save_volume(value);
}

#endif // USE_PWMSND		// use PWM sound output; set 1.. = number of channels (lib_pwmsnd.c, lib_pwmsnd.h)

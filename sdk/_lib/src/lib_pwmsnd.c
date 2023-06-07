
// ****************************************************************************
//
//                                PWM sound output
//
// ****************************************************************************
// Note: Cannot use DMA, because sample is 8-bit, but CC port requires 16-bit write.

#include "../../global.h"	// globals

#if USE_PWMSND		// use PWM sound output; set 1.. = number of channels (lib_pwmsnd.c, lib_pwmsnd.h)

#include "../../_sdk/inc/sdk_irq.h"
#include "../inc/lib_pwmsnd.h"

// current sound
const u8* CurSound[USE_PWMSND]; // current playing sound
volatile int SoundCnt[USE_PWMSND]; // counter of current playing sound (<=0 no sound)
int SoundInc[USE_PWMSND]; // pointer increment
volatile int SoundAcc[USE_PWMSND]; // pointer accumulator
const u8* NextSound[USE_PWMSND]; // next sound to play repeated sound
int NextSoundCnt[USE_PWMSND]; // counter of next sound (0=no repeated sound)
int SoundVol[USE_PWMSND]; // sound volume (SNDINT = normal)

Bool GlobalSoundOff = False;	// global sound OFF

// PWM sound interrupt service
void PWMSndIrq()
{
	// clear interrupt request
	PWM_IntClear(PWMSND_SLICE);

	// default sample if no sound		
	int samp = 128*SNDINT;

	// check if sound is playing
	int ch;
	for (ch = 0; ch < USE_PWMSND; ch++)
	{
		int cnt = SoundCnt[ch];
		if (cnt > 0)
		{
			// get next sample
			const u8* snd = CurSound[ch];
			samp += (int)(*snd - 128) * SoundVol[ch];

			// increment pointer accumulator
			int acc = SoundAcc[ch] + SoundInc[ch];
			int i = acc >> SNDFRAC; // whole increment
			snd += i;
			cnt -= i;
			acc &= (SNDINT-1);

			// repeated sample
			if (cnt <= 0)
			{
				cnt = NextSoundCnt[ch];
				snd = NextSound[ch];
			}

			// save new pointer
			SoundCnt[ch] = cnt;
			SoundAcc[ch] = acc;
			CurSound[ch] = snd;
		}
	}

	samp >>= SNDFRAC;
	if (samp < 0) samp = 0;
	if (samp > 255) samp = 255;

	// write PWM sample
	PWM_Comp(PWMSND_SLICE, PWMSND_CHAN, (u8)samp);
}

// initialize PWM sound output (must be re-initialized after changing CLK_SYS system clock)
void PWMSndInit()
{
	// sound is OFF
	if (GlobalSoundOff) return;

	// reset PWM to default state
	PWM_Reset(PWMSND_SLICE);

	// set GPIO function to PWM
	PWM_GpioInit(PWMSND_GPIO);

	// clear descriptors
	int i;
	for (i = 0; i < USE_PWMSND; i++) SoundCnt[i] = 0;

	// set IRQ handler
	SetHandler(IRQ_PWM_WRAP, PWMSndIrq);
	NVIC_IRQEnable(IRQ_PWM_WRAP);

	// set clock divider
	//  125 MHz: 125000000/5644800 = 22.144, INT=22, FRAC=2,
	//     real sample rate = 125000000/(22+2/16)/256 = 22069Hz
	PWM_Clock(PWMSND_SLICE, PWMSND_CLOCK);

	// set period to 256 cycles
	PWM_Top(PWMSND_SLICE, PWMSND_TOP);

	// write default PWM sample
	PWM_Comp(PWMSND_SLICE, PWMSND_CHAN, 128);

	// enable PWM (will be enabled on 1st using of some sound to avoid speaker noise)
//	PWM_Enable(PWMSND_SLICE);

	// interrupt enable
	PWM_IntEnable(PWMSND_SLICE);
}

// terminate PWM sound output
void PWMSndTerm()
{
	// disable PWM
	PWM_Disable(PWMSND_SLICE);

	// interrupt disable
	PWM_IntDisable(PWMSND_SLICE);

	// clear interrupt request
	PWM_IntClear(PWMSND_SLICE);

	// reset PWM to default state
	PWM_Reset(PWMSND_SLICE);

	// set GPIO function to default
	GPIO_Init(PWMSND_GPIO);
}

// stop playing sound
void StopSoundChan(u8 chan)
{
	dmb();
	SoundCnt[chan] = 0;
	dmb();
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
	SoundVol[chan] = (int)(SNDINT*volume + 0.5f);

	// start current sound
	CurSound[chan] = snd;
	dmb();
	SoundCnt[chan] = len;
	dmb();

	// enable PWM
	PWM_Enable(PWMSND_SLICE);
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
	dmb();

	// start sound if not playing
	if (SoundCnt[chan] == 0)
	{
		CurSound[chan] = snd;
		dmb();
		SoundCnt[chan] = len;
		dmb();
	}

	// set next sound
	NextSound[chan] = snd;
	dmb();
	NextSoundCnt[chan] = len;
}

void SetNextSound(const u8* snd, int len)
{
	SetNextSoundChan(0, snd, len);
}

// global sound set OFF
void GlobalSoundSetOff()
{
	GlobalSoundOff = True;
	PWMSndTerm();
}

// global sound set ON
void GlobalSoundSetOn()
{
	PWMSndTerm();
	GlobalSoundOff = False;
	PWMSndInit();
}

#endif // USE_PWMSND		// use PWM sound output; set 1.. = number of channels (lib_pwmsnd.c, lib_pwmsnd.h)

import random
import adafruit_wave
import ulab.numpy as np

def lerp(a, b, t): return (1-t)*a + t*b

class Wavetable:
    """ A 'waveform' for synthio.Note that uses a wavetable w/ a scannable wave position."""

    def __init__(self, filepath, wave_len=256):
        self.w = adafruit_wave.open(filepath)
        self.wave_len = wave_len  # how many samples in each wave
        if self.w.getsampwidth() != 2 or self.w.getnchannels() != 1:
            raise ValueError("unsupported WAV format")
        # empty buffer we'll copy into
        self.waveform = np.zeros(wave_len, dtype=np.int16)
        self.num_waves = self.w.getnframes() // self.wave_len
        self.set_wave_pos(0)

    def set_wave_pos(self, pos):
        """Pick where in wavetable to be, morphing between waves"""
        pos = min(max(pos, 0), self.num_waves-1)  # constrain
        samp_pos = int(pos) * self.wave_len  # get sample position
        self.w.setpos(samp_pos)
        waveA = np.frombuffer(self.w.readframes(self.wave_len), dtype=np.int16)
        self.w.setpos(samp_pos + self.wave_len)  # one wave up
        waveB = np.frombuffer(self.w.readframes(self.wave_len), dtype=np.int16)
        pos_frac = pos - int(pos)  # fractional position between wave A & B
        self.waveform[:] = lerp(waveA, waveB, pos_frac)  # mix waveforms A & B

VOLUME = 28000
SAMPLE_SIZE = 512
# our oscillator waveform, a 512 sample downward saw wave going from +/-28k
wave_tri = np.concatenate((np.linspace(-VOLUME, VOLUME, num=SAMPLE_SIZE//2, dtype=np.int16),
                          np.linspace(VOLUME, -VOLUME, num=SAMPLE_SIZE//2, dtype=np.int16)))
wave_saw = np.linspace(VOLUME, -VOLUME, num=SAMPLE_SIZE, dtype=np.int16)
wave_squ = np.concatenate((np.ones(SAMPLE_SIZE//2, dtype=np.int16)
                          * VOLUME, np.ones(SAMPLE_SIZE//2, dtype=np.int16)*-VOLUME))
wave_sin = np.array(np.sin(np.linspace(
    0, 2*np.pi, SAMPLE_SIZE, endpoint=False)) * VOLUME, dtype=np.int16)
wave_noise = np.array([random.randint(-VOLUME, VOLUME)
                      for i in range(SAMPLE_SIZE)], dtype=np.int16)

wave_combined = wave_sin + (wave_noise / 4)
wave_combined_clipped = np.clip(wave_combined, -32768, 32767)
wave_sin_dirty = np.array(wave_combined_clipped, dtype=np.int16)

wavetable = Wavetable("PLAITS02.WAV")
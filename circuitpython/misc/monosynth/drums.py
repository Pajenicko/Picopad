import ulab.numpy as np
import random
import synthio

SAMPLE_SIZE = 200
sinwave1 = np.array(np.sin(np.linspace(0, 2*np.pi, SAMPLE_SIZE, endpoint=False)) * 32767, dtype=np.int16)
sinwave2 = np.array(np.sin(np.linspace(np.pi/2, 2.5*np.pi, SAMPLE_SIZE, endpoint=False)) * 32767, dtype=np.int16)
downwave = np.linspace(32767, -32767, num=3, dtype=np.int16)

noisewave = np.array([random.randint(-32767, 32767) for i in range(SAMPLE_SIZE)], dtype=np.int16)
w1 = np.array( [int(max(min(sinwave1[i] + (noisewave[i]/2.0), 32767), -32767)) for i in range(SAMPLE_SIZE)], dtype=np.int16)
w2 = np.array( [int(max(min(sinwave2[i] + (noisewave[i]/2.0), 32767), -32767)) for i in range(SAMPLE_SIZE)], dtype=np.int16)

class KickDrum:
    def __init__(self, synth):
        self.synth = synth
        
        self.lfo = synthio.LFO(waveform=downwave)
        self.lfo.once = True
        self.lfo.offset=0.33
        self.lfo.scale = 0.3
        self.lfo.rate=20
        
        self.filter_fr = 2000
        self.lpf = synthio.Biquad(synthio.FilterMode.LOW_PASS, frequency=self.filter_fr)

        self.amp_env1 = synthio.Envelope(attack_time=0.0, decay_time=0.075, release_time=0, attack_level=1, sustain_level=0)
        self.note1 = synthio.Note(frequency=53, envelope=self.amp_env1, waveform=sinwave2, filter=self.lpf, bend=self.lfo)

        self.amp_env2 = synthio.Envelope(attack_time=0.0, decay_time=0.055, release_time=0, attack_level=1, sustain_level=0)
        self.note2 = synthio.Note(frequency=72, envelope=self.amp_env2, waveform=sinwave1, filter=self.lpf, bend=self.lfo)

        self.amp_env3 = synthio.Envelope(attack_time=0.0, decay_time=0.095, release_time=0, attack_level=1, sustain_level=0)
        self.note3 = synthio.Note(frequency=41, envelope=self.amp_env3, waveform=sinwave2, filter=self.lpf, bend=self.lfo)
    
    def setLPF(self, fr):
        self.filter_fr = fr
        self.lpf = synthio.Biquad(synthio.FilterMode.LOW_PASS, frequency=self.filter_fr)
        self.note1.filter = self.lpf
        self.note2.filter = self.lpf
        self.note3.filter = self.lpf

    def play(self, synth=None):
        if synth is None:
            synth = self.synth
        self.lfo.retrigger()
        synth.press((self.note1, self.note2, self.note3))

class Snare:
    def __init__(self, synth):
        self.synth = synth
        
        self.lfo = synthio.LFO(waveform=downwave)
        self.lfo.once = True
        self.lfo.offset=0.33
        self.lfo.scale = 0.3
        self.lfo.rate=20

        self.filter_fr = 9500
        self.lpf = synthio.Biquad(synthio.FilterMode.LOW_PASS, frequency=self.filter_fr)

        self.amp_env1 = synthio.Envelope(attack_time=0.0, decay_time=0.115, release_time=0, attack_level=1, sustain_level=0)
        self.note1 = synthio.Note(frequency=90, envelope=self.amp_env1, waveform=w1, filter=self.lpf, bend=self.lfo)

        self.amp_env2 = synthio.Envelope(attack_time=0.0, decay_time=0.095, release_time=0, attack_level=1, sustain_level=0)
        self.note2 = synthio.Note(frequency=135, envelope=self.amp_env2, waveform=w2, filter=self.lpf, bend=self.lfo)

        self.amp_env3 = synthio.Envelope(attack_time=0.0, decay_time=0.115, release_time=0, attack_level=1, sustain_level=0)
        self.note3 = synthio.Note(frequency=165, envelope=self.amp_env3, waveform=w2, filter=self.lpf, bend=self.lfo)

    def setLPF(self, fr):
        self.filter_fr = fr
        self.lpf = synthio.Biquad(synthio.FilterMode.LOW_PASS, frequency=self.filter_fr)
        self.note1.filter = self.lpf
        self.note2.filter = self.lpf
        self.note3.filter = self.lpf

    def play(self, synth=None):
        if synth is None:
            synth = self.synth
        self.lfo.retrigger()
        synth.press((self.note1, self.note2, self.note3))

class HighHat:
    def __init__(self, synth, t=0.115):
        self.lfo = synthio.LFO(waveform=downwave)
        self.lfo.once = True
        self.lfo.offset=0.33
        self.lfo.scale = 0.3
        self.lfo.rate=20
        
        self.synth = synth
        
        self.t = t

        self.filter_fr = 9500
        self.hpf = synthio.Biquad(synthio.FilterMode.HIGH_PASS, frequency=self.filter_fr)

        self.amp_env1 = synthio.Envelope(attack_time=0.0, decay_time=t, release_time=0, attack_level=1, sustain_level=0)
        self.note1 = synthio.Note(frequency=90, envelope=self.amp_env1, waveform=noisewave, filter=self.hpf, bend=self.lfo)

        self.amp_env2 = synthio.Envelope(attack_time=0.0, decay_time=t-0.02, release_time=0, attack_level=1, sustain_level=0)
        self.note2 = synthio.Note(frequency=135, envelope=self.amp_env2, waveform=noisewave, filter=self.hpf, bend=self.lfo)

        self.amp_env3 = synthio.Envelope(attack_time=0.0, decay_time=t, release_time=0, attack_level=1, sustain_level=0)
        self.note3 = synthio.Note(frequency=165, envelope=self.amp_env3, waveform=noisewave, filter=self.hpf, bend=self.lfo)

    def setHPF(self, fr):
        self.filter_fr = fr
        self.hpf = synthio.Biquad(synthio.FilterMode.HIGH_PASS, frequency=self.filter_fr)
        self.note1.filter = self.hpf
        self.note2.filter = self.hpf
        self.note3.filter = self.hpf

    def setTime(self, t):
        self.t = t
    
        self.amp_env1 = synthio.Envelope(attack_time=0.0, decay_time=t, release_time=0, attack_level=1, sustain_level=0)
        self.note1 = synthio.Note(frequency=90, envelope=self.amp_env1, waveform=noisewave, filter=self.hpf, bend=self.lfo)

        self.amp_env2 = synthio.Envelope(attack_time=0.0, decay_time=t-0.02, release_time=0, attack_level=1, sustain_level=0)
        self.note2 = synthio.Note(frequency=135, envelope=self.amp_env2, waveform=noisewave, filter=self.hpf, bend=self.lfo)

        self.amp_env3 = synthio.Envelope(attack_time=0.0, decay_time=t, release_time=0, attack_level=1, sustain_level=0)
        self.note3 = synthio.Note(frequency=165, envelope=self.amp_env3, waveform=noisewave, filter=self.hpf, bend=self.lfo)
        
    def play(self, synth=None):
        if synth is None:
            synth = self.synth
        self.lfo.retrigger()
        synth.press((self.note1, self.note2, self.note3))
        
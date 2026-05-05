# Picopad monosynth - based on @todbot's monosynth1 example
#
# monosynth1_synthio.py -- partial synthio port of 'monosynth1' from mozzi_experiments
# 22 Jun 2023 - @todbot / Tod Kurt
# part of https://github.com/todbot/circuitpython-synthio-tricks


import board
import audiomixer
import audiopwmio
import synthio
from waves import Wavetable, wave_squ, wave_sin, wave_tri, wave_saw, wave_noise
from ui import get_display
# Drums from https://gist.github.com/gamblor21/15a430929abf0e10eeaba8a45b01f5a8
from drums import KickDrum, Snare, HighHat

DEBUG = False

# basic synth settings
oscs_per_note = 3      # how many oscillators for each note
osc_detune = 0.001     # how much to detune oscillators for phatness
filter_freq_lo = 100   # filter lowest freq
filter_freq_hi = 10000  # filter highest freq
filter_res_lo = 0.5    # filter q lowest value
filter_res_hi = 2.0    # filter q highest value
vibrato_lfo_hi = 0.3   # vibrato amount when modwheel is maxxed out
vibrato_rate = 5       # vibrato frequency

# scale set with modwheel
lfo_vibrato = synthio.LFO(rate=vibrato_rate, scale=0.01)

# set up the audio system, mixer, and synth
audio = audiopwmio.PWMAudioOut(board.AUDIO) # for small internal speaker
#audio = audiopwmio.PWMAudioOut(board.D0) # for PWM output through RC filter

mixer = audiomixer.Mixer(channel_count=1, sample_rate=28000, buffer_size=2048)
synth = synthio.Synthesizer(channel_count=1, sample_rate=28000)
audio.play(mixer)
mixer.voice[0].play(synth)
mixer.voice[0].level = 0.75  # cut the volume a bit so doesn't distort

wavetable = Wavetable("PLAITS02.WAV")

# https://studiocode.dev/resources/midi-middle-c/
notes = [
    60,  # C4
    62,  # D4
    64,  # E4
    67,  # G4
]

# setup UI
display, keys, labels, bars, sprites, buttons, colors, palettes = get_display()

# simple range mapper, like Arduino map()
def map_range(s, a1, a2, b1, b2): return b1 + \
    ((s - a1) * (b2 - b1) / (a2 - a1))


def limits(value, plus, lo, hi, loop=False):
    value += plus
    if value < lo:
        if loop:
            return hi
        else:
            return lo
    if value > hi:
        if loop:
            return lo
        else:
            return hi
    return value

# midi note on
def note_on(notenum, vel=100):
    amp_level = map_range(vel, 0, 100, 0, 1)
    amp_env = synthio.Envelope(attack_time=0.1, decay_time=0.05,
                               release_time=amp_env_release_time,
                               attack_level=amp_level, sustain_level=amp_level*0.8)
    f = synthio.midi_to_hz(notenum)
    oscs.clear()  # chuck out old oscs to make new ones
    for i in range(oscs_per_note):
        fr = f * (1 + (osc_detune*i))
        lpf = synthio.Biquad(synthio.FilterMode.LOW_PASS, frequency=filter_freq, Q=filter_res)
        # in synthio, 'Note' objects are more like oscillators
        oscs.append(synthio.Note(frequency=fr, filter=lpf, envelope=amp_env,
                                 waveform=s.shapes[s.shape], bend=lfo_vibrato))
    # press the 'note' (collection of oscs acting in concert)
    synth.press(oscs)

# midi note off
def note_off():
    synth.release(oscs)
    oscs.clear()

def drum(type, sprite_num):
    if type == "kick":
        kick.play()
    elif type == "snare":
        snare.play()
    elif type == "highhat":
        highhat.play()

    sprites[sprite_num].pixel_shader = palettes.inverse
    
    if type == "off":
        sprites[sprite_num].pixel_shader = palettes.normal
            
    display.refresh()
        
    
    display.refresh()

class synh_settings():
    def __init__(self):
        self.shapes = [wave_squ, wave_sin, wave_tri,
                       wave_saw,  wave_noise, wavetable.waveform]
        self.shape = 0
        self.octave = 0
        self.lfo = 0
        self.freq = 30
        self.q = 10
        self.release = 20
        self.detune = 0

        self.current = 0

    def move(self, ch):
        labels[self.current].color = colors.white
        self.current = limits(self.current, 1*ch, 0, 7)
        labels[self.current].color = colors.red
        display.refresh()

    def change(self, ch):


        if self.current == 1:
            sprites[8+self.octave//12].pixel_shader = palettes.normal
            self.octave = limits(self.octave, 12*ch, -24, 24)
            sprites[8+self.octave//12
                    ].pixel_shader = palettes.active
        
        elif self.current == 2:
            sprites[self.shape].pixel_shader = palettes.normal
            self.shape = limits(self.shape, 1*ch, 0, 5, True)
            sprites[self.shape].pixel_shader = palettes.active

        elif self.current == 3:
            self.lfo = limits(self.lfo, 10*ch, 0, 100)
            bars[self.current-3].value = self.lfo

        elif self.current == 4:
            self.freq = limits(self.freq, 10*ch, 0, 100)
            bars[self.current-3].value = self.freq

        elif self.current == 5:
            self.q = limits(self.q, 10*ch, 0, 100)
            bars[self.current-3].value = self.q

        elif self.current == 6:
            self.release = limits(self.release, 10*ch, 0, 100)
            bars[self.current-3].value = self.release

        elif self.current == 7:
            self.detune = limits(self.detune, 10*ch, 0, 100)
            bars[self.current-3].value = self.detune

        display.refresh()


s = synh_settings()

oscs = []   # holds currently sounding oscillators
filter_freq = s.freq  # current setting of filter
filter_res = s.q   # current setting of filter
amp_env_release_time = s.release  # current release time
note_played = 0  # current note playing

bars[0].value = s.lfo
bars[1].value = s.freq
bars[2].value = s.q
bars[3].value = s.release
bars[4].value = s.detune

kick = KickDrum(synth)
snare = Snare(synth)
highhat = HighHat(synth)

if DEBUG:
    last = 0


display.refresh()


while True:
    for item in buttons:
        item.update()

    # to do global filtermod we must iterate over all oscillators in each note
    for osc in oscs:
        osc.filter = synthio.Biquad(synthio.FilterMode.LOW_PASS, frequency=filter_freq, Q=filter_res)

    for item in range(4):

        if (buttons[item].fell):
            note = notes[item] + s.octave
            note_off()
            note_on(note)
            note_played = note
            keys[item].fill = colors.white
            display.refresh()

        if (buttons[item].rose):
            note = notes[item] + s.octave
            note_off()
            keys[item].fill = colors.grey
            display.refresh()

    if (buttons[4].fell):
        if s.current == 0:
            drum("kick", 11)
        else:
            s.change(-1)
    
    if (buttons[4].rose):
        if s.current == 0:
            drum("off", 11)
            
    if (buttons[5].fell):
        if s.current == 0:
            drum("snare", 13)
        else:
            s.change(1)
    
    if (buttons[5].rose):
        if s.current == 0:
            drum("off", 13)

    if (buttons[6].fell):
        if s.current == 0:
            drum("highhat", 12)
        else:
            s.move(-1)

    if (buttons[6].rose):
        if s.current == 0:
            drum("off", 12)

    if (buttons[7].fell):
        s.move(1)

    lfo_vibrato.scale = map_range(s.lfo, 0, 100, 0, vibrato_lfo_hi)
    filter_freq = map_range(s.freq, 0, 100, filter_freq_lo, filter_freq_hi)
    filter_res = map_range(s.q, 0, 100, filter_res_lo, filter_res_hi)
    amp_env_release_time = map_range(s.release, 0, 100, 0.1, 1)
    osc_detune = map_range(s.detune, 0, 100, 0, 0.01)

    if DEBUG:
        if lfo_vibrato.scale + filter_freq + filter_res + amp_env_release_time + osc_detune != last:
            print(s.shape, s.octave, s.lfo, s.freq, s.q, s.release, s.detune)
            print(lfo_vibrato.scale, filter_freq, filter_res,
                amp_env_release_time, osc_detune)
        last = lfo_vibrato.scale + filter_freq + \
            filter_res + amp_env_release_time + osc_detune

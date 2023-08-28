"""


You can find the required librarie in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""

import board
import simpleio
import time
import pwmio
import adafruit_hcsr04
import asyncio
import digitalio

display = board.DISPLAY
# hide display terminal to better performance
display.root_group.hidden = True

# initialize the ultrasonic sensor
sensor = adafruit_hcsr04.HCSR04(trigger_pin=board.D3, echo_pin=board.D2)

# initialize the buzzer
buzzer = pwmio.PWMOut(board.AUDIO, variable_frequency=True)

# notes frequencies

C4 = 261.63
Db4 = 277.18
D4 = 293.66
Eb4 = 311.13
E4 = 329.63
F4 = 349.23
Gb4 = 369.99
G4 = 392.00
Ab4 = 415.30
A4 = 440.00
Bb4 = 466.16
B4 = 493.88

C5 = 523.25
Db5 = 554.37
D5 = 587.33
Eb5 = 622.25
E5 = 659.25
F5 = 698.46
Gb5 = 739.99
G5 = 783.99
Ab5 = 830.61
A5 = 880.00
Bb5 = 932.33
B5 = 987.77

C6 = 1046.50

# defualt beat duration
T= 0.4

# buzzer duty cycle to on (50%) and off
OFF = 0
ON = 2**15


notes = [C4, D4, E4, F4, G4, A4, B4, C5, D5, E5, F5, G5, A5, B5, C6]
notes_names = ["C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5", "D5", "E5", "F5", "G5", "A5", "B5", "C6"]

# initialize the LED
led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT


# mute
def buzzer_off():
    buzzer.duty_cycle = OFF

# play sound
def buzzer_on():
    buzzer.duty_cycle = ON  

# some calculations to remove outliers/errors from the sensor
# calculate the mean
def mean(lst):
    return sum(lst) / len(lst)

# calculate the standard deviation
def std_dev(lst):
    avg = mean(lst)
    variance = sum((x - avg) ** 2 for x in lst) / len(lst)
    return variance ** 0.5

def remove_outliers(lst, threshold=1):
    avg = mean(lst)
    std = std_dev(lst)
    if std == 0:
        return lst
    return [x for x in lst if abs((x - avg) / std) <= threshold]

# store last 5 measurements
values = [0,0,0,0,0]
values_index = 0

# metronome task - blinking the LED
async def metronome():
    global led
    while True:
        led.value = not led.value  # Toggle LED
        await asyncio.sleep(T/2)  # Sleep for half the beat duration


# measure task - measure the distance and store it in the values array
async def measure():
    global distance
    global sensor
    global values
    global values_index
    while True:
        try:
            distance = sensor.distance

        except RuntimeError:
            # sensor wasn't able to measure the distance or it is too long
            distance = 0

        # exclude too long or too short distances
        if distance > 90 or distance < 5:
            distance = 0
        
        # circular buffer for last 5 measurements
        values[values_index] = distance
        values_index = (values_index + 1) % 5
        await asyncio.sleep(0.05)


# play_note task - play the note according every T
async def play_note():
    global values
    global values_index
    global distance

    while True:
        # remove strange values and calculate the mean
        dist = mean(remove_outliers(values))
        
        # if the distance is 0 (too long, too short or error)- mute the buzzer
        if dist == 0:   
            buzzer_off()
        else:
            # map the distance to the notes
            # notes list has 15 notes
            # the distance range is 10-70 cm
            # = one note for every 4 cm
            tone = int(simpleio.map_range(dist, 10, 70, 0, 14))
            
            # print(notes_names[tone])
            
            buzzer.frequency = int(notes[tone])
            buzzer_on()

        await asyncio.sleep(T)

# distance 0 = pause/mute
distance = 0

# Prepare the event loop    
loop = asyncio.get_event_loop()

# Schedule tasks to run concurrently
loop.run_until_complete(asyncio.gather(
    play_note(),
    measure(),
    metronome()
))

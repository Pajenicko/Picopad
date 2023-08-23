# HC-SR04 Sensor Tutorial
This tutorial covers using the HC-SR04 ultrasonic distance sensor with CircuitPython and Picopad.

The HC-SR04 uses ultrasound to measure distance up to 4 meters.

## What you'll learn
- Initialize trigger and echo pins
- Read distance values
- Remove noise from measurements
- Map distance to musical notes
- Play tones using PWM buzzer
- Async tasks for sensor, sound and LED

## Quick Start - Measure Distance
Initialize the HC-SR04, trigger readings, and print distance values.

### Key concepts:
- Trigger and echo pins
- Timing echo pulse
- Calculating distance
- Printing sensor values

![cp_sensors_hcsr04_quick](https://github.com/MakerClassCZ/Picopad/assets/3875093/110da735-88d5-4381-ae3b-23b97ae2e61b)

## Music Meter - Distance Instrument
Use distance to play notes on a buzzer. LED blinks as metronome.

### Key concepts:
- Removing outlier readings
- Mapping distance to music notes
- Playing tones with PWM buzzer
- Async tasks for sensor, sound and LED

https://github.com/MakerClassCZ/Picopad/assets/3875093/b4a97e53-f044-4438-8140-b9111ead4fd5

## Summary
The tutorial covers ultrasonic distance measurement, noise reduction, value mapping, sound generation, and concurrent async programming. You'll learn to build an interactive instrument using the HC-SR04 distance sensor.

# Photoresistor Sensor Tutorial
This tutorial covers using a photoresistor with CircuitPython and Picopad to detect ambient light levels.

A photoresistor decreases resistance when light shines on it, allowing analog light measurements.

## What you'll learn
- Read analog values from a photoresistor
- Print light intensity values
- Update graphics based on sensor input
- Display light-reactive owl eyes 😊


## Quick Start - Read Light Levels
Initialize the analog pin and print out photoresistor readings.

### Key concepts:
- AnalogIn for analog input
- Reading analog voltage values
- Printing sensor values

![cp_sensors_photoresistor_quick](https://github.com/MakerClassCZ/Picopad/assets/3875093/05ea60ea-cdde-4089-8ea8-9f1c2fc88d85)

## Digi Owl - Reacts on light intensity
Use light level to control owl eye color. Eyes get brighter in dark.

### Key concepts:

- Mapping light values to colors
- Updating Circle fill color
- Displaying reactive graphics

### Intersting techniques:
- Use simpleio to map different ranges
- Using HSL color format

![cp_sensors_photoresistor_owl](https://github.com/MakerClassCZ/Picopad/assets/3875093/7efcfc41-5fbe-4571-98ab-c5bbb3c83512)

## Summary
The tutorial covers reading analog voltage levels, mapping sensor values, updating graphics, and displaying reactive content based on ambient light input.

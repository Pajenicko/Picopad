# DS18B20 Sensor Tutorial
This tutorial covers using the DS18B20 temperature sensor with CircuitPython and Picopad.

The DS18B20 is a commonly used digital temperature sensor that connects over 1-Wire interface.

## What you'll learn
- Initialize 1-Wire communication
- Read temperature from DS18B20
- Display sensor data on screen
- Create an interactive game using sensor input
- Manage concurrent tasks with asyncio

## Quick Start - Read Temperature
Initialize 1-Wire bus and read temperature from DS18B20. Print measurements.

### Key concepts:

- 1-Wire initialization
- Scanning for devices
- Reading temperature
- Printing sensor values

## Hot Air Balloon - It's in the Game
Use DS18B20 temperature to control an animated hot air balloon on the screen.  Touch the sensor with your finger to heat it up and use cold breath to cool it down 😉

### Key concepts:

- Asyncio tasks for animation
- Reading sensor in background
- Updating display
- Sprite animation

## Summary
The tutorial covers core techniques like 1-Wire communication, display animation, sensor interaction and asyncio concurrency. Each lesson builds on the previous one, towards creating a complete interactive game using the temperature sensor.
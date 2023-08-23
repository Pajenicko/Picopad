# Sensors Intro
This tutorial covers interfacing sensors using CircuitPython and Picopad. You'll learn to connect sensors over I2C, collect and visualize sensor data.

The code examples use the **SCD4x** sensor, but you can also follow along using the **internal temperature sensor** or other common sensors like **BME280** or **DS18x20** with provided class examples - goto level 3 for use these sensors.


## What you'll learn
- Initialize I2C communication
- Interact with I2C sensors like SCD4x
- Create classes to represent sensor data
- Display sensor readings on the screen
- Save data to SD card
- Send data to cloud service
- Manage concurrent tasks with asyncio

## Level 1 - Basic I2C Sensor
Initialize I2C bus and read temperature, humidity and CO2 data from SCD4x sensor.

### Key concepts:

- I2C initialization
- Reading sensor data
- Printing measurements

## Level 2 - Object Oriented Sensor
Encapsulate sensor interaction into Sensor class and represent readings as Measurement objects.

### Key concepts:
- Object oriented programming
- Representing data as objects
- Separation of concerns

## Level 3 - Visualize Sensor Data
Display sensor readings on screen using displayio and adafruit_display_text.

### Key concepts:
- Updating values on display
- Using spritesheets
- Refreshing display

## Level 4 - Asynchronous Tasks
Use asyncio to concurrently blink LED while displaying sensor data.

### Key concepts:

- Concurrent execution with asyncio
- Cooperative multitasking
- Scheduling coroutines

## Lesson 5 - Cloud Data Logging
Send sensor data to https://tmep.cz/ IoT cloud and save to SD card using asyncio.

### Key concepts:

- WiFi connectivity
- Sending HTTP requests
- Writing to SD card
- Time synchronization with NTP

## Summary
The tutorial covers core techniques like object oriented programming, asynchronous programming, cloud connectivity, data storage and visualization. Each lesson builds on the previous one, towards a complete sensor monitoring application.
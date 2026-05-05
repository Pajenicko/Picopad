"""
In this simple example, you will learn how to interface with the Sensirion SCD4x sensor,
which enables us to measure temperature, humidity, and CO2 levels in the surroundings.
This example demonstrates the step-by-step process of setting up the necessary components,
initializing the I2C bus, and accessing sensor data.

It requires the adafruit_scd4x library placed in /lib directory.
You can find the library in the CircuitPython library bundle (https://circuitpython.org/libraries).

You can use the same concept to interface with other I2C sensors as well.

If you don't have SCD4x sensor, goto Level 3 and try to use internal temperature sensor od RP2040.
"""

import board
import busio
import time
import adafruit_scd4x

# initialize i2c bus
i2c = busio.I2C(board.SCL, board.SDA)

# initialize SCD4x sensor
sensor = adafruit_scd4x.SCD4X(i2c)
sensor.start_periodic_measurement()

# read and show measured values every 5 seconds
while True:

    # wait for data to be ready
    # section 3.5.2 https://sensirion.com/media/documents/48C4B7FB/6426E14D/CD_DS_SCD40_SCD41_Datasheet_D1_052023.pdf
    while not sensor.data_ready:
        time.sleep(0.2)
    
    # read and show measured values
    print(f"Temperature: {sensor.temperature:.2f} °C")
    print(f"Humidity: {sensor.relative_humidity:.2f} %")
    print(f"CO2: {sensor.CO2:.0f} ppm")

    time.sleep(5)

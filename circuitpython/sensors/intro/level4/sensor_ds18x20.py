"""
This is example of using OneWire temperature sensor DS18B20 e.g. from official Picopad module.

It requires the adafruit_onewire and adafruit_ds18x20 library placed in /lib directory.
You can find the libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""
import board
from adafruit_onewire.bus import OneWireBus
from adafruit_ds18x20 import DS18X20

# Measurement class to store the sensor data in a structured way
class Measurement:
    def __init__(self, name, tag, type, value, unit):
        # name: human-readable name of the measured value - e.g. Temperature
        self.name = name
        # tag: identifier of the measured value, usefull for data processing - e.g. temp1
        self.tag = tag
        # type: type of the measured value, useful for visualization - e.g. temperature
        self.type = type
        # value: the measured value itself - e.g. 25.6
        self.value = value
        # unit: unit of the measured value - e.g. °C
        self.unit = unit

    # basic string representation of the Measurement object
    def __str__(self):
        return f"{self.name}: {self.value:.1f} {self.unit}"


# Sensor class to handle the sensor inicialization and data collection
class Sensor:
    def __init__(self):
        # store the measured values in a list of Measurement objects
        self.measurements = []

        #init the bus
        bus = OneWireBus(board.D0)

        # Scan for devices and select the first one found
        devices = bus.scan()
        self.sensor = DS18X20(bus, devices[0])

        # define your sensor capabilities
        self.readings = {
           "temp": {"name": "Temperature", "type": "temperature", "unit": "°C"},
        }
        
    # measure the sensor data and return a list of Measurement objects
    def measure(self):
        self.measurements = []
        
        tag = "temp"
        measurement = Measurement(
            self.readings[tag]["name"], tag, self.readings[tag]["type"], self.sensor.temperature, self.readings[tag]["unit"])
        self.measurements.append(measurement)

        return self.measurements

    # return the list of Measurement objects
    def get_measurements(self):
        return self.measurements
    
    # return only one Measurement object with the specified tag
    def get_measurement(self, tag):
        for measurement in self.measurements:
            if measurement.tag == tag:
                return measurement
        return None


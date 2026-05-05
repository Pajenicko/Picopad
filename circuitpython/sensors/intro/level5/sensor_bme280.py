"""
This is handler for BME280 sensor to use in our demos.

It requires the adafruit_bme280 library placed in /lib directory.
You can find the libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""
import board
import busio
from adafruit_bme280 import basic as adafruit_bme280


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
        # initialize i2c bus and SCD4x sensor
        i2c = busio.I2C(board.SCL, board.SDA)
        self.sensor = adafruit_bme280.Adafruit_BME280_I2C(i2c)
        self.sensor.sea_level_pressure = 1013.25
        # define your sensor capabilities
        self.readings = {
           "temp": {"name": "Temperature", "type": "temperature", "unit": "°C"},
           "humi": {"name": "Humidity", "type": "humidity", "unit": "%"},
           "pres":  {"name": "Pressure", "type": "pressure", "unit": "hPa"}
        }

    # measure the sensor data and return a list of Measurement objects
    def measure(self):
        self.measurements = []

        # Read data from sensor and save them into the list of Measurement objects
        # BME280 sensor measures temperature, relative humidity and pressure, so we will add three measurements

        tag = "temp"
        measurement = Measurement(
            self.readings[tag]["name"], tag, self.readings[tag]["type"], self.sensor.temperature, self.readings[tag]["unit"])
        self.measurements.append(measurement)

        tag = "humi"
        measurement = Measurement(
            self.readings[tag]["name"], tag, self.readings[tag]["type"], self.sensor.relative_humidity, self.readings[tag]["unit"])
        self.measurements.append(measurement)
        
        tag = "pres"
        measurement = Measurement(
            self.readings[tag]["name"], tag, self.readings[tag]["type"], self.sensor.pressure, self.readings[tag]["unit"])
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
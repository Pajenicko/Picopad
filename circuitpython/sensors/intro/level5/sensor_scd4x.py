"""
This is handler for SCD4x sensor to use in our demos.

It requires the adafruit_scd4x library placed in /lib directory.
You can find the libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""
import board
import busio
import adafruit_scd4x
import time

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
        self.sensor = adafruit_scd4x.SCD4X(i2c)
        self.sensor.start_periodic_measurement()

        # define your sensor capabilities
        self.readings = {
           "temp": {"name": "Temperature", "type": "temperature", "unit": "°C"},
           "humi": {"name": "Humidity", "type": "humidity", "unit": "%"},
           "CO2":  {"name": "CO2", "type": "co2", "unit": "ppm"}
        }

    # measure the sensor data and return a list of Measurement objects
    def measure(self):
        self.measurements = []
        # wait for data to be ready
        while not self.sensor.data_ready:
            time.sleep(0.2)

        # Read data from sensor and save them into the list of Measurement objects
        # SCD4x sensor measures temperature, relative humidity and CO2, so we will add three measurements

        tag = "temp"
        measurement = Measurement(
            self.readings[tag]["name"], tag, self.readings[tag]["type"], self.sensor.temperature, self.readings[tag]["unit"])
        self.measurements.append(measurement)

        tag = "humi"
        measurement = Measurement(
            self.readings[tag]["name"], tag, self.readings[tag]["type"], self.sensor.relative_humidity, self.readings[tag]["unit"])
        self.measurements.append(measurement)
        
        tag = "CO2"
        measurement = Measurement(
            self.readings[tag]["name"], tag, self.readings[tag]["type"], self.sensor.CO2, self.readings[tag]["unit"])
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
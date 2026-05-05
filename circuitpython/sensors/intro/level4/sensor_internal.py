"""
This is example of using internal temperature sensor of RP2040 as "sensor".
"""
import microcontroller
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

        # define your sensor capabilities
        self.readings = {
           "temp": {"name": "Temperature", "type": "temperature", "unit": "°C"},
        }
        
    # measure the sensor data and return a list of Measurement objects
    def measure(self):
        self.measurements = []
        
        tag = "temp"
        measurement = Measurement(
            self.readings[tag]["name"], tag, self.readings[tag]["type"], microcontroller.cpu.temperature, self.readings[tag]["unit"])
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


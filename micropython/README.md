# Work in progress

# demo.py

This Python script demonstrates the usage of a Picopad board with a connected display, buttons, and a buzzer.

- Initializes an ST7789 display using SPI communication.
- Displays text and graphics on the display.
- Detects button presses to perform various actions.
- Reads voltage from an ADC pin, calculates the voltage value, and displays it on the screen.
- Includes a function to toggle an LED and play simple melodies using a PWM-controlled buzzer.

# module_ds18b20.py

Sample code for [DS18B20 Digital Temperature Sensor Module](https://pajenicko.cz/picopad/picopad-modul-s-digitalnim-cidlem-teploty-ds18b20)

- The code imports the necessary modules and sets up the pins for the ST7789 display.
- Initializes the DS18B20 sensor on the OneWire bus.
- Runs a loop where it:
  - Checks for the presence of a DS18B20 sensor.
  - Reads the temperature from the sensor if found.
  - Displays the temperature on the screen.
- Continuously updates the displayed temperature, providing real-time temperature monitoring.

# module_hc-sr04.py

Sample code for [HC-SR04 Ultrasonic Distance Measuring Module](https://pajenicko.cz/picopad/picopad-modul-ultrazvukoveho-merice-vzdalenosti-hc-sr04)

- The script imports required libraries and configures the pins for the ST7789 display.
- It initializes the ultrasonic sensor HC-SR04.
- A function (measure_distance) is defined to measure distance using the ultrasonic sensor.
- Inside a perpetual loop, it measures the distance using the function and displays it on the screen.
- If the distance is greater than the sensor's maximum detection range, it waits for a second before the next measurement.
- The script continuously updates the display with the calculated distance in real time.

# module_photoresistor.py

Sample code for [GL5516 Light Sensor Module](https://pajenicko.cz/picopad/picopad-modul-svetelneho-senzoru-gl5516)

- The script sets up an ST7789 display and initializes an ADC on pin 26 for a photoresistor.
- Text is displayed on the screen to label the photoresistor demonstration.
- Inside an infinite loop, the script continuously reads ADC values from the photoresistor.
- These ADC values, indicative of light intensity, are then displayed on the screen.
- If the ADC value is less than 10000, the script clears the old value from the display to prevent ghosting.
- The script sleeps for 100ms after each read-display cycle to ensure smoother updates of the display.

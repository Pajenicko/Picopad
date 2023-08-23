#  Basic CircuitPython Tutorial
This tutorial will teach you the basics of programming with CircuitPython. It is prepared in the form of code examples with comments. Each lesson has its own directory where you can find code.py, necessary external libraries in /lib and possibly other necessary assets. To run the example, just upload the contents of the directory to the disk drive of the connected PicoPad (or other development board).

You'll start from simple examples and build up to interacting with buttons, LEDs, screen, audio and more on your Picopad or another development board.

  

## What you'll learn
- Printing messages to the console   
- Using the display and drawing text, shapes, images
- Controlling LEDs
- Reading button inputs
- Playing sounds
- Bringing it all together to create an interactive demo

## Lesson 1 - Hello World 
Directory: *hello_world*
The simplest CircuitPython program prints a message to the serial console. This verifies your environment is setup properly.

### Key concepts:
- Printing to the console
- CircuitPython code.py startup script

## Lesson 2 - Display Text
Directory: *hello_world-display*
Use the displayio and adafruit_display_text libraries to show text labels on the Picopad screen.
  
### Key concepts:
- DisplayIO graphic rendering
- Working with fonts
- Positioning and displaying text

## Lesson 3 - Blink LED
Directory: *hello_world-led*
Access the on-board LED and turn it on/off. Intro to digital IO.

### Key concepts:
- DigitalInOut for GPIO control
- Setting pin modes
- LED on/off

## Lesson 4 - Picopad Demo
Directory: *hello_world-picopad*
Bring everything together into an interactive demo using Picopad hardware like buttons, LEDs, screen and audio.

### Key concepts:
- Reading input from buttons
- Debouncing
- Playing tones
- Updating graphics dynamically
- Combining everything into a demo

## Summary
The tutorial covers core CircuitPython concepts like GPIO control, display output, sound output, debouncing inputs, and wiring everything up into a simple interactive application. Each lesson builds on the previous one, towards the complete demo project.
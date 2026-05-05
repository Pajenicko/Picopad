# Miscellaneous CircuitPython Examples

Collection of advanced examples that don't fit into other categories - audio synthesis, USB peripherals, image slideshows, and development tools.

You'll learn audio synthesis with synthio, USB HID keyboard emulation, image display from SD card, and interactive device debugging.

## Mono Synth

Polyphonic synthesizer with drum machine. Play notes with buttons, switch between waveforms (square, sine, triangle, sawtooth, noise, wavetable), adjust filter and effects parameters.

### Key concepts:

-   Audio synthesis with synthio
-   Waveform generation with ulab.numpy
-   Lowpass/highpass filters (Biquad)
-   Drum synthesis (kick, snare, hi-hat)
-   Interactive parameter UI with sprite graphics

## Macro Keyboard

Turn PicoPad into a USB HID macro keyboard. Each button sends different key sequences - from simple arrow keys to complex macros that open applications and type text.

### Key concepts:

-   USB HID keyboard emulation
-   Key press/release sequences
-   Custom keyboard layouts (Czech Windows)
-   Modifier key combinations (Ctrl, Alt, Win)

## Slideshow

Image slideshow viewer that loads BMP images from SD card. Navigate manually or enable auto-advance with configurable timing.

### Key concepts:

-   SD card file access
-   BMP image display
-   Auto-advance timing
-   Playback order (alphabetical, random)

## Fast Slideshow

Optimized image display using low-level display API. Reads pre-converted RGB565 images and sends them directly to the display bus for maximum speed.

### Key concepts:

-   Low-level display bus access
-   RGB565 image format
-   Memory-efficient chunked rendering
-   Pre-converted image assets

## REPL Tools

Interactive debugging and device introspection tool. Provides menus for I2C scanning, WiFi testing, display diagnostics, pin mapping, and more.

### Key concepts:

-   I2C device scanning and identification
-   WiFi connection management
-   Display test patterns
-   GPIO pin mapping
-   Boot mode selection

## Alarm Clock (Offline)

Standalone alarm clock that works without WiFi. Set time manually using buttons. Features alarm with buzzer sound.

### Key concepts:

-   RTC (Real Time Clock) usage
-   Button-based time setting UI
-   Alarm scheduling and notification
-   State machine (setting, normal, alarm, ringing)

# CircuitPython Network Tutorial

This tutorial covers connecting CircuitPython boards like Picopad to the internet using WiFi.

You'll learn to make HTTP requests, interact with web APIs, send sensor data to the cloud, and control devices remotely.

## What you'll learn

-   Connect to WiFi
-   Make HTTP requests
-   Parse JSON responses
-   Log sensor data to cloud
-   Control devices over internet
-   Build Telegram bot

## WiFi Test

Connect to WiFi network and print network info.

### Key concepts:

-   WiFi credentials
-   Printing MAC and IP
-   Use ping to test network connectivity

![cp_network_wifitest](https://github.com/MakerClassCZ/Picopad/assets/3875093/8586d82f-5dc1-45ac-9ff1-5d1ce81b4fed)

## Teletext

There are **two examples** how to use a web API to fetch Czech Teletext as image or text.
The image example (teletext_sdcard) requires SD Card as temporary storage for the teletext screen.

![cp_network_teletext_image](https://github.com/MakerClassCZ/Picopad/assets/3875093/161c0029-e763-443f-bd32-5266838cf937)

![cp_network_teletext_text](https://github.com/MakerClassCZ/Picopad/assets/3875093/c8ef82b7-fbab-4ee1-99f9-b9d0f66641af)


### Key concepts:

-   Making HTTP requests
-   Use external JSON API
-   Downloading binary data
-   Saving images to storage

### Interesting techniques:
- saving memory techniques
  * use of garbage collector
  * use of bitmap label
  * split large bitmap label to multiple smaller
  * use context manager (with)
- rounding number to tens/hundreds  with simple arithmetic
- custom fonts


## Telegram Bot

Build a Telegram bot to control your board remotely.

### Key concepts:

-   Telegram bot API
-   Sending messages
-   Responding to commands

### Interesting techniques:
- Use long polling with Telegram API to reduce number of requests

![cp_network_telegram](https://github.com/MakerClassCZ/Picopad/assets/3875093/ebfd61ec-c9e4-430a-a811-07f92255d43d)



## Summary

The tutorial covers core network concepts like WiFi, HTTP requests, APIs, IoT data logging, and remote control. Follow along to connect your CircuitPython projects to the internet!

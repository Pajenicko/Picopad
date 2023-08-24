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

## Teletext

There are two example how to use a web API to fetch Czech Teletext as image or text.
The image example (teletext_sdcard) requires SD Card as temporary storage for the teletext screen.

### Key concepts:

-   Making HTTP requests
-   Use external JSON API
-   Downloading binary data
-   Saving images to storage

### Interesting techniques:
- saving memory techniques
-- use of garbage collector
-- use of bitmap label
-- split large bitmap label to multiple smaller
-- use context manager (with)
- rounding number to tens/hundreds  with simple arithmetics
- custom fonts


## Telegram Bot

Build a Telegram bot to control your board remotely.

### Key concepts:

-   Telegram bot API
-   Sending messages
-   Responding to commands

### Interesting techniques:
- Use long polling with Telegram API to reduce number of requests

## Summary

The tutorial covers core network concepts like WiFi, HTTP requests, APIs, IoT data logging, and remote control. Follow along to connect your CircuitPython projects to the internet!
"""
Web Server with HTTP Polling for PicoPad

Serves a dashboard that polls for sensor data every 2 seconds.
The simplest approach - browser periodically asks the server for new data.
Shows CPU temperature, LED control, and button state.

Frontend uses Alpine.js for reactivity and Bulma CSS for styling,
both loaded from CDN so the microcontroller only serves a small HTML page.

Controls:
  Browser: toggle LED, view temperature and button state
  Device: press A button to see state change in browser

WiFi credentials must be set in settings.toml:
  CIRCUITPY_WIFI_SSID = "your_ssid"
  CIRCUITPY_WIFI_PASSWORD = "your_password"

Required libraries in /lib:
  adafruit_httpserver
"""

import board
import digitalio
import microcontroller
import wifi
import socketpool
import os
import json
from adafruit_httpserver import Server, Request, Response, FileResponse

# Connect to WiFi
print("Connecting to WiFi...")
wifi.radio.connect(os.getenv("CIRCUITPY_WIFI_SSID"), os.getenv("CIRCUITPY_WIFI_PASSWORD"))
print(f"Connected: {wifi.radio.ipv4_address}")

# Setup LED
led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT

# Setup button (active low - pressed = False)
button = digitalio.DigitalInOut(board.SW_A)
button.direction = digitalio.Direction.INPUT
button.pull = digitalio.Pull.UP

# Start HTTP server
pool = socketpool.SocketPool(wifi.radio)
server = Server(pool, root_path="/static")


@server.route("/")
def index(request: Request):
    return FileResponse(request, "index.html")


@server.route("/data")
def data(request: Request):
    body = json.dumps({
        "temp": round(microcontroller.cpu.temperature, 1),
        "led": not led.value,
        "btn": not button.value,
    })
    return Response(request, body, content_type="application/json")


@server.route("/led/toggle")
def toggle_led(request: Request):
    led.value = not led.value
    body = json.dumps({"led": not led.value})
    return Response(request, body, content_type="application/json")


print(f"Starting server on http://{wifi.radio.ipv4_address}:80")
server.start(str(wifi.radio.ipv4_address), port=80)

while True:
    server.poll()

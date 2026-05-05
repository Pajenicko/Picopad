"""
Web Server with WebSocket for PicoPad

Serves a dashboard with real-time bidirectional communication via WebSocket.
Unlike SSE, WebSocket allows the browser to send commands (LED toggle)
through the same connection that receives updates - no separate HTTP requests needed.
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
import time
from adafruit_httpserver import Server, Request, FileResponse, Websocket

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

# WebSocket connection - only one client at a time on microcontroller
ws = None


def get_data():
    return json.dumps({
        "temp": round(microcontroller.cpu.temperature, 1),
        "led": not led.value,
        "btn": not button.value,
    })


@server.route("/")
def index(request: Request):
    return FileResponse(request, "index.html")


@server.route("/ws")
def websocket(request: Request):
    global ws
    if ws is not None:
        ws.close()
    ws = Websocket(request)
    return ws


print(f"Starting server on http://{wifi.radio.ipv4_address}:80")
server.start(str(wifi.radio.ipv4_address), port=80)

last_send = 0
last_btn = not button.value
last_temp = round(microcontroller.cpu.temperature, 1)

while True:
    server.poll()

    if ws:
        # Check for incoming messages from browser
        try:
            message = ws.receive()
        except Exception:
            ws = None
            continue

        if message == "toggle_led":
            led.value = not led.value
            # Send updated state immediately after toggle
            try:
                ws.send_message(get_data())
            except Exception:
                ws = None
                continue

        # Send update when button state changes
        btn = not button.value
        if btn != last_btn:
            last_btn = btn
            try:
                ws.send_message(get_data())
            except Exception:
                ws = None
                continue

        # Send temperature update every 5 seconds
        now = time.monotonic()
        if now - last_send >= 5:
            last_send = now
            try:
                ws.send_message(get_data())
            except Exception:
                ws = None

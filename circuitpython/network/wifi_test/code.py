# SPDX-FileCopyrightText: 2022 Liz Clark for Adafruit Industries
#
# SPDX-License-Identifier: MIT
# source: https://learn.adafruit.com/pico-w-wifi-with-circuitpython/pico-w-basic-wifi-test

import os
import ipaddress
import wifi
import socketpool
import time

"""
make sure to set your WiFi credentials
in settings.toml before running this example
"""

print("Connecting to WiFi")

# connect to your SSID
wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))

print("Connected to WiFi %s" % (os.getenv('CIRCUITPY_WIFI_SSID')))

pool = socketpool.SocketPool(wifi.radio)

# prints MAC address to REPL
print("MAC addr:", ":".join([hex(i).replace("0x","").upper() for i in wifi.radio.mac_address]))

# prints IP address to REPL
print("IP addr: ", wifi.radio.ipv4_address)

# set Google IPv4 address
google_ipv4 = ipaddress.ip_address("8.8.4.4")

# ping Google every 15 seconds
while True:
    
    print("Ping google.com: %f ms" % (wifi.radio.ping(google_ipv4)*1000))
    time.sleep(15)
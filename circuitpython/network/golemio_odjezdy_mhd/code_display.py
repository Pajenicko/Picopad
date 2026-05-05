"""
Prague public transport departure board on PicoPad display.

Connects to Prague data platform Golemio.cz and displays departure times
at a public transport stop. Refreshes every 60 seconds.

1. Generate your API key at https://api.golemio.cz/api-keys/auth/sign-up
   Set it as GOLEMIO_API_KEY in settings.toml
2. Set WiFi credentials in settings.toml
3. Set STOP_NAME or STOP_GTFS_ID in settings.toml

Uses teletext.bdf font with Czech diacritics for proper display of stop names.
Uses GTS Root R4 certificate for HTTPS connection to Golemio API.
"""
import os
import board
import displayio
import time
import gc
import wifi
import ssl
import socketpool
import zlib
import json
import adafruit_requests
from adafruit_display_text import bitmap_label
from adafruit_bitmap_font import bitmap_font

display = board.DISPLAY
display.auto_refresh = False

font = bitmap_font.load_font("/teletext.bdf")

# Colors
WHITE = 0xFFFFFF
YELLOW = 0xFFFF00
CYAN = 0x00FFFF
GRAY = 0x888888

# Prague metro line colors
METRO_A = 0x55E490  # green
METRO_B = 0xE6E600  # yellow
METRO_C = 0xFF6655  # red

# Color for tram/bus/other lines
LINE_OTHER = 0x66E0E0  # teal

METRO_COLORS = {"A": METRO_A, "B": METRO_B, "C": METRO_C}

LINE_HEIGHT = 13
HEADER_Y = 4
TABLE_START_Y = 22


# Convert HTTP Date header (GMT) + ISO TZ offset to local HH:MM string.
# date_str format (RFC 7231): "Fri, 01 May 2026 16:32:28 GMT"
# tz_offset format: "+02:00"
def parse_http_date(date_str, tz_offset):
    parts = date_str.split(" ")
    if len(parts) < 5:
        return ""
    time_part = parts[4]
    h = int(time_part[:2])
    m = int(time_part[3:5])

    sign = 1 if tz_offset[:1] == "+" else -1
    oh = int(tz_offset[1:3])
    om = int(tz_offset[4:6])

    total = (h * 60 + m + sign * (oh * 60 + om)) % (24 * 60)
    return f"{total // 60:02d}:{total % 60:02d}"


# Read the TZ suffix (e.g. "+02:00") from the first departure's predicted timestamp.
def extract_tz_offset(departures):
    if departures:
        iso = departures[0]["departure_timestamp"]["predicted"]
        if iso[-6] in "+-":
            return iso[-6:]
    return "+02:00"


# Build the full departure board layout as a displayio.Group.
def build_display(stop_name, departures, infotexts, current_time):
    group = displayio.Group()

    # Header — stop name
    group.append(bitmap_label.Label(font, text=stop_name.upper(), color=YELLOW,
                                    x=4, y=HEADER_Y))

    # Current time (top-right, dimmed) — from HTTP Date header
    if current_time:
        group.append(bitmap_label.Label(font, text=current_time, color=GRAY,
                                        anchor_point=(1.0, 0.0),
                                        anchored_position=(316, HEADER_Y)))

    # Separator
    group.append(bitmap_label.Label(font, text="-" * 40, color=GRAY,
                                    x=0, y=HEADER_Y + LINE_HEIGHT))

    # Departure rows
    y = TABLE_START_Y + LINE_HEIGHT
    for dep in departures[:14]:
        gc.collect()
        line_num = dep["route"]["short_name"]
        headsign = dep["trip"]["headsign"]
        minutes = dep["departure_timestamp"]["minutes"]
        ac = "*" if dep["trip"]["is_air_conditioned"] else " "

        if len(headsign) > 22:
            headsign = headsign[:21] + "."

        line_color = METRO_COLORS.get(line_num, LINE_OTHER)

        # Line + AC indicator (* = air-conditioned), headsign, minutes (right)
        group.append(bitmap_label.Label(font, text=f"{line_num:>4}{ac}",
                                        color=line_color, x=4, y=y))
        group.append(bitmap_label.Label(font, text=headsign,
                                        color=WHITE, x=52, y=y))
        group.append(bitmap_label.Label(font, text=f"{minutes} min", color=WHITE,
                                        anchor_point=(1.0, 0.0),
                                        anchored_position=(316, y)))

        y += LINE_HEIGHT

    # Infotexts (if any)
    for inf in infotexts[:2]:
        if y + LINE_HEIGHT < 235:
            group.append(bitmap_label.Label(font, text=inf["text"][:39], color=CYAN,
                                            x=4, y=y))
            y += LINE_HEIGHT

    gc.collect()
    # Footer
    group.append(bitmap_label.Label(font, text="PID.cz | Golemio.cz", color=GRAY,
                                    x=4, y=230))

    return group


wifi.radio.connect(os.getenv("CIRCUITPY_WIFI_SSID"), os.getenv("CIRCUITPY_WIFI_PASSWORD"))
print(f"Connected: {wifi.radio.ipv4_address}")

pool = socketpool.SocketPool(wifi.radio)
ssl_context = ssl.create_default_context()
with open("/gtsr4.pem", "r") as f:
    ssl_context.load_verify_locations(cadata=f.read())
requests = adafruit_requests.Session(pool, ssl_context)

api_key = os.getenv("GOLEMIO_API_KEY")
if os.getenv("STOP_NAME"):
    query = f"names={os.getenv('STOP_NAME')}"
elif os.getenv("STOP_GTFS_ID"):
    query = f"ids={os.getenv('STOP_GTFS_ID')}"
else:
    query = "names=Muzeum"


# Call the Golemio API and return (json_data, local_time_hhmm).
def fetch_departures():
    url = f"https://api.golemio.cz/v2/pid/departureboards?{query}&preferredTimezone=Europe%2FPrague&total=14"
    headers = {"X-Access-Token": api_key, "Accept": "application/json"}

    response = requests.get(url, headers=headers)
    http_date = response.headers.get("date", "")

    if response.headers.get("content-encoding") == "gzip":
        data = json.loads(zlib.decompress(response.content, 31))
    else:
        data = json.loads(response.text)

    response.close()

    tz_offset = extract_tz_offset(data.get("departures", []))
    current_time = parse_http_date(http_date, tz_offset)
    return data, current_time


# Main loop
while True:
    gc.collect()
    data, current_time = fetch_departures()
    gc.collect()

    stop_name = data["stops"][0]["stop_name"]
    infotexts = data.get("infotexts", [])
    group = build_display(stop_name, data["departures"], infotexts, current_time)
    display.root_group = group
    display.refresh()
    print(f"Display updated ({current_time})")

    del data
    gc.collect()
    time.sleep(60)

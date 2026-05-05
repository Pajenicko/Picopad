"""
NTP Clock with animated sky for PicoPad

Syncs time via NTP and displays a clock with day/night sky animation.
Sun moves across the sky following real time. Stars appear at night
through a palette swap trick - star pixels in sky.bmp use palette index 1
which matches the sky color during day (invisible) and becomes bright at night.

Layers: sky.bmp (background) -> sun.bmp (sprite) -> fg.bmp (landscape) -> clock text

WiFi credentials must be set in settings.toml:
  CIRCUITPY_WIFI_SSID = "your_ssid"
  CIRCUITPY_WIFI_PASSWORD = "your_password"
"""

import board
import displayio
from adafruit_display_text import label
from adafruit_bitmap_font import bitmap_font
import adafruit_imageload
import time
import os
import wifi
import socketpool
import adafruit_ntp
import rtc

# Connect to WiFi
print("Connecting to WiFi...")
wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))
print(f"Connected: {wifi.radio.ipv4_address}")

# Sync time via NTP (UTC, offset computed locally)
pool = socketpool.SocketPool(wifi.radio)
ntp = adafruit_ntp.NTP(pool, tz_offset=0)
rtc.RTC().datetime = ntp.datetime
print("Time synced from NTP")

display = board.DISPLAY
group = displayio.Group()

# Layer 1: Sky background (320x106) with hidden stars - only visible part above foreground
bitmap_sky, palette_sky = adafruit_imageload.load("/bg.bmp",
                                          bitmap=displayio.Bitmap,
                                          palette=displayio.Palette)
group.append(displayio.TileGrid(bitmap_sky, pixel_shader=palette_sky))

# Layer 2: Sun sprite (48x48), palette index 1 = transparent
bitmap_sun, palette_sun = adafruit_imageload.load("/sun.bmp",
                                          bitmap=displayio.Bitmap,
                                          palette=displayio.Palette)
sun = displayio.TileGrid(bitmap_sun, pixel_shader=palette_sun)
palette_sun.make_transparent(1)
sun.x = -50
sun.y = -50
group.append(sun)

# Layer 3: Foreground landscape (320x158), palette index 7 = transparent
bitmap_fg, palette_fg = adafruit_imageload.load("/fg.bmp",
                                          bitmap=displayio.Bitmap,
                                          palette=displayio.Palette)
palette_fg.make_transparent(7)
fg = displayio.TileGrid(bitmap_fg, pixel_shader=palette_fg)
fg.y = 82
group.append(fg)

# Layer 4: Digital clock
font = bitmap_font.load_font("/Digital-Display-80.bdf")
text_area = label.Label(font, text="00:00", color=0xFFFFFF, scale=1)
text_area.x = 0
text_area.y = 170
group.append(text_area)

display.auto_refresh = False
display.root_group = group

# Save original palette colors for star/detail pixels (indices 2-8)
STAR_COLORS = [palette_sky[i] for i in range(2, 9)]

SUNRISE = 6
SUNSET = 20
MIDPOINT_X = 150

# Daytime sky/sun colors based on sun Y position (lower Y = higher sun)
# Each entry: (max_y, sky_color, sun_color)
# Morning palette (sun rising, x < MIDPOINT_X)
MORNING_BANDS = [
    (50,  0x46d3fc, 0xfbf236),  # high sun - bright blue
    (70,  0x6cb4d8, 0xfbf236),  # mid-high
    (85,  0x568099, 0xf5e060),  # mid-low
    (100, 0x3a7a9c, 0xf0e880),  # near horizon
    (999, 0x29638f, 0xfcffcf),  # at horizon - pale sun
]

# Evening palette (sun setting, x >= MIDPOINT_X)
EVENING_BANDS = [
    (50,  0x46d3fc, 0xfbf236),  # high sun - same as morning
    (70,  0x50c0e8, 0xf0d860),  # warm blue
    (85,  0x70a8c0, 0xe8a848),  # hazy blue
    (100, 0x8890a8, 0xe08840),  # muted lavender
    (999, 0x605878, 0xc07040),  # purple horizon
]

# Twilight colors when sun is off-screen (hours from sunrise/sunset)
MORNING_TWILIGHT = [
    (0.5, 0x2c4a73),  # pre-dawn glow
    (1.0, 0x1e3570),
    (2.0, 0x1a2a6c),
    (3.0, 0x141f5c),
    (4.0, 0x0e1550),
]

EVENING_TWILIGHT = [
    (0.5, 0x2b2050),  # post-sunset purple
    (1.0, 0x1a2050),
    (2.0, 0x141f5c),
    (3.0, 0x0e1550),
]

NIGHT_SKY = 0x0a1040


# EU DST base offset (CET = UTC+1)
TZ_BASE = 1


def day_of_week(y, m, d):
    """Tomohiko Sakamoto's algorithm. Returns 0=Sunday, 1=Monday, ..., 6=Saturday."""
    t = (0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4)
    if m < 3:
        y -= 1
    return (y + y // 4 - y // 100 + y // 400 + t[m - 1] + d) % 7


def last_sunday(year, month):
    """Day of last Sunday in given month (28-31)."""
    last_day = 31 if month != 2 else 28
    return last_day - day_of_week(year, month, last_day)


def is_cest(year, month, day, hour_utc):
    """Check if UTC time falls in EU summer time (CEST, UTC+2).
    Switches: last Sunday of March at 1:00 UTC -> last Sunday of October at 1:00 UTC."""
    if month < 3 or month > 10:
        return False
    if month > 3 and month < 10:
        return True
    switch_day = last_sunday(year, month)
    if month == 3:
        return day > switch_day or (day == switch_day and hour_utc >= 1)
    # October
    return day < switch_day or (day == switch_day and hour_utc < 1)


def utc_to_local(dt):
    """Convert UTC struct_time to local (CET/CEST) struct_time."""
    offset = TZ_BASE + (1 if is_cest(dt.tm_year, dt.tm_mon, dt.tm_mday, dt.tm_hour) else 0)
    return time.localtime(time.mktime(dt) + offset * 3600)


def set_sky_color(color):
    palette_sky[0] = color
    for i in range(1, 9):
        palette_sky[i] = color


def show_stars():
    palette_sky[1] = 0xFFFFEE
    for i, c in enumerate(STAR_COLORS):
        palette_sky[i + 2] = c


def update_sky(hour, minute):
    t = hour + minute / 60.0

    if SUNRISE <= t < SUNSET:
        # Sun is visible - compute position from parabola
        progress = (t - SUNRISE) / (SUNSET - SUNRISE)
        x = int(20 + progress * 260)
        y = int(0.005 * x * x - 1.5 * x + 140)
        sun.x = x - 24
        sun.y = y - 24

        # Pick colors from Y position and morning/evening
        bands = MORNING_BANDS if x < MIDPOINT_X else EVENING_BANDS
        sky_color = bands[-1][1]
        sun_color = bands[-1][2]
        for max_y, sc, suc in bands:
            if y <= max_y:
                sky_color = sc
                sun_color = suc
                break

        palette_sun[0] = sun_color
        set_sky_color(sky_color)
    else:
        # Sun off-screen
        sun.x = -50
        sun.y = -50

        # Twilight gradient based on hours from sunrise/sunset
        if t < SUNRISE:
            hours_away = SUNRISE - t
            twilight = MORNING_TWILIGHT
        else:
            hours_away = t - SUNSET
            twilight = EVENING_TWILIGHT

        sky_color = NIGHT_SKY
        for max_h, color in twilight:
            if hours_away <= max_h:
                sky_color = color
                break

        palette_sky[0] = sky_color
        show_stars()


# Main loop - real time from RTC
last_utc_minute = -1
last_sync_day = rtc.RTC().datetime.tm_mday
hour = 0
minute = 0

while True:
    utc = rtc.RTC().datetime

    # Update display only when UTC minute changes
    if utc.tm_min != last_utc_minute:
        last_utc_minute = utc.tm_min
        local = utc_to_local(utc)
        hour = local.tm_hour
        minute = local.tm_min
        text_area.text = "%02d:%02d" % (hour, minute)
        update_sky(hour, minute)
        display.refresh()

        # Re-sync NTP once per day (when UTC day changes)
        if utc.tm_mday != last_sync_day:
            try:
                rtc.RTC().datetime = ntp.datetime
                last_sync_day = rtc.RTC().datetime.tm_mday
            except Exception:
                pass

    time.sleep(1)

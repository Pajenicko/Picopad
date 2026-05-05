"""
Alarm Clock with NTP for PicoPad

Displays current time synced via NTP with alarm functionality.
Colon blinks every second. Alarm beeps and blinks when triggered.

Controls:
  A - enter alarm setting / confirm alarm / dismiss ringing alarm
  B - toggle alarm on/off / dismiss ringing alarm
  In alarm setting: Up/Down change value, Left/Right switch hour/minute

WiFi credentials must be set in settings.toml:
  CIRCUITPY_WIFI_SSID = "your_ssid"
  CIRCUITPY_WIFI_PASSWORD = "your_password"

Required libraries in /lib:
  adafruit_display_text, adafruit_bitmap_font, adafruit_ntp
"""

import board
import displayio
import terminalio
import keypad
from adafruit_display_text import label
from adafruit_bitmap_font import bitmap_font
import simpleio
import time
import os
import wifi
import socketpool
import adafruit_ntp
import rtc

# Connect to WiFi using credentials from settings.toml
print("Connecting to WiFi...")
wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))
print(f"Connected: {wifi.radio.ipv4_address}")

# Sync time via NTP - we store UTC in the RTC and convert to local time later
pool = socketpool.SocketPool(wifi.radio)
ntp = adafruit_ntp.NTP(pool, tz_offset=0)
rtc.RTC().datetime = ntp.datetime
print("Time synced from NTP")


# EU Daylight Saving Time detection
# In EU, clocks move forward on last Sunday of March at 1:00 UTC (CET -> CEST)
# and back on last Sunday of October at 1:00 UTC (CEST -> CET)
TZ_BASE = 1  # CET = UTC+1, CEST = UTC+2


def day_of_week(y, m, d):
    """Tomohiko Sakamoto's algorithm. Returns 0=Sunday, 1=Monday, ..., 6=Saturday."""
    t = (0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4)
    if m < 3:
        y -= 1
    return (y + y // 4 - y // 100 + y // 400 + t[m - 1] + d) % 7


def last_sunday(year, month):
    """Find the day number of the last Sunday in a given month."""
    return 31 - day_of_week(year, month, 31)


def is_cest(year, month, day, hour_utc):
    """Check if a given UTC date/time falls in EU summer time (CEST)."""
    if month < 3 or month > 10:
        return False
    if 3 < month < 10:
        return True
    switch_day = last_sunday(year, month)
    if month == 3:
        return day > switch_day or (day == switch_day and hour_utc >= 1)
    return day < switch_day or (day == switch_day and hour_utc < 1)


def utc_to_local(dt):
    """Convert UTC struct_time to local CET/CEST struct_time."""
    offset = TZ_BASE + (1 if is_cest(dt.tm_year, dt.tm_mon, dt.tm_mday, dt.tm_hour) else 0)
    return time.localtime(time.mktime(dt) + offset * 3600)


# Setup buttons using the keypad module
# keypad.Keys scans buttons in the background and queues press/release events,
# so we never miss a button press even with longer sleep intervals
KEY_A = 0
KEY_B = 1
KEY_UP = 2
KEY_DOWN = 3
KEY_LEFT = 4
KEY_RIGHT = 5

keys = keypad.Keys(
    (board.SW_A, board.SW_B, board.SW_UP, board.SW_DOWN, board.SW_LEFT, board.SW_RIGHT),
    value_when_pressed=False,
    pull=True,
)

# Initialize the display
display = board.DISPLAY
display.auto_refresh = False
group = displayio.Group()

# Top label - shows date in normal mode, "SET ALARM" in alarm setting mode
top_label = label.Label(terminalio.FONT, text="", color=0xFFFFFF, scale=2)
top_label.anchor_point = (0.5, 0)
top_label.anchored_position = (160, 5)
group.append(top_label)

# Main time display - split into 3 labels so we can blink the colon independently
# Font advance is 64px per character: "HH" (128) + ":" (64) + "MM" (128) = 320px
big_font = bitmap_font.load_font("/Digital-Display-80.bdf")
TIME_Y = 110

hours_label = label.Label(big_font, text="00", color=0xFFFFFF)
hours_label.x = 0
hours_label.y = TIME_Y
group.append(hours_label)

colon_label = label.Label(big_font, text=":", color=0xFFFFFF)
colon_label.x = 128
colon_label.y = TIME_Y
group.append(colon_label)

minutes_label = label.Label(big_font, text="00", color=0xFFFFFF)
minutes_label.x = 192
minutes_label.y = TIME_Y
group.append(minutes_label)

# Alarm info label below the time
alarm_label = label.Label(terminalio.FONT, text="", color=0xFFFFFF, scale=2)
alarm_label.anchor_point = (0.5, 0)
alarm_label.anchored_position = (160, 180)
group.append(alarm_label)

display.root_group = group

# Application states
NORMAL = 0
ALARM_SET = 1
RINGING = 2

state = NORMAL
alarm_hour = 7
alarm_minute = 0
alarm_enabled = False
alarm_field = 0  # 0 = editing hour, 1 = editing minute
alarm_dismissed = False  # prevents re-triggering alarm in the same minute

hour = 0
minute = 0
date_str = ""
last_utc_minute = -1
last_sync_day = rtc.RTC().datetime.tm_mday
colon_on = True

# Main loop
while True:
    # Drain the event queue and collect which keys were pressed this iteration
    pressed = []
    event = keys.events.get()
    while event:
        if event.pressed:
            pressed.append(event.key_number)
        event = keys.events.get()

    # Read UTC from RTC and convert to local time (only recompute on minute change)
    utc = rtc.RTC().datetime
    if utc.tm_min != last_utc_minute:
        last_utc_minute = utc.tm_min
        local = utc_to_local(utc)
        hour = local.tm_hour
        minute = local.tm_min
        date_str = "%d.%d.%d" % (local.tm_mday, local.tm_mon, local.tm_year)
        alarm_dismissed = False

        # Re-sync NTP once per day (when UTC day changes, around midnight)
        if utc.tm_mday != last_sync_day:
            try:
                rtc.RTC().datetime = ntp.datetime
                last_sync_day = rtc.RTC().datetime.tm_mday
            except Exception:
                pass

    if state == NORMAL:
        # Show date at top, current time, and alarm info if enabled
        top_label.text = date_str
        hours_label.text = "%02d" % hour
        minutes_label.text = "%02d" % minute
        hours_label.color = 0xFFFFFF
        minutes_label.color = 0xFFFFFF
        colon_label.color = 0xFFFFFF if colon_on else 0x000000

        if alarm_enabled:
            alarm_label.text = "ALARM %02d:%02d" % (alarm_hour, alarm_minute)
            alarm_label.color = 0xFFFFFF
        else:
            alarm_label.text = ""

        # Trigger alarm when time matches
        if alarm_enabled and not alarm_dismissed and hour == alarm_hour and minute == alarm_minute:
            state = RINGING

        # A = enter alarm setting
        if KEY_A in pressed:
            state = ALARM_SET
            alarm_field = 0

        # B = toggle alarm on/off
        if KEY_B in pressed:
            alarm_enabled = not alarm_enabled

    elif state == ALARM_SET:
        # Show alarm time in big display, active field highlighted in yellow
        top_label.text = "SET ALARM"
        hours_label.text = "%02d" % alarm_hour
        minutes_label.text = "%02d" % alarm_minute
        colon_label.color = 0xFFFFFF
        hours_label.color = 0xFFFF00 if alarm_field == 0 else 0xFFFFFF
        minutes_label.color = 0xFFFF00 if alarm_field == 1 else 0xFFFFFF
        alarm_label.text = ""

        # Left/Right = switch between hour and minute
        if KEY_LEFT in pressed:
            alarm_field = 0
        if KEY_RIGHT in pressed:
            alarm_field = 1

        # Up/Down = change value
        if KEY_UP in pressed:
            if alarm_field == 0:
                alarm_hour = (alarm_hour + 1) % 24
            else:
                alarm_minute = (alarm_minute + 1) % 60
        if KEY_DOWN in pressed:
            if alarm_field == 0:
                alarm_hour = (alarm_hour - 1) % 24
            else:
                alarm_minute = (alarm_minute - 1) % 60

        # A = confirm and activate alarm
        if KEY_A in pressed:
            alarm_enabled = True
            state = NORMAL

    elif state == RINGING:
        # Blink time white/yellow, "ALARM!" label blinks in opposite phase
        top_label.text = ""
        hours_label.text = "%02d" % hour
        minutes_label.text = "%02d" % minute
        blink = 0xFFFF00 if colon_on else 0xFFFFFF
        hours_label.color = blink
        minutes_label.color = blink
        colon_label.color = blink
        alarm_label.text = "ALARM!"
        alarm_label.color = 0xFFFFFF if colon_on else 0xFFFF00

        # Beep
        simpleio.tone(board.AUDIO, 1000, 0.1)

        # A or B = dismiss alarm
        if KEY_A in pressed or KEY_B in pressed:
            alarm_dismissed = True
            state = NORMAL

    display.refresh()

    # In alarm setting mode, use short sleep for responsive controls
    # In other modes, use 0.5s sleep for colon blinking rhythm
    if state == ALARM_SET:
        time.sleep(0.05)
    else:
        colon_on = not colon_on
        time.sleep(0.5)

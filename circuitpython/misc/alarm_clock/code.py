"""
Alarm Clock (manual) for PicoPad

Displays current time with alarm functionality. No WiFi required.
Time is set manually at startup and whenever arrows are pressed.

Controls:
  Arrows in normal mode - enter clock setting
  A - confirm clock/alarm setting / enter alarm setting / dismiss ringing alarm
  B - toggle alarm on/off / dismiss ringing alarm
  In setting mode: Up/Down change value, Left/Right switch hour/minute

Required libraries in /lib:
  adafruit_display_text, adafruit_bitmap_font
"""

import board
import displayio
import terminalio
import keypad
from adafruit_display_text import label
from adafruit_bitmap_font import bitmap_font
import simpleio
import time
import rtc

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

# Top label - shows current mode (SET CLOCK / SET ALARM)
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
CLOCK_SET = 0
NORMAL = 1
ALARM_SET = 2
RINGING = 3

COLOR_ACTIVE_CLOCK = 0x88CCFF  # light blue for clock setting
COLOR_ACTIVE_ALARM = 0xFFFF00  # yellow for alarm setting

# Start in clock setting mode so the user sets the time first
state = CLOCK_SET
set_hour = 12
set_minute = 0
clock_field = 0  # 0 = editing hour, 1 = editing minute

alarm_hour = 7
alarm_minute = 0
alarm_enabled = False
alarm_field = 0  # 0 = editing hour, 1 = editing minute
alarm_dismissed = False  # prevents re-triggering alarm in the same minute

hour = 0
minute = 0
last_minute = -1
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

    # Read time from RTC (only update on minute change)
    dt = rtc.RTC().datetime
    if dt.tm_min != last_minute:
        last_minute = dt.tm_min
        hour = dt.tm_hour
        minute = dt.tm_min
        alarm_dismissed = False

    if state == CLOCK_SET:
        # Show clock time being set, active field highlighted in light blue
        top_label.text = "SET CLOCK"
        hours_label.text = "%02d" % set_hour
        minutes_label.text = "%02d" % set_minute
        colon_label.color = 0xFFFFFF
        hours_label.color = COLOR_ACTIVE_CLOCK if clock_field == 0 else 0xFFFFFF
        minutes_label.color = COLOR_ACTIVE_CLOCK if clock_field == 1 else 0xFFFFFF
        alarm_label.text = ""

        # Left/Right = switch between hour and minute
        if KEY_LEFT in pressed:
            clock_field = 0
        if KEY_RIGHT in pressed:
            clock_field = 1

        # Up/Down = change value
        if KEY_UP in pressed:
            if clock_field == 0:
                set_hour = (set_hour + 1) % 24
            else:
                set_minute = (set_minute + 1) % 60
        if KEY_DOWN in pressed:
            if clock_field == 0:
                set_hour = (set_hour - 1) % 24
            else:
                set_minute = (set_minute - 1) % 60

        # A = confirm and set the RTC
        if KEY_A in pressed:
            rtc.RTC().datetime = time.struct_time((2026, 1, 1, set_hour, set_minute, 0, 3, 1, -1))
            hour = set_hour
            minute = set_minute
            last_minute = set_minute
            state = NORMAL

    elif state == NORMAL:
        # Show current time, colon blinks
        top_label.text = ""
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

        # Any arrow key = enter clock setting (pre-fill with current time)
        if KEY_UP in pressed or KEY_DOWN in pressed or KEY_LEFT in pressed or KEY_RIGHT in pressed:
            set_hour = hour
            set_minute = minute
            clock_field = 0
            state = CLOCK_SET

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
        hours_label.color = COLOR_ACTIVE_ALARM if alarm_field == 0 else 0xFFFFFF
        minutes_label.color = COLOR_ACTIVE_ALARM if alarm_field == 1 else 0xFFFFFF
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

    # In setting modes, use short sleep for responsive controls
    # In other modes, use 0.5s sleep for colon blinking rhythm
    if state in (CLOCK_SET, ALARM_SET):
        time.sleep(0.05)
    else:
        colon_on = not colon_on
        time.sleep(0.5)

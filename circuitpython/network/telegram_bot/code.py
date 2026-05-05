"""
In this example, you will connect your Picopad to the internet and send messages to your Telegram bot.

You need telegram bot token to use this example. You can get it from @BotFather (https://t.me/BotFather).

Use command /newbot and follow the instructions. At the end you will get the token.

Then you need to set the token as TELEGRAM_BOT_TOKEN environment variable in your settings.toml file.

The only external library we need is adafruit_requests.

You can find the required librarie in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""
import board
import time
import digitalio
import os
import wifi
import socketpool
import ssl
import adafruit_requests
import microcontroller
import gc



# Send a message via Telegram Bot API
# chat_id - the ID of the chat or user we want to send the message to
# we get the chat_id from the update (command) we receive from the API
def send_telegram_message(chat_id, message):
    base_url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
    payload = {
        "chat_id": chat_id,
        "text": message
    }
    response = requests.post(base_url, data=payload)
    return response.json()

# Get updates from Telegram Bot API
# We call the API with 2 parameters:
# - offset - the ID of the first message we want to receive (we set it last received message ID + 1)
# - timeout - how long to wait for new updates - this technique is called long polling:
#             The connection will be open for defined amount of time, waiting for new messages.
#             If there are no new messages, the API will return an empty response and we will need to call it again.
#             In case of new messages, the API will return them immediately.
#             This way we don't need to call the API in a loop and overloading the API, but still get instant responses.
#
# https://core.telegram.org/bots/api#getupdates

def get_telegram_updates(offset=None):
    base_url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/getUpdates?timeout=120&offset={offset}"
    response = requests.get(base_url)
    return response.json()

# Return "visual" status of the LED
def get_led_status():
    if not led.value:
        return "🟡"
    else:
        return "⚫"
    
# initialize LED
led = digitalio.DigitalInOut(board.LED)
# default pin mode is input, so we need to change it to output
led.direction = digitalio.Direction.OUTPUT

# Connect to WiFi
print("Connecting to WiFi")
wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))
print(f"Connected to WiFi {os.getenv('CIRCUITPY_WIFI_SSID')}")
pool = socketpool.SocketPool(wifi.radio)
requests = adafruit_requests.Session(pool, ssl.create_default_context())

TELEGRAM_BOT_TOKEN = os.getenv('TELEGRAM_BOT_TOKEN')
last_update_id = None

# Main loop to check for /temp command
while True:

    updates = get_telegram_updates(offset=last_update_id)
    gc.collect()

    for update in updates.get("result", []):

        last_update_id = update.get("update_id") + 1  # Update the offset for the next poll
        message = update.get("message", {}).get("text", "")
        chat_id = update.get("message", {}).get("chat", {}).get("id", "")
        print(message)
        
        if message == "/start":
            temperature = microcontroller.cpu.temperature
            send_telegram_message(chat_id, f"Hello! I'm Mr. Picopad and I'm alive!!! Your chat/user ID is: {chat_id}")

        if message == "/temp":
            temperature = microcontroller.cpu.temperature
            send_telegram_message(chat_id, f"Current temperature: {temperature:.2f}°C")

        if message == "/led":
            led_status = get_led_status()
            send_telegram_message(chat_id, f"LED is now {led_status}")

        if message == "/toggle":
            led.value = not led.value
            led_status = get_led_status()
            send_telegram_message(chat_id, f"LED toggled and is {led_status}")            
        
        if message == "/memory":
            free_mem = gc.mem_free()
            send_telegram_message(chat_id, f"Free memory: {free_mem}")            
    
    # wait 2 seconds before checking for new updates - to avoid overloading the API
    time.sleep(2)

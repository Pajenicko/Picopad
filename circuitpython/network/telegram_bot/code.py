import os
import wifi
import socketpool
import ssl
import adafruit_requests
import microcontroller
import gc
import time
import board
import digitalio


# Function to send a message via Telegram Bot API
def send_telegram_message(chat_id, message):
    base_url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
    payload = {
        "chat_id": chat_id,
        "text": message
    }
    response = requests.post(base_url, data=payload)
    return response.json()

# Function to get updates from Telegram Bot API
def get_telegram_updates(offset=None):
    base_url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/getUpdates?timeout=100&offset={offset}"
    response = requests.get(base_url)
    return response.json()


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
print("Connected to WiFi %s" % (os.getenv('CIRCUITPY_WIFI_SSID')))
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

    time.sleep(2)

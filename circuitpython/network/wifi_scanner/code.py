"""
WiFi Scanner for PicoPad

This example demonstrates how to scan for WiFi networks and visualize them
on the PicoPad display. It shows networks as parabolas positioned by channel
and signal strength.

Features:
- Scan for WiFi networks
- Display networks as colored parabolas on channel graph
- Navigate networks with arrow keys  
- View detailed network lists sorted by signal strength or alphabetically
- Rescan with B button

You can find the required libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""

import board
import wifi
import displayio
import terminalio
from adafruit_display_text import label
from digitalio import DigitalInOut, Pull
from adafruit_debouncer import Debouncer
import time
import math
import gc

# Display setup
display = board.DISPLAY
group = displayio.Group()
display.root_group = group

# Button setup
def setup_button(pin):
    button_pin = DigitalInOut(pin)
    button_pin.pull = Pull.UP
    return Debouncer(button_pin)

btn_up = setup_button(board.SW_UP)
btn_down = setup_button(board.SW_DOWN)
btn_left = setup_button(board.SW_LEFT)
btn_right = setup_button(board.SW_RIGHT)
btn_a = setup_button(board.SW_A)
btn_b = setup_button(board.SW_B)

# Colors for networks with gradient levels for smooth antialiasing
COLORS_BASE = [
    0xFF0000,  # Red
    0x00FF00,  # Green
    0x0000FF,  # Blue
    0xFFFF00,  # Yellow
    0xFF00FF,  # Magenta
    0x00FFFF,  # Cyan
    0xFFaa00,  # Orange
    0xaa00FF,  # Purple
]

# Generate 4 intensity levels for each color (100%, 75%, 50%, 25%)
COLORS = []
for base_color in COLORS_BASE:
    r = (base_color >> 16) & 0xFF
    g = (base_color >> 8) & 0xFF
    b = base_color & 0xFF
    
    # 4 intensity levels
    COLORS.append(base_color)  # 100%
    COLORS.append(((r * 3 // 4) << 16) | ((g * 3 // 4) << 8) | (b * 3 // 4))  # 75%
    COLORS.append(((r >> 1) << 16) | ((g >> 1) << 8) | (b >> 1))  # 50%
    COLORS.append(((r >> 2) << 16) | ((g >> 2) << 8) | (b >> 2))  # 25%

# WiFi networks storage
networks = []
selected_network = 0
current_view = 0  # 0=graph, 1=signal sorted, 2=alphabetical

# Channel positions (WiFi channels 1-11, gap, 13) - shifted right to avoid edge
CHANNEL_POSITIONS = {
    1: 35, 2: 55, 3: 75, 4: 95, 5: 115, 6: 135, 7: 155, 8: 175, 9: 195, 10: 215, 11: 235, 12: 255, 13: 275
}

class WiFiNetwork:
    def __init__(self, ssid, channel, rssi, bssid, authmode=None):
        self.ssid = ssid if ssid else "[Hidden]"
        self.channel = channel
        self.rssi = rssi
        self.bssid = bssid
        self.authmode = authmode
        self.color_index = 0
    
    def get_color(self):
        return COLORS[self.color_index % len(COLORS)]

def scan_networks():
    """Scan for WiFi networks and return list of WiFiNetwork objects"""
    print("Scanning for networks...")
    networks_found = []
    seen_bssids = {}  # Track duplicates by BSSID
    
    try:
        # Start scanning
        scan_results = []
        for network in wifi.radio.start_scanning_networks():
            scan_results.append(network)
        
        # Stop scanning before processing
        wifi.radio.stop_scanning_networks()
        print(f"Scan completed, found {len(scan_results)} raw results")
        
        # Process results and filter duplicates
        for network in scan_results:
            bssid_str = ":".join([f"{b:02x}" for b in network.bssid])
            
            # Check if we've seen this BSSID before
            if bssid_str in seen_bssids:
                # Update with stronger signal if found
                if network.rssi > seen_bssids[bssid_str].rssi:
                    print(f"Updating {network.ssid} with stronger signal: {network.rssi}dBm")
                    seen_bssids[bssid_str].rssi = network.rssi
                continue
            
            # Get all available attributes for first occurrence
            print("\n--- Network Details ---")
            print(f"SSID: {network.ssid}")
            print(f"Channel: {network.channel}")
            print(f"RSSI: {network.rssi}dBm")
            print(f"BSSID: {bssid_str}")
            
            # Try to get additional attributes
            for attr in ['authmode', 'country']:
                try:
                    value = getattr(network, attr, 'N/A')
                    print(f"{attr}: {value}")
                except:
                    print(f"{attr}: N/A")
            print("--- End Details ---\n")
            
            authmode = getattr(network, 'authmode', None)
            wifi_net = WiFiNetwork(
                ssid=network.ssid,
                channel=network.channel,
                rssi=network.rssi,
                bssid=bssid_str,
                authmode=authmode
            )
            wifi_net.color_index = len(networks_found)
            networks_found.append(wifi_net)
            seen_bssids[bssid_str] = wifi_net
            
    except Exception as e:
        print(f"Scan error: {e}")
        # Add some dummy networks for testing
        test_networks = [
            ("TestNet1", 1, -45),
            ("TestNet2", 6, -60),
            ("TestNet3", 11, -75),
        ]
        for i, (ssid, channel, rssi) in enumerate(test_networks):
            wifi_net = WiFiNetwork(ssid, channel, rssi, "00:00:00:00:00:00")
            wifi_net.color_index = i
            networks_found.append(wifi_net)
            print(f"Added test network: {ssid}")
    
    # Sort by signal strength (strongest first)
    networks_found.sort(key=lambda x: x.rssi, reverse=True)
    print(f"Final unique networks: {len(networks_found)}")
    return networks_found

def draw_parabola_outline(x_center, signal_strength, color, bitmap, base_palette_idx, min_rssi, max_rssi, graph_height, fill=True):
    """Draw a parabola outline with antialiasing and optional fill"""
    signal_range = max_rssi - min_rssi
    if signal_range == 0:
        normalized_height = 0.5
    else:
        normalized_height = (signal_strength - min_rssi) / signal_range

    height = max(8, int(normalized_height * graph_height))
    base_y = 210
    width = 20
    fill_idx = base_palette_idx + 3  # 25% intensity for fill

    for x_offset in range(-width, width + 1):
        x = x_center + x_offset
        if 0 <= x < 320:
            normalized_offset = x_offset / width
            parabola_height = height * (1 - normalized_offset * normalized_offset)
            precise_y = base_y - parabola_height
            y_int = int(precise_y)
            y_frac = precise_y - y_int

            try:
                # Fill below curve (even if top is clipped)
                if fill:
                    fill_start = max(50, y_int + 2)
                    for fy in range(fill_start, base_y + 1):
                        if bitmap[x, fy] == 0:
                            bitmap[x, fy] = fill_idx

                # Antialiased outline (only in visible area)
                if 50 <= y_int <= 210:
                    if y_frac < 0.25:
                        bitmap[x, y_int] = base_palette_idx
                    elif y_frac < 0.5:
                        bitmap[x, y_int] = base_palette_idx + 1
                    elif y_frac < 0.75:
                        bitmap[x, y_int] = base_palette_idx + 2
                    else:
                        bitmap[x, y_int] = base_palette_idx + 3

                    if y_frac > 0.25 and y_int + 1 <= 210:
                        if y_frac > 0.75:
                            bitmap[x, y_int + 1] = base_palette_idx
                        elif y_frac > 0.5:
                            bitmap[x, y_int + 1] = base_palette_idx + 1
                        else:
                            bitmap[x, y_int + 1] = base_palette_idx + 2

                    if y_frac > 0.75 and y_int + 2 <= 210:
                        bitmap[x, y_int + 2] = base_palette_idx + 3
            except:
                pass

def draw_parabola_simple_white(x_center, signal_strength, bitmap, palette_idx, min_rssi, max_rssi, graph_height, fill_idx=0):
    """Draw a simple white parabola outline for selected network"""
    signal_range = max_rssi - min_rssi
    if signal_range == 0:
        normalized_height = 0.5
    else:
        normalized_height = (signal_strength - min_rssi) / signal_range

    height = max(8, int(normalized_height * graph_height))
    base_y = 210
    width = 20

    for x_offset in range(-width, width + 1, 2):
        x = x_center + x_offset
        if 0 <= x < 320:
            normalized_offset = x_offset / width
            parabola_height = height * (1 - normalized_offset * normalized_offset)
            y = int(base_y - parabola_height)

            try:
                # Fill below curve (even if top is clipped)
                if fill_idx:
                    fill_start = max(50, y + 2)
                    for fy in range(fill_start, base_y + 1):
                        if bitmap[x, fy] == 0:
                            bitmap[x, fy] = fill_idx
                        if x + 1 < 320 and bitmap[x + 1, fy] == 0:
                            bitmap[x + 1, fy] = fill_idx

                # Outline with thickness (only in visible area)
                if 50 <= y <= 210:
                    bitmap[x, y] = palette_idx
                    if x + 1 < 320:
                        bitmap[x + 1, y] = palette_idx
                    if y + 1 <= 210:
                        bitmap[x, y + 1] = palette_idx
                        if x + 1 < 320:
                            bitmap[x + 1, y + 1] = palette_idx
            except:
                pass

def draw_graph_view():
    """Draw the main channel graph view"""
    # Clear display
    while len(group) > 0:
        group.pop()
    
    # Calculate signal range for dynamic scaling
    if networks:
        min_rssi = min(net.rssi for net in networks)
        max_rssi = max(net.rssi for net in networks)
        # Round: min down (away from 0), max up (toward 0)
        min_rssi = ((min_rssi - 10) // 10) * 10
        max_rssi = -(-max_rssi // 10) * 10
        if max_rssi <= max(net.rssi for net in networks):
            max_rssi += 10
        # Ensure minimum range of 30dBm for readability
        if max_rssi - min_rssi < 30:
            mid = (max_rssi + min_rssi) // 2
            min_rssi = mid - 20
            max_rssi = mid + 10
    else:
        min_rssi, max_rssi = -100, -30
    
    graph_height = 160  # Height available for graph (from y=50 to y=210)
    
    # Create a single bitmap with all color gradients
    total_colors = len(COLORS) + 4  # All gradient colors + black + white + grid + dim white
    bitmap = displayio.Bitmap(320, 240, total_colors)
    palette = displayio.Palette(total_colors)
    palette[0] = 0x000000  # Black background
    palette[1] = 0xFFFFFF  # White for selected
    grid_idx = len(COLORS) + 2
    palette[grid_idx] = 0x333333  # Dark gray for grid lines
    dim_white_idx = len(COLORS) + 3
    palette[dim_white_idx] = 0x888888  # Dim white for selected fill

    # Add all gradient colors to palette
    for i, color in enumerate(COLORS):
        palette[i + 2] = color

    # Create tile grid for the bitmap
    tile_grid = displayio.TileGrid(bitmap, pixel_shader=palette, x=0, y=0)
    group.append(tile_grid)

    # Draw horizontal grid lines and Y-axis labels
    signal_range = max_rssi - min_rssi
    for i in range(0, signal_range + 1, 10):
        rssi_value = max_rssi - i
        if rssi_value >= min_rssi:
            y_pos = 50 + int((i / signal_range) * graph_height)
            if y_pos <= 210:
                # Dotted horizontal grid line
                for gx in range(30, 280, 3):
                    try:
                        bitmap[gx, y_pos] = grid_idx
                    except:
                        pass
                rssi_label = label.Label(terminalio.FONT, text=f"{rssi_value}", color=0x666666, x=285, y=y_pos)
                group.append(rssi_label)

    # Draw baseline
    for gx in range(30, 280):
        try:
            bitmap[gx, 210] = grid_idx
        except:
            pass
    
    # Draw non-selected networks first
    for i, network in enumerate(networks):
        if i != selected_network and network.channel in CHANNEL_POSITIONS:
            x_pos = CHANNEL_POSITIONS[network.channel]
            base_color_set = (network.color_index % len(COLORS_BASE)) * 4
            base_palette_idx = base_color_set + 2
            draw_parabola_outline(x_pos, network.rssi, None, bitmap, base_palette_idx, min_rssi, max_rssi, graph_height)

    # Draw selected network on top
    if networks and 0 <= selected_network < len(networks):
        network = networks[selected_network]
        if network.channel in CHANNEL_POSITIONS:
            x_pos = CHANNEL_POSITIONS[network.channel]
            draw_parabola_simple_white(x_pos, network.rssi, bitmap, 1, min_rssi, max_rssi, graph_height, dim_white_idx)
    
    # Title and selected network info
    title_label = label.Label(terminalio.FONT, text="WiFi Scanner", color=0xFFFFFF, x=10, y=10)
    group.append(title_label)

    net_count = label.Label(terminalio.FONT, text=f"{len(networks)} networks", color=0x666666, x=10, y=22)
    group.append(net_count)

    if networks and 0 <= selected_network < len(networks):
        net = networks[selected_network]
        detail_text = f"{net.ssid} Ch:{net.channel} {net.rssi}dBm"
        detail_label = label.Label(terminalio.FONT, text=detail_text, color=0xFFFFFF, x=10, y=34)
        group.append(detail_label)
    
    # Channel labels
    for channel, x_pos in CHANNEL_POSITIONS.items():
        ch_label = label.Label(terminalio.FONT, text=str(channel), color=0xFFFFFF, x=x_pos-5, y=215)
        group.append(ch_label)
    
    # Instructions
    inst_label = label.Label(terminalio.FONT, text="Arrows:Select A:Lists B:Scan", color=0xAAAAAA, x=10, y=230)
    group.append(inst_label)
    
    # Force garbage collection
    gc.collect()

def draw_list_view(sort_by_signal=True):
    """Draw list view sorted by signal strength or alphabetically"""
    # Clear display
    while len(group) > 0:
        group.pop()
    
    # Title
    title_text = "Signal Strength" if sort_by_signal else "Alphabetical"
    title_label = label.Label(terminalio.FONT, text=title_text, color=0xFFFFFF, x=10, y=15)
    group.append(title_label)
    
    # Sort networks
    sorted_networks = networks.copy()
    if sort_by_signal:
        sorted_networks.sort(key=lambda x: x.rssi, reverse=True)
    else:
        sorted_networks.sort(key=lambda x: x.ssid.lower())
    
    # Display networks in two-line format (SSID+info, BSSID)
    y_pos = 30
    for i in range(len(sorted_networks)):
        network = sorted_networks[i]
        if y_pos > 210:
            break

        # First line: SSID, channel, signal
        ssid_short = network.ssid[:15] if len(network.ssid) > 15 else network.ssid
        net_text = f"{ssid_short} Ch{network.channel:2d} {network.rssi:3d}dBm"
        text_color = 0xFFFFFF

        net_label = label.Label(terminalio.FONT, text=net_text, color=text_color, x=10, y=y_pos)
        group.append(net_label)

        # Second line: BSSID
        if y_pos + 12 <= 210:
            bssid_text = f"  {network.bssid[:17]}"
            bssid_label = label.Label(terminalio.FONT, text=bssid_text, color=0x888888, x=10, y=y_pos + 12)
            group.append(bssid_label)

        y_pos += 25
    
    # Instructions
    inst_label = label.Label(terminalio.FONT, text="A:Next View B:Scan", color=0xAAAAAA, x=10, y=230)
    group.append(inst_label)

def update_display():
    """Update display based on current view"""
    if current_view == 0:
        draw_graph_view()
    elif current_view == 1:
        draw_list_view(sort_by_signal=True)
    else:
        draw_list_view(sort_by_signal=False)

def update_selection_only(prev_selected):
    """Fast update: clear only affected parabola areas, redraw all"""
    if current_view != 0 or not networks:
        return

    bitmap = None
    for item in group:
        if hasattr(item, 'bitmap'):
            bitmap = item.bitmap
            break

    if bitmap is None:
        update_display()
        return

    min_rssi = min(net.rssi for net in networks)
    max_rssi = max(net.rssi for net in networks)
    min_rssi = ((min_rssi - 10) // 10) * 10
    max_rssi = -(-max_rssi // 10) * 10
    if max_rssi <= max(net.rssi for net in networks):
        max_rssi += 10
    if max_rssi - min_rssi < 30:
        mid = (max_rssi + min_rssi) // 2
        min_rssi = mid - 20
        max_rssi = mid + 10
    signal_range = max_rssi - min_rssi
    graph_height = 160
    grid_idx = len(COLORS) + 2
    dim_white_idx = len(COLORS) + 3

    # Clear only the two affected parabola areas (old + new selection)
    clear_centers = set()
    for idx in (prev_selected, selected_network):
        if 0 <= idx < len(networks) and networks[idx].channel in CHANNEL_POSITIONS:
            clear_centers.add(CHANNEL_POSITIONS[networks[idx].channel])

    for cx in clear_centers:
        for x in range(max(0, cx - 21), min(320, cx + 22)):
            for y in range(50, 211):
                bitmap[x, y] = 0
        # Restore grid lines in cleared area
        for i in range(0, signal_range + 1, 10):
            y_pos = 50 + int((i / signal_range) * graph_height)
            if y_pos <= 210:
                for gx in range(max(30, cx - 21), min(280, cx + 22), 3):
                    bitmap[gx, y_pos] = grid_idx
        for gx in range(max(30, cx - 21), min(280, cx + 22)):
            bitmap[gx, 210] = grid_idx

    # Redraw non-selected that overlap cleared areas
    for i, network in enumerate(networks):
        if i != selected_network and network.channel in CHANNEL_POSITIONS:
            x_pos = CHANNEL_POSITIONS[network.channel]
            for cx in clear_centers:
                if abs(x_pos - cx) < 42:  # parabolas could overlap
                    base_color_set = (network.color_index % len(COLORS_BASE)) * 4
                    draw_parabola_outline(x_pos, network.rssi, None, bitmap, base_color_set + 2, min_rssi, max_rssi, graph_height)
                    break

    # Draw selected on top
    network = networks[selected_network]
    if network.channel in CHANNEL_POSITIONS:
        x_pos = CHANNEL_POSITIONS[network.channel]
        draw_parabola_simple_white(x_pos, network.rssi, bitmap, 1, min_rssi, max_rssi, graph_height, dim_white_idx)

    # Update detail text
    for i in range(len(group) - 1, -1, -1):
        item = group[i]
        if hasattr(item, 'text') and 'Ch:' in item.text:
            group.pop(i)

    net = networks[selected_network]
    detail_label = label.Label(terminalio.FONT, text=f"{net.ssid} Ch:{net.channel} {net.rssi}dBm", color=0xFFFFFF, x=10, y=34)
    group.append(detail_label)

def navigate_networks(direction):
    """Navigate through networks in graph view, returns previous selection"""
    global selected_network

    if not networks:
        return selected_network

    prev = selected_network
    if direction == "up" or direction == "right":
        selected_network = (selected_network + 1) % len(networks)
    elif direction == "down" or direction == "left":
        selected_network = (selected_network - 1) % len(networks)

    print(f"Selected network {selected_network}: {networks[selected_network].ssid}")
    return prev

# Initial scan and display
print("Starting WiFi Scanner...")
networks = scan_networks()
print(f"Found {len(networks)} networks")

selected_network = 0
update_display()

# Main loop
while True:
    # Update buttons
    btn_up.update()
    btn_down.update()
    btn_left.update()
    btn_right.update()
    btn_a.update()
    btn_b.update()
    
    # Handle button presses
    if btn_b.fell:  # B button - rescan
        print("Rescanning...")
        networks = scan_networks()
        selected_network = 0
        current_view = 0
        update_display()
        gc.collect()
    
    elif btn_a.fell:  # A button - cycle views
        current_view = (current_view + 1) % 3
        update_display()
    
    elif current_view == 0:  # Graph view navigation
        if btn_up.fell or btn_right.fell:
            prev = navigate_networks("up")
            update_selection_only(prev)
        elif btn_down.fell or btn_left.fell:
            prev = navigate_networks("down")
            update_selection_only(prev)
    
    time.sleep(0.1)
#!/bin/sh

# Check if picotool is installed
if ! command -v picotool >/dev/null 2>&1; then
  echo "picotool is not installed."
  echo "You can get it here: https://github.com/raspberrypi/picotool"
  exit 1
fi

# Find the first UF2 file in the build directory
UF2_FILE=$(ls build/*.UF2 2>/dev/null | head -n 1)

if [ -z "$UF2_FILE" ]; then
  echo "No .UF2 file was found in the build directory."
  exit 1
fi

# Upload the UF2 file using picotool
if ! picotool load -f "$UF2_FILE"; then
  echo "Failed to upload the file $UF2_FILE."
  exit 1
fi

# Reboot the device using picotool
if ! picotool reboot; then
  echo "Failed to reboot the device."
  exit 1
fi

echo "File $UF2_FILE was successfully uploaded, and the device has been rebooted."

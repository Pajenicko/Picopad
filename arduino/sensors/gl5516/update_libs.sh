#!/bin/bash

# Get the current directory
CURRENT_DIR=$(pwd)

# Display information about the directory at the start
echo "Starting the update process for directory: $CURRENT_DIR"

# Backup the user_config.h file
cp lib/picopad/include/user_config.h user_config.h.bak

# Delete specified directories
rm -rf lib/picopad lib/no-OS-FatFS-SD-SPI-RPi-Pico tools patches

# Delete specified files
rm -f build.sh

# Copy specified directories from ../../template
cp -r ../../template/lib/picopad lib/
cp -r ../../template/lib/no-OS-FatFS-SD-SPI-RPi-Pico lib/
cp -r ../../template/tools .
cp -r ../../template/patches .

# Copy specified files from ../../../template
cp ../../template/build.sh .
cp ../../template/tools/update_libs.sh .

# Restore the user_config.h file from the backup
cp user_config.h.bak lib/picopad/include/user_config.h

# Delete specified files
rm tools/update_libs.sh

# Delete the backup of user_config.h
rm user_config.h.bak

./build.sh

# Display completion message with the directory name
echo "Update complete for directory: $CURRENT_DIR!"

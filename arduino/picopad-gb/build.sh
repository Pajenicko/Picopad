#!/bin/bash

# For each game
for file in roms/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        filename_no_ext="${filename%.*}"
        echo "Processing $file..."

        # Check if 'build' directory exists and delete it
        if [ -d "build" ]; then
            rm -r "build"
        fi

        # Check if 'rom_builds' directory exists, if not create it
        if [ ! -d "rom_builds" ]; then
            mkdir -p "rom_builds"
        fi

        # Generate rom.c from the game's ROM file
        rom_file="src/rom.c"
        xxd -i "${file}" >"$rom_file"
        sed -i '' '1s/^.*$/#include <pico\/platform.h>\nconst unsigned char __in_flash("rom") gameRom[] = {/g' "$rom_file"

        # Build project
        docker run -e HOME=`pwd` -u $UID -w `pwd` -v `pwd`:`pwd` -e PLATFORMIO_CORE_DIR=/app --rm -it platformiobuild pio run -e picopad || exit 1

        # Copy the contents of 'build' directory to 'rom_builds'
        if [ -d "build" ]; then
          cp -rf build/GAMEBOY.UF2 rom_builds/"${filename_no_ext}".UF2
        fi

        # Clean up
        rm -r "build"
        rm -r "src/rom.c"
        rm -r ".pio"

        echo "Finished processing $file."
    fi
done

echo "All games processed."

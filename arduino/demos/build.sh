#!/bin/bash

# Go through each directory in the current directory
for dir in */ ; do
    cd "$dir"

    # Check if 'build' directory exists and delete it
    if [ -d "build" ]; then
        rm -r "build"
    fi

    # Check if '.pio' directory exists and delete it
    if [ -d ".pio" ]; then
        rm -r ".pio"
    fi

    # Call pio to generate the build files
    docker run -e HOME=`pwd` -u $UID -w `pwd` -v `pwd`:`pwd` -e PLATFORMIO_CORE_DIR=/app --rm -it platformiobuild pio run -e picopad || exit 1

    # Check if '.pio' directory exists and delete it
    if [ -d ".pio" ]; then
        rm -r ".pio"
    fi

    # Copy the contents of 'build' directory to 'sdcard' directory
    if [ -d "build" ]; then
        cp -rf build/* ../../sdcard/ARDUINO/DEMOS/
    fi

    # Go back to the parent directory
    cd ..
done

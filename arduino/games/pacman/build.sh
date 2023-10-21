#!/bin/bash

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

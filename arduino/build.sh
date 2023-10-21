#!/bin/bash

# Go through each directory in the current directory
for dir in */ ; do
    if [ "$dir" != "sdcard/" ] && [ "$dir" != "tools/" ]; then
        cd "$dir"
    
        ./build.sh || exit 1
	
        # Go back to the parent directory
        cd ..
    fi
done

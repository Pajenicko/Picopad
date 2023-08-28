#!/bin/bash

# Compilation...

export TARGET="SCD41"
export GRPDIR="DEMO"

origin_folder=$(pwd)
mkdir -p "../../sdk/PicoPad/DEMO/$TARGET" 2>/dev/null
cp -r *.* "../../sdk/PicoPad/DEMO/$TARGET"
cd "../../sdk/PicoPad/DEMO/$TARGET"

../../../_c1.sh picopad10

cd "$origin_folder"
cp -r "../../sdk/PicoPad/DEMO/$TARGET"/* "$origin_folder"
rm -r "../../sdk/PicoPad/DEMO/$TARGET"
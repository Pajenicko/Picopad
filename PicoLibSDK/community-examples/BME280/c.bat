@echo off
rem Compilation...

set TARGET=BME280
set GRPDIR=DEMO
set MEMMAP=

set "origin_folder=%CD%"
mkdir "..\..\sdk\PicoPad\DEMO\BME280" 2>nul
xcopy /E /Y "*.*" "..\..\sdk\PicoPad\DEMO\BME280"
cd /d "..\..\sdk\PicoPad\DEMO\BME280"

call ..\..\..\_c1.bat picopad10

cd /d "%origin_folder%"
xcopy /E /Y "..\..\sdk\PicoPad\DEMO\BME280\*" "%origin_folder%"
rmdir /S /Q "..\..\sdk\PicoPad\DEMO\BME280"

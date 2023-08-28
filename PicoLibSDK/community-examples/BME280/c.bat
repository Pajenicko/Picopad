@echo off
rem Compilation...

set TARGET=BME280
set DEVICE=picopad10

set "origin_folder=%CD%"
mkdir "..\..\sdk\PicoPad\DEMO\TMP" 2>nul
xcopy /E /Y "*.*" "..\..\sdk\PicoPad\DEMO\TMP"
cd /d "..\..\sdk\PicoPad\DEMO\TMP"

call ..\..\..\_c1.bat picopad10

cd /d "%origin_folder%"
xcopy /E /Y "..\..\sdk\PicoPad\DEMO\TMP\*" "%origin_folder%"
rmdir /S /Q "..\..\sdk\PicoPad\DEMO\TMP"

@echo off
rem Compilation...

set TARGET=DS18B20
set GRPDIR=DEMO
set MEMMAP=

set "origin_folder=%CD%"
mkdir "..\..\sdk\PicoPad\DEMO\DS18B20" 2>nul
xcopy /E /Y "*.*" "..\..\sdk\PicoPad\DEMO\DS18B20"
cd /d "..\..\sdk\PicoPad\DEMO\DS18B20"

call ..\..\..\_c1.bat picopad10

cd /d "%origin_folder%"
xcopy /E /Y "..\..\sdk\PicoPad\DEMO\DS18B20\*" "%origin_folder%"
rmdir /S /Q "..\..\sdk\PicoPad\DEMO\DS18B20"

@echo off
rem Compilation...

set TARGET=HC-SR04
set GRPDIR=DEMO
set MEMMAP=

set "origin_folder=%CD%"
mkdir "..\..\sdk\PicoPad\DEMO\HC-SR04" 2>nul
xcopy /E /Y "*.*" "..\..\sdk\PicoPad\DEMO\HC-SR04"
cd /d "..\..\sdk\PicoPad\DEMO\HC-SR04"

call ..\..\..\_c1.bat picopad10

cd /d "%origin_folder%"
xcopy /E /Y "..\..\sdk\PicoPad\DEMO\HC-SR04\*" "%origin_folder%"
rmdir /S /Q "..\..\sdk\PicoPad\DEMO\HC-SR04"

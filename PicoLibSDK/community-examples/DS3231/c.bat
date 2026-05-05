@echo off
rem Compilation...

set TARGET=DS3231
set GRPDIR=DEMO
set MEMMAP=

set "origin_folder=%CD%"
mkdir "..\..\sdk\PicoPad\DEMO\DS3231" 2>nul
xcopy /E /Y "*.*" "..\..\sdk\PicoPad\DEMO\DS3231"
cd /d "..\..\sdk\PicoPad\DEMO\DS3231"

call ..\..\..\_c1.bat picopad10

cd /d "%origin_folder%"
xcopy /E /Y "..\..\sdk\PicoPad\DEMO\DS3231\*" "%origin_folder%"
rmdir /S /Q "..\..\sdk\PicoPad\DEMO\DS3231"

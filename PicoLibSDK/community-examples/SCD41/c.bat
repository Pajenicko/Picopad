@echo off
rem Compilation...

set TARGET=SCD41
set GRPDIR=DEMO
set MEMMAP=

set "origin_folder=%CD%"
mkdir "..\..\sdk\PicoPad\DEMO\SCD41" 2>nul
xcopy /E /Y "*.*" "..\..\sdk\PicoPad\DEMO\SCD41"
cd /d "..\..\sdk\PicoPad\DEMO\SCD41"

call ..\..\..\_c1.bat picopad10

cd /d "%origin_folder%"
xcopy /E /Y "..\..\sdk\PicoPad\DEMO\SCD41\*" "%origin_folder%"
rmdir /S /Q "..\..\sdk\PicoPad\DEMO\SCD41"

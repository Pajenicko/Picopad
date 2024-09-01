@echo off
rem Compilation...

set TARGET=GL5516
set GRPDIR=DEMO
set MEMMAP=

set "origin_folder=%CD%"
mkdir "..\..\sdk\PicoPad\DEMO\GL5516" 2>nul
xcopy /E /Y "*.*" "..\..\sdk\PicoPad\DEMO\GL5516"
cd /d "..\..\sdk\PicoPad\DEMO\GL5516"

call ..\..\..\_c1.bat picopad10

cd /d "%origin_folder%"
xcopy /E /Y "..\..\sdk\PicoPad\DEMO\GL5516\*" "%origin_folder%"
rmdir /S /Q "..\..\sdk\PicoPad\DEMO\GL5516"

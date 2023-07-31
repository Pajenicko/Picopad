@echo off
rem Compilation...

set TARGET=SCD41
set DEVICE=picopad10

set "origin_folder=%CD%"
mkdir "..\..\sdk\DEMO\TMP" 2>nul
xcopy /E /Y "*.*" "..\..\sdk\DEMO\TMP"
cd /d "..\..\sdk\DEMO\TMP"

call ..\..\_c1.bat picopad10

cd /d "%origin_folder%"
xcopy /E /Y "..\..\sdk\DEMO\TMP\*" "%origin_folder%"
rmdir /S /Q "..\..\sdk\DEMO\TMP"

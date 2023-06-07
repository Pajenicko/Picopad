@echo off
rem Compilation...

set TARGET=MONOSCOP
set DEVICE=picopad
call ..\..\_c1.bat

if not exist %TARGET%.uf2 goto stop
..\..\_tools\PicoPadLoaderCrc\LoaderCrc.exe %TARGET%.bin %TARGET%.uf2
if errorlevel 1 goto stop
if not exist ..\..\!PicoPad\TEST\*.UF2 md ..\..\!PicoPad\TEST
copy /b %TARGET%.uf2 ..\..\!PicoPad\TEST\%TARGET%.UF2 > nul
:stop

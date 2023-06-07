@echo off
rem Compilation...

set TARGET=HELLO
set DEVICE=picopad
call ..\..\_c1.bat

if not exist %TARGET%.uf2 goto stop
..\..\_tools\PicoPadLoaderCrc\LoaderCrc.exe %TARGET%.bin %TARGET%.uf2
if errorlevel 1 goto stop
if not exist ..\..\!PicoPad\DEMO\*.UF2 md ..\..\!PicoPad\DEMO
copy /b %TARGET%.uf2 ..\..\!PicoPad\DEMO\%TARGET%.UF2 > nul
:stop

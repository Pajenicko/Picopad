@echo off
rem Compilation...

set TARGET=VEGASLOT
set DEVICE=picopad
call ..\..\_c1.bat

if not exist %TARGET%.uf2 goto stop
..\..\_tools\PicoPadLoaderCrc\LoaderCrc.exe %TARGET%.bin %TARGET%.uf2
if errorlevel 1 goto stop
if not exist ..\..\!PicoPad\GAME\*.UF2 md ..\..\!PicoPad\GAME
copy /b %TARGET%.uf2 ..\..\!PicoPad\GAME\%TARGET%.UF2 > nul
:stop

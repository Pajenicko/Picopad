@echo off
rem Compilation...

set TARGET=NEW
set DEVICE=picopad
call ..\..\_c1.bat

if not exist %TARGET%.uf2 goto stop
..\..\_tools\PicoPadLoaderCrc\LoaderCrc.exe %TARGET%.bin %TARGET%.uf2
if errorlevel 1 goto stop
if not exist ..\..\!PicoPad\NEW\*.UF2 md ..\..\!PicoPad\NEW
copy /b %TARGET%.uf2 ..\..\!PicoPad\NEW\%TARGET%.UF2 > nul
:stop

@echo off
rem Compilation...

set TARGET=LOADER
set DEVICE=picopad_loader
call ..\..\_c1.bat

if not exist %TARGET%.uf2 goto stop
if not exist ..\..\!PicoPad\NEW\*.UF2 md ..\..\!PicoPad\NEW
copy /b %TARGET%.uf2 ..\..\!PicoPad\%TARGET%.UF2 > nul
exe\LoaderBin LOADER.bin ..\loader_bin.S
:stop

@echo off
rem Compilation...

set TARGET=GINGER
..\..\_tools\PicoPadLoaderCrc\LoaderCrc.exe %TARGET%.bin %TARGET%.uf2

@echo off
rem Compilation...

set PATH=..\..\_tools;C:\ARM10\bin;%PATH%

if exist %TARGET%.uf2 del %TARGET%.uf2
if exist %TARGET%.bin del %TARGET%.bin
make all 
if errorlevel 1 goto err
if not exist %TARGET%.uf2 goto err
echo.
type %TARGET%.siz
goto end

:err
pause ERROR!
:end

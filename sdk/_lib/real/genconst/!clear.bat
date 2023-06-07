@echo off

call :clear1 Debug
call :clear1 Release
call :clear1 Debug_x64
call :clear1 Release_x64

if exist *.ncb del *.ncb
if exist *.pdb del *.pdb
if exist *.user del *.user
if exist *_deb.exe del *_deb.exe

attrib -H *.suo > nul
if exist *.suo del *.suo

exit /b

:clear1
if "%1"=="" goto end
if exist %1\*.pch goto start
if exist %1\*.pdb goto start
if exist %1\*.cod goto start
if exist %1\*.htm goto start
if not exist %1\*.obj goto end

:start
if exist %1\*.htm del %1\*.htm
if exist %1\*.dep del %1\*.dep
if exist %1\*.exe del %1\*.exe
if exist %1\*.ilk del %1\*.ilk
if exist %1\*.obj del %1\*.obj
if exist %1\*.pdb del %1\*.pdb
if exist %1\*.manifest del %1\*.manifest
if exist %1\*.res del %1\*.res
if exist %1\*.idb del %1\*.idb
if exist %1\*.pch del %1\*.pch
if exist %1\*.cod del %1\*.cod
rd %1

:end

exit /b

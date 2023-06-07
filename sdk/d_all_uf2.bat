@echo off
rem Deleting UF2
for /D %%d in (*) do call :d3 %%d
exit /b

:d3
if not exist %1\d.bat goto stop
cd %1
echo Deleting %1
call :d4
cd ..
:stop
exit /b

:d4
for /D %%d in (*) do call :d5 %%d
exit /b

:d5
if not exist %1\d.bat goto stop2
cd %1
echo Deleting %1
if exist *.uf2 del *.uf2
cd ..
:stop2
exit /b

@echo off

rem Boot2 need to be compiled first
cd _boot2
echo.
echo ======== Compiling _boot2 ========
call c.bat
cd ..

rem Loader need to be compiled second
cd !LOADER
echo.
echo ======== Compiling !LOADER ========
call c.bat
cd ..

for /D %%d in (*) do call _c2.bat %%d

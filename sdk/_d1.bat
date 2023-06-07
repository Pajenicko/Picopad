@echo off
rem Delete...

if exist build\%TARGET%.elf del build\%TARGET%.elf
if not exist build\*.o goto nobuild
del build\*.o
rd /q build
:nobuild
if exist %TARGET%.hex del %TARGET%.hex
if exist %TARGET%.lst del %TARGET%.lst
if exist %TARGET%.map del %TARGET%.map
if exist %TARGET%.siz del %TARGET%.siz
if exist %TARGET%.sym del %TARGET%.sym
if exist %TARGET%.bin del %TARGET%.bin

:end

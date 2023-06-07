@echo off
copy /b program_.bin program.bin > nul
copy /b program_.uf2 program.uf2 > nul
LoaderCrc program.bin program.uf2

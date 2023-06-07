@echo off
rem Export to hardware...

if not exist %TARGET%.uf2 goto end
copy /b %TARGET%.uf2 r:

:end

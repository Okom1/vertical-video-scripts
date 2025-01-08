@echo off

set /p scalar="Enter desired scalar (e.g. 1.5): "

ffmpeg -i "%~1" -vf scale=(iw/%scalar%):-2 -c:a copy "scaled_%~n1%~x1"
REM 'pause' to show potential errors before exiting
pause
exit

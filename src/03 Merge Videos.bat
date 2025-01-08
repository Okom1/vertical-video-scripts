@echo off
chcp 1252
SETLOCAL EnableExtensions EnableDelayedExpansion

for /d %%A in (%*) do (
    set /A foldersAvailable=1
    set "file=%%~nxA"
    echo file ^'%%~dpA%%~nxA^' >>confiles.txt
)

if "%foldersAvailable%"=="" (
	cls
	echo Merging does not work this way:
	echo Please drop files on this batch file to merge them.
	echo.
	pause
	exit
)

ffmpeg -f concat -safe 0 -i confiles.txt -c copy merged_"!file!"
del confiles.txt
exit

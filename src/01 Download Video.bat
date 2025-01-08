@echo off

set /p link="Enter video URL to download: "
set /p filename="Enter output file name: "

:choice
set /P c=Download only specific section of video? (Y/N): 
if /I "%c%" EQU "Y" goto :download-section
if /I "%c%" EQU "N" goto :download-full
goto :choice

:download-section

set /p starttime="Enter clip start time (HH:mm:ss.SSS): "
set /p endtime="Enter clip end time (HH:mm:ss.SSS): "

yt-dlp --no-check-certificate --download-sections "*%starttime%-%endtime%" "%link%" -o "%filename%.mp4"
exit

:download-full

yt-dlp "%link%" -o "%filename%.mp4"
exit

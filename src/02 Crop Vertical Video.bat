@echo off

:choice-webcam
set /p answer=Relocate webcam to vertical video? (Y/N): 
if /i "%answer%" EQU "Y" goto :webcam-true
if /i "%answer%" EQU "N" goto :webcam-false
goto :choice-webcam

:webcam-true
set /p answer=Use preset webcam position values? (Y/N): 
if /i "%answer%" EQU "Y" goto :webcam-preset-true
if /i "%answer%" EQU "N" goto :webcam-preset-false
goto :choice-webcam

:webcam-preset-true

REM Preset webcam position values; change to your own desired values
set videoWidth=1920
set videoHeight=1080
set camWidth=535
set camHeight=326
set camPosWidth=1339
set camPosHeight=97
set camScale=1
set camOffsetHorizontal=1
set camOffsetVertical=10

goto :calculate-cam-pos

:webcam-preset-false

REM Set defaults, so they work even if skipped
set camScale=1
set camOffsetHorizontal=1
set camOffsetVertical=10

REM Manually set webcam position values
set /p videoWidth="Enter video width in pixels (e.g. 1920): " 
set /p videoHeight="Enter video height in pixels (e.g. 1080): " 
set /p camWidth="Enter webcam width in pixels: " 
set /p camHeight="Enter webcam height in pixels: " 
set /p camPosWidth="Enter webcam distance from the left of video in pixels: " 
set /p camPosHeight="Enter webcam distance from the top of video in pixels: " 
set /p camScale="Enter webcam output size multiplier (default = 1): " 
set /p camOffsetHorizontal="Enter webcam horizontal offset (default = 1): " 
set /p camOffsetVertical="Enter webcam vertical offset (default = 10): " 

goto :calculate-cam-pos

:calculate-cam-pos
for /f "delims=" %%a in ('powershell -Command %videoWidth%/%camWidth%') do set ratioCamWidth=%%a
for /f "delims=" %%a in ('powershell -Command %videoHeight%/%camHeight%') do set ratioCamHeight=%%a
for /f "delims=" %%a in ('powershell -Command %videoWidth%/%camPosWidth%') do set ratioCamPosWidth=%%a
for /f "delims=" %%a in ('powershell -Command %videoHeight%/%camPosHeight%') do set ratioCamPosHeight=%%a
for /f "delims=" %%a in ('powershell -Command %videoWidth%/%camOffsetHorizontal%') do set ratioCamOffsetHorizontal=%%a
for /f "delims=" %%a in ('powershell -Command %videoHeight%/%camOffsetVertical%') do set ratioCamOffsetVertical=%%a

goto :choice-trim

:webcam-false

set ratioCamWidth=1
set ratioCamHeight=1
set ratioCamPosWidth=1
set ratioCamPosHeight=1
set camScale=1
set ratioCamOffsetHorizontal=1
set ratioCamOffsetVertical=1

goto :choice-trim

:choice-trim
set /p answer=Trim video to a specific section? (Y/N): 
if /i "%answer%" EQU "Y" goto :video-trim
if /i "%answer%" EQU "N" goto :video-full
goto :choice-trim

:video-trim

REM Set defaults, so they work even if skipped
set starttime=0
set endtime=99999

set /p starttime="Enter clip start time (HH:mm:ss.SSS): "
set /p endtime="Enter clip end time (HH:mm:ss.SSS): "

goto :video-transcode

:video-full

set starttime=0
set endtime=99999

goto :video-transcode

:video-transcode

ffmpeg -ss %starttime% -to %endtime% -i "%~1" -filter_complex "[0:v]crop=(iw/3.15789):(ih)[vertical],[0:v]crop=(iw/%ratioCamWidth%):(ih/%ratioCamHeight%):(iw/%ratioCamPosWidth%):(ih/%ratioCamPosHeight%)[webcam],[webcam]scale=(iw*%camScale%):(ih*%camScale%)[webcam-scaled],[vertical][webcam-scaled]overlay=(((W-w)/2)+(W/%ratioCamOffsetHorizontal%)):(H/%ratioCamOffsetVertical%)[out]" -map [out] -map 0:a -c:a copy "vertical_%~n1.mp4"
exit

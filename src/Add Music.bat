@echo off

ffprobe -i "%~1" -show_entries format=duration -v quiet -of csv="p=0" >> duration.txt

set /p videoduration=<duration.txt
set /a fadestart=videoduration-5
del duration.txt

REM Set defaults, so they work even if skipped
set starttime=0
set volume=0.1

set /p starttime="Enter music start time (mm:ss): "
set /p volume="Enter music volume (default = 0.1): "

ffmpeg -i "%~1" -ss %starttime% -i "%~2" -filter_complex [1:a]volume=%volume%[music],[music]afade=in:st=0:d=1[music-fade-in],[music-fade-in]afade=out:st=%fadestart%:d=3[music-fade-in-out],[0:a][music-fade-in-out]amix=inputs=2[combined],[combined]volume=2[audio] -map 0:v -map [audio] -c:v copy -shortest "music_%~n1.mp4"
exit

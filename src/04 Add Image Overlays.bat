@echo off

ffprobe -i "%~1" -show_entries format=duration -v quiet -of csv="p=0" >> duration.txt

set /p videoduration=<duration.txt
set /a fadestart=videoduration-3
del duration.txt

:choice
set /p answer=Add end card? (Y/N): 
if /i "%answer%" EQU "Y" goto :end-card-true
if /i "%answer%" EQU "N" goto :end-card-false
goto :choice

:end-card-true

ffmpeg -i "%~1" -i "image-overlay.png" -loop 1 -i "end-card.png" -filter_complex [1:v][0:v]scale=rw:rh[1-scaled],[2:v][0:v]scale=rw:rh[2-scaled],[0:v][1-scaled]overlay=0:0[image-overlay],[2-scaled]fade=in:st=%fadestart%:d=1:alpha=1[end-card],[image-overlay][end-card]overlay[out] -map [out] -map 0:a -c:a copy -shortest "overlay_%~n1.mp4"
exit

:end-card-false

ffmpeg -i "%~1" -i "image-overlay.png" -filter_complex [1:v][0:v]scale=rw:rh[1-scaled],[0:v][1-scaled]overlay=0:0[image-overlay] -map [image-overlay] -map 0:a -c:a copy -shortest "overlay_%~n1.mp4"
exit

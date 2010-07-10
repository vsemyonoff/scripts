#!/bin/sh

if [ $# -ne 1 ]; then
    echo "usage: $0 output"
fi

screen -m -d mencoder -fps 7.52 tv:// -ovc lavc -lavcopts vcodec=mpeg4 -o "$1"; sleep 2; mplayer "$1"; screen -r
#mencoder tv:// -tv driver=v4l2:width=320:height=240:device=/dev/video0:alsa:forceaudio:amode=0:adevice=hw.0,0 -ovc lavc -lavcopts vcodec=mpeg4 -oac mp3lame -lameopts vbr=3:br=32:mode=3 -af volnorm -o VideoFile.avi
ffmpeg -t 10 -f video4linux2 -r 30 -i /dev/video0 -f avi webcam.avi

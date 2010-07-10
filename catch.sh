#!/bin/sh

if [ $# -ne 1 ]; then
    echo "usage: $0 output"
fi

screen -m -d mencoder -fps 7.52 tv:// -ovc copy -o "$1"; sleep 2; mplayer "$1"; screen -r

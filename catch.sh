#!/bin/sh

if [ $# -ne 1 ]; then
    echo "usage: $0 output"
    exit 1
fi

ffmpeg -y -f video4linux2 -r 30 -i /dev/video0 -f avi "$1"

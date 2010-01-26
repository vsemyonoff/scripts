#!/bin/sh

if [ -z "$1" ]; then
    exec mplayer dvdnav:// -dvd-device "$(pwd)"
else
    exec mplayer dvdnav:// -dvd-device "$(readlink -m $1)"
fi

#!/usr/bin/env bash

#
#  File: audio-osd.sh
#  Description:
#
#  Creation date: 2010.08.03 17:41:53
#  Last modified: 2010.08.03 19:11:28
#
#  Copyright © 2010 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

PID=`pgrep audacious`
PLAYER=`which audacious2`

if  [ -z $PID ] ; then
    if [ -z $PLAYER ]; then
        OUTPUT="audacious2 not installed"
    else
        bash -c "audacious2 &"
    fi
fi

if [ -z $OUTPUT ]; then
    case $1 in

       play) audtool2 --playback-playpause ;;

       stop) audtool2 --playback-stop ;;

       prev) audtool2 --playlist-reverse ;;

       next) audtool2 --playlist-advance ;;

       *) echo "Usage: $0 { play | stop | prev | next }"  && exit 1;;

    esac
fi

killall aosd_cat &> /dev/null
echo -n "`audtool2 --playlist-position` - `audtool2 --current-song` - `audtool2 --current-song-length` (`audtool2 --playback-status`)" | aosd_cat -n "Sans 20 bold" -o 3000 -R yellow -f 0

# End of script

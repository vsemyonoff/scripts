#!/usr/bin/env bash

#
#  File: audio-osd.sh
#  Description:
#
#  Creation date: 2010.08.03 17:41:53
#  Last modified: 2010.08.04 00:13:30
#
#  Copyright © 2010 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

case $1 in

    play) (mpc status | grep -q "playing") && mpc pause || mpc play ;;

    stop) mpc stop ;;

    prev) mpc prev ;;

    next) mpc next ;;

    *) echo "Usage: $0 { play | stop | prev | next }"  && exit 1;;

esac

killall aosd_cat &> /dev/null
echo -n `mpc status` | aosd_cat -n "Sans 20 bold" -o 3000 -R yellow -f 0

# End of script

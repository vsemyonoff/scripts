#!/usr/bin/env bash

#
#  File: audio-osd.sh
#  Description:
#
#  Creation date: 2010.08.03 17:41:53
#  Last modified: 2010.10.12 14:16:59
#
#  Copyright © 2010 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

case $1 in

    play) mpc toggle ;;

    stop) mpc stop ;;

    prev) mpc prev ;;

    next) mpc next ;;

    *) echo "Usage: $0 { play | stop | prev | next }"  && exit 1;;

esac

killall aosd_cat &> /dev/null
mpc status | aosd_cat -l 3 -n "Sans 20 bold" -o 0 -R yellow -f 3000

# End of script

#!/usr/bin/env bash

#
#  File: audio-osd.sh
#  Description:
#
#  Creation date: 2010.08.03 17:41:53
#  Last modified: 2010.10.21 15:31:03
#
#  Copyright © 2010 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

case $1 in

    play) ncmpcpp toggle ;;

    stop) ncmpcpp stop ;;

    prev) ncmpcpp prev ;;

    next) ncmpcpp next ;;

    *) echo "Usage: $0 { play | stop | prev | next }"  && exit 1;;

esac

STATUS="$(ncmpcpp --now-playing)"
[ -x ${STATUS} ] && STATUS="STOPPED"
killall aosd_cat &> /dev/null
echo "${STATUS}" | aosd_cat -n "Sans 20 bold" -o 0 -R yellow -f 0

# End of script

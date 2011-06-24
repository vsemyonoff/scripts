#!/usr/bin/env bash

#
#  File: audio-osd.sh
#  Description: require libaosd
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

    *) ;; # Noop, just show info

esac

LEN="$(ncmpcpp --now-playing %l)"
if [ -z "${LEN}" ]; then
    STATUS="STOPPED"
else
    TITLE="$(ncmpcpp --now-playing %t)"
    if [ -z "${TITLE}" ]; then
        FILE="$(ncmpcpp --now-playing %f)"
        STATUS="(${LEN})  ${FILE}"
    else
        ARTIST="$(ncmpcpp --now-playing %a)"
        if [ -z "${ARTIST}" ]; then
            STATUS="(${LEN})  ${TITLE}"
        else
            STATUS="(${LEN})  ${ARTIST} - ${TITLE}"
        fi
    fi
fi

killall -u "${USER}" aosd_cat &> /dev/null
echo "${STATUS}" | aosd_cat -n "Sans 20 bold" -l 5 -o 0 -R yellow -f 0

# End of script

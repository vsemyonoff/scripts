#!/usr/bin/env bash

#
#  File: backlight-osd.sh
#  Description: require libaosd
#
#  Creation date: 2010.08.03 17:41:53
#  Last modified: 2010.08.03 18:29:33
#
#  Copyright © 2010 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

BLPATH="/sys/class/backlight/acpi_video0"
CONTROL="${BLPATH}/brightness"
MAXIMUM=$(cat "${BLPATH}/max_brightness")
CURRENT=$(cat "${CONTROL}")

case $1 in
   raise)
       NEWVALUE=$(( CURRENT + 16500 ))
       [ ${NEWVALUE} -gt ${MAXIMUM} ] && NEWVALUE=${MAXIMUM}
       ;;
   lower)
       NEWVALUE=$(( CURRENT - 16500 ))
       [ ${NEWVALUE} -lt 0 ] && NEWVALUE=0
       ;;
   *) echo "Usage: ${0} { raise | lower }"  && exit 1;;
esac
sudo bash -c "echo ${NEWVALUE} > ${CONTROL}"

PERC=$(( ${NEWVALUE} * 100 / ${MAXIMUM} ))

exec echo-osd "LCD Brightness: ${PERC}%"

# End of script

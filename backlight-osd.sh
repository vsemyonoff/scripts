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

BLPATH="/sys/class/backlight/sony"
CONTROL="${BLPATH}/brightness"
MAXIMUM=$(cat "${BLPATH}/max_brightness")
CURRENT=$(cat "${CONTROL}")

case $1 in
   raise)
       NEWVALUE=$((CURRENT + 10))
       [ ${NEWVALUE} -gt ${MAXIMUM} ] && NEWVALUE=${MAXIMUM}
       ;;
   lower)
       NEWVALUE=$((CURRENT - 10))
       [ ${NEWVALUE} -lt 1 ] && NEWVALUE=1
       ;;
   *) echo "Usage: ${0} { raise | lower }"  && exit 1;;
esac
sudo bash -c "echo ${NEWVALUE} > ${CONTROL}"

PERC=$(( ${NEWVALUE} / (${MAXIMUM} / 100) ))
[ ${PERC} -gt 100 ] && PERC=100

exec echo-osd "LCD Brightness: ${PERC}%"

# End of script

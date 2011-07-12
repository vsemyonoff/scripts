#!/usr/bin/env bash

#
#  File: volume.sh
#  Description: require libaosd
#
#  Creation date: 2010.08.03 16:45:13
#  Last modified: 2010.08.03 16:45:58
#
#  Copyright © 2010 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

case $1 in
   volup) VOL="VOLUME: $(amixer sset Master 1dB+ | grep "Mono:" | awk '{print $4}' | tr -d '[]')" ;;
   voldown) VOL="VOLUME: $(amixer sset Master 1dB- | grep "Mono:" | awk '{print $4}' | tr -d '[]')" ;;
   mute) amixer set Master toggle ;;
   *) echo "Usage: ${0} { volup | voldown | mute }" ;;
esac

MUTESTATUS=$(amixer get Master | grep "Mono:" | awk '{print $6}' | tr -d '[]')

if [ "${MUTESTATUS}" == "off" ]; then
    ARG="--error" && [ -z "${VOL}" ] && VOL="MUTED"
else
    [ -z "${VOL}" ] && VOL="UNMUTED"
fi

exec echo-osd ${ARG} ${VOL}

# End of script

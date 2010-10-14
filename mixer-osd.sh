#!/usr/bin/env bash

#
#  File: volume.sh
#  Description:
#
#  Creation date: 2010.08.03 16:45:13
#  Last modified: 2010.08.03 16:45:58
#
#  Copyright © 2010 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

case $1 in

   volup) A="VOLUME: $(amixer sset Master 2dB+ | grep "Mono:" \
      | awk '{print $4}' | tr -d '[]')" ;;

   voldown) A="VOLUME: $(amixer sset Master 1dB- | grep "Mono:" \
      | awk '{print $4}' | tr -d '[]')" ;;

   mute)
      case $(amixer set Master toggle | grep "Mono:" \
         | awk '{print $6}' | tr -d '[]') in
            on) A="UNMUTED" ;;
            off) A="MUTED" ;;
      esac ;;

   *) echo "Usage: $0 { volup | voldown | mute }" ;;

esac

MUTESTATUS=$(amixer get Master | grep "Mono:" | awk '{print $6}' | tr -d '[]')

if [ $MUTESTATUS == "off" ]; then
   OSDCOLOR=red; else
   OSDCOLOR=yellow
fi

killall aosd_cat &> /dev/null

echo "$A" | aosd_cat -n "Sans 20 bold" -o 0 -R $OSDCOLOR -f 0

# End of script

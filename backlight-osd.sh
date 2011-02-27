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

CONTROL="/sys/class/backlight/acpi_video0/brightness"
MAXIMUM=`cat /sys/class/backlight/acpi_video0/max_brightness`
CURRENT=`cat $CONTROL`

case $1 in

   raise) [ $CURRENT -lt $MAXIMUM ] && NEWVALUE=$((CURRENT + 1)) || NEWVALUE=$CURRENT ;;

   lower) [ $CURRENT -gt 1 ] && NEWVALUE=$((CURRENT - 1)) || NEWVALUE=1 ;;

   *) echo "Usage: $0 { raise | lower }"  && exit 1;;

esac
sudo bash -c "echo $NEWVALUE > $CONTROL"

killall aosd_cat &> /dev/null

echo -n "LCD Brightness: $((100 / MAXIMUM * NEWVALUE + 4))%" | aosd_cat -n "Sans 20 bold" -o 0 -R yellow -f 0

# End of script

#!/usr/bin/env bash

#
#  File: burndvd.sh
#  Description: require dvd+rw-tools
#
#  Creation date: 2011.02.16 17:01:53
#  Last modified: 2011.04.03 10:56:12
#
#  Copyright © 2011 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

if [ $# -ne 1 ]; then
    echo "usage: $(basename $(readlink -m $0)) path_to_data"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: '$1' is not a folder, exiting..."
    exit 1
fi

exec growisofs -dvd-compat -Z /dev/dvdrw -allow-limited-size -joliet-long -f -r -J "$1"

# End of script

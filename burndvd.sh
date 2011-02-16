#!/usr/bin/env bash

#
#  File: burndvd.sh
#  Description:
#
#  Creation date: 2011.02.16 17:01:53
#  Last modified: 2011.02.16 17:12:18
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

exec growisofs -Z /dev/dvdrw -r -f -J "$1"

# End of script

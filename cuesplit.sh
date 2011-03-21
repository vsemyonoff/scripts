#!/usr/bin/env bash

#
#  File: cuesplit.sh
#  Description: require cue2tracks lame mac id3v2
#
#  Version: cuesplit.sh, 2011/02/27 19:24:26 EET
#  Copyright © 2010 Vladyslav Semyonov <vsemyonoff@gmail.com>
#

cue2tracks -R -c mp3 -l best -Q 0 -f cp1251  -o "%A/%N - %t" -i "$1" "$2"

# End of cuesplit.sh

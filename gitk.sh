#!/usr/bin/env bash

#
#  File: gitk.sh
#  Description: gitk wrapper to prevent gui translation till fonts bug won't fixed
#
#  Version: gitk, 2010/12/09 14:41:41 EET
#  Copyright © 2010 Vladyslav Semyonov <vsemyonoff@gmail.com>
#

LANG=C exec /usr/bin/gitk "$@"

# End of gitk.sh

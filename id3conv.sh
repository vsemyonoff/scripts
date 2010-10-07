#!/usr/bin/env bash

#
#  File: id3conv.sh
#  Description:
#
#  Version: id3conv.sh, 2010/10/07 14:40:36 EEST
#  Copyright © 2010 Vladyslav Semyonov <vsemyonoff@gmail.com>
#

find . -name "*.[Mm][Pp]3" -exec mp3unicode -s cp1251 -p -1 none -2 unicode {} +

# End of id3conv.sh

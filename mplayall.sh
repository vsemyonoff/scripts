#!/usr/bin/env bash

#
#  File: mplayall.sh
#  Description:
#
#  Creation date: 2011.01.27 12:38:00
#  Last modified: 2011.01.27 13:40:42
#
#  Copyright © 2011 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

find . -type f -print | sort -V | mplayer -playlist -

#!/usr/bin/env bash

#
#  File: 00-Смотреть_все
#  Description:
#
#  Creation date: 2011.01.27 12:38:00
#  Last modified: 2011.01.27 13:14:49
#
#  Copyright © 2011 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

mplayer -- `find . -type f | sed -e 's/\ /\\\ /g' | sort -V`

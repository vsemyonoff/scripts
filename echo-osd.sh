#!/usr/bin/env bash

killall -u "${USER}" aosd_cat >/dev/null 2>&1
echo "${@}" | aosd_cat -n "AG_Futura 14" -s 0 -b 100 -B white -R black

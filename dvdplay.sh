#!/bin/sh

DEVICE="${1:-"$(pwd)"}"

exec mplayer -nocache dvdnav:// -dvd-device "${DEVICE}"

#!/bin/sh

DEVICE="${1:-"$(pwd)"}"

exec mplayer dvdnav:// -dvd-device "${DEVICE}"

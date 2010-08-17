#!/usr/bin/env bash

DEVICE="${1:-"$(pwd)"}"

exec mplayer -nocache dvdnav:// -dvd-device "${DEVICE}"

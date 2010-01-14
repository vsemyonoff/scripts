#!/bin/sh

exec mplayer dvdnav:// -dvd-device "$(pwd)" &

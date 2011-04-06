#!/usr/bin/env bash

# Set wine version and prefix
WINEARCH=win32
WINEPREFIX=$(dirname $(readlink -m ${0}))
export WINEARCH WINEPREFIX

# 32 bit app starter (schroot or any wrapper)
[ "$(uname -m)" == "x86_64" ] && BIN32="bin32"

# Setup or update prefix folder
if [ ! -d "${WINEPREFIX}/drive_c" ]; then
    exec ${BIN32} winecfg
else
    [ ! -f "${WINEPREFIX}/.update-timestamp" ] && exec ${BIN32} wineboot
fi

# Start winecfg or winetricks
case "$1" in
    bash)
        shift
        exec ${BIN32} bash "${@}"
        ;;

    regedit)
        shift
        exec ${BIN32} regedit "${@}"
        ;;

    winecfg)
        exec ${BIN32} winecfg
        ;;

    winetricks)
        shift
        exec ${BIN32} winetricks "${@}"
        ;;
esac

# Start application
killall xcompmgr >/dev/null 2>&1
cd "${WINEPREFIX}/drive_c/your-app.folder" &&
    exec ${BIN32} wine your-app.bin "${@}"

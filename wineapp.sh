#!/usr/bin/env bash

# Set wine home folder
WINEPREFIX=`dirname $(readlink -m $0)`
[ "$WINEPREFIX" == "." ] && WINEPREFIX=`pwd`
export WINEPREFIX

# Start application
cd "$WINEPREFIX/drive_c/your-app.folder" && \
    exec bin32 wine your-app.bin "$@"

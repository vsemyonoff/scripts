#!/usr/bin/env bash

# Set wine home folder
WINEPREFIX=
if [ -L $0 ]; then
    WINEPREFIX=`dirname $(readlink $0)`
else
    WINEPREFIX=`dirname $0`
fi
[ "$WINEPREFIX" == "." ] && WINEPREFIX=`pwd`
export WINEPREFIX

# Start application
cd "$WINEPREFIX/drive_c/your-app.folder" && \
wine your-app.bin "$@"

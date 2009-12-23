#!/bin/sh

if [ -z $DISPLAY ]; then
    ARGS="--tty"
else
    ARGS="--create-frame"
fi

exec emacsclient --alternate-editor="" $ARGS "$@"

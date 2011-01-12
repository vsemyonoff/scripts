#!/usr/bin/env bash

EMACS="emacsclient --alternate-editor="

# Iterate arguments
while (( "$#" )); do
    if [ "$1" == "--nofork" ]; then
        NOFORK=1
    else
        EMACS_ARGS="${EMACS_ARGS} $1"
    fi
    if [ "$1" == "-nw" ] || [ "$1" == "-t" ] || [ "$1" == "--tty" ]; then
        NOFORK=1
    fi
    shift
done

# Exec emacs
if [ -z ${DISPLAY} ]; then
    exec ${EMACS} --tty ${EMACS_ARGS}
else
    EMACS="${EMACS} --create-frame"
    if [ -z "${NOFORK}" ]; then
        exec ${EMACS} ${EMACS_ARGS} &>/dev/null &
    else
        exec ${EMACS} ${EMACS_ARGS}
    fi
fi

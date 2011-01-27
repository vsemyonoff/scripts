#!/usr/bin/env bash

EMACS="emacsclient --alternate-editor="

# Iterate arguments
while (( "$#" )); do
    if [ "$1" != "--nofork" ]; then
        EMACS_ARGS="${EMACS_ARGS} $1"
    fi
    case "$1" in
        --nofork|--tty|-nw|-t)
            NOFORK=1
            ;;
        *)
            ;;
    esac
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

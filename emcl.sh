#!/bin/sh

EMACS="emacsclient --alternate-editor=\"\""

if [ -z $DISPLAY ]; then
    exec ${EMACS} --tty "$@" &>/dev/null
else
    exec ${EMACS} --create-frame "$@" &>/dev/null &
fi

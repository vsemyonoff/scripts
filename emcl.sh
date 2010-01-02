#!/bin/sh

EMACS="emacsclient --alternate-editor="

if [ -z $DISPLAY ]; then
    exec ${EMACS} --tty "$@"
else
    exec ${EMACS} --create-frame "$@" &>/dev/null &
fi

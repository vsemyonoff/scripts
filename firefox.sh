#!/usr/bin/env bash

FIREPATH="${HOME}/.mozilla/firefox/profiles.ini"
PROFILE=$(grep Path ${FIREPATH} | cut -f 2 -d '=')
rm -fr "${HOME}/.mozilla/firefox/${PROFILE}/compatibility.ini"
exec /usr/bin/firefox "$@"

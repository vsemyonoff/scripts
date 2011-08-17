#!/usr/bin/env bash

error_exit() {
    echo "error: ${1}, exiting..."
    exit 1
}

GLOBALCONF="/etc/makepkg.conf"
USERCONF="${HOME}/.makepkg.conf"

source "${GLOBALCONF}" || error_exit "can't read '${GLOBALCONF}'"
[ -r "${USERCONF}" ] && source "${USERCONF}"

[ -z "${PKGDEST}" ] && error_exit "'\$PKGDEST' undefined"
[ -z "${PKGREPO}" ] && error_exit "'\$PKGREPO' undefined"
[ ! -d "${PKGDEST}" ] && error_exit "'${PKGDEST}' not exists"

repo-add "${PKGDEST}/${PKGREPO}.db.tar.gz" "${PKGDEST}/"*.pkg.tar.xz

exit $?

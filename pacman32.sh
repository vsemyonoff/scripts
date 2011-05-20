#!/usr/bin/env bash

####
#
# Privileges test
#
if [ ${UID} -ne 0 ]; then
    echo "Error: only root can use this script"
    exit 1
fi

####
#
# Exec pacman
#
ROOTDIR="/opt/arch32"
sed -e 's/x86_64/i686/g' /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist32
sed -e 's/mirrorlist/mirrorlist32/g' /etc/pacman.conf > /etc/pacman32.conf
exec pacman --arch i686 --root "${ROOTDIR}" \
            --cachedir "${ROOTDIR}/var/cache/pacman/pkg" \
            --config /etc/pacman32.conf "$@"

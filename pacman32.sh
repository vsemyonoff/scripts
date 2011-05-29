#!/usr/bin/env bash

####
#
# Exec pacman
#
ROOTDIR="/opt/arch32"
sed -e 's/x86_64/i686/g' /etc/pacman.d/mirrorlist 2>/dev/null > /dev/shm/mirrorlist32
sed -e 's@/etc/pacman.d/mirrorlist@/dev/shm/mirrorlist32@g' /etc/pacman.conf 2>/dev/null > /dev/shm/pacman32.conf
exec pacman --arch i686 --root "${ROOTDIR}" \
            --cachedir "${ROOTDIR}/var/cache/pacman/pkg" \
            --config /dev/shm/pacman32.conf "$@"

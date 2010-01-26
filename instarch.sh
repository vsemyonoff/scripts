#!/bin/sh

if [ "$UID" != "0" ]; then
    echo "Error: only root can use this script"
    exit 1
fi

ARCHLIVE="/mnt/archlive"

mkdir -p $ARCHLIVE/var/{cache/pacman/pkg,lib/pacman,lib/dbus}

pacman --root $ARCHLIVE                           \
       --cachedir $ARCHLIVE/var/cache/pacman/pkg  \
       --config /etc/pacman.conf -Sy $(cat arch.world)

tar xvf etc.tar.bz2 -C $ARCHLIVE

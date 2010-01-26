#!/bin/sh

if [ "$UID" != "0" ]; then
    echo "Error: only root can use this script"
    exit 1
fi

ARCH32="/opt/arch32"

sed -e 's/x86_64/i686/g' /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist32
sed -e 's@/etc/pacman.d/mirrorlist@/etc/pacman.d/mirrorlist32@g' /etc/pacman.conf > /etc/pacman32.conf
mkdir -p $ARCH32/var/{cache/pacman/pkg,lib/pacman,lib/dbus}

pacman --root $ARCH32                           \
       --cachedir $ARCH32/var/cache/pacman/pkg  \
       --config /etc/pacman32.conf -Sy filesystem \
                                       grep       \
                                       gawk       \
                                       sed        \
                                       procps     \
                                       bash       \
                                       coreutils  \
                                       gzip

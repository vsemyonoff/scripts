#!/bin/sh

if [ "$UID" != "0" ]; then
    echo "Error: only root can use this script"
    exit 1
fi    

ARCH32="/opt/arch32"

mkdir -p $ARCH32/etc/pacman.d
sed -e 's/x86_64/i686/g' /etc/pacman.d/mirrorlist > /tmp/mirrorlist
sed -e 's@/etc/pacman.d/mirrorlist@/tmp/mirrorlist@g' /etc/pacman.conf > /tmp/pacman.conf
mkdir -p $ARCH32/var/{cache/pacman/pkg,lib/pacman,lib/dbus}

pacman --root $ARCH32                           \
       --cachedir $ARCH32/var/cache/pacman/pkg  \
       --config /tmp/pacman.conf -Sy filesystem \
                                     grep       \
                                     gawk       \
                                     sed        \
                                     pacman     \
                                     procps     \
                                     bash       \
                                     coreutils  \
                                     gzip

rm -f $ARCH32/etc/pacman.d/mirrorlist
mv /tmp/mirrorlist $ARCH32/etc/pacman.d
rm -f /tmp/pacman.conf

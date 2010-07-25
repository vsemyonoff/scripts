#!/usr/bin/env bash

[ -z $1 ] && echo "usage: $0 stage3" && exit 1

GEN="/mnt/gentoo"

tar xvjpf "$1" -C ${GEN} && \
tar xvjf portage-latest.tar.bz2 -C ${GEN}/usr && \
mount -t proc none ${GEN}/proc && \
mount -t sysfs none ${GEN}/sys && \
mount -o bind /dev ${GEN}/dev && \
tar xvf etc.tar.bz2 -C ${GEN} && \
cp -L /etc/resolv.conf ${GEN}/etc && \
cp ./update.sh ${GEN}/root && \
chroot ${GEN} /root/update.sh

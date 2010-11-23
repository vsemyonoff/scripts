#!/usr/bin/env bash

[ ${UID} != 0 ] && echo "Use this script as root!!!" && exit 1
[ -z "$1" ] && echo "usage: $0 [--update] stage3_name" && exit 1
[ $# == 2 ] && STAGE="$2" || STAGE="$1"
PORTAGE="portage-latest.tar.bz2"
BACKUP="backup.tar.bz2"
ROOT="/mnt/gentoo"

tar xvjpf ${STAGE} -C ${ROOT} || exit 1

if [ -f ${PORTAGE} ]; then
    tar xvjf ${PORTAGE} -C ${ROOT}/usr || exit 1
fi

if [ -f ${BACKUP} ]; then
    tar xvf ${BACKUP} -C ${ROOT} || exit 1
fi

if [ "$1" == "--update" ]; then
    mount -t proc none ${ROOT}/proc && \
    mount -t sysfs none ${ROOT}/sys && \
    mount -o bind /dev ${ROOT}/dev || exit 1

    cp -L /etc/resolv.conf ${ROOT}/etc && \
    cp ./update.sh ${ROOT}/root && \
    chroot ${ROOT} /root/update.sh --toolchain

    umount ${ROOT}/dev
    umount ${ROOT}/sys
    umount ${ROOT}/proc
fi

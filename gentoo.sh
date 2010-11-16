#!/usr/bin/env bash

[ ${UID} != 0 ] && echo "Use this script as root!!!" && exit 1
START="/root/gstart.sh"
ROOT="/mnt/gentoo"

mount -t proc none ${ROOT}/proc && \
mount -t sysfs none ${ROOT}/sys && \
mount -o bind /dev ${ROOT}/dev || exit 1

cp -L /etc/resolv.conf ${ROOT}/etc
cat > ${ROOT}${START} << EOF
env-update
source /etc/profile
bash
EOF
chmod a+x ${ROOT}${START}
chroot ${ROOT} ${START}

umount ${ROOT}/dev
umount ${ROOT}/sys
umount ${ROOT}/proc

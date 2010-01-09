#!/usr/bin/env bash

GEN="/mnt/gentoo"

#rm -fr ${GEN} && \
#mkdir ${GEN} && \
tar xvjpf stage3-amd64-20091231.tar.bz2 -C ${GEN} && \
tar xvjf portage-latest.tar.bz2 -C ${GEN}/usr && \
mount -t proc none ${GEN}/proc && \
mount -t sysfs none ${GEN}/sys && \
mount -o bind /dev ${GEN}/dev && \
tar xvf etc.tar.bz2 -C ${GEN} && \
cp -L /etc/resolv.conf ${GEN}/etc && \
cp ./update.sh ${GEN}/root && \
chroot ${GEN} /root/update.sh

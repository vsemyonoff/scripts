#!/usr/bin/env bash

env-update && \
source /etc/profile && \

locale-gen && \
emerge --sync && \
emerge portage && \
emerge linux-headers glibc binutils gcc-config gcc && \
binutils-config $(binutils-config -l | wc -l) && \
gcc-config $(gcc-config -l | wc -l) && \
source /etc/profile && \
emerge -b glibc binutils gcc && \
echo "Toolchain update complete." > upd-"`date +%Y%m%d`".log

[ $? == 0 ] && \
emerge -bke system && \
emerge -bke world && \
emerge --depclean && \
echo "World update complete." >> upd-"`date +%Y%m%d`".log

[ $? == 0 ] && \
echo "Update complete. Use 'dispatch-conf' to update configs." >> upd-"`date +%Y%m%d`".log

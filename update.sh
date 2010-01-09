#!/usr/bin/env bash

env-update && \
source /etc/profile && \

locale-gen && \
emerge --sync && \
emerge portage gentoo-sources && \
emerge linux-headers glibc binutils gcc-config gcc && \
gcc-config $(gcc-config -l | wc -l) && \
source /etc/profile && \
emerge -b glibc binutils gcc portage gentoolkit && \
echo "Toolchain update complete." > upd-"`date +%Y%m%d`".log

emerge -bke system && \
emerge -bke world && \
emerge --depclean && \
revdep-rebuild && \
echo "World update complete." >> upd-"`date +%Y%m%d`".log

echo "Now execute 'dispatch-conf'..." >> upd-"`date +%Y%m%d`".log

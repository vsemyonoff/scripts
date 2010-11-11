#!/usr/bin/env bash

env-update && \
source /etc/profile

# Change default profile
eselect profile set "default/linux/amd64/10.0/no-multilib"

# Override emerge options from make.conf
export EMERGE_DEFAULT_OPTS=""

# Mask 2.6.36 kernel
mkdir -p /etc/portage/package.mask
echo ">=sys-kernel/gentoo-sources-2.6.36" >> /etc/portage/package.mask/gentoo-sources
echo ">=sys-kernel/linux-headers-2.6.36" >> /etc/portage/package.mask/linux-headers

# Use latest 2.6.35 kernel
mkdir -p /etc/portage/package.keywords
echo "sys-kernel/gentoo-sources           ~amd64" >> /etc/portage/package.keywords/gentoo-sources
echo "sys-kernel/linux-headers            ~amd64" >> /etc/portage/package.keywords/linux-headers

locale-gen && \
emerge --sync && \
emerge --oneshot portage && \
emerge --oneshot linux-headers glibc binutils gcc-config gcc && \
binutils-config $(binutils-config -l | wc -l) && \
gcc-config $(gcc-config -l | wc -l) && \
source /etc/profile && \
emerge --oneshot -b glibc binutils gcc && \
echo "Toolchain update complete." > upd-"`date +%Y%m%d`".log || exit 1

[ $? == 0 ] && \
emerge -bke system && \
emerge -bke world && \
emerge --depclean && \
echo "World update complete." >> upd-"`date +%Y%m%d`".log || exit 1

echo "Update complete. Use 'dispatch-conf' to update configs." >> upd-"`date +%Y%m%d`".log

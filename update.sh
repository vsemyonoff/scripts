#!/usr/bin/env bash

# Update environment variables
source /etc/profile && env-update

# Change default profile
#eselect profile set "default/linux/amd64/10.0/no-multilib"

# Override default emerge options from make.conf
export EMERGE_DEFAULT_OPTS=""

locale-gen

if [ "$1" == "--toolchain" ]; then
    emerge --oneshot portage && \
    emerge --oneshot linux-headers glibc binutils gcc-config gcc && \
    binutils-config $(binutils-config -l | wc -l) && \
    gcc-config $(gcc-config -l | wc -l) && \
    source /etc/profile && \
    emerge --oneshot -b glibc binutils gcc || exit 1
    echo "Toolchain update complete." > "${HOME}/update.log"
fi

emerge -bke system && emerge -bke world || exit 1
echo "World update complete." >> "${HOME}/update.log"

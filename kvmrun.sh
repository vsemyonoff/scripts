#!/usr/bin/env bash

IMAGEDIR="/mnt/share/images/kvmimages"
IMAGENAME="$(basename ${0})"
IMAGE="${IMAGEDIR}/${IMAGENAME}.img"

[ "${IMAGENAME}" == "kvmrun.sh" ] && echo "error: create image named symlink for this script to use it, exiting..." && exit 1

if [ ! -r "${IMAGE}" ]; then
    if [ ! -z "${1}" ]; then
        qemu-img create -f qcow2 "${IMAGE}" 5G
    else
        echo "error: image named '${IMAGENAME}' not exists, exiting..." && exit 1
    fi
fi

[ ! -z "${1}" ] && CDIMAGE="-cdrom ${1}"

XCOMPMGR_PID=$(pgrep -U ${UID} "xcompmgr")
[ ! -z "${XCOMPMGR_PID}" ] && kill -9  ${XCOMPMGR_PID}

exec qemu-kvm -full-screen -alt-grab -enable-kvm -drive file="${IMAGE}",if=virtio,boot=on -net nic,model=virtio,vlan=1 -net user,vlan=1 -m 1024 -vga std ${CDIMAGE}

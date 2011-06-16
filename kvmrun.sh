#!/usr/bin/env bash

#============= Settings section ================================

IMAGESDIR="/mnt/share/images/kvmimages"
IMAGENAME="$(basename ${0})"
IMAGEFULL="${IMAGESDIR}/${IMAGENAME}.img"
CPUMODEL="core2duo" # use 'qemu[-kvm] -cpu ?' for details
SNDMODEL="hda"      # use 'qemu[-kvm] -soundhw ?' for details
CPUSCOUNT=1
CORESCOUNT=1
THREADSCOUNT=1
RAMSIZE=2048
VGAMODE="std"

#============= End of settings section =========================

# Validate symlink name
[ "${IMAGENAME}" == "kvmrun.sh" ] && echo "error: create image named symlink for this script to use it, exiting..." && exit 1

# To be sure that images dir exists
mkdir -p "${IMAGESDIR}" || exit 1

# Validate virtual image existance
if [ ! -r "${IMAGEFULL}" ]; then
    if [ ! -z "${1}" ]; then
        echo -n "Enter virtual image size (gigabytes, default: 5): " && read IMAGESIZE
        qemu-img create -f qcow2 "${IMAGEFULL}" ${IMAGESIZE:-5}G || exit 1
    else
        echo "error: image named '${IMAGENAME}' not exists, exiting..." && exit 1
    fi
fi

# Drive C
DRIVE_C="-drive file=\"${IMAGEFULL}\",if=virtio,boot=on"

# Drives A, D and E (use premounted folder, cdrom ".iso" and floppy ".vfd")
for i in $(seq 1 3); do
    ARG=$(eval echo \${${i}})
    [ -z "${ARG}" ] && break
    if [ -f "${ARG}" ]; then
        [[ "${ARG}" =~ (.*)\.vfd$ ]] && [ -z "${DRIVE_A}" ] && DRIVE_A="-fda \"${ARG}\""
        [[ "${ARG}" =~ (.*)\.iso$ ]] && [ -z "${DRIVE_D}" ] && DRIVE_D="-cdrom \"${ARG}\""
    fi
    [ -d "${ARG}" ] && [ -z "${DRIVE_E}" ] && DRIVE_E="-hdd fat:\"${ARG}\""
    unset ARG
done

# Full QEMU command
QEMUCMD="qemu-kvm -full-screen -enable-kvm \
    -cpu ${CPUMODEL} -smp ${CPUSCOUNT},cores=${CORESCOUNT},threads=${THREADSCOUNT} \
    ${DRIVE_A} ${DRIVE_C} ${DRIVE_D} ${DRIVE_E} -boot order=cda \
    -soundhw ${SNDMODEL} \
    -net nic,model=virtio,vlan=1 \
    -net user,vlan=1 \
    -m ${RAMSIZE} -vga ${VGAMODE}"

# Shutdown 'xcompmgr'
XCOMPMGR_PID=$(pgrep -U ${UID} "xcompmgr")
[ ! -z "${XCOMPMGR_PID}" ] && kill -9  ${XCOMPMGR_PID}
unset XCOMPMGR_PID

# Exec QEMU
echo ${QEMUCMD}
exec $(eval echo "${QEMUCMD}")

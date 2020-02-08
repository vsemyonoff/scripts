#!/usr/bin/env bash

MODULES="nvidia_drm nvidia_uvm nvidia_modeset nvidia"
CFG="/etc/modprobe.d/disable-nvidia"
GPU="0000:01:00.0"
BUS="0000:00:01.0"

echo "Disabling nVidia GPU..."

systemctl stop bumblebeed 2>/dev/null

modprobe -r ${MODULES} 2>/dev/null

echo -n 1 > "/sys/bus/pci/devices/${GPU}/remove" 2> /dev/null; sleep 1
echo -n auto > "/sys/bus/pci/devices/${BUS}/power/control"; sleep 1

[ -r "${CFG}" ] && mv "${CFG}" "${CFG}.conf"

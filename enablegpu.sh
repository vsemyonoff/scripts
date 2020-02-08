#!/usr/bin/env bash

CFG="/etc/modprobe.d/disable-nvidia"
GPU="0000:01:00.0"
BUS="0000:00:01.0"

echo "Enabling nVidia GPU..."

[ -r "${CFG}.conf" ] && mv "${CFG}.conf" "${CFG}"

echo -n on > "/sys/bus/pci/devices/${BUS}/power/control"; sleep 1
echo -n 1 > "/sys/bus/pci/rescan"; sleep 1

systemctl start bumblebeed

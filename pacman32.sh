#!/bin/sh

exec pacman --root /opt/arch32 --cachedir /opt/arch32/var/cache/pacman/pkg --config /etc/pacman32.conf "$@"

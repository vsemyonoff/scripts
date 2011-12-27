#!/usr/bin/env bash

[ $# -lt 1 ] && echo "usage: $0 server_name_or_ip [path_on_server [where_to_mount]]" && exit 1

MNTROOT="${3:-${HOME}/mnt}"
MNT="${MNTROOT}/$1"
TGT="${2:-/}"
ARG="reconnect,transform_symlinks,allow_other,volname=${TGT} (on $1)"

mkdir -p ${MNT} && sshfs -C -o "${ARG}" "$1:${TGT}" "${MNT}" || exit 1

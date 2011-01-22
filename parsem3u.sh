#!/usr/bin/env bash

#
#  File: parsem3u.sh
#  Description:
#
#  Creation date: 2011.01.22 01:51:51
#  Last modified: 2011.01.22 16:05:42
#
#  Copyright © 2010 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

OUTDIR="/mnt/share/video/IPTV"
PLAYLIST="${OUTDIR}/.playlist.m3u"
NAME=$(basename "${0}")

echo $NAME

case "${NAME}" in
    parsem3u*)
        [ -z "${1}" ] && echo "Playlist not specified" && exit 1
        [ ! -f "${1}" ] && echo "Playlist not found: ${1}" && exit 1
        mkdir -p "${OUTDIR}" || exit 1
        cp -f "${1}" "${PLAYLIST}"
        grep -o -P "(?<=EXTINF:0,).*$" "${PLAYLIST}" |
        while read i
        do
            if echo "$i" | grep "\(Мультимедиа\)" &>/dev/null ; then
                continue
            fi
            ln -sf "${NAME}" "${OUTDIR}/${i}"
        done
        ;;

    *)
        [ ! -f "${PLAYLIST}" ] && echo "Playlist not found: ${PLAYLIST}" && exit 1
        mplayer $(grep -A1 -E "EXTINF:0,${NAME}" "${PLAYLIST}" | tail -n 1)
        ;;
esac

# End of script

#!/usr/bin/env bash

#
#  File: parsem3u.sh
#  Description:
#
#  Creation date: 2011.01.22 01:51:51
#  Last modified: 2011.01.27 12:30:36
#
#  Copyright © 2010 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

OUTDIR="/mnt/share/video/IPTV"
PLAYLIST="${OUTDIR}/.playlist.m3u"
PROGNAME=$(readlink -m "${0}")

case "$(basename ${0})" in
    parsem3u*)
        [ -z "${1}" ] && echo "Playlist not specified" && exit 1
        [ ! -f "${1}" ] && echo "Playlist not found: ${1}" && exit 1
        rm -fr "${OUTDIR}" || exit 1
        mkdir "${OUTDIR}" || exit 1
        cp -f "${1}" "${PLAYLIST}"
        grep -o -P "(?<=EXTINF:0,).*(?=$)" "${PLAYLIST}" |
        while read i
        do
            if echo "$i" | grep "\(Мультимедиа\)" &>/dev/null ; then
                continue
            fi
            CHANNEL=$(echo "${i}" | sed -e 's/\//\\/g' | sed -e 's/\ /_/g' | tr -d '\015')
            ln -sf "${PROGNAME}" "${OUTDIR}/${CHANNEL}"
        done
        ;;

    *)
        [ ! -f "${PLAYLIST}" ] && echo "Playlist not found: ${PLAYLIST}" && exit 1
        CHANNEL=$(echo `basename ${0}` | sed -e 's/\\/\//g' | sed -e 's/_/\ /g' | sed 's/+/\\+/g')
        exec urxvtc -e mplayer $(grep -A1 -E "EXTINF:0,${CHANNEL}" "${PLAYLIST}" | tail -n 1)
        ;;
esac

# End of script

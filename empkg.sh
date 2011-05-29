#!/usr/bin/env bash

#
#  File: empkg.sh
#  Description: wget git
#
#  Creation date: 2011.02.16 17:01:53
#  Last modified: 2011.04.03 10:56:12
#
#  Copyright © 2011 Vladyslav Semyonoff <vsemyonoff@gmail.com>
#

download_package() {
    # ${1} - output file name
    # ${2} - package file URL
    if [ -z "${1}" ]; then
        echo "Warning: package name not specified, skipping..."
        return 1
    fi
    if [ -z "${2}" ]; then
        echo "Warning: package '${1}' URL is empty, skipping..."
        return 1
    fi
    wget -q -O "${1}" "${2}" || exit 1
}

git_packages() {
    for pkg in "${GIT_PACKAGES[@]}"; do
        local name=$(eval echo \${${pkg}[0]})
        local url=$(eval echo \${${pkg}[1]})
        echo "Processing package: '${name}'"
        if [ -z "${url}" ]; then
            echo "Warning: URL for '${name}' packages is empty, skipping..."
            continue
        fi
        if [ -d "${name}" ]; then
            ( cd "${name}" && git pull >/dev/null 2>&1 || exit 1 )
        else
            git clone "${url}" "${name}" >/dev/null 2>&1 || exit 1
        fi
    done
}

tar_packages() {
    for pkg in "${TAR_PACKAGES[@]}"; do
        local name=$(eval echo \${${pkg}[0]})
        local url=$(eval echo \${${pkg}[1]})
        echo "Processing package: '${name}'"
        [ -d "${name}" ] && echo "Package '${name}' already installed, skipping..." && continue
        download_package "${name}.pkg" "${url}" || continue
        local untar_cmd="tar xf \"${name}.pkg\" -C \"${name}\""
        local topdir=$(tar tf "${name}.pkg" | head -1)
        [[ "${topdir}" =~ ^.*/$ ]] && untar_cmd="${untar_cmd} --strip-components=1"
        mkdir -p "${name}"
        eval "${untar_cmd} >/dev/null" || exit 1
        rm -f "${name}.pkg"
    done
}

raw_packages() {
    for pkg in "${RAW_PACKAGES[@]}"; do
        local name=$(eval echo \${${pkg}[0]})
        local url=$(eval echo \${${pkg}[1]})
        echo "Processing package: '${name}'"
        [ -f "${name}.el" ] && echo "Package '${name}' already installed, skipping..." && continue
        download_package "${name}.el" "${url}" || continue
    done
}

# Read packages list
CONFIG="packages.cfg"
if [ -r "${CONFIG}" ]; then
    . "${CONFIG}"
else
    echo "Error: config file '${CONFIG}' not exists or unreadable, exiting..."
    exit 1
fi

# Prepare output dir
PACKAGES_DIR="${HOME}/.emacs.d/packages"
mkdir -p "${PACKAGES_DIR}"
cd "${PACKAGES_DIR}"

# Process packages
git_packages
tar_packages
raw_packages

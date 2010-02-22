#!/bin/sh

####
#
# Setup defaults
#
PRGNAME="$0"
ROOTDIR="/opt/arch32"
TARGETARCH="i686"
GRUBINST="false"
CURRARCH=$(uname -m)

function usage() {
    cat << EOF
usage: $(basename $PRGNAME) [--arch i686|x86_64] [--backup FILE] [--root DEVICE|PATH]
    --arch   - target architecture (i686)
    --backup - archive with settings (none)
    --grub   - install bootloader (disabled)
    --help   - show this message
    --root   - installation root block device or premounted folder (/opt/arch32)
EOF
}

####
#
# Parse args
#
if [ $# -ge 1 ]; then
    while true; do
        case $1 in
            --arch)
                shift
                case $1 in
                    x86)
                        TARGETARCH="i686"
                        ;;
                    x86_64)
                        case $CURRARCH in
                            i?86)
                                echo "Error: x86_64 installation from i686 is currently not supported"
                                exit 1
                                ;;
                            x86_64)
                                TARGETARCH="x86_64"
                                ;;
                            *)
                                echo "Error: unsupported architecture '$CURRARCH'"
                                ;;
                        esac
                        ;;
                    *)
                        echo "Error: unsupported target architecture '$1'"
                        usage
                        exit 1
                        ;;
                esac
                ;;
            --backup)
                shift
                if [ -z "$1" ]; then
                    echo "Error: backup archive not specified"
                    usage
                    exit 1
                fi
                BACKUP="$1"
                ;;
            --grub)
                GRUBINST="true"
                ;;
            --help)
                usage
                exit 0
                ;;
            --root)
                shift
                if [ -z "$1" ]; then
                    echo "Error: installation root not specified"
                    usage
                    exit 1
                fi
                if [ -b "$1" ]; then
                    ROOTPAR="$1"
                    ROOTNUM=$(echo "$ROOTPAR" | sed -r 's/(.*)([1-100])/\2/g')
                    if [ -z "$ROOTNUM" ]; then
                        echo "Error: expected disk partition, not entry disk '$1'"
                        usage
                        exit 1
                    fi
                    ROOTDIR=$(grep -m 1 "$ROOTPAR" /proc/mounts | cut -f 2 -d " ")
                    if [ -z "$ROOTDIR" ]; then
                        _TMP_="yes"
                    fi
                else
                    mkdir -p "$ROOTDIR" || exit 1
                    ROOTDIR="$1"
                    ROOTPAR=$(grep -m 1 "$ROOTDIR" /proc/mounts | cut -f 1 -d " ")
                fi
                ;;
            *)
                if [ $# -eq 0 ]; then
                    break
                else
                    echo "Error: unknown option '$1'"
                    usage
                    exit 1
                fi
                ;;
        esac
        shift
    done
fi


####
#
# User test
#
if [ "$UID" != "0" ]; then
    echo "Error: only root can use this script"
    exit 1
fi


####
#
# Preinstall
#
if [ "$_TMP_" == "yes" ]; then
    ROOTDIR=$(mktemp -d)
    mount "$ROOTPAR" "$ROOTDIR" || exit 1
fi
mkdir -p "$ROOTDIR/etc/pacman.d" || exit 1
mkdir -p "$ROOTDIR"/var/{cache/pacman/pkg,lib/pacman} || exit 1
# Prepare mirror list
echo -ne "Target architecture: "
case "$TARGETARCH" in
    i?86)
        echo "'i686'"
        sed -e 's/x86_64/i686/g' /etc/pacman.d/mirrorlist > /tmp/mirrorlist
        ;;
    x86_64)
        echo "'x86_64'"
        sed -e 's/i686/x86_64/g' /etc/pacman.d/mirrorlist > /tmp/mirrorlist
        ;;
esac
sed -e 's@/etc/pacman.d/mirrorlist@/tmp/mirrorlist@g' /etc/pacman.conf > /tmp/pacman.conf
# Mount filesystems
mkdir -p "$ROOTDIR/dev" && mount -obind /dev "$ROOTDIR/dev" || exit 1
mkdir -p "$ROOTDIR/sys" && mount -obind /sys "$ROOTDIR/sys" || exit 1
mkdir -p "$ROOTDIR/proc" && mount -obind /proc "$ROOTDIR/proc" || exit 1


####
#
# Install
#
if [ -z "$ROOTPAR" ]; then
    echo "Chroot environment installation to: '$ROOTDIR'"
else
    echo "Installation root device: '$ROOTPAR' mounted to '$ROOTDIR'"
fi
sleep 3
pacman --noconfirm --root "$ROOTDIR"              \
       --cachedir "$ROOTDIR/var/cache/pacman/pkg" \
       --config /tmp/pacman.conf -Sy base || exit 1


####
#
# Postinstall
#
sed -ri 's/^HOOKS="(.*)"$/HOOKS="\1 usb"/g' "$ROOTDIR/etc/mkinitcpio.conf"
chroot "$ROOTDIR" mkinitcpio -p kernel26
[ "$?" != "0" ] && exit 1
umount "$ROOTDIR/dev" || exit 1
umount "$ROOTDIR/sys" || exit 1
umount "$ROOTDIR/proc" || exit 1
# Fix default devices
(
    cd "$ROOTDIR/dev" && \
    rm -f console &&  mknod -m 600 console c 5 1 && \
    rm -f null &&  mknod -m 666 null c 1 3 && \
    rm -f zero &&  mknod -m 666 zero c 1 5
)
mv -f /tmp/mirrorlist $ROOTDIR/etc/pacman.d
# Update configuration from backup
if [ ! -z "$BACKUP" ]; then
    tar xvf "$BACKUP" -C "$ROOTDIR"
fi
if [ ! -z "$ROOTPAR" ]; then
    # Setup fstab
    UUID=$(ls -la /dev/disk/by-uuid/* | grep $(basename $ROOTPAR) | sed -r 's/^(.*)uuid\/(.*) -> (.*)$/\2/g')
    cat << EOF > $ROOTDIR/etc/fstab
devpts                                    /dev/pts    devpts    defaults            0  0
shm                                       /dev/shm    tmpfs     nodev,nosuid        0  0
UUID=$UUID /           auto      defaults            0  1
EOF
    if [ "$GRUBINST" == "true" ]; then
        # Install GRUB
        ROOTDEV=$(echo $ROOTPAR | sed -r 's/(.*)([1-100])/\1/g')
        GROOTSTR="(hd0,$((ROOTNUM-1)))"
        cp -f $ROOTDIR/usr/lib/grub/i386-pc/* $ROOTDIR/boot/grub
        grub --batch --no-floppy --device-map=/dev/null << EOF
device (hd0) $ROOTDEV
root $GROOTSTR
setup (hd0)
quit
EOF
        cat << EOF > $ROOTDIR/boot/grub/menu.lst
timeout   3
default   0
color light-blue/black light-cyan/blue

title  Arch Linux Live
root   $GROOTSTR
kernel /boot/vmlinuz26 root=/dev/disk/by-uuid/$UUID quiet ro vga=791
initrd /boot/kernel26.img

title  Arch Linux Live (fallback)
root   $GROOTSTR
kernel /boot/vmlinuz26 root=/dev/disk/by-uuid/$UUID ro vga=normal single 3
initrd /boot/kernel26-fallback.img
EOF
    fi
fi


####
#
# Cleanup
#
if [ "$_TMP_" == "yes" ]; then
    umount "$ROOTPAR" || exit 1
    rm -r "$ROOTDIR"
fi
rm -f /tmp/pacman.conf

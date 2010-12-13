#!/sbin/runscript

#
#  File: emacsd.sh
#  Description: system service to stop all emacs daemons
#
#  Version: emacsd.sh, 2010/12/13 02:00:06 EET
#  Copyright © 2010 Vladyslav Semyonov <vsemyonoff@gmail.com>
#

start() {
    ebegin "Starting Emacs daemon handler"
    eend ${?}
}

stop() {
    ebegin "Stopping Emacs daemon instances"
    exec find /tmp -maxdepth 1 -type d -name 'emacs*' -exec find {} -type s -name server \; | \
        perl -ne 's/[^\d]//g; print scalar getpwuid($_), "\n"' | \
        xargs -n 1 su -c /mnt/share/scripts/killemacs.sh -
    eend ${?}
}

# End of emacsd.sh

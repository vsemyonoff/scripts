#!/usr/bin/env bash

#
#  File: emacsd.sh
#  Description:
#
#  Version: emacsd.sh, 2010/08/26 12:38:37 EEST
#  Copyright © 2010 Vladyslav Semyonov <vsemyonoff@gmail.com>
#

. /etc/rc.conf
. /etc/rc.d/functions

case "$1" in
    start)
        add_daemon emacsd
        ;;
    stop)
        stat_busy "Stopping emacs daemon"
        exec find /tmp -maxdepth 1 -type d -name 'emacs*' -exec find {} -type s -name server \; | \
            perl -ne 's/[^\d]//g; print scalar getpwuid($_), "\n"' | \
            xargs -n 1 su -c /mnt/share/bin/killemacs -
        stat_done
        rm_daemon emacsd
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    *)
        echo "usage: $0 {start|stop|restart}"
esac

# End of emacsd.sh

#!/usr/bin/env bash

header() {
    cat << _HEADER
<openbox_pipe_menu>
 <separator label="Приложения" />
_HEADER
}

applications() {
    xdg_menu --format openbox3 --root-menu /etc/xdg/menus/arch-applications.menu 2>/dev/null \
        | sed -e 's/\(<menu id=".*" \(label=".*"\)>\)$/\1 <separator \2 \/>/g' | sed -e 's/xterm/urxvtc/g'
}

footer() {
    cat "${XDG_CONFIG_HOME}/openbox/menu-static.xml" 2>/dev/null
    cat << _FOOTER
</openbox_pipe_menu>
_FOOTER
}

header
applications
footer

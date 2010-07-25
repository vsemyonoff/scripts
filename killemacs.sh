#!/usr/bin/env bash

#
#  File: killemacs.sh
#  Description: Save all buffers and stop emacs daemon
#
#  Version: killemacs.sh, 2010/05/26 16:02:20 EEST
#  Copyright © 2010 Vladyslav Semyonov <vsemyonoff@gmail.com>
#

emacsclient --eval "(progn (setq kill-emacs-hook 'nil) (kill-emacs))"

# End of killemacs.sh

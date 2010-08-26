#!/usr/bin/env bash

#
#  File: killemacs.sh
#  Description: Save all buffers and stop emacs daemon
#
#  Version: killemacs.sh, 2010/08/26 12:11:15 EEST
#  Copyright © 2010 Vladyslav Semyonov <vsemyonoff@gmail.com>
#

emacsclient --eval "(progn (save-some-buffers t) (setq kill-emacs-hook 'nil) (kill-emacs))"

# End of killemacs.sh

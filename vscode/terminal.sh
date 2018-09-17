#!/bin/sh
SESSION="vscode`pwd | md5`"
#tmux set-environment TMUX_IN_VSCODE yes
tmux attach-session -d -t $SESSION || tmux new-session -s $SESSION

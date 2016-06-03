#!/usr/bin/env zsh
#
# Launch a bash process which calls the
# 'old' way of working with aliphysics, i.e. the Dario's alice-env.sh
#

MYPARAM="-m aliphysics=$1" bash --init-file $HOME/Scripts/bash_profile.old


#!/bin/bash

version=${1:-latest}

export WORK_DIR=$HOME/o2/o2work/sw

source $WORK_DIR/osx_x86-64/O2/$version/etc/profile.d/init.sh

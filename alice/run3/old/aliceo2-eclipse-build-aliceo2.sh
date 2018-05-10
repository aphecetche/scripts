#!/bin/bash

source $HOME/Scripts/o2-env.sh

cd $HOME/o2/alfa/AliceO2/build_o2

if [ $# -eq 2 ]; then
  cd $2  
fi

/usr/bin/make -j$MJ install 2>&1

exit ${PIPESTATUS[0]}

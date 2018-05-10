#!/bin/bash

source $HOME/Scripts/o2-env.sh

cd $HOME/o2/alfa/FairSoft/AliRoot/build_for_alfa/

if [ $# -eq 2 ]; then
  cd $2  
fi

/usr/bin/make -j$MJ install 2>&1

exit ${PIPESTATUS[0]}

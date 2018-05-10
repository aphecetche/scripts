#!/bin/bash

source $HOME/alicesw/alice-env.sh -m aliroot=$1

printenv

cd $HOME/alicesw/aliroot/$1/build

if [ $# -eq 2 ]; then
  cd $2  
fi

/usr/bin/make -j$MJ install 2>&1

exit ${PIPESTATUS[0]}

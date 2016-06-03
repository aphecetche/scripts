#!/bin/bash

source $HOME/Scripts/alice-env.sh $1

what=${ALICE_ROOT}

if [ $# -eq 2 ]; then
  what=${ALICE_ROOT}/$2
fi

cd $what

if [ -f Doxyfile ]; then
  /Users/laurent/Bin/doxygen 2>& 1
fi

exit ${PIPESTATUS[0]}










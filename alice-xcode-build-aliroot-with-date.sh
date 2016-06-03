#!/bin/bash

source $HOME/Scripts/alice-amore-env.sh $1

#source $HOME/Scripts/alice-env.sh $1

what=${ALICE_BUILD}

if [ $# -eq 2 ]; then
  what=${ALICE_BUILD}/$2
fi

cd $what

/usr/bin/make install -j 2 2>&1

exit ${PIPESTATUS[0]}










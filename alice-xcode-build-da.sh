#!/bin/bash

source $HOME/Scripts/alice-env.sh $1

cd ${ALICE_BUILD}

/usr/bin/make $2 2>&1

exit ${PIPESTATUS[0]}










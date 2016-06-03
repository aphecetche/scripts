#!/bin/bash

source $HOME/alicesw/alice-env.sh -m aliroot=master aliphysics=master

cd ${HOME}/aafu

/usr/bin/make 2>&1

exit ${PIPESTATUS[0]}










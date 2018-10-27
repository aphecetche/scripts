#!/bin/bash

printenv

source /cvmfs/alice.cern.ch/etc/login.sh

source $(which alienv) setenv VO_ALICE@AliPhysics::${3:-v5-09-39-01-1}

server=$1
path=$2

# check destination is not already there
if [[ $(xrdfs $server locate -r $path) ]]; then
  echo "File is already there"
else
  # stage it
  echo "Will stage the file"
  aaf-stage-and-filter --from alien://$path --to root://$server/$path
fi

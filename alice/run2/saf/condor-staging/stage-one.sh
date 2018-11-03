#!/bin/bash

cp -a *${UID}* /tmp/

source /cvmfs/alice.cern.ch/etc/login.sh

aliphysics=${4:-v5-09-39-01-1}

source $(which alienv) setenv VO_ALICE@AliPhysics::${aliphysics}

server=$1
filepath=$2
filter=${3:-NONE}

filename=$filepath

if [[ "$filter" != "NONE" ]]; then
  filename=${filepath/.root}
  filename="${filename}.FILTER_${filter}_WITH_ALIPHYSICS_${aliphysics}.root"
fi

# check destination is already there
xrdfs $server locate -r $filename > /dev/null 2>&1
alreadyThere=$?

if [[ $alreadyThere -eq 0 ]]; then
  echo "File $filename is already there. Not doing it again."
  exit 1
else
  alien-token-init laphecet

  if [[ "$filter" == "NONE" ]]; then
    echo "Will stage the file without any filter"
    aaf-stage-and-filter --from alien://$filepath --to root://$server/$filename
    exit $?
  else
    echo "Will stage the file with filter $filter"
    aaf-stage-and-filter --from alien://$filepath --to root://$server/$filename --filter $filter
    exit $?
  fi
fi

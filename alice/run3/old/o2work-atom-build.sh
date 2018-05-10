#!/bin/bash

# run cmake for a given configuration
# examples :
#
# ./o2work-atom-build.sh [BuildType] [What] ([version]) ([subdir])
#
# /o2work-atom-build.sh Debug O2
# to build O2 in Debug mode
#
# ./o2work-atom-build.sh RelWithDebInfo AliRoot latest HLT
# to build AliRoot/HLT in RelWithDebInfo, version = latest
#

TopDir=$HOME/o2/o2work/sw

BuildType=${1:-Debug}

What=${2:-O2}

Version=${3:-latest}

SubDir=${4:-}

BuildDir=$TopDir/BUILD/$What-$Version/$What

cd $BuildDir/$4

echo "Current directory is $PWD"

nproc=$(getconf _NPROCESSORS_ONLN)
nproc=$((++nproc))
make -j$nproc install 2>&1

exit ${PIPESTATUS[0]}

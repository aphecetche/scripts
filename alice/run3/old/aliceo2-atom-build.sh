#!/bin/bash

# run cmake for a given configuration
# examples :
#
# ./aliceo2-atom-build.sh Debug AliceO2 cmake
# will call cmake in the Debug subdirectory of the alfa (source) directory
#
# /aliceo2-atom-build.sh Debug AliceO2 make
# will call make in the Debug subdirectory of the alfa (source) directory
#
# ./aliceo2-atom-build.sh Debug FairSoft/AliRoot make HLT
# will call make in the Debug/HLT subdirectory of the FairSoft/AliRoot source directory
#

Configuration=${1:-Debug}

What=${2:-AliceO2}

CmdToExecute=${3:-cmake}

SubDir=${4:-}

Extra_CMake_Options=""

InstallDir=$HOME/o2/alfa/inst

if [[ $What =~ AliRoot ]];
then
Extra_CMake_Options="-DROOTSYS=$InstallDir"
else
Extra_CMake_Options="-DUSE_DIFFERENT_COMPILER=TRUE"
fi

echo Configuration=$Configuration What=$What Cmd=$CmdToExecute Extra_CMake_Options=$Extra_CMake_Options

export PATH=$PATH:/usr/local/bin

source $HOME/Scripts/o2-env.sh

mkdir -p $HOME/o2/alfa/$What/$Configuration

cd $HOME/o2/alfa/$What/$Configuration/$SubDir

echo "Current directory is $PWD"

if [[ "$CmdToExecute" == "cmake" ]]; then
  /Applications/CMake.app/Contents/bin/cmake -G "Unix Makefiles" ../ -DCMAKE_BUILD_TYPE:STRING=$Configuration -DCMAKE_INSTALL_PREFIX=$InstallDir  $Extra_CMake_Options
  exit ${PIPESTATUS[0]}
elif [[ "$CmdToExecute" =~ "make" ]]; then
  nproc=$(getconf _NPROCESSORS_ONLN)
  nproc=$((++nproc))
  make -j$nproc install 2>&1
  exit ${PIPESTATUS[0]}
else
  echo "Unknown command $CmdToExecute"
  exit 1
fi

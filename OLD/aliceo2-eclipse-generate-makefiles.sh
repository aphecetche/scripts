#!/bin/bash

# Generate Makefiles for Eclipse for a given configuration (e.g. Debug, Release)

Configuration=${1:-Debug}

What=${2:-AliceO2}


Extra_CMake_Options=""

InstallDir=$HOME/o2/alfa/inst

if [[ $What =~ AliRoot ]]; 
then
Extra_CMake_Options="-DROOTSYS=$InstallDir"
fi

echo Configuration=$Configuration What=$What Extra_CMake_Options=$Extra_CMake_Options

export PATH=$PATH:/usr/local/bin

source $HOME/Scripts/o2-env.sh

mkdir -p $HOME/o2/alfa/$What/$Configuration

cd $HOME/o2/alfa/$What/$Configuration

/Applications/CMake.app/Contents/bin/cmake -G "Unix Makefiles" ../ -DCMAKE_BUILD_TYPE:STRING=$Configuration -DUSE_DIFFERENT_COMPILER=TRUE -DCMAKE_INSTALL_PREFIX=$InstallDir  $Extra_CMake_Options

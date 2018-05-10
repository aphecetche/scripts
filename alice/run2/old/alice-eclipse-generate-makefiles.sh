#!/bin/bash

# Generate Makefiles for Eclipse for a given configuration (e.g. Debug, Release)

Configuration=${1:-Debug}

What=${2:-master}

source $HOME/alicesw/alice-env.sh -m aliroot=$What

echo Configuration=$Configuration What=$What Extra_CMake_Options=$Extra_CMake_Options

mkdir -p $ALICE_ROOT/../build

cd $ALICE_ROOT/../build

/Applications/CMake.app/Contents/bin/cmake -G "Unix Makefiles" ../ \
-DCMAKE_BUILD_TYPE:STRING=$Configuration \
$ALICE_ROOT/../src \
-DCMAKE_INSTALL_PREFIX=$ALICE_ROOT \
-DROOTSYS=$ROOTSYS -DALIEN=$ALIEN_DIR

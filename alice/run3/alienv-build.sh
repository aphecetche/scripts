#!/bin/sh

# what=${1:-O2}
#
# cd $HOME/alice/sw/BUILD/$what-latest/$what 
#
# alienv --work-dir $HOME/alice/sw setenv $what/latest,CMake/latest -c cmake --build . -- install

cd $ALIBUILD_WORK_DIR/BUILD/O2-latest/O2
ninja


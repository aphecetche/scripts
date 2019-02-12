#!/bin/sh

what=${1:-O2}

cd $HOME/alice/sw/BUILD/$what-latest/$what 

alienv --work-dir $HOME/alice/sw setenv $what/latest,CMake/latest -c cmake --build . -- install

#!/usr/bin/env sh

generator=Ninja
install=$HOME/alice/tests/sw
version=latest

case $OSTYPE in
linux*)
  g3lib=lib64
  ddlext=so
  platform=slc7_x86-64
  ;;
darwin*)
  g3lib=lib
  ddlext=dylib
  platform=osx_x86-64
  ;;
esac

export CXXFLAGS="-std=c++17" 
export ROOTSYS=$install/$platform/ROOT/$version 
export BOOST_ROOT=$install/$platform/boost/$version 
export GEANT4_ROOT=$install/$platform/GEANT4/$version
export GEANT4_VMC_ROOT=$install/$platform/GEANT4_VMC/$version
export G4INSTALL=${GEANT4_ROOT}
export G4INSTALL_DATA=${GEANT4_ROOT}/share
export FairMQ_ROOT=$install/$platform/FairMQ/$version
export LD_LIBRARY_PATH=${G4VMCINSTALL}/lib
export FairLogger_ROOT=$install/$platform/FairLogger/$version

cmd=$(
  cat <<EOF
cmake \
  -S /Users/laurent/alice/tests/standalone/FairRoot/src \
  -B /Users/laurent/alice/tests/standalone/FairRoot/build \
  -G ${generator} \
  -DCMAKE_BUILD_TYPE=Debug \
  -DBOOST_ROOT=${BOOST_ROOT} \
  -DBOOST_INCLUDEDIR=${BOOST_ROOT}/include \
  -DBOOST_LIBRARYDIR=${BOOST_ROOT}/lib \

#   -DCMAKE_FIND_DEBUG_MODE=ON
EOF
)

echo "--- cmd="
echo $cmd
echo "--------"

eval "$cmd"

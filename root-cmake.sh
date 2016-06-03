#!/bin/sh

export ALIEN_ROOT=/Users/laurent/alicesw/alien/

export PATH=${ALIEN_ROOT}/bin:$PATH
export LD_LIBRARY_PATH=${ALIEN_ROOT}/api/lib:$LD_LIBRARY_PATH

cmake -DCMAKE_INSTALL_PREFIX=$ALICE_PREFIX/root/$ROOT_SUBDIR/inst \
-DCMAKE_F_COMPILER=gfortran \
-Dminuit2=ON \
-Dalien=ON \
-Dxrootd=ON \
-Dgsl_shared=OFF \
-Dpythia6=ON \
-Dldap=ON \
-DALIEN_INCLUDE_DIR=$ALIEN_ROOT/api/include/ \
-DALIEN_LIBRARY=$ALIEN_ROOT/api/lib/libgapiUI.so \
-DXROOTD_INCLUDE_DIR=$ALIEN_ROOT/api/include/xrootd/ \
-DXROOTD_XrdClient_LIBRARY=$ALIEN_ROOT/api/lib/libXrdClient.dylib \
-DXROOTD_XrdMain_LIBRARY=$ALIEN_ROOT/api/lib/libXrdMain.dylib \
-DXROOTD_XrdUtils_LIBRARY=$ALIEN_ROOT/api/lib/libXrdUtils.dylib \
-DPYTHIA6_LIBRARY=/opt/pythia6/libPythia6.so \
-DPYTHIA6_INCLUDE_DIR=/opt/pythia6 \
$ALICE_PREFIX/root/$ROOT_SUBDIR/src

#-Dpythia6_nolink=ON \


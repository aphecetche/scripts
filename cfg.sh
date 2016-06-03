#!/bin/sh

# after config you must use :
# make CPATH=/usr/X11/include

[[ ${GSHELL_ROOT}+set = set ]] || GSHELL_ROOT=${HOME}/alicesw/alien/api

./configure \
  --with-pythia6-uscore=SINGLE \
  --with-alien-incdir=${GSHELL_ROOT}/include \
  --with-alien-libdir=${GSHELL_ROOT}/lib \
  --with-monalisa-libdir="${GSHELL_ROOT}/lib" \
  --with-monalisa-incdir="${GSHELL_ROOT}/include" \
  --with-xrootd=${GSHELL_ROOT} \
  --with-clang \
  --enable-minuit2 \
  --enable-roofit \
  --enable-soversion  \
  --enable-builtin-freetype \
  --disable-fink \
  --fail-on-missing \
  --enable-cocoa \
  --prefix=$ROOT_INSTALL \
  --etcdir=$ROOT_INSTALL/etc/root
  
#  --disable-fink

#  --with-x11-libdir=/opt/X11/lib \
#  --with-xpm-libdir=/opt/X11/lib \
#  --with-xft-libdir=/opt/X11/lib \
#  --with-xext-libdir=/opt/X11/lib \
  
#./configure \
#  --with-f77=/usr/local/bin/gfortran \
#  --with-pythia6-uscore=SINGLE \
#  --enable-minuit2 \
#  --with-alien-incdir=${GSHELL_ROOT}/include \
#  --with-alien-libdir=${GSHELL_ROOT}/lib \
#  --with-monalisa-libdir=${GSHELL_ROOT}/lib \
#  --with-monalisa-incdir=${GSHELL_ROOT}/include \
#  --with-xrootd-incdir=${GSHELL_ROOT}/include/xrootd \
#  --with-xrootd-libdir=${GSHELL_ROOT}/lib \
#  --enable-gsl-shared \
#  --disable-globus \
#  --build=debug \
#  --disable-roofit \
#  --enable-builtin-freetype \
#  --enable-builtin-pcre \
#  --enable-builtin-zlib \
#  --enable-soversion \
#  --disable-bonjour \
#  --with-clang
  
 # the last 3 ones are for "make static" for DAs
  
#    --disable-editline \

# version adapted from Dario, to be able to compile 5.33/02 ?

#./configure \
#  --with-f77=/opt/local/bin/gfortran-mp-4.6  \
#  --with-cc=/opt/local/bin/gcc-mp-4.6 \
#  --with-cxx=/opt/local/bin/g++-mp-4.6 \
#  --with-ld=/opt/local/bin/g++-mp-4.6 \
#  --with-pythia6-uscore=SINGLE \
#  --with-alien-incdir=${ALIEN_ROOT}/api/include \
#  --with-alien-libdir=${ALIEN_ROOT}/api/lib \
#  --with-monalisa-libdir=${ALIEN_ROOT}/api/lib \
#  --with-monalisa-incdir=${ALIEN_ROOT}/api/include \
#  --with-xrootd-libdir=${ALIEN_ROOT}/api \
#  --enable-minuit2 \
#  --enable-roofit \
#  --enable-soversion \
#  --disable-bonjour \
  
# local ConfigOpts="--with-pythia6-uscore=SINGLE \
#    --with-alien-incdir=$GSHELL_ROOT/include \
#    --with-alien-libdir=$GSHELL_ROOT/lib \
#    --with-monalisa-incdir="$GSHELL_ROOT/include" \
#    --with-monalisa-libdir="$GSHELL_ROOT/lib" \
#    --with-xrootd=$GSHELL_ROOT \
#    --enable-minuit2 \
#    --enable-roofit \
#    --enable-soversion \
#    --disable-bonjour"
#!/bin/env zsh
#
# set the development environment for Alice software
#

run=$1

what=${2:="AliRoot"}

whatlc=$what:l

version=${3:="feature-muonhlt"}

srcdir="$HOME/alicesw/$run/$whatlc-$version"
wd="$HOME/alicesw/$run/sw"

if [ ! -d "$srcdir/AliRoot" ]; then
  what="AliPhysics"
fi

if [ -d "$srcdir" ]; then
    alias ali-env="$HOME/alicesw/repos/alibuild/aliEnv --work-dir $wd "
    alias ali-use="ali-enter --shellrc"
    alias ali-build="cd $wd/BUILD/$what-latest-$version/$what"
    alias ali-enter="ali-env enter VO_ALICE@$what::latest-$whatlc-$version"
    alias ali-make="ali-build ; make -j9 install"
    alias ali-src="cd $srcdir/$what"
    cd $srcdir/$what 
    echo "$FG[red]Now in directory $(pwd)"
    echo "$FG[blue]Aliases ali-* have been redefined"
    alias | grep ali-
else
  echo "Unknown directory $srcdir" 
fi

unset wd
unset srcdir


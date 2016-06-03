#!/bin/bash

#
# duplicate an existing installation by linking to what can be linked,
# and copying what cannot be linked

#------------------------------------------

if [ $# -ne 2 ] 
then
    echo "Usage : $0 src_version_name dest_version_name"
    exit 0
fi

SCRIPTDIR=`dirname $0`

SRCDIR="$HOME/Alice/AliRoot/$1/aliroot"
DESTDIR="$HOME/Alice/AliRoot/$2/aliroot"

if [ ! -e "$SRCDIR" ]
then
  echo "Source dir $SRCDIR does not exist"
  exit 0
fi

if [ -e "$DESTDIR" ]
then
  echo "Destination dir $DESTDIR already exists !"
  exit 0
fi

mkdir -p "$DESTDIR"

# This is the list of packages to be copied to destination.
destinationPackages="ALIROOT MUON STEER"
# All the other packages will be linked from source directory.

source "$SCRIPTDIR"/alice-lock-directory.sh "$SRCDIR" 1

for file in "$SRCDIR"/*
do
    [[ $file =~ "xcode" ]] && continue
    [[ $file =~ "include" ]] && continue
    [[ $file =~ "lib" ]] && continue
    [[ $file =~ "bin" ]] && continue

		if [ -d "$file" ]
		then
			# this is a directory    
				copy=0
				package=`basename $file`
				for p in $destinationPackages
				do
					if [ "$package" == "$p" ]; then
						copy=1
					fi
				done
				if [ "$copy" -eq 1 ]; then	
				    cp -R $file "$DESTDIR/$package"
				    chmod +w "$DESTDIR/$package"
				    rm -rf "$DESTDIR/$package/tgt_*"
				else
					ln -si $file "$DESTDIR/$package"
				fi
			fi
done

# explicitely copy the .svn directory and the Makefile also...
cp -R "$SRCDIR"/.svn "$DESTDIR"
chmod +w "$DESTDIR"/.svn
cp "$SRCDIR"/Makefile "$DESTDIR"
chmod +w "$DESTDIR/Makefile"

mkdir "$DESTDIR/lib"
mkdir "$DESTDIR/include"
mkdir "$DESTDIR/bin"

# now establish the links in the lib directory
for d in "$SRCDIR/lib"/*
do
  if [ -d "$d" ]
  then
    dlib=`basename $d`
    mkdir $DESTDIR/lib/$dlib
    for lib in "$d"/*
    do
      ln -si $lib "$DESTDIR/lib/$dlib/"
    done
  fi
done

ln -si "$SRCDIR"/../root "$DESTDIR"/../root
ln -si "$SRCDIR"/../geant3 "$DESTDIR"/../geant3

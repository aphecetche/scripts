#!/bin/sh

suffix=$(aliBuild architecture)

prefix=${1:-$ALIBUILD_WORK_DIR/${suffix}}
label=${2:-latest}

if ! test -d $prefix; then
  echo "directory $prefix does not exist"
  exit 65
fi

targetdir=${3:-EXPERIMENTAL}

targetdir=$prefix/$targetdir

echo "prefix=$prefix"
echo "targetdir=$targetdir"
echo "label=$label"

if ! test -d $targetdir; then
  mkdir $targetdir
fi

find $prefix -maxdepth 2 -type l -name $label | while read dir; do
  ln -sf $dir $targetdir/$(basename $(dirname $dir))
done

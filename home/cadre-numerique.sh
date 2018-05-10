#!/bin/bash

if [ $# -ne 2 ]; then
 echo "Usage: " $(basename $0) "sourcedir destination_tag"
 exit
fi

sourcedir=$(cd $1; pwd)

topdir="$HOME/Desktop/CadreNumerique"

destinationLandscape="$topdir/$2paysage"
destinationPortrait="$topdir/$2portrait"

mkdir -p $destinationLandscape
mkdir -p $destinationPortrait

for f in $(ls $sourcedir)
do
  h=$(sips -g pixelHeight $sourcedir/$f | grep pixel | cut -f 2 -d ':' | cut -c 2-10)
  w=$(sips -g pixelWidth $sourcedir/$f | grep pixel | cut -f 2 -d ':' | cut -c 2-10)
  if [ $h -gt $w ]; then
     echo "Resizing and rotating into $destinationPortrait/$f..."
     sips --resampleHeight 1024 -r 270 $sourcedir/$f --out $destinationPortrait/$f > /dev/null 2>&1
  else
     echo "Resizing into $destinationLandscape/$f..."
    sips --resampleWidth 1024 $sourcedir/$f --out $destinationLandscape/$f > /dev/null 2>&1
  fi
done

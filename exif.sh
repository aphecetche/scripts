#!/bin/bash

cmd=$HOME/Scripts/EXIF.py

size=3872

echo "dx/i:cdx/f:fx/i:cx/f"

mkdir -p tri
cd tri

n=0

for f in `ls $1` 
do
  img=$1/$f
  fx=$($cmd $img | grep FocalLengthIn35mmFilm | cut -d ' ' -f 7)
  dx=$(($fx*2/3))
  h=$(identify -ping -format '%h' $img)
  w=$(identify -ping -format '%w' $img)
  x=$h
  if [ $w -gt $x ]
  then
     x=$w
  fi
  r=$(echo "oldscale=scale; scale = 9; $size/$x; scale=oldscale" | bc)
  cfx=$(echo "oldscale=scale; scale = 0; $fx*$r/1; scale=oldscale" | bc)
  cdx=$(echo "oldscale=scale; scale = 0; $dx*$r/1; scale=oldscale" | bc)
  echo $dx $cdx $fx $cfx
  dir=""
  n=$(($n+1))
  if [ $cfx -le 24 ]; then
    dir="fle24"
  elif [ $cfx -lt 55 ]; then
    dir="f24-55"
  elif [ $cfx -lt 70 ]; then
    dir="f55-70";
  elif [ $cfx -lt 105 ]; then
    dir="f70-105";
  elif [ $cfx -lt 200 ]; then
    dir="f105-200";
  else
    dir="fgt200";
  fi
  mkdir -p $dir
  cd $dir
  ln -si $img .
  cd ..
  dir="sf$cfx"
  mkdir -p $dir
  cd $dir
  ln -si $img .
  cd ..
done

echo "-------------------------------------------------------------"

echo "$n pictures scanned"

for dir in `ls -1d sf*` `ls -1d f*` 
do
    ndir=$(ls -al $dir/*.jpg | wc -l)
    frac=$(echo "oldscale=scale; scale = 1; $ndir*100.0/$n; scale=oldscale" | bc)
    echo "$dir has $frac percent of pictures"
done
 
cd ..


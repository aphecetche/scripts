#!/bin/sh

if [ $# -ne 3 ]; then
  echo "Usage : $0 root_version geant_version aliroot_version"
  exit
fi

server=http://alimacx03.cern.ch:8889/tarballs/

pc=Darwin-i386--gnu-4.0.1.tar.gz

root=root_v$1.$pc # 34 M
geant=geant3_v$2.$pc # 23 M
aliroot=aliroot_v$3.$pc # 752 M

if [ ! -e $root ]; then
  wget $server/$root
fi

if [ ! -e $geant ]; then
  wget $server/$geant
fi

if [ ! -e $aliroot ]; then
  wget $server/$aliroot
fi

dir=v$3

mkdir $dir

cd $dir

tar -zxvf ../$root 
tar -zxvf ../$geant 
tar -zxvf ../$aliroot 

mv v$1 root
mv v$2 geant
mv v$3 aliroot

cd ../



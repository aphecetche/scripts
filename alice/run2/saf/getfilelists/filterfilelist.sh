#!/bin/sh

for filelist in $(ls nansaf*.txt)
do

period=$1
pass=$2
datatype=${3:AliESD}

cat $filelist | cut -d ' ' -f 5 | grep "$datatype" | grep "$period" | grep "$pass" | sed s_/data/alice_/alice_g | awk '{printf "xrdfs nansafmaster2 rm %s\n",$1;} '

done

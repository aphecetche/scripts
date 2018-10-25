#!/bin/sh

for filelist in $(ls nansaf*.files.list)
do

#period=$1
#pass=$2
#datatype=${3:AliESD}
#cat $filelist | cut -d ' ' -f 5 | grep "$pass" | grep "$datatype" | grep "$period" | sed s_/data/alice_/alice_g | awk '{printf "xrdfs nansafmaster2 rm %s\n",$1;} '

search="OCDB"

cat $filelist | cut -d ' ' -f 4,5 | grep $search | sed s_/data/alice_/alice_g | awk '{printf "xrdfs " $2 " rm %s\n",$1;} ' | sed s/SAF-//g

done

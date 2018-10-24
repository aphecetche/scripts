#!/bin/sh

filelist=$1
period=$2
pass=$3

cat $filelist | cut -d ' ' -f 2 | grep "AliESDs" | grep "$period" | grep "$pass" | sed s_/data/alice_/alice_g | awk '{printf "xrdfs %s rm %s\n",ENVIRON["machine"],$1;} '


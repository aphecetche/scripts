#!/bin/sh

root=$HOME/alice
#log=$HOME/tmp/toto.log

#echo $(date) "$1" >> $log

file=$root/$1

cd $(dirname $root/$1)
cd ..

#echo $PWD >> $log

if [[ -f $file ]]; then
  ln -s $file .
fi

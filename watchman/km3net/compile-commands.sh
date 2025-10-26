#!/bin/sh

root=$HOME/km3net

file=$root/$1


dir=$(dirname $root/$1)
cd $dir
cd ..

if [[ -f $file ]]; then
  # file is created
  ln -sf $file .
elif [[ ! -e $file ]]; then
  # file is removed
  # watchman log error "file $file is removed. dir=$dir"
  cd $(dirname $dir)
  if [[ -L compile_commands.json ]]; then 
    rm compile_commands.json
  fi
fi

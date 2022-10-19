#!/bin/sh

root=$HOME/alice

file=$root/$1

cd $(dirname $root/$1)

if [[ -d $file ]]; then
  ln -s $file ./spack-build-latest
fi

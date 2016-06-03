#!/bin/bash

# generate tags (using ctags) for a given project

What=${1:-AliceO2}

cmd="ctags -R  --exclude=.git --exclude=Debug --exclude=Release --exclude=build --exclude=G__ --exclude=data"

if [[ $What =~ AliRoot ]];
then
cmd="$cmd --exclude=OCDB --exclude=LHAPDF"
fi

cd $HOME/o2/alfa/$What
$cmd

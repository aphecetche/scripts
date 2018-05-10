#!/bin/bash

# alice-lock-directory dir status
# status = 1 to made dir read-only
# status = 0 to made dir read-write

if  [ ! $# -eq 2 ]
then
  echo "Must give 2 arguments"
  exit
fi

if [ $2 == 0 ]
then
  param="+w"
else
  param="-w"
fi

dir=`pwd`

cd $1

for file in *
do
  if [ -d "$file" ]
  then
    chmod $param "$file"
  fi
done

cd $dir



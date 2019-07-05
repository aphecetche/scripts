#!/usr/bin/env sh
#
# Apply cmake-format to all CMakeLists.txt files in a given directory,
# recursively
#

dir=$1
configfile=$2

find $1 -name CMakeLists.txt | while read file; do
  cmake-format -i -c $configfile $file 
done

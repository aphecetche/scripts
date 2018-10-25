#!/bin/sh

basedir=${1:-/data}
maxdepth=${2:-4}
export machine=$(hostname -s)
output=$machine.sizes.txt

find $basedir -name "*" -maxdepth ${maxdepth}  -type d -exec du -sh {} \; | sort -nr > $output


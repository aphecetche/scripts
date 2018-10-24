#!/bin/sh

for s in $(ls nan*.sh)
do
echo $s
. ./$s
done

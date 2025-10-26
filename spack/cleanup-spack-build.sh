#!/bin/sh

# WIP !
# NOT DONE !
#
find -E . -regex ".*spack-build-[a-z0-9]{7}$" -type d -depth 1 -exec stat -f "%a %N" {} \; | sort -n 

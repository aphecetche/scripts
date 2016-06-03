#!/bin/sh

# if you have one or several workdirs (obtained through git-new-workir) based
# on a common topdir and that you decide to move the topdir... 
# this script will fix the links in your workdir for you...
#
# cd workdir
# git-relocate-links new-location-of-top-dir
#

topdir=$1

files=(config hooks info objects packed-refs refs remotes rr-cache svn logs/refs)

for f in ${files[*]}
  do
    rm .git/$f
    ln -sf $topdir/.git/$f .git/$f
  done

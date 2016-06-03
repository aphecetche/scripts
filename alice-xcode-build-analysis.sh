#!/bin/bash
#
# alice-xcode-build-analysis.sh topdir [what]
#
# topdir must be absolute dir, e.g. ${HOME}/Code/Analysis/laphecet-mumu

source $HOME/Scripts/alice-env.sh Dev/trunk

cd $1

packages=( )

what=""

if [ $# -eq 2 ]; then
  what=$2
fi

/usr/bin/make $what -j 2 2>&1 | while read line; do

  if [[ "$line" =~ "error" ]] || [[ "$line" =~ "warning" ]]; then
      
   if ! [[ "$line" =~ "/root/include" ]]; then # we're not really interested in Root warnings

       if [[ "$line" =~ ".cxx" ]] || [[ "$line" =~ ".h" ]]; then

       a="$1/$line"

       echo $a

       fi

   fi

fi

done

#exit $rv










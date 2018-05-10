#!/bin/bash
#
# alice-xcode-build-af.sh
#
# to wrap call to Makefile in $HOME/Code/AF 

source $HOME/Scripts/alice-alien-env.sh
source $HOME/Scripts/alice-root-env.sh

cd $HOME/Code/AF

packages=( )

/usr/bin/make 2>&1 | while read line; do

  if [[ "$line" =~ "error" ]] || [[ "$line" =~ "warning" ]]; then
      
   if ! [[ "$line" =~ "/root/include" ]]; then # we're not really interested in Root warnings

       if [[ "$line" =~ ".cxx" ]] || [[ "$line" =~ ".h" ]]; then

       a="$HOME/Code/AF/$line"

       echo $a

       fi

   fi

fi

done

#exit $rv










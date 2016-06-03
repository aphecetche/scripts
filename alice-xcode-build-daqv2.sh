#!/bin/bash
#
# alice-xcode-build-daqv2.sh 
#

source $HOME/Scripts/alice-amore-env.sh

dir=$HOME/Alice/Online/Alice-daqDA-framework-2.02

cd $dir

nerrors=0

$dir/make.sh 2>&1 | while read line; do

  if [[ "$line" =~ "error" ]] || [[ "$line" =~ "warning" ]]; then
      
   if ! [[ "$line" =~ "/root/include" ]]; then # we're not really interested in Root warnings

       if [[ "$line" =~ ".cpp" ]] || [[ "$line" =~ ".h" ]]; then

       a="$dir/$line"

       echo $a

       (( nerrors += 1 ))

       fi

   fi

fi

done

echo "n=$nerrors"

#exit 1










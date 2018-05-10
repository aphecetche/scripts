#!/bin/bash
#
# alice-xcode-build-amore.sh topdir [what]
#
# topdir must be absolute dir, e.g. ${HOME}/Alice/Amore/trunk

topdir=$1
#echo "topdir=$topdir"

source $HOME/Scripts/alice-env.sh Dev/trunk
source $HOME/Scripts/alice-date-env.sh

cd $topdir

packages=( core agent archiver client publisher subscriber )

what=""

if [ $# -eq 2 ]; then
  what=$2
fi

/usr/bin/make $what -j 2 2>&1 | while read line; do

  if ! [[ "$line" =~ "libtool" ]]; then # discard libtool messages

  if [[ "$line" =~ "error" ]] || [[ "$line" =~ "warning" ]]; then
      
   if ! [[ "$line" =~ "/root/include" ]]; then # we're not really interested in Root warnings

       a=$line

       b=$(echo $a | awk -F ":" '{print $1}')

       c=$(find $topdir -name "$b")

       d=$(dirname $c)

       echo "$d/$a" 

   fi
fi
fi

done

#exit $rv










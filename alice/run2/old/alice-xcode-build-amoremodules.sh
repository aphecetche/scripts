#!/bin/bash
#
# alice-xcode-build-amoremodules.sh topdir module [package]
#
# topdir must be absolute dir, e.g. ${HOME}/Alice/AmoreModules/trunk

topdir=$1
module=$2

package=""

if [ $# -eq 3 ]; then
  package=$3
fi

# insure our parameters do not get propagated to other scripts...
while (( "$#" )); do
shift
done

source $HOME/Scripts/alice-amore-env.sh

cd "$topdir/$module/src"

if [ -n "$package" ]; then
 cd $package
fi
 
packages=( common publisher subscriber ui )

/usr/bin/make install 2>&1 | while read line; do

  if ! [[ "$line" =~ "libtool" ]]; then # discard libtool messages

  if [[ "$line" =~ "error" ]] || [[ "$line" =~ "warning" ]]; then
      
   if ! [[ "$line" =~ "/root/include" ]]; then # we're not really interested in Root warnings

       a=$line

       b=$(echo $a | awk -F ":" '{print $1}')

       c=$(find $topdir -name "$b")

       if [ -n "$c" ]; then

	   d=$(dirname $c)

	   echo "$d/$a" 
	fi

   fi
fi
fi

done

#exit $rv










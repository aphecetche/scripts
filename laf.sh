#!/bin/tcsh
# should be sourced

pid=`ps aux | grep 'ssh -fN4 -X -l aphecetc ccali.in2p3.fr -L 2093:ccapl0012.in2p3.fr:1093' | grep -v grep | cut -d ' ' -f 3`

for p in $pid; do
	echo "pid=$p"
	kill -9 $p
done

ssh -fN4 -X -l aphecetc ccali.in2p3.fr -L 2093:ccapl0012.in2p3.fr:1093


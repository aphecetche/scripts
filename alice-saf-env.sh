#!/bin/sh

export TOL_PROXY=60
# Location of the Grid x509 proxy
export PROXY="/tmp/x509up_u$UID"

source $HOME/Scripts/alice-alien-env.sh

exp=$(openssl x509 -in "$PROXY" -noout -checkend $TOL_PROXY 2>&1)

if [ -n "$exp" ]; then
    echo "Doing a xrdgsiproxy init"
	xrdgsiproxy init

fi

source $HOME/Scripts/alice-root-env.sh trunk

#source $PROXY

export XrdSecGSISRVNAMES="nansafmaster.in2p3.fr"

# create new tunnels
#
#pid=`ps x -o "pid, command" | grep ssh | grep aphecete | grep nansl1 | cut -d ' ' -f 1`

#for p in $pid; do
#	echo "pid=$p"
#	kill -9 $p
#done
#
#ssh -fN4 -X -l aphecete nansl1.in2p3.fr -L 1093:nansafmaster.in2p3.fr:1093

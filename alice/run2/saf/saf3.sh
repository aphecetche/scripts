#!/bin/bash

# time left until expiration of proxy
remainingTime=$(grid-proxy-info -timeleft)

if [ "$remainingTime" -le 60 ]; then
	grid-proxy-init 
fi

option=""
if [ $# -gt 1 ]; then
	option=$2
fi

if [[ "$option" == "enter" ]]; then
	gsissh -t -p 1975 nansafmaster3.in2p3.fr "export PS1='\u\h\w>'; /opt/SAF3/bin/saf3-enter"
else
	gsissh -t -p 1975 nansafmaster3.in2p3.fr bash
fi


sshfs -o ssh_command="gsissh -p1975" nansafmaster3.in2p3.fr:/home/laphecet ~/saf3

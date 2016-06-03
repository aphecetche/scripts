#!/bin/tcsh

xname ssh-tunnels-to-cern

# Definition of the ports to be used

set logbook=8080
set layout=8123
set vaf=5522

echo "Ports will be :"

echo "logbook=$logbook"
echo "layout=$layout"
echo "vaf=$vaf"

ssh -l laphecet -L ${vaf}:alivaf-004.cern.ch:22 -L ${logbook}:alice-logbook.cern.ch:80 -L ${layout}:layout.web.cern.ch:80 lxplus.cern.ch


#echo "no tunnel defined yet"


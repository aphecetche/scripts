#!/bin/tcsh

xname rssh-tunnels

# Definition of the ports to be used

set logbook=5000
set elog=7815
set netmon=4000
set pcam0=3000
set web=8000

echo "Ports will be :"

echo "logbook\t\t$logbook"
echo "elog\t\t$elog"
echo "netmon\t\t$netmon"
echo "pcam0\t\t\$pcam0"
echo "phenix web $web"

ssh -L ${elog}:logbook.phenix.bnl.gov:7815 \
    -L ${logbook}:logbook.phenix.bnl.gov:80 \
    -L ${netmon}:netmon.phenix.bnl.gov:80 \
    -L ${pcam0}:pcam0.phenix.bnl.gov:80 \
    -L ${web}:www.phenix.bnl.gov:80 \
 rssh.rhic.bnl.gov

#!/bin/sh

if [ $# -gt 0 ]; then
  inputdata=$1
else
  inputdata="AliESDs.root"
fi

aliroot -b << EOF
.L AODtrain.C
TStopwatch t;
AODtrain(0,"$inputdata"); > runtrain.log
t.Print(); >> runtrain.log
EOF



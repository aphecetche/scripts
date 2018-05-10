#!/bin/bash

if [ $# -lt 1 ]; then
  echo "usage: $0 fillnumber"
  exit
fi

fill=$1

if [ ! -e "fill.$fill.txt" ]; then
	echo "cannot find fill file : fill.$fill.txt"
	exit
fi

root -b << EOF
AliAnalysisTriggerScalers ts("fill.$fill.txt","raw://");
ts.SetCrossSectionUnit("ub");
ts.IntegratedLuminosity("C0V0M-B-NOPF-CENTNOTRD,CMUL7-B-NOPF-MUFAST,CMSL7-B-NOPF-MUFAST,CMSH7-B-NOPF-MUFAST","lumi.$fill.csv"); > lumi.$fill.txt
.q
EOF

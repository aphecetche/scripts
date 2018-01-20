#!/bin/sh

for period in lhc17p lhc17q
do
root -b <<EOF
AliAnalysisTriggerScalers ts("$HOME/github.com/aphecetche/acode/runlists/2017/runlist.$period","local:///alice/data/2017/OCDB");
ts.IntegratedLuminosity("C0TVX-B-NOPF-CENT,C0TVX-B-NOPF-CENTNOTRD,C0TVX-B-NOPF-MUON,CMUL7-B-NOPF-MUON,CMUL7-B-NOPF-MUFAST,CMSL7-B-NOPF-MUON,CMSL7-B-NOPF-MUFAST,CMSH7-B-NOPF-MUON,CMSH7-B-NOPF-MUFAST","lumi.$period.csv"); > lumi.$period.txt
.q
EOF
done

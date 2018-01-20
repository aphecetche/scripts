#!/bin/sh

root -b<<EOF
AliAnalysisTriggerScalers ts("$HOME/github.com/aphecetche/acode/runlists/2017/runlist.13","local:///alice/data/2017/OCDB");
ts.IntegratedLuminosity("C0TVX-B-NOPF-CENT,C0TVX-B-NOPF-CENTNOTRD,C0TVX-B-NOPF-MUON,CMUL7-B-NOPF-MUON,CMUL7-B-NOPF-MUFAST,CMSL7-B-NOPF-MUON,CMSL7-B-NOPF-MUFAST,CMSH7-B-NOPF-MUON,CMSH7-B-NOPF-MUFAST","lumi.13.csv"); > lumi.13.txt
.q
EOF

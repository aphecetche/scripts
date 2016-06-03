#!/bin/sh

#rm -rf *.ps *.root runtrainmc*.log 

aliroot -b << EOF
.L AnalysisTrainNewFilterAODMC.C
TStopwatch t;
AnalysisTrainNew("local"); > runtrainmc.log
t.Print(); >> runtrainmc.log
EOF



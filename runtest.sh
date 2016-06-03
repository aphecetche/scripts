#!/bin/sh
# run the reco step of the test script under valgrind

rm -rf *.ps MUON*.root CORR* Global* Merge* galice.root Run* Ali*.root Tri*.root HLT*.root *QA* *.log 

aliroot -b -q runReconstruction.C\(1234567,\"raw.root\",\"SAVEDIGITS\"\) 2>&1 | tee runtest.log



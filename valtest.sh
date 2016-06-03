#!/bin/sh
# run the reco step of the test script under valgrind

rm -rf *.ps MUON*.root CORR* Global* Merge* galice.root Run* Ali*.root Tri*.root HLT*.root *QA* *.log 

valgrind --num-callers=30 --dsymutil=yes --error-limit=no --leak-check=full --suppressions=$ROOTSYS/etc/valgrind-root.supp aliroot -b -q runReconstruction.C\(1234567,\"raw.root\",\"SAVEDIGITS\"\) 2>&1 | tee valtest.log



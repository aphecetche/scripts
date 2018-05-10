#!/bin/sh
# run the reco under valgrind

rm -rf *.ps MUON*.root CORR* Global* Merge* galice.root Run* Ali*.root Tri*.root HLT*.root *QA* *.log 

valgrind --num-callers=30 --dsymutil=yes --error-limit=no --leak-check=full --show-reachable=no --track-origins=no --time-stamp=yes --read-var-info=yes --verbose --suppressions=$ROOTSYS/etc/valgrind-root.supp --suppressions=$ALICE_ROOT/etc/valgrind-aliroot.supp aliroot -b -q runDataReconstruction.C 2>&1 | tee valtest.log

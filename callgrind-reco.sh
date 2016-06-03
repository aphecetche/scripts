#!/bin/sh
# run the reco under valgrind

rm -rf *.ps MUON*.root CORR* Global* Merge* galice.root Run* Ali*.root Tri*.root HLT*.root *QA* *.log

valgrind --tool=callgrind --num-callers=30 --dsymutil=yes --error-limit=no --time-stamp=yes --read-var-info=yes --verbose --suppressions=$ROOTSYS/etc/valgrind-root.supp --suppressions=$ALICE_ROOT/etc/valgrind-aliroot.supp aliroot -b -q runDataReconstruction.C 2>&1 | tee callgrind.log

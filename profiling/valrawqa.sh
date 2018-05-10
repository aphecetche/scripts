#!/bin/sh
# run the reco under valgrind

rm -rf *QA*.root

valgrind --num-callers=30 --dsymutil=yes --error-limit=no --leak-check=full --show-reachable=no --track-origins=no --time-stamp=yes --read-var-info=yes --verbose --suppressions=$ROOTSYS/etc/valgrind-root.supp --suppressions=$ALICE_ROOT/etc/valgrind-aliroot.supp root -q rawqa.C++ 2>&1 | tee valrawqa.log

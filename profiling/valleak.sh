#!/bin/sh
# run leak.C under valgrind

valgrind --num-callers=30 --dsymutil=yes --error-limit=no --leak-check=full --show-reachable=no --track-origins=no --time-stamp=yes --read-var-info=yes --verbose --suppressions=$ROOTSYS/etc/valgrind-root.supp --suppressions=$ALICE_ROOT/etc/valgrind-aliroot.supp root.exe -b -q leak.C\(0\) 2>&1 | tee valleak.log

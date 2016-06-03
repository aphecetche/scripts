#!/bin/sh
# run the runMuMu.C under valgrind

valgrind \
--num-callers=30 \
--dsymutil=yes \
--error-limit=no \
--leak-check=full \
--show-reachable=no \
--track-origins=no \
--time-stamp=yes \
--read-var-info=yes \
--verbose \
--suppressions=$ROOTSYS/etc/valgrind-root.supp \
root.exe -b -q runMuMu.C\(0\) 2>&1 | tee valmumu.log

#!/bin/sh
# run esd.C under valgrind


valgrind --num-callers=30 --dsymutil=yes --error-limit=no --leak-check=full --suppressions=$ROOTSYS/etc/valgrind-root.supp root.exe -b -q esd.C\(0\) 2>&1 | tee valesd.log



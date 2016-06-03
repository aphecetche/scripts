#!/bin/sh

source $HOME/Scripts/cleanrec.sh

#iprofiler -T 7200 -timeprofiler -leaks `which aliroot` -b -q rec.C 2>&1 | tee profilerec.log
iprofiler -T 7200 -leaks `which aliroot` -b -q rec.C 2>&1 | tee profilerec.log


#!/bin/sh

source $HOME/Scripts/cleanrec.sh

iprofiler -T 7200 -timeprofiler `which aliroot` -b -q RunBasicHLTMUONChain.C+ 2>&1 | tee profilehlt.log


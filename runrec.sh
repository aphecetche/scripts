#!/bin/sh

source $HOME/Scripts/cleanrec.sh

aliroot -b -q rec.C 2>&1 | tee runreco.log

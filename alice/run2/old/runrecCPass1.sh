#!/bin/sh

rm -rf HLT*.root *.ps *.Digits.root *.RecPoints.root galice.root *QA*.root Trigger.root *.log AliESD*

aliroot -b -q recCPass1_OuterDet.C 2>&1 | tee runrecCPass1.log

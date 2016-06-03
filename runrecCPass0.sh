#!/bin/sh

rm -rf HLT*.root *.ps *.Digits.root *.RecPoints.root galice.root *QA*.root Trigger.root *.log AliESD*

aliroot -b -q recCPass0.C 2>&1 | tee runrecCPass0.log

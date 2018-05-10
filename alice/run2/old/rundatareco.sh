#!/bin/sh

rm -rf *.ps *.root *.log 

aliroot -b -q runDataReconstruction.C 2>&1 | tee rundatareco.log



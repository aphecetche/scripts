#!/bin/sh

#list=( STEERBase ESD CDB AOD ANALYSIS ANALYSISalice PWG3base CORRFW PWG3muon PWG3dielectron TENDER )

list=( STEERBase ESD AOD ANALYSIS OADB ANALYSISalice CORRFW PWGmuon ) #PWGmuondep)

cur=$(pwd)

#rm *.par

cd ${ALICE_BUILD}

for p in ${list[@]:0}
do
  rm -rf $p
  par="$p.par"
  make $par
#  cp ${ALICE_BUILD}/$par .
done

cd $cur

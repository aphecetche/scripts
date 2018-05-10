#
#
# cd $ALICE_BUILD
# cmake --graphviz=graph.dot .
#

/Users/laurent/Scripts/graphviz-cleaner.py -p ACORDE \
-p ALIROOT \
-p ANALYSIS \
-p BCM \
-p CORRFW \
-p DPMJET \
-p EMCAL \
-p EPOS \
-p EVE \
-p EVGEN \
-p FASTSIM \
-p FMD \
-p HERWIG \
-p HIJING \
-p HLT \
-p HMPID \
-p ITS \
-p JETAN \
-p LHAPDF \
-p MICROCERN \
-p MONITOR \
-p OADB \
-p PHOS \
-p PMD \
-p PWG0 \
-p PWG1 \
-p PWG2 \
-p PWG3 \
-p PWG4 \
-p PYTHIA6 \
-p PYTHIA8 \
-p RAW \
-p STAT \
-p STRUCT \
-p T0 \
-p TAmpt \
-p TDPMjet \
-p TEPEMGEN \
-p THbtp \
-p THerwig \
-p THijing \
-p TOF \
-p TPC \
-p TPHIC \
-p T-RD \
-p TRIGGER \
-p TTherminator \
-p TUHKMgen \
-p VZERO \
-p ZDC \
graph.dot

dot cleaned.dot -Tpng -o cleaned.png

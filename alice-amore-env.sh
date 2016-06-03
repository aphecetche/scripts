# script to be sourced from the main alice-env.sh one
# once AMORE variables has been set

function AmoreSetEnv()
{

export AMORE_SITE=/amoreSite

export PATH=$PATH:$AMORE/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$AMORE/lib:$AMORE_SITE/lib:$AMORE_MODULES/lib

#export DAQ_DEBUG=true
#export DAQ_DEBUG_DET=1024
#export DAQ_DEBUG_CLUSTERS=2

#export QA_DEBUG=true
#  	export QA_DEBUG_SPECIES=2 # LowMultiplicity
#export QA_DEBUG_SPECIES=4 # HighMultiplicity
#export QA_CRASH_MAX_FUNCTIONS=true
    
export DATE_RUN_TYPE=PHYSICS

export DATE_RUN_NUMBER=167920

#export AMORE_TEST_FILE=/alice/data/2011/LHC11h/000169099/raw/11000169099082.51.raw

export AMORE_TEST_FILE=/alice/data/2015/LHC15c/000217648/raw/15000217648018.10.raw

#export AMORE_TEST_FILE=/alice/data/2013/LHC13f/000196474/raw/13000196474082.15.raw

#export AMORE_CDB_URI=local:///local/cdb/

export AMORE_CDB_URI=local:///cvmfs/alice-ocdb.cern.ch/calibration/data/2011/OCDB

export DIM_DNS_NODE=localhost

source $AMORE/bin/amoreSetup $AMORE_SITE/AMORE.params

}


function AmoreCleanEnv() {

  for v in ${!AMORE*}; do
      unset $v
  done

unset DAQ_DEBUG DAQ_DEBUG_DET DAQ_DEBUG_CLUSTERS QA_DEBUG QA_DEBUG_SPECIES QA_CRASH_MAX_FUNCTIONS DATE_RUN_TYPE DATE_RUN_NUMBER

}

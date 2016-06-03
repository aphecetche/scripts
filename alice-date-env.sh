# script to be sourced from the main alice-env.sh one
# once DATE_ROOT has been set

function DateSetEnv()
{
export DATE_SITE=/dateSite
export DAQDALIB_PATH=$HOME/alicesw/Alice-daqDA-framework-1.5.1/daqDAlib

# DIM
export OS=Linux
export DIMDIR=/opt/dim
source $DIMDIR/setup.sh > /dev/null 2>& 1

if [ -e "$DATE_ROOT"/setup.sh ]; then
   source "$DATE_ROOT"/setup.sh
   # note that this setup will load a number of env. variables
   # from the DB (using eval `$DATE_DB_DIR/loadEnvDB.tcl -b`)
   # so that might undo some of your settings if you are not carefull...
fi

if [ "$DAQDALIB_PATH" != '' ]; then
     export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$DAQDALIB_PATH"
fi

export DATE_DETECTOR_CODE=MCH
export DATE_ROLE_NAME=ldc-MUON_TRK-3
export DATE_FES_PATH=/dateSite/FES
export DATE_FES_DB=daq:daq@localhost/DATE_CONFIG
}

function DateCleanEnv()
{
  for v in ${!DATE_*} ${!SMI*} ${!DIM*}; do
      unset $v
  done

  unset DAQDALIB_PATH OS DIMDIR DIM_DNS_NODE DAQ_ROOT_DOMAIN_NAME
}
#
# script (to be sourced, not executed) to help testing amore & DA stuff
# note that Amore env must be set prior to calling this script
# see e.g. ~/alicesw/alice-amore-env.sh

usage() {
    echo "Usage= $0 {start|stop|testDA|occDA|startMCHQA|startMCHQAshifter|valMCHQA|startMTRQA|startExpert|purge|startDAQ|startMCHQC}"
}

if [ -z "$1" ]; then
    usage
    return
fi

action=$1

# Procedure to check for a Unix daemon
# Parameters:
#    1: full path to the daemon
#    2: silent/scream switch
checkDaemon() {
  f=`basename $1`
  if [ "`ps -efl|grep $f|grep -v grep`" = "" ]; then
    [ "$2" ] && echo "UNIX daemon $1 not active"
    return 2
  fi
  return 0
}

installDaemon() {
  f="`basename $1`"
  if [ "`ps -efl|grep $f|grep -v grep`" = "" -a -x $1 ]; then
    nohup $1 </dev/null >/dev/null 2>&1 &
  fi
}

amoreenv() {
    if [ -z "$AMORE_SITE" ]; then
	echo "amore env not set"
	return
    fi

#    export DAQ_DEBUG=true
#    export DAQ_DEBUG_DET=1024
#    export DAQ_DEBUG_CLUSTERS=2
#    export QA_DEBUG=true
#  	export QA_DEBUG_SPECIES=2 # LowMultiplicity
#  	export QA_DEBUG_SPECIES=4 # HighMultiplicity
    export QA_CRASH_MAX_FUNCTIONS=true

    export DATE_RUN_TYPE=PHYSICS
    export DATE_RUN_NUMBER=169099

    export MYTESTFILE=$AMORE_TEST_FILE
    


# -u = run control mode (will wait SOR)
# -r = rewind file
# 
# -n = never stops
# -c xxx = xxx max number of cyles to execute
#
# (use amoreAgent -h to get the list of possible options)
#
#    export AGENT_RUN_OPTIONS="-u -r"
    export AGENT_RUN_OPTIONS=" -e 250 -c 1 "
}

case "$action" in
    startMySQL)
	
	;;
    stopMySQL)
	
	;;
    purge)
	# this is in principle no longer needed as long as binary logging is disable in my.cnf ...
	#now=`date +%Y-%m-%d`
	#mysql -u root -p -e "PURGE BINARY LOGS BEFORE '$now';"
	;;
    start)
	amoreenv
	${DATE_INFOLOGGER_BIN}/infoLoggerServer.sh start
	${DATE_INFOLOGGER_BIN}/infoLoggerReader.sh start
	fakeSOREOR &
	amoreArchiver -g $HOME/alicesw/archiver.conf &
	;;
    stop)
	amoreenv
	${DATE_INFOLOGGER_BIN}/infoLoggerServer.sh stop
	${DATE_INFOLOGGER_BIN}/infoLoggerReader.sh stop
	killall fakeSOREOR
	killall amoreArchiver
	;;
  testDA)
	amoreenv
  export DATE_DETECTOR_CODE=MCH
  export AMORE_DA_NAME=mon-DA-MUON_TRK-0
  export DATE_RUN_NUMBER=162181
  $ALICE_BUILD/lib/tgt_$ALICE_TARGET/MUONTRKTESTda.exe
  ;;
  occDA)
	amoreenv

 export DATE_DETECTOR_CODE=MCH
#  export DATE_RUN_NUMBER=215258
  export DATE_RUN_NUMBER=169099

  export MYPEDFILE=/alice/data/2011/LHC11h/000169099/raw/11000169099082.51.raw

  export AMORE_DA_NAME=mon-DA-MUON_TRK-0
  export DATE_ROLE_NAME=$AMORE_DA_NAME
  MCHOCCda.exe $MYTESTFILE
  ;;
  pedDA)

	amoreenv

  export DATE_DETECTOR_CODE=MCH
#  export DATE_RUN_NUMBER=215253
  export DATE_RUN_NUMBER=216303

  export MYPEDFILE=$HOME/alicesw/ped.run$DATE_RUN_NUMBER.raw

#  for LDC in {0..6} 
  for LDC in {0..6}
  do 
      export DATE_ROLE_NAME=ldc_MUON-TRK-${LDC}
      export AMORE_DA_NAME=$DATE_ROLE_NAME
      MCHPEDda.exe $MYPEDFILE.$DATE_ROLE_NAME
  done
  ;;
    startDAQ)
	amoreenv
	dir=`pwd`
	[[ ! -e /tmp/amoreAgentDAQ ]] && mkdir /tmp/amoreAgentDAQ
	cd /tmp/amoreAgentDAQ ; nice amoreAgent -a DAQ01 -r -s $MYTESTFILE -g $AMORE_SITE/eventSizePP.config
	cd $dir
	;;
    valMCHQA)
	amoreenv
	[[ ! -e /tmp/amoreAgentMCHQAshifter ]] && mkdir /tmp/amoreAgentMCHQAshifter
	dir=`pwd`
	rm -f /tmp/amoreAgentMCHQAshifter/*.root
#   use -u option of amoreAgent to be in "RunControl" mode, i.e. waiting for SOR
	cd /tmp/amoreAgentMCHQAshifter; 
	valgrind --num-callers=30 --dsymutil=yes --error-limit=no --leak-check=full --show-reachable=no \
	--track-origins=no --time-stamp=yes --read-var-info=yes --verbose --suppressions=$ROOTSYS/etc/valgrind-root.supp \
	--suppressions=$ALICE_ROOT/etc/valgrind-aliroot.supp 2>&1 amoreAgent -a MCHQAshifter -c 5 -r -s $MYTESTFILE 2>&1 | tee valgrind.log
	cd $dir
	;;
    startMCHQAshifter)
	amoreenv
	[[ ! -e /tmp/amoreAgentMCHQAshifter ]] && mkdir /tmp/amoreAgentMCHQAshifter
	dir=`pwd`
	rm -f /tmp/amoreAgentMCHQAshifter/*.root
#   use -u option of amoreAgent instead of -c to be in "RunControl" mode, i.e. waiting for SOR
#   use -c [n] instead of -u to run only n cycles and then exit
	cd /tmp/amoreAgentMCHQAshifter; 
	echo "AliRoot.AliLog.ClassDebugLevel: AliMUONTrackerQADataMakerRec:1" > .rootrc
	nice amoreAgent -a MCHQAshifter $AGENT_RUN_OPTIONS -s $MYTESTFILE 2>&1 | tee run.log
	cd $dir
	;;
    valMCHQC)
	amoreenv
	[[ ! -e /tmp/amoreAgentMCHQC ]] && mkdir /tmp/amoreAgentMCHQC
	dir=`pwd`
	rm -f /tmp/amoreAgentMCHQC/*.root
#   use -u option of amoreAgent to be in "RunControl" mode, i.e. waiting for SOR
	cd /tmp/amoreAgentMCHQC; 
	valgrind --num-callers=30 --dsymutil=yes --error-limit=no --leak-check=full --show-reachable=yes \
	--track-origins=yes --time-stamp=yes --read-var-info=yes --verbose --suppressions=$ROOTSYS/etc/valgrind-root.supp \
	--suppressions=$ALICE_ROOT/../src/etc/valgrind-aliroot.supp 2>&1 amoreAgent -a MCHQC -c 5 -r -s $MYTESTFILE 2>&1 | tee valgrind.log
	cd $dir
	;;
    startMCHQC)
	amoreenv
	[[ ! -e /tmp/amoreAgentMCHQC ]] && mkdir /tmp/amoreAgentMCHQC
	dir=`pwd`
	rm -f /tmp/amoreAgentMCHQC/*.root
	cd /tmp/amoreAgentMCHQC
#	echo "AliRoot.AliLog.ClassDebugLevel: AliMergeableCollection:1" > .rootrc
	nice amoreAgent -a MCHQC $AGENT_RUN_OPTIONS -s $MYTESTFILE  2>&1 | tee run.log
	cd $dir
	;;
    startMCHQA)
	amoreenv
	[[ ! -e /tmp/amoreAgentMCHQA ]] && mkdir /tmp/amoreAgentMCHQA
	dir=`pwd`
	rm -f /tmp/amoreAgentMCHQA/*.root
	cd /tmp/amoreAgentMCHQA
	echo "AliRoot.AliLog.ClassDebugLevel: AliMUONTrackerQADataMakerRec:1" > .rootrc
	echo "+AliRoot.AliLog.ClassDebugLevel: AliMUONTrackerDataMaker:1" >> .rootrc

	nice amoreAgent -a MCHQA $AGENT_RUN_OPTIONS -s $MYTESTFILE  2>&1 | tee run.log
	cd $dir
	;;
    startTPCQA)
	amoreenv
	[[ ! -e /tmp/amoreAgentTPCQAshifter ]] && mkdir /tmp/amoreAgentTPCQAshifter
	dir=`pwd`
	rm -f /tmp/amoreAgentTPCQAshifter/*.root
#   use -u option of amoreAgent to be in "RunControl" mode, i.e. waiting for SOR
	cd /tmp/amoreAgentTPCQAshifter; nice amoreAgent -a TPCQAshifter -u -r -s $MYTESTFILE
	cd $dir
	;;
    startV0QA)
    # mind the fact that detector code for vzero is V00 for amore...
	amoreenv
	[[ ! -e /tmp/amoreAgentV00QAshifter ]] && mkdir /tmp/amoreAgentV00QAshifter
	dir=`pwd`
	rm -f /tmp/amoreAgentV00QAshifter/*.root
#   use -u option of amoreAgent to be in "RunControl" mode, i.e. waiting for SOR
	cd /tmp/amoreAgentV00QAshifter; nice amoreAgent -a V00QAshifter -u -r -s $MYTESTFILE
	cd $dir
	;;
    startMTRQA)
	amoreenv
	[[ ! -e /tmp/amoreAgentMTRQAshifter ]] && mkdir /tmp/amoreAgentMTRQAshifter
	dir=`pwd`
	rm -f /tmp/amoreAgentMTRQAshifter/*.root
#   use -u option of amoreAgent to be in "RunControl" mode, i.e. waiting for SOR
	cd /tmp/amoreAgentMTRQAshifter; nice amoreAgent -a MTRQAshifter -u -r -s $MYTESTFILE 2>&1 | tee run.log
	cd $dir
	;;
    startExpert)
	amoreenv
	[[ ! -e /tmp/amoreAgentMCHExpert ]] && mkdir /tmp/amoreAgentMCHExpert
	dir=`pwd`
	cd /tmp/amoreAgentMCHExpert; nice amoreAgent -a MCHExpert -u -r -s $MYTESTFILE  -g $AMORE_SITE/mchexpert.configfile
	cd $dir
	;;
    startHLT)
	amoreenv
	[[ ! -e /tmp/amoreAgentHLT ]] && mkdir /tmp/amoreAgentHLT
	dir=`pwd`
	cd /tmp/amoreAgentHLT; nice amoreAgent -a HLT_01 -u -r -s $MYTESTFILE  -g $AMORE_SITE/hlt.configfile
	cd $dir

# TCPHOMERDataProvider -port 9500 -infile mch-clustering-inspector-with-occupancy.root 
	;;
    *)
	usage
esac

#!/bin/sh
# starts the relevant daemons used by Amore
# must have issued the relevant command the setup the env. before (e.g. amore-env)

usage() {
    echo "Usage= $0 {start|stop|testDA|occDA|startMCHQA|startMCHQAshifter|valMCHQA|startMTRQA|startExpert|purge|startDAQ}"
    exit 1
}

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

if [ -z "$1" ]; then
    usage
fi

action=$1

amoreenv() {
    if [ -z "$AMORE_SITE" ]; then
	echo "amore env not set"
	exit 1
    fi

    export DAQ_DEBUG=true
    export DAQ_DEBUG_DET=1024
    export DAQ_DEBUG_CLUSTERS=2
    export QA_DEBUG=true
#  	export QA_DEBUG_SPECIES=2 # LowMultiplicity
  	export QA_DEBUG_SPECIES=4 # HighMultiplicity
    export QA_CRASH_MAX_FUNCTIONS=true
    export DATE_RUN_TYPE=PHYSICS

    export DATE_RUN_NUMBER=167920

#    export MYTESTFILE=/alice/data/2011/LHC11d/000157560/raw/11000157560007.15.raw
#    export MYTESTFILE=/alice/data/2011/LHC11e/000162181/raw/11000162181027.42.raw
#    export MYTESTFILE=/alice/data/2011/LHC11h_Technical/000166423/raw/11000166423079.15.raw
    export MYTESTFILE=/alice/data/2011/LHC11h/000167920/raw/11000167920043.17.raw
    
#    [[ -e $ALICE_INSTALL/lib/tgt_macosx64/libMONITOR.so ]] && mv $ALICE_INSTALL/lib/tgt_macosx64/libMONITOR.so $ALICE_INSTALL/lib/tgt_macosx64/libAliMONITOR.so
}

case "$action" in
    startMySQL)
	sudo launchctl load -w /Library/LaunchDaemons/org.macports.mysql5.plist
	;;
    stopMySQL)
	sudo launchctl unload -w /Library/LaunchDaemons/org.macports.mysql5.plist
	;;
	purge)
	# this is in principle no longer needed as long as binary logging is disable in my.cnf ...
	now=`date +%Y-%m-%d`
	mysql -u root -p -e "PURGE BINARY LOGS BEFORE '$now';"
	;;
    start)
	amoreenv
	${DATE_INFOLOGGER_BIN}/infoLoggerServer.sh start
	${DATE_INFOLOGGER_BIN}/infoLoggerReader.sh start
	rm -f /tmp/dns.log
	$DIMBIN/dns</dev/null >& /tmp/dns.log &
	$AMORE/bin/fakeLogbook &
#	installDaemon "${DATE_RC_BIN}/start_dim.sh"
	;;
    stop)
	amoreenv
	${DATE_INFOLOGGER_BIN}/infoLoggerServer.sh stop
	${DATE_INFOLOGGER_BIN}/infoLoggerReader.sh stop
	killall dns
	killall fakeLogbook
	;;
  testDA)
	amoreenv
  export DATE_DETECTOR_CODE=MCH
  export AMORE_DA_NAME=mon-DA-MUON_TRK-0
  export DATE_RUN_NUMBER=162181
  $ALICE_BUILD/lib/tgt_macosx64/MUONTRKTESTda.exe
  ;;
  occDA)
	amoreenv
  export DATE_DETECTOR_CODE=MCH
  export DATE_RUN_NUMBER=162181
  export AMORE_DA_NAME=mon-DA-MUON_TRK-0
  $ALICE_BUILD/lib/tgt_macosx64/MUONTRKOCCda.exe $MYTESTFILE
  ;;
  pedDA)
	amoreenv
  export DATE_DETECTOR_CODE=MCH
  export DATE_RUN_NUMBER=162181
  export AMORE_DA_NAME=ldc-MTRK-S3-0
  $ALICE_BUILD/lib/tgt_macosx64/MUONTRKPEDda.exe $MYPEDFILE
  ;;
    startDAQ)
	amoreenv
	dir=`pwd`
	[[ ! -e /tmp/amoreAgentDAQ ]] && mkdir /tmp/amoreAgentDAQ
	cd /tmp/amoreAgentDAQ ; nice amoreAgent -a DAQ -r -s $MYTESTFILE -g $AMORE_SITE/eventSizePP.config
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
	nice amoreAgent -a MCHQAshifter -u -r -s $MYTESTFILE 2>&1 | tee run.log
	cd $dir
	;;
    startMCHQA)
	amoreenv
	[[ ! -e /tmp/amoreAgentMCHQA ]] && mkdir /tmp/amoreAgentMCHQA
	dir=`pwd`
	rm -f /tmp/amoreAgentMCHQA/*.root
	cd /tmp/amoreAgentMCHQA
#	echo "AliRoot.AliLog.ClassDebugLevel: AliMUONTrackerQADataMakerRec:1" > .rootrc
	nice amoreAgent -a MCHQA -s $MYTESTFILE  2>&1 | tee run.log
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
    *)
	usage
esac

exit 0

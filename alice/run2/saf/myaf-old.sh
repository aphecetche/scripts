#!/bin/sh

# myaf [aaf] [what] [option] [detail]
# this script is supposed to be sourced, not executed
# if [what] is ds, option is the regexp of the dataset searched for
# if [what] is reset, option is true or false (hard or soft reset)
# if [what] is showds, option is dataset name
# if [what] is repairds, option is datasetname
# if [what] is xferlog, option is the filename of the file for which the transfer log should be searched for
# if [what] is corrupt, option is filename to mark as corrupted and detail is the dataset name
# if [what] is conf, option and detail are not used and the configuration file of the AAF is shown

# example : myaf saf ds '*27*'
# note the '' to protect the regular expression
#

AFDSUTILS="VO_ALICE@AFDSUtils::1.0.0";

usage() {
  echo "Usage : myaf aaf what option"
  echo "aaf can be caf, saf, saf2, skaf"
  echo "what can be 'ds', 'reset','df', 'clear', 'packages', 'showds', 'repairds', 'lstxt', 'corrupt', 'xferlog', 'synclog', 'conf' or 'stagerlog'"
}

xrddmlog()
{
  root -l -b << EOF
  TProof::Open("$1","workers=1x");
  gProof->Exec(".!echo '**************************************'; hostname -a ; cat /pool/PROOF-AAF/logs/xrddm.log");
  .q
EOF
}

stagerlog()
{
  root -l -b << EOF
  TProof::Open("$1","masteronly");
  gProof->Exec(".!cat $2/afdsmgrd/afdsmgrd.log")
  .q
EOF
}

synclog()
{
  root -l -b << EOF
  TProof::Open("$1","masteronly");
  gProof->Exec(".!cat /pool/PROOF-AAF/logs/sync_alien_cron/sync_alien_packages_cron.log")
  .q
EOF
}


showpackages() {
  root -l -b << EOF
  TProof::Open("$1","masteronly");
  gProof->ShowPackages();
  .q
EOF
}

dataset() {
  root -l -b << EOF
  TProof::Open("$1","masteronly");
  gProof->ShowDataSets("$2");
  .q
EOF
}

df() {
  if [ "$aaf" == "caf" ]; then
  disk="/pool/data/01 /pool/data/02 /pool/data/03"
  else
  disk="/pool/data/01"
  fi
  root -l -b << EOF
  TProof::Open("$1","workers=1x");
  gProof->Exec(".!hostname ; df -h $disk");
  .q
EOF
}

xferlog() {
  ff=$2
#  if [[ "$aaf" == "saf2" ]]; then
#  root -l -b << EOF
#      TProof::Open("$1","workers=1x");
#	  gProof->Exec(".!hostname; cat $3/xrootd/xrddm/$ff/xrddm*.log");
#  .q
#EOF	  
#  else
    root -l -b << EOF
      TProof::Open("$1","workers=1x");
	  gProof->Exec(".!hostname; cat $3/xrddm/$ff/xrddm*.log");
  .q
EOF
#  fi 
}

clearpackages() {
  root -l -b << EOF
  TProof::Open("$1","workers=8x");
  gProof->ClearPackages();
  .q
EOF
}

resetroot() {
  root -l -b << EOF
  TProof::Mgr("$1")->SetROOTVersion("current");
  .q
EOF
}

showds() {
  root -l -b << EOF
  TProof::Open("$1","masteronly");
  gProof->EnablePackage("$AFDSUTILS");
  if ( TString("$3") != "all" ) { afShowDsContent("$2","$3"); } else afShowDsContent("$2");
  .q
EOF
}

repairds() {
   root -l -b << EOF
  TProof::Open("$1","masteronly");
  gProof->EnablePackage("$AFDSUTILS");
  afRepairDs("$2","unstage:uncorrupt");
  .q
EOF
}

corrupt() {
   root -l -b << EOF
  TProof::Open("$1","masteronly");
  gProof->EnablePackage("$AFDSUTILS");
  afMarkUrlAs("$2","C","$3");
  .q
EOF
}

reset() {
  master=$1
  opt=`echo $2 | tr "[:upper:]" "[:lower:]"`
  hardreset=false
  if [[ $opt == "hard" ]]; then
    hardreset=true
  fi
  root -l -b << EOF
  TProof::Reset("$master",$hardreset);
  .q
EOF
}

lstxt() {
  root -l -b << EOF
  TProof::Open("$1","masteronly");
  gProof->Exec(".!rm /pool/PROOF-AAF/proof/dataset/MUON/laphecet/ls.txt");
  .q
EOF
}


showConfig()
{
  root -l -b << EOF
  TProof::Open("$1","masteronly");
  gProof->Exec(".!cat $2/proof/xproofd/prf-main.cf");
  .q
EOF
}

if [ $# -lt 2 ]; then
  usage
  return
fi

aaf=`echo $1 | tr "[:upper:]" "[:lower:]"`
what=$2
option="soft"
detail="all"
if [ $# -gt 2 ]; then
option=$3
fi
if [ $# -gt 3 ]; then
detail=$4
fi

master=""

logdir="/pool/PROOF-AAF/logs/"

homedir="/pool/PROOF-AAF"


if [[ "$aaf" == "caf" ]]; then
  master="alice-caf.cern.ch"
elif [[ "$aaf" == "saf" ]]; then
  source $HOME/Scripts/alice-saf-env.sh
  master="nansafmaster.in2p3.fr"
elif [[ "$aaf" == "saf2" ]]; then
  source $HOME/Scripts/alice-saf-env.sh
  master="nansafmaster2.in2p3.fr"
  logdir="/var/log"
  homedir="/home/PROOF-AAF"
elif [[ "$aaf" == "skaf" ]]; then
  master="skaf.saske.sk"
elif [[ "$aaf" == "kiaf" ]]; then
 master="kiaf.sdfarm.kr"
else
  echo "Unknown AF $aaf"
  return
fi

master="laphecet@$master/?N"

echo "what=$what master=$master option=$option detail=$detail"

case "$what" in
  ds)
    dataset $master "$option"
    ;;
  reset)
    reset $master $option
    ;;
  df)
  	df $master $aaf
  	;;
  clear)
    clearpackages $master
    ;;
  packages)
    showpackages $master $option
    ;;
  stagerlog)
    stagerlog $master $logdir
    ;;
  xrddmlog)
    xrddmlog $master
    ;;
  synclog)
    synclog $master
    ;;
  showds)
    showds $master $option $detail
    ;;
  repairds)
    repairds $master $option
    ;;
  xferlog)
    xferlog $master $option $logdir
    ;;
  resetroot)
    resetroot $master
  ;;
  lstxt)
    lstxt $master
  ;;
  corrupt)
  	corrupt $master $option $detail
  ;;
  conf)
  	showConfig $master $homedir
  ;;
  *)
    usage
esac


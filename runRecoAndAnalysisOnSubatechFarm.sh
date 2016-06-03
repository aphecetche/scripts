#!/bin/bash

rawCollectionFile="rawList.xml"
runCollectionFile="runList.xml"
runListTxtFile="runList.txt"
runCollectionFileLocal="runListLocal.txt"

currDir=`pwd`

EXIT=0
runListString=""
runLocalAnalysis=0
runLocalReco=0
isStandaloneRun=0
jobSubmission=0

################## User defined defaults values ##################
# General
baseAlienDir="/alice/data/2009/LHC09c"
baseOCDBdir="alien://folder=/alice/data/2009/OCDB"
baseOutDir="/scratch/aliced/stocco/gridAnalysis/cosmicRuns/cosmicRunAug09"
macroDir="$HOME/macros/gridAnalysis/cosmicRuns/cosmicRunAug09"

# Specific for job submission on farm
sourceEnvString="export BASEDIR=$BASEDIR; source $HOME/setAlirootEnv.sh HEAD09Jul09"
emailAddress="stocco@subatech.in2p3.fr"

# Specific for analysis
analysisType=2; # 1 -> use macro   2 -> use Analysis Train   anyOtherNum -> use both

# minor importance
recoScriptName="runReco.sh"
sleepTime=3
##################################################################



while getopts "o:r:alb:f:sm:t:jv:" option
do
  case $option in
    o ) baseOutDir=$OPTARG;;
    r ) runListString=$OPTARG;;
    a ) runLocalAnalysis=1;;
    l ) runLocalReco=1;;
    b ) baseAlienDir=$OPTARG;;
    f ) baseOCDBdir=$OPTARG;;
    s ) isStandaloneRun=1;;
    m ) macroDir=$OPTARG;;
    t ) analysisType=$OPTARG;;
    j ) jobSubmission=1;;
    v ) sourceEnvString=$OPTARG;;
    *     ) echo "Unimplemented option chosen."
    EXIT=1
    ;;
  esac
done

if [ ${jobSubmission} -eq 1 ]; then
    runLocalReco=1
fi

runLocal=0
if [ ${runLocalReco} -eq 1 ]; then
    runLocal=1;
fi
if [ ${runLocalAnalysis} -eq 1 ]; then
    runLocal=1;
fi

# look if there are some leftover options
shift $(($OPTIND - 1))

if [ $# -gt 0 ] || [ "$EXIT" -eq 1 ]; then
  echo "ERROR : extra option not recognized"
  echo "Usage: `basename $0` options (-o:r:alb:f:sm:tjv:)"
  echo "       -o output directory (default: baseOutDir)"
  echo "       -r list of runs"
  echo "       -a perform only local analysis"
  echo "       -l perform local reconstruction"
  echo "       -b base directory on alien (default: $baseAlienDir)"
  echo "       -f OCDB folder (default: $baseOCDBdir)"
  echo "       -s standalone run"
  echo "       -m directory with macros (default: $macroDir)"
  echo "       -t analysis type:  1 -> use macro   2 -> use Analysis Train   anyOtherNum -> use both"
  echo "       -j submit jobs on farm"
  echo "       -v string allowing to source aliroot version (default: $sourceEnvString)"
  exit 4;
fi


baseAlienRawDir="${baseAlienDir}"

if [ $isStandaloneRun -eq 1 ]; then
    baseAlienRawDir="${baseAlienDir}_MUON_TRG"
    echo "Stanbdalone run"
fi

myName=`whoami`

##################################
# Create output directory
##################################
function makeOutDir(){
    currOutDir="$1"

    if [ ${runLocalReco} -eq 1 ]; then
	if [ -e "${currOutDir}" ]; then
	    echo "Directory ${currOutDir}"
	    echo "already exist: Overwrite? [y/n]"
	    read decision
	    if [ $decision == "y" ]; then
		echo "Removing $currOutDir"
		rm -r $currOutDir
	    else
		return 1
	    fi
	fi
    fi

    if [ ! -e "${currOutDir}" ]; then
	echo ""
	echo "Creating directory $currOutDir"
	mkdir -p $currOutDir
    fi

    return 0
}


##################################
# Create run list from string
#################################
function createRunList(){
    inputRunList="$1"

    createList=1

    if [ -e ${runListTxtFile} ]; then
	echo "Run list exists: overwrite? [y/n]"
	read decision
	if [ $decision != "y" ]; then
	    createList=0
	else 
	    rm ${runListTxtFile}
	fi
    fi

    if [ $createList -eq 1 ]; then
	if [ ! "${inputRunList}" ]; then
	    echo "No file list given. Nothing done!"
	    return
	else
	    echo ""
	    echo "Creating run list..."
	    touch $runListTxtFile
	    for irun in $inputRunList; do
		echo "$irun" >> $runListTxtFile
	    done
	fi
    fi
  
    echo "Run list:"
    cat $runListTxtFile
}


##################################
# Create xml with raw data list 
# for reconstruction
# (Ideally 1 AliESDs.root per run
#################################
function createRecoXml(){
    alienDir="$1"
    echo ""
    echo "Creating raw list"
    alien_find -x collection ${alienDir}/raw/* *00*.root > ${rawCollectionFile}
}


##################################
# Run reconstruction
# (ideally 1 reco per run)
##################################
function runReconstruction(){
    currOutDir="$1"
    rawFileList="${currOutDir}/${rawCollectionFile}"

    echo ""
    echo "Running reconstruction ..."

    alienaliroot -b <<EOF >& testReco.out
AliLog::SetClassDebugLevel("AliMUONTrackHitPattern",1);
.x $macroDir/runDataReconstruction.C("collection://${rawFileList}","${baseOCDBdir}");
.q
EOF
}

##################################
# Generate reconstruction script
##################################
function GenerateRecoScript(){
    currOutDir="$1"
    rawFileList="${currOutDir}/${rawCollectionFile}"

    echo "echo \"--- This is $recoScriptName running as \$0\""
    echo "echo \"--- Using client:\""
    echo "hostname"

    echo ""
    echo "source /tmp/gclient_env_$UID"
    echo "$sourceEnvString"

    echo ""
    echo "echo \"Running reconstruction ...\""
    echo "cd $currOutDir"
    echo "aliroot -b <<EOF >& ${currOutDir}/testReco.out"
    echo ".x $macroDir/runDataReconstruction.C(\"collection://${rawFileList}\",\"${baseOCDBdir}\");"
    echo ".q"
    echo "EOF"
}


##################################
# Create xml with raw ESD.tag.root
# list for analysis
#################################
function createAnalysisXml(){
    baseAlienRunDir="$1"
    inputRunList="$2"

    if [ -e $runCollectionFile ]; then
	echo "Xml run list exists: overwrite? [y/n]"
	read decision
	if [ $decision != "y" ]; then
	    return
	fi
    fi
  
    echo ""
    echo "Creating xml..."
    echo "Run list:"
    cat $runListTxtFile

    alienaliroot -b <<EOF >& testMakeRunList.out 
.x $macroDir/makeXmlFromRunList.C+("*.ESD.tag.root","${runListTxtFile}","${runCollectionFile}","${baseAlienRunDir}",kTRUE)
.q
EOF
}


##################################
# Run analysis:
# - On grid if xml is given as input
# - Locally if a txt file with list of AliESDs.root 
#   is given as input
##################################
function runAnalysis(){
    runListFile="$1"

    echo ""
    echo "Running analysis ..."

    if [ $analysisType -ne 1 ]; then
	declare -a filesToLink=("AliAnalysisTaskTrigChEffPlus.h" "AliAnalysisTaskTrigChEffPlus.cxx")
	nFilesToLink=2;
	for((ifile=0; ifile<${nFilesToLink}; ifile++)){
	    ln -s "${macroDir}/${filesToLink[$ifile]}"
	}

	alienaliroot -b <<EOF >& testTriggerEfficiencyTrain.out
.x $macroDir/AnalysisTrigChEff.C("${runListFile}",kTRUE,".");
.q
EOF

	for((ifile=0; ifile<${nFilesToLink}; ifile++)){
	    if [ -L ${filesToLink[$ifile]} ]; then
		rm ${filesToLink[$ifile]}
	    elif [ -d ${filesToLink[$ifile]} ]; then
		rm -rf ${filesToLink[$ifile]}
	    fi
	}
	rm *_cxx.d
	rm *_cxx.so
    fi

    if [ $analysisType -ne 2 ]; then
	alienaliroot -b <<EOF >& testTriggerEfficiency.out
.x $macroDir/TriggerChamberEff.C+("${currOutDir}","${currOutDir}")
.q
EOF
    fi
}


##################################
# Copy/link/rm files for job submission
##################################
function filesForJobs(){
    alienEnvName="gclient_env_$UID"
    alienFileList="gclient_env_$UID gclient_token_$UID x509up_u$UID"
    for file in $alienFileList;
      do
      if [ $2 -eq 0 ]; then
	  echo "if [ -e $1/$file ]; then"
	  echo "  rm $1/$file"
	  echo "fi"
      elif [ $2 -eq 1 ]; then
	  #ln -s $1/$file /tmp/$file
	  echo "ln -s $1/$file /tmp/$file"
      else
	  cp -pu /tmp/$file $1/.
      fi
    done
}


##################################
# Submit jobs
##################################
function submitJob(){
    currRun=$1
    currOutDir=$2
    recoScriptFile=$3
    
    submittedJobs=`qstat -u $myName | grep -c $myName`
    while [ $submittedJobs -ge 10 ];
      do
      echo "Too many jobs in queue ($submittedJobs): waiting..."
      sleep 180;
      submittedJobs=`qstat -u $myName | grep -c $myName`
    done

    jobName="r_$1"
    echo "currRun $1"
    jobLog="$currOutDir/pbs${currRun}.o"

    /usr/bin/qsub -j oe -m "ae" -N $jobName -M "$emailAddress" -o "${jobLog}" $recoScriptFile
}


##################################
# Main loop
##################################
source /tmp/gclient_env_$UID
echo "Output dir: ${baseOutDir}"

outDir="${baseOutDir}"
makeOutDir "${outDir}"
cd $outDir
createRunList "${runListString}"

if [ ! -e "$runListTxtFile" ]; then
    echo ""
    echo "Please provide a list of runs"
    echo "exit"
    exit
fi

inputRunList=`cat $runListTxtFile | xargs`

if [ $runLocalReco -eq 1 ]; then
    for irun in ${inputRunList}; do
	irunGridDir="0000${irun}"
	outDir="${baseOutDir}/${irun}"
	alienDir="${baseAlienDir}/0000${irun}"
	makeOutDir "${outDir}"
	if [ $? -eq 1 ]; then 
	    continue
	fi
	cd $outDir
	createRecoXml "${alienDir}"
	if [ $jobSubmission -eq 1 ]; then
	    filesForJobs $outDir 2
	    recoScriptFile="$outDir/$recoScriptName"
	    touch $recoScriptFile
	    filesForJobs "${outDir}" 1 >> $recoScriptFile
	    GenerateRecoScript "${outDir}" >> $recoScriptFile
	    filesForJobs "${outDir}" 0 >> $recoScriptFile
	    submitJob $irun "${outDir}" $recoScriptFile
	    sleep $sleepTime
	else
	    runReconstruction "${outDir}"
	fi
    done
else
    outDir="${baseOutDir}"
    alienDir="${baseAlienDir}"
    makeOutDir "${outDir}"
    cd $outDir
    if [ $runLocal -eq 0 ]; then
	createAnalysisXml "${alienDir}" "${inputRunList}"
    fi
fi

if [ $jobSubmission -eq 0 ]; then # REMEMBER TO CHECK: so far I submit jobs only for reco
    outDir="${baseOutDir}"
    cd $outDir
    runAnalysisFile="$runCollectionFile"
    if [ $runLocal -eq 1 ]; then
	find $outDir -name "AliESDs.root" > $runCollectionFileLocal
	runAnalysisFile="$runCollectionFileLocal"
    fi

    runAnalysis "${runAnalysisFile}"
fi

echo ""
echo "Finished"  
echo "... see results in ${outDir}"
echo -ne "\a"

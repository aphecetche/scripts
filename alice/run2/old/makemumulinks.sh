#!/bin/sh

# make links in local directory to [DIR]/AliAnalysis*MuMu* 

usage() {
	echo "Usage : makemumulinks action [basedir]"
	echo " where action is link (default, then basedir must be specified) to create the links or unlink to destroy them"
}

classes=(PWG/muon/AliAnalysisMuMuBase PWG/muon/AliAnalysisMuMuBinning PWG/muon/AliAnalysisMuMuCutCombination PWG/muon/AliAnalysisMuMuCutElement PWG/muon/AliAnalysisMuMuCutRegistry PWG/muon/AliAnalysisMuMuEventCutter PWG/muon/AliAnalysisMuMuGlobal PWG/muon/AliAnalysisMuMuMinv PWG/muon/AliAnalysisMuMuNch PWG/muon/AliAnalysisMuMuSingle PWG/muon/AliAnalysisMuonUtility PWG/muon/AliAnalysisTaskMuMu PWG/muon/AliMergeableCollection PWG/muon/AliMuonEventCuts PWG/muon/AliMuonTrackCuts PWG/muon/AliOADBMuonTrackCutsParam PWG/muon/AliAnalysisMuMuDiffractive)
link() {	
	for f in ${classes[*]}
	do
		for ext in h cxx
		do
			if [ -f $1/$f.$ext ]; then
				ln -si $1/$f.$ext .
  				echo "$f.$ext successfully linked"
			else
  				echo "did not find $1/$f.$ext"
			fi	
		done
	done
}

unlink() {	
	for bf in ${classes[*]}
	do
		f=`basename $bf`
		for ext in h cxx
		do
			if [ -L $f.$ext ]; then
				rm $f.$ext
  				echo "$f.$ext successfully unlinked"
			else	
  				echo "$f.$ext not found"
			fi
		done
	done
}

if [ $# -lt 1 ]; then
  usage
  return
fi

action=$1
basedir=""

if [ $# -gt 1 ]; then
  basedir=$2
fi

case "$action" in
	link)
		link $basedir
		;;
	unlink)
		unlink
		;;
	*)
	usage
esac




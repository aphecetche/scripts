# script to setup a correct environment to work with Alice software
#

# you'll want to change this obviously to reflect your name and location
export alien_API_USER=laphecet
export alien_CLOSE_SE=ALICE::Subatech::DPM

# as well as this...
source $HOME/Scripts/alice-topdir.sh

# --- things below should not have to be changed

if [ $# -gt 1 ]; then
  echo "Too many parameters. Exiting"
  return
fi

if [ $# -eq 1 ]; then
  ALICE="$ALICETOPDIR/AliRoot/$1"
  # use xname only if interactive shell
  [ -z "$PS1" ] || xname $1
else
  # default to Dev/trunk
  ALICE="$ALICETOPDIR/AliRoot/Dev/trunk"
  # use xname only if interactive shell
  [ -z "$PS1" ] || xname Dev/trunk
fi

export ALICE

export ROOTSYS=$ALICE/root
export ALICE_ROOT=$ALICE/aliroot
export GEANT3=$ALICE/geant3

if [ -f $ROOTSYS/bin/root-config ]; then
    export ALICE_TARGET=`$ROOTSYS/bin/root-config --arch`
else
    echo "Could not find $ROOTSYS/bin/root-config. ROOT probably not installed. Exiting"
    return
fi

ldpath=.:$GEANT3/lib/tgt_${ALICE_TARGET}:${ALICE_ROOT}/lib/tgt_${ALICE_TARGET}:$ROOTSYS/lib:${ALICE_ROOT}/SHUTTLE/TestShuttle

set +o nounset

testmac=`which otool 2> /dev/null`;

if [ x$testmac = "x" ]; then
    if [ -z "$LD_LIBRARY_PATH" ]; then
	export LD_LIBRARY_PATH=$ldpath:${LD_LIBRARY_PATH}
    else
	export LD_LIBRARY_PATH=$ldpath
    fi
else
    if [ -z "$DYLD_LIBRARY_PATH" ]; then
	export DYLD_LIBRARY_PATH=$ldpath:${DYLD_LIBRARY_PATH}
    else
	export DYLD_LIBRARY_PATH=$ldpath
    fi
fi

set -o nounset

export PATH=${ROOTSYS}/bin:${ALICE_ROOT}/bin/tgt_${ALICE_TARGET}:$PATH:/opt/alien/api/bin:/usr/local/bin

# For IRST Rule Checker
export IRST_INSTALLDIR=${HOME}/Alice/ALICENewRuleChecker
#export CLASSPATH=${IRST_INSTALLDIR}
#export PATH=${PATH}:${CLASSPATH}/syntax

alias mchl='source $HOME/Scripts/alien-command-wrapper.sh mchview'
alias rl='source $HOME/Scripts/alien-command-wrapper.sh root'
alias al='source $HOME/Scripts/alien-command-wrapper.sh aliroot'
alias el='source $HOME/Scripts/alien-command-wrapper.sh alieve'

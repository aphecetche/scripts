# script to setup a correct environment to work with Alice software
#

[[ ${ALICE_ROOT+set} = set ]] && return

# you may need to change this
source $HOME/Scripts/alice-alien-env.sh

# as well as this...
source $HOME/Scripts/alice-topdir.sh

# --- things below should not have to be changed

if [ $# -gt 2 ]; then
  echo "Too many parameters ($#). Exiting"
  echo "$1 -> $2 -> $3"
  return
fi

EXTRA=""

if [ -n "$DATE_ROOT" ]; then
EXTRA="-with-DATE"
echo "**************************************"
echo "WILL USE THE DATE VERSION OF ALIROOT !" 
echo "**************************************"
fi

if [ $# -ge 1 ]; then
  export ALICE="$ALICETOPDIR/AliRoot/$1"
  export ALICE_BUILD="$ALICETOPDIR/Build/AliRoot/$1$EXTRA"
  export ALICE_INSTALL="$ALICETOPDIR/Install/AliRoot/$1$EXTRA"
  # use xname only if interactive shell
  set +o nounset
  [ -z "$PS1" ] || xname $1$EXTRA
  set -o nounset
else
  # default to Dev/master
  export ALICE="$ALICETOPDIR/AliRoot/Dev/master"
  export ALICE_BUILD="$ALICETOPDIR/Build/AliRoot/Dev/master$EXTRA"
  export ALICE_INSTALL="$ALICETOPDIR/Install/AliRoot/Dev/master$EXTRA"
  # use xname only if interactive shell
  set +o nounset
  [ -z "$PS1" ] || xname Dev/master$EXTRA
  set -o nounset
fi

if [ $# -eq 2 ]; then
OPTION=$2
else
OPTION=""
fi

#export ALICE

export ALICE_ROOT=$ALICE/aliroot
export GEANT3=$ALICE/geant3

if [ ! -d $ALICE_BUILD ]; then
	echo "Direction $ALICE_BUILD does not exist !"
	return
fi

if [ ! -d $ALICE_INSTALL ]; then
	echo "Direction $ALICE_INSTALL does not exist !"
	return
fi

if [ -f "$ALICE/root/bin/root-config" ]; then
    export ROOTSYS=$ALICE/root
    export ALICE_TARGET=`$ROOTSYS/bin/root-config --arch`
else
    echo "Could not find $ROOTSYS/bin/root-config. ROOT probably not installed. Exiting"
    return
fi

ldpath=.:$ROOTSYS/lib:$GEANT3/lib/tgt_${ALICE_TARGET}

#:${ALICE_INSTALL}/SHUTTLE/TestShuttle

if [ "$OPTION" == "train" ]; then
ldpath=$ldpath:/opt/local/lib
fi

ldpathcmake=${ALICE_INSTALL}/lib/tgt_${ALICE_TARGET}

ldpath=${ldpath}:${ldpathcmake}

    if [ "${LD_LIBRARY_PATH+set}" = set ]; then
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$ldpath
    else
	export LD_LIBRARY_PATH=$ldpath
    fi

set -o nounset

export PATH=$PATH:${ROOTSYS}/bin:${ALICE_INSTALL}/bin/tgt_${ALICE_TARGET}:/usr/local/bin

# For IRST Rule Checker
export IRST_INSTALLDIR=${HOME}/Alice/ALICENewRuleChecker
#source $GSHELL_ROOT/etc/env_gbbox.sh

export DYLD_LIBRARY_PATH=${LD_LIBRARY_PATH}

# those to insure CMAKE is using the correct compilers...
export CC=`root-config --cc`
export CXX=`root-config --cxx`
export F77=`root-config --f77`
export LD=`root-config --ld`


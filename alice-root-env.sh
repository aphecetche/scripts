
[[ "${ROOTSYS+set}" = set ]] && return

if [ $# -eq 1 ]; then
  export ROOTSYS=$HOME/Alice/Root/$1
else
  export ROOTSYS=$HOME/Alice/Root/latest
fi

export PATH=${PATH}:${ROOTSYS}/bin

if [[ ${LD_LIBRARY_PATH+set} = set ]]; then

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib

else

    export LD_LIBRARY_PATH=$ROOTSYS/lib

fi





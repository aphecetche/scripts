# build aliroot version for run specified in $1 and version $2
# using alibuild

run=$1

if [[ "$run" != "run2" && "$run" != "run3" ]]; then
  echo "I only know how to work with run2 or run3, not with $1..."
  return
fi

aliroot=$2

echo "run=$run"
echo "aliroot=$aliroot"

DISABLED="fastjet,GEANT4,GEANT4_VMC,HepMC,EPOS,JEWEL"

#alibuild -z -w ~/alicesw/$run/sw --disable $DISABLED build AliRoot
pushd ~/alicesw/$run/sw/BUILD/AliRoot-latest-$aliroot/AliRoot
make -j9 install

echo "PIPESTATUS=${PIPESTATUS[0]}"



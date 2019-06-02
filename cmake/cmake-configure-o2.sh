#!/usr/bin/env sh
# in CMAKE_PREFIX_PATH the ;-list of directories where to find <package>Config.cmake files ... (i.e. by CONFIG in find_package)
# in CMAKE_MODULE_PATH the list of directories where to find Find<package>.cmake files ... (i.e. MODULE in find_package)
#
# for some reason the FairRoot/FindPythia6.cmake is looking for libPythia with a capital P. So pythia6 is found
# iif Pythia6_LIBRARY_DIR points to the correct directory directly...

simulation=0
buildtype=Debug
generator=Ninja
basedir=cmake

while [[ $# -gt 0 ]]; do
  case "$1" in
    --simulation)
      simulation=1
      shift 1
    ;;
    ---build-type)
      buildtype="$2"
      shift 2
    ;;
    --generator)
      generator="$2"
      shift 2
    ;;
  --basedir)
      basedir="$2"
      shift 2
    ;;
    *)
      echo "Parameter unknown: $1" >&2
      exit 1
    ;;
  esac
done

source=$HOME/alice/${basedir}/O2
deplocation=$HOME/alice/${basedir}/sw
dest=$HOME/alice/${basedir}/sw/
version=latest
label=standalone

install_prefix=$HOME/alice/${basedir}/standalone/O2/install-${buildtype}

# echo "simulation=$simulation"
# echo "buildtype=$buildtype"
# echo "generator=$generator"
# echo "source=$source"
# echo "basedir=$basedir"
# echo "-"
# echo "deplocation=$deplocation"
# echo "dest=$dest"
# echo "install_prefix=$install_prefix"

case $OSTYPE in
linux*)
	g3lib=lib64
	ddlext=so
	platform=slc7_x86-64
	;;
darwin*)
	g3lib=lib
	ddlext=dylib
	platform=osx_x86-64
	;;
esac

basecmd=$(
cat << EOF
cmake $source \
\
-G "$generator" \
-DCMAKE_CXX_STANDARD=17 \
-DCMAKE_CXX_STANDARD_REQUIRED=TRUE \
-DCMAKE_INSTALL_PREFIX=$install_prefix \
-DBUILD_TESTING=ON \
-DCMAKE_BUILD_TYPE=$buildtype \
-DDDS_ROOT=$deplocation/$platform/DDS/$version \
-Dprotobuf_ROOT=$deplocation/$platform/protobuf/$version \
-DCommon_ROOT=$deplocation/$platform/Common-O2/$version \
-DConfiguration_ROOT=$deplocation/$platform/Configuration/$version \
-DMonitoring_ROOT=$deplocation/$platform/Monitoring/$version \
-DFairMQ_ROOT=$deplocation/$platform/FairMQ/$version \
-DFairLogger_ROOT=$deplocation/$platform/FairLogger/$version \
-DFairRoot_ROOT=$deplocation/$platform/FairRoot/$version \
-DInfoLogger_ROOT=$deplocation/$platform/libInfoLogger/$version \
-DBOOST_ROOT=$deplocation/$platform/boost/$version \
-DROOT_ROOT=$deplocation/$platform/ROOT/$version \
-DRapidJSON_ROOT=$deplocation/$platform/RapidJSON/$version \
-DCMAKE_MODULE_PATH="$source/cmake/modules;$deplocation/$platform/FairRoot/$version/share/fairbase/cmake/modules" \
-DCMAKE_PREFIX_PATH="$deplocation/$platform/ROOT/$version;$deplocation/$platform/Vc/$version;"  \
-DProtobuf_LIBRARY=$deplocation/$platform/protobuf/$version/lib/libprotobuf.$ddlext \
-DProtobuf_LITE_LIBRARY=$deplocation/$platform/protobuf/$version/lib/libprotobuf-lite.$ddlext \
-DProtobuf_PROTOC_LIBRARY=$deplocation/$platform/protobuf/$version/lib/libprotoc.$ddlext \
-DProtobuf_INCLUDE_DIR=$deplocation/$platform/protobuf/$version/include \
-DProtobuf_PROTOC_EXECUTABLE=$deplocation/$platform/protobuf/$version/bin/protoc \
-Darrow_DIR=$deplocation/$platform/arrow/$version/lib/cmake/arrow \
-Dbenchmark_DIR=$deplocation/$platform/googlebenchmark/$version/lib/cmake/benchmark 
-Dms_gsl_ROOT=$deplocation/$platform/ms_gsl/$version/include
EOF
)

simcmd=$(
	cat <<EOF
$basecmd \
-DBUILD_SIMULATION=ON \
-DCMAKE_PREFIX_PATH="$deplocation/$platform/ROOT/$version;$deplocation/$platform/Vc/$version;$deplocation/$platform/GEANT3/$version;$deplocation/$platform/GEANT4/$version;$deplocation/$platform/vgm/$version"  \
-DPythia6_LIBRARY_DIR=$deplocation/$platform/pythia6/$version/lib \
-DPythia8_DIR=$deplocation/$platform/pythia/$version/ \
-DGeant3_DIR=$deplocation/$platform/GEANT3/$version \
-DGeant4_DIR=$deplocation/$platform/GEANT4/$version \
-DGEANT4VMC_DIR=$deplocation/$platform/GEANT4_VMC/$version/lib/Geant4VMC-3.6.3 \
-DVGM_DIR=$deplocation/$platform/vgm/$version
EOF
)

cmd=$(
echo $basecmd
)

if [[ "$simulation" == "yes" ]]; then
  echo "would do sim"
  eval "$simcmd"
else
  echo "would do without sim"
  eval "$cmd"
fi



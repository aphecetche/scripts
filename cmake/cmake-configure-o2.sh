# in CMAKE_PREFIX_PATH the ;-list of directories where to find <package>Config.cmake files ... (i.e. by CONFIG in find_package)
# in CMAKE_MODULE_PATH the list of directories where to find Find<package>.cmake files ... (i.e. MODULE in find_package)
#
# for some reason the FairRoot/FindPythia6.cmake is looking for libPythia with a capital P. So pythia6 is found
# iif Pythia6_LIBRARY_DIR points to the correct directory directly...

generator=${1:-Ninja}
source=${2:-"/Users/laurent/alice/o2-dev/O2"}
install=${3:-"/Users/laurent/alice/sw/"}
dest=${4:-"/Users/laurent/alice/sw/"}
label=${5:-"$version"}
version=${6:-"latest-dpl-mch-test-o2-ninja"}

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

cmd=$(
	cat <<EOF
cmake $source \
-DCMAKE_INSTALL_PREFIX=$dest/$platform/$label \
-DALICEO2_MODULAR_BUILD=ON \
-DFairRoot_DIR=$install/$platform/FairRoot/$version/ \
-DBOOST_ROOT=$install/$platform/boost/$version/ \
-DROOTSYS=$install/$platform/ROOT/$version/ \
-DGeant3_DIR="$install/$platform/GEANT3/$version/$g3lib/Geant3-2.5.0" \
-DGeant4_DIR="$install/$platform/GEANT4/$version/lib/Geant4-10.3.3" \
-DGeant4VMC_DIR="$install/$platform/GEANT4_VMC/$version/lib/Geant4VMC-3.5.0" \
-DVGM_DIR="$install/$platform/vgm/$version/lib/VGM-4.4.0" \
-DVc_DIR="$install/$platform/Vc/$version/lib/cmake/Vc" \
-DCMAKE_LIBRARY_PATH="$install/$platform/vgm/$version/lib;$install/$platform/GEANT4_VMC/$version/lib;$install/$platform/GEANT4/$version/lib;$install/$platform/GEANT3/$version/$g3lib;$install/$platform/ROOT/$version" \
-DCMAKE_MODULE_PATH="$source/cmake/modules;$install/$platform/FairRoot/$version/share/fairbase/cmake/modules" \
-DPythia6_LIBRARY_DIR=$install/$platform/pythia6/$version/lib \
-DPYTHIA8_DIR=$install/$platform/pythia/$version/ \
-DPYTHIA8_INCLUDE_DIR=$install/$platform/pythia/$version/include \
-DProtobuf_LIBRARY=$install/$platform/protobuf/$version/lib/libprotobuf.$ddlext \
-DProtobuf_LITE_LIBRARY=$install/$platform/protobuf/$version/lib/libprotobuf-lite.$ddlext \
-DProtobuf_PROTOC_LIBRARY=$install/$platform/protobuf/$version/lib/libprotoc.$ddlext \
-DProtobuf_INCLUDE_DIR=$install/$platform/protobuf/$version/include \
-DProtobuf_PROTOC_EXECUTABLE=$install/$platform/protobuf/$version/bin/protoc \
-DMonitoring_ROOT=$install/$platform/Monitoring/$version \
-DConfiguration_ROOT=$install/$platform/Configuration/$version \
-DDDS_PATH=$install/$platform/DDS/$version/ \
-DRAPIDJSON_INCLUDEDIR=$install/$platform/RapidJSON/$version/include \
-Dbenchmark_DIR=$install/$platform/googlebenchmark/$version/lib/cmake/benchmark \
-DMS_GSL_INCLUDE_DIR=$install/$platform/ms_gsl/$version/include \
-DALITPCCOMMON_DIR=$install/$platform/AliTPCCommon/$version \
-DBUILD_TESTING=OFF \
-DCMAKE_BUILD_TYPE=Debug \
-DCMAKE_CXX_STANDARD=14 \
-G "$generator"
EOF
)

#export LD_LIBRARY_PATH="$install:$platform/lib"
#eval "$cmd"

# uncomment the line below to generate a piece of JSON suitable for insertion in VSCode settings.json file
# for CMake Tools extension.
echo $cmd | tr " " "\n" | grep "^-D" | awk '{ print "\"" $1"\","}' | sed s/-D//g | sed s/=/\":\"/g | sed s_\/\/_\/_g | sed s/\"\"/\"/g

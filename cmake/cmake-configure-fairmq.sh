cmake -DCMAKE_INSTALL_PREFIX=../install -G Ninja \
$HOME/github.com/FairRootGroup/FairMQ \
-DBOOST_ROOT=$HOME/alice/sw/osx_x86-64/boost/latest \
-DGTEST_ROOT=$HOME/alice/sw/osx_x86-64/googletest/latest \
-DBUILD_NANOMSG_TRANSPORT=OFF \
-DBUILD_DDS_PLUGIN=ON \
-DDDS_ROOT=$HOME/alice/sw/osx_x86-64/DDS/latest-run3-o2
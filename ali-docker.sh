#!/bin/zsh
# run a container with the source locally on the Mac
#

version=${1:="feature-reco-2016"}

echo $version

xdrun -v /Users/laurent/alicesw/run2/aliroot-$version/AliRoot:/alicesw/AliRoot -v /Users/laurent/alicesw/repos/AliRoot:/Users/laurent/alicesw/repos/AliRoot --name $version aphecetche/centos7-feature-reco-2016 

# if the complete image is not done alread, have to build it with :
# docker run -v /Users/laurent/alicesw/run2/aliroot-$version/AliRoot:/alicesw/AliRoot -v /Users/laurent/alicesw/repos/AliRoot:/Users/laurent/alicesw/repos/AliRoot --name $version aphecetche/centos7-alibase 
# and then build aliroot inside
#
# cd /alicesw
# alibuild/aliBuild --disable GEANT4,GEANT4_VMC,fastjet --debug build AliRoot

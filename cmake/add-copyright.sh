#!/bin/sh

# Batch apply the Copyright notice to all CMakeLists.txt files
# and apply cmake-format.
#

read -r -d '' COPY <<EOM
# Copyright CERN and copyright holders of ALICE O2. This software is
# distributed under the terms of the GNU General Public License v3 (GPL
# Version 3), copied verbatim in the file "COPYING".
#
# See http://alice-o2.web.cern.ch/license for full licensing information.
#
# In applying this license CERN does not waive the privileges and immunities
# granted to it by virtue of its status as an Intergovernmental Organization
# or submit itself to any jurisdiction.
EOM

find . -name CMakeLists.txt | while read file; do
  echo $file
  cmake-format -i $file
  # echo "$COPY\n" >$file.tmp
  # cat $file >>$file.tmp
  # mv $file.tmp $file
done

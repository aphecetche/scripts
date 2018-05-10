#!/bin/sh

# extract a few events from a raw data event file

#rm -rf /tmp/raw /tmp/temp.date /tmp/rawdata 

#mkdir /tmp/raw
#deroot $1 /tmp/temp.date /tmp/raw

# just hit CTRL-C to end before the end of the file

# extract the MUONTRK par 

mkdir /tmp/rawdata
for ((N=440;N<460;N++)) ; do mkdir /tmp/rawdata/raw$N ; 
cp /tmp/raw/raw$N/MUON*.ddl /tmp/rawdata/raw$N/ ; done
cd /tmp ; tar cjf rawdata.tar.bz2 rawdata

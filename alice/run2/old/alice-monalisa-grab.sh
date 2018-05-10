#!/bin/bash

#prodUrlInMonalisa="http://alimonitor.cern.ch/prod/jobs.jsp?t=1835&outputdir=muon" 
#alirootInMonalisa="v5-01-Rev" #"v5-01-Rev-12" #"v5-02-09-AN"

prodUrlInMonalisa=$1 #"http://alimonitor.cern.ch/prod/jobs.jsp?t=2593" 
alirootInMonalisa=$2 #"v5-02-Rev" #"v5-01-Rev-12" #"v5-02-09-AN"
type=$3 # ESD or AOD

if [ $type == "ESD" ]; then

curl -s "${prodUrlInMonalisa}" | awk -v aliRev="${alirootInMonalisa}" ' {
      if ( index($0,"runview")) {
        currLine=$0; gsub("\"","",currLine); split(currLine,arr,"=");
        currRun=arr[3];
        while ( index($0,"table_row") == 0 ) getline;
        for ( iline=0; iline<1; iline++ ) getline;
    split($0,arr,">"); split(arr[2],finArr,"<");
    filteredEvents=finArr[1];
        getline;
        while ( index($0,"table_row") == 0 ) getline;
    for ( iline=0; iline<1; iline++ ) getline;
        alirootRevLine=$0;
    for ( iline=0; iline<2; iline++) getline;
        split($0,arr,">"); split(arr[2],finArr,"<");
    percentdone=finArr[1];
    if (index(alirootRevLine,aliRev)) print currRun," ",percentdone; } } ' 

else

curl -s "${prodUrlInMonalisa}" | awk -v aliRev="${alirootInMonalisa}" ' {
      if ( index($0,"runview")) {
        currLine=$0; gsub("\"","",currLine); split(currLine,arr,"=");
        currRun=arr[3];
        while ( index($0,"table_row") == 0 ) getline;
        for ( iline=0; iline<3; iline++ ) getline;
    split($0,arr,">"); split(arr[2],finArr,"<");
    filteredEvents=finArr[1];
        getline;
        while ( index($0,"table_row") == 0 ) getline;
    for ( iline=0; iline<1; iline++ ) getline;
        alirootRevLine=$0;
    for ( iline=0; iline<2; iline++) getline;
        split($0,arr,">"); split(arr[2],finArr,"<");
    percentdone=finArr[1];
    if (index(alirootRevLine,aliRev)) print currRun," ",percentdone; } } ' 

fi

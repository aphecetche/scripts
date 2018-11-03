#!/bin/bash

filelist=${1:-files.list}

if [[ -d $filelist ]]; then
  echo "$filelist is not a filelist but a directory"
  return 2
fi

filter=${2:-NONE}

prefix=${filelist%%.*}

workdir=$prefix

hosts=( nansaf02 nansaf03 nansaf04 nansaf05 nansaf06 nansaf07 nansaf08 nansaf09 nansaf11 )

index=0
n=0

# create the output working directory, named
# from the file list prefix
mkdir -p $workdir
rm -rf $workdir/*

# copy the condor submit script and the staging script into 
# the working directory
cp stage-one.sh stage.condor $workdir/

submitlist=$workdir/submitlist.txt

# split the filelist into n filelists, where n = number of hosts
for f in $(cat $filelist);
do
  if [[ $f =~ /alice ]]; then
    echo ${hosts[$index]},$f,$filter >> $submitlist
    (( index++ ))
    if [[ $index -ge ${#hosts[*]} ]]; then
     index=0
     (( n++ )) 
    fi
    if [[ $n -eq 2 ]]; then
       break
    fi
  fi
done

echo "# Now you should : "
echo "cd $workdir"
echo "# Review the files that were generated in that directory and then :"
echo "condor_submit stage.condor"


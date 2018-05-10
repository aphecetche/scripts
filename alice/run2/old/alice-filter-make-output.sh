#!/bin/sh

packages=( ACORDE ALIROOT ANALYSIS BCM CORRFW DPMJET EMCAL EPOS ESDCheck EVE EVGEN FASTSIM FMD GRP HERWIG HIJING HLT \
HMPID ITS MONITOR MUON PHOS PMD PWG0 PWG1 PWG2 PWG3 PWG4 RAW SHUTTLE STAT STEER STRUCT T0 TOF TPC TRD TRIGGER VZERO ZDC )

line=$1

   for rep in ${packages[@]:0}
   do
       line=$(echo "$line"| sed -e "s#$rep/#${ALICE_ROOT}/$rep/#")
   done

exit

   if [[ "$line" =~ "warning" ]]; then
       echo "warning=$line"
       if   [[ "$line" =~ "/root/include" ]]; then
# suppress root warnings we do not really care about...	 
	   suppress=1
       else
	   echo "$line"	   
       fi
   else
       echo "$line"
   fi

   if  [[ "$line" =~ Stop ]] || [[ "$line" =~ Error ]]
     then
       rv=1
     else
       rv=0
   fi

   done

exit $rv



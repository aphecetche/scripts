WIP : SAF staging revamp

Goals :
- Stage data to SAF using only condor jobs (i.e. without Proof)
- Stage data correctly balanced between the 10 servers (knowing that current staging with proof leads to major unbalances)

The starting point is a list of files to be staged. For instance using `alien_find` :

```
> alien_find /alice/data/2015/LHC15o/000246087/pass1/15*.9*  AliESDs.root > files.list
> cat files.list
...
/alice/data/2015/LHC15o/000246087/pass1/15000246087039.9807/AliESDs.root
/alice/data/2015/LHC15o/000246087/pass1/15000246087039.9808/AliESDs.root
/alice/data/2015/LHC15o/000246087/pass1/15000246087039.9809/AliESDs.root
/alice/data/2015/LHC15o/000246087/pass1/15000246087039.9810/AliESDs.root
/alice/data/2015/LHC15o/000246087/pass1/15000246087039.9811/AliESDs.root
/alice/data/2015/LHC15o/000246087/pass1/15000246087039.9812/AliESDs.root
/alice/data/2015/LHC15o/000246087/pass1/15000246087039.9813/AliESDs.root
/alice/data/2015/LHC15o/000246087/pass1/15000246087039.9814/AliESDs.root
/alice/data/2015/LHC15o/000246087/pass1/15000246087039.9900/AliESDs.root
/alice/data/2015/LHC15o/000246087/pass1/15000246087039.9901/AliESDs.root
...
```

That list is then split into 10 (because there are 10 servers in SAF), one list per server. 

This is in this first splitting that we insure the balance between server (or, if need be, we could imagine to introduce some unbalance).

Each of those 10 lists is used as the input to a condor _master_ job. 

Each master job in turn splits further the list into manageable chunks (250 files by default). 

Each chunk is a single condor job that will use the  `aaf-stage-and-filter` executable (from the AliPhysics version specified) to perform the staging.





WIP : SAF staging revamp

Goals :
- Stage data to SAF using only condor jobs (i.e. without Proof)
- Stage data correctly balanced between the 10 servers (knowing that current staging with proof leads to major unbalances)

The starting point is a list of files to be staged. For instance using `alien_find` :

```
> alien_find /alice/data/2015/LHC15o/000246087/pass1/15*.9*  AliESDs.root > esd-muon-246087.list
> cat esd-muon-246087.list
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

That list is then used as the input of the `stage.sh` script which will prepare a `submitlist.txt` file where each line specify the destination hostname, the remote filename and the filter to be used. That list is generated into a directory named after the file list filename, e.g. `esd-muon-246087` in the example above.

The condor _master_ job uses this `submitlist.txt` file to spawn the jobs (one job per file transfer). 

Each single condor job will use the  `aaf-stage-and-filter` executable (from the AliPhysics version specified) to perform the actual staging.





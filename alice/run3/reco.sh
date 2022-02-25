
config="MCHTracking.chamberResolutionX=1;MCHTracking.chamberResolutionY=1;MCHTracking.refineTracks=false"
shared_mem_size=16000000000

date > reco.start.txt

o2-ctf-reader-workflow --ctf-input \
  ./o2_ctf_run00505645_orbit0035545150_tf0000276227.root \
  --onlyDet MCH \
  --ctf-dict $HOME/alice/data/ctf_dictionary.root \
  --shm-segment-size ${shared_mem_size} | \
o2-mch-digits-filtering-workflow --disable-mc | \
o2-mch-digits-to-timeclusters-workflow \
  --only-trackable | \
o2-mch-digits-to-preclusters-workflow --pipeline mch-preclustering:1 \
  --discard-high-occupancy-des | \
o2-mch-preclusters-to-clusters-original-workflow \
  --pipeline mch-cluster-finder-original:1 | \
o2-mch-clusters-transformer-workflow | \
o2-mch-clusters-to-tracks-workflow \
  --configKeyValues ${config} \
  --pipeline mch-track-finder:1 | \
o2-mch-tracks-writer-workflow | \
o2-dpl-run --run 

date > reco.end.txt

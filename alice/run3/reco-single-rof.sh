config="MCHTracking.chamberResolutionX=1;MCHTracking.chamberResolutionY=1;MCHTracking.refineTracks=false"

o2-ctf-reader-workflow --ctf-input \
  ./o2_ctf_run00505645_orbit0035545150_tf0000276227.root \
  --onlyDet MCH \
  --ctf-dict $HOME/alice/data/ctf_dictionary.root \
  --shm-segment-size 8000000000 | \
o2-mch-digits-filtering-workflow --disable-mc --single-rof | \
o2-mch-digits-to-preclusters-workflow --pipeline mch-preclustering:2 \
  --input-digits-data-description F-DIGITS \
  --input-digitrofs-data-description F-DIGITROFS | \
o2-mch-preclusters-to-clusters-original-workflow \
  --pipeline mch-cluster-finder-original:4 | \
o2-mch-clusters-transformer-workflow | \
o2-mch-clusters-to-tracks-workflow \
  --configKeyValues ${config} \
  --pipeline mch-track-finder:2 | \
o2-mch-tracks-writer-workflow | \
o2-dpl-run --run

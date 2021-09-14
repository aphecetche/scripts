#!/bin/sh

dir=$ALIBUILD_WORK_DIR/BUILD/O2-latest/O2/stage/bin
N=10
RATE=10
limitrate=
limitrate=--rate $RATE

for ((i = 0; i < $N; i++)); do
${dir}/o2-mch-clusters-sampler-workflow -b ${limitrate} \
--infile $HOME/cernbox/o2muon/clusters.O2.in | \
${dir}/o2-mch-clusters-sink-workflow -b --outfile $i.txt --txt
done

checksum=$(md5sum 0.txt | cut -f1 -d ' ')
echo "checksum=$checksum"

for ((i = 1; i < $N; i++)); do
  c=$(md5sum $i.txt | cut -f1 -d ' ')
  echo "i $i c $c vs $checksum"
  [[ "$c" != "$checksum" ]] && echo "file $i is different from file $0" && exit 1
done

exit 0

# o2-mch-clusters-sampler-workflow --infile "clusters.O2.in" | o2-mch-clusters-sink-workflow --outfile « clusters.O2.in.txt" --txt

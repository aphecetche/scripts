runfilelist="fill.$1.txt"
if [ ! -f "$runfilelist" ]; then
  echo "file fill.$1.txt does not exist. Assuming we're given a full filename"
  runfilelist="$1"
fi

root -b -l << EOF
.x loadlibs.C
AliAnalysisTriggerScalers ts("$runfilelist","local:///Users/laurent/Alice/OCDBcopy2011");
ts.IntegratedLuminosity("CPBI2_B1-B-NOPF-ALLNOTRD,CPBI1MUL-B-NOPF-MUON,CPBI1MSL-B-NOPF-MUON,CPBI1MSH-B-NOPF-MUON","CVLN-B-NOPF-ALLNOTRD",4100,"",'\t',"mb"); > pbpb.integrated.lumi.$1.txt
EOF


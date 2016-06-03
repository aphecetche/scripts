runfilelist="fill.$1.txt"
if [ ! -f "$runfilelist" ]; then
  echo "file fill.$1.txt does not exist. Assuming we're given a full filename"
  runfilelist="$1"
fi

root -b -l << EOF
.x loadlibs.C
AliAnalysisTriggerScalers ts("$runfilelist","local:///Users/laurent/Alice/OCDBcopy");
ts.IntegratedLuminosity("CMSH7-B-NOPF-MUON,CMUL7-B-NOPF-MUON,CMSL7-B-NOPF-MUON,CEMC7-B-NOPF-CENTNOTRD,CEMC7EG1-B-NOPF-CENTNOTRD,CEMC7EG2-B-NOPF-CENTNOTRD,CEMC7EJ1-B-NOPF-CENTNOTRD,CEMC7EJ2-B-NOPF-CENTNOTRD","C0TVX-B-NOPF-ALLNOTRD",1520,"",'\t',"ub");  > integrated.lumi.$1.txt
EOF


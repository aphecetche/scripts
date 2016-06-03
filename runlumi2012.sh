runfilelist="fill.$1.txt"
if [ ! -f "$runfilelist" ]; then
  echo "file fill.$1.txt does not exist. Assuming we're given a full filename"
  runfilelist="$1"
fi

root -b -l << EOF
.x loadlibs.C
AliAnalysisTriggerScalers ts("$runfilelist","local:///Users/laurent/Alice/OCDBcopy2012");
ts.IntegratedLuminosity("","C0TVX-S-NOPF-ALLNOTRD",28,"",'\t',"nb");  > test.integrated.lumi.$1.txt

EOF

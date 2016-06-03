runfilelist="fill.$1.txt"
if [ ! -f "$runfilelist" ]; then
  echo "file fill.$1.txt does not exist. Assuming we're given a full filename"
  runfilelist="$1"
fi

root -b -l << EOF
.x loadlibs.C
//AliAnalysisTriggerScalers ts("$runfilelist","local:///Users/laurent/Alice/OCDBcopy");
AliAnalysisTriggerScalers ts("$runfilelist","raw://");
ts.IntegratedLuminosity("","C0TVX-B-NOPF-ALLNOTRD",18,"",'\t',"nb");  > integrated.lumi.$1.txt

ts.PlotTriggerEvolution("CMSL7-B-NOPF-ALLNOTRD","L0B");
ts.PlotTriggerEvolution("CMSH7-B-NOPF-ALLNOTRD","L0B");
ts.PlotTriggerEvolution("CMUL7-B-NOPF-ALLNOTRD","L0B");

ts.PlotTriggerEvolution("CMSL7-B-NOPF-ALLNOTRD","L0A");
ts.PlotTriggerEvolution("CMSH7-B-NOPF-ALLNOTRD","L0A");
ts.PlotTriggerEvolution("CMUL7-B-NOPF-ALLNOTRD","L0A");

ts.PlotTriggerEvolution("CMSL7-B-NOPF-MUON","L0B");
ts.PlotTriggerEvolution("CMSH7-B-NOPF-MUON","L0B");
ts.PlotTriggerEvolution("CMUL7-B-NOPF-MUON","L0B");

ts.PlotTriggerEvolution("CMSL7-B-NOPF-MUON","L0A");
ts.PlotTriggerEvolution("CMSH7-B-NOPF-MUON","L0A");
ts.PlotTriggerEvolution("CMUL7-B-NOPF-MUON","L0A");

EOF


mv TriggerEvolutionCMSH7-B-NOPF-ALLNOTRD-L0B.png FILL$1_CMSH7-B-NOPF-ALLNOTRD-L0B.png
mv TriggerEvolutionCMSL7-B-NOPF-ALLNOTRD-L0B.png FILL$1_CMSL7-B-NOPF-ALLNOTRD-L0B.png
mv TriggerEvolutionCMUL7-B-NOPF-ALLNOTRD-L0B.png FILL$1_CMUL7-B-NOPF-ALLNOTRD-L0B.png

mv TriggerEvolutionCMSH7-B-NOPF-ALLNOTRD-L0A.png FILL$1_CMSH7-B-NOPF-ALLNOTRD-L0A.png
mv TriggerEvolutionCMSL7-B-NOPF-ALLNOTRD-L0A.png FILL$1_CMSL7-B-NOPF-ALLNOTRD-L0A.png
mv TriggerEvolutionCMUL7-B-NOPF-ALLNOTRD-L0A.png FILL$1_CMUL7-B-NOPF-ALLNOTRD-L0A.png

mv TriggerEvolutionCMSH7-B-NOPF-MUON-L0B.png FILL$1_CMSH7-B-NOPF-MUON-L0B.png
mv TriggerEvolutionCMSL7-B-NOPF-MUON-L0B.png FILL$1_CMSL7-B-NOPF-MUON-L0B.png
mv TriggerEvolutionCMUL7-B-NOPF-MUON-L0B.png FILL$1_CMUL7-B-NOPF-MUON-L0B.png

mv TriggerEvolutionCMSH7-B-NOPF-MUON-L0A.png FILL$1_CMSH7-B-NOPF-MUON-L0A.png
mv TriggerEvolutionCMSL7-B-NOPF-MUON-L0A.png FILL$1_CMSL7-B-NOPF-MUON-L0A.png
mv TriggerEvolutionCMUL7-B-NOPF-MUON-L0A.png FILL$1_CMUL7-B-NOPF-MUON-L0A.png

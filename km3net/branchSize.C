#include "TFile.h"
#include "TTree.h"
#include "TList.h"
#include "TBranch.h"
#include "TObjArray.h"

// root [0] .x branchSize.C("KM3NeT_00000075_00010263_toashort.root")
// TotalBytes   81030567 Bytes AfterCompression   18513281 Bytes Nentries 1093420
// ###################################
//              TObject TotalBytes   15334669 (  19 %) AfterCompression    2496792 (  13 %)
//                DETID TotalBytes   21903287 (  27 %) AfterCompression    2218102 (  12 %)
//                  RUN TotalBytes    4378839 (   5 %) AfterCompression      28953 (   0 %)
//            RUNNUMBER TotalBytes    4379241 (   5 %) AfterCompression      29356 (   0 %)
//         UNIXTIMEBASE TotalBytes    8758884 (  11 %) AfterCompression    3362330 (  18 %)
//                DOMID TotalBytes    4378973 (   5 %) AfterCompression     452990 (   2 %)
//            EMITTERID TotalBytes    4379241 (   5 %) AfterCompression     339478 (   2 %)
//                TOA_S TotalBytes    8757946 (  11 %) AfterCompression    6915443 (  37 %)
//        QUALITYFACTOR TotalBytes    4379509 (   5 %) AfterCompression    2642281 (  14 %)
// QUALITYNORMALISATION TotalBytes    4379978 (   5 %) AfterCompression      27556 (   0 %)

void branchSize(const char* file, const char* treename="DB_TOASHORT")
{
  TFile* f1 = TFile::Open(file);

  if (!f1) return;
  
  TTree *tree = (TTree*)f1->Get(treename);

  if (!tree) return;
  
  TBranchElement* tbe = static_cast<TBranchElement*>(tree->GetListOfBranches()->First());

  auto tb = tbe->GetListOfBranches();

  if (!tb) return;

  ULong64_t totBytes = tree->GetTotBytes();
  ULong64_t zipBytes = tree->GetZipBytes();

  printf("TotalBytes %10lld Bytes AfterCompression %10lld Bytes Nentries %lld\n",
         totBytes,zipBytes,tree->GetEntries());
  printf("###################################\n");
  TBranch* b;
  TIter next(tb);
  while ( ( b = static_cast<TBranch*>(next()) ) )
  { 
    printf("%20s ",b->GetName());
    printf("TotalBytes %10d (%4.0f %%) AfterCompression %10d (%4.0f %%)\n",
           (Int_t)b->GetTotBytes("*"),
           (totBytes>0) ? b->GetTotBytes("*")*100.0/totBytes : 0,
           (Int_t)b->GetZipBytes("*"),
           (zipBytes>0) ? b->GetZipBytes("*")*100.0/zipBytes : 0
           );
  }

  delete f1;
}

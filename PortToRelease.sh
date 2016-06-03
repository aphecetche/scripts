cd $ALICE_ROOT

echo "svn merge -c 34140 https://alisoft.cern.ch/AliRoot/trunk/MUON MUON"
svn merge -c 34140 https://alisoft.cern.ch/AliRoot/trunk/MUON MUON

echo "svn merge -c 35711 https://alisoft.cern.ch/AliRoot/trunk"
svn merge -c 35711 https://alisoft.cern.ch/AliRoot/trunk

for rev in 35725 35732 35733 35743 35760 35792 
do
  echo "svn merge -c $rev https://alisoft.cern.ch/AliRoot/trunk/MUON MUON"
  svn merge -c $rev https://alisoft.cern.ch/AliRoot/trunk/MUON MUON
done

echo "svn merge -c 35824 https://alisoft.cern.ch/AliRoot/trunk"
svn merge -c 35824 https://alisoft.cern.ch/AliRoot/trunk

for rev in 35828 35829 35841 35862
do
  echo "svn merge -c $rev https://alisoft.cern.ch/AliRoot/trunk/MUON MUON"
  svn merge -c $rev https://alisoft.cern.ch/AliRoot/trunk/MUON MUON
done


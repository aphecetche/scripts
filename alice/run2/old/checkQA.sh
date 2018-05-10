
topdir=$HOME/Alice/Data/Reco

#for dir in 119041 119061/Dev.023.10 119061/Dev.034.310 119037 119059
#for dir in 117116 119059 
for dir in 119037/Dev.023.10 119037/Dev.034.400
do
  cd $topdir/$dir
  $HOME/Scripts/runreco.sh
  open QAImageRec*.ps
done

# script to AODs from the grid
# for a given run

topdir="/alice/data/2010"

griddir="$topdir/$1" # starting at period, e.g. LHC10f/000134905/ESDs/pass1/AOD014

outdir=$2

mkdir -p $2/$1

dir=$(pwd)

for chunk in $(alien_ls $griddir); do
  cd $dir
  mkdir -p $2/$1/$chunk
  odir="$2/$1/$chunk"
  cd $odir
  cmd="alien_cp alien://$griddir/$chunk/root_archive.zip ."
  $cmd
  unzip root_archive.zip  
  rm root_archive.zip
  exit
done



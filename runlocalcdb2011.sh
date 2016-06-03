if [ $# -lt 1 ]; then
  echo "Need an argument !"
  exit
fi

if [ ! -f "$1" ]; then
  echo "file $1 does not exist ! Assuming a run number"
root -b -l << EOF
.x loadlibs.C
.L $HOME/Code/OCDB/MakeLocalCDB.C+
MakeLocalCDB($1,"alien://folder=/alice/data/2011/OCDB","local://$HOME/Alice/OCDBcopy2011");
.q
EOF
  exit
fi

root -b -l << EOF
.x loadlibs.C
.L $HOME/Code/OCDB/MakeLocalCDB.C+
MakeLocalCDB("$1","alien://folder=/alice/data/2011/OCDB","local://$HOME/Alice/OCDBcopy2011");
.q
EOF

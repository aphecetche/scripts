if [ $# -lt 1 ]; then
  echo "Need an argument !"
  exit
fi

if [ ! -f "$1" ]; then
  echo "file $1 does not exist ! Assuming a run number"
root -l << EOF
.x loadlibs.C
.L $HOME/Code/OCDB/MakeLocalCDB.C+
MakeLocalCDB($1,"alien://folder=/alice/data/2010/OCDB","local://$HOME/Alice/OCDBcopy2010");
.q
EOF
  exit
fi

root -l << EOF
.x loadlibs.C
.L $HOME/Code/OCDB/MakeLocalCDB.C+
MakeLocalCDB("$1","alien://folder=/alice/data/2010/OCDB","local://$HOME/Alice/OCDBcopy2010");
.q
EOF

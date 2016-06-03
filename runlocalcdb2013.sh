if [ $# -lt 1 ]; then
  echo "Need an argument !"
  exit
fi

if [ ! -f "$1" ]; then
  echo "file $1 does not exist ! Assuming a run number"
aliroot -b -l << EOF
.x loadlibs.C
.L $HOME/Code/OCDB/MakeLocalCDB.C+
MakeLocalCDB($1);
.q
EOF
  exit
fi

aliroot -b -l << EOF
.x loadlibs.C
.L $HOME/Code/OCDB/MakeLocalCDB.C+
MakeLocalCDB("$1");
.q
EOF

if [ $# -lt 1 ]; then
  echo "Need an argument !"
  exit
fi

fromURI="alien://folder=/alice/data/2012/OCDB"
toURI="local://$HOME/Alice/OCDBcopy2012"

if [ ! -f "$1" ]; then
  echo "file $1 does not exist ! Assuming a run number"
aliroot -b -l << EOF
.x loadlibs.C
.L $HOME/Code/OCDB/MakeLocalCDB.C+
MakeLocalCDB($1,"$fromURI","$toURI");
.q
EOF
  exit
fi

aliroot -b -l << EOF
.x loadlibs.C
.L $HOME/Code/OCDB/MakeLocalCDB.C+
MakeLocalCDB("$1","$fromURI","$toURI");
.q
EOF

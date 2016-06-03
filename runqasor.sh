#!/bin/sh

root << EOF
.L QASOR.cxx+
QASOR(4); > toto.4
QASOR(8); > toto.8
QASOR(16); > toto.16
.L ObjectStats.C+
ObjectStats("toto.4","toto.8");
ObjectStats("toto.8","toto.16");
EOF


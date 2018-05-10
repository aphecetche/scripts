# Run Alice Rule Checker on a single class (given in argumen, w/o extension)
#
# Assuming you get an alias, such as :
#
# alias irst='source $HOME/Scripts/alice-irst.sh'
#
# you call this script for a given class MyClass as:
#
# irst MyClass

gcc -E -I$ROOTSYS/include -I$ALICE_ROOT/include -I$ALICE_ROOT/MUON -I$ALICE_ROOT/MUON/mapping $1.cxx > $1.i 
${IRST_INSTALLDIR}/patch/patch4alice.prl $1.i
java rules.ALICE.ALICERuleChecker $1.i
rm -f $1.i $1.ii
# Run doxygen on a single Alice MUON class given in argument
#
# Assuming you get an alias, such as :
#
# alias dox='source $HOME/Scripts/alice-doxygen.sh'
#
# you call this script for a given class MyClass as:
#
# dox MyClass

EXE=/Applications/Doxygen.app/Contents/Resources/doxygen

OFILE=doxygen.config.single

$EXE -g $OFILE
echo "INPUT = ." >> $OFILE
echo "FILE_PATTERNS = $1.*" >> $OFILE
echo "WARNINGS = YES" >> $OFILE
echo "WARN_IF_UNDOCUMENTED   = YES" >> $OFILE

$EXE $OFILE

rm -f $OFILE

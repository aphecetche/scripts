# Run Alice Rule Checker on a single class (given in argumen, w/o extension)
#
# Assuming you get an alias, such as :
#
# alias irst='source $HOME/Scripts/alice-irst.sh'
#
# you call this script for a given class MyClass as:
#
# irst MyClass

src2srcml --language=C++ $1.cxx -o $1.cxx.xml
src2srcml --language=C++ $1.h -o $1.h.xml
java -jar $ALICE_ROOT/RuleChecker/FactExtractor.jar ./ ./
java -jar $ALICE_ROOT/RuleChecker/NewRuleChecker.jar $1.cxx.xml $1.h.xml factFile.xml $ALICE_ROOT/RuleChecker/CodingConventions.xml

#rm -f $1.cxx.xml $1.h.xml factFile.xml


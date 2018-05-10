#!/bin/sh

grep -v E-T $1 | grep -v TAlienFile | grep -v TBuffer | grep -v TClass::TClass | grep -v ACLiC | grep -v "^=>" | grep -v CDBManager | grep -v FromCache




#!/bin/sh

grep -i warning $1 | grep -v "/root/include" | \
 grep -v "deprecated conversion" | grep -v "/Alice/Root"


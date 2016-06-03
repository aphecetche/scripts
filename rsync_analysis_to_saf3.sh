#!/bin/sh

rsync --rsh="gsissh -p 1975" -avu --chmod=g+rw -p /Users/laurent/analysis/2015/LHC15h nansafmaster3.in2p3.fr:analysis/2015


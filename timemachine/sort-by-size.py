#!/usr/bin/python

""" Script to sort the output of `tmutil compare -s` by size
"""

import sys

def report_by_size(filename):
    with open(filename) as file:
        for line in file:
            print(line[3:10])

report_by_size(sys.argv[1])

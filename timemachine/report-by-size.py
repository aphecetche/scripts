#!/usr/bin/env python

""" Script to sort the output of `tmutil compare -s` by size
"""

import sys
from parse import *

def human_size(num,suffix='B'):
    for unit in ['','Ki','Mi','Gi','Ti','Pi','Ei','Zi']:
        if abs(num) < 1024.0:
            return "%3.1f %s%s" % (num, unit, suffix)
        num /= 1024.0
    return "%.1f %s%s" % (num, 'Yi', suffix)

def size_in_bytes(r):
    units = {"B": 1, "K": 2**10, "M": 2**20, "G": 2**30, "T": 2**40}
    if r is None:
        return 0
    return r[0]*units[r[1]]

def report_by_size(filename):
    lines={}
    with open(filename) as file:
        for line in file:
            size = line[2:10].strip()
            r = parse("{:f}{}",size)
            if r is None:
                r = parse("{:d}{}",size)
            s = size_in_bytes(r)
            lines[s]=line[31:]
    for k in sorted(lines):
        print("{:>10s}".format(human_size(k)),lines[k].rstrip())

report_by_size(sys.argv[1])

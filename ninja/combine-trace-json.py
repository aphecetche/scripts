#!/usr/bin/env python3
 
"""Merge results from all cpu cores into one
 
Run with (e.g.): python combine-trace-json.py trace.json

output is combined.json"""
 
import json
import sys
 
if __name__ == '__main__':
    combined_data = []
    with open(sys.argv[1],'r') as f:
        for event in json.load(f):
            # merge all cpu traces into one
            event['tid']=0
            combined_data.append(event)
    with open('combined.json', 'w') as f:
        json.dump(sorted(combined_data, key=lambda k: k['ts']), f)

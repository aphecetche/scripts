#!/usr/bin/env python

import pandas as pd
import numpy as np
import argparse
import os
import openpyxl

def is_valid_file(parser, arg):
    if not os.path.isfile(arg):
        parser.error("The file %s does not exist!" % arg)
    else:
        return pd.read_excel(arg,names=["cru","fiber","crate","solar","slat","length","de","ds1","ds2","ds3","ds4","ds5"],na_filter=True)

parser = argparse.ArgumentParser()
parser.add_argument('--infile','-i', dest="inputfile", required=True,
                    help="input excel filename", metavar="FILE",
                    type=lambda x: is_valid_file(parser,x))
parser.add_argument('--outfile','-o', dest="outputfile",
                    help="output excel filename", metavar="FILE")

args = parser.parse_args()
df = args.inputfile

# remove lines where only the "CRATE #" column is
# different from NaN
df = df[df.count(1)>1] 

# row_list is a dictionary where we'll put only the information we need
# from the input DataFrame (df)
row_list = []

for row in df.itertuples():
    crate = int(row.crate.strip('C '))
    solar_pos = int(row.solar.split('-')[2].strip('S '))-1
    group_id = int(row.solar.split('-')[3].strip('J '))-1
    solar_id = crate*8 + solar_pos
    de_id = int(row.de.strip("DE "))
    d = dict({'solar_id': solar_id,
                          'group_id': group_id,
                          'de_id': de_id,
                          'ds_id_0': int(row.ds1),
                          'ds_id_1': int(row.ds2)
                         })
    d['ds_id_2'] = int(row.ds3) if pd.notna(row.ds3) else 0
    d['ds_id_3'] = int(row.ds4) if pd.notna(row.ds4) else 0
    d['ds_id_4'] = int(row.ds5) if pd.notna(row.ds5) else 0

    row_list.append(d)
    
# create the output DataFrame (sf) from the row_list dict
sf = pd.DataFrame(row_list,dtype=np.int16)

# output to screen
print(sf.to_string())

# save to an excel file if so desired
if args.outputfile:
    sf.to_excel(args.outputfile)


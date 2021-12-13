#!/usr/bin/env python3

''' Remove rows that represent individuals in a "toremove" file
    infile should have a column labeled "indv"
    toremove_file should have one sample name per line
    usage: ./rm-indvs.py sample_file.tsv toremove_file.txt

    cyp I-2021
'''

import sys
import pandas as pd

infile = sys.argv[1]
toremove_file = sys.argv[2]

with open(toremove_file,'r') as f:
  toremove = f.read().splitlines() 

df = pd.read_csv(infile,sep='\t')
new_df = df[~df.indv.isin(toremove)]

new_df.to_csv(infile+'_w-indvs-rm.tsv',sep='\t',index=False)

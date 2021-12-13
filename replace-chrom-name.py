#!/usr/bin/env python

''' Renames the chromosome names in a file using a 2-column name-to-name
    map (as long as the original name column is labeled 'group' and the
    replacement name column is labeled 'chr'). Writes a new file with the
    extension "_chr-renamed.csv". 

    usage: ./replace-chrom-name.py chrom-name-number.txt infile.csv

    cyp 06/2020
'''

import sys
import csv
import pandas as pd

name2num = pd.read_csv(sys.argv[1], delimiter='\t')
#print(name2num.columns.tolist())
inf = pd.read_csv(sys.argv[2])
name2num_dict = dict(zip(list(name2num['chr']), list(name2num['group'])))
inf['chr'] = inf['chr'].map(name2num_dict)

inf.to_csv(sys.argv[2]+'_chr-renamed.csv',index=False)

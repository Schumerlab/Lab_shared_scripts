#!/usr/bin/env python2
''' Purpose: thin AIMs file by read_length (to minimize/eliminate
             read overlap when mapping to transcriptome/genome)
    Usage:   ./thin_AIMs.py AIMs_file.txt read_length 

    cyp 06/2020
'''


import sys
import pandas as pd

aims_file = sys.argv[1]
read_length = int(sys.argv[2])

# read in and sort AIMs 
aims = pd.read_csv(aims_file,sep='\t', header=None)
aims.columns = ['tx','pos','ref','alt']
aims = aims.sort_values(by=['tx','pos'])
aims = aims.reset_index(drop=True)

todrop= []
first = 1; last = None
for row in aims.itertuples():
  if first: first=0; last=row; continue
  elif row.tx == last.tx:
    diff = int(row.pos) - int(last.pos)
    if diff <= read_length:
      todrop.append(row.Index)
      last = last # keep last the same, so you can compare again
    else: last = row
  else: last = row

print("Num AIMs before thinning: " + str(len(aims)))
# drop all rows corresponding with todrop indices
aims.drop(aims.index[todrop], inplace=True)
print("Num AIMs after thinning: " + str(len(aims)))
# output new AIMs
outfile = aims_file + "_thinned-by-" + str(read_length) + "bp" 
aims.to_csv(outfile,sep='\t',index=False,header=False)

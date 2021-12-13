#!/usr/bin/env python3
''' One-hot encode one column of data file 
    infile should have at least one column to encode, tab-sep 
    col_name is the name of the column to encode
    usage: ./onehot-encode_column.py infile.tsv col_name 

    cyp I-2021
'''

import sys
import pandas as pd

infile = sys.argv[1]
col = sys.argv[2]

df = pd.read_csv(infile,sep='\t')
onehot = pd.get_dummies(df[col])
new_df = df.join(onehot)

new_df.to_csv(infile+'_w-'+col+'-onehot.tsv',sep='\t',index=False)

#!/usr/bin/env python3

''' Identify regions that overlap in two bed files, with different ranges [start,end]
    Used for HOMER output, converted into bed files (no header info, ID switched to 4th row)

    usage: ./atacseq-homer-range-overlap.py ATAC-bir1.bed ATAC-bir2.bed

    cyp 10/2/2020
'''
import sys
import numpy as np
import pandas as pd

bed1 = sys.argv[1]
bed2 = sys.argv[2]

# name output file, using file names
of_name = bed1.split('_')[0] + '_' + bed2.split('_')[0] + '-peak-overlap.tsv'

# note: column names need to be different to perform join
df1 = pd.read_table(sys.argv[1], header=None)
# capture unique id at position 3
df1 = df1.iloc[:,0:4]
df1.columns = ['chr1','start1','end1','peakid1']
#df1.columns = ['chr','start','end','strand','Normalized Tag Count',\
#               'focus ratio','findPeaks Score','Fold Change vs Local',\
#               'p-value vs Local','Clonal Fold Change']
df2 = pd.read_table(sys.argv[2], header=None)
df2 = df2.iloc[:,0:4]
df2.columns = ['chr2','start2','end2','peakid2']

df1['key'] = 0
df2['key'] = 0

joined_df = pd.merge(df1, df2).drop(columns=['key'])

interval1 = pd.IntervalIndex.from_arrays(joined_df.start1, joined_df.end1, closed='both')
interval2 = pd.IntervalIndex.from_arrays(joined_df.start2, joined_df.end2, closed='both')

# filter for peaks that overlap between intervals
output = joined_df.loc[[a.overlaps(b) for a, b in zip(interval1,interval2) ]]

# output overlap
output.to_csv(of_name,sep='\t',index=False)

#joined_df[((joined_df["start1"] < joined_df["start2"]) & (joined_df["start2"] < joined_df["end1"])) | ((joined_df["start2"] < joined_df["start1"]) & (joined_df["start1"] < joined_df["end2"])) | ((joined_df["start2"] < joined_df["end1"]) & (joined_df["end1"] < joined_df["end2"])) | ((joined_df["start1"] < joined_df["end2"]) & (joined_df["end1"]))]

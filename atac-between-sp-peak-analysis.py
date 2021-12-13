#!/usr/bin/env python3

''' first run atac-homer-range-overlap.py to get overlap in peaks
    for replicates within species

    then run the following to get between species shared peaks

    usage: atac-between-sp-peak-analysis.py ATAC-birch1_ATAC-birch2-peak-overlap_sword-qtl.tsv ATAC-malinche1_ATAC-malinche2-peak-overlap_sword-qtl.tsv  
    cyp 10/04/2020
'''

import sys
import pandas as pd

of_name = 'sp1_sp2_range-peak-overlap.tsv'

sp1_pks = pd.read_table(sys.argv[1])
sp2_pks = pd.read_table(sys.argv[2])
# sp2_pks = pd.read_table("ATAC-malinche1_ATAC-malinche2-peak-overlap_sword-qtl.tsv")
# sp1_pks = pd.read_table("ATAC-birch1_ATAC-birch2-peak-overlap_sword-qtl.tsv")

sp1 = sp1_pks[['peakid1','peakid2']].copy()

# get full range of peaks (union of 2 replicates)
sp1['range_start'] = sp1_pks[['start1','start2']].min(axis=1)
sp1['range_end'] = sp1_pks[['end1','end2']].max(axis=1)
# also identify the intersection of the ranges (i.e. the 2x replicate
# supported peak)
sp1['peak_start'] = sp1_pks[['start1','start2']].max(axis=1)
sp1['peak_end'] = sp1_pks[['end1','end2']].min(axis=1)

sp2 = sp2_pks[['peakid1','peakid2']].copy()
sp2['range_start'] = sp2_pks[['start1','start2']].min(axis=1)
sp2['range_end'] = sp2_pks[['end1','end2']].max(axis=1)
sp2['peak_start'] = sp2_pks[['start1','start2']].max(axis=1)
sp2['peak_end'] = sp2_pks[['end1','end2']].min(axis=1)

# output those dataframes
sp1.to_csv('sp1_combined-peak-info.tsv',sep='\t',index=False)
sp2.to_csv('sp2_combined-peak-info.tsv',sep='\t',index=False)

# make headers unique so that you can merge dataframes
for i,v in enumerate(sp1.columns.values): sp1.columns.values[i] = v + '_1'
for i,v in enumerate(sp2.columns.values): sp2.columns.values[i] = v + '_2'

sp1['key'] = 0
sp2['key'] = 0

joined_df = pd.merge(sp1, sp2).drop(columns=['key'])

interval1 = pd.IntervalIndex.from_arrays(joined_df.range_start_1, joined_df.range_end_1, closed='both')
interval2 = pd.IntervalIndex.from_arrays(joined_df.range_start_2, joined_df.range_end_2, closed='both')

# filter for peaks that overlap between intervals
output = joined_df.loc[[a.overlaps(b) for a, b in zip(interval1,interval2) ]]

# output overlap
output.to_csv(of_name,sep='\t',index=False)

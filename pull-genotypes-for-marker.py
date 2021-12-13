#!/usr/bin/env python3

''' Pulls the column of genotypes for a specified marker_name from a big
    genotypes file

    usage: ./pull-genotypes-for-marker.py genotypes_file.tsv marker_name
    
    cyp II/2021
'''

import sys
import pandas as pd

data = pd.read_csv(sys.argv[1],sep='\t')
marker = sys.argv[2]
id_marker = data[['id',marker]]
id_marker = id_marker.fillna('NA')
id_marker.to_csv(marker+'_genotypes.tsv',sep='\t',index=False)

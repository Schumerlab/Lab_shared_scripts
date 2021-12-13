#!/usr/bin/env python

'''   Takes a file with a 'Gene' (Xmac Ensembl ID) and a gff 
      file, and outputs a new file with all the contents of 
      the gene file, plus a column with the corresponding 
      annotation per gene
      usage: ./grab-gff-annots.py annots.gff file-w-genes.csv

      cyp 06/2020
'''
import sys
import pandas as pd

GFF         = sys.argv[1]
GENEID_FILE   = sys.argv[2]
gene_annot_dict = {}

with open(GFF, 'r') as gff:
    for line in gff:
        items   = line.split(';') 
        gene_id = items[0].split(' ')[1]
        annot   = items[4].split(' ')[2] 
        gene_id = gene_id.replace("\"","")
        annot = annot.replace("\"","")
        if annot == "ensembl":
            annot = "NA" 
#        print(gene_id + " " + annot)
        gene_annot_dict[gene_id] = annot

gene2annot = pd.DataFrame.from_dict(list(gene_annot_dict.items()))
gene2annot.columns = ["gene","annot"]

csv = pd.read_csv(GENEID_FILE)

merged = csv.merge(gene2annot, left_on='Gene', right_on='gene', how='left')
#merged = csv.merge(gene2annot, left_on='Gene_ID', right_on='gene', how='left')
out = merged.drop('gene', axis=1)


OUTFILE = GENEID_FILE+"_with-annots.csv"
out.to_csv(OUTFILE,index=False)

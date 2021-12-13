#!/usr/bin/env python

'''
  TL;DR     Splits rqtl infile produced by (AncestryHMM --> rqtl input)
            by chromosome (outputs split files under chromosome names)
  warning:  make sure chrom files don't already exist
            delete them if they do, this script will append to them
  usage:    ./split_rqtl-infile_by_chrom.py rqtl-infile.rqtl.csv num_phenotypes
              num_phenotypes: number of columns with phenotype/covariate data
  cyp III-2020
'''

import sys
import csv

infile = sys.argv[1]
num_phenos = int(sys.argv[2])
idx_dict = {}
with open(infile,'r') as data:
  reader = csv.reader(data)
  first = True
  for row in reader:
    if first: 
      header = row
      first = False
      continue
    for idx, val in enumerate(row):
      if idx <= num_phenos-1: continue
      if val not in idx_dict: idx_dict[val] = []
      idx_dict[val].append(idx)
    break

with open(infile,'r') as data:
  reader = csv.reader(data)
  for row in reader:
    for fout in idx_dict:
      f = open(fout, "a")
      start = idx_dict[fout][0]
      stop  = idx_dict[fout][len(idx_dict[fout])-1]
      print(fout)
      towrite = row[0:num_phenos] + row[start:(stop+1)]
      str_towrite = ','.join(towrite) + '\n'
      f.write(str_towrite)
      f.close()

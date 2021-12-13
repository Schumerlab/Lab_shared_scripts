#!/usr/bin/env python

'''
  TL;DR     Splits tsv file, produced by AncestryHMM, by chromosome 
  warning:  make sure chrom files don't already exist
            delete them if they do, this script will append to them
  usage:    ./split_ancestryprob-file_by_chrom.py ancestry-prob-p1.tsv 

  cyp III-2020
'''

import sys
import csv

infile = sys.argv[1]
idx_dict = {}

# read first line (header) to grab chrom indices
with open(infile,'r') as data:
  reader = csv.reader(data,delimiter="\t")
  first = True
  for row in reader:
    for idx, val in enumerate(row):
      if idx == 0: continue
      chrom = val.split(':')[0]
      if chrom not in idx_dict: idx_dict[chrom] = []
      idx_dict[chrom].append(idx)
    break

# fill out each chromosome's file
with open(infile,'r') as data:
  reader = csv.reader(data,delimiter="\t")
  for row in reader:
    print(row[0])
    for fout in idx_dict:
      chromfile = infile.split('_')[0] + '_' + fout + '.tsv'
      f = open(chromfile, "a")
      start = idx_dict[fout][0]
      stop  = idx_dict[fout][len(idx_dict[fout])-1]
      towrite = row[0:1] + row[start:(stop+1)]
      str_towrite = '\t'.join(towrite) + '\n'
      f.write(str_towrite)
      f.close()

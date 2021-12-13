#!/usr/bin/env python3

''' Pulls out the coordinates for a list of ids (can be gene or
    transcript ids) and creates bed file. If the stop codon is
    less than the start codon coordinate, the smallest will be
    listed first (per bedtools file guidelines).

    Can use either Xmac or Xbirch gtf

    First run bedtools intersect to subset gtf by the region of
    interest, if applicable

    args:  annotation.gtf = file containing annotations, must have
                            'start_codon' and 'stop_codon' elements
           id_list.txt    = file with one column, list of ids
           id_type        = specify id type, either 'genes' or 'transcripts'

    usage: ./extract_gene-coords_from_gtf.py annotation.gtf
           id_list.txt id_type 
    
    cyp II/2021
'''
import sys 
import re

## process arguments
if len(sys.argv) < 4: print('Provide a gtf file, id_list file, and id type.')
gtf_file = sys.argv[1]
with open(sys.argv[2]) as idf: id_list = idf.read().splitlines()
id_type = sys.argv[3]

if id_type == "genes": id_pattern = 'gene_id '
elif id_type == "transcripts": id_pattern = 'transcript_id '
else: print("Specify which id type you're using: genes OR transcripts")

outfile = sys.argv[2] + '.bed'

## create dictionaries
chrom_dict={}; start_dict={}; stop_dict={}; annot_dict={}

with open(gtf_file, 'r') as f:
  for line in f:
    fields = line.strip().split('\t')

    # grab the id
    line_id = fields[8].split(id_pattern)[1].split('"')[1]

    # if the current id matches one in the list, proceed
    # otherwise jump to next line
    if line_id in id_list: target_id = line_id
    else: continue 

    # if line has both id and "start_codon", collect
    start_regex = 'start_codon'
    # if line has both id and "stop_codon", collect
    stop_regex = 'stop_codon'

    # find the start and stop coordinates
    # and add to respective dictionaries
    if re.search(start_regex, line): 
      start_coord = (fields[3],fields[4]) 
      start_dict[target_id] = start_coord
      chrom_dict[target_id] = fields[0]
      if len(fields) > 9: annot_dict[target_id] = ' '.join([fields[8],fields[9],fields[10]])
      else: annot_dict[target_id] = ' '.join([fields[8]])
    elif re.search(stop_regex, line): 
      stop_coord = (fields[3],fields[4])
      stop_dict[target_id] = stop_coord

# write to bed file
with open(outfile,'w') as of:
  for i in id_list:
    missing = False
    start   = '0' 
    stop    = '0'
    # in case there's missing data
    if not i in  start_dict.keys() and not i in stop_dict.keys():
      print('{} not included, both codons missing'.format(i))
      continue
    elif not i in start_dict.keys(): 
      missing = "start_codon"
      chrom_dict[i] = 'NA'
      annot_dict[i] = i
      start   = 'NA' 
      stop    = stop_dict[i][1]
    elif not i in stop_dict.keys():
      missing = "stop_codon"
      stop    = 'NA'
      start   = start_dict[i][0]

    if missing: print('{} done, has missing value(s): {}'.format(i,missing))
    else: print('{} done'.format(i))
    
    direction = 'NA'
    # determine direction of sequence
    if start != 'NA' and stop != 'NA':
      # if fwd, start coordinate listed as start
      # if rev, start coordinate listed as stop
      if int(start_dict[i][0])<int(stop_dict[i][0]): 
        direction = 'fwd'
        start     = start_dict[i][0]
        stop      = stop_dict[i][1]
      else: 
        direction = 'rev'
        start     = stop_dict[i][0]
        stop      = start_dict[i][1]


    out_line = '\t'.join([chrom_dict[i],start,stop, \
               direction,annot_dict[i]])
    of.write(out_line+'\n')

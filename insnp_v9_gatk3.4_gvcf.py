#!/usr/bin/env python
#AUTHOR: Alisa Sedghifar, written 20151210 to deal with chromosome non-identifiability issues of original insnp filtering scripts
#NB!!!! As of 20151210 I have not built in any error/usage messages, or tested this on anything. Use at your own peril.
##Not all quality indicators present in some lines for variant sites. When this happens, parameters are set to 0 or 100
##This script relies on positions presented in order along the chromosome in the input .vcf file
##USERS: If you've un/successfully used this and/or have tested for accuracy, please leave a line here. This way I can contact you if I find an error, or have questions about what may have gone wrong.
##
#Example usage: ./alisa_insnp_script.py SD1-9-allsites.vcf SD1-9-allsites.insnp 20 10 40 2 60 4 -12.5 -8.0 5
##Added an existence check for the key in the indel dictionary - Clair, Patrick, Andrew
##Added genotype check for haploid -20160817, Clair, Andrew
## May 2, 2016: For deletions relative to the reference strain, the masking was not working -- it would mask correctly preceeding the 
## 		indel, but not afterward. I changed the appropriate lines: there are four changes, the old line is commented out and marked
##		with my initials, AMT. -Andrew

## May 11, 2016: A bunch of edits accounting for the RGQ value. RGQ appears to call 0 even when likelihood is high... In the end, we decided to just treat it as a reliable variable, since the alternative would be to mask it anyway. This fix masks an extra ~3% of sites, and recovers ~1% of sites

import sys
import os
import numpy
from bisect import bisect

infile = sys.argv[1]
outfile = sys.argv[2]

gq_cutoff,dpcutoff,mq_cutoff,qd_cutoff,fs_cutoff,sor_cutoff,mqrs_cutoff,readpos_cutoff,indel_window = map(float,sys.argv[3:])

needs_greater_than = numpy.array([gq_cutoff,dpcutoff,mq_cutoff,qd_cutoff,mqrs_cutoff,readpos_cutoff])
needs_less_than = numpy.array([fs_cutoff,sor_cutoff])

indel_halfsize=int(indel_window)

filename,ext = os.path.splitext(infile)

indel_dict = {}


def split2(x,sep="="):
	res = x.split(sep)
	if len(res) == 1:
		return (res[0],None)
	return tuple(res)
 
IUPAC_dict = {"AG":"R","CT":"Y","CG":"S","AT":"W","GT":"K","AC":"M"}
	

#make indel dictionary:

with open(infile,'r') as f1:
	for line in f1:
		if line.startswith("#"):
			continue
		cols = line.strip().split()
		chr = cols[0]
		pos = int(cols[1])
		if len(cols[4])>1 or len(cols[3])>1:
			indel_length = len(cols[3])
			#indel_leftsize = max(indel_length,indel_halfsize)+1  -- AMT
			indel_leftsize = indel_length
			if chr not in indel_dict:
				print chr
				#indel_dict[chr] = [pos-indel_halfsize,pos+indel_leftsize]  -- AMT
				indel_dict[chr] = [pos-indel_halfsize,pos+indel_leftsize+indel_halfsize]
			else:
				if pos-indel_halfsize>indel_dict[chr][-1]: #option 3
					#indel_dict[chr]+=[pos-indel_halfsize,pos+indel_leftsize]  -- AMT
					indel_dict[chr]+=[pos-indel_halfsize,pos+indel_leftsize+indel_halfsize]
				else:
					#indel_dict[chr][-1] = max(pos+indel_leftsize,indel_dict[chr][-1])  -- AMT
					indel_dict[chr][-1] = max(pos+indel_leftsize+indel_halfsize,indel_dict[chr][-1])

print "dict made!"

#For interactive debugging, uncomment this:
#raw_input()

#variantout = open(filename+".insnp_test2",'w')
variantout = open(outfile,'w')

with open(infile,'r') as f1:
	for line in f1:
		USE_RGQ=False
		if line.startswith("#"):
			continue
		cols = line.strip().split()
		chr = cols[0]	
		pos = int(cols[1]) 
		info = cols[7]
		info_dict = dict([split2(chunk) for chunk in info.split(";")])
		qualLAB_split = cols[8].split(":")
		qual_split = cols[9].split(":")
		qual_dict = dict(zip(qualLAB_split,qual_split))
		
		if "GQ" not in qual_dict:
			qual_dict["GQ"]=0
			USE_RGQ=True 

		if "QD" not in info_dict:
			info_dict["QD"] = 0
		
		if "MQRankSum" not in info_dict:
			info_dict["MQRankSum"] = 0
		
		if "ReadPosRankSum" not in info_dict:
			info_dict["ReadPosRankSum"] = 0
		
		if "FS" not in info_dict:
			info_dict["FS"] = 100
	
		if "SOR" not in info_dict:
			info_dict["SOR"] = 10

		if "DP" not in qual_dict:
			qual_dict["DP"] = 0	
		
				
		genotype = qual_dict["GT"]
		if len(genotype.split('/')) == 1 or genotype.split("/")[0] == genotype.split("/")[1]:
			homo=1
		else:
			homo=0
		
		alpha_genotype = "".join(sorted(cols[3]+cols[4]))
		
		#Mask if found in an indel
		if (chr in indel_dict) and bisect(indel_dict[chr], pos) % 2:
			variantout.write("\t".join([chr,str(pos),cols[3],"N"])+'\n')

		#If heterozygous, add IUPAC base to .insnp The USE_RGQ qualification was added on 20160511  --AES 
		elif homo==0:
			if USE_RGQ==True: #20160511 --AES
				if float(qual_dict["DP"])<dpcutoff: #changed this to "DP" from "RGQ" 20170130 --AES
					variantout.write("\t".join([chr,str(pos),cols[3],"N"])+'\n')

			else:
				if max(needs_greater_than - numpy.array(map(float,[qual_dict[x] for x in ["GQ","DP"]]+[info_dict[x] for x in ["MQ","QD","MQRankSum","ReadPosRankSum"]])))<=0 and max(numpy.array(map(float,[info_dict["FS"],info_dict["SOR"]]))-needs_less_than)<=0:    
					IUPAC_geno = IUPAC_dict[alpha_genotype]
					variantout.write("\t".join([chr,str(pos),cols[3],IUPAC_geno])+'\n')		
			
				else:
    					variantout.write("\t".join([chr,str(pos),cols[3],"N"])+'\n') #this should happen relatively infrequently...
			
			#In principle, if RGQ is too low, we would like to mask it from the genome. However, RGQ is unreliable and can be low even when there is good evidence for the site being invariant			
			
				


		#If homozygous variant site does not pass thresholds, mask with 'N'. Otherwise, it passes, and gets replaced with the ALT allele  	
		elif cols[4] != ".": 
			if USE_RGQ==True:
				if float(qual_dict["DP"])<dpcutoff: #changed this to "DP" from "RGQ" 20170130 --AES
					variantout.write("\t".join([chr,str(pos),cols[3],"N"])+'\n')

			else:
				if max(needs_greater_than[0:4] - numpy.array(map(float,[qual_dict[x] for x in ["GQ","DP"]]+[info_dict[x] for x in ["MQ","QD"]])))>=0 or max(numpy.array(map(float,[info_dict["FS"],info_dict["SOR"]]))-needs_less_than)>=0:       
					variantout.write("\t".join([chr,str(pos),cols[3],"N"])+'\n')		
				else:
					variantout.write("\t".join([chr,str(pos),cols[3],cols[4]])+'\n')
	

		#If homozygous site has enough support (using only DP and not RGQ)
		else: #Mask invariant site if coverage is too low -- AES 20160511
			if float(qual_dict["DP"])<dpcutoff:
				variantout.write("\t".join([chr,str(pos),cols[3],"N"])+'\n')
		#UNCOMMENT THE FOLLOWING TO ENABLE FILTERING BASED ON RGQ ALONE (not necessarily recommended because of weird haplotypeCaller behavior that assigns 0 RGQ even to high coverage monomorphic sites)	
		#elif qual_dict["RGQ"]<gqcutoff:
		#	variantout.write("\t".join([chr,str(pos),cols[3],"N"])+'\n')

variantout.close()



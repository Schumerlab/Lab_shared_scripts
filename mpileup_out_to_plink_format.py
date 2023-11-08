import argparse
import pandas as pd

parser = argparse.ArgumentParser(description="This script will convert the output of samtools mpileup (variant calls for GWAS) to a format that is suitable for bcftools to generate pseudohaploid calls. The input file should contain the following columns:\nColumn 1 = name of the chromosome/scaffold in your genome assembly of choice\nColumn 2 = pos\nColumn 3 = ref allele,alt allele\nSee https://openwetware.org/wiki/Schumer_lab:_Commonly_used_workflows#Case/Control_GWAS_from_low_coverage_data for more information.",
	formatter_class = argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument("-i", "--infile", help="infile - raw pileup variant calls", required=True)
parser.add_argument("-o", "--outfile", help="outfile - reformatted mpileup variant calls suitable for psuedohaploid analyses ", required=True)

args = parser.parse_args()

outfile_name = args.outfile
infile_name = args.infile

def main():

	#read in tab-delimited data as a dataframe
	df = pd.read_csv(infile_name, delimiter="\t")

	# check that the input files has the correct headers from our GWAS output
	if 'group' in df.columns:
		# add compound ref_alt column
		df["ref_alt"] = df["ref_allele"] + "," + df["alt_allele"]
		# select relevant columns
		df = df[["group","pos","ref_alt"]]
		# write to outfile
		df.to_csv(outfile_name, index=False, sep='\t',header=False)
	else:
		print()
		print("Error: incorrect headers. Does this file have bcftools mpileup headers?")
		print()

if __name__ == '__main__':
	main()